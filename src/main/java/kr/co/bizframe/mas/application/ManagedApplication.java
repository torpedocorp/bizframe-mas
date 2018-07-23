package kr.co.bizframe.mas.application;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import kr.co.bizframe.mas.Application;
import kr.co.bizframe.mas.Serviceable;


import kr.co.bizframe.mas.process.ProcessApplication;
import kr.co.bizframe.mas.process.ScriptCommandApplication;
import kr.co.bizframe.mas.util.leak.ClassLoaderLeakPreventor;
import kr.co.bizframe.mas.util.leak.ClassLoaderLeakPreventorFactory;


public class ManagedApplication {

	private static Logger log = LoggerFactory.getLogger(ManagedApplication.class);

	public enum Status {

		PRELOADING, LOADED, INITING, INITED, STARTING, STARTED, STOPPED, STOPPING,
			DESTROYING, DESTROYED, FAILED
	}

	private long initTime = -1L;

	private long startTime = -1L;

	private long stopTime = -1L;

	private long destroyTime = -1L;


	// 실제 application 객체
	private Application application;

	private ApplicationContext applicationContext;

	private Status status;

	//private ClassLoaderLeakPreventor classLoaderLeakPreventor;
	
	//private boolean enableLeakPreventor = true;
	

	public ManagedApplication(ApplicationContext applicationContext) {
		this.applicationContext = applicationContext;
		this.status = Status.PRELOADING;
	}
	
	
	public ManagedApplication(Application application,
			ApplicationContext applicationContext) {
		this.application = application;
		this.applicationContext = applicationContext;
		this.status = Status.LOADED;
	}

	public Application getApplication() {
		return application;
	}

	public void setApplication(Application application) {
		this.application = application;
		this.status = Status.LOADED;
	}

	public ApplicationContext getContext() {
		return applicationContext;
	}

	public void init() throws ApplicationException {

		if (application == null) {
			throw new NullPointerException("application object is null.");
		}
		
		String appId = applicationContext.getId();
		if (status != Status.LOADED && status != Status.DESTROYED) {
			throw new ApplicationException("cannot init application=[" + appId + "], application status=[" + status + "]");
		}

		Status preStatus = status;
		try {
			status = Status.INITING;
			
					
			application.init(applicationContext);
			
			/*
			enableLeakPreventor = applicationContext.getBooleanProperty("leak_preventor", true);
			if(enableLeakPreventor){
				log.debug("enable app leak preventor");
				ClassLoader appClassLoader = applicationContext.getClassLoader();
				ClassLoaderLeakPreventorFactory classLoaderLeakPreventorFactory = 
						new ClassLoaderLeakPreventorFactory() ;
				classLoaderLeakPreventor = classLoaderLeakPreventorFactory.
						newLeakPreventor(appClassLoader);
				classLoaderLeakPreventor.runPreClassLoaderInitiators();
			}
			*/
			
			
			log.info("application=[" + appId + "] inited");
			initTime = System.currentTimeMillis();
			status = Status.INITED;
		} catch (Throwable t) {
			status = preStatus;
			throw new ApplicationException("cannot init application=[" + appId + "]", t);
		}
	}

	
	public void destroy() throws ApplicationException {
		destroy(false);
	}
	
	/*
	 * 
	 * 강제 application 종료이므로 상태나 오류를 리턴하지 않는다.
	 */
	public void destroyForcely() throws ApplicationException {
		destroy(true);
	}
	
	/*
	 * 
	 * forcely 옵션이 true 일 경우 상태에 상관 없이 destroy 수행
	 */
	public void destroy(boolean forcely) throws ApplicationException {
		if (application == null) {
			//throw new NullPointerException("application object is null.");
			status = Status.DESTROYED;
			return;
		}
		String appId = applicationContext.getId();
		
		if(!forcely){
			if (status != Status.INITED && status != Status.STARTED && status != Status.STOPPED) {
				throw new ApplicationException("cannot destroy application=[" + appId + "], application status=[" + status + "]");
			}
		}
		
		Status preStatus = status;
		try {
			status = Status.DESTROYING;
			
			//if(enableLeakPreventor){
			//	classLoaderLeakPreventor.runCleanUps();
			//}
			
			application.destroy(applicationContext);
			
			// applications 객체 널시킴
			application = null;
			//classLoaderLeakPreventor.runCleanUps();
			
			log.info("application=[" + appId + "] destroyed");
			destroyTime = System.currentTimeMillis();
			status = Status.DESTROYED;
		} catch (Throwable t) {
			status = preStatus;
			throw new ApplicationException("cannot destroy application=[" + appId + "]", t);
		}
		
	}

	
	
	public void start() throws ApplicationException {

		if (application == null) {
			throw new NullPointerException("application object is null.");
		}

		String appId = applicationContext.getId();

		if (application instanceof Serviceable) {
			Serviceable s = (Serviceable) application;

			if (status == Status.STOPPED || status == Status.INITED) {
				Status preStatus = status;
				try {
					status = Status.STARTING;
					s.start();
					log.info("application=[" + appId + "] started");
					startTime = System.currentTimeMillis();
					status = Status.STARTED;
				} catch (Exception e) {
					status = preStatus;
					throw new ApplicationException(e.getMessage(), e);
				}
			} else {
				throw new ApplicationException("cannot start application=[" + appId + "], application status=[" + status + "]");
			}
		} else {
			throw new ApplicationException("application is not serviceable.");
		}
	}

	public void stop() throws ApplicationException {

		if (application == null) {
			throw new NullPointerException("application object is null.");
		}

		String appId = applicationContext.getId();

		if(application instanceof Serviceable){
			Serviceable s = (Serviceable)application;

			if(status == Status.STARTED){
				Status preStatus = status;
				try{
					status = Status.STOPPING;
					s.stop();
					log.info("application=["+appId+"] stopped");
					stopTime = System.currentTimeMillis();
					status = Status.STOPPED;
				}catch(Exception e){
					status = preStatus;
					throw new ApplicationException(e.getMessage(), e);
				}

			}else{
				throw new ApplicationException("cannot stop application=[" + appId
						+ "], application status=[" + status + "]");
			}
		}else{
			throw new ApplicationException("application is not serviceable.");
		}
	}

	public String getStatusAsString(){
		
		if(application instanceof ProcessApplication){
			ProcessApplication pa = (ProcessApplication)application;
			return status.toString() + " : " + pa.getStatus();
		}else{
			return status.toString();
		}
	}

	public Status getStatus() {
		return status;
	}
	
	public long getInitTime() {
		return initTime;
	}

	public void setInitTime(long initTime) {
		this.initTime = initTime;
	}

	public long getStartTime() {
		return startTime;
	}

	public void setStartTime(long startTime) {
		this.startTime = startTime;
	}

	public long getStopTime() {
		return stopTime;
	}

	public void setStopTime(long stopTime) {
		this.stopTime = stopTime;
	}

	public long getDestroyTime() {
		return destroyTime;
	}

	public void setDestroyTime(long destroyTime) {
		this.destroyTime = destroyTime;
	}




	//public void setStatus(Status status) {
	//	this.status = status;
	//}

}
