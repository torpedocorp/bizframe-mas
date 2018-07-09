package kr.co.bizframe.mas.routing.impl.conf;

import org.jdom.Element;

public class Path {

	private Condition condition;

	private Application application;

	public Element toElement() throws Exception {
		return null;
	}

	public void parse(Element ele) throws Exception {

		Element conditionEle = ele.getChild("condition");
		if (conditionEle == null) {
			throw new Exception("condition element is null.");
		}
		Condition condition = new Condition();
		condition.parse(conditionEle);
		this.condition = condition;

		Element applicationEle = ele.getChild("application");
		if (applicationEle == null) {
			throw new Exception("application element is null.");
		}
		Application application = new Application();
		application.parse(applicationEle);
		this.application = application;

		String appId = application.getId();
		// /////////////////////////////////////
		// 실제 appId가 존재하는지 체크
		// /////////////////////////////////////

		this.application = application;
	}

	public Condition getCondition() {
		return condition;
	}

	public void setCondition(Condition condition) {
		this.condition = condition;
	}

	public Application getApplication() {
		return application;
	}

	public void setApplication(Application application) {
		this.application = application;
	}

	@Override
	public String toString() {
		return "Path [application=" + application + ", condition=" + condition
				+ "]";
	}

}
