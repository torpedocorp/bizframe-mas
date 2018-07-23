<%@ page contentType="text/html; charset=EUC_KR"%>
<%
/**
 * Client License List
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
<script language="javascript">
<!--
function initialize() {
	getLicenses();
}
function getHeader() {
	var body = "";

	body += '<table class="TableLayout">';
	body += '  <COLGROUP>';
	body += '  <COL span="1">';
	body += '  <COL span="1">';
	body += '  <COL span="1">';
	body += '  <COL span="1">';
	body += '  <COL span="1">';
	body += '  </COLGROUP>';
	body +='<tr>';
    body +='<td class="ResultHeader"><%=_i18n.get("license.product.name")%></td>';
    body +='<td class="ResultHeader"><%=_i18n.get("license.customer.name")%></td>';
    body +='<td class="ResultHeader">License Number</td>';
    body +='<td class="ResultHeader"><%=_i18n.get("license.valid.through")%></td>';
    body +='<td class="ResultHeader"><%=_i18n.get("global.status")%></td>';
	body +='</tr>';
	return body;
}

function showList(originalRequest) {

	var res = eval("(" + originalRequest.responseText + ")");

	var body = "";

	var num = 0;
	body += getHeader();

	for (var i=0; i<res.licenses.length; i++) {
		body += '<tr>';
		body += '<td class="ResultData"><a href="lic21ms001.jsp?obid=' + res.licenses[i].obid + '">' + res.licenses[i].productname + '</a></td>';
		body += '<td class="ResultData">' + res.licenses[i].customername + '</td>';
		body += '<td class="ResultData"><a href="lic21ms001.jsp?obid=' + res.licenses[i].obid + '">' + res.licenses[i].licensenumber + '</a></td>';
		body += '<td class="ResultData">' + res.licenses[i].start + ' ~ ' + res.licenses[i].end + '</td>';
		body += '<td class="ResultLastData">' + res.licenses[i].status + '</td>';
		body += '</tr>';
	}
	if (res.totalRows == 0) {
//		body += '<tr><td class="ResultData" colspan="8" align="center"><%= _i18n.get("msg20ms901.notfound")%></td></tr>';
	}

	body += '</table>';

	$('listContent').innerHTML = body;

	$('row_size').innerHTML = res.totalRows;
//	$('pagelist').innerHTML = res.pagelist;
}

function getLicenses() {
	var body = "";

	body += getHeader();
	body += '<tr>';
	body += '<td class="ResultData" colspan="4" align="center"><%=_i18n.get("global.processing") %></td>';
	body += '</tr>';
	body += '</table>';

	$('listContent').innerHTML = body;

	var params = '';
	var opt = {
		method: 'post',
		parameters: params,
		onSuccess: showList,
	    on404: function(t) {
        	$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" ><%=_i18n.get("err00zz404.message") %>';
	    },
	    onFailure: function(t) {
        	$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" ><%=_i18n.get("global.error.retry") %>';
        	showErrorPopup(t.responseText, null, null, null);
	    }
	}
	var myAjax = new Ajax.Request("./lic20ac001.jsp", opt);
}

window.onload = initialize;
-->
</script>
</head>
<body>
<!-- 제목테이블 -->
<table class="TableLayout">
  <tr>
    <td width="20%" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.license.list")%></td>
    <td width="80%" class="MessageDisplay" ><div id=messageDisplay></div></td>
  </tr>
  <tr>
    <td colspan="2" height="10"></td>
  </tr>
</table>
<!-- total -->
<table class="TotalTable" >
  <tr>
    <td width="50%" align="left">[ <%= _i18n.get("global.search") %> : <span id="row_size"></span> <%= _i18n.get("global.case") %> ]
    </td>
    <td width="50%" align="right">&nbsp; </td>
  </tr>
</table>
<!-- 결과 목록 테이블 -->
<div id="listContent"></div>
<!-- Page Navigation  -->
<table class="PageNavigationTable" >
  <tr>
    <td height="34" align="center"> <table cellpadding="0" cellspacing="0" border="0">
        <tr>
          <td class="listAPaging"><span id="pagelist"></span></td>
        </tr>
      </table></td>
  </tr>
</table>
<!-- 버튼테이블 -->
<table class="TableLayout" >
  <tr>
    <td align="right" style="padding-top:15">
      	<a href="lic10ms002.jsp"><img src="images/btn_big_import.gif" width="58" height="23" border="0"></a>
    </td>
  </tr>
</table>
</body>
</html>
