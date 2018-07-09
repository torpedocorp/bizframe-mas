package kr.co.bizframe.mas.conf.bind;

public class Application {

	private String contextPath;

	public String getContextPath() {
		return contextPath;
	}

	public void setContextPath(String contextPath) {
		this.contextPath = contextPath;
	}

	@Override
	public String toString() {
		return "Application [contextPath=" + contextPath + "]";
	}

}
