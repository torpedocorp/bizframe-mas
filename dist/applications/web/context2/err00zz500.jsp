<%@ page contentType="text/html; charset=EUC-KR" language="java" %>
<%@ page isErrorPage="true" %>
<%@ page import="java.io.StringWriter" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="kr.co.bizframe.mxs.web.ErrorReport" %>
<html>
<head>
<%@include file="./com00in000.jsp" %>
<title><%=_i18n.get("err00zz500.page.title")%></title>
<%

/**
 * @author Jae-Heon Kim
 * @version 1.0
 */

String curPage = (String)session.getAttribute("_currentPage");
String prevPage = (String)session.getAttribute("_previousPage");
String errStr = "";

%>
<link href="./css/error.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="js/error.js"> </script>

<script language="JavaScript" type="text/JavaScript">
function showError2(msg, title, okStr, cancelStr) {
	if (okStr == null || okStr == '') {
		okStr = "<%=_i18n.get("err00zz500.ok")%>";
	}
	if (cancelStr == null || cancelStr == '') {
		cancelStr = "<%=_i18n.get("err00zz500.cancel")%>";
	}
	if (title == null || title == '') {
		title = "<%=_i18n.get("err00zz500.title")%>";
	}
	_showError(msg, title, okStr, cancelStr);
}

function popupError() {
	showError2(document.getElementById("errtxt").value);
}
window.onload=popupError;
</script>
</head>
<%
if (exception != null) {
	StringWriter sw = new StringWriter();
	PrintWriter pw = new PrintWriter(sw);
	exception.printStackTrace(pw);
	errStr = sw.toString();

	System.out.println(errStr);
%>

<textarea id = "errtxt" style="width:50%; height: 100px;">
	<%=errStr%>
</textarea>
<%
}

String forwardRequestUri
	= (String)pageContext.getAttribute("javax.servlet.forward.request_uri",
								PageContext.REQUEST_SCOPE);
if (forwardRequestUri == null) {
	forwardRequestUri = "";
}
String forwardContextPath
	= (String)pageContext.getAttribute("javax.servlet.forward.context_path",
								PageContext.REQUEST_SCOPE);
if (forwardContextPath == null) {
	forwardContextPath = "";
}
String forwardServletPath
	= (String)pageContext.getAttribute("javax.servlet.forward.servlet_path",
									PageContext.REQUEST_SCOPE);
if (forwardServletPath == null) {
	forwardServletPath = "";
}
String forwardPathInfo
	= (String)pageContext.getAttribute("javax.servlet.forward.path_info",
									PageContext.REQUEST_SCOPE);
if (forwardPathInfo == null) {
	forwardPathInfo = "";
}
String errorServletName
	= (String)pageContext.getAttribute("javax.servlet.error.servlet_name",
									PageContext.REQUEST_SCOPE);
if (errorServletName == null) {
	errorServletName = "";
}
String errorMessage
	= (String)pageContext.getAttribute("javax.servlet.error.message",
									PageContext.REQUEST_SCOPE);
if (errorMessage == null) {
	errorMessage = "";
}
// For Tomcat 4.1.3 Exception is returned,
// while for Tomcat 5.5.17 javax.servlet.ServletException is returned
Exception errorException
	= (Exception)pageContext.getAttribute("javax.servlet.error.exception",
									PageContext.REQUEST_SCOPE);
Object errorExceptionType
	= pageContext.getAttribute("javax.servlet.error.exception_type",
									PageContext.REQUEST_SCOPE);
String errorRequestUri
	= (String)pageContext.getAttribute("javax.servlet.error.request_uri",
									PageContext.REQUEST_SCOPE);
Integer errorStatusCode
	= (Integer)pageContext.getAttribute("javax.servlet.error.status_code",
									PageContext.REQUEST_SCOPE);
String jspClasspath
	= (String)pageContext.getAttribute("org.apache.catalina.jsp_classpath",
									PageContext.APPLICATION_SCOPE);

%>
<body>
<form name="errorReport" action="sys00ac001.jsp" method="POST">
	<input type="hidden" id="command" name="command" value="">
</form>
<!--table width="980" border="0" cellspacing="0" cellpadding="0"-->
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" valign="top" bgcolor="#d6d6d6">
<table width="100%" border="0" cellspacing="1" cellpadding="2">
	<tr align="center" valign="middle" bgcolor="#eff4fb" class="gray_bold">
	<td width="200" height="20" bgcolor="#eff4fb"><%=_i18n.get("err00zz500.param")%></td>
	<td width="440" height="20" bgcolor="#eff4fb"><%=_i18n.get("err00zz500.value")%></td>
	<td width="340" height="20" bgcolor="#eff4fb"><%=_i18n.get("err00zz500.type")%></td>
	</tr>

<tr align="left" valign="middle" bgcolor="#FFFFFF" class="gray-text">
<td height="18" bgcolor="#FFFFFF">forward.request_uri</td>
<td height="18" bgcolor="#FFFFFF"><%=forwardRequestUri%></td>
<td height="18" bgcolor="#FFFFFF"><%=forwardRequestUri.getClass().getName()%></td>
</tr>

<tr align="left" valign="middle" bgcolor="#FFFFFF" class="gray-text">
<td height="18" bgcolor="#FFFFFF">forward.context_path</td>
<td height="18" bgcolor="#FFFFFF"><%=forwardContextPath%></td>
<td height="18" bgcolor="#FFFFFF"><%=forwardContextPath.getClass().getName()%></td>
</tr>

<tr align="left" valign="middle" bgcolor="#FFFFFF" class="gray-text">
<td height="18" bgcolor="#FFFFFF">forward.servlet_path</td>
<td height="18" bgcolor="#FFFFFF"><%=forwardServletPath%></td>
<td height="18" bgcolor="#FFFFFF"><%=forwardServletPath.getClass().getName()%></td>
</tr>

<tr align="left" valign="middle" bgcolor="#FFFFFF" class="gray-text">
<td height="18" bgcolor="#FFFFFF">forward.path_info</td>
<td height="18" bgcolor="#FFFFFF"><%=forwardPathInfo%></td>
<td height="18" bgcolor="#FFFFFF"><%=forwardPathInfo.getClass().getName()%></td>
</tr>

<tr align="left" valign="middle" bgcolor="#FFFFFF" class="gray-text">
<td height="18" bgcolor="#FFFFFF">error.servlet_name</td>
<td height="18" bgcolor="#FFFFFF"><%=errorServletName%></td>
<td height="18" bgcolor="#FFFFFF"><%=errorServletName.getClass().getName()%></td>
</tr>

<tr align="left" valign="middle" bgcolor="#FFFFFF" class="gray-text">
<td height="18" bgcolor="#FFFFFF">error.message</td>
<td height="18" bgcolor="#FFFFFF"><pre><%=
	pageContext.getAttribute("javax.servlet.error.message",
									PageContext.REQUEST_SCOPE)
	%></pre></td>
<td height="18" bgcolor="#FFFFFF"><%=errorMessage.getClass().getName()%></td>
</tr>

<tr align="left" valign="middle" bgcolor="#FFFFFF" class="gray-text">
<td height="18" bgcolor="#FFFFFF">error.exception</td>
<td height="18" bgcolor="#FFFFFF"><%=errorException%></td>
<td height="18" bgcolor="#FFFFFF"><%=errorException.getClass().getName()%></td>
</tr>

<tr align="left" valign="middle" bgcolor="#FFFFFF" class="gray-text">
<td height="18" bgcolor="#FFFFFF">error.exception_type</td>
<td height="18" bgcolor="#FFFFFF"><%=errorExceptionType%></td>
<td height="18" bgcolor="#FFFFFF"><%=errorExceptionType.getClass().getName()%></td>
</tr>

<tr align="left" valign="middle" bgcolor="#FFFFFF" class="gray-text">
<td height="18" bgcolor="#FFFFFF">error.request_uri</td>
<td height="18" bgcolor="#FFFFFF"><%=errorRequestUri%></td>
<td height="18" bgcolor="#FFFFFF"><%=errorRequestUri.getClass().getName()%></td>
</tr>

<tr align="left" valign="middle" bgcolor="#FFFFFF" class="gray-text">
<td height="18" bgcolor="#FFFFFF">error.status_code</td>
<td height="18" bgcolor="#FFFFFF"><%=errorStatusCode%></td>
<td height="18" bgcolor="#FFFFFF"><%=errorStatusCode.getClass().getName()%></td>
</tr>

<tr align="left" valign="middle" bgcolor="#FFFFFF" class="gray-text">
<td height="18" bgcolor="#FFFFFF">jsp_classpath</td>
<td width=440 class=td_wrap height="18" bgcolor="#FFFFFF"><pre><%=jspClasspath%></pre></td>
<td height="18" bgcolor="#FFFFFF"><%=jspClasspath.getClass().getName()%></td>
</tr>

</table>


     </td>
</tr>
</table>

<%

ErrorReport er = new ErrorReport();
er.setForwardRequestUri(forwardRequestUri);
er.setForwardContextPath(forwardContextPath);
er.setForwardServletPath(forwardServletPath);
er.setForwardPathInfo(forwardPathInfo);
er.setErrorServletName(errorServletName);
er.setErrorMessage(errorMessage);
er.setErrorException(errorException);
er.setErrorExceptionType(errorExceptionType);
er.setErrorRequestUri(errorRequestUri);
er.setErrorStatusCode(errorStatusCode);
er.setJspClasspath(jspClasspath);
er.setStackTrace(errStr);

session.setAttribute("_errorReport", er);

%>
</body>
</html>
