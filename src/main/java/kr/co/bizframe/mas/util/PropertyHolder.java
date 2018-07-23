package kr.co.bizframe.mas.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

public class PropertyHolder {

	protected HashMap<String, Object> properties = new HashMap<String, Object>();

	public HashMap<String, Object> getProperties() {
		return properties;
	}

	public void setProperties(HashMap<String, String> properties) {
		this.properties.clear();
		this.properties.putAll(properties);
	}

	public void addProperties(HashMap<String, String> properties) {
		this.properties.putAll(properties);
	}
	
	public void addPropertie(String key, Object value) {
		this.properties.put(key, value);
	}

	public Object getObjectProperty(String key) {
		return properties.get(key);
	}
	
	
	public List<String> getPropertiesKey(String keyPrefix){
		
		List<String> propsKeys = new ArrayList<String>();
		if(keyPrefix == null) return null;
		Set<String> keySet = properties.keySet();
		Iterator<String> keys = keySet.iterator();
		while(keys.hasNext()){
			
			String key = keys.next();
			if(key.startsWith(keyPrefix)){
				propsKeys.add(key);
			}
		}
		
		return propsKeys;
	}
	
	public String getProperty(String key) {
		Object value0 = properties.get(key);
		if (value0 == null) {
			return null;
		}
		return (String) value0;
	}

	public void setProperty(String key, String value) {
		this.properties.put(key, value);
	}

	public String getProperty(String key, String defaultValue) {
		if (key == null)
			throw new NullPointerException();
		String value = getProperty(key);
		return (value == null || "".equals(value)) ? defaultValue : value;
	}

	public int getIntProperty(String key) {
		String value = getProperty(key);
		try {
			return Integer.parseInt(value);
		} catch (NumberFormatException e) {
			return 0;
		}
	}

	public int getIntProperty(String key, int defaultValue) {
		String value = getProperty(key);
		try {
			return (value != null) ? Integer.parseInt(value) : defaultValue;
		} catch (NumberFormatException e) {
			return 0;
		}
	}

	public long getLongProperty(String key) {
		String value = getProperty(key);
		try {
			return Long.parseLong(value);
		} catch (NumberFormatException e) {
			return 0;
		}
	}

	public long getLongProperty(String key, long defaultValue) {
		String value = getProperty(key);
		try {
			return (value != null) ? Long.parseLong(value) : defaultValue;
		} catch (NumberFormatException e) {
			return 0;
		}
	}

	public boolean getBooleanProperty(String key) {
		String value = getProperty(key);
		return ("true".equalsIgnoreCase(value)) ? true : false;
	}

	public boolean getBooleanProperty(String key, boolean defaultValue) {
		String value = getProperty(key);
		return (value != null) ? (("true".equalsIgnoreCase(value)) ? true : false) : defaultValue;
	}

	public void clear() {
		properties.clear();
	}

}
