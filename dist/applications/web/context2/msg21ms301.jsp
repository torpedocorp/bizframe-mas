<%@ page contentType="text/html; charset=EUC_KR"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%@ page import="kr.co.bizframe.mxs.MxsConstants"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.Eb3Constants"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.Eb3Message"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.PartInfo"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.Property"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.RefToMessageVO"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.SignalMessage"%>
<%@ page import="kr.co.bizframe.mxs.ebms.EbConstants"%>
<%@ page import="kr.co.bizframe.mxs.soap.PayloadContainer"%>
<%
/**
 * 사용자 메시지 상세 조회
 *
 * @author Ho-Jin Seo
 * @version 1.0
 */
 try{
String messageId = StringUtil.nullCheck(request.getParameter("messageId"));
String referenceId = StringUtil.nullCheck(request.getParameter("referenceId"));
String obid = StringUtil.nullCheck(request.getParameter("obid"));
String contentStr = "";

MxsEngine engine = MxsEngine.getInstance();
QueryCondition qc = new QueryCondition();
Eb3Message msgVO = null;
SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy.MM.dd HH:mm:ss.S");
%>
<html>
<head>
<%@ include file="./com00in000.jsp" %>
<%@ include file="./com00in003.jsp" %>
<%
if (messageId.equals("") && referenceId.equals("") &&  obid.equals("") ) {
    out.println("<script>alert('" + _i18n.get("msg21ms301.notfound") + "');history.back();</script>");
   	return;
}

try {
	if (!messageId.equals("")) {
		qc.add("message_id", messageId);
	} else if (!referenceId.equals("")) {
		qc.add("ref_to_message_id", referenceId);
	} else {
		qc.add("obid", obid);
	}
	msgVO = (Eb3Message)engine.getObject("Eb3UserMessage", qc, DAOFactory.EBMS3);

} catch (Exception e) {
    out.println("<script>alert('" + _i18n.get("msg21ms301.notfound") + "');history.back();</script>");
    e.printStackTrace();
    return;
}
if (msgVO == null) {
    out.println("<script>alert('" + _i18n.get("msg21ms301.notfound") + "');history.back();</script>");
    return;
} else {
    //BfFile content = new BfFile(msgVO.getMessageFilePath());

    //contentStr = new String(content.toByteArray());
}

String inoutStr = "";
String statusStr = EbConstants.getMessageStatusString(msgVO.getStatus());
obid = msgVO.getUserMessage().getObid();

/*
if(statusStr == null || statusStr.equals("")) {
	statusStr = "n/a";
}else if(statusStr.equalsIgnoreCase("UnAuthorized")) {
	statusStr = _i18n.get("global.msg.status.unauthorized");
} else if(statusStr.equalsIgnoreCase("Forwarded")) {
	statusStr = _i18n.get("global.msg.status.forwarded");
} else if(statusStr.equalsIgnoreCase("Processed")) {
	statusStr = _i18n.get("global.msg.status.processed");
	if(msgVO.getBoundFor() == MxsConstants.MESSAGE_BOUND_FOR_IN) {
		statusStr = _i18n.get("global.msg.status.send");
	}
} else if(statusStr.equalsIgnoreCase("Received")) {
	statusStr = _i18n.get("global.msg.status.received");
} else if(statusStr.equalsIgnoreCase("NotRecognized")) {
	if(msgVO.getBoundFor() == MxsConstants.MESSAGE_BOUND_FOR_IN){
		statusStr = _i18n.get("global.msg.status.recverror");
	} else {
		statusStr = _i18n.get("global.msg.status.senderror");
	}
} else if(statusStr.equalsIgnoreCase("Error")) {
	statusStr = _i18n.get("global.msg.status.error");
	if(msgVO.getBoundFor() == MxsConstants.MESSAGE_BOUND_FOR_OUT) {
		statusStr = _i18n.get("global.msg.status.senderror");
	}
} else {
	statusStr = "---";
}
*/

if(msgVO.getBoundFor() == MxsConstants.MESSAGE_BOUND_FOR_IN) {
	inoutStr = _i18n.get("global.msg.inbound");
} else {
	inoutStr = _i18n.get("global.msg.outbound");
}
%>
<title><%=_i18n.get("global.page.title")%></title>
<style>
.tooltip, .green {
  /*color:#191;
  text-decoration: underline;*/
}

.tooltip_content{
  padding:10px; border:1px solid #ccc;
  background:#eee; font-size: small;
  font: 14px "Trebuchet MS",Verdana,Arial,sans-serif;
  overflow:hidden;
  /*margin:0;
  padding:0;*/
}
.tooltip_content h3 {
  margin:0;
  padding:0;
  background:#FFFFFF;
  text-align:center;
}

</style>
<script language="JavaScript" type="text/JavaScript">
<!--
function viewMessage(obid, href) {
	window.open("msg22ac301.jsp?obid=" + obid + "&href=" + href, "View", "width=1010,height=800,left=0,top=0,resizable=yes,scrollbars=yes");
}

function downloadMessage(obid, href) {
	frm = document.form1;
	frm.action = "msg50ac301.jsp?obid=" + obid + "&href=" + href;
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
	    	$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("msg21ms301.operation.update") %>';
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

	var myAjax = new Ajax.Request('./msg30ac301.jsp', opt);
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
	    	$('messageDisplay').innerHTML = '<%=_i18n.get("msg21ms301.operation.delete") %>';
	    	Dialog.setInfoMessage('<%=_i18n.get("msg21ms301.operation.delete") %>');
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

	var myAjax = new Ajax.Request('./msg40ac301.jsp', opt);
}

function deleteMessage() {
	msg = "<%=_i18n.get("msg21ms301.delete.confirm")%>";
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
function viewRefMessage(obid)
{
	refid = obid;
	if (refid != "")
		location.href = "msg21ms301.jsp?messageId=" + refid;
}

function viewPartProperties(div_name) {
	Windows.closeAllModalWindows();

    //var effect = new PopupEffect(html, {className: "popup_effect2", duration: 2, fromOpacity: 0.2, toOpacity: 0.4});
    var win = new Window({
		title: "Title",
    	className:"error",
		closable:true,
		maximizable:false,
		minimizable:false,
    	width: 600, height:null
    });
    win.getContent().innerHTML = $(div_name).innerHTML;

    win.showCenter();
}

TooltipManager.init("tooltip",
	{url: "tooltip_ajax.html", options: {method: 'get', className:'dialog'}},
	{width: 600, shiftX: -450, shiftY: 10});
//TooltipManager.init("tooltip", {url: "tooltip_ajax.html", options: {method: 'get'}}, {showEffect: Element.show, hideEffect: Element.hide});


var g_propWindow = null;

function showWindow(i)
{
	if (g_propWindow != null)
		g_propWindow.close();
  g_propWindow = new Window( { className: 'dialog', title: $('tooltip_title' + i).innerHTML,
    destroyOnClose: true,
    onClose:function() { $('tooltip_content' + i).style.display = 'none'; } } );
  g_propWindow.setContent( 'tooltip_content' + i, true, true );
  g_propWindow.showCenter();
}

-->
</script>
</head>

<body>
<!-- 제목 테이블 -->
<table class="TableLayout">
  <tr>
    <td width="25%" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.msg.usermessage.view")%></td>
    <td width="75%" class="MessageDisplay" ><div id="messageDisplay"></div></td>
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
            <input name="textfield22222" type="text" class="FormTextReadOnly" readonly value="<%= msgVO.getUserMessageId() %>" style="width:520;">
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%=_i18n.get("global.agreementRef")%></td>
    <td width="260" class="FieldData">
		  <input name="textfield2222" type="text" class="FormTextReadOnly" readonly value="<%= msgVO.getAgreementRefVal() %>" size="32">
    </td>
    <td class="FieldLabel"><%=_i18n.get("global.msg.inout")%></td>
    <td class="FieldData"><input name="textfield222225" type="text" class="FormTextReadOnly" readonly size="32" value="<%= inoutStr %>"></td>
  </tr>
  <tr>
    <td class="FieldLabel"><%= _i18n.get("msg21ms001.detail.service.name") %></td>
    <td class="FieldData">
      <input type="text" name="serviceName" id="serviceName" class="FormTextReadOnly" size="32" value="<%= msgVO.getCollaborationInfo().getService()%>">
    </td>
    <td class="FieldLabel"><%= _i18n.get("msg21ms001.detail.action.name") %></td>
    <td class="FieldData">
      <input type="text" name="actionName" id="actionName" class="FormTextReadOnly" size="32" value="<%= msgVO.getCollaborationInfo().getAction()%>"></td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%=_i18n.get("global.msg.date")%></td>
    <td width="260" class="FieldData"><input name="textfield222223" type="text" class="FormTextReadOnly" readonly size="32" value="<%= sdf1.format(msgVO.getUserMessageInfo().getTimestamp().toDate()) %>"></td>
    <td class="FieldLabel"><%=_i18n.get("global.msg.status")%></td>
    <td class="FieldData"><input name="textfield222224" type="text" class="FormTextReadOnly" readonly size="32" value="<%= statusStr %>"></td>
  </tr>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("global.msg.comment")%></td>
    <td colspan="3" class="FieldData"><input name="comment" id="comment" type="text" class="FormText" size="98" value="<%= (msgVO.getUserMessage().getUserComment()==null? "" : msgVO.getUserMessage().getUserComment()) %>">
		  <a href="javascript:updateComment()"><img src="images/btn_update.gif" align="absmiddle" border="0"></a></td>
  </tr>
</table>
<br>
<%
qc = new QueryCondition();
ArrayList refVOs = null;

// 이 메시지가 참조하는 메시지
if (msgVO.getUserMessage().getRefToMessageVOs() != null) {
%>
<br>
<table class="FieldTable">
	  <tr>
	    <td class="FieldLabel"><%=_i18n.get("global.msg.referralid")%></td>
	    <td colspan="3" class="FieldData">
<%
	qc.add("referrer_obid", msgVO.getUserMessage().getObid());
	refVOs = MxsEngine.getInstance().getObjects("Eb3RefToMessage", 0, qc, DAOFactory.EBMS3);
	for (Iterator i = refVOs.iterator(); i.hasNext();) {
		RefToMessageVO refVO = (RefToMessageVO)i.next();
		if (refVO.getReferralType() == Eb3Constants.MESSAGE_TYPE_SIGNAL) {
%>
    	<a href="msg21ms401.jsp?obid=<%= refVO.getReferralObid()%>"><%= refVO.getReferralMsgId() %></a><br>
<%
		} else if (refVO.getReferralType() == Eb3Constants.MESSAGE_TYPE_USER) {
%>
    	<a href="msg21ms301.jsp?obid=<%= refVO.getReferralObid()%>"><%= refVO.getReferralMsgId() %></a><br>
<%
		}
%>
<% }
%>
	    </td>
	  </tr>
</table>
<%
}
// 이 메시지를 참조하는 메시지
qc = new QueryCondition();
qc.add("referral_obid", msgVO.getUserMessage().getObid());
refVOs = MxsEngine.getInstance().getObjects("Eb3RefToMessage", 0, qc, DAOFactory.EBMS3);
if (refVOs.size() > 0) {
%>
<br>
<table class="FieldTable">
	  <tr>
	    <td class="FieldLabel"><%=_i18n.get("global.msg.referrerid")%></td>
	    <td colspan="3" class="FieldData">
<%
}
for (Iterator i = refVOs.iterator(); i.hasNext();) {
	RefToMessageVO refVO = (RefToMessageVO)i.next();
	if (refVO.getReferrerType() == Eb3Constants.MESSAGE_TYPE_SIGNAL) {
%>
    	<a href="msg21ms401.jsp?obid=<%= refVO.getReferrerObid()%>"><%= refVO.getReferrerMsgId() %></a><br>
<%
	} else if (refVO.getReferrerType() == Eb3Constants.MESSAGE_TYPE_USER) {
%>
    	<a href="msg21ms301.jsp?obid=<%= refVO.getReferrerObid()%>"><%= refVO.getReferrerMsgId() %></a><br>
<%
	}

}
if (refVOs.size() > 0) {
%>
	    </td>
	  </tr>
</table>
<%
}

	if (msgVO.getMessageProperties() != null) {
%>
<br>
<h3><%=_i18n.get("msg21ms301.msg.property")%></h3>
<table class="TableLayout" >
  <col width="120" align="center">
  <col width="120">
  <col width="">
  <tr>
    <td class="ResultHeader"><%=_i18n.get("global.msg.prop.name")%></td>
    <td class="ResultHeader"><%=_i18n.get("global.msg.prop.type")%></td>
    <td class="ResultLastHeader"><%=_i18n.get("global.msg.prop.value")%></td>
  </tr>
<%
		for(int i=0; i<msgVO.getMessageProperties().size(); i++) {
			Property prop = (Property)msgVO.getMessageProperties().get(i);
%>
  <tr>
    <td class="ResultData"><%=prop.getPropertyName()%></td>
    <td class="ResultData"><%=(prop.getType() == null ? "" : prop.getType())%></td>
    <td class="ResultLastData"><%=prop.getContent()%></td>
  </tr>
<%
		}
%>
</table>
<%
	}
%>
<br>
<table class="FieldTable">
  <tr>
    <td class="FieldLabel" width="120"><%=_i18n.get("msg21ms301.msg.body")%></td>
    <td colspan="3" class="FieldData"><img src="images/xml.gif" width="39" height="20" align="absmiddle">
      <a href="javascript:viewMessage('<%=obid%>', '');"><img src="images/btn_inview.gif" width="39" height="13" align="absmiddle" border="0"></a>
      <a href="javascript:downloadMessage('<%= obid%>', '');"><img src="images/btn_indown.gif" width="62" height="13" align="absmiddle" border="0"></a>
    </td>
  </tr>
</table>
</form>
<!-- 첨부 속성 팝업  테이블 코드 시작-->
<%
if (msgVO.getPartInfos().size() > 0) {
	for (int i=0; i<msgVO.getPartInfos().size(); i++) {
		PartInfo partVO = (PartInfo)msgVO.getPartInfos().get(i);
		if (partVO.getPartProperties() != null) {
%>
<h3><%=_i18n.get("msg21ms301.part.property")%></h3>
<table class="TableLayout">
  <col width="120" align="center">
  <col width="120">
  <col width="360">
  <tr>
    <td class="ResultHeader"><%=_i18n.get("global.msg.prop.name")%></td>
    <td class="ResultHeader"><%=_i18n.get("global.msg.prop.type")%></td>
    <td class="ResultLastHeader"><%=_i18n.get("global.msg.prop.value")%></td>
  </tr>
<%
			for(int k=0; k<partVO.getPartProperties().getProperties().size(); k++) {
				Property prop = (Property)partVO.getPartProperties().getProperties().get(k);
%>
  <tr>
    <td class="ResultData"><%=prop.getPropertyName()%></td>
    <td class="ResultData"><%=(prop.getType() == null ? "" : prop.getType())%></td>
    <td class="ResultLastData"><%=prop.getContent()%></td>
  </tr>
<%
			}
%>
</table>
<br>
<%
		}
	}
%>
<table class="TableLayout" >
  <col width=" 30" align="center">
  <col width="">
  <col width="">
  <col width="">
  <col width="">
  <col width="120" align="center">
  <tr>
    <td class="ResultHeader"><%=_i18n.get("msg21ms301.column.1")%></td>
    <td class="ResultHeader"><%=_i18n.get("msg21ms301.column.2")%></td>
    <td class="ResultHeader"><%=_i18n.get("msg21ms301.column.3")%></td>
    <td class="ResultHeader"><%=_i18n.get("msg21ms301.column.4")%></td>
    <td class="ResultHeader"><%=_i18n.get("msg21ms301.column.5")%></td>
    <td class="ResultLastHeader">&nbsp; </td>
  </tr>
<%
	String color = null;
	String hasProperties = null;
	for (int i=0; i<msgVO.getPartInfos().size(); i++) {
		color = i % 2 == 0 ? "#FFFFFF" : "#F9F9F9";

		PartInfo partVO = (PartInfo)msgVO.getPartInfos().get(i);
		if (partVO.getPartProperties() != null) {
			//hasProperties = "<a href='javascript:showWindow(" + i + ")'>" + _i18n.get("msg21ms301.prop.found") + "</a></span>";
			hasProperties = "<span id=\"tooltip" + i + "\" class='tooltip green'><a href=\"#clicked\">" + _i18n.get("msg21ms301.prop.found") + "</a></span>";
			hasProperties += "<script>TooltipManager.addHTML('tooltip" + i + "', 'tooltip_content" + i + "');</script>";
		} else {
			hasProperties = _i18n.get("msg21ms301.prop.notfound");
		}
		if (partVO.getHrefType() == MxsConstants.HREF_TYPE_MIME) {
			PayloadContainer pc = msgVO.getPayloadContainer(partVO.getHref());
			if (pc == null) continue;
%>
  <tr>
    <td class="ResultData"><%= i+1 %></td>
    <td class="ResultData"><%= partVO.getHref() %></td>
    <td class="ResultData"><%= pc.getContentType() %></td>
    <td class="ResultData"><%= (pc.getDescription() == null ? "&nbsp;" : pc.getDescription()) %></td>
    <td class="ResultData"><%= hasProperties%></td>
    <td class="ResultLastData"><a href="javascript:viewMessage('<%=obid%>', '<%= partVO.getHref() %>')"><img src="images/btn_inview.gif" width="39" height="13" align="absmiddle" border="0"></a>
      <a href="javascript:downloadMessage('<%=obid%>', '<%= partVO.getHref() %>')"><img src="images/btn_indown.gif" width="62" height="13" align="absmiddle" border="0"></a>
    </td>
  </tr>
<%
		} else if (partVO.getHrefType() == MxsConstants.HREF_TYPE_REMOTE) {
%>
  <tr>
    <td class="ResultData"><%= i+1 %></td>
    <td class="ResultData"><%= partVO.getHref() %></td>
    <td class="ResultData">&nbsp;</td>
    <td class="ResultData"><%= (partVO.getDescriptionContent() == null? "&nbsp;" : partVO.getDescriptionContent())%></td>
    <td class="ResultData"><%= hasProperties%></td>
    <td class="ResultLastData"><a href="javascript:viewMessage('<%=obid%>', '<%= partVO.getHref() %>')"><img src="images/btn_inview.gif" width="39" height="13" align="absmiddle" border="0"></a>
      <a href="javascript:downloadMessage('<%=obid%>', '<%= partVO.getHref() %>')"><img src="images/btn_indown.gif" width="62" height="13" align="absmiddle" border="0"></a>
    </td>
  </tr>
<%
		}
	}
}
%>
</table>
<%
// 메시지 번들
if (msgVO.getSignalMessageCnt() > 0) {
%>
<br>
<h3><%=_i18n.get("msg21ms301.msg.association")%></h3>
<table class="TableLayout" >
  <col width="120" align="center">
  <col>
  <tr>
    <td class="ResultHeader"><%=_i18n.get("global.msg.type")%></td>
    <td class="ResultLastHeader"><%=_i18n.get("global.msg.id")%></td>
  </tr>
<%
SignalMessage bundleSignalMsg = msgVO.getSignalMessage(MxsConstants.SIGNAL_PULLREQUEST);
if (bundleSignalMsg != null) {
%>
<tr>
<td class="ResultData"><%= _i18n.get("msg21ms401.type.signal") %></td>
<td class="ResultLastData"><a href="msg21ms401.jsp?obid=<%= bundleSignalMsg.getObid()%>"><%= bundleSignalMsg.getMessageId() %></a></td>
</tr>
<%
}

bundleSignalMsg = msgVO.getSignalMessage(MxsConstants.SIGNAL_ERROR);
if (bundleSignalMsg != null) {
%>
<tr>
<td class="ResultData"><%= _i18n.get("msg21ms401.type.signal") %></td>
<td class="ResultLastData"><a href="msg21ms401.jsp?obid=<%= bundleSignalMsg.getObid()%>"><%= bundleSignalMsg.getMessageId() %></a></td>
</tr>
<%
}

bundleSignalMsg = msgVO.getSignalMessage(MxsConstants.SIGNAL_RECEIPT);
if (bundleSignalMsg != null) {
%>
<tr>
<td class="ResultData"><%= _i18n.get("msg21ms401.type.signal") %></td>
<td class="ResultLastData"><a href="msg21ms401.jsp?obid=<%= bundleSignalMsg.getObid()%>"><%= bundleSignalMsg.getMessageId() %></a></td>
</tr>
<%
}
%>
</table>
<%
}
%>
<table class="TableLayout" >
  <tr>
    <td align="right" style="padding-top:15"><a href="javascript:goList()"><img src="images/btn_big_list.gif" width="39" height="23" border="0"></a>
       <a href="javascript:deleteMessage()"><img src="images/btn_big_delete.gif" width="39" height="23" border="0"></a>
    </td>
  </tr>
</table>
</body>
</html>
<%
 } catch (Throwable e) {
	 e.printStackTrace();
 }
%>
