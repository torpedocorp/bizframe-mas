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
<%
	/**
	 * clear log buffer
	 *
	 * @version 1.0 2009.06.19
	 * @author Ho-Jin Seo
	 */
	 
	String id = StringUtil.checkNull(request.getParameter("id"));
	
	if (id.length() == 0) {
		return;
	}

	LoggerManager mgr = LoggerManager.getInstance();
	Log4JAppenderAccessor lacc = (Log4JAppenderAccessor)mgr.getLogAccessor(id);
	
	if (lacc == null)
		return;
	
	TailingFile ff = (TailingFile) request.getSession(true).getAttribute("log" + id);
	
    if (ff != null) {
   		ff.getLines().clear();
   	}
%>