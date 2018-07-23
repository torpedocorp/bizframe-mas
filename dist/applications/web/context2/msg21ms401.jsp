<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.io.ByteArrayInputStream" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%@ page import="kr.co.bizframe.mxs.MxsConstants"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.Eb3MessageManager"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.Eb3Message"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.SignalMessage"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.RefToMessageVO"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.Error"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.Eb3Constants" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.parser.Eb3Parser" %>
<%@ page import="kr.co.bizframe.mxs.ebms.EbConstants"%>
<%@ page import="kr.co.bizframe.mxs.storage.MxsFileManager" %>
<%@ page import="kr.co.bizframe.mxs.soap.MimeHeaders" %>
<%@ page import="kr.co.bizframe.mxs.soap.SOAPMessage" %>
<%@ page import="kr.co.bizframe.mxs.soap.SOAPParser" %>
<%
/**
 * 시그널 메시지 상세 조회
 *
 * @author Mi-Young Kim
 * @version 1.0 2008.09.03
 */
 %>
<html>
<head>
<%@ include file="./com00in000.jsp" %>
<%@ include file="./com00in003.jsp" %>
<%
String signalMsgObid = StringUtil.nullCheck(request.getParameter("obid"));
if (signalMsgObid == null || signalMsgObid.equals("")) {
    out.println("<script>alert('" + _i18n.get("msg21ms401.notfound") + "');history.back();</script>");
   	return;
}

Eb3Message msg = null;
ArrayList errors = new ArrayList();
Eb3MessageManager msgMgr = new Eb3MessageManager();
QueryCondition qc = new QueryCondition();
try {
	qc.add("obid", signalMsgObid);
    msg = (Eb3Message)msgMgr.getSignalMessage(qc);

} catch (Exception e) {
    out.println("<script>alert('" + _i18n.get("msg21ms401.notfound") + "');history.back();</script>");
    e.printStackTrace();
    return;
}

try {
	// error list 는 msg 를 파싱해서 가져온다.
	// msg 파일이 없더라도 에러는 무시하고 DB정보로 조회하도록한다
	if (msg.getErrors() != null && msg.getErrors().size() > 0) {
		// 위 메시지에는 번들이나 첨부파일에 대한 정보가 없기때문에 새로 조회해서 파싱한다.
		Eb3Message parseMsg = msgMgr.getMessage(qc,
				Eb3Constants.MESSAGE_TYPE_SIGNAL, true);
		errors = parseMsg.getErrors();
	}
} catch (Exception e) {
    e.printStackTrace();
}

String inoutStr = "";
String statusStr = EbConstants.getMessageStatusString(msg.getStatus());
if(msg.getBoundFor() == MxsConstants.MESSAGE_BOUND_FOR_IN) {
	inoutStr = _i18n.get("global.msg.inbound");
} else {
	inoutStr = _i18n.get("global.msg.outbound");
}
SignalMessage signalMsg = msg.getSignalMessage();
%>
<title><%=_i18n.get("global.page.title")%></title>
<script language="JavaScript" type="text/JavaScript">
<!--
	function viewMessage(obid, href) {
		window.open("msg22ac401.jsp?obid=" + obid + "&href=" + href, "View", "width=1010,height=800,left=0,top=0,resizable=yes,scrollbars=yes");
	}

	function downloadMessage(obid, href) {
		frm = document.form1;
		frm.action = "msg50ac401.jsp?obid=" + obid + "&href=" + href;
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
		    	$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("msg21ms401.operation.update") %>';
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

		var myAjax = new Ajax.Request('./msg30ac401.jsp', opt);
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
		    	$('messageDisplay').innerHTML = '<%=_i18n.get("msg21ms401.operation.delete") %>';
		    	Dialog.setInfoMessage('<%=_i18n.get("msg21ms401.operation.delete") %>');
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

		var myAjax = new Ajax.Request('./msg40ac401.jsp', opt);
	}

	function deleteMessage() {
		msg = "<%=_i18n.get("msg21ms401.delete.confirm")%>";
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
-->
</script>
</head>
<body>
<!-- 제목 테이블 -->
<table class="TableLayout">
  <tr>
    <td width="25%" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.msg.signalmessage.view")%></td>
    <td width="75%" class="MessageDisplay" ><div id=messageDisplay></div></td>
  </tr>
  <tr>
    <td colspan="2" height="10"></td>
  </tr>
</table>
<!-- 등록테이블-->
<form name="form1" method="post" >
<input type="hidden" name="obid" value="<%= signalMsgObid %>">
<table class="FieldTable">
  <tr>
    <td width="120" class="FieldLabel"><%=_i18n.get("global.msg.id")%></td>
    <td colspan="3" class="FieldData">
            <input name="textfield22222" type="text" class="FormTextReadOnly" readonly value="<%= signalMsg.getMessageId() %>" style="width:520;">
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%=_i18n.get("msg20ms401.list.type")%></td>
    <td width="260" class="FieldData">
		  <input name="textfield2222" type="text" class="FormTextReadOnly" readonly value="<%= MxsConstants._eb3SignalString[signalMsg.getType()] %>" size="32">
    </td>
    <td class="FieldLabel"><%=_i18n.get("global.msg.inout")%></td>
    <td class="FieldData"><input name="textfield222225" type="text" class="FormTextReadOnly" readonly size="32" value="<%= inoutStr %>"></td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%=_i18n.get("global.msg.date")%></td>
    <td width="260" class="FieldData"><input name="textfield222223" type="text" class="FormTextReadOnly" readonly size="32" value="<%= new SimpleDateFormat("yyyy.MM.dd HH:mm:ss.S").format(signalMsg.getMessageTimestamp().toDate()) %>"></td>
    <td class="FieldLabel"><%=_i18n.get("global.msg.status")%></td>
    <td class="FieldData"><input name="textfield222224" type="text" class="FormTextReadOnly" readonly size="32" value="<%= statusStr %>"></td>
  </tr>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("global.msg.comment")%></td>
    <td colspan="3" class="FieldData"><input name="comment" id="comment" type="text" class="FormText" size="98" value="<%= (signalMsg.getUserComment()==null? "" : signalMsg.getUserComment()) %>">
		  <a href="javascript:updateComment()"><img src="images/btn_update.gif" align="absmiddle" border="0"></a></td>
  </tr>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("msg21ms401.msg.body")%></td>
    <td colspan="3" class="FieldData"><img src="images/xml.gif" width="39" height="20" align="absmiddle">
      <a href="javascript:viewMessage('<%=signalMsgObid%>', '');"><img src="images/btn_inview.gif" width="39" height="13" align="absmiddle" border="0"></a>
      <a href="javascript:downloadMessage('<%= signalMsgObid%>', '');"><img src="images/btn_indown.gif" width="62" height="13" align="absmiddle" border="0"></a>
    </td>
  </tr>
</table>
<%
if (errors.size() > 0) {
%>
<br/>
<h3><%=_i18n.get("global.msg.error")%></h3>
<table class="FieldTable">

<%
	for(int i=0; i<errors.size(); i++) {
		Error err = (Error)errors.get(i);
		String error_code = StringUtil.checkNull(err.getErrorCode());
		String severity = StringUtil.checkNull(err.getSeverity());
		String category = StringUtil.checkNull(err.getCategory());
%>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("global.msg.error_code")%></td><td class="FieldData"><input name="err_code" id="err_code" type="text" class="FormTextReadOnly" readonly size="16" value="<%= error_code %>"></td>
    <td class="FieldLabel"><%=_i18n.get("global.msg.error_severity")%></td><td class="FieldData"><input name="severity" id="severity" type="text" class="FormTextReadOnly" readonly size="16" value="<%= severity %>"></td>
    <td class="FieldLabel"><%=_i18n.get("global.msg.error_category")%></td><td class="FieldData"><input name="category" id="category" type="text" class="FormTextReadOnly" readonly size="16" value="<%= category %>"></td>
  </tr>
<%
	}
%>

</table>
<% } %>

<%
qc = new QueryCondition();
ArrayList refVOs = null;

// 이 메시지가 참조하는 메시지
if (signalMsg.getRefToMessageVOs() != null) {
%>
<br>
<table class="FieldTable">
	  <tr>
	    <td class="FieldLabel"><%=_i18n.get("global.msg.referralid")%></td>
	    <td colspan="3" class="FieldData">
<%
	qc.add("referrer_obid", signalMsgObid);
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
//이 메시지를 참조하는 메시지
qc = new QueryCondition();
qc.add("referral_obid", signalMsgObid);
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
<% }

// 메시지 번들 체크
if (!msg.getObid().equals(signalMsgObid)) {
	qc = new QueryCondition();
	qc.add("obid", msg.getObid());
	Eb3Message bundleMsg = (Eb3Message)MxsEngine.getInstance().getObject("Eb3MessageBundle", qc, DAOFactory.EBMS3);
	if (bundleMsg != null) {
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
	if (bundleMsg.getUserMessage() != null) {
%>
  <tr>
    <td class="ResultData"><%= _i18n.get("msg21ms401.type.user") %></td>
    <td class="ResultLastData"><a href="msg21ms301.jsp?obid=<%= bundleMsg.getUserMessage().getObid()%>"><%= bundleMsg.getUserMessageId() %></a></td>
  </tr>
<%
	}
	SignalMessage bundleSignalMsg = bundleMsg.getSignalMessage(MxsConstants.SIGNAL_PULLREQUEST);
	if (bundleSignalMsg != null && !bundleSignalMsg.getObid().equals(signalMsgObid)) {
%>
  <tr>
    <td class="ResultData"><%= _i18n.get("msg21ms401.type.signal") %></td>
    <td class="ResultLastData"><a href="msg21ms401.jsp?obid=<%= bundleSignalMsg.getObid()%>"><%= bundleSignalMsg.getMessageId() %></a></td>
  </tr>
<%
	}

	bundleSignalMsg = bundleMsg.getSignalMessage(MxsConstants.SIGNAL_ERROR);
	if (bundleSignalMsg != null && !bundleSignalMsg.getObid().equals(signalMsgObid)) {
%>
  <tr>
    <td class="ResultData"><%= _i18n.get("msg21ms401.type.signal") %></td>
    <td class="ResultLastData"><a href="msg21ms401.jsp?obid=<%= bundleSignalMsg.getObid()%>"><%= bundleSignalMsg.getMessageId() %></a></td>
  </tr>
<%
	}

	bundleSignalMsg = bundleMsg.getSignalMessage(MxsConstants.SIGNAL_RECEIPT);
	if (bundleSignalMsg != null && !bundleSignalMsg.getObid().equals(signalMsgObid)) {
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
	} // bundleMsg end
}
%>
<table class="TableLayout" >
  <tr>
    <td align="right" style="padding-top:15"><a href="javascript:goList()"><img src="images/btn_big_list.gif" width="39" height="23" border="0"></a>
       <a href="javascript:deleteMessage()"><img src="images/btn_big_delete.gif" width="39" height="23" border="0"></a>
    </td>
  </tr>
</table>
</form>
</body>
</html>