package kr.co.bizframe.mas.application;

import java.net.URL;

import kr.co.bizframe.mas.routing.RoutingContext;
import kr.co.bizframe.mas.routing.RoutingManager;
import kr.co.bizframe.mas.routing.impl.DefaultRoutingContext;
import kr.co.bizframe.mas.util.PropertyHolder;

public class ApplicationContext extends PropertyHolder {

	private String id;

	private String name;

	private String contextDir;
	
	private String homeDir;
	
	private boolean disableCreateClassLoader;

	private ClassLoader classLoader;

	private ApplicationManager applicationManager;

	/*
	 * Application Def 원본
	 */
	private ApplicationDef applicationDef;

	// private HashMap<String, String> properties = new HashMap<String, String>();

	public ApplicationContext(ApplicationManager manager) {
		this.applicationManager = manager;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getContextDir() {
		return contextDir;
	}

	public void setContextDir(String contextDir) {
		this.contextDir = contextDir;
	}
	
	public String getHomeDir() {
		return homeDir;
	}

	public void setHomeDir(String homeDir) {
		this.homeDir = homeDir;
	}

	public ClassLoader getClassLoader() {
		return classLoader;
	}

	public void setClassLoader(ClassLoader classLoader) {
		this.classLoader = classLoader;
	}

	public RoutingContext getRoutingContext() {
		RoutingManager routingManager = applicationManager.getRoutingManager();
		return new DefaultRoutingContext(this, routingManager);
	}



	/*
	 * public void setProperties(HashMap<String, String> properties) {
	 * this.properties = properties; }
	 *
	 * public void putProperty(String key, String value) { properties.put(key,
	 * value); }
	 *
	 * public String getProperty(String key) { return properties.get(key); }
	 */

	public ApplicationDef getApplicationDef() {
		return applicationDef;
	}

	public void setApplicationDef(ApplicationDef applicationDef) {
		this.applicationDef = applicationDef;
	}

	public boolean isDisableCreateClassLoader() {
		return disableCreateClassLoader;
	}

	public void setDisableCreateClassLoader(boolean disableCreateClassLoader) {
		this.disableCreateClassLoader = disableCreateClassLoader;
	}

	public ApplicationManager getApplicationManager() {
		return applicationManager;
	}
	
	public URL getResource(String name){
		
		URL url = null;
		try{
			url = new URL("file://"+contextDir + "/" + name);
		}catch(Exception e){
			throw new RuntimeException(e.getMessage(), e);
		}
		return url;
	}

	
	
	
}
