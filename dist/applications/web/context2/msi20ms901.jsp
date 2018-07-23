<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date" %>
<%
/**
 * @author Ho-Jin Seo
 * @version 1.0
 */

String strFromDate = "";
String strToDate   = "";
SimpleDateFormat sdf  = new SimpleDateFormat("yyyy-MM-dd");

Date today = new Date(System.currentTimeMillis());
strFromDate = sdf.format(today);
strToDate   = sdf.format(today);

%>
<html>
<head>
<%@ include file="./com00in000.jsp" %>
<%@ include file="./com00in001.jsp" %>
<%@ include file="./com00in003.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>
<!-- script type="text/javascript" src="js/dhtmlHistory.js"> </script-->
<script language="JavaScript" type="text/JavaScript">
<!--
function initialize() {
	getWSDL();
	/*
	dhtmlHistory.initialize();
	dhtmlHistory.addListener(historyChange);
	if (dhtmlHistory.isFirstLoad()) {
		var params = Form.serialize(document.wsdlSearch);
		dhtmlHistory.add((new Date()).toString(), params);
		getWSDL();
	}
	*/
}

function historyChange(newLocation, historyData) {
	var historyMsg = historyData;
	if (historyData != null && historyData != "") {
		Form.deserialize(document.wsdlSearch, historyData);
	}
	getWSDL();
}

function detailWSDL(obid, type) {
	if (type == 0) {
	   location = "msi20ms902.jsp?obid=" + obid;
	} else {
	   location = "msi20ms902.jsp?obid=" + obid;
	}
}

function showList(originalRequest) {
   	//closeInfo();

	var res = eval("(" + originalRequest.responseText + ")");

	var operations = "";
	var performers = "";
	var body = "";
	body = getHeader();

	var num = 0;
	for (var i=0; i<res.wsdl.length; i++) {
		body += '<tr>';
		body += '<input type=hidden name="wsdlObid' + i + '" id="wsdlObid' + i + '" value="' + res.wsdl[i].obid + '">';
		body += '<td class="ResultData" align="center"><a href="javascript:detailWSDL(\'' + res.wsdl[i].obid + '\', \'' + res.wsdl[i].isclient + '\' );"><font class="blue-text03">' + res.wsdl[i].name + '</font></a></td>';
		body += '<td class="ResultData" align="center">' + res.wsdl[i].type + '</td>';
		body += '<td class="ResultData" align="center">' + res.wsdl[i].creation + '</td>';
		body += '<td class="ResultData" align="center">' + res.wsdl[i].status + '</td>';
		body += '<td class="ResultLastData" align="center" colspan="2">' + res.wsdl[i].owner + '</td>';
		body += '</tr>';	
	}
	
	if (res.wsdl.length == 0) {
		body += '<tr>';
		body += '<td class="ResultData" colspan="6" align="center"><%= _i18n.get("wsd20ms001.notfound")%></td></tr>';
	}
	
	body += "</table>";
	$('listContent').innerHTML = body;
	
	$('row_size').innerHTML = res.wsdl.length;
	$('pagelist').innerHTML = res.pagelist;

}	
function getHeader() {
	var body = "";
	body += '<table class="TableLayout" >';
	body += '  <COLGROUP>';
	body += '  <COL span="1" style="width:40%;">';
	body += '  <COL span="1" style="width:15%;">';
	body += '  <COL span="1" style="width:15%;">';
	body += '  <COL span="1" style="width:15%;">';
	body += '  <COL span="1" style="width:15%;">';
	body += '  </COLGROUP>';
	body += '<tr>';
	body += '<td class="ResultHeader"><%=_i18n.get("global.wsdl.name")%></td>';
	body += '<td class="ResultHeader"><%=_i18n.get("global.wsdl.type")%></td>';
	body += '<td class="ResultHeader"><%=_i18n.get("global.date.creation")%></td>';
	body += '<td class="ResultHeader"><%=_i18n.get("global.status")%></td>';
	body += '<td class="ResultLastHeader" colspan="2"><%=_i18n.get("global.registrar")%></td>';
	body += '</tr>';
	
	return body;
}

function getWSDL() {

	var body = getHeader();
	body += '<tr>';
	body += '<td class="ResultData" colspan="6" align="center"><%=_i18n.get("global.processing") %></td>';
	body += '</tr>';
	body += '</table>';
	$('listContent').innerHTML = body;
	
	var params = Form.serialize(document.wsdlSearch);
	//openInfo('<%=_i18n.get("global.processing") %>');
	var opt = {
		method: 'post', 
		parameters: params, 
		onSuccess: showList,
	    on404: function(t) {
	    	//closeInfo();
        	$('messageDisplay').innerHTML = '<%=_i18n.get("err00zz404.message") %>';
        //	showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
	    },
	    onFailure: function(t) {
	    	//closeInfo();
        	$('messageDisplay').innerHTML = '<%=_i18n.get("global.error.retry") %>';
        	//showErrorPopup(t.responseText, null, null, null);
	    }
	}
	var myAjax = new Ajax.Request("./wsd20ac001.jsp", opt);

}		

function searchList(page) {
	$('curPage').value = page;
	
	var params = Form.serialize(document.wsdlSearch);
	//dhtmlHistory.add((new Date()).toString(), params);
	getWSDL();
}

window.onload = initialize;
//-->
</script>
</head>

<body>
<table class="TableLayout">
  <tr>
    <td width="160" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.msi.list")%></td>
    <td width="600" class="MessageDisplay" ><div id=messageDisplay></div></td>
  </tr>
  <tr> 
    <td colspan="2" height="6"></td>
  </tr>
</table>
<!--SelectTable 시작 --> 
<form name="wsdlSearch" method="post">
<input type="hidden" name="curPage" id="curPage" value="1">
<table class="SearchTable"  >
  <tr>
      <td style="padding:10px">
        <table>
        <tr>
          <td width="95"><img src="images/bu_search.gif" ><%=_i18n.get("global.wsdl.name")%></td>
          <td width="250"><input name="wsdlname" type="text" class="FormText" size="32" > </td>
          <td width="95"><img src="images/bu_search.gif" ><%=_i18n.get("global.wsdl.type")%></td>
          <td width="250">
            <select name="wsdltype" class="FormSelect" style="width:187;">
              <option value="">Provider/Client</option>
              <option value="0">Provider</option>
              <option value="1">Client</option>
            </select></td>
          <td width="50">&nbsp;</td>
        </tr>
        <tr>
          <td><img src="images/bu_search.gif" ><%=_i18n.get("global.status")%></td>
          <td colspan="3">
            <select name="wsdlstatus" class="FormSelect" style="width:187;">
              <option value="">Enabled/Disabled</option>
              <option value="1">Enabled</option>
              <option value="0">Disabled</option>
            </select>
          </td>
          <td align="right"><a href="javascript:searchList(1)"><img src="images/btn_go.gif" border="0" ></a></td>
        </tr>
      </table></td>
  </tr>
</table>
</form>
<!-- 총개수 테이블 -->
<form name="form1" method="post">
<table class="TotalTable">
  <tr> 
    <td align="left">[ <%= _i18n.get("global.search") %> : <span id="row_size"></span> ]</td>
  </tr>
</table>
<!-- 결과 목록 테이블 코드 시작-->
<div id="listContent"></div>
</form>
<!--naiigation-->
<table class="PageNavigationTable" >
  <tr> 
    <td height="34" align="center"> 
      <table cellpadding="0" cellspacing="0" border="0">
        <tr> 
          <td><span id="pagelist"></span></td> 
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html>

