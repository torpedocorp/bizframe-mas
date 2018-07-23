package kr.co.bizframe.mas.application;

import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import kr.co.bizframe.mas.Application;
import kr.co.bizframe.mas.Lifecycle;
import kr.co.bizframe.mas.Serviceable;
import kr.co.bizframe.mas.conf.ApplicationConfig;
import kr.co.bizframe.mas.conf.bind.ApplicationsDef;
import kr.co.bizframe.mas.core.MasEngine;
import kr.co.bizframe.mas.routing.RoutingManager;
import kr.co.bizframe.mas.util.leak.ClassLoaderLeakPreventorFactory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class ApplicationManager implements Lifecycle {

	private static Logger log = LoggerFactory.getLogger(ApplicationManager.class);

	private String baseDir;

	private final String DEFAULT_BASE_DIR = "applications";

	private ApplicationsDef applicationsDef;

	private final String APP_DESC_FILE = "application.xml";

	private MasEngine engine;

	private Status status = Status.SHUTDOWNED;

	private enum Status {

		SHUTDOWNED, SHUTDOWNING, STARTED, STARTING, FAILED

	}

	/*
	 *  ApplicationDef 순서 리스트 (기동과 종료시 순서 지정)
	 *
	 */
	private List<ApplicationDef> applicationDefs = new ArrayList<ApplicationDef>();

	/*
	 * String : applicationId
	 * ManagedApplication : application 인스턴스
	 *
	 */
	private Map<String, ManagedApplication> applications = new LinkedHashMap<String, ManagedApplication>();


	public ApplicationManager(String homeDir, ApplicationsDef appsDef, MasEngine engine) {

		this.engine = engine;

		if (appsDef == null) {
			appsDef = new ApplicationsDef();
		}

		String baseDir = appsDef.getBaseDir();

		if (baseDir == null) {
			this.baseDir = homeDir + "/" + DEFAULT_BASE_DIR;
		} else {
			this.baseDir = baseDir;
		}
		this.applicationsDef = appsDef;
	}

	public void startup() throws Exception {

		if (status == Status.SHUTDOWNED || status == Status.FAILED) {
			status = Status.STARTING;
		} else {
			String errorMsg = "cannot start ApplicationManager : status=[" + status + "]";
			log.error(errorMsg);
			throw new Exception(errorMsg);
		}

		try {
			scanAppDirectorys();
			startupApplications();
			status = Status.STARTED;
		} catch (Exception e) {
			status = Status.FAILED;
			log.error(e.getMessage(), e);
		}
	}

	
	
	private void scanAppDirectorys() {
		List<kr.co.bizframe.mas.conf.bind.Application> appsConf = applicationsDef.getList();

		// 지정 디렉터리 스캔
		for (kr.co.bizframe.mas.conf.bind.Application app : appsConf) {
			File fa = new File(app.getContextPath());
			// startupApplication(fa);
			scanAppDirectory(fa);
		}

		// 자동 deploy 디렉토러 스캔
		log.info("applications base home=[" + baseDir + "]");
		File appHome = new File(baseDir);
		File[] apps = appHome.listFiles();

		if (apps != null) {
			for (File app : apps) {
				scanAppDirectory(app);
			}
		}
	}
	
	
	
	private void scanAppDirectory(File appDir) {

		if (appDir.isDirectory()) {

			log.info("scan application context dir=[" + appDir.getAbsolutePath() + "]");
			String descFile = appDir.getAbsolutePath() + "/" + APP_DESC_FILE;
			File apf = new File(descFile);
			if (!apf.exists()) {
				log.error("fail load : missing config [" + descFile + "]");
				return;
			}

			ApplicationDef appDef = null;
			try {
				appDef = ApplicationConfig.parse(apf);
				appDef.setContextDir(appDir.getAbsolutePath());
				applicationDefs.add(appDef);
				
			} catch (Throwable t) {
				log.error(t.getMessage(), t);
			}
			
			try{
				checkAppDefValidity();
			}catch (Exception e) {
				throw new RuntimeException(e.getMessage(), e);
			}
			
		} else {
			log.error("application context dir=[" + appDir.getAbsolutePath() + "] is not valid.");
		}

	}
	
	/**
	 * App Definition의 validity 체크
	 */
	private void checkAppDefValidity() throws Exception {
		
		for(int ii=0;ii<applicationDefs.size();ii++){
			
			ApplicationDef adef = applicationDefs.get(ii);
			String aid = adef.getId();
			
			for(int jj=ii+1;jj<applicationDefs.size();jj++){
				ApplicationDef bdef = applicationDefs.get(jj);
				String bid = bdef.getId();
				if(aid.equals(bid)){
					throw new Exception("app id=["+bid+"] is duplicated");
				}
				
			}
		}
	}
	
	
	public void refreshAppDef() {
		scanAppDirectorys();
	}
	
	
	private void startupApplications() {

		Collections.sort(applicationDefs, new PriorityCompare());

		for (ApplicationDef appDef : applicationDefs) {
			log.debug("appDef = " + appDef);

		}

		for (ApplicationDef appDef : applicationDefs) {
			try{
				deployApplication(appDef);
			}catch(Exception e){
				log.error(e.getMessage(), e);
			}
		}

	}
	
	
	private ApplicationDef getApplicationDef(String appId){
		for (ApplicationDef appDef : applicationDefs) {
			if(appId.equals(appDef.getId())){
				return appDef;
			}
		}
		return null;
	}

	
	private void deployApplication(ApplicationDef appDef) throws Exception {

		if(appDef == null){
			throw new Exception("application def is null");
		}
	
		String appId = appDef.getId();
		ManagedApplication ma = applications.get(appId);
		
		if(ma != null){
			
			if(ma.getStatus() == ManagedApplication.Status.INITED ||
					ma.getStatus() == ManagedApplication.Status.STARTED ){
				throw new Exception("application status is not valid status=["+ma.getStatus()+ "]");
			}
			
			//ma가 아직 남아 있다면 오류 케이스 이므로 일단 다시 제거.
			//internalDestroy(ma);
		}
		

		try {
			ma = createManagedApplication(appDef);
			applications.put(appId, ma);
		} catch (Throwable t) {
			internalDestroy(ma);
			throw new Exception(t.getMessage(), t);
		}
		
		try {
			loadApplication(ma, appDef);
		} catch (Exception e) {
			internalDestroy(ma);
			throw new Exception("cannot load application=[" + appId + "]", e);
		}
		
		
		try {
			initApplication(ma);
		
			// application이 service 형이고 자동시작 설정되어 있으면 시작함.
			if (ma.getApplication() instanceof Serviceable && appDef.isAutoStart()) {
				startApplication(ma);
			}
		} catch (ApplicationException e) {
		
			// 어플리케이션 기동중 에러발생시
			// 내부 강제 종료 destroyForcely() 호출
			internalDestroy(ma);
			throw e;
		} catch (Throwable t) {
			internalDestroy(ma);
			throw new Exception(t.getMessage(), t);
		}
	}
	
	
	public List<ApplicationDef> getApplicationDefs(){
		return applicationDefs;
	}

	
	public void deployApplication(String appId)  throws Exception {
		ManagedApplication ma = applications.get(appId);
		ApplicationDef def = null;
		if(ma != null){
			def = ma.getContext().getApplicationDef();
		}else {
			def = getApplicationDef(appId);
		}
		
		deployApplication(def);
	}

	
	public void undeployApplication(String appId) throws Exception {
		destroyApplication(appId);
	}


	public RoutingManager getRoutingManager() {
		return engine.getRoutingManager();
	}

	public Application lookup(String appId) {
		Application app = null;
		ManagedApplication ma = applications.get(appId);
		if (ma != null) {
			app = ma.getApplication();
		}
		return app;
	}

	
	private void internalDestroy(ManagedApplication ma) throws Exception {
		ma.destroyForcely();
		//applications.remove(ma.getContext().getId());
	}

	
	
	private void initApplication(ManagedApplication ma) throws Exception {

		if (ma == null) {
			throw new Exception("managed application is null.");
		}
		
		try{
			ma.init();
		}catch(Exception e){
			log.error(e.getMessage(), e);
			throw e;
		}
	}


	public void startApplication(String appId) throws Exception {
		ManagedApplication appObj = applications.get(appId);
		startApplication(appObj);
	}


	/*
	 * Serviceable Application만 start
	 */
	private void startApplication(ManagedApplication ma) throws Exception {

		if (ma == null) {
			throw new Exception("managed application is null.");
		}

		Application application = ma.getApplication();
		if(application instanceof Serviceable){

			try{
				ma.start();
			}catch(Exception e){
				log.error(e.getMessage(), e);
				throw e;
			}
		}else{
			throw new Exception("application is not serviceable");
		}
	}


	public void shutdown() throws Exception {

		if (status == Status.STARTED || status == Status.FAILED) {
			status = Status.SHUTDOWNING;
		} else {
			log.error("cannot shutdown ApplicationManager : status=[" + status + "]");
			return;
		}

		try {
			undeployAll();
		} catch (Exception e) {
			log.error(e.getMessage(), e);
		}
		status = Status.SHUTDOWNED;
	}

	/*
	public void undeployAll() throws Exception {

		//deploy 역순으로 undeploy 처리
		for(int ii=applicationDefs.size()-1;ii>=0;ii--){

			ApplicationDef appDef = applicationDefs.get(ii);
			String appId = appDef.getId();
			undeployApplication(appId);
		}
	}
	*/
	

	public void undeployAll() throws Exception {

		//deploy 역순으로 undeploy 처리
		List<String> appIds = new ArrayList(applications.keySet());
		for(int ii=appIds.size()-1;ii>=0;ii--){
			String appId = appIds.get(ii);
			undeployApplication(appId);
		}
		
	}

	
	
	public void stopApplication(String appId) throws Exception {
		ManagedApplication appObj = applications.get(appId);
		if(appObj == null){
			throw new Exception("application obj id= ["+appId+"] is not found.");
		}
		stopApplication(appObj);
	}


	public void destroyApplication(String appId) throws Exception {
		ManagedApplication appObj = applications.get(appId);
		
		if(appObj == null){
			throw new Exception("application obj id= ["+appId+"] is not found.");
		}
		destroyApplication(appObj);
	}


	private void stopApplication(ManagedApplication ma) throws Exception {

		if (ma == null) {
			throw new Exception("application obj is null.");
		}
		//String appId = ma.getContext().getId();
		Application application = ma.getApplication();
		
		if(application instanceof Serviceable){
			
			if(ma.getStatus() != ManagedApplication.Status.STARTED){
				throw new Exception("application is not started.");
			}
			
			try{
				ma.stop();
			}catch(Exception e){
				throw e;
			}
		}else{
			throw new Exception("application is not serviceable");
		}
	}


	private void destroyApplication(ManagedApplication ma) throws Exception {

		if (ma == null) {
			throw new Exception("application obj is null.");
		}
		//String appId = ma.getContext().getId();

		// application이 start 상태이면 stop 시키고 destory 함.
		if(ma.getApplication() instanceof Serviceable &&
				ma.getStatus() == ManagedApplication.Status.STARTED){
			stopApplication(ma);
		}
		
		try{
			
			String appId = ma.getContext().getId();
			ClassLoader classLoader = ma.getContext().getClassLoader();
			
			ma.destroy();
			
			//applications.remove(appId);
			//applications.remove(id);

			// /////////////////////////////////////////////////////////////////
			// applicatinContext 정보를 외부 어플리케이션에 전달하기 위한
			// 헬퍼 클래스 tkrwp
			// /////////////////////////////////////////////////////////////////
			ApplicationContextUtils.removeApplicationContext(appId);
			ApplicationContextUtils.removeApplicationId(classLoader);
			///////////////////////////////////////////////////////////////////
			
		}catch(Exception e){
			throw e;
		}
	}


	private ManagedApplication createManagedApplication(ApplicationDef def) {

		ManagedApplication ma = null;
		ApplicationContext context = new ApplicationContext(this);
		String appId = def.getId();
		String contextDir = def.getContextDir();
		String name = def.getName();
 
		context.setId(appId);
		context.setName(name);
		context.setContextDir(contextDir);
		context.setProperties(def.getProperties());
		context.setApplicationDef(def);

		ma = new ManagedApplication(context);
	
		return ma;
	}
	
	
	
	
	private void loadApplication(ManagedApplication ma, ApplicationDef def) throws Exception {
		
		Application application = null;
		ApplicationClassLoader classLoader = null;
		
		ApplicationContext context = ma.getContext();
		String appId = context.getId();
	
		String contextDir = def.getContextDir();
		String loadClassName = def.getLoadClass();
		try {
			classLoader = new ApplicationClassLoader(appId, contextDir, this.getClass().getClassLoader(), def.isParentOnlyClassLoader(), def.isParentFirstClassLoader());

			Class task = classLoader.loadClass(loadClassName);
			application = (Application) task.newInstance();
			ma.setApplication(application);
			log.trace("application = " + application);
		} catch (Throwable t) {
			throw new Exception(t.getMessage(), t);
		}
		
		// /////////////////////////////////////////////////////////////////
		// applicatinContext 정보를 외부 어플리케이션에 전달하기 위한
		// 헬퍼 클래스
		// /////////////////////////////////////////////////////////////////
		ApplicationContextUtils.putApplicationContext(appId, context);
		ApplicationContextUtils.putApplicationId(classLoader, appId);
		// //////////////////////////////////////////////////////////////////

	}
	
	
	/*
	private void reloadManagedAppliation(ManagedApplication ma) throws Exception {

		ApplicationContext context = ma.getContext();
		ApplicationDef def = context.getApplicationDef();
		String contextDir = def.getContextDir();
		String appId = def.getId();
		String loadClassName = def.getLoadClass();
		ClassLoader preClassLoader = context.getClassLoader();

		Application application = null;
		ApplicationClassLoader classLoader = null;
		try {
			classLoader = new ApplicationClassLoader(appId, contextDir, this.getClass().getClassLoader(),
					def.isParentOnlyClassLoader(), def.isParentOnlyClassLoader());

			Class task = classLoader.loadClass(loadClassName);
			application = (Application) task.newInstance();
			log.trace("application = " + application);
		} catch (Throwable t) {
			throw new Exception(t.getMessage(), t);
		}

		context.setClassLoader(classLoader);
		ma.setApplication(application);

		// /////////////////////////////////////////////////////////////////
		// applicatinContext 정보를 외부 어플리케이션에 전달하기 위한
		// 헬퍼 클래스
		// /////////////////////////////////////////////////////////////////
		ApplicationContextUtils.removeApplicatioinId(preClassLoader);
		ApplicationContextUtils.putApplicationId(classLoader, appId);
		// //////////////////////////////////////////////////////////////////
	}
	*/
	


	public Status getStatus() {
		return status;
	}


	public ManagedApplication getManagedApplication(String appId){
		ManagedApplication ma = applications.get(appId);
		return ma;
	}


	public List<ManagedApplication> getManagedApplications() {
		return new ArrayList<ManagedApplication>(applications.values());
	}



	/*
	 priority 순번이 낮을수록  먼저 위치한다.
	 priorty 0 이 priority 1 보다 먼저  로딩 ,  내려갈때는 반대순서
	*/
	static class PriorityCompare implements Comparator<ApplicationDef> {

		public int compare(ApplicationDef def1, ApplicationDef def2) {

			int priority1 = def1.getPriority();
			int priority2 = def2.getPriority();

			if (priority1 > priority2) {
				return 1;
			} else if (priority1 == priority2) {
				return 0;
			} else {
				return -1;
			}

		}

	}
}
