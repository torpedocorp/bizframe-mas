<%@ page contentType="text/html; charset=EUC_KR"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.mxs.wsms.dto.WsMessageVO"%>
<%@ page import="kr.co.bizframe.mxs.wsms.model.Operation"%>
<%@ page import="kr.co.bizframe.mxs.wsms.model.Wsdl"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="kr.co.bizframe.mxs.wsms.WsConstants" %>
<%@ page import="kr.co.bizframe.mxs.wsms.WsdlManager" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.dto.PartInfoVO"%>
<%@ page import="kr.co.bizframe.util.StringUtil" %>
<%
 /**
 * @author Ho-Jin Seo
 * @version 1.0
 */
//============ information of message  ================
String messageId = StringUtil.nullCheck(request.getParameter("messageId"));
String referenceId = StringUtil.nullCheck(request.getParameter("referenceId"));
String obid = StringUtil.nullCheck(request.getParameter("obid"));
String contentStr = "";

MxsEngine engine = MxsEngine.getInstance();
QueryCondition qc = new QueryCondition();
WsMessageVO msgVO = null;
Operation opVO = null;
Wsdl wsdlVO = null;
SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy.MM.dd HH:mm:ss.S");
%>
<html>
<head>
<%@ include file="./com00in000.jsp" %>
<%@ include file="./com00in003.jsp" %>
<%
if (messageId.equals("") && referenceId.equals("") &&  obid.equals("") ) {
    out.println("<script>alert('" + _i18n.get("msg21ms901.notfound") + "');history.back();</script>");
    return;
}

try {
	if (messageId != null && !messageId.equals(""))
		qc.add("wsa_message_id", messageId);
	else if (referenceId != null && !referenceId.equals(""))
		qc.add("ref_to_message", referenceId);
	else if (obid != null && !obid.equals(""))
		qc.add("obid", obid);

	msgVO = (WsMessageVO)engine.getObject("WsMessage", qc, DAOFactory.WSMS);

	if (msgVO != null) {
		qc = new QueryCondition();
		qc.add("obid", msgVO.getOperationObid());
		opVO = (Operation)engine.getObject("Operation", qc, DAOFactory.WSMS);
		WsdlManager wm = new WsdlManager();
		wsdlVO = wm.getWsdlByOperation(msgVO.getOperationObid());
		if (wsdlVO == null) wsdlVO = new Wsdl();
	}
} catch (Exception e) {
    out.println("<script>alert('" + _i18n.get("msg21ms901.notfound") + "');history.back();</script>");
    e.printStackTrace();
    return;
}
if (msgVO == null || wsdlVO == null || opVO == null) {
    out.println("<script>alert('" + _i18n.get("msg21ms901.notfound") + "');history.back();</script>");
    return;
} else {
    //BfFile content = new BfFile(msgVO.getMessageFilePath());

    //contentStr = new String(content.toByteArray());
}

String inoutStr = "";
String statusStr = WsConstants.getMessageStatusString(msgVO.getStatus());
obid = msgVO.getObid();

if(statusStr == null || statusStr.equals("")) {
	statusStr = "n/a";
}else if(statusStr.equalsIgnoreCase("UnAuthorized")) {
	statusStr = _i18n.get("global.msg.status.unauthorized");
} else if(statusStr.equalsIgnoreCase("Forwarded")) {
	statusStr = _i18n.get("global.msg.status.forwarded");
} else if(statusStr.equalsIgnoreCase("Processed")) {
	statusStr = _i18n.get("global.msg.status.processed");
	if(msgVO.getBoundFor() == WsConstants.OUTBOUND_MSG) {
		statusStr = _i18n.get("global.msg.status.send");
	}
} else if(statusStr.equalsIgnoreCase("Received")) {
	statusStr = _i18n.get("global.msg.status.received");
} else if(statusStr.equalsIgnoreCase("NotRecognized")) {
	if(msgVO.getBoundFor() == WsConstants.INBOUND_MSG){
		statusStr = _i18n.get("global.msg.status.recverror");
	} else {
		statusStr = _i18n.get("global.msg.status.senderror");
	}
} else if(statusStr.equalsIgnoreCase("Error")) {
	statusStr = _i18n.get("global.msg.status.error");
	if(msgVO.getBoundFor() == WsConstants.OUTBOUND_MSG) {
		statusStr = _i18n.get("global.msg.status.senderror");
	}
} else {
	statusStr = "---";
}

if(msgVO.getBoundFor() == WsConstants.INBOUND_MSG) {
	inoutStr = _i18n.get("global.msg.inbound");
} else {
	inoutStr = _i18n.get("global.msg.outbound");
}

if (msgVO.getInputOutput() == WsConstants.OPERATION_FAULT_MSG) {
	inoutStr = _i18n.get("global.msg.status.error");
}
%>
<title><%=_i18n.get("global.page.title")%></title>
<script language="JavaScript" type="text/JavaScript">
<!--
function viewMessage(obid, num) {
	window.open("msg22ac901.jsp?obid=" + obid + "&num=" + num, "View", "width=1010,height=800,left=0,top=0,resizable=yes,scrollbars=yes");
}

function downloadMessage(obid, num) {
	frm = document.form1;
	frm.action = "msg50ac901.jsp?obid=" + obid + "&num=" + num;
	frm.method = "post";
	frm.submit();
}

function updateComment() {
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

	var myAjax = new Ajax.Request('./msg30ac901.jsp', opt);
}

function deleteMessageOkFunction() {
	Windows.closeAllModalWindows();
	clearNotify();

	var params = Form.serialize(document.form1);

	openInfo('<%=_i18n.get("global.processing") %>');
	var opt = {
	    method: 'post',
	    postBody: params,
	    onSuccess: function(t) {
	    	//closeInfo();
	    	$('messageDisplay').innerHTML = '<%=_i18n.get("msg21ms901.operation.delete") %>';
	    	Dialog.setInfoMessage('<%=_i18n.get("msg21ms901.operation.delete") %>');
	    	timeout=2; setTimeout(goList, 1000);
	    },
	    on404: function(t) {
	    	closeInfo();
	        $('messageDisplay').innerHTML = '<%=_i18n.get("err00zz404.message") %>';
	        //showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
	    },
	    onFailure: function(t) {
	    	closeInfo();
	        $('messageDisplay').innerHTML = '<%=_i18n.get("global.error.retry") %>';
	        showErrorPopup(t.responseText, null, null, null);
			//openAlert(t.responseText, "<%=_i18n.get("global.alert")%>", "<%=_i18n.get("global.ok")%>");
			//showError(t.responseText, null, null, null);
	    }
	}

	var myAjax = new Ajax.Request('./msg40ac901.jsp', opt);
}

function deleteMessage() {
	msg = "<%=_i18n.get("msg21ms901.delete.confirm")%>";
	openConfirm(msg, deleteMessageOkFunction, null, "<%=_i18n.get("global.warning")%>");
}

function goList() {
	timeout--;
	if (timeout >0) {
		setTimeout(goList, 1000) ;
	} else {
		history.go(-1);
	}
}
function viewMessageByObid(obid) {
	if (obid != "")
		location.href = "msg21ms901.jsp?obid=" + obid;
}

function viewMessageById(message_id) {
	if (obid != "")
		location.href = "msg21ms901.jsp?messageid=" + message_id;
}
-->
</script>
</head>

<body>
<!-- 제목 테이블 -->
<table class="TableLayout">
  <tr>
    <td width="25%" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.msg.view")%></td>
    <td width="75%" class="MessageDisplay" ><div id=messageDisplay></div></td>
  </tr>
  <tr>
    <td colspan="2" height="10"></td>
  </tr>
</table>
<!-- 등록테이블-->
<form name="form1" method="post" >
<table class="FieldTable">
<input type="hidden" name="obid" value="<%= obid %>">
  <tr>
    <td width="120" class="FieldLabel"><%=_i18n.get("global.msg.id")%></td>
    <td colspan="3" class="FieldData">
            <input name="textfield22222" type="text" class="FormTextReadOnly" readonly value="<%= StringUtil.checkNull(msgVO.getWsaMessageId()) %>" style="width:520;">
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%=_i18n.get("global.wsdl.name")%></td>
    <td width="260" class="FieldData">
		  <input name="textfield2222" type="text" class="FormTextReadOnly" readonly value="<%= wsdlVO.getName() %>" size="32">
    </td>
    <td width="120" class="FieldLabel"><%=_i18n.get("global.msg.date")%></td>
    <td width="260" class="FieldData"><input name="textfield222223" type="text" class="FormTextReadOnly" readonly size="32" value="<%= sdf1.format(msgVO.getTimestamp()) %>"></td>
        </tr>
        <tr>
    <td class="FieldLabel"><%=_i18n.get("global.msg.inout")%></td>
    <td class="FieldData"><input name="textfield222225" type="text" class="FormTextReadOnly" readonly size="32" value="<%= inoutStr %>"></td>
    <td class="FieldLabel"><%=_i18n.get("global.msg.status")%></td>
    <td class="FieldData"><input name="textfield222224" type="text" class="FormTextReadOnly" readonly size="32" value="<%= statusStr %>"></td>
  </tr>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("global.msg.from")%></td>
    <td class="FieldData"><input name="textfield222226" type="text" class="FormTextReadOnly" readonly size="32" value="<%= (msgVO.getWsaFromUri() == null ? "" : msgVO.getWsaFromUri()) %>"></td>
    <td class="FieldLabel"><%=_i18n.get("global.msg.to")%></td>
    <td class="FieldData"><input name="textfield222227" type="text" class="FormTextReadOnly" readonly size="32" value="<%= (msgVO.getWsaToUri()==null?"":msgVO.getWsaToUri()) %>"></td>
  </tr>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("global.msg.operation")%></td>
    <td colspan="3" class="FieldData"><input name="textfield222222" type="text" class="FormTextReadOnly" readonly size="32" value="<%= opVO.getName() %>"></td>
  </tr>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("global.msg.comment")%></td>
    <td colspan="3" class="FieldData"><input name="comment" id="comment" type="text" class="FormText" size="98" value="<%= (msgVO.getUserComment()==null? "" : msgVO.getUserComment()) %>">
		  <a href="javascript:updateComment()"><img src="images/btn_update.gif" align="absmiddle" border="0"></a></td>
  </tr>
<%
if (msgVO.getRefToMessage() != null && !msgVO.getRefToMessage().equals("")) {
%>
  <tr>
    <td width="120" class="FieldLabel"><%=_i18n.get("global.msg.referralid")%></td>
    <td colspan="3" class="FieldData"><a href="javascript:viewMessageByObid('<%=StringUtil.nullCheck(msgVO.getRefToMessage()) %>')"><%= msgVO.getRefToMessage() %></a></td>
  </tr>
<%
} else {
	qc = new QueryCondition();
	qc.add("ref_to_message", msgVO.getObid());
	WsMessageVO referrerMsgVO = (WsMessageVO)engine.getObject("WsMessage", qc, DAOFactory.WSMS);
	if (referrerMsgVO != null) {
%>
  <tr>
    <td width="120" class="FieldLabel"><%=_i18n.get("global.msg.referrerid")%></td>
    <td colspan="3" class="FieldData"><a href="javascript:viewMessageByObid('<%= referrerMsgVO.getObid() %>')"><%= referrerMsgVO.getObid() %></a></td>
  </tr>
<%
	}
}
%>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("msg21ms901.msg.body")%></td>
    <td colspan="3" class="FieldData"><img src="images/xml.gif" width="39" height="20" align="absmiddle">
      <a href="javascript:viewMessage('<%=obid%>', 0);"><img src="images/btn_inview.gif" width="39" height="13" align="absmiddle" border="0"></a>
      <a href="javascript:downloadMessage('<%= obid%>', 0);"><img src="images/btn_indown.gif" width="62" height="13" align="absmiddle" border="0"></a>
    </td>
  </tr>
</table>
</form>
<br>
<!-- 결과 목록 테이블 코드 시작-->
<%
if (msgVO.getPartInfos().size() > 0) {
%>
<table class="TableLayout" >
  <col width=" 30" align="center">
  <col width="">
  <col width="">
  <col width="">
  <col width="120" align="center">
  <tr>
    <td class="ResultHeader"><%=_i18n.get("msg21ms901.column.1")%></td>
    <td class="ResultHeader"><%=_i18n.get("msg21ms901.column.2")%></td>
    <td class="ResultHeader"><%=_i18n.get("msg21ms901.column.3")%></td>
    <td class="ResultHeader"><%=_i18n.get("msg21ms901.column.4")%></td>
    <td class="ResultLastHeader">&nbsp; </td>
  </tr>
<%
	String color = null;
	for (int i=0; i<msgVO.getPartInfos().size(); i++) {
		color = i % 2 == 0 ? "#FFFFFF" : "#F9F9F9";
		PartInfoVO partVO = (PartInfoVO)msgVO.getPartInfos().get(i);
		String cid = partVO.getContentId();
		cid = cid.replaceAll("<", "&lt;");
		cid = cid.replaceAll(">", "&gt;");
%>
  <tr>
    <td class="ResultData"><%= i+1 %></td>
    <td class="ResultData"><%= cid %></td>
    <td class="ResultData"><%= partVO.getContentType() %></td>
    <td class="ResultData"><%= (partVO.getDescription() == null ? "&nbsp;" : partVO.getDescription()) %></td>
    <td class="ResultLastData"><a href="javascript:viewMessage('<%=obid%>', <%= i+1 %>)"><img src="images/btn_inview.gif" width="39" height="13" align="absmiddle" border="0"></a>
      <a href="javascript:downloadMessage('<%=obid%>', <%= i+1 %>)"><img src="images/btn_indown.gif" width="62" height="13" align="absmiddle" border="0"></a>
    </td>
  </tr>
<%
	}
}
%>
</table>
<table class="TableLayout" >
  <tr>
    <td align="right" style="padding-top:15"><a href="javascript:goList()"><img src="images/btn_big_list.gif" width="39" height="23" border="0"></a>
       <a href="javascript:deleteMessage()"><img src="images/btn_big_delete.gif" width="39" height="23" border="0"></a>
    </td>
  </tr>
</table>
</body>
</html>
