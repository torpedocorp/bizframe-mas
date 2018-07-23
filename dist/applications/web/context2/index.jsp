<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%
String session_status = (String)session.getAttribute("status");
String redirect = "ses00ms001.jsp";
if(session_status != null && session.getAttribute("passwd") != null) {
	redirect = "main.jsp";
} 
%>
<script>
location.href="<%=redirect%>";
</script>