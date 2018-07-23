<%@ page contentType="text/html; charset=EUC-KR" language="java" %>
<%@ page import="kr.co.bizframe.util.PropertiesEx"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>

<%
	/**
	 * dbpools.properties 정보 추출
	 * (Etax Client에서 사용하기 위해 추가)
	 * 
	 * @version 1.0, 2010.01.21
	 * @author Hakju Oh
	 */
	String path = session.getServletContext().getRealPath(
		"/WEB-INF/classes/dbpools.properties");

	PropertiesEx props = new PropertiesEx();
	props.load(path);
	
	JSONObject json = new JSONObject();
	json.put("driver", props.getProperty("db.pool.mxs.driver", "oracle.jdbc.driver.OracleDriver"));
	json.put("url", props.getProperty("db.pool.mxs.url", ""));
	
	json.put("user", props.getProperty("db.pool.mxs.user", ""));
	json.put("password", props.getProperty("db.pool.mxs.password", ""));
	
	json.put("maxpool", props.getProperty("db.pool.mxs.maxpool", "5"));
	json.put("maxconn", props.getProperty("db.pool.mxs.maxconn", "20"));
	
	//json.put("logfile", props.getProperty("db.pool.mxs.logfile", "dbpool_etax.log"));
	json.put("init", props.getProperty("db.pool.mxs.init", "0"));
	json.put("expiration", props.getProperty("db.pool.mxs.expiration", "0"));
	json.put("timeout", props.getProperty("db.pool.mxs.timeout", "30"));
	json.put("cache", props.getProperty("db.pool.mxs.cache", "false"));
	json.put("decoder", props.getProperty("db.pool.mxs.decoder", ""));
	
	out.print(json);
	
%>