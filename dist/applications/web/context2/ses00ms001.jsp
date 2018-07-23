<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.license.LicenseManager" %>
<%
/**
 * Login page
 *
 * @author Ho-Jin Seo
 * @version 1.0
 */
	String product_code = "pa";
	String background = "#158E93";
	if (LicenseManager.getInstance().getNumConcurrentTx() == 0 &&
			LicenseManager.getInstance().getNumPartyId() == 0 &&
			LicenseManager.getInstance().getNumPortAddress() == 0) {
		product_code = "en";
		background = "046099";

	}

%>
<html>
<head>
<%@ include file="./com00in000.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>
<script language="javascript">
<!--
function login() {
	id = $('loginid').value;
	pw = $('loginpw').value;

	if(id == null || id == '') {
		alert('<%=_i18n.get("ses00ms001.loginid.nullcheck") %>');
		return;
	}
	if(pw == null || pw == '') {
		alert('<%=_i18n.get("ses00ms001.loginpw.nullcheck") %>');
		return;
	}

	var params = Form.serialize(document.form1);
	var opt = {
		method: 'post',
		parameters: params,
		asynchronous: false,
		onSuccess: function(t) {
			var res = eval("(" + t.responseText + ")");
			checkLogin(res.result);
		},
		 on404: function(t) {
			  alert('<%=_i18n.get("err00zz404.message") %>');
			  closeInfo();
		 },
		 onFailure: function(t) {
			  showErrorPopup(t.responseText, null, null, null);
			  closeInfo();
		 }
	}
	var myAjax = new Ajax.Request("./ses00ac001.jsp", opt);
}

function checkLogin(code) {
	if (code == "001") {
		location.href="main.jsp";
	} else if (code == "101") {
		alert('<%=_i18n.get("ses00ms001.loginpw.nullcheck") %>');
	} else if (code == "102") {
		alert('<%=_i18n.get("ses00ms001.loginpw.nullcheck") %>');
	} else if (code == "103") {
		alert('<%=_i18n.get("ses00ms001.loginpw.incorrect") %>');
	} else if (code == "104") {
		alert('<%=_i18n.get("ses00ms001.loginpw.notadmin") %>');
	}
}

function onEnter(event)
{
   if(event==null) event =  window.event;
   if(event.keyCode == 13) {
     login();
   }
}
-->
</script>
</head>

<body bgcolor="<%=background%>"  >
<form name="form1" method="post">
<table width="100%" height="100%"  border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td align="center" valign="middle">
    <table width="710" height="306" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td background="images/logon_main<%=product_code%>.jpg">
          <div style="position: relative; top: 230px; left: 0px; height: 306px">
          <table width="680" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="440" rowspan="3">&nbsp;</td>
              <td width="45"><img src="images/log_id.gif" width="45" height="11" align="absmiddle"></td>
              <td width="112"><input name="loginid" id="loginid" type="text" class="FormText" size="15" tabindex="1">
              </td>
              <td rowspan="3"><div align="right"><a href="javascript:login()"><img src="images/btn_log<%=product_code%>.gif" width="69" height="47" border="0" tabindex="3"></a></div></td>
            </tr>
            <tr>
              <td height="5" colspan="2"></td>
            </tr>
            <tr>
              <td><img src="images/log_pass.gif" width="45" height="11" align="absmiddle"></td>
              <td><input name="loginpw" id="loginpw" type="password" class="FormText" size="15" tabindex="2" onkeydown="onEnter(event)"></td>
            </tr>
          </table>
          </div>
          </td>
        </tr>
      </table></td>
    </tr>
  </table>
</form>
</body>
</html>
