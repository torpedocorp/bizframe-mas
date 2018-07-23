<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsConstants" %>
<%
/**
 * @author Jae-Heon Kim
 * @author Ho-Jin Seo
 * @version 1.0
 */


String module = request.getParameter("mod");

if (module == null || module.length() == 0) {
	module = "";
}

String mainpage = "";
%>
<html>
<head>
<%@ include file="./com00in000.jsp" %>
<%@ include file="./com00in003.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>
<script>
<!--
function changeInfo() {
	window.open("usr22ms001.jsp", "", "width=450,height=250,left=0,top=0,resizable=no,scrollbars=yes");
}
//-->
</script>
</head>
<body style="margin:0 0 0 0" bgcolor="#F3F4F6">

<table width="195" height="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#F3F4F6">
  <tr>
    <td height="98" valign="middle" background="./images/login_bg.gif"><table width="190" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td class="login_text"><%=_i18n.get("global.user")%>
			<br>(<%= (String)session.getAttribute("userid")%>)
		</td>
      </tr>
      <tr>
          <td class="login_btn"><a href="javascript:changeInfo()"><img src="./images/btn_change.gif" width="67" height="18" border="0"></a>
            <a href="ses00ac002.jsp"><img src="./images/btn_logout.gif" width="62" height="18" border="0"></a></td>
      </tr>
    </table></td>
  </tr>
  <tr>
    <td height=3> <img src="./images/left_bar.gif" width="195" height="2"></td>
  </tr>
  <tr>
	  <td valign="top"  style="padding:15px 12 30 13">
<%
if (module.equals("ebms")) {
	mainpage = "msg20ms001.jsp";
%>

	  <table width="170" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td height="27"> <h1><a href="msg20ms001.jsp" class="left" target=contents><%=_i18n.get("menu.msg")%></a></h1></td>
        </tr>
        <tr>
          <td><img src="./images/left_barline.gif" width="170" height="1"></td>
        </tr>
		</table>
<%
} else if (module.equals("ebms3")) {
	mainpage = "msg20ms301.jsp";
%>

	  <table width="170" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td height="27"> <h3><%=_i18n.get("menu.msg")%></h3></td>
        </tr>
		<tr>
          <td><img src="./images/left_barline.gif" width="170" height="1"></td>
        </tr>
		<tr>
              <td height="5"></td>
		</tr>
         <tr>
		   <td><h2><a href="msg20ms301.jsp" target=contents><%=_i18n.get("menu.msg.usermessage")%></a></h2></td>
          </tr>
          <tr>
			<td><h2><a href="msg20ms401.jsp" target=contents><%=_i18n.get("menu.msg.signalmessage")%></a></h2></td>
		  </tr>
        <tr>
          <td><img src="./images/left_barline.gif" width="170" height="1"></td>
        </tr>
		</table>
<%
} else if (module.equals("ebms_common")) {
	mainpage = "cpa20ms001.jsp";
%>
	  <table width="170" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><img src="./images/left_barline.gif" width="170" height="1"></td>
        </tr>
        <tr>
          <td height="27"> <h3><%=_i18n.get("menu.agreement")%></h3></td>
        </tr>
		<tr>
          <td><img src="./images/left_barline.gif" width="170" height="1"></td>
        </tr>
		<tr>
              <td height="5"></td>
		</tr>
         <tr>
		   <td><h2><a href="cpa20ms001.jsp" target=contents><%=_i18n.get("menu.agreement.cpa")%></a></h2></td>
          </tr>
		  <tr>
			<td><h2><a href="pmd20ms001.jsp" target=contents><%=_i18n.get("menu.agreement.pmode")%></a></h2></td>
		  </tr>
          <tr>
			<td><h2><a href="agr20ms001.jsp" target=contents><%=_i18n.get("menu.agreement.ref")%></a></h2></td>
		  </tr>
        <tr>
          <td><img src="./images/left_barline.gif" width="170" height="1"></td>
        </tr>
        <tr>
          <td height="27"> <h3><%=_i18n.get("menu.msi")%></h3></td>
        </tr>
		<tr>
          <td><img src="./images/left_barline.gif" width="170" height="1"></td>
        </tr>
		<tr>
              <td height="5"></td>
		</tr>
         <tr>
		   <td><h2><a href="msi20ms001.jsp" target=contents><%=_i18n.get("menu.msi.cpa.performer")%></a></h2></td>
          </tr>
		  <tr>
		   <td><h2><a href="msi20ms301.jsp" target=contents><%=_i18n.get("menu.msi.pmode.performer")%></a></h2></td>
          </tr>
          <tr>
			<td><h2><a href="msi20ms101.jsp" target=contents><%=_i18n.get("menu.msi.queue")%></a></h2></td>
		  </tr>
		  <tr>
			<td><h2><a href="msi20ms201.jsp" target=contents><%=_i18n.get("menu.msi.subscriber")%></a></h2></td>
		  </tr>
        <tr>
          <td><img src="./images/left_barline.gif" width="170" height="1"></td>
        </tr>
        <tr>
          <td height="27"> <h3><%=_i18n.get("menu.mpc")%></h3></td>
        </tr>
		<tr>
          <td><img src="./images/left_barline.gif" width="170" height="1"></td>
        </tr>
		<tr>
              <td height="5"></td>
		</tr>
         <tr>
		   <td><h2><a href="mpc20ms001.jsp" target=contents><%=_i18n.get("menu.mpc.local")%></a></h2></td>
          </tr>
          <tr>
			<td><h2><a href="mpc20ms002.jsp" target=contents><%=_i18n.get("menu.mpc.remote")%></a></h2></td>
		  </tr>
          <tr>
			<td><h2><a href="mpc20ms101.jsp" target=contents><%=_i18n.get("menu.mpc.cpaconnect")%></a></h2></td>
		  </tr>
        <tr>
          <td><img src="./images/left_barline.gif" width="170" height="1"></td>
        </tr>
		</table>
<%
} else if (module.equals("wsms")) {
	mainpage = "msg20ms901.jsp";
%>
	  <table width="170" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td> <img src="./images/left_menu02.gif" width="170"></td>
	    </tr>
        <tr>
          <td height="27"> <h1><a href="msg20ms901.jsp" class="left" target=contents><%=_i18n.get("menu.msg")%></a></h1></td>
        </tr>
        <tr>
          <td><img src="./images/left_barline.gif" width="170" height="1"></td>
        </tr>
        <tr>
          <td height="27"> <h1><a href="wsd20ms001.jsp" class="left" target=contents><%=_i18n.get("menu.wsdl")%></a></h1></td>
        </tr>
        <tr>
          <td><img src="./images/left_barline.gif" width="170" height="1"></td>
        </tr>
        <tr>
          <td height="27"> <h1><a href="sys20ms002.jsp" class="left" target=contents><%=_i18n.get("menu.ws.context")%></a></h1></td>
        </tr>
        <tr>
          <td><img src="./images/left_barline.gif" width="170" height="1"></td>
        </tr>
        <tr>
          <td height="27"> <h1><a href="msi20ms901.jsp" class="left" target=contents><%=_i18n.get("menu.msi")%></a></h1></td>
        </tr>
		<tr>
          <td><img src="./images/left_barline.gif" width="170" height="1"></td>
        </tr>
		</table>
<%
} else if (module.equals("usr")) {
	mainpage = "usr20ms001.jsp";
%>
	  <table width="170" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td> <img src="./images/left_menu03.gif" width="170"></td>
	    </tr>
        <tr>
          <td height="27"> <h1><a href="usr20ms001.jsp" class="left" target=contents><%=_i18n.get("menu.user.1")%></a></h1></td>
        </tr>
        <tr>
          <td><img src="./images/left_barline.gif" width="170" height="1"></td>
        </tr>
<%
if (MxsConstants.EB_MOD_SUPPORTED) {
%>
        <tr>
          <td height="27"> <h1><a href="wsu20ms001.jsp" class="left" target=contents><%=_i18n.get("menu.user.2")%></a></h1></td>
        </tr>
		<tr>
          <td><img src="./images/left_barline.gif" width="170" height="1"></td>
        </tr>
<%} %>
		</table>

<%
} else if (module.equals("sys")) {
	mainpage = "sys20ms001.jsp";
%>
	  <table width="170" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td> <img src="./images/left_menu04.gif" width="170"></td>
	    </tr>
        <tr>
          <td height="27"> <h3><%=_i18n.get("menu.props")%></h3></td>
        </tr>
        <tr>
          <td><img src="./images/left_barline.gif" width="170" height="1"></td>
        </tr>
		<tr>
          <td height="5"></td>
        </tr>
	    <tr>
    	  <td><h2><a href="sys20ms001.jsp" target=contents><%=_i18n.get("menu.props.sys")%></a></h2></td>
  	    </tr>
	    <tr>
	      <td><h2><a href="sys20ms003.jsp" target=contents><%=_i18n.get("menu.props.db")%></a></h2></td>
        </tr>
        <tr>
          <td><img src="./images/left_barline.gif" width="170" height="1"></td>
        </tr>
        <!--
        <tr>
          <td height="27"> <h3>Ελ°θ</h3></td>
        </tr>
		<tr>
          <td><img src="./images/left_barline.gif" width="170" height="1"></td>
        </tr>
		<tr>
              <td height="5"></td>
		</tr>
          <tr>
			<td><h2><a href="com00en000.jsp" target=contents>ebMS</a></h2></td>
		  </tr>
		  <tr>
			<td><h2><a href="com00en000.jsp" target=contents>WS</a></h2></td>
		  </tr>
        <tr>
          <td><img src="./images/left_barline.gif" width="170" height="1"></td>
        </tr>
        -->
<%
if (MxsConstants.EB_MOD_SUPPORTED) {
%>
        <tr>
          <td height="27"> <h3><%=_i18n.get("menu.test.eb")%></h3></td>
        </tr>
		<tr>
          <td><img src="./images/left_barline.gif" width="170" height="1"></td>
        </tr>
		<tr>
              <td height="5"></td>
		</tr>
        <tr>
			<td><h2><a href="tst00ms001.jsp" target=contents><%=_i18n.get("menu.test.eb.send")%></a></h2></td>
		</tr>
        <tr>
			<td><h2><a href="tst00ms002.jsp" target=contents><%=_i18n.get("menu.test.eb.self")%></a></h2></td>
		</tr>
        <tr>
			<td><h2><a href="tst00ms301.jsp" target=contents><%=_i18n.get("menu.test.eb3.send")%></a></h2></td>
		</tr>
	    <tr>
	          <td><img src="./images/left_barline.gif" width="170" height="1"></td>
	    </tr>
<%
}
if (MxsConstants.WS_MOD_SUPPORTED) {
%>
	    <tr>
	          <td height="27"> <h3><%=_i18n.get("menu.test.ws")%></h3></td>
	    </tr>
		<tr>
	          <td><img src="./images/left_barline.gif" width="170" height="1"></td>
	    </tr>
		<tr>
	              <td height="5"></td>
		</tr>
		<tr>
			<td><h2><a href="tst00ms901.jsp" target=contents><%=_i18n.get("menu.test.ws.send")%></a></h2></td>
		</tr>
		<tr>
			<td><h2><a href="tst00ms902.jsp" target=contents><%=_i18n.get("menu.test.ws.self")%></a></h2></td>
		</tr>
        <tr>
          <td><img src="./images/left_barline.gif" width="170" height="1"></td>
        </tr>
<%
}
%>
        <tr>
          <td height="27"> <h3><%=_i18n.get("menu.monitor")%></h3></td>
        </tr>
		<tr>
          <td><img src="./images/left_barline.gif" width="170" height="1"></td>
        </tr>
		<tr>
              <td height="5"></td>
		</tr>
        <tr>
			<td><h2><a href="mon20ms001.jsp" target=contents><%=_i18n.get("menu.monitor.setting")%></a></h2></td>
		</tr>
        <tr>
			<td><h2><a href="mon21ms001.jsp" target=contents><%=_i18n.get("menu.monitor.view")%></a></h2></td>
		</tr>
	    <tr>
	          <td><img src="./images/left_barline.gif" width="170" height="1"></td>
	    </tr>
		<tr>
              <td height="5"></td>
		</tr>
        <tr>
			<td><h2><a href="log21ms001.jsp?id=MXS" target=contents><%=_i18n.get("menu.log.system")%></a></h2></td>
		</tr>
        <tr>
			<td><h2><a href="log21ms001.jsp?id=MXS_DB" target=contents><%=_i18n.get("menu.log.db")%></a></h2></td>
		</tr>
	    <tr>
	          <td><img src="./images/left_barline.gif" width="170" height="1"></td>
	    </tr>

		</table>
<%
} else if (module.equals("sec")) {
	mainpage = "sec20ms001.jsp";
%>
	  <table width="170" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td> <img src="./images/left_menu05.gif" width="170"></td>
	    </tr>
        <tr>
          <td height="27"> <h1><a href="sec20ms001.jsp" class="left" target=contents><%=_i18n.get("menu.keystore")%></a></h1></td>
        </tr>
		<tr>
          <td><img src="./images/left_barline.gif" width="170" height="1"></td>
        </tr>
		</table>

<%
} else if (module.equals("lic")) {
	mainpage = "lic20ms001.jsp";
%>
	  <table width="170" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td> <img src="./images/left_menu06.gif" width="170"></td>
	    </tr>
        <tr>
          <td height="27"> <h1><a href="lic20ms001.jsp" class="left" target=contents><%=_i18n.get("menu.license")%></a></h1></td>
        </tr>
        <tr>
          <td><img src="./images/left_barline.gif" width="170" height="1"></td>
        </tr>
		</table>

<%
} else {
%>
&nbsp;
<%
}
%>

</td>
  </tr>
</table>
<script>
<% if (mainpage != "") { %>
	window.open('<%= mainpage %>', 'contents');
<% } %>
</script>
</body>
</html>
