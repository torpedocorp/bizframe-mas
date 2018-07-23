<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.util.HashEncryption" %>
<%@ page import="kr.co.bizframe.util.ServerProperties" %>
<%
/**
 * update user
 *
 * @author M.K JUNG
 * @version 1.0
 */

	String passwd = request.getParameter("passwd");
	if (passwd != null && !passwd.equals(""))
		passwd = HashEncryption.getInstance().encryptSHA1(passwd);

	ServerProperties props = ServerProperties.getInstance();
	props.setProperty("mxs.admin.password", passwd);

	String path = session.getServletContext().getRealPath(
		"/WEB-INF/classes/mxs.properties");

	ServerProperties.save(path, props);
%>

