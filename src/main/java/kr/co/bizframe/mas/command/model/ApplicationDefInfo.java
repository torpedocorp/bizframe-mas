package kr.co.bizframe.mas.command.model;

import java.io.Serializable;

public class ApplicationDefInfo implements Serializable{

	private static final long serialVersionUID = -6816176400575038755L;

	private String id;

	private String name;

	private boolean autoStart = true;

	private int priority = 0;

	private String contextDir;

	private String loadClass;

	private boolean parentOnlyClassLoader;

	private boolean parentFirstClassLoader;

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

	@Override
	public String toString() {
		return "ApplicationDefInfo [id=" + id + ", name=" + name
				+ ", autoStart=" + autoStart + ", priority=" + priority
				+ ", contextDir=" + contextDir + ", loadClass=" + loadClass
				+ ", parentOnlyClassLoader=" + parentOnlyClassLoader
				+ ", parentFirstClassLoader=" + parentFirstClassLoader + "]";
	}

	
}
