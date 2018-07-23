<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.dto.SecurityKeyStoreVO" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%
 /**
 * @author Yoon-Soo Lee
 * @author Mi-Young Kim
 * @version 2.0
 */
%>
<html>
<head>
<%@ include file="com00in000.jsp" %>
<%@ include file="./com00in003.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>
<%
   String obid   = request.getParameter("obid");
   String errMsg = _i18n.get("sec21ms001.keystore.notfound");
   if (obid == null || obid.equals("")) {
%>
		<script>
		alert("<%=errMsg%>");
		location.href="sec20ms001.jsp";
		</script>
<%
   return;
   }
   String command = (String) request.getParameter("command");
   command = (command == null ? "" : command);
   String msg = (String) request.getParameter("result");
   msg = (msg == null ? "" : msg);

   SecurityKeyStoreVO vo = null;
   String desc = "";
   try	{
		MxsEngine engine = MxsEngine.getInstance();
		QueryCondition qc = new QueryCondition();
		qc.add("obid", obid);
		ArrayList list = engine.getObjects("SecurityKeyStore", 1, qc, DAOFactory.COMMON);
		if (list == null || list.size() == 0) {
%>
		<script>
		alert("<%=errMsg%>");
		location.href="sec20ms001.jsp";
		</script>
<%
		return;
		}
		// get KeystoreVO
		vo = (SecurityKeyStoreVO) list.get(0);
		desc = vo.getDescription();
		desc = (desc == null ? "" : desc);

   } catch (Exception e) {
	     e.printStackTrace();
%>
		<script>
		alert("<%=errMsg%>");
		location.href="sec20ms001.jsp";
		</script>
<%
	   return;
   }
%>
<script language="JavaScript" type="text/JavaScript">
<!--
function updateKeyStore() {
   var frm = document.keystoreUpdate;
   frm.action = "sec30ac001.jsp";
   frm.submit();
}

function deleteKeyStore() {
	msg = "<%=_i18n.get("sec20ms001.delete.confirm")%>";
	bChoice = openConfirm(msg, deleteFunction, null, "<%=_i18n.get("global.warning")%>");
}

function deleteFunction() {

   $('messageDisplay').innerHTML = '';

   var params = Form.serialize(document.keystoreUpdate);
   var opt = {
      method: 'post',
      parameters: params,
       onSuccess: function(t) {
         $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("sec40ac001.keystore.delete.success") %>';
         location.href = "sec20ms001.jsp";
       },
       on404: function(t) {
           $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("err00zz404.message") %>';
           showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
       },
       onFailure: function(t) {
           $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("global.error.retry") %>';
           showErrorPopup(t.responseText, null, null, null);
       }
   }

   var myAjax = new Ajax.Request("sec40ac001.jsp", opt);
}

//-->
</script>
</head>
<body bgcolor=#FFFFFF leftmargin=0 topmargin=0 marginwidth=0 marginheight=0>


<form name="keystoreUpdate" method="post" enctype="multipart/form-data">
<input type="hidden" name="obid" value="<%=vo.getObid()%>">
<input type="hidden" name="curPage" id="curPage" value="1">

<!-- 제목테이블 -->
<table class="TableLayout">
  <tr>
    <td width="170" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.sec.detail")%></td>
    <td width="620" class="MessageDisplay" >
          <span id=messageDisplay></span></td>
  </tr>
  <tr>
    <td colspan="2" height="10"></td>
  </tr>
</table>

<!-- 정보 테이블-->
<table class="FieldTable">
  <tr>
    <td width="130" class="FieldLabel"><%=_i18n.get("sec21ms001.keystore.file")%> </td>
    <td width="630" class="FieldData"><input type="file" name="keystoreFile" class="FormText" size="40" id="uploadFile" /></td>
  </tr>
  <tr>
    <td width="130" class="FieldLabel"><%=_i18n.get("sec21ms001.keystore.name")%> </td>
    <td width="630" class="FieldData"><input name="keystore_name" id="keystore_name" type="text" class="FormText" value="<%=vo.getName()%>" size="50"></td>
  </tr>
  <tr>
    <td width="130" class="FieldLabel"><%=_i18n.get("sec21ms001.keystore.password")%> </td>
    <td width="630" class="FieldData"><input name="keystore_password" id="keystore_password" type="password" class="FormText" value="<%=vo.getKeystorePassword()%>" size="50"></td>
  </tr>
  <tr>
    <td width="130" class="FieldLabel"><%=_i18n.get("sec21ms001.keystore.alias.name")%> </td>
    <td width="630" class="FieldData"><input name="alias_name" id="alias_name" type="text" class="FormText" value="<%=vo.getPrivateKeyAlias()%>" size="50"></td>
  </tr>
  <tr>
    <td width="130" class="FieldLabel"><%=_i18n.get("sec21ms001.keystore.alias.password")%> </td>
    <td width="630" class="FieldData"><input name="alias_password" id="alias_password" type="password" class="FormText" value="<%=vo.getPrivateKeyPassword()%>" size="50"></td>
  </tr>
  <tr>
    <td width="130" class="FieldLabel"><%=_i18n.get("sec21ms001.keystore.type")%> </td>
    <td width="630" class="FieldData"><input name="keystore_type" id="keystore_type" type="text" class="FormText" value="<%=vo.getKeystoreType() %>" size="50"></td>
  </tr>
  <tr>
    <td width="130" class="FieldLabel"><%=_i18n.get("sec21ms001.keystore.desc")%> </td>
    <td width="630" class="FieldData"><input name="desc" id="desc" type="text" class="FormText" value="<%=desc %>" size="50"></td>
  </tr>
   <tr>
    <td width="130" class="FieldLabel"><%=_i18n.get("sec21ms001.keystore.related.cpa")%> </td>
    <td width="630" class="FieldData">
<%
    int size = vo.getCpaids().size();
	if (size > 0 )
	{
		out.println("<select name='cpaIds' class='FormSelect'>");
		for (int i = 0; i < size; i++) {
			out.println("<option>" + vo.getCpaids().get(i) + "</option>");
		}
		out.println("</select>");
	} else {
		out.println("N/A");
	}
%>
    </td>
  </tr>
</table>

<!-- 버튼테이블 -->
<table class="TableLayout" >
  <tr>
    <td align="right" style="padding-top:15">
      <a href="sec20ms001.jsp"><img src="images/btn_big_list.gif" width="39" height="23" border="0"> </a>
      <a href="javascript:updateKeyStore()"><img src="images/btn_big_change.gif" width="39" height="23" border="0"></a>
      <a href="javascript:deleteKeyStore()"><img src="images/btn_big_delete.gif" width="39" height="23" border="0"></a></td>
  </tr>
</table>
</form>

<script>
<%
	if (command.equals("update")) {
		 msg = (msg.equals("success") ? "sec30ac001.keystore.update.success" : "global.error.retry");
%>

         $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get(msg)%>';
<%
	}
	else if (command.equals("insert")) {
	     msg = (msg.equals("success") ? "sec.keystore.register.success" : "global.error.retry");
%>

         $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get(msg)%>';
<%
}
%>
</script>

</body>
</html>
