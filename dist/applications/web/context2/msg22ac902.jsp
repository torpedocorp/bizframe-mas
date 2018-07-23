<%@ page contentType="text/html; charset=EUC-KR" language="java" %>
<%@ page import="kr.co.bizframe.mxs.web.I18nStrings"%>
<%
	String err = request.getParameter("err");
    String isClose = request.getParameter("close");

    I18nStrings i18n = I18nStrings.getInstance();
%>
	<script>
		alert("<%=i18n.get(err)%>");
<%
    if (isClose.equals("1")) {
%>
 		self.close();
<%
    } else {
%>
	history.go(-2);
<%
    }
%>
	</script>