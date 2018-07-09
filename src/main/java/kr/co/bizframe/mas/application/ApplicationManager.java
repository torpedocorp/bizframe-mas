package kr.co.bizframe.mas.application;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.net.URI;
import java.nio.file.FileSystem;
import java.nio.file.FileSystems;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipInputStream;

import kr.co.bizframe.mas.Application;
import kr.co.bizframe.mas.Lifecycle;
import kr.co.bizframe.mas.Serviceable;
import kr.co.bizframe.mas.conf.ApplicationConfig;
import kr.co.bizframe.mas.conf.bind.ApplicationsDef;
import kr.co.bizframe.mas.core.MasEngine;
import kr.co.bizframe.mas.management.JMXManager;
import kr.co.bizframe.mas.routing.RoutingManager;
import kr.co.bizframe.mas.util.FileUtil;
import kr.co.bizframe.mas.util.ZipUtil;
import kr.co.bizframe.mas.util.leak.ClassLoaderLeakPreventorFactory;

import org.apache.commons.io.FilenameUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class ApplicationManager implements Lifecycle {

	private static Logger log = LoggerFactory.getLogger(ApplicationManager.class);
	
	private String homeDir;
	
	private String baseDir;

	private final String DEFAULT_BASE_DIR = "applications";

	private ApplicationsDef applicationsDef;

	private final String APP_DESC_FILE = "application.xml";

	private MasEngine engine;

	private Status status = Status.SHUTDOWNED;

	private ApplicationWatcher applicationWatcher;
	
	private String DEFAULT_TMP_APPLICATIONS = "/tmp/applications";
	
	private enum Status {
		SHUTDOWNED, SHUTDOWNING, STARTED, STARTING, FAILED
	}
	
	/*
	 * String : absolute normalized file Name
	 * File : Application file(mar file) or directory File
	 * 
	 */
	private Map<String, File> applicationFiles = new LinkedHashMap<String, File>();
	
	/*
	 * 	String : applicatinId
	 *  ApplicationDef : Application definitin value
	 *
	 */
	private Map<String, ApplicationDef> applicationDefs = new LinkedHashMap<String, ApplicationDef>();

	
	/*
	 * String : applicationId
	 * ManagedApplication : application 인스턴스
	 *
	 * 기동 순서를 가지기 위해서 LinkedHashMap을 사용
	 */
	private Map<String, MasApplication> applications = new LinkedHashMap<String, MasApplication>();


	public ApplicationManager(String homeDir, ApplicationsDef appsDef, boolean hotDeploy, MasEngine engine) {

		this.engine = engine;
		this.homeDir = homeDir;
		
		if (appsDef == null) {
			appsDef = new ApplicationsDef();
		}

		String baseDirDef = appsDef.getBaseDir();

		if (baseDirDef == null) {
			this.baseDir = homeDir + "/" + DEFAULT_BASE_DIR;
		} else {
			this.baseDir = baseDirDef;
		}
		this.applicationsDef = appsDef;
		
		if(hotDeploy){
			applicationWatcher = new ApplicationWatcher(this);
			applicationWatcher.addWatch(baseDir);
		}
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
		
		// 초기화
		applicationDefs.clear();
		
		// 지정 디렉터리 스캔
		for (kr.co.bizframe.mas.conf.bind.Application app : appsConf) {
			File fa = new File(app.getContextPath());
			//scanAppDirectory(fa);
			applicationFiles.put(fa.getName(), fa);
		}

		// 자동 deploy 디렉토러 스캔
		log.info("applications base home=[" + baseDir + "]");
		File appHome = new File(baseDir);
		File[] apps = appHome.listFiles();
		for(File f : apps){
			applicationFiles.put(FilenameUtils.normalize(f.getAbsolutePath()), f);
		}
		
		if (apps != null) {
			for (File app : applicationFiles.values()) {
				try{
					scanAppDirectory(app);
				}catch(Exception e){
					log.warn(e.getMessage());
				}
			}
		}
	}
	
	
	
	public ApplicationDef scanAppDirectory(File appDir) throws Exception {
		
		if (appDir.isDirectory()) {
			return scanDirApp(appDir);
		}else if(appDir.isFile()) {
			if(isMarFile(appDir)){
				return scanMarApp(appDir);
			} 
			
		} else {
			throw new Exception("application context dir=[" + appDir.getAbsolutePath() + "] is not valid.");
		}
		return null;
	}
	

	private File getMarFile(String name){

		if(name == null) return null;
		
		File f = applicationFiles.get(name +".mar"); 
		if(f == null) {
			f = applicationFiles.get(name +".zip"); 
		}
		return f;
	}
	
	
	private boolean isMarFile(File f){
		if(f == null) return false;
		if(f.isFile() && (f.getName().endsWith(".zip") ||
				f.getName().endsWith(".mar"))){
			return true;
		}
		return false;
	}
	
	
	private ApplicationDef scanDirApp(File appDir) throws Exception {
		
		log.info("scan dir application context dir=[" + FilenameUtils.normalize(appDir.getAbsolutePath()) + "]");
		
		// mar 형태로 풀려진 dir 가 있을 경우 skip 함
		if(getMarFile(appDir.getName()) != null){
			throw new Exception("duplicated mar application exist");
		}
		
		String descFile = appDir.getAbsolutePath() + "/" + APP_DESC_FILE;
		File apf = new File(descFile);
		if (!apf.exists()) {
			throw new Exception("fail load : missing config [" + descFile + "]");
		}

		ApplicationDef appDef = null;
		try {
			appDef = ApplicationConfig.parse(apf);
			appDef.setContextDir(FilenameUtils.normalize(appDir.getAbsolutePath()));
			checkAppDefValidity(appDef);
			applicationDefs.put(appDef.getId(), appDef);

		} catch (Throwable t) {
			throw new Exception(t.getMessage(), t);
		}
		
		return appDef;
	}
	
	
	private ApplicationDef scanMarApp(File f) throws Exception {

		log.info("scan mar application file=[" + FilenameUtils.normalize(f.getAbsolutePath()) + "]");
		ApplicationDef appDef = null;
		try{
			InputStream aps = ZipUtil.getEntryInputStream(f, APP_DESC_FILE);
			if(aps == null){
				throw new Exception("fail load : missing config [" + f + "]");
			}
			
			appDef = ApplicationConfig.parse(aps);
			checkAppDefValidity(appDef);
			applicationDefs.put(appDef.getId(), appDef);
			
			String appDir = null;
			if(appDef.isUnpackMar()){
				appDir = baseDir + "/" + FilenameUtils.removeExtension(f.getName());
			}else{
				appDir = homeDir + DEFAULT_TMP_APPLICATIONS + "/" + FilenameUtils.removeExtension(f.getName());
			}
			
			//check dir and remove 
			File dir = new File(appDir);
			if(dir.exists()) dir.delete();
			dir.mkdir();
			
			ZipUtil.deflateZip(f, appDir);
			appDef.setContextDir(FilenameUtils.normalize(appDir));
			
		}catch(Throwable t){
			throw new Exception(t.getMessage(), t);
		}
		return appDef;
	}
	
	
	/**
	 * App Definition의 validity 체크
	 */
	/*
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
	*/
	
	
	/*
	 *  check whether ApplicationDef is valid
	 */
	private void checkAppDefValidity(ApplicationDef def) throws Exception {
		String id = def.getId();
		ApplicationDef preDef = applicationDefs.get(id);
		if(preDef != null){
			throw new Exception("app id=["+id+"] is duplicated");
		}
	}
	
	
	public void refreshAppDef() {
		scanAppDirectorys();
	}
	
	
	private void startupApplications() {

		//Collections.sort(applicationDefs, new PriorityCompare());
		List<ApplicationDef> appDefs = getApplicationDefsSortByPriority(true);
	
		for (ApplicationDef appDef : appDefs) {
			log.info("appDef = " + appDef);
		}

		for (ApplicationDef appDef : appDefs) {
			try{
				deployApplication(appDef);
			}catch(Exception e){
				log.error(e.getMessage(), e);
			}
		}
	}
	
	
	/*
	private ApplicationDef getApplicationDef(String appId){
		
		for (ApplicationDef appDef : applicationDefs) {
			if(appId.equals(appDef.getId())){
				return appDef;
			}
		}
		
		return null;
	}
	*/
	
	
	private void deployApplication(ApplicationDef appDef) throws Exception {

		if(appDef == null){
			throw new Exception("application def is null");
		}
	
		String appId = appDef.getId();
		MasApplication ma = applications.get(appId);
		
		if(ma != null){
			
			if(ma.getStatus() == MasApplication.Status.INITED ||
					ma.getStatus() == MasApplication.Status.STARTED ){
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
	
	/*
	public List<ApplicationDef> getApplicationDefs(){
		return applicationDefs;
	}
	*/
	
	public List<ApplicationDef> getApplicationDefs(){
		return new ArrayList<ApplicationDef>(applicationDefs.values());
	}
	
	
	private ApplicationDef getApplicationDefByAppFile(File f){
		for(ApplicationDef def : applicationDefs.values()){
			String cdir = def.getContextDir();
			if(FilenameUtils.normalize(f.getAbsolutePath()).
				equals(FilenameUtils.normalize(cdir))){
				return def;
			}
		}
		return null;
	}
	
	
	public void deployApplication(String appId)  throws Exception {
		//ManagedApplication ma = applications.get(appId);
		ApplicationDef def = null;
		
		/*
		 * deploy 시에는 항상 새로운 application def로 로딩함.  
		 */
		/*
		if(ma != null){
			def = ma.getContext().getApplicationDef();
		}else {
			def = getApplicationDef(appId);
		}
		*/
		def = applicationDefs.get(appId);
		deployApplication(def);
	}

	
	public void undeployApplication(String appId) throws Exception {
		destroyApplication(appId);
	}
	
	
	public void removeApplication(String appId) throws Exception {
		
		ApplicationDef appDef = applicationDefs.get(appId);
		
		undeployApplication(appId);
		applications.remove(appId);
		applicationDefs.remove(appId);
		
		applicationFiles.remove(FilenameUtils.normalize(appDef.getContextDir()));
		JMXManager.unregisterApplicationMgmt(appId);
	}

	
	public void removeApplication(File appDir)  throws Exception {
		
		ApplicationDef appDef = getApplicationDefByAppFile(appDir);
		removeApplication(appDef.getId());
	}
	
	
	public RoutingManager getRoutingManager() {
		return engine.getRoutingManager();
	}

	public Application lookup(String appId) {
		Application app = null;
		MasApplication ma = applications.get(appId);
		if (ma != null) {
			app = ma.getApplication();
		}
		return app;
	}

	
	private void internalDestroy(MasApplication ma) throws Exception {
		ma.destroyForcely();
		//applications.remove(ma.getContext().getId());
	}

	
	
	private void initApplication(MasApplication ma) throws Exception {

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
		MasApplication appObj = applications.get(appId);
		startApplication(appObj);
	}


	/*
	 * Serviceable Application만 start
	 */
	private void startApplication(MasApplication ma) throws Exception {

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
		MasApplication appObj = applications.get(appId);
		if(appObj == null){
			throw new Exception("application obj id= ["+appId+"] is not found.");
		}
		stopApplication(appObj);
	}


	public void destroyApplication(String appId) throws Exception {
		MasApplication appObj = applications.get(appId);
		
		if(appObj == null){
			throw new Exception("application obj id= ["+appId+"] is not found.");
		}
		destroyApplication(appObj);
	}


	private void stopApplication(MasApplication ma) throws Exception {

		if (ma == null) {
			throw new Exception("application obj is null.");
		}
		//String appId = ma.getContext().getId();
		Application application = ma.getApplication();
		
		if(application instanceof Serviceable){
			
			if(ma.getStatus() != MasApplication.Status.STARTED){
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


	private void destroyApplication(MasApplication ma) throws Exception {

		if (ma == null) {
			throw new Exception("application obj is null.");
		}
		//String appId = ma.getContext().getId();

		// application이 start 상태이면 stop 시키고 destory 함.
		if(ma.getApplication() instanceof Serviceable &&
				ma.getStatus() == MasApplication.Status.STARTED){
			stopApplication(ma);
		}
		
		try{
			
			String appId = ma.getContext().getId();
			ClassLoader classLoader = ma.getContext().getClassLoader();
			
			ma.destroy();
		
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


	private MasApplication createManagedApplication(ApplicationDef def) {

		MasApplication ma = null;
		ApplicationContext context = new ApplicationContext(this);
		String appId = def.getId();
		String contextDir = def.getContextDir();
		String name = def.getName();
 
		context.setId(appId);
		context.setName(name);
		context.setContextDir(contextDir);
		context.setProperties(def.getProperties());
		context.setApplicationDef(def);
		context.setHomeDir(homeDir);
		ma = new MasApplication(context);
		JMXManager.registerApplicationMgmt(ma);
		return ma;
	}
	
	
	
	private void loadApplication(MasApplication ma, ApplicationDef def) throws Exception {
		
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
			context.setClassLoader(classLoader);
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
	

	public Status getStatus() {
		return status;
	}


	public MasApplication getManagedApplication(String appId){
		MasApplication ma = applications.get(appId);
		return ma;
	}


	public List<MasApplication> getManagedApplications() {
		return new ArrayList<MasApplication>(applications.values());
	}


	
	/*
	 priority 순번이 낮을수록  먼저 위치한다.
	 priorty 0 이 priority 1 보다 먼저  로딩 ,  내려갈때는 반대순서
	*/
	static class PriorityCompare implements Comparator<ApplicationDef> {
		
		private boolean descending = false;
		
		public PriorityCompare(boolean descending){
			this.descending = descending;
		}
		
		public int compare(ApplicationDef def1, ApplicationDef def2) {

			int priority1 = def1.getPriority();
			int priority2 = def2.getPriority();

			/*
			if (priority1 > priority2) {
				return 1;
			} else if (priority1 == priority2) {
				return 0;
			} else {
				return -1;
			}
			*/
			if (priority1 > priority2) {
				
				if(descending) return -1;
				else return 1;
			} else if (priority1 == priority2) {
				return 0;
			} else {
				
				if(descending) return 1;
				else return -1;
			}
		}

	}

	
	private List<ApplicationDef> getApplicationDefsSortByPriority(boolean descending) {
		List<ApplicationDef> list = new ArrayList<ApplicationDef>();
		list.addAll(applicationDefs.values());		
		Collections.sort(list, new PriorityCompare(descending));
		return list;
	}
	
	
	/*
	public Map<String, ApplicationDef> sortByPriority(final Map<String, ApplicationDef> map, boolean descending) {
		System.out.println("xxxxxxxxx original size = " + map.size());
		//TreeMap<String, ApplicationDef> sorted = 
		//		 new TreeMap<String, ApplicationDef>(new PriorityCompare(map, descending));
		TreeMap<String, ApplicationDef> sorted = new TreeMap<String, ApplicationDef>();
		
		sorted.putAll(map); 
		
		System.out.println("xxxxxxxxx sorted size = " + sorted.size());
		
		return sorted;
	}
	*/
	
	
	
	/*
	 priority 순번이 낮을수록  먼저 위치한다.
	 priorty 0 이 priority 1 보다 먼저  로딩 ,  내려갈때는 반대순서
	*/
	/*
	static class PriorityCompare implements Comparator<String> {
		
		private Map<String, ApplicationDef> map;
		
		private boolean descending = false;
		
		public PriorityCompare(Map<String, ApplicationDef> map, boolean descending){
			this.map = map;
			this.descending = descending;
		}
		
		public int compare(String id1, String id2) {

			int priority1 = map.get(id1).getPriority();
			int priority2 = map.get(id2).getPriority();
			
			if (priority1 > priority2) {
				
				if(descending) return -1;
				else return 1;
			} else if (priority1 == priority2) {
				return 0;
			} else {
				
				if(descending) return 1;
				else return -1;
			}

		}

	}
	*/
	
	
}
