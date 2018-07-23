<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.util.PropertiesEx" %>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%@ page import="java.util.Properties"%>
<%@ page import="kr.co.bizframe.persistence.db.BfPasswordCipher"%>
<%
	/**
	 * dbpools.properties 업데이트
	 * (Etax Client에서 사용하기 위해 추가)
	 * 
	 * @version 1.0, 2010.01.21
	 * @author Hakju Oh
	 */
	String path = session.getServletContext().getRealPath("/WEB-INF/classes/dbpools.properties");
	
	Properties props = new Properties();

	props.setProperty("db.pools", "mxs");
	
	String driver = StringUtil.nullCheck(request.getParameter("db.pool.mxs.driver"));
	if("".equals(driver))
		driver = StringUtil.nullCheck(request.getParameter("_db.pool.mxs.driver"));
	props.setProperty("db.drivers", driver);
	props.setProperty("db.pool.mxs.driver", driver);
	props.setProperty("db.pool.mxs.url", StringUtil.nullCheck(request.getParameter("db.pool.mxs.url")));
	props.setProperty("db.pool.mxs.user", StringUtil.nullCheck(request.getParameter("db.pool.mxs.user")));
	
	String password = request.getParameter("db.pool.mxs.password");
	password = (password == null) ? "" : password.trim();
	
	String cipher = request.getParameter("db.pool.mxs.cipher");
	cipher = (cipher == null) ? "" : cipher.trim();
	
	if(!"".equals(password)) {
		if("true".equals(cipher)) {
			BfPasswordCipher c = new BfPasswordCipher();
			password = c.encode(password);
		}
		props.setProperty("db.pool.mxs.password", password);
	} 
	
	props.setProperty("db.pool.mxs.decoder", ("true".equals(cipher)) ? BfPasswordCipher.class.getName() : "");
	props.setProperty("db.pool.mxs.maxpool", StringUtil.nullCheck(request.getParameter("db.pool.mxs.maxpool")));
	props.setProperty("db.pool.mxs.maxconn", StringUtil.nullCheck(request.getParameter("db.pool.mxs.maxconn")));
	props.setProperty("db.pool.mxs.logfile", StringUtil.nullCheck(request.getParameter("db.pool.mxs.logfile")));
	props.setProperty("db.pool.mxs.init", StringUtil.nullCheck(request.getParameter("db.pool.mxs.init")));
	props.setProperty("db.pool.mxs.expiration", StringUtil.nullCheck(request.getParameter("db.pool.mxs.expiration")));
	props.setProperty("db.pool.mxs.timeout", StringUtil.nullCheck(request.getParameter("db.pool.mxs.timeout")));
	props.setProperty("db.pool.mxs.cache", StringUtil.nullCheck(request.getParameter("db.pool.mxs.cache")));
	
	PropertiesEx.save(path, props);
%>

