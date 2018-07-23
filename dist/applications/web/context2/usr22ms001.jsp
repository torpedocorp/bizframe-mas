<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%
/**
 * detail for user
 *
 * @author M.K JUNG
 * @version 1.0
 */
%>
<html>
<head>
<%@ include file="./com00in000.jsp" %>
<%@ include file="./com00in003.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>
<script language="JavaScript" type="text/JavaScript">
<!--

function updateUser() {
	if ($('passwd').value == "") {
		alert("<%=_i18n.get("usr10ms001.passwd.empty")%>");
		return;
	}
	if ($('passwd').value != $('passwd2').value) {
		alert("<%=_i18n.get("usr21ms001.passwd.incorrect")%>");
		return;
	}

	msg = "<%=_i18n.get("usr21ms001.update.confirm")%>";
	openConfirm(msg, updateOkFunction, null, "<%=_i18n.get("global.warning")%>");
}

function updateOkFunction() {
	Windows.closeAllModalWindows();
	clearNotify();

	var params = Form.serialize(document.form1);

	var opt = {
	    method: 'post',
	    postBody: params,
	    aynchronous: false,
	    onSuccess: function(t) {
			alert("<%=_i18n.get("usr21ms001.operation.update") %>");
			this.close();
	    },
	    on404: function(t) {
	        $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("err00zz404.message") %>';
	    },
	    onFailure: function(t) {
	        $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("global.error.retry") %>';
	    }
	}

	var myAjax = new Ajax.Request('./usr30ac002.jsp', opt);
}

//-->
</script>
</head>
<body style="margin:15px 0px 0px 15px">
<!-- 제목테이블 -->
<table class="TableLayout" style="width:400px">
	<tr>
		<td class="Title"><img src="images/tit.gif">
		<%=_i18n.get("menu.user.info")%>
		</td>
		<td class="MessageDisplay"><div id="messageDisplay"></div></td>
	</tr>
	<tr>
		<td colspan="2" height="12"></td>
	</tr>
</table>
<!-- 등록테이블-->
<form name="form1" method="post" >
<table class="FieldTable" style="width:400px">
        <tr>
          <td width="120" class="FieldLabel"><%=_i18n.get("global.user.id")%></td>
          <td width="260" class="FieldData" colspan="3"><%=session.getAttribute("userid") %>
          </td>
        </tr>
        <tr>
          <td width="120" class="FieldLabel"><%=_i18n.get("global.user.password")%></td>
          <td width="260" class="FieldData" colspan="3">
            <input name="passwd" id="passwd" type="password" class="FormText" size="32"></td>
        </tr>
        <tr>
          <td width="120" class="FieldLabel"><%=_i18n.get("global.user.password.confirm")%></td>
          <td width="260" class="FieldData" colspan="3">
            <input name="passwd2" id="passwd2" type="password" class="FormText" size="32"></td>
        </tr>
</table>
<!-- 버튼테이블 -->
<br>
<table class="TableLayout" style="width:400px">
  <tr>
    <td align="right">
      <a href="javascript:updateUser()"><img src="images/btn_big_change.gif" width="39" height="23" border="0"></a>
    </td>
  </tr>
</table>
</form>
</body>
</html>
