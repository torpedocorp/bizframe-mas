package kr.co.bizframe.mas.core;

import java.lang.reflect.Constructor;
import java.util.ArrayList;
import java.util.List;

import kr.co.bizframe.mas.Application;
import kr.co.bizframe.mas.Lifecycle;
import kr.co.bizframe.mas.Routable;
import kr.co.bizframe.mas.Serviceable;
import kr.co.bizframe.mas.Version;
import kr.co.bizframe.mas.application.ApplicationContext;
import kr.co.bizframe.mas.application.ApplicationDef;
import kr.co.bizframe.mas.application.ApplicationManager;
import kr.co.bizframe.mas.application.ManagedApplication;
import kr.co.bizframe.mas.command.model.ApplicationDefInfo;
import kr.co.bizframe.mas.command.model.ApplicationInfo;
import kr.co.bizframe.mas.command.model.RouteInfo;
import kr.co.bizframe.mas.conf.MasConfig;
import kr.co.bizframe.mas.conf.bind.ApplicationsDef;
import kr.co.bizframe.mas.conf.bind.EngineDef;
import kr.co.bizframe.mas.conf.bind.RoutingDef;
import kr.co.bizframe.mas.routing.AbstractRoutingManager;
import kr.co.bizframe.mas.routing.RoutingManager;
import kr.co.bizframe.mas.routing.impl.conf.RouteConfig;
import kr.co.bizframe.mas.routing.impl.conf.RouteDef;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class MasEngine implements Lifecycle {

	private static Logger log = LoggerFactory.getLogger(MasEngine.class);

	private String engineId;

	private Status status = Status.SHUTDOWNED;

	private ApplicationManager applicationManager;

	private boolean enableRouting = false;

	private AbstractRoutingManager routingManager;

	private enum Status {

		SHUTDOWNED, SHUTDOWNING, STARTED, STARTING, FAILED

	}

	public MasEngine() {
		this("./");
	}

	public MasEngine(String homeDir) {
		this(homeDir, MasConfig.getServer().getEngine());
	}

	public MasEngine(String homeDir, EngineDef engineDef) {

		this.engineId = engineDef.getId();
		ApplicationsDef appsDef = engineDef.getApplications();

		this.applicationManager = new ApplicationManager(homeDir, appsDef, this);

		RoutingDef routingDef = engineDef.getRouting();
		loadRoutingManager(routingDef);
	}

	private void loadRoutingManager(RoutingDef routingDef) {

		if (routingDef == null) {
			return;
		}

		String routingClassName = routingDef.getClassName();
		this.enableRouting = routingDef.getEnable();

		if (enableRouting) {
			try {
				Class clazz = Class.forName(routingClassName);
				Constructor constructor = clazz.getConstructor(new Class[] { MasEngine.class });
				this.routingManager = (AbstractRoutingManager) constructor.newInstance(this);
			} catch (Throwable t) {
				log.error(t.getMessage(), t);
			}
		}

	}

	public synchronized void startup() throws Exception {

		if (status == Status.SHUTDOWNED || status == Status.FAILED) {
			status = Status.STARTING;
		} else {
			String errorMsg = "cannot start engine : engine status=[" + status + "]";
			log.error(errorMsg);
			throw new Exception(errorMsg);
		}

		try {
			// application load
			applicationManager.startup();

			// routing engine start
			if (enableRouting && routingManager != null) {
				routingManager.startup();
			}
			status = Status.STARTED;
		} catch (Throwable t) {
			status = Status.FAILED;
			log.error(t.getMessage(), t);
			throw new Exception(t);
		}

		// shutdown hook 설정
		Runtime.getRuntime().addShutdownHook(new EngineShutdownHook());
		log.info("BizFrame mas engine started.");
	}

	public void shutdown() throws Exception {

		if (status == Status.STARTED || status == Status.FAILED) {
			status = Status.SHUTDOWNING;
		} else {
			log.error("cannot shutdown engine : engine status=[" + status + "]");
			return;
		}

		try {
			if (enableRouting && routingManager != null) {
				routingManager.shutdown();
			}
			applicationManager.shutdown();
		} catch (Throwable t) {
			log.error(t.getMessage(), t);
		}
		status = Status.SHUTDOWNED;
		log.info("BizFrame mas engine shutdowned.");
	}

	protected class EngineShutdownHook extends Thread {

		public void run() {

			if (status != Status.SHUTDOWNING && status != Status.SHUTDOWNED) {
				log.info("start mas shutdown hook process.");
				try {
					shutdown();
				} catch (Throwable t) {
					log.error(t.getMessage(), t);
				}
			}
		}
	}

	public ApplicationManager getApplicationManager() {
		return applicationManager;
	}

	public RoutingManager getRoutingManager() {
		return routingManager;
	}

	public boolean isEnableRouting() {
		return enableRouting;
	}

	public void setEnableRouting(boolean enableRouting) {
		this.enableRouting = enableRouting;
	}

	public String getEngineId() {
		return engineId;
	}

	public void setEngineId(String engineId) {
		this.engineId = engineId;
	}

	public String getVersion() {
		return Version.getVersion();
	}

	
	public String getStatusInfo() {
		
		log.debug("MasEngine getStatusInfo");
		
		StringBuffer sb = new StringBuffer();

		sb.append("engine status=["+status+"] \n");
		sb.append("applicationManager status=["	+applicationManager.getStatus()+"] \n");
		List<ManagedApplication> apps = applicationManager.getManagedApplications();
		for (ManagedApplication app : apps) {
			String id = app.getContext().getId();
			String name = app.getContext().getName();
			sb.append("application id=[" + id + "], name=[" + name
					+ "]. status=[" + app.getStatusAsString() + "] \n");
		}

		if (enableRouting == true && routingManager != null) {
			sb.append("routingManager status=[" + routingManager.getStatus()
					+ "] \n");
		}

		return sb.toString();
	}

	
	

	public List<ApplicationDefInfo> getApplicationDefList(){

		log.debug("MasEngine getApplicationDefList");
		
		List<ApplicationDefInfo> appDefInfoList = new ArrayList<ApplicationDefInfo>();
		List<ApplicationDef> appDefs = applicationManager.getApplicationDefs();
		
		for(ApplicationDef appDef : appDefs){
			ApplicationDefInfo appDefInfo = populateApplicationDefInfo(appDef);
			appDefInfoList.add(appDefInfo);
	
			//log.debug(appDefInfo.getId());
			
		}

		return appDefInfoList;
	}

	
	
	public ApplicationDefInfo getApplicationDef(String appId){
		
		log.debug("MasEngine getApplicationDef appId=["+ appId+"]");
		
		if(appId == null) return null;
		List<ApplicationDef> appDefs = applicationManager.getApplicationDefs();

		for(ApplicationDef appDef : appDefs){
			if(appId.equals(appDef.getId())){
				return populateApplicationDefInfo(appDef);
			}
		}
		return null;
		
	}
	
	
	
	private  ApplicationDefInfo populateApplicationDefInfo(ApplicationDef appDef){
		
		
		ApplicationDefInfo appDefInfo = new ApplicationDefInfo();
		appDefInfo.setId(appDef.getId());
		appDefInfo.setName(appDef.getName());
		appDefInfo.setPriority(appDef.getPriority());
		appDefInfo.setContextDir(appDef.getContextDir());
		appDefInfo.setLoadClass(appDef.getLoadClass());
		appDefInfo.setParentOnlyClassLoader(appDef.isParentOnlyClassLoader());
		appDefInfo.setParentFirstClassLoader(appDef.isParentFirstClassLoader());

		return appDefInfo;
	}


	/*
	 *
	 */
	public void refreshApplicationDef() throws Exception {

		log.debug("MasEngine refreshApplicationDef");
		applicationManager.refreshAppDef();
	}

	
	/*
	 * Command.GET_APP_LIST
	 */
	public List<ApplicationInfo> getApplicationList(){

		log.debug("MasEngine getApplicationList");
		
		List<ApplicationInfo> appInfoList = new ArrayList<ApplicationInfo>();
		List<ManagedApplication> maps = applicationManager.getManagedApplications();
		
		for(ManagedApplication mapp : maps){
			ApplicationInfo appInfo = populateApplicationInfo(mapp);
			appInfoList.add(appInfo);
	
			log.debug(appInfo.getId() + "serviceable=[" + appInfo.getServiceable()+"]" +
					", routable=[" +appInfo.getRoutable()+"]");
			
		}

		return appInfoList;
	}

	
	
	/*
	 * Command.GET_APP_INFO
	 */
	public ApplicationInfo getApplicationInfo(String appId){
		
		log.debug("MasEngine getApplicationInfo appId["+appId+"]");
		
		if(appId == null) return null;
		List<ManagedApplication> maps = applicationManager.getManagedApplications();

		for(ManagedApplication mapp : maps){
			//ApplicationInfo appInfo = populateApplicationInfo(mapp);
			if(appId.equals(mapp.getContext().getId())){
				return populateApplicationInfo(mapp);
			}
		}
		return null;
	}
	
	
	private ApplicationInfo populateApplicationInfo(ManagedApplication mapp){
		
		ApplicationContext context = mapp.getContext();
		ApplicationInfo appInfo = new ApplicationInfo();
		appInfo.setContextFilePath(context.getContextDir().replaceAll("\\\\", "/")+"/"+"application.xml");
//		appDef.setContextFilePath(context.getContextDir()+"/"+"application.xml");
		appInfo.setId(context.getId());
		appInfo.setName(context.getName());
		appInfo.setStatus(mapp.getStatus().toString());
		String loadClass = context.getApplicationDef().getLoadClass();
		appInfo.setLoadClass(loadClass);

		Application app = mapp.getApplication();
		if (app instanceof Serviceable) {
			appInfo.setServiceable();
			RouteDef routeDef = RouteConfig.findRoute(appInfo.getId());
			if (routeDef != null) {
				appInfo.setRouteId(routeDef.getId());
			}
		}
		if (app instanceof Routable) {
			appInfo.setRoutable();
		}
		
		appInfo.setInitTime(mapp.getInitTime());
		appInfo.setStopTime(mapp.getStopTime());
		appInfo.setStartTime(mapp.getStartTime());
	
		return appInfo;
	}
	
	
	/*
	 * Command.DEPLOY_APP
	 */
	public void deployApplication(String appId) throws Exception {

		log.debug("MasEngine deployApp appId=[" + appId + "]");
		applicationManager.deployApplication(appId);
	}

	/*
	 * Command.UNDEPLOY_APP
	 */
	public void undeployApplication(String appId) throws Exception {

		log.debug("MasEngine undeployApp appId=["+ appId + "]");
		applicationManager.undeployApplication(appId);
	}

	/*
	 * Command.START_APP
	 */
	public void startApplication(String appId) throws Exception {

		log.debug("MasEngine startupApp appId=["+ appId + "]");
		applicationManager.startApplication(appId);
	}

	/*
	 * Command.STOP_APP
	 */
	public void stopApplication(String appId) throws Exception {

		log.debug("MasEngine stopApp appId=["+appId + "]");
		applicationManager.stopApplication(appId);
	}

	/*
	 * Command.RETRIEVE_ROUTELIST
	 */
	public List<RouteInfo> getRouteList() throws Exception {

		log.debug("MasEngine getRouteList");
		return RouteConfig.getRouteDef();
	}

	/*
	 * Command.RETRIEVE_ROUTEDETAIL
	 */
	public List<ApplicationInfo> getRouteDetail(String routeId)  throws Exception {

		log.debug("MasEngine getRouteDetail");
	
		List<ApplicationInfo> appInfoList = new ArrayList();
		List<String> appIds = new ArrayList();

		List<RouteInfo> routeInfos = RouteConfig.getRouteDef();
		for(RouteInfo routeInfo: routeInfos) {
			if(routeInfo.getId().equals(routeId)) {
				appIds = routeInfo.getAppIds();
			}
		}

		List<ManagedApplication> maps = applicationManager.getManagedApplications();

		for(ManagedApplication mapp : maps){
			ApplicationContext context = mapp.getContext();
			ApplicationInfo appInfo = new ApplicationInfo();
			if(appIds.contains(context.getId())) {
				appInfo.setContextFilePath(context.getContextDir().replaceAll("\\\\", "/")+"/"+"application.xml");
				appInfo.setId(context.getId());
				appInfo.setName(context.getName());
				appInfo.setStatus(mapp.getStatus().toString());
				appInfo.setLoadClass("context.getClassLoader() ... ??? ");

				Application app = mapp.getApplication();
				if(app instanceof Serviceable)
					appInfo.setServiceable();
				if(app instanceof Routable)
					appInfo.setRoutable();

				appInfo.setInitTime(mapp.getInitTime());
				appInfo.setStopTime(mapp.getStopTime());
				appInfo.setStartTime(mapp.getStartTime());

				appInfoList.add(appInfo);

				log.debug(appInfo.toString());
			}
		}

		return appInfoList;
	}



}
