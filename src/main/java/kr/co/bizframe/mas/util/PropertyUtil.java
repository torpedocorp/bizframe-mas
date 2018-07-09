package kr.co.bizframe.mas.util;

public class PropertyUtil {

	public static String getString(String value, String defaultValue) {
		return (value == null || "".equals(value)) ? defaultValue : value;
	}

	public static int getInt(String value, int defaultValue) {
		try {
			return (value != null) ? Integer.parseInt(value) : defaultValue;
		} catch (NumberFormatException e) {
			return 0;
		}
	}

	public static long getLongProperty(String value, long defaultValue) {
		try {
			return (value != null) ? Long.parseLong(value) : defaultValue;
		} catch (NumberFormatException e) {
			return 0;
		}
	}

	public static boolean getBooleanProperty(String value, boolean defaultValue) {
		return (value != null) ? (("true".equalsIgnoreCase(value)) ? true
				: false) : defaultValue;
	}

}
