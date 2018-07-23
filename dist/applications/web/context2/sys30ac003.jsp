<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.util.PropertiesEx" %>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%@ page import="java.util.Properties"%>
<%
	/**
	 * update dbpools.properties
	 *
	 * @author Ho-Jin Seo
	 * @version 1.0
	 */
	String path = session.getServletContext().getRealPath("/WEB-INF/classes/dbpools.properties");
	
	Properties props = new Properties();
	
	props.setProperty("db.pool.mxs.driver", StringUtil.nullCheck((String)request.getParameter("db.pool.mxs.driver")));
	props.setProperty("db.pool.mxs.url", StringUtil.nullCheck((String)request.getParameter("db.pool.mxs.url")));
	props.setProperty("db.pool.mxs.user", StringUtil.nullCheck((String)request.getParameter("db.pool.mxs.user")));
	props.setProperty("db.pool.mxs.password", StringUtil.nullCheck((String)request.getParameter("db.pool.mxs.password")));
	props.setProperty("db.pool.mxs.maxpool", StringUtil.nullCheck((String)request.getParameter("db.pool.mxs.maxpool")));
	props.setProperty("db.pool.mxs.maxconn", StringUtil.nullCheck((String)request.getParameter("db.pool.mxs.maxconn")));
	props.setProperty("db.pool.mxs.logfile", StringUtil.nullCheck((String)request.getParameter("db.pool.mxs.logfile")));
	
	PropertiesEx.save(path, props);
%>

