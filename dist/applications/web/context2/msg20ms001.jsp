<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="kr.co.bizframe.mxs.ebms.EbConstants"%>
<%
/**
 * List ebMessage
 *
 * @author Gemini Kim
 * @author Ho-Jin Seo
 * @author Mi-Young Kim
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
<!-- get wsdlList -->
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
	}
*/
}
function historyChange(newLocation, historyData) {
	var historyMsg = historyData;

//   if (historyData != null && historyData == "") {
			Form.deserialize(document.form1, historyData);
			getMessages();
//   }
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

		$('cpaId').disabled = true;
		$('msgId').disabled = true;
		$('msgOperation').disabled = true;
		$('msgStatus').disabled = true;
		$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("msg20ms901.message.select.date") %>';
		$('delbydate').value = 1;
	}

}

function deleteByDateCancel() {
	$('cpaId').disabled = false;
	$('msgId').disabled = false;
	$('msgOperation').disabled = false;
	$('msgStatus').disabled = false;
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
		if(check_index == null || check_index == '') {
				msg = "<%=_i18n.get("msg20ms001.non.selected")%>";
				openAlert(msg, "<%=_i18n.get("global.alert")%>",
							"<%=_i18n.get("global.ok")%>");
		} else {
				msg = "<%=_i18n.get("msg20ms001.delete.confirm")%>";
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
	var myAjax = new Ajax.Request("./msg40ac001.jsp", opt);
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
	var myAjax = new Ajax.Request("./msg40ac002.jsp", opt);
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

// By J-.H. Kim on 2008.05.19
//function viewMessage(id)
//{
	//window.open("msg21ms901.jsp?messageId="+id,"msgview","width=800,height=920,left=0,top=0,resizable=yes,scrollbars=yes");
//   location.href = "msg21ms901.jsp?messageId=" + id;
//}

function LoginEnterDown(){
	if(event.keyCode==13){
			getMessages();
	}
}

function loading() {
	var body = "";

	body = '<table class="TableLayout">';
	body +='<tr>';
	body +='  <td class="ResultHeader"><%= _i18n.get("msg20ms001.list.inout") %></td>';
	body +='  <td class="ResultHeader"><%= _i18n.get("msg20ms001.list.status") %></td>';
	body +='  <td class="ResultHeader"><%= _i18n.get("msg20ms001.list.timestamp") %></td>';
	body +='  <td class="ResultHeader"><%= _i18n.get("global.cpaid") %></td>';
	body +='  <td class="ResultHeader"><%= _i18n.get("msg20ms001.list.service.name") %></td>';
	body +='  <td class="ResultHeader"><%= _i18n.get("msg20ms001.list.action.name") %></td>';
	body +='  <td class="ResultLastHeader"><input type="checkbox" id="chbox" name="allChkBtn" value="" class="gray-text" onClick="javascript:mainAllCheck();"></td>';
	body +='</tr>';
	body += '<tr>';
	body += '   <td colspan="7" class="ResultLastData" align="center"><%= _i18n.get("global.loading")%></td></tr>';

	body += "</table>";


	$('listContent').innerHTML = body;

}

function showList(originalRequest) {

	var res = eval("(" + originalRequest.responseText + ")");

	var operations = "";
	var performers = "";
	var body = "";

	body = '<table class="TableLayout">';
	body +='<tr>';
	body +='  <td class="ResultHeader"><%= _i18n.get("msg20ms001.list.inout") %></td>';
	body +='  <td class="ResultHeader"><%= _i18n.get("msg20ms001.list.status") %></td>';
	body +='  <td class="ResultHeader"><%= _i18n.get("msg20ms001.list.timestamp") %></td>';
	body +='  <td class="ResultHeader"><%= _i18n.get("global.cpaid") %></td>';
	body +='  <td class="ResultHeader"><%= _i18n.get("msg20ms001.list.service.name") %></td>';
	body +='  <td class="ResultHeader"><%= _i18n.get("msg20ms001.list.action.name") %></td>';
	body +='  <td class="ResultLastHeader"><input type="checkbox" id="chbox" name="allChkBtn" value="" class="gray-text" onClick="javascript:mainAllCheck();"></td>';
	body +='</tr>';


	for (var i=0; i<res.messages.length; i++) {
			color = i % 2 == 0 ? "#FFFFFF" : "#F9F9F9";

			body += '<tr>';
			//body += '<td height="45" bgcolor="' + color + '" >' + res.messages[i].inout + '</td>';
			body += '   <td class="ResultData" >' + res.messages[i].inout + '</td>';

			if (res.messages[i].status == 0 || res.messages[i].status == 1 || res.messages[i].status == 5 ) {
				textcolor = 'red';
			} else {
				textcolor = 'blue';
			}
			body += '   <td class="ResultData" >' + res.messages[i].status + '</td>';
			body += '   <td class="ResultData" >' + res.messages[i].time + '</td>';
			body += '   <td class="ResultData" >' + res.messages[i].cpaid + '</td>';
			body += '   <td class="ResultData" >' + res.messages[i].service + '</td>';
			body += '   <td class="ResultData" ><a href="msg21ms001.jsp?obid='+res.messages[i].obid+'">' + res.messages[i].action + '</a></td>';
			body += '   <td class="ResultLastData"><input type="checkbox" name="msgObid" id="msgObid" value="'+res.messages[i].obid+'"></td>';
			body += '</tr>';
	}
	if (res.totalRows == 0) {
			body += '<tr>';
				body += '<td colspan="7" class="ResultLastData" align="center"><%= _i18n.get("msg20ms001.notfound")%></td></tr>';
	}

	body += "</table>";


	$('listContent').innerHTML = body;

	$('row_size').innerHTML = res.totalRows;
	$('pagelist').innerHTML = res.pagelist;
}

function getMessages() {

	loading();

	var params = Form.serialize(document.form1);
	var opt = {
			method: 'post',
			parameters: params,
			onSuccess: showList,
			on404: function(t) {
					$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("err00zz404.message") %>';
				//   showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
			},
			onFailure: function(t) {
					$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("global.error.retry") %>';
					showErrorPopup(t.responseText, null, null, null);
			}
	}
	var myAjax = new Ajax.Request("msg20ac001.jsp", opt);
}

function searchMessage(page) {
	if (page == null || page == '') {
			page = 1;
	}

	$('curPage').value = page;
	$('messageDisplay').innerHTML = '';

	var params = Form.serialize(document.form1);
//   dhtmlHistory.add((new Date()).toString(), params);

	getMessages();
}

function displayCpaList(originalRequest) {
	var res = eval("(" + originalRequest.responseText + ")");

	var operations = "";
	var performers = "";
	var body = "";
	for (var i=0; i<res.cpa.length; i++) {
			$('cpaId').options[i+1] = new Option(res.cpa[i].id,res.cpa[i].id);
	}
}

function getCpa() {
	//$('content').innerHTML = "<div id='modal_dialog_progress' class='alphacube_progress'>  </div>";

	var opt = {
			method: 'get',
			parameters: '',
			onSuccess: displayCpaList,
			on404: function(t) {
					$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("err00zz404.message") %>';
				//   showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
			},
			onFailure: function(t) {
					$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("global.error.retry") %>';
					showErrorPopup(t.responseText, null, null, null);
			}
	}
	var myAjax = new Ajax.Request("msg20ac002.jsp", opt);

}

//-->
</script>
</head>
<body bgcolor=#FFFFFF leftmargin=0 topmargin=0 marginwidth=0 marginheight=0 onLoad="initialize()">

<form name="form1" method="POST">
<input type="hidden" name="curPage" id="curPage" value="1">
<input type="hidden" name="delbydate" id="delbydate" value="0">
<!-- 제목 테이블 -->
<table class="TableLayout">
	<tr>
		<td width="120" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.msg.list")%></td>
		<td width="640" class="MessageDisplay" >
			<div id="messageDisplay"></div></td>
	</tr>
	<tr>
		<td colspan="3" height="6"></td>
	</tr>
</table>


<!--SelectTable 시작 -->
<table class="SearchTable"  >
	<tr>
			<td style="padding:10px"><table>
				<tr>
					<td width="95"><img src="images/bu_search.gif" ><%= _i18n.get("global.cpaid") %></td>
					<td width="250">
						<select name="cpaId" id="cpaId" style="width:187;" class='FormSelect'>
							<option value=""><%= _i18n.get("global.all") %></option>
						</select>
						</td>
					<td width="95"><img src="images/bu_search.gif" ><%= _i18n.get("msg20ms001.search.message.id") %></td>
					<td width="250">
						<input type="text" name="msgId" id="msgId" class="FormText" size="32" onKeyDown="javascript:LoginEnterDown();" ></td>
					<td width="50" align="right">&nbsp;</td>
				</tr>
				<tr>
					<td><img src="images/bu_search.gif" ><%= _i18n.get("msg20ms001.search.message.action") %></td>
					<td width="250">
						<input type="text" name="msgAction" id="msgOperation" class="FormText" size="32" onKeyDown="javascript:LoginEnterDown();" ></td>
					<td width="95"><img src="images/bu_search.gif" ><%= _i18n.get("msg20ms001.search.date") %></td>
					<td width="250">
			<input name="f_date" id="f_date" type="text" class="FormText" size="8" maxlength="10" value="<%=strFromDate%>" onKeyDown="javascript:LoginEnterDown();" >
					<img src="images/bu_day.gif" style="cursor: pointer; " title="Date selector" onClick="return showCalendar('f_date', '%Y-%m-%d');" align="absmiddle">
					~
					<input name="t_date" id="t_date" type="text" class="FormText" size="8" maxlength="10" value="<%=strToDate%>" onKeyDown="javascript:LoginEnterDown();" >
					<img src="images/bu_day.gif" style="cursor: pointer; " title="Date selector" onClick="return showCalendar('t_date', '%Y-%m-%d');" align="absmiddle">
					</td>
					<td width="50" align="right">&nbsp;</td>
				</tr>
				<tr>
					<td><img src="images/bu_search.gif"><%= _i18n.get("msg20ms901.column.2") %></td>
					<td><select name="msgType" id="msgType" class="FormSelect" style="width:187;">
											<option value="" selected><%= _i18n.get("global.all") %></option>
											<option value="0"><%= _i18n.get("global.msg.inbound") %></option>
											<option value="1"><%= _i18n.get("global.msg.outbound") %></option>
						</select></td>
					<td><img src="images/bu_search.gif" ><%= _i18n.get("msg20ms001.search.message.status") %></td>
					<td width="250">
						<select name="msgStatus" id="msgStatus" size="1" class="FormSelect" style="width:187;">
								<option value="" selected><%= _i18n.get("global.all") %></option>
								<option value="<%= EbConstants.MESSAGE_STATUS_UNAUTHORIZED %>"><%= _i18n.get("global.msg.status.unauthorized") %></option>
								<option value="<%= EbConstants.MESSAGE_STATUS_NOT_RECOGNIZED %>"><%= _i18n.get("global.msg.status.notrecognized") %></option>
								<option value="<%= EbConstants.MESSAGE_STATUS_RECEIVED %>"><%= _i18n.get("global.msg.status.received") %></option>
								<option value="<%= EbConstants.MESSAGE_STATUS_PROCESSED %>"><%= _i18n.get("global.msg.status.processed") %></option>
								<option value="<%= EbConstants.MESSAGE_STATUS_FORWARDED %>"><%= _i18n.get("global.msg.status.forwarded") %></option>
								<option value="-1"><%= _i18n.get("global.msg.status.error") %></option>
						</select>
						</td>
					<td width="50" align="right">
						<a href="javascript:searchMessage(1);"><img src="images/btn_go.gif" border="0" style="cursor:hand;"></a></td>
				</tr>
			</table></td>
	</tr>
</table>

<!-- 총개수 테이블 -->
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

<!-- ---------------->
<!-- 검색결과 목록 -->
<!-- ---------------->
<table>
	<tr>
		<td>
				<div id="listContent"></div>
						<script>
							getCpa();
						</script>
		</td>
	</tr>
</table>

<table class="PageNavigationTable" >
	<tr>
		<td height="34" align="center"> <table cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td class="listAPaging" valign="center"><span id="pagelist"></span></td>
				</tr>
			</table></td>
	</tr>
</table>


</form>
</body>
</html>
