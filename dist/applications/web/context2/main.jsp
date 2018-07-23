<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsConstants" %>
<%
/**
 * @author Jae-Heon Kim
 * @author Ho-Jin Seo
 * @version 1.0
 */
 String menuLink = "com00en002.jsp?mod=ebms";
 String contentLink = "msg20ms001.jsp";

 if (!MxsConstants.EB_MOD_SUPPORTED && MxsConstants.WS_MOD_SUPPORTED) {
	 menuLink = "com00en002.jsp?mod=wsms";
	 contentLink = "wsd20ms001.jsp";
 }
%>
<html>
<head>
<%@ include file="./com00in000.jsp" %>
<%@ include file="./com00in003.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>
</head>

<frameset rows="91, *, 51" border="0">
    <frame name="header" scrolling="no" marginwidth="0" marginheight="0" src="com00en001.jsp" noresize>
    <frameset cols="195, *, 3" border="0">
		<frame name="menu" scrolling="no" marginwidth="0" marginheight="0" src="<%=menuLink %>" noresize>
		<frame name="contents" scrolling="auto" src="<%=contentLink %>">
		<frame src="com00en003.jsp" scrolling="no" marginwidth="0" marginheight="0">
    </frameset>
    <frame name="footer" scrolling="no" marginwidth="0" marginheight="0" src="com00en004.jsp" noresize>
</frameset>
<noframes>
	<body bgcolor="white" text="black" link="blue" vlink="purple" alink="red">
	<p>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</p>
	</body>
</noframes>
</html>
