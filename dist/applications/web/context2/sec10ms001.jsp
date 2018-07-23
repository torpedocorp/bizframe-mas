<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%
/**
 * Keystore registration form
 *
 * @author Mi-Young Kim
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
function insertKeystore()
{
   var frm = document.frm;

   if (frm.keystoreFile.value == '') {
      $('messageDisplay').innerHTML ='<%=_i18n.get("sec10ms001.nullCheck.file")%>'; 
      alert('<%=_i18n.get("sec10ms001.nullCheck.file")%>');
      return;
   } 
   
   if (frm.keystore_name.value == '') {
      $('messageDisplay').innerHTML ='<%=_i18n.get("sec10ms001.nullCheck.keystore_name")%>'; 
      alert('<%=_i18n.get("sec10ms001.nullCheck.keystore_name")%>');
      return;
   } 

   if (frm.keystore_password.value == '') {
      $('messageDisplay').innerHTML ='<%=_i18n.get("sec10ms001.nullCheck.keystore_password")%>'; 
      alert('<%=_i18n.get("sec10ms001.nullCheck.keystore_password")%>');
      return;
   } 
   
   if (frm.alias_name.value == '') {
      $('messageDisplay').innerHTML ='<%=_i18n.get("sec10ms001.nullCheck.alias_name")%>'; 
      alert('<%=_i18n.get("sec10ms001.nullCheck.alias_name")%>');
      return;
   }  
   
   if (frm.alias_password.value == '') {
      $('messageDisplay').innerHTML ='<%=_i18n.get("sec10ms001.nullCheck.alias_password")%>'; 
      alert('<%=_i18n.get("sec10ms001.nullCheck.alias_password")%>');
      return;
   } 

   if (frm.keystore_type.value == '') {
      $('messageDisplay').innerHTML ='<%=_i18n.get("sec10ms001.nullCheck.keystore_type")%>'; 
      alert('<%=_i18n.get("sec10ms001.nullCheck.keystore_type")%>');
      return;
   } 
   frm.action = "sec10ac001.jsp";
   frm.submit();  
}
//-->
</script>
</head>
<body bgcolor=#FFFFFF leftmargin=0 topmargin=0 marginwidth=0 marginheight=0>
<form name="frm" method="post" enctype="multipart/form-data">	
<input type="hidden" name="curPage" id="curPage" value="1">

<!-- 제목테이블 -->
<table class="TableLayout">
  <tr>
    <td width="25%" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.sec.register")%></td>
    <td width="75%" class="MessageDisplay"><div id=messageDisplay></div></td>
  </tr>
  <tr> 
    <td colspan="2" height="6"></td>
  </tr>
</table>

<!-- 등록테이블  -->
<table class="FieldTable">
  <tr> 
    <td width="130" class="FieldLabel"><%=_i18n.get("sec21ms001.keystore.file")%> </td>
    <td width="630" class="FieldData"><input type="file" name="keystoreFile" class="FormText" size="40" id="keystoreFile" /></td>
  </tr>
  <tr> 
    <td width="130" class="FieldLabel"><%=_i18n.get("sec21ms001.keystore.name")%> </td>
    <td width="630" class="FieldData"><input name="keystore_name" id="keystore_name" type="text" class="FormText" value="" size="50"></td>
  </tr>  
  <tr> 
    <td width="130" class="FieldLabel"><%=_i18n.get("sec21ms001.keystore.password")%> </td>
    <td width="630" class="FieldData"><input name="keystore_password" id="keystore_password" type="password" class="FormText" value="" size="50"></td>
  </tr>    
  <tr> 
    <td width="130" class="FieldLabel"><%=_i18n.get("sec21ms001.keystore.alias.name")%> </td>
    <td width="630" class="FieldData"><input name="alias_name" id="alias_name" type="text" class="FormText" value="" size="50"></td>
  </tr>    
  <tr> 
    <td width="130" class="FieldLabel"><%=_i18n.get("sec21ms001.keystore.alias.password")%> </td>
    <td width="630" class="FieldData"><input name="alias_password" id="alias_password" type="password" class="FormText" value="" size="50"></td>
  </tr>    
  <tr> 
    <td width="130" class="FieldLabel"><%=_i18n.get("sec21ms001.keystore.type")%> </td>
    <td width="630" class="FieldData"><input name="keystore_type" id="keystore_type" type="text" class="FormText" value="" size="50"></td>
  </tr>    
  <tr> 
    <td width="130" class="FieldLabel"><%=_i18n.get("sec21ms001.keystore.desc")%> </td>
    <td width="630" class="FieldData"><input name="desc" id="desc" type="text" class="FormText" value="" size="50"></td>
  </tr>    
</table>

<!-- 버튼  테이블-->
<table class="TableLayout" >
  <tr> 
    <td align="right" style="padding-top:15">
      <a href="sec20ms001.jsp"><img src="images/btn_big_list.gif" width="39" height="23" border="0"></a> 
      <a href="javascript:insertKeystore()"><img src="images/btn_big_create.gif" width="39" height="23" border="0"></a> 
      <a href="javascript:document.frm.reset()"><img src="images/btn_big_reset.gif" width="47" height="23" border="0"></a> 
    </td>
  </tr>
</table>
</form>

</body>
</html>
