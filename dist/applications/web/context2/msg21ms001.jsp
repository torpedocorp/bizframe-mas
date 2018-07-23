<%@ page contentType="text/html; charset=EUC-KR" language="java"%>

<%
	/**
		* Detaiil Message
		*
		* @author Gemini Kim
		* @author Mi-Young Kim
		* @version 1.0
		*/
%>
<html>
<head>
<%@ include file="com00in000.jsp" %>
<%@ include file="com00in001.jsp" %>
<%@ include file="com00in003.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>
<script language="JavaScript" type="text/JavaScript">
<!--
function deleteFunction() {
	closeInfo();

	var params = Form.serialize(document.form1);
	var opt = {
			method: 'get',
			parameters: params,
			onSuccess: function(t) {
				$('messageDisplay').innerHTML = '<%= _i18n.get("msg20ms901.message.deleted") %>';
				openAlert('<%= _i18n.get("msg20ms901.message.deleted") %>');
				location.href="msg20ms001.jsp";
			},
			on404: function(t) {
					$('messageDisplay').innerHTML = '<%=_i18n.get("err00zz404.message") %>';
				//   showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
			},
			onFailure: function(t) {
					$('messageDisplay').innerHTML = '<%=_i18n.get("global.error.retry") %>';
					showErrorPopup(t.responseText, null, null, null);
			}
	}
	var myAjax = new Ajax.Request("msg40ac001.jsp", opt);
}



function deleteMessage() {
	// 변경내역_40
	if ($('msgType').value == "EbMessage") {
		msg = "<%=_i18n.get("msg20ms901.delete.confirm")%>";
		openConfirm(msg, deleteFunction, null, "<%=_i18n.get("global.warning")%>");
	} else {
		alert("<%=_i18n.get("msg21ms001.spamletter.noupdate") %>");
	}
}

function viewMessage() {
	var s_obid = document.getElementById("msg.obid").value;
	var url = 'msg22ac001.jsp?s_obid='+s_obid+'&type=message';
	window.open(url, "MessageView", "width=1010,height=620,left=0,top=0,resizable=yes,scrollbars=yes");
}

function downMessage() {
	var s_obid = document.getElementById("msg.obid").value;
	location.href = 'msg50ac001.jsp?s_obid='+s_obid+'&type=message';
	//window.open(url, "MessageView", "width=1010,height=620,left=0,top=0,resizable=yes,scrollbars=yes");
}

function viewPart(s_obid, p_obid) {
	var url = 'msg22ac001.jsp?s_obid='+s_obid+'&p_obid='+p_obid+'&type=part';
	window.open(url, "MessageView", "width=1010,height=520,left=0,top=0,resizable=yes,scrollbars=yes");
}

function convertCharacter(str) {
	var result = '';
	for(i=0; i<str.length; i++) {
			var ch = str.charAt(i);
			if(ch == '<') result += '&lt;';
			else if(ch == '>') result += '&gt;';
			else result += ch;
	}

	return result;
}

function getMessageInfo() {

	var params = Form.serialize(document.form1);
	var opt = {
			method: 'post',
			parameters: params,
			onSuccess: show,
			on404: function(t) {
					$('messageDisplay').innerHTML = '<%=_i18n.get("err00zz404.message") %>';
					showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
			},
			onFailure: function(t) {
					$('messageDisplay').innerHTML = '<%=_i18n.get("global.error.retry") %>';
					showErrorPopup(t.responseText, null, null, null);
			}
	}

	var myAjax = new Ajax.Request("msg21ac001.jsp", opt);
}

function show(originalRequest) {
	var res = eval("(" + originalRequest.responseText + ")");
	this.document.getElementById('msg.obid').value = res.obid;
	this.document.getElementById('msgId').value          = res.msgId;
	this.document.getElementById('cpaId').value          = res.cpaId;

	if (res.inOut == '1') {
		this.document.getElementById('inOut').value =
			'<%= _i18n.get("global.msg.outbound") %>';
	} else {
		this.document.getElementById('inOut').value =
			'<%= _i18n.get("global.msg.inbound") %>';
	}

	this.document.getElementById('serviceName').value    = res.serviceName;
	this.document.getElementById('actionName').value     = res.actionName;
	this.document.getElementById('timeStamp').value      = res.timeStamp;
	this.document.getElementById('status').value         = res.status;
	this.document.getElementById('comment').value        = res.comment;

	if (res.referralid != null && res.referralid.length > 0) {
		referralidStr = "";
		referralidStr += '<table class="FieldTable"><tr>';
		referralidStr += '<td class="FieldLabel"><%=_i18n.get("global.msg.referralid")%></td>';
		referralidStr += '<td colspan="3" class="FieldData"><a href="msg21ms001.jsp?id='+ res.referralid +'">' + res.referralid + '</a></td>';
		referralidStr += '</tr></table><br>';
		$('referralid').innerHTML = referralidStr;
	}
	if (res.referrerid != null && res.referrerid.length > 0) {
		referreridStr = "";
		referreridStr += '<table class="FieldTable"><tr>';
		referreridStr += '<td class="FieldLabel"><%=_i18n.get("global.msg.referrerid")%></td>';
		referreridStr += '<td colspan="3" class="FieldData"><a href="msg21ms001.jsp?id='+ res.referrerid +'">' + res.referrerid + '</a></td>';
		referreridStr += '</tr></table><br>';
		$('referrerid').innerHTML = referreridStr;
	}

	// 변경내역_40
	$('msgType').value = res.msgType;

	for (var i=0; i<res.list.length; i++) {
			var color = i % 2 == 0 ? "#FFFFFF" : "#F9F9F9";
			tmp = convertCharacter(res.list[i].contentId);
			if (i==0) {
		body = "";
		body += '<table class="TableLayout" >';
		body += '   <col width=" 30" align="center"> ';
		body += '   <col width=""> ';
		body += '   <col width=""> ';
		body += '   <col width=""> ';
		body += '   <col width="110" align="center"> ';
		body += '   <tr> ';
		body += '      <td class="ResultHeader"><%=_i18n.get("msg21ms001.attach.id") %></td>';
		body += '      <td class="ResultHeader"><%=_i18n.get("msg21ms001.content.id")%></td>';
		body += '      <td class="ResultHeader"><%=_i18n.get("msg21ms001.attach.type")%></td>';
		body += '      <td class="ResultHeader"><%=_i18n.get("msg21ms001.attach.description")%></td>';
		body += '      <td class="ResultLastHeader">&nbsp</td>';
		body += '   </tr>';
			}
			body += '<tr>';
			body += '   <td class="ResultData">'+(i+1)+'</td>';
			body += '   <td class="ResultData">'+tmp+'</td>';
			body += '   <td class="ResultData">'+res.list[i].contentType+'</td>';
			body += '   <td class="ResultData">'+res.list[i].description+'</td>';
			body += '   <td class="ResultLastData" align="center">';
			body += '      <a href="javascript:viewPart(\''+res.obid+'\' , \'' + res.list[i].obid + '\');"><img src="images/btn_inview.gif" width="39" height="13" align="absmiddle" border="0" style="cursor:hand;"></a> ';
			body += '      <a href="msg50ac001.jsp?s_obid='+res.obid+'&p_obid=' + res.list[i].obid + '&type=part"><img src="images/btn_indown.gif" width="62" height="13" align="absmiddle" border="0" style="cursor:hand;"></a> ';

			body += '   </td>';
			body += '</tr>';

	}

	if (res.totalRows == 0) {
			body += '<tr>';
				body += '<td class="ResultData" colspan="5" align="center">첨부파일 정보가 없습니다.</td></tr>';
	}

	body += "</table>";

	$('listContent').innerHTML = body;

}

function updateComment() {
	// 변경내역_40
	if ($('msgType').value == "EbMessage") {
		Windows.closeAllModalWindows();
		clearNotify();

		var params = Form.serialize(document.form1);

		openInfo('<%=_i18n.get("global.processing") %>');
		var opt = {
				method: 'post',
				postBody: params,
				onSuccess: function(t) {
					closeInfo();
					$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("msg21ms901.operation.update") %>';
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
		var myAjax = new Ajax.Request('./msg30ac001.jsp', opt);
	} else {
		alert("<%=_i18n.get("msg21ms001.spamletter.noupdate") %>");
	}

}

function goList() {
	history.go(-1);
}

//-->
</script>
</head>
<body bgcolor=#FFFFFF leftmargin=0 topmargin=0 marginwidth=0 marginheight=0>

<!-- 검색 Form 시작 ... -->
<form name="form1" method="POST">

<input type="hidden" name="msg.obid" id="msg.obid" value="<%=request.getParameter("obid")%>">
<input type="hidden" name="msg.id" id="msg.id" value="<%=request.getParameter("id")%>">
<input type="hidden" name="msg.refId" id="msg.refId" value="<%=request.getParameter("refId")%>">
<input type="hidden" name="msgType" id="msgType" value="">

<!-- 제목테이블 -->
<table class="TableLayout">
	<tr>
		<td width="180" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.msg.view")%></td>
		<td width="580" class="MessageDisplay" >&nbsp;<div id=messageDisplay></td>
	</tr>
	<tr>
		<td colspan="2" height="10"></td>
	</tr>
</table>

<!-- 상세정보 테이블-->
<table class="FieldTable">
	<tr>
		<td width="120" class="FieldLabel"><%= _i18n.get("msg21ms001.detail.message.id") %></td>
		<td colspan="3" class="FieldData">
			<input type="text" name="msgId" id="msgId" class="FormTextReadOnly" readonly value="" size="90">
		</td>
	</tr>
	<tr>
		<td class="FieldLabel"><%= _i18n.get("global.cpaid") %></td>
		<td width="260" class="FieldData">
			<input type="text" name="cpaId" id="cpaId" class="FormTextReadOnly" value="" size="32"></td>
		<td width="120" class="FieldLabel"><%= _i18n.get("msg21ms001.detail.inout") %></td>
		<td width="260" class="FieldData">
			<input type="text" name="inOut" id="inOut" class="FormTextReadOnly" value="" size="32"></td>
	</tr>
	<tr>
		<td class="FieldLabel"><%= _i18n.get("msg21ms001.detail.service.name") %></td>
		<td class="FieldData">
			<input type="text" name="serviceName" id="serviceName" class="FormTextReadOnly" value="" size="32">
		</td>
		<td class="FieldLabel"><%= _i18n.get("msg21ms001.detail.action.name") %></td>
		<td class="FieldData">
			<input type="text" name="actionName" id="actionName" class="FormTextReadOnly" value="" size="32"></td>
	</tr>
	<tr>
		<td class="FieldLabel"><%= _i18n.get("msg21ms001.detail.timestamp") %></td>
		<td class="FieldData">
			<input type="text" name="timeStamp" id="timeStamp" class="FormTextReadOnly" value="" size="32"></td>
		<td class="FieldLabel"><%= _i18n.get("msg21ms001.detail.status") %></td>
		<td class="FieldData">
			<input type="text" name="status" id="status" class="FormTextReadOnly" value="" size="32">
		</td>
	</tr>
	<!-- tr>
		<td class="FieldLabel">관련 인증서</td>
		<td colspan="3" class="FieldData">
			<input name="textfield2242" type="text" class="FormText" size="90">
		</td>
	</tr -->
	<tr>
		<td class="FieldLabel"><%=_i18n.get("global.msg.comment")%></td>
		<td colspan="3" class="FieldData"><input name="comment" id="comment" type="text" class="FormText" size="98" value="">
			<a href="javascript:updateComment()"><img src="images/btn_update.gif" align="absmiddle" border="0"></a></td>
	</tr>
	<tr>
		<td class="FieldLabel"><%= _i18n.get("msg21ms001.msg.body") %></td>
		<td colspan="3" class="FieldData"><img src="images/xml.gif" width="39" height="20">
			<a href="javascript:viewMessage()">
				<img src="images/btn_inview.gif" width="39" height="13" align="absmiddle" border="0"></a>
			<a href="javascript:downMessage()">
				<img src="images/btn_indown.gif" width="62" height="13" align="absmiddle" border="0"></a>
		</td>
	</tr>
</table>
<br>
<!-- 이 메시지가 참조하는 메시지 -->
<table class="TableLayout">
	<tr>
			<td><div id="referralid"></div></td>
	</tr>
</table>

<!-- 이 메시지를  참조하는 메시지 -->
<table class="TableLayout">
	<tr>
			<td><div id="referrerid"></div></td>
	</tr>
</table>

<table class="TableLayout">
	<tr>
			<td>
				<div id="listContent"></div>
									<script>
									getMessageInfo();
									</script>
			</td>
	</tr>
</table>

<!-- 버튼테이블 -->
<table class="TableLayout" >
	<tr>
		<td align="right" style="padding-top:15">
			<a href="javascript:goList()"><img src="images/btn_big_list.gif" width="39" height="23" border="0"></a>
			<a href="javascript:deleteMessage();"><img src="images/btn_big_delete.gif" width="39" height="23" border="0"></a>
		</td>
	</tr>
</table>

</form>

</body>
</html>
