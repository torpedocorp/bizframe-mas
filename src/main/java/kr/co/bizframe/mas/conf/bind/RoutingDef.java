package kr.co.bizframe.mas.conf.bind;

public class RoutingDef {

	private boolean enable = false;

	private String className;

	public boolean getEnable() {
		return enable;
	}

	public void setEnable(boolean enable) {
		this.enable = enable;
	}

	public String getClassName() {
		return className;
	}

	public void setClassName(String className) {
		this.className = className;
	}

	@Override
	public String toString() {
		return "RoutingDef [className=" + className + ", enable=" + enable
				+ "]";
	}

}
