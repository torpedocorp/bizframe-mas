<%@ page contentType="text/html; charset=EUC-KR" language="java"%>

<%@ page import="java.io.File"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="org.apache.log4j.Logger"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="org.apache.log4j.Appender"%>
<%@ page import="kr.co.bizframe.logging.CommonsLoggerAccessor"%>
<%@ page import="kr.co.bizframe.logging.Log4JAppenderAccessor"%>
<%@ page import="kr.co.bizframe.logging.Log4JLoggerAccessor"%>
<%@ page import="kr.co.bizframe.logging.Log4JManagerAccessor"%>
<%@ page import="kr.co.bizframe.logging.LoggerManager"%>
<%@ page import="kr.co.bizframe.logging.TailingFile"%>
<%@ page import="kr.co.bizframe.logging.BackwardsFileStream"%>
<%@ page import="kr.co.bizframe.logging.BackwardsLineReader"%>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
	/**
	 * log information
	 *
	 * @version 1.0 2009.06.19
	 * @author Ho-Jin Seo
	 */
	 
	String id = StringUtil.checkNull(request.getParameter("id"));

	LoggerManager mgr = LoggerManager.getInstance();
	Log4JAppenderAccessor lacc = (Log4JAppenderAccessor)mgr.getLogAccessor(id);
	
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
	JSONObject json = new JSONObject();

	if (lacc != null) {
		json.put("logClass", lacc.getLogClass());
		json.put("filepath", lacc.getFile().getAbsolutePath());
		json.put("logSize", lacc.getSize());
		json.put("lastModified", sdf.format(lacc.getLastModified()));
		json.put("logType", lacc.getType());
	} else {
		json.put("logClass", "");
		json.put("filepath", "");
		json.put("logSize", 0);
		json.put("lastModified", "");
		json.put("logType", "");
	}
	out.print(json);			
%>