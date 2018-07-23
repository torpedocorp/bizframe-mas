<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date" %>
<%@ page import="kr.co.bizframe.mxs.license.LicenseManager" %>
<%
/**
 * @author Ho-Jin Seo
 * @version 1.0
 */

String command = (String)session.getAttribute("wsdl.command");
command = (command == null ? "" : command);
String msg = (String)session.getAttribute("wsdl.msg");
msg = (msg == null ? "" : msg);

String strFromDate = "";
String strToDate   = "";
SimpleDateFormat sdf  = new SimpleDateFormat("yyyy-MM-dd");

Date today = new Date(System.currentTimeMillis());
strFromDate = sdf.format(today);
strToDate   = sdf.format(today);

//System.out.println("NumPort = " + LicenseManager.getInstance().getNumPortAddress());
//System.out.println("NumTransaction = " + LicenseManager.getInstance().getNumConcurrentTx());
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
	getWSDLList();

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
	getWSDLList();
}

function detailWSDL(obid, type) {
	if (type == 0) {
	   location = "wsd21ms001.jsp?obid=" + obid;
	} else {
	   location = "wsd21ms001.jsp?obid=" + obid;
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
		body += '<td class="ResultData" align="center">' + res.wsdl[i].owner + '</td>';
		body += '<td class="ResultLastData" align="center"><input type="checkbox" name="checkIndex" value="' + i + '"></td>';
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
	body += '  <COL span="1" width="30" align="center">';
	body += '  </COLGROUP>';
	body += '<tr>';
	body += '<td class="ResultHeader"><%=_i18n.get("global.wsdl.name")%></td>';
	body += '<td class="ResultHeader"><%=_i18n.get("global.wsdl.type")%></td>';
	body += '<td class="ResultHeader"><%=_i18n.get("global.date.creation")%></td>';
	body += '<td class="ResultHeader"><%=_i18n.get("global.status")%></td>';
	body += '<td class="ResultHeader"><%=_i18n.get("global.registrar")%></td>';
	body += '<td class="ResultLastHeader"><input type="checkbox" name="allChkBtn" id="allChkBtn" onClick="javascript:mainAllCheck()" ></td>';
	body += '</tr>';

	return body;
}

function getWSDLList() {

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
	getWSDLList();
}

function mainAllCheck() {
	var inputs     = document.getElementsByTagName('input');
	var checkboxes = new Array();
	var count = 0;
	for (var i = 0; i < inputs.length; i++) {
	   if (inputs[i].type == 'checkbox' && inputs[i].name != 'allChkBtn') {
		   checkboxes[count++] = inputs[i];
	   }
	}
	for (var i = 0; i < checkboxes.length; i++) {
	   checkboxes[i].checked = document.all.allChkBtn.checked;
	}
}

function deleteWsdlOkFunction() {
	Windows.closeAllModalWindows();

	var params = Form.serialize(document.form1);
	var opt = {
		method: 'get',
		parameters: params,
		onSuccess: function(t) {
			$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%= _i18n.get("wsd40ac001.wsdl.deleted") %>';
			searchList(1);
		},
	    on404: function(t) {
        	$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("err00zz404.message") %>';
        //	showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
	    },
	    onFailure: function(t) {
        	$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("global.error.retry") %>';
        	showErrorPopup(t.responseText, null, null, null);
	    }
	}
	var myAjax = new Ajax.Request("./wsd40ac001.jsp", opt);
}

function deleteWSDL() {
	var check_index = getSelectedId_Index();
	if(check_index == null || check_index == '') {
		msg = "<%=_i18n.get("wsd20ms001.non.selected")%>";
		openAlert(msg, "<%=_i18n.get("global.alert")%>", "<%=_i18n.get("global.ok")%>");
	} else {
		msg = "<%=_i18n.get("wsd20ms001.delete.confirm")%>";
		openConfirm(msg, deleteWsdlOkFunction, null, "<%=_i18n.get("global.warning")%>");
	}
}

/* Commented out by J-.H. Kim on 2008.05.19
function viewWSDL(obid) {
   window.open("wsd22ac001.jsp?obid=" + obid, "WSDL", "width=1010,height=800,left=0,top=0,resizable=yes,scrollbars=yes");
}*/

function downloadWSDL() {
	var inputs = document.getElementsByTagName('input');
	var id_Index = "" ;
	var selCnt = 0;
	for (var i = 0; i < inputs.length; i++) {
		if (inputs[i].type == 'checkbox' && inputs[i].checked==true && inputs[i].name != 'allChkBtn') {
			id_Index = inputs[i].value;
			selCnt++;
		}
	}
	if (selCnt == 0 ) {
		var msg = "<%=_i18n.get("wsd20ms001.non.selected")%>";
		alert(msg);
	} else if (selCnt > 1) {
		var msg = "<%=_i18n.get("wsd20ms001.select.one")%>";
		alert(msg);
	} else {
		wsdlid = "wsdlObid" + id_Index;

		var frm = document.form1;
		frm.action = "wsd50ac001.jsp?obid=" + $(wsdlid).value;
		frm.method = "post";
		frm.submit();

		//window.open("wsd50ac001.jsp?obid=" + $(wsdlid).value, "WSDL", "width=100,height=100,left=5000,top=100,resizable=yes,scrollbars=yes");
	}
}

function getSelectedId_Index() {
   var inputs = document.getElementsByTagName('input');
   var id_Index = "" ;
   var selCnt = 0;
   for (var i = 0; i < inputs.length; i++) {
	  if (inputs[i].type == 'checkbox' && inputs[i].checked==true && inputs[i].name != 'allChkBtn')
	  {
		  id_Index = inputs[i].value;
		  selCnt++;
	  }
   }
   return id_Index;
}

function deployWsdl() {
	document.wsdlUpload.action = "wsd10ms001.jsp";
	document.wsdlUpload.submit();
}

function importWsdl() {
	document.wsdlUpload.action = "wsd10ms002.jsp";
	document.wsdlUpload.submit();
}

function changeFile() {
	$('filepath').value= $('uploadFile').value;
}

window.onload = initialize;
//-->
</script>
</head>

<body>
<!--%@ include file="./index2.jsp" %-->
<!--div id="maincontent"-->
<table class="TableLayout">
  <tr>
    <td width="120" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.wsdl.list")%></td>
    <td width="640" class="MessageDisplay" ><div id=messageDisplay></div></td>
  </tr>
  <tr>
    <td colspan="2" height="6"></td>
  </tr>
</table>
<!-- upload wsdl -->
<form name="wsdlUpload" method="post" enctype="multipart/form-data">
<table border="0" cellpadding="0" cellspacing="0" class="space_search" >
  <tr class="SelectTable"  >
    <td width="120" height="30" class="SelectTablein" ><%=_i18n.get("wsd20ms001.wsdl.file")%></td>
    <td width="640">
<!--
      <input name="filepath" id="filepath" type="text" class="FormTextReadOnly" readonly size="25">
<span style='overflow:hidden; width:59; height:20;background-image:url(images/btn_sesrch.gif);'>
      <input id="uploadFile" name="uploadFile" type="file" style='width:0; height:22; filter:alpha(opacity=0);' onChange="javascript:changeFile()">
</span>&nbsp;&nbsp;
-->
      <input id="uploadFile" name="uploadFile" type="file" size="25" class="FormText">
      <a href="javascript:deployWsdl()"><img src="images/btn_deploy.gif" border="0" align="absmiddle" ></a>
      <a href="javascript:importWsdl()"><img src="images/btn_import.gif" border="0" align="absmiddle"></a>
    </td>
  </tr>
</table>
</form>
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
    <td width="300" align="right"><a href="javascript:downloadWSDL()"><img src="images/btn_donwload.gif" border="0" /></a>
      <a href="javascript:deleteWSDL()"><img src="images/btn_delete.gif" border="0" /></a></td>
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
<%
session.setAttribute("wsdl.command", "");
session.setAttribute("wsdl.msg", "");

%>

