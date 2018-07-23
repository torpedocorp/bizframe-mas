<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
/**
 * List WsMessage
 *
 * @author Ho-Jin Seo
 * @version 1.0
 */

String itemSet[]= {"5","10","20","30","50","100"};
String pageSet[]= {"5","10","15","20"};//,"30","40","50"};

Date today = new Date(System.currentTimeMillis());

SimpleDateFormat sdf  = new SimpleDateFormat("yyyy-MM-dd");
String strFromDate = sdf.format(today);
String strToDate = sdf.format(today);
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
	getMessages();
	/*
	dhtmlHistory.initialize();
	dhtmlHistory.addListener(historyChange);
	if (dhtmlHistory.isFirstLoad()) {
		var params = Form.serialize(document.form1);
		dhtmlHistory.add((new Date()).toString(), params);
		getMessages();
	}
	*/
}

function historyChange(newLocation, historyData) {
	var historyMsg = historyData;

	if (historyData != null && historyData != "") {
		Form.deserialize(document.form1, historyData);
	}
	getMessages();
}


function mainAllCheck()
{
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
   return selCnt;
}

function getListCnt() {
   var inputs = document.getElementsByTagName('input');
   var selCnt = 0;
   for (var i = 0; i < inputs.length; i++) {
	  if (inputs[i].type == 'checkbox' && inputs[i].name != 'allChkBtn')
	  {
		  selCnt++;
	  }
   }
   return selCnt;
}

function deleteByDate() {
    var check_index = getListCnt();
    if(check_index == null || check_index == 0) {
		   msg = "<%=_i18n.get("msg20ms901.non.selected")%>";
		   openAlert(msg, "<%=_i18n.get("global.alert")%>", "<%=_i18n.get("global.ok")%>");
    } else {

		$('wsdlName').disabled = true;
		$('msgId').disabled = true;
		$('msgOperation').disabled = true;
		$('msgType').disabled = true;
		$('status').disabled = true;
		$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("msg20ms901.message.select.date") %>';
		$('delbydate').value = 1;
	}

}

function deleteByDateCancel() {
	$('wsdlName').disabled = false;
	$('msgId').disabled = false;
	$('msgOperation').disabled = false;
	$('msgType').disabled = false;
	$('status').disabled = false;
	$('messageDisplay').innerHTML = '';
	$('delbydate').value = 0;
}

function deleteMessage() {
    if ($('delbydate').value == 1) {
        if ($('f_date').value == '' || $('t_date').value == '') {
        	alert('<%=_i18n.get("msg20ms901.message.no.date")%>');
        	return;
        }

		msg = "<%=_i18n.get("msg20ms901.message.info")%>";
		openConfirm(msg, deleteByDateFunc, deleteByDateCancel, "<%=_i18n.get("global.warning")%>");

    } else {
		var check_index = getSelectedId_Index();
		if(check_index == null || check_index == 0) {
		   msg = "<%=_i18n.get("msg20ms901.non.selected")%>";
		   openAlert(msg, "<%=_i18n.get("global.alert")%>", "<%=_i18n.get("global.ok")%>");
		} else {
			msg = "<%=_i18n.get("msg20ms901.delete.confirm")%>";
			openConfirm(msg, deleteMessageOkFunc, null, "<%=_i18n.get("global.warning")%>");
		}
    }
}


function deleteMessageOkFunc() {
	Windows.closeAllModalWindows();

	var params = Form.serialize(document.form1);
	var opt = {
		method: 'post',
		parameters: params,
		onSuccess: function(t) {
		    deleteByDateCancel();
			$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" ><%= _i18n.get("msg20ms901.message.deleted") %>';
			setTimeout(searchMessage, 3000);
		},
	    on404: function(t) {
	        deleteByDateCancel();
        	$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" ><%=_i18n.get("err00zz404.message") %>';
        //	showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
	    },
	    onFailure: function(t) {
	        deleteByDateCancel();
        	$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" ><%=_i18n.get("global.error.retry") %>';
        	showErrorPopup(t.responseText, null, null, null);
	    }
	}
	var myAjax = new Ajax.Request("./msg40ac901.jsp", opt);
}

function deleteByDateFunc() {
	Windows.closeAllModalWindows();

	var params = Form.serialize(document.form1);
	var opt = {
		method: 'post',
		parameters: params,
		onSuccess: function(t) {
		    deleteByDateCancel();
			$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" ><%= _i18n.get("msg20ms901.message.deleted") %>';
			setTimeout(searchMessage, 3000);
		},
	    on404: function(t) {
	        deleteByDateCancel();
        	$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" ><%=_i18n.get("err00zz404.message") %>';
        //	showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
	    },
	    onFailure: function(t) {
	        deleteByDateCancel();
        	$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" ><%=_i18n.get("global.error.retry") %>';
        	showErrorPopup(t.responseText, null, null, null);
	    }
	}
	var myAjax = new Ajax.Request("./msg40ac902.jsp", opt);
}


function viewMessage(id)
{
	location.href = "msg21ms901.jsp?obid=" + id;
}

function viewRefMessage(id)
{
	location.href = "msg21ms901.jsp?referenceId=" + id;
}

function LoginEnterDown(){
   if(event.keyCode==13){
      getMessages();
   }
}

function getHeader() {
	var body = "";
	body += '<table class="TableLayout" style="table-layout: fixed">';
	body += '  <COLGROUP>';
	body += '  <COL span="1" style="width:100;">';
	body += '  <COL span="1" style="width:40;">';
	body += '  <COL span="1" style="width:60;">';
	body += '  <COL span="1" style="width:120;">';
	body += '  <COL span="1" style="width:120;">';
	body += '  <COL span="1" style="width:70;">';
	body += '  <COL span="1" style="width:160;">';
	body += '  <COL span="1" style="width:30;">';
	body += '  </COLGROUP>';
	body +='<tr>';
    body +='<td class="ResultHeader"><%= _i18n.get("msg20ms901.column.1") %></td>';
    body +='<td class="ResultHeader"><%= _i18n.get("msg20ms901.column.2") %></td>';
    body +='<td class="ResultHeader"><%= _i18n.get("msg20ms901.column.3") %></td>';
    body +='<td class="ResultHeader"><%= _i18n.get("msg20ms901.column.4") %></td>';
    body +='<td class="ResultHeader"><%= _i18n.get("msg20ms901.column.5") %></td>';
    body +='<td class="ResultHeader"><%= _i18n.get("msg20ms901.column.6") %></td>';
    body +='<td class="ResultHeader"><%= _i18n.get("msg20ms901.column.7") %></td>';
    body +='<td class="ResultLastHeader"><input type="checkbox" name="allChkBtn" onClick="javascript:mainAllCheck();"></td>';
	body +='</tr>';
	return body;
}

function showList(originalRequest) {

  	//closeInfo();

	var res = eval("(" + originalRequest.responseText + ")");

	var operations = "";
	var performers = "";
	var body = "";

	var num = 0;
	body += getHeader();

	for (var i=0; i<res.messages.length; i++) {
		color = i % 2 == 0 ? "#FFFFFF" : "#F9F9F9";

	    if(res.messages[i].inout == 0) {
			inoutStr = '<%=_i18n.get("global.msg.inbound") %>';
	    } else {
	    	inoutStr = '<%=_i18n.get("global.msg.outbound") %>';
	    }


		body += '<tr>';
		body += '<td class="ResultData">' + res.messages[i].wsdlName + '</td>';
		body += '<td class="ResultData">' + inoutStr + '</td>';

		var statusStr ="";
		if (res.messages[i].status == 0 || res.messages[i].status == 1 || res.messages[i].status == 5 ) {
			textcolor = 'red';
			statusStr = '<td class="ResultData"><a href="javascript:viewRefMessage(\'' + res.messages[i].obid + '\')"><font color='+ textcolor +'>' + res.messages[i].statusStr + '</font></a></td>'
		} else {
			textcolor = 'blue';
			statusStr = '<td class="ResultData" bgcolor="' + color + '" align="left"><font color='+ textcolor +'>' + res.messages[i].statusStr + '</font></td>'
		}
		fromUri = (res.messages[i].fromUri == null ? "" : res.messages[i].fromUri);
		toUri =  (res.messages[i].toUri == null ? "" : res.messages[i].toUri);

		if (res.messages[i].inout == 0) toUri = "";
		if (res.messages[i].inout == 1) fromUri = "";

		body += statusStr;
		body += '<td class="ResultData"><pre style="word-wrap: break-word;">' + fromUri + '<br>' + toUri + '</pre></td>';
		body += '<td class="ResultData" align="center"><pre style="word-wrap: break-word;">' + res.messages[i].operationName + '</pre></td>';
		body += '<td class="ResultData" align="center">' + res.messages[i].time + '</td>';
		body += '<td class="ResultData" align="center">';

		wsa_msg_id = res.messages[i].messageId;
		if (wsa_msg_id == null) {
			wsa_msg_id = "[ - ]";
		}

		body += '<pre style="word-wrap: break-word;"><a href="javascript:viewMessage(\'' + res.messages[i].obid + '\')"><font class="blue-text03">' + wsa_msg_id + '</font></a></pre></td>';
		body += '<td class="ResultLastData" align="center"><input type="checkbox" name="checkIndex" value="' + i + '">';
		body += '<input type=hidden name="msgObid' + i + '" value="' + res.messages[i].obid + '"></td>';
		body += '</tr>';
	}
	if (res.totalRows == 0) {
		body += '<tr>';
		body += '<td class="ResultData" colspan="8" align="center"><%= _i18n.get("msg20ms901.notfound")%></td></tr>';
	}

	body += '</table>';

	$('listContent').innerHTML = body;

	$('row_size').innerHTML = res.totalRows;
	$('pagelist').innerHTML = res.pagelist;
	$('messageDisplay').innerHTML = '';
}

function getMessages() {
	var body = "";

	body += getHeader();
	body += '<tr>';
	body += '<td class="ResultData" colspan="8" align="center"><%=_i18n.get("global.processing") %></td>';
	body += '</tr>';
	body += '</table>';

	$('listContent').innerHTML = body;

	var params = Form.serialize(document.form1);

	//openInfo('<%=_i18n.get("global.processing") %>');

	var opt = {
		method: 'post',
		parameters: params,
		onSuccess: showList,
	    on404: function(t) {
	    	//closeInfo();
        	$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" ><%=_i18n.get("err00zz404.message") %>';
        //	showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
	    },
	    onFailure: function(t) {
	    	//closeInfo();
        	$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" ><%=_i18n.get("global.error.retry") %>';
        	showErrorPopup(t.responseText, null, null, null);
	    }
	}
	var myAjax = new Ajax.Request("./msg20ac901.jsp", opt);
}
function searchMessage(page) {
    if (page == null || page == '') {
    	page = 1;
    }
	$('curPage').value = page;

	var params = Form.serialize(document.form1);
	//dhtmlHistory.add((new Date()).toString(), params);

	getMessages();
}

function displayWsdlList(originalRequest) {
	var res = eval("(" + originalRequest.responseText + ")");

	var operations = "";
	var performers = "";
	var body = "";
	for (var i=0; i<res.wsdl.length; i++) {
		$('wsdlName').options[i+1] = new Option(res.wsdl[i].name,res.wsdl[i].name);
	}
}

function getWsdl() {
	//$('content').innerHTML = "<div id='modal_dialog_progress' class='alphacube_progress'>  </div>";

	var opt = {
		method: 'get',
		parameters: '',
		onSuccess: displayWsdlList,
	    on404: function(t) {
        	$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" ><%=_i18n.get("err00zz404.message") %>';
        //	showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
	    },
	    onFailure: function(t) {
        	$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" ><%=_i18n.get("global.error.retry") %>';
        	showErrorPopup(t.responseText, null, null, null);
	    }
	}
	var myAjax = new Ajax.Request("./wsd20ac001.jsp", opt);

}

window.onload = initialize;
//-->
</script>
</head>
<body>
<form name="form1" method="POST">
<input type="hidden" name="curPage" id="curPage" value="1">
<input type="hidden" name="delbydate" id="delbydate" value="0">
<!-- 제목 테이블 -->
<table class="TableLayout">
  <tr>
    <td width="20%" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.msg.list")%></td>
    <td width="80%" class="MessageDisplay" ><div id=messageDisplay></div></td>
  </tr>
  <tr>
    <td colspan="2" height="6"></td>
  </tr>
</table>
<!--SelectTable 시작 -->
<table class="SearchTable"  >
  <tr>
    <td style="padding:10px"><table>
        <tr>
          <td width="95"><img src="images/bu_search.gif" ><%=_i18n.get("global.wsdl.name")%></td>
          <td width="250"><select name="wsdlName" id="wsdlName" class="FormSelect" style="width:187;">
              <option value=""><%= _i18n.get("global.all") %>&nbsp;&nbsp;&nbsp;&nbsp;</option>
            </select> </td>
          <td width="95"><img src="images/bu_search.gif" ><%= _i18n.get("msg20ms901.column.7") %></td>
          <td width="250"><input name="msgId" id="msgId" type="text" class="FormText" size="32"></td>
          <td width="50">&nbsp;</td>
        </tr>
        <tr>
          <td><img src="images/bu_search.gif"><%= _i18n.get("msg20ms901.column.5") %></td>
          <td><input name="msgOperation" id="msgOperation" type="text" class="FormText" size="32"></td>
          <td><img src="images/bu_search.gif" ><%= _i18n.get("msg20ms901.column.6") %></td>
          <td>
			<input name="f_date" id="f_date" type="text" class="FormText" size="8" maxlength="10" value="<%=strFromDate%>" onKeyDown="javascript:LoginEnterDown();" >
                  <img src="images/bu_day.gif" style="cursor: pointer; " title="Date selector" onClick="return showCalendar('f_date', '%Y-%m-%d');" align="absmiddle">
                  ~
                  <input name="t_date" id="t_date" type="text" class="FormText" size="8" maxlength="10" value="<%=strToDate%>" onKeyDown="javascript:LoginEnterDown();" >
                  <img src="images/bu_day.gif" style="cursor: pointer; " title="Date selector" onClick="return showCalendar('t_date', '%Y-%m-%d');" align="absmiddle">
		  </td>

          <td>&nbsp;</td>
        </tr>
        <tr>
          <td><img src="images/bu_search.gif"><%= _i18n.get("msg20ms901.column.2") %></td>
          <td><select name="msgType" id="msgType" class="FormSelect" style="width:187;">
                       <option value="" selected><%= _i18n.get("global.all") %></option>
                       <option value="0"><%= _i18n.get("global.msg.inbound") %></option>
                       <option value="1"><%= _i18n.get("global.msg.outbound") %></option>
            </select></td>
          <td><img src="images/bu_search.gif"><%= _i18n.get("msg20ms901.column.3") %></td>
          <td>
                  	<!-- option value="0"><%= _i18n.get("global.msg.status.unauthorized") %></option>
                  	<option value="1"><%= _i18n.get("global.msg.status.notrecognized") %></option-->
                  <select name="status" id="status" class="FormSelect" style="width:187;">
                  	<option value=""><%= _i18n.get("global.all") %></option>
                  	<option value="2"><%= _i18n.get("global.msg.status.received") %></option>
                  	<option value="3"><%= _i18n.get("global.msg.status.processed") %></option>
                  	<option value="4"><%= _i18n.get("global.msg.status.forwarded") %></option>
                  	<option value="5"><%= _i18n.get("global.msg.status.error") %></option>
                  </select>
          </td>
          <td align="right"><a href="javascript:searchMessage(1);"><img src="images/btn_go.gif" border="0" ></a></td>
        </tr>
      </table></td>
  </tr>
</table>
<!-- 토탈테이블 -->
<table class="TotalTable">
  <tr>
    <td align="left" width="80%">
      [<%= _i18n.get("global.search") %> : <span id="row_size"></span> <%= _i18n.get("global.case") %>]
      <select name="page_Cnt" id="page_Cnt" size="1" class="FormSelect" onChange="javascript:searchMessage(1)">
<%
	    String selectedStr = "";
		String pageStr = "";
		for(int i = 0; i < pageSet.length; i++) {
			pageStr = pageSet[i];
			if (pageStr.equals("10")) {
				selectedStr = "selected";
			} else {
				selectedStr = "";
			}
			out.println("<option value='"+pageStr+"' "+selectedStr+">"+pageStr+"</option>");
		}
%>
      </select>
      <%= _i18n.get("global.pages") %>
      <select name="item_Cnt" id="item_Cnt" size="1" class="FormSelect" onChange="javascript:searchMessage(1)">
<%
		String item = "";
		for(int i = 0; i < itemSet.length; i++) {
			item = itemSet[i];
			if (item.equals("10")) {
				selectedStr = "selected";
			} else {
				selectedStr = "";
			}
			out.println("<option value='"+item+"' "+selectedStr+">"+item+"</option>");
		}
%>
      </select>
      <%= _i18n.get("global.rows") %>
    </td>
    <td width="14%" align="right">
    	<a href="javascript:deleteByDate()"><img src="images/button_daydel.gif" border="0" /></a>
    </td>
    <td width="6%" align="right"><a href="javascript:deleteMessage()"><img src="images/btn_delete.gif" border="0" /></a></td>
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
<script>
	getWsdl();
</script>
</form>
</body>
</html>
