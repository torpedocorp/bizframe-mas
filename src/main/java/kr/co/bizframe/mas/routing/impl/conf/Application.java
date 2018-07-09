package kr.co.bizframe.mas.routing.impl.conf;

import java.util.HashMap;
import java.util.List;

import org.jdom.Element;

public class Application implements RouteItem {

	private String id;

	private HashMap<String, String> properties = new HashMap<String, String>();

	public Element toElement() throws Exception {
		return null;
	}

	public void parse(Element ele) throws Exception {

		String id = ele.getAttributeValue("id");
		this.id = id;

		List<Element> propertiesEle = ele.getChildren("property");
		for (Element propertyEle : propertiesEle) {

			String key = propertyEle.getAttributeValue("key");
			String value = propertyEle.getAttributeValue("value");

			addProperty(key, value);
		}
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public void addProperty(String key, String value) {
		properties.put(key, value);
	}

	public String getProperty(String key) {
		return (String) properties.get(key);
	}

	public HashMap<String, String> getProperties() {
		return properties;
	}

	public void checkValidity() {

	}

	@Override
	public String toString() {
		return "Application [id=" + id + ", properties=" + properties + "]";
	}

}
