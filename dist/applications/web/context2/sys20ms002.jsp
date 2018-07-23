<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%
/**
 * Context Management
 *
 * @author Ho-Jin Seo
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
function init() {
	getList();
}

function getList() {
	var body = getHeader();
	body += '<tr>';
	body += '<td class="ResultData" colspan="2" align="center"><%=_i18n.get("global.processing") %></td>';
	body += '</tr>';
	body += '</table>';
	$('listContent').innerHTML = body;
	
	var params = '';
	var opt = {
			method: 'get', 
			parameters: params,
			asynchronous : false,
			onSuccess: showList,
		    on404: function(t) {
	        	$('messageDisplay').innerHTML = '<%=_i18n.get("err00zz404.message") %>';
	        //	showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
		    },
		    onFailure: function(t) {
	        	$('messageDisplay').innerHTML = '<%=_i18n.get("global.error.retry") %>';
	        //	showErrorPopup(t.responseText, null, null, null);
		    }
		}
	var myAjax = new Ajax.Request( './sys20ac002.jsp', opt);

}

function showList(originalRequest)
{
	var res = eval("(" + originalRequest.responseText + ")");
	var operations = "";
	var performers = "";
	var body = "";
	body = getHeader();
	var num = 0;

	for (var i=0; i<res.web.length; i++) {
		row = 0;
		var serviceName = res.web[i].service;
		body += "<tr>";
		body += '<td class="ResultData">' + (i+1) + '</td>';
		body += '<td class="ResultLastData"><input type="text" id="newName' + i + '" name="newName' + i + '" value="' + serviceName + '" size=50 class="FormText">&nbsp;';
		body += '<input type="hidden" id="oldName' + i + '" name="oldName' + i + '" value="' + serviceName + '">';
		body += '<a href="javascript:updateContext(' + i + ')"><img src="images/btn_update.gif" border="0" align="absmiddle"></a>';
		body += '<a href="javascript:deleteContext(' + i + ')"><img src="images/btn_delete.gif" border="0" align="absmiddle"></a>';
		body += '</td>';
		body += '</tr>';
	}
	body += "</table>";
	$('listContent').innerHTML = body;

}

function getHeader() {
	var body = "";
	body += '<table class="TableLayout" >';
	body += '  <tr> ';
	body += '    <td class="ResultHeader"><%=_i18n.get("sys20ms002.colhead.1")%></td>';
	body += '    <td class="ResultLastHeader"><%=_i18n.get("sys20ms002.colhead.2")%></td>';
	body += '  </tr>';
	return body;
}	

function updateContext(num) {
	msg = "<%=_i18n.get("sys20ms002.context.warn1")%>";
	msg += "\r\n<%=_i18n.get("sys20ms002.context.warn2")%>";
	
	$('newName').value = $('newName' + num).value;
	$('oldName').value = $('oldName' + num).value;
	
	if ($('newName').value == $('oldName').value) {
		return;
	} 
	
	openConfirm(msg, updateContextOk, null, "<%=_i18n.get("global.warning")%>");
}

function updateContextOk() {
	Windows.closeAllModalWindows();
	clearNotify();

	var newName = $('newName').value;
	var oldName = $('oldName').value;

	openInfo('<%=_i18n.get("global.processing") %>');
	var param = "oldName="+oldName+ "&newName=" + newName;
	var opt = {
	    method: 'post',
	    postBody: param,
	    onSuccess: function(t) {
	    	closeInfo();
	    	$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("sys20ms002.context.update") %>';
	        //timeout=2; setTimeout(infoTimeout, 1000);
	        //openInfo('<%=_i18n.get("msi20ms902.operation.update") %>');
	    },
	    on404: function(t) {
	    	closeInfo();
	        $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("err00zz404.message") %>';
	        //showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
	    },
	    onFailure: function(t) {
	    	closeInfo();
	        $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("global.error.retry") %>';
	        showErrorPopup(t.responseText, null, null, null);
	    }
	}
	
	var myAjax = new Ajax.Request('./sys30ac002.jsp', opt);	
}

function deleteContext(num) {
	msg = "<%=_i18n.get("sys20ms002.context.warn1")%>";
	msg += "\r\n<%=_i18n.get("sys20ms002.context.warn2")%>";
	
	$('newName').value = '';
	$('oldName').value = $('oldName' + num).value;
	
	openConfirm(msg, deleteContextOk, null, "<%=_i18n.get("global.warning")%>");
}

function deleteContextOk() {
	Windows.closeAllModalWindows();
	clearNotify();

	var oldName = $('oldName').value;

	openInfo('<%=_i18n.get("global.processing") %>');
	var param = "oldName="+oldName;
	var opt = {
	    method: 'post',
	    postBody: param,
	    onSuccess: function(t) {
	    	closeInfo();
	    	$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("sys20ms002.context.delete") %>';
	    	getList();
	        //timeout=2; setTimeout(infoTimeout, 1000);
	        //openInfo('<%=_i18n.get("msi20ms902.operation.update") %>');
	    },
	    on404: function(t) {
	    	closeInfo();
	        $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("err00zz404.message") %>';
	        //showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
	    },
	    onFailure: function(t) {
	    	closeInfo();
	        $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("global.error.retry") %>';
	        showErrorPopup(t.responseText, null, null, null);
	    }
	}
	
	var myAjax = new Ajax.Request('./sys40ac002.jsp', opt);	
}

function addContext() {
	msg = "<%=_i18n.get("sys20ms002.context.warn1")%>";
	msg += "\r\n<%=_i18n.get("sys20ms002.context.warn2")%>";
	openConfirm(msg, addContextOk, null, "<%=_i18n.get("global.warning")%>");
}


function addContextOk() {
	Windows.closeAllModalWindows();
	clearNotify();

	var serviceName = $('serviceName').value;

	openInfo('<%=_i18n.get("global.processing") %>');
	var param = "serviceName="+serviceName;
	var opt = {
	    method: 'post',
	    postBody: param,
	    onSuccess: function(t) {
	    	closeInfo();
	    	$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("sys20ms002.context.registered") %>';
	    	getList();
	        //timeout=2; setTimeout(infoTimeout, 1000);
	        //openInfo('<%=_i18n.get("msi20ms902.operation.update") %>');
	    },
	    on404: function(t) {
	    	closeInfo();
	        $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("err00zz404.message") %>';
	        //showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
	    },
	    onFailure: function(t) {
	    	closeInfo();
	        $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("global.error.retry") %>';
	        showErrorPopup(t.responseText, null, null, null);
	    }
	}
	
	var myAjax = new Ajax.Request('./sys10ac002.jsp', opt);	
}
function searchList(num) {
	getList();
}
function goList() {
	history.go(-1);
}
window.onload=init;

//-->
</script>
</head>
<body>
<!-- 제목테이블 -->
<table class="TableLayout">
  <tr>
    <td width="160" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.sys.context")%></td>
    <td width="600" class="MessageDisplay"><div id=messageDisplay></div></td>
  </tr>
  <tr> 
    <td colspan="2" height="6"></td>
  </tr>
</table>
<!--SelectTable 시작 --> 
<form name="form1" method="post" >
<input type="hidden" name="newName" id="newName">
<input type="hidden" name="oldName" id="oldName">
<!-- 등록테이블-->
<table border="0" cellpadding="0" cellspacing="0" class="space_search" >
  <tr class="SelectTable"  > 
    <td width="200" height="30" class="SelectTablein" ><%=_i18n.get("sys20ms002.context.name")%></td>
    <td width="640">
      <input id="serviceName" name="serviceName" type="text" size="25" class="FormText">
      <a href="javascript:addContext()"><img src="images/btn_big_save.gif" border="0" align="absmiddle" ></a> 
    </td>
  </tr>
</table> 
<br>
<!-- 결과 목록 테이블 코드 시작-->
<div id="listContent"></div>
<!-- 버튼테이블 -->
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
