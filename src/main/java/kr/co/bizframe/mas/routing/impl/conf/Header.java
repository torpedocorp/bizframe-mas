package kr.co.bizframe.mas.routing.impl.conf;

import org.jdom.Element;

public class Header extends ConditionItem {

	private String key;

	private String value;

	public void parse(Element ele) throws Exception {

		String key = ele.getAttributeValue("key");
		if (key == null) {
			throw new Exception("key value is null.");
		}
		String value = ele.getAttributeValue("value");

		setKey(key);
		setValue(value);
	}

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	@Override
	public String toString() {
		return " Header [key=" + key + ", value=" + value + "]";
	}
}