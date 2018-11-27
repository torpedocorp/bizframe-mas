package kr.co.bizframe.mas.util;

import java.text.SimpleDateFormat;
import java.util.Date;

public class TimeUtil {

	public static String getTimeStamp(long time) {
	    SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	    Date t = new Date(time);
	    String strDate = sdfDate.format(t);
	    return strDate;
	}
	
	
	public static String getCurrentTimeStamp() {
	    SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	    Date now = new Date();
	    String strDate = sdfDate.format(now);
	    return strDate;
	}
	
}
