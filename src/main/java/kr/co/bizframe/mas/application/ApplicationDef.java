package kr.co.bizframe.mas.application;

import java.util.HashMap;

public class ApplicationDef {

	private String id;

	private String name;

	// 기본 자동 deploy 설정-> true
	private boolean autoDeploy = true;
		
	// 기본 자동 시작 설정-> true
	private boolean autoStart = true;

	private int loadSequence = 0;
	
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
	
	
	public boolean isAutoDeploy() {
		return autoDeploy;
	}

	public void setAutoDeploy(boolean autoDeploy) {
		this.autoDeploy = autoDeploy;
	}

	public boolean isAutoStart() {
		return autoStart;
	}

	public void setAutoStart(boolean autoStart) {
		this.autoStart = autoStart;
	}

	public int getLoadSequence() {
		return loadSequence;
	}

	public void setLoadSequence(int sequence) {
		this.loadSequence = sequence;
	}

	@Override
	public String toString() {
		return "ApplicationDef [id=" + id + ", name=" + name + ", autoDeploy=" + autoDeploy + ", autoStart=" + autoStart
				+ ", loadSequence=" + loadSequence + ", contextDir=" + contextDir + ", loadClass=" + loadClass
				+ ", parentOnlyClassLoader=" + parentOnlyClassLoader + ", parentFirstClassLoader="
				+ parentFirstClassLoader + ", unpackMar=" + unpackMar + ", properties=" + properties + "]";
	}

	
	


}
