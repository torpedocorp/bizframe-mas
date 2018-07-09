package kr.co.bizframe.mas.application;

import java.util.HashMap;

public class ApplicationDef {

	private String id;

	private String name;

	// 기본 자동 시작 설정-> true
	private boolean autoStart = true;

	private int priority = 0;
	
	private String contextDir;

	private String loadClass;

	private boolean parentOnlyClassLoader;

	private boolean parentFirstClassLoader;

	private boolean unpackMar = false; 
	
	private HashMap<String, String> properties = new HashMap<String, String>();

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

	
	public boolean isUnpackMar() {
		return unpackMar;
	}

	public void setUnpackMar(boolean unpackMar) {
		this.unpackMar = unpackMar;
	}

	public String getContextDir() {
		return contextDir;
	}

	public void setContextDir(String contextDir) {
		this.contextDir = contextDir;
	}

	public String getLoadClass() {
		return loadClass;
	}

	public void setLoadClass(String loadClass) {
		this.loadClass = loadClass;
	}

	public HashMap<String, String> getProperties() {
		return properties;
	}

	public void setProperties(HashMap<String, String> properties) {
		this.properties = properties;
	}

	public void putProperty(String key, String value) {
		properties.put(key, value);
	}

	public String getProperty(String key) {
		return properties.get(key);
	}



	public boolean isParentOnlyClassLoader() {
		return parentOnlyClassLoader;
	}

	public void setParentOnlyClassLoader(boolean parentOnlyClassLoader) {
		this.parentOnlyClassLoader = parentOnlyClassLoader;
	}

	public boolean isParentFirstClassLoader() {
		return parentFirstClassLoader;
	}

	public void setParentFirstClassLoader(boolean parentFirstClassLoader) {
		this.parentFirstClassLoader = parentFirstClassLoader;
	}

	public boolean isAutoStart() {
		return autoStart;
	}

	public void setAutoStart(boolean autoStart) {
		this.autoStart = autoStart;
	}

	public int getPriority() {
		return priority;
	}

	public void setPriority(int priority) {
		this.priority = priority;
	}

	@Override
	public String toString() {
		return "ApplicationDef [contextDir=" + contextDir
				+ ", id=" + id + ", loadClass=" + loadClass + ", name=" + name
				+ ", properties=" + properties + "]";
	}


}
