<%@ page contentType="text/html; charset=EUC_KR"%>
<%
/**
 * Client License Import
 *
 * @author Yoon-Soo Lee
 * @author Ho-Jin Seo
 * @version 1.0
 */
%>
<html>
<head>
<%@ include file="./com00in000.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>

<body>
<!-- 제목테이블 -->
<table class="TableLayout">
  <tr>
    <td width="200" class="Title" ><img src="images/bu_tit.gif"><%=_i18n.get("menu.license.import")%></td>
    <td width="560" class="MessageDisplay" ><div id=messageDisplay></div></td>
  </tr>
  <tr>
    <td colspan="2" height="10"></td>
  </tr>
</table>

<table border="0" cellpadding="0" cellspacing="0" class="space_search" >
  <form name=validate action="lic10ac002.jsp" method="post" enctype="multipart/form-data">
  <tr class="SelectTable">
    <td width="120" class="SelectTablein"><%=_i18n.get("license.license.file")%></td>
    <td width="640">
    	<input type="file" name="licenseFile" size="50">
    	<input type=image src="images/btn_import.gif" width="58" height="20" align="absmiddle">
    </td>
  </tr>
  </form>
</table>
</body>
</html>