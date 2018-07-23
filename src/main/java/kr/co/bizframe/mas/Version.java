package kr.co.bizframe.mas;

public class Version {

	private static final String PRODUCT_NAME = "BizFrame MAS platform";

	private static final String PRODUCT_VERSION = "2.0.0";

	public static String getVersion() {
		return PRODUCT_NAME + " " + PRODUCT_VERSION;
	}
}
