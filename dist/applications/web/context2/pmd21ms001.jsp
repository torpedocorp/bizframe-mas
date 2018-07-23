<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.Eb3Constants" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.pmode.PMode" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.pmode.PModeLeg"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.pmode.MessageProperty"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.pmode.PayloadPart"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.common.MxsObject"%>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%@ page import="java.util.Iterator" %>
<%
/**
 * Detail PMode
 *
 * @author Mi-Young Kim
 * @version 1.0 2008.10.20
 */

String command = request.getParameter("command");
String obid = request.getParameter("obid");
String menuKey = "menu.pmd.view";
PMode pmode = null;
if ("insert".equalsIgnoreCase(command)) {
	// 파일 업로드를 통한 등록
    pmode = (PMode)session.getAttribute("pmode");
	menuKey = "menu.pmd.register";

} else if("update".equalsIgnoreCase(command)) {
	// 이미 등록된 pmode를 등록하려 한 경우
    pmode = (PMode)session.getAttribute("pmode");
	obid = pmode.getObid();
} else {
	// 목록에서 상세 페이지를 클릭 한 경우
}

if (pmode == null && obid != null) {
	MxsEngine engine  = MxsEngine.getInstance();
	QueryCondition qc = new QueryCondition();
	qc.add("obid", obid);
	MxsObject obj = engine.getObject("PMode", qc, DAOFactory.EBMS3);
	if (obj != null) {
		pmode = (PMode)obj.getExtension(Eb3Constants.MXSOBJ_EXTENSION_PMODE);
	}
}

PModeLeg leg = null;
%>
<html>
<head>
<%@ include file="com00in000.jsp" %>
<%@ include file="com00in001.jsp" %>
<%@ include file="com00in003.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>
<script language="JavaScript" type="text/JavaScript"><!--

var appname = navigator.appName;
<%
if (pmode == null) {
%>
		alert("<%=_i18n.get("global.error.retry")%>");
		location.href="pmd20ms001.jsp";
<%
	}
%>
function initialize() {
   $('messageDisplay').innerHTML = '';
   initSetData();
}

function initSetData() {
<%
	if ("insert".equalsIgnoreCase(command)) {
%>
    enterDown(1);
	$('idCheckFlag').value = "1";
<%
	} else if ("update".equalsIgnoreCase(command)) {
		String nameChkFlag = request.getParameter("nameCheckFlag");
		if (!"1".equals(nameChkFlag)) {
			nameChkFlag = "0";
%>
		    enterDown(1);
<%
		}
%>
	$('idCheckFlag').value = "1";
    $('nameCheckFlag').value = "<%=nameChkFlag%>";
<%
	} else {
%>
    $('nameCheckFlag').value = "1";
	$('idCheckFlag').value = "1";
<%
	}
%>
	$('name').value = "<%=pmode.getDisplayName()%>";
	$('id').value = "<%=pmode.getId()%>";
	$('agreement').value = "<%=pmode.getAgreement()%>";
    if ("<%=pmode.getMep()%>" == '0') {
        document.form1.mep[0].checked = true;
    } else {
        document.form1.mep[1].checked = true;
    }

    viewMepBinding('<%=pmode.getMep()%>');
	var mepbinding = document.form1.mepbinding;
	for(var i=0; i<mepbinding.length; i++){
		if(mepbinding.options[i].value == '<%=pmode.getMepbinding()%>'){
		   mepbinding.options[i].selected = true;
		}
	}

	pmodeLeg();

    if ("<%=pmode.getMyRole()%>" == '0') {
        document.form1.myrole[0].checked = true;
    } else {
        document.form1.myrole[1].checked = true;
    }

	$('desc').value = "<%=StringUtil.nullCheck(pmode.getDescription())%>";
	$('initPartyId').value ="<%=pmode.getInitiator().getParty()%>";
	$('initRole').value = "<%=pmode.getInitiator().getRole()%>";
<%
	if (pmode.getInitiator().getUsername() != null) {
%>
 	 applyWssUser("initWssuser", "<%=StringUtil.nullCheck(pmode.getInitiator().getUserObid())%>", "<%=pmode.getInitiator().getUsername()%>", "<%=pmode.getInitiator().getPassword()%>");
<%
	}
%>
	$('respPartyId').value ="<%=pmode.getResponder().getParty()%>";
	$('respRole').value = "<%=pmode.getResponder().getRole()%>";
<%
	if (pmode.getResponder().getUsername() != null) {
%>
		 applyWssUser("respWssuser", "<%=StringUtil.nullCheck(pmode.getResponder().getUserObid())%>", "<%=pmode.getResponder().getUsername()%>", "<%=pmode.getResponder().getPassword()%>");
<%
	}
	String[] legType = {"", "u", "s"};
    String legId = "";
	for (int i=1; i<3; i++) {
 		for (int j =0; j < legType.length; j++) {
 			legId = String.valueOf(i) + legType[j];
 			leg = pmode.getLeg(i, legType[j]);
 			if (leg != null) {
%>
        // protocol
		$('protocolAddress<%=legId%>').value = "<%=leg.getProtocolAddress()%>";
		var ver = eval("document.form1.protocolSoapVersion<%=legId%>");
		for(var i=0; i<ver.length; i++){
		   if(ver.options[i].value == '0' && "<%=leg.getSOAPVersion()%>" == '1.1'){
		      ver.options[i].selected = true;
		   }
		   if(ver.options[i].value == '1' && "<%=leg.getSOAPVersion()%>" == '1.2'){
		      ver.options[i].selected = true;
		   }
		}
		// error
		$('errSndErrTo<%=legId%>').value= "<%=StringUtil.nullCheck(leg.getErrSndErrTo())%>";
		$('errRcvErrTo<%=legId%>').value= "<%=StringUtil.nullCheck(leg.getErrRcvErrTo())%>";
        if ("<%=leg.getErrAsResponse()%>".toLowerCase() == 'true') {
        	eval("document.form1.errAsResponse<%=legId%>")[0].checked = true;
        } else {
	        eval("document.form1.errAsResponse<%=legId%>")[1].checked = true;
        }

        // TODO false로 고정해야함 주석처리
        /*if ("<%=leg.getErrPeNotifyConsumer()%>".toLowerCase() == 'true') {
        	eval("document.form1.errPeNotifyConsumer<%=legId%>")[0].checked = true;
        } else {
	        eval("document.form1.errPeNotifyConsumer<%=legId%>")[1].checked = true;
        }*/

        if ("<%=leg.getErrPeNotifyProducer()%>".toLowerCase() == 'true') {
        	eval("document.form1.errPeNotifyProducer<%=legId%>")[0].checked = true;
        } else {
	        eval("document.form1.errPeNotifyProducer<%=legId%>")[1].checked = true;
        }

        // TODO false로 고정해야함 주석처리
        /*if ("<%=leg.getErrDfNotifyProducer()%>".toLowerCase() == 'true') {
        	eval("document.form1.errDfNotifyProducer<%=legId%>")[0].checked = true;
        } else {
	        eval("document.form1.errDfNotifyProducer<%=legId%>")[1].checked = true;
        }*/

		// businessInfo
<%
 				if (!"s".equalsIgnoreCase(legType[j])) {
 					if (pmode.getMyRole() == Eb3Constants.PMODE_MYROLE_INITIATOR) {
 						leg.setMpcIsLocal(Eb3Constants.MPC_REMOTE);
 					} else {
 						leg.setMpcIsLocal(Eb3Constants.MPC_LOCAL);
 					}
%>
					$('bizinfoService<%=legId%>').value = "<%=leg.getService()%>";
					$('bizinfoAction<%=legId%>').value = "<%=leg.getAction()%>";
					$('payloadMaxSize<%=legId%>').value = "<%=leg.getPayloadMaxSize()%>";

	 				applyMpc('mpc<%=legId%>', '<%=StringUtil.nullCheck(leg.getMpcObid())%>', '<%=leg.getMpcUri()%>', '<%=leg.getMpcIsLocal()%>', '<%=StringUtil.nullCheck(leg.getMpcName())%>');
<%
	 				if (leg.getMsgProperties() != null) {
	 					for (Iterator k = leg.getMsgProperties().iterator(); k.hasNext();) {
	 						MessageProperty prop = (MessageProperty) k.next();
%>

	 			    addRowMsgPropTblLast('<%=legId%>', '<%=prop.getPropName()%>', '<%=StringUtil.nullCheck(prop.getType())%>', '<%=StringUtil.nullCheck(prop.getDescription())%>', '<%=prop.getRequired()%>');
<%
	 					}
	 				}
	 				if (leg.getPayloadParts() != null) {
	 					for (Iterator k = leg.getPayloadParts().iterator(); k.hasNext();) {
	 						PayloadPart prop = (PayloadPart) k.next();
%>

	 			    addRowPayloadProfTblLast('<%=legId%>', '<%=StringUtil.nullCheck(prop.getPropName())%>', '<%=StringUtil.nullCheck(prop.getType())%>', '<%=StringUtil.nullCheck(prop.getSchemaFile())%>', '<%=prop.getMaxSize()%>', '<%=prop.getRequired()%>')
<%
	 					}
	 				}
 				}
 			}
 		}
	}
%>
}

function viewMepBinding(val) {
    var body = '<select name="mepbinding" id="mepbinding" class="FormSelect" onChange="javascript:pmodeLeg()">';
    body += '<option value=-1><%=_i18n.get("pmd10ms001.btn.select")%></option>';
	if (val == 0) {
    	//oneway
    	body += '<option value="<%=Eb3Constants.PMODE_MEPBINDING_PUSH%>"><%=Eb3Constants.PModeMepBindingString[Eb3Constants.PMODE_MEPBINDING_PUSH]%></option>';
    	body += '<option value="<%=Eb3Constants.PMODE_MEPBINDING_PULL%>"><%=Eb3Constants.PModeMepBindingString[Eb3Constants.PMODE_MEPBINDING_PULL]%></option>';

	} else if (val == 1) {
		// twoway
    	body += '<option value="<%=Eb3Constants.PMODE_MEPBINDING_SYNC%>"><%=Eb3Constants.PModeMepBindingString[Eb3Constants.PMODE_MEPBINDING_SYNC]%></option>';
    	body += '<option value="<%=Eb3Constants.PMODE_MEPBINDING_PUSHANDPUSH%>"><%=Eb3Constants.PModeMepBindingString[Eb3Constants.PMODE_MEPBINDING_PUSHANDPUSH]%></option>';
    	body += '<option value="<%=Eb3Constants.PMODE_MEPBINDING_PUSHANDPULL%>"><%=Eb3Constants.PModeMepBindingString[Eb3Constants.PMODE_MEPBINDING_PUSHANDPULL]%></option>';
    	body += '<option value="<%=Eb3Constants.PMODE_MEPBINDING_PULLANDPUSH%>"><%=Eb3Constants.PModeMepBindingString[Eb3Constants.PMODE_MEPBINDING_PULLANDPUSH]%></option>';
	}
	body += '</select>';
	$('mepBindingDisplay').innerHTML = body;
}

function setMessage(msg) {
      //$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > ' + msg;
      alert(msg);
}

function deletePMode() {
	msg = "<%=_i18n.get("pmd21ms001.delete.confirm")%>";
	bChoice = openConfirm(msg, deleteFunction, null, "<%=_i18n.get("global.warning")%>");
}

function deleteFunction() {
   closeInfo();

   var params = Form.serialize(document.form1);
   var opt = {
      method: 'post',
      parameters: params,
      onSuccess: function(t) {
         $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%= _i18n.get("pmd40ac001.pmode.deleted") %>';
         goList();
      },
       on404: function(t) {
           $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("err00zz404.message") %>';
           showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
       },
       onFailure: function(t) {
           $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("global.error.retry") %>';
           showErrorPopup(t.responseText, null, null, null);
       }
   }
   var myAjax = new Ajax.Request("pmd40ac001.jsp", opt);
}

function validateURI(str){
	if(!str) {
		return false;
	}

    var regexUri = /^([a-z0-9+.-]+):/; // scheme

	if(!regexUri.exec(str)) {
		return false; //invalid URI
	} else {
		return true;
	}
}

function storePMode(kind) {
	if ($('name').value == "") {
		setMessage("<%=_i18n.get("pmd10ms001.name.empty") %>");
        return;
	}

    if ($('nameCheckFlag').value == "0") {
		setMessage("<%=_i18n.get("pmd10ms001.name.inform") %>");
        return;
    }

	if ($('id').value == "") {
		setMessage("<%=_i18n.get("pmd10ms001.id.empty") %>");
        return;
	}

	if ($('agreement').value == "") {
		setMessage("<%=_i18n.get("pmd10ms001.agreement.empty") %>");
        return;
	}

    if ($('idCheckFlag').value == "0") {
		setMessage("<%=_i18n.get("pmd10ms001.id.inform") %>");
        return;
    }

	if (!document.form1.mep[0].checked && !document.form1.mep[1].checked) {
		setMessage("<%=_i18n.get("pmd10ms001.mep.inform") %>");
        return;
	}
	var mepbinding = $('mepbinding').value;
	if (mepbinding == "-1") {
		setMessage("<%=_i18n.get("pmd10ms001.mepbinding.inform") %>");
        return;
	}

	if (!document.form1.myrole[0].checked && !document.form1.myrole[1].checked) {
		setMessage("<%=_i18n.get("pmd10ms001.myrole.inform") %>");
        return;
	}

	if ($('initPartyId').value == "") {
		setMessage("<%=_i18n.get("pmd10ms001.initPartyId.inform") %>");
        return;
	}

	if (!validateURI($('initPartyId').value)) {
		setMessage("<%=_i18n.get("pmd10ms001.initPartyId.uri.inform") %>");
        return;
	}

	if ($('initRole').value == "") {
		setMessage("<%=_i18n.get("pmd10ms001.initRole.inform") %>");
        return;
	}

	if ($('respPartyId').value == "") {
		setMessage("<%=_i18n.get("pmd10ms001.respPartyId.inform") %>");
        return;
	}

	if (!validateURI($('respPartyId').value)) {
		setMessage("<%=_i18n.get("pmd10ms001.respPartyId.uri.inform") %>");
        return;
	}

	if ($('respRole').value == "") {
		setMessage("<%=_i18n.get("pmd10ms001.respRole.inform") %>");
        return;
	}

	if (mepbinding == "<%=Eb3Constants.PMODE_MEPBINDING_PUSH%>"
	    || mepbinding == "<%=Eb3Constants.PMODE_MEPBINDING_SYNC%>"
	    || mepbinding == "<%=Eb3Constants.PMODE_MEPBINDING_PUSHANDPUSH%>") {
	    if ($('initWssuserTxt').value != "") {
	    	setMessage("<%=_i18n.get("pmd10ms001.init.userid.notnull.inform") %>");
        	return;
	    }
	}

    // LEG[1]
	if (mepbinding == "<%=Eb3Constants.PMODE_MEPBINDING_PUSH%>"
	    || mepbinding == "<%=Eb3Constants.PMODE_MEPBINDING_SYNC%>"
	    || mepbinding == "<%=Eb3Constants.PMODE_MEPBINDING_PUSHANDPUSH%>"
	    || mepbinding == "<%=Eb3Constants.PMODE_MEPBINDING_PUSHANDPULL%>") {

		if ($('protocolAddress1').value == '') {
			setMessage("LEG[1] <%=_i18n.get("pmd10ms001.protocol.inform") %>");
	        return;
		}

		if ($('bizinfoService1').value == '') {
			setMessage("LEG[1] <%=_i18n.get("pmd10ms001.service.inform") %>");
	        return;
		}

		if (!validateURI($('bizinfoService1').value)) {
				setMessage("LEG[1] <%=_i18n.get("pmd10ms001.service.uri.inform") %>");
		        return;
		}

		if ($('bizinfoAction1').value == '') {
			setMessage("LEG[1] <%=_i18n.get("pmd10ms001.action.inform") %>");
	        return;
		}

		if ($('mpc1Name').value != '') {
			setMessage("LEG[1] <%=_i18n.get("pmd10ms001.nullmpc.inform") %>");
	        return;
		}
	}

	// LEG[1][s], LEG[1][u]
	if (mepbinding == "<%=Eb3Constants.PMODE_MEPBINDING_PULL%>"
	    || mepbinding == "<%=Eb3Constants.PMODE_MEPBINDING_PULLANDPUSH%>") {

		if ($('protocolAddress1s').value == '') {
			setMessage("LEG[1][s] <%=_i18n.get("pmd10ms001.protocol.inform") %>");
	        return;
		}

		if ($('protocolAddress1u').value == '') {
			setMessage("LEG[1][u]<%=_i18n.get("pmd10ms001.protocol.inform") %>");
	        return;
		}

		if ($('bizinfoService1u').value == '') {
			setMessage("LEG[1][u]<%=_i18n.get("pmd10ms001.service.inform") %>");
	        return;
		}

		if (!validateURI($('bizinfoService1u').value)) {
				setMessage("LEG[1][u] <%=_i18n.get("pmd10ms001.service.uri.inform") %>");
		        return;
		}

		if ($('bizinfoAction1u').value == '') {
			setMessage("LEG[1][u]<%=_i18n.get("pmd10ms001.action.inform") %>");
	        return;
		}
		if ($('mpc1uName').value == '') {
			setMessage("LEG[1][u] <%=_i18n.get("pmd10ms001.notnullmpc.inform") %>");
	        return;
		}
		if (document.form1.myrole[0].checked && $('mpc1u').value !=''
					&& $('mpc1uIsLocal').value =='1') {
				setMessage("LEG[1][u] <%=_i18n.get("pmd10ms001.remotempc.inform") %>");
		        return;
		}
		if (document.form1.myrole[1].checked && $('mpc1u').value !=''
					&& $('mpc1uIsLocal').value =='0') {
				setMessage("LEG[1][u] <%=_i18n.get("pmd10ms001.localmpc.inform") %>");
		        return;
		}
	}

	// LEG[2]
	if (mepbinding == "<%=Eb3Constants.PMODE_MEPBINDING_SYNC%>"
			|| mepbinding == "<%=Eb3Constants.PMODE_MEPBINDING_PUSHANDPUSH%>"
			|| mepbinding == "<%=Eb3Constants.PMODE_MEPBINDING_PULLANDPUSH%>") {

		if ($('protocolAddress2').value == '') {
			setMessage("LEG[2] <%=_i18n.get("pmd10ms001.protocol.inform") %>");
	        return;
		}

		if ($('bizinfoService2').value == '') {
			setMessage("LEG[2] <%=_i18n.get("pmd10ms001.service.inform") %>");
	        return;
		}

		if (!validateURI($('bizinfoService2').value)) {
				setMessage("LEG[2] <%=_i18n.get("pmd10ms001.service.uri.inform") %>");
		        return;
		}

		if ($('bizinfoAction2').value == '') {
			setMessage("LEG[2] <%=_i18n.get("pmd10ms001.action.inform") %>");
	        return;
		}
		if ($('mpc2Name').value != '') {
			setMessage("LEG[2] <%=_i18n.get("pmd10ms001.nullmpc.inform") %>");
	        return;
		}
	}

	// LEG[2][s] LEG[2][u]
    if (mepbinding == "<%=Eb3Constants.PMODE_MEPBINDING_PUSHANDPULL%>") {
		if ($('protocolAddress2s').value == '') {
			setMessage("LEG[2][s] <%=_i18n.get("pmd10ms001.protocol.inform") %>");
	        return;
		}

		if ($('protocolAddress2u').value == '') {
			setMessage("LEG[2][u]<%=_i18n.get("pmd10ms001.protocol.inform") %>");
	        return;
		}

		if ($('bizinfoService2u').value == '') {
			setMessage("LEG[2][u]<%=_i18n.get("pmd10ms001.service.inform") %>");
	        return;
		}

		if (!validateURI($('bizinfoService2u').value)) {
				setMessage("LEG[2][u] <%=_i18n.get("pmd10ms001.service.uri.inform") %>");
		        return;
		}

		if ($('bizinfoAction2u').value == '') {
			setMessage("LEG[2][u]<%=_i18n.get("pmd10ms001.action.inform") %>");
	        return;
		}
		if ($('mpc2uName').value == '') {
			setMessage("LEG[2][u] <%=_i18n.get("pmd10ms001.notnullmpc.inform") %>");
	        return;
		}
		if (document.form1.myrole[0].checked && $('mpc2u').value !=''
					&& $('mpc2uIsLocal').value =='1') {
				setMessage("LEG[2][u] <%=_i18n.get("pmd10ms001.remotempc.inform") %>");
		        return;
		}
		if (document.form1.myrole[1].checked && $('mpc2u').value !=''
					&& $('mpc2uIsLocal').value =='0') {
				setMessage("LEG[2][u] <%=_i18n.get("pmd10ms001.localmpc.inform") %>");
		        return;
		}
	}

	// radio disable을 다시 endable로 해줘야한다. 그래야 값이 넘어감
	var inputs     = document.getElementsByTagName('input');
	var checkboxes = new Array();
	var count = 0;
	for (var i = 0; i < inputs.length; i++) {
	   if (inputs[i].type == 'radio' && inputs[i].name.indexOf("err") > -1) {
		   inputs[i].disabled = false;
	   }
	}

	var url ="";
	var msg = "";
	if (kind == 1) {
		url = "pmd10ac001.jsp";
		msg = '<%=_i18n.get("pmd10ms001.msg.registered") %>';
	} else if (kind == 2) {
		url = "pmd30ac001.jsp";
		msg = '<%=_i18n.get("pmd30ms001.msg.updated") %>';
	}

	Windows.closeAllModalWindows();
	clearNotify();
	openInfo('<%=_i18n.get("global.processing") %>');
	var params = Form.serialize(document.form1);
	var opt = {
	    method: 'post',
	    postBody: params,
	    onSuccess: function(t) {
	    	closeInfo();
	    	var res = eval("(" + t.responseText + ")");
	    	if (res.err == "true") {
		    	alert(res.msg);
	    	} else {
				Dialog.setInfoMessage(msg);
		    	timeout=2;
		    	setTimeout(goList, 1000);
	    	}
	    },
	    on404: function(t) {
	    	closeInfo();
	        $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("err00zz404.message") %>';
	    },
	    onFailure: function(t) {
	    	closeInfo();
	        $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("global.error.retry") %>';
	        showErrorPopup(t.responseText, null, null, null);
	    }
	}

	var myAjax = new Ajax.Request(url, opt);
}

function enterDown(kind){
  var checkBtnStr = '<a href="javascript:nameCheck('+kind+')"><img src="images/btn_checkunique.gif" width="59" height="20" align="absmiddle" border="0"></a>';
  checkBtnStr += '&nbsp; <font color="red"><%=_i18n.get("global.duplication.check") %></font>';

  var fieldId = "";
  if (kind == 1) { // name
  	  fieldId = "name";
  } else if (kind ==2) { // id
	  fieldId = "id";
  }

  if ($(fieldId + 'CheckBtnDisplay').innerHTML != checkBtnStr) {
	  $(fieldId + 'CheckBtnDisplay').innerHTML = checkBtnStr;
	  $(fieldId + "CheckFlag").value = "0";
  }
}

function nameCheck(kind) {
   $('messageDisplay').innerHTML = '';
   var check_name = "";
   var errMsg = "";
   var url = "";
   if (kind == 1) { // check_name
   	   check_name = $("name").value;
   	   errMsg = "<%=_i18n.get("pmd10ms001.name.empty") %>";
   	   url = "pmd20ac003.jsp";
   } else if (kind == 2) { // id
   	   check_name = $("id").value;
   	   errMsg = "<%=_i18n.get("pmd10ms001.id.empty") %>";
   	   url = "pmd20ac002.jsp";
   }

   if(check_name == null || check_name == '') {
      $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > ' + errMsg;
      return;
   }

   var params = Form.serialize(document.form1);
   var opt = {
      method: 'post',
      parameters: params,
      asynchronous: false,
      onSuccess: function(t) {
	      var res = eval("(" + t.responseText + ")");
      		dupCheckResult(kind, res.name, res.can_use);
      },
       on404: function(t) {
           $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("err00zz404.message") %>';
           closeInfo();
       },
       onFailure: function(t) {
           $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("global.error.retry") %>';
           showErrorPopup(t.responseText, null, null, null);
           closeInfo();
       }
   }
   var myAjax = new Ajax.Request(url, opt);
}

function dupCheckResult(kind, check_name, result) {
   var checkBtnStr = '<a href="javascript:nameCheck('+ kind +')"><img src="images/btn_checkunique.gif" width="59" height="20" align="absmiddle" border="0"></a>';
   var fieldId = "";
   var errMsg = "";
   if (kind == 1) {
	   fieldId = "name";
	   errMsg = "<%=_i18n.get("pmd10ms001.name.use.no") %>";
   } else if (kind == 2) {
       fieldId = "id";
       errMsg = "<%=_i18n.get("pmd10ms001.id.use.no") %>";
   }

   if(result == 'true') {
      $(fieldId + "CheckFlag").value = "1";
      $('messageDisplay').innerHTML ='<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("pmd10ms001.use.ok") %>';
   } else {
      $('messageDisplay').innerHTML ='<img src="images/bu_query.gif" align="absmiddle" > ' + errMsg;
      checkBtnStr += '&nbsp; <font color="red"><%=_i18n.get("global.duplication.check") %></font>';
   }
   $(fieldId + 'CheckBtnDisplay').innerHTML = checkBtnStr;
}

function loading() {
   $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%= _i18n.get("global.loading")%>';
}

function goList() {
	timeout--;
	if (timeout >0) {
		setTimeout(goList, 1000) ;
	} else {
		location.href= "pmd20ms001.jsp";
	}
}

function selectWssUser(fieldId) {
	if (fieldId != null && fieldId.length > 0) {
    	window.open("wsu20pu003.jsp?fieldId=" + fieldId, "View", "width=830,height=500,left=0,top=0,resizable=yes,scrollbars=yes");
    }
}

function viewSelectedWssUser(fieldId) {
    var obid = $(fieldId).value;
    if (obid != null && obid.length > 0) {
	    window.open("wsu21ms001.jsp?obid=" + obid, "View", "width=830,height=500,left=0,top=0,resizable=yes,scrollbars=yes");
    }
}

function deleteWssUser(fieldId) {
	$(fieldId).value = "";
	$(fieldId + 'Txt').value ="";
}

function applyWssUser(fieldId, obid, id, pwd) {
  if (id != '') {
	  $(fieldId).value = obid;
	  $(fieldId + 'Txt').value = id;
	  $(fieldId + 'Pwd').value = pwd;
  }
}

function selectMpc(fieldId) {
	if (fieldId != null && fieldId.length > 0) {
    	window.open("mpc20pu001.jsp?fieldId=" + fieldId, "View", "width=830,height=500,left=0,top=0,resizable=yes,scrollbars=yes");
    }
}

function viewSelectedMpc(fieldId) {
    var obid = $(fieldId).value;
    var url = "mpc21ac003.jsp";
    var isLocal = $(fieldId + "IsLocal").value;
    if (isLocal == 1) {
    	url = "mpc21ms001.jsp";
    } else if (isLocal == 0) {
	    url = "mpc21ms002.jsp";
    }
    if (obid != null && obid.length > 0) {
	    window.open(url + "?obid=" + obid, "View", "width=830,height=500,left=0,top=0,resizable=yes,scrollbars=yes");
    }
}

function deleteMpc(fieldId) {
	$(fieldId).value = "";
    $(fieldId + 'Uri').value = "";
    $(fieldId + 'Name').value = "";
    $(fieldId + 'IsLocal').value = "";
}

function applyMpc(fieldId, obid, uri, isLocal, check_name) {
  if (check_name != '') {
	  $(fieldId).value = obid;
	  $(fieldId + 'Uri').value = uri;
	  $(fieldId + 'Name').value = check_name;
	  $(fieldId + 'IsLocal').value = isLocal;
  }
}

function addRowMsgPropTbl(num) {

  var check_name = $('msgPropName'+num).value;
  var type = $('msgPropType'+num).value;
  var desc = $('msgPropDesc'+num).value;
  var required = eval("document.form1.msgPropRequired"+num);
  addRowMsgPropTblLast(num, check_name, type, desc, required);
}

function addRowMsgPropTblLast(num, check_name, type, desc, required) {
  if (check_name.length > 0) {
      if (!checkMsgPropName(check_name, type, num)) {
        alert("<%=_i18n.get("pmd10ms001.msgProPName.duplicate.inform")%>");
      	return;
      }

      var tbl = document.getElementById('msgPropTbl'+num);
      var seqno = tbl.rows.length;
	  var newRow = tbl.insertRow(seqno);
	  seqno = seqno + 1;
	  newRow.setAttribute("id","tr_" + (seqno));
	  var body = "";
	  var delBtnStr = '<a href="javascript:delRowTbl(\'msgPropTbl'+num+'\', \'tr_'+seqno+'\', \''+num+'\')"><img src="images/btn_big_delete.gif" width="39" height="23" border="0" align="absmiddle">';
	  var cell1 = newRow.insertCell(0);
	  body = '<input type="text" name="msgPname'+ num +'" value="'+ check_name +'" size="25" class="FormTextReadOnly" readOnly>';
	  cell1.innerHTML = body;
	  cell1.style.borderTop = '1px #C3D2E8 solid';
	  cell1.style.borderLeft = '1px #C3D2E8 solid';
	  cell1.style.borderRight = '1px #C3D2E8 solid';
	  cell1.style.borderBottom = '1px #C3D2E8 solid';
      cell1.style.background = '#FFFFFF';
      cell1.style.padding = '3px 3px 1px 3px';

	  var cell2 = newRow.insertCell(1);
	  body = '<input type="text" name="msgPtype'+ num +'" value="'+ type +'" size="10" class="FormTextReadOnly" readOnly>';
	  cell2.innerHTML = body;
	  cell2.style.borderTop = '1px #C3D2E8 solid';
	  cell2.style.borderLeft = '1px #C3D2E8 solid';
	  cell2.style.borderRight = '1px #C3D2E8 solid';
	  cell2.style.borderBottom = '1px #C3D2E8 solid';
      cell2.style.background = '#FFFFFF';
      cell2.style.padding = '3px 3px 1px 3px';

	  var cell3 = newRow.insertCell(2);
	  body = '<input type="text" name="msgPdesc'+ num +'" value="'+ desc +'" size="50" class="FormTextReadOnly" readOnly>';
	  cell3.innerHTML = body;
	  cell3.style.borderTop = '1px #C3D2E8 solid';
	  cell3.style.borderLeft = '1px #C3D2E8 solid';
	  cell3.style.borderRight = '1px #C3D2E8 solid';
	  cell3.style.borderBottom = '1px #C3D2E8 solid';
      cell3.style.background = '#FFFFFF';
      cell3.style.padding = '3px 3px 1px 3px';

	  var cell4 = newRow.insertCell(3);
	  body = '<input type="checkBox" name="msgPrequired'+ num +'"';
	  if (required == 'true') {
	  	  body += " checked";
	  } else if(required == 'false') {
	      body += "";
	  } else {
		  if (required.checked) {
		  	body += " checked";
		  }
	  }
	  body += ' disabled>';
	  body += '&nbsp;&nbsp;' + delBtnStr;
	  if (required == 'true') {
	  	  body += '<input type="hidden" name="msgPrequiredVal'+ num +'" value="1">';
	  } else if(required == 'false') {
	      body += '<input type="hidden" name="msgPrequiredVal'+ num +'" value="0">';
	  } else {
		  if (required.checked) {
			body += '<input type="hidden" name="msgPrequiredVal'+ num +'" value="1">';
		  } else {
			body += '<input type="hidden" name="msgPrequiredVal'+ num +'" value="0">';
		  }
	  }

	  cell4.innerHTML = body;
	  cell4.style.borderTop = '1px #C3D2E8 solid';
	  cell4.style.borderLeft = '1px #C3D2E8 solid';
	  cell4.style.borderRight = '1px #C3D2E8 solid';
	  cell4.style.borderBottom = '1px #C3D2E8 solid';
      cell4.style.background = '#FFFFFF';
      cell4.style.padding = '3px 3px 1px 3px';

      $('msgPropName'+num).value = "";
      $('msgPropType'+num).value = "";
      $('msgPropDesc'+num).value = "";
      eval("document.form1.msgPropRequired"+num).checked = false;
  }

}

function checkPayloadType(num){
  var val = $("payloadProfType"+num).value;
  val = val.toLowerCase();
  if (val == "text/xml") {
	  this.document.getElementById('payloadProfschemaFile'+num).className = "FormText";
	  this.document.getElementById('payloadProfschemaFile'+num).disabled = false;
  } else {
	  this.document.getElementById('payloadProfschemaFile'+num).className = "FormTextReadOnly";
	  this.document.getElementById('payloadProfschemaFile'+num).disabled = true;
  }
}

function applySchemaFile(num, filepath) {
	$('schemaFilePath'+num).value = filepath;
    addRowPayloadProfTbl(num);
}

function addRowPayloadProfTbl(num)
{
  var check_name = $('payloadProfName'+num).value;
  var type = $('payloadProfType'+num).value;
  var schemaFile = $('payloadProfschemaFile'+num).value;
  var maxSize = $('payloadProfSize'+num).value;
  var required = eval("document.form1.payloadProfRequired"+num);

  if (type.length > 0) {
      if (!checkPayloadProfName(check_name, num)) {
        alert("<%=_i18n.get("pmd10ms001.payloadProfileName.duplicate.inform")%>");
      	return;
      }
      addRowPayloadProfTblLast(num, check_name, type, schemaFile, maxSize, required);
  }
}

function addRowPayloadProfTblLast(num, check_name, type, schemaFile, maxSize, required)
{
  if (check_name == "") {
  	// soapbody전체를 나타냄
  	type = "text/xml";
  }

  if (maxSize.match(/[^0-9]/) != null ) {
	  alert("숫자만 입력할 수 있습니다.");
	  return;
  }

  var tbl = document.getElementById('payloadProfTbl'+num);
  var seqno = tbl.rows.length;
  var newRow = tbl.insertRow(seqno);
  seqno = seqno + 1;
  newRow.setAttribute("id","tr_" + (seqno));
  var body = "";
  var delBtnStr = '<a href="javascript:delRowTbl(\'payloadProfTbl'+num+'\', \'tr_'+seqno+'\',  \''+num+'\')"><img src="images/btn_big_delete.gif" width="39" height="23" border="0" align="absmiddle">';

  var cell1 = newRow.insertCell(0);
  body = '<input type="text" name="payloadPname'+ num+'" value="'+ check_name +'" size="25" class="FormTextReadOnly" readOnly>';
  cell1.innerHTML = body;
  cell1.style.borderTop = '1px #C3D2E8 solid';
  cell1.style.borderLeft = '1px #C3D2E8 solid';
  cell1.style.borderRight = '1px #C3D2E8 solid';
  cell1.style.borderBottom = '1px #C3D2E8 solid';
  cell1.style.background = '#FFFFFF';
  cell1.style.padding = '3px 3px 1px 3px';

  var cell2 = newRow.insertCell(1);
  body = '<input type="text" name="payloadPtype'+ num +'" value="'+ type +'" size="20" class="FormTextReadOnly" readOnly>';
  cell2.innerHTML = body;
  cell2.style.borderTop = '1px #C3D2E8 solid';
  cell2.style.borderLeft = '1px #C3D2E8 solid';
  cell2.style.borderRight = '1px #C3D2E8 solid';
  cell2.style.borderBottom = '1px #C3D2E8 solid';
  cell2.style.background = '#FFFFFF';
  cell2.style.padding = '3px 3px 1px 3px';

  var cell3 = newRow.insertCell(2);
  body = '<input type="text" name="payloadPschemaFile'+ num +'" value="'+ schemaFile +'" size="50" class="FormTextReadOnly" readOnly>';
  cell3.innerHTML = body;
  cell3.style.borderTop = '1px #C3D2E8 solid';
  cell3.style.borderLeft = '1px #C3D2E8 solid';
  cell3.style.borderRight = '1px #C3D2E8 solid';
  cell3.style.borderBottom = '1px #C3D2E8 solid';
  cell3.style.background = '#FFFFFF';
  cell3.style.padding = '3px 3px 1px 3px';

  var cell4 = newRow.insertCell(3);
  body = '<input type="text" name="payloadPFileSize'+ num +'" value="'+ maxSize +'" size="10" class="FormTextReadOnly" readOnly>';
  cell4.innerHTML = body;
  cell4.style.borderTop = '1px #C3D2E8 solid';
  cell4.style.borderLeft = '1px #C3D2E8 solid';
  cell4.style.borderRight = '1px #C3D2E8 solid';
  cell4.style.borderBottom = '1px #C3D2E8 solid';
  cell4.style.background = '#FFFFFF';
  cell4.style.padding = '3px 3px 1px 3px';

  var cell5 = newRow.insertCell(4);
  body = '<input type="checkBox" name="payloadPrequired'+ num +'"';
  if (required == 'true') {
	  	  body += " checked";
	  } else if(required == 'false') {
	      body += "";
	  } else {
		  if (required.checked) {
		  	body += " checked";
		  }
	  }
	  body += ' disabled>';
	  body += '&nbsp;&nbsp;' + delBtnStr;
	  if (required == 'true') {
	  	  body += '<input type="hidden" name="payloadPrequiredVal'+ num +'" value="1">';
	  } else if(required == 'false') {
	      body += '<input type="hidden" name="payloadPrequiredVal'+ num +'" value="0">';
	  } else {
		  if (required.checked) {
			body += '<input type="hidden" name="payloadPrequiredVal'+ num +'" value="1">';
		  } else {
			body += '<input type="hidden" name="payloadPrequiredVal'+ num +'" value="0">';
		  }
  }

  cell5.innerHTML = body;
  cell5.style.borderTop = '1px #C3D2E8 solid';
  cell5.style.borderLeft = '1px #C3D2E8 solid';
  cell5.style.borderRight = '1px #C3D2E8 solid';
  cell5.style.borderBottom = '1px #C3D2E8 solid';
  cell5.style.background = '#FFFFFF';
  cell5.style.padding = '3px 3px 1px 3px';

  setPayloadMaxSize(num);

  $('payloadProfName'+num).value = "";
  $('payloadProfType'+num).value = "";

  $('payloadProfschemaFile'+num).value = "";
  $('payloadProfschemaFile'+num).className = "FormTextReadOnly";
  $('payloadProfschemaFile'+num).disabled = true;

  $('payloadProfSize'+num).value = "";
  eval("document.form1.payloadProfRequired"+num).checked = false;


}

function delRowTbl(tblId, trnum, num) {
  var tbl = document.getElementById(tblId);
  var targetObj = document.getElementById(trnum);
  tbl.deleteRow(targetObj.rowIndex);
  setPayloadMaxSize(num);
}

function checkMsgPropName(check_name, type, num) {
      var inputs = document.getElementsByTagName('input');
      var nameArr = new Array();
      var typeArr = new Array();
      for (var i = 0; i < inputs.length; i++) {
          if (inputs[i].type == 'text' && inputs[i].name == "msgPname"+num) {
              nameArr.push(inputs[i].value);
          }
		  if (inputs[i].type == 'text' && inputs[i].name == "msgPtype"+num) {
              typeArr.push(inputs[i].value);
          }
      }
      for (i = 0; i < nameArr.length; i++) {
      	if (check_name == nameArr[i] && type == typeArr[i]) {
      		return false;
      	}
      }
      return true;
}

function checkPayloadProfName(check_name, num) {
      var inputs = document.getElementsByTagName('input');
      var fieldId = "payloadPname"+num;
      var arr = new Array();
      for (var i = 0; i < inputs.length; i++) {
          if (inputs[i].type == 'text' && inputs[i].name == fieldId) {
              arr.push(inputs[i].value);
          }
      }
      for (i = 0; i < arr.length; i++) {
      	if (check_name == arr[i]) {
      		return false;
      	}
      }
      return true;
}

function setPayloadMaxSize(num) {
      // maxSize
      var inputs = document.getElementsByTagName('input');
      var totalSize = 0 ;
      var size = 0;
      var fieldId = "payloadPFileSize"+num;
      for (var i = 0; i < inputs.length; i++) {
          if (inputs[i].type == 'text' && inputs[i].name == fieldId) {
              size = inputs[i].value
              if (size == '' || size.length ==0) {
              	size = 0;
              }
              totalSize += eval(size);
          }
      }
      $("payloadMaxSize"+num).value = totalSize;
}

function pmodeLeg() {
	var body = "";
	var mepbinding = $('mepbinding').value;

    // LEG[1]
	if (mepbinding == "<%=Eb3Constants.PMODE_MEPBINDING_PUSH%>"
	    || mepbinding == "<%=Eb3Constants.PMODE_MEPBINDING_SYNC%>"
	    || mepbinding == "<%=Eb3Constants.PMODE_MEPBINDING_PUSHANDPUSH%>"
	    || mepbinding == "<%=Eb3Constants.PMODE_MEPBINDING_PUSHANDPULL%>") {

		// push
		body += '<h3>LEG[1]</h3>';
		body += pmodeLegForUser("1", "");
	}

	// LEG[1][s], LEG[1][u]
	if (mepbinding == "<%=Eb3Constants.PMODE_MEPBINDING_PULL%>"
	    || mepbinding == "<%=Eb3Constants.PMODE_MEPBINDING_PULLANDPUSH%>") {

		// pull
		body += '<h3>LEG[1][s]</h3>';
		body += pmodeLegForSignal("1", "s");
		body += '<br>';
		body += '<h3>LEG[1][u]</h3>';
		body += pmodeLegForUser("1", "u");
	}

	// LEG[2]
	if (mepbinding == "<%=Eb3Constants.PMODE_MEPBINDING_SYNC%>"
			|| mepbinding == "<%=Eb3Constants.PMODE_MEPBINDING_PUSHANDPUSH%>"
			|| mepbinding == "<%=Eb3Constants.PMODE_MEPBINDING_PULLANDPUSH%>") {

		body += '<br>';
		body += '<h3>LEG[2]</h3>';
		body += pmodeLegForUser("2", "");
	}

	// LEG[2][s] LEG[2][u]
    if (mepbinding == "<%=Eb3Constants.PMODE_MEPBINDING_PUSHANDPULL%>") {

		body += '<br>';
		body += '<h3>LEG[2][s]</h3>';
		body += pmodeLegForSignal("2", "s");
		body += '<br>';
		body += '<h3>LEG[2][u]</h3>';
		body += pmodeLegForUser("2", "u");
	}

	$('legDisplay').innerHTML = body;

	if (mepbinding == "<%=Eb3Constants.PMODE_MEPBINDING_PULL%>"
	    || mepbinding == "<%=Eb3Constants.PMODE_MEPBINDING_PULLANDPUSH%>") {

		// PullSignal 수신오류는 따로 전송하지 않는다.
	    document.form1.errRcvErrTo1s.value = "";
	    document.form1.errRcvErrTo1s.disabled = true;
	    document.form1.errRcvErrTo1s.className = "FormTextReadOnly";

	    // [1][s] errAsResponse = true, [1][u] errAsResponse = false
		document.form1.errAsResponse1s[0].checked = true;
		document.form1.errAsResponse1s[0].disabled = true;
		document.form1.errAsResponse1s[1].disabled = true;

        document.form1.errAsResponse1u[1].checked = true;
		document.form1.errAsResponse1u[0].disabled = true;
		document.form1.errAsResponse1u[1].disabled = true;

	 }

	if (mepbinding == "<%=Eb3Constants.PMODE_MEPBINDING_PUSHANDPULL%>") {

		// PullSignal 수신오류는 따로 전송하지 않는다.
	    document.form1.errRcvErrTo2s.value = "";
	    document.form1.errRcvErrTo2s.disabled = true;
	    document.form1.errRcvErrTo2s.className = "FormTextReadOnly";

	    // [2][s] errAsResponse = true, [2][u] errAsResponse = false
		document.form1.errAsResponse2s[0].checked = true;
		document.form1.errAsResponse2s[0].disabled = true;
		document.form1.errAsResponse2s[1].disabled = true;

        document.form1.errAsResponse2u[1].checked = true;
		document.form1.errAsResponse2u[0].disabled = true;
		document.form1.errAsResponse2u[1].disabled = true;

	 }

	if (mepbinding == "<%=Eb3Constants.PMODE_MEPBINDING_SYNC%>") {
		// [1] errAsResponse = true, [2] errAsResponse = false
		document.form1.errAsResponse1[0].checked = true;
		document.form1.errAsResponse1[0].disabled = true;
		document.form1.errAsResponse1[1].disabled = true;

	    document.form1.errAsResponse2[1].checked = true;
		document.form1.errAsResponse2[0].disabled = true;
		document.form1.errAsResponse2[1].disabled = true;
	}
}

function pmodeLegForUser(legno, type) {
	var body = "";
	// 1. protocol
	body += pmodeLegProtocol(legno, type);

	// 2. businessInfo
	body += '<br>';
	body += pmodeLegBusinessInfo(legno, type);

	// 3. errHandling
	body += '<br>';
	body += pmodeLegErrHandling(legno, type);
	return body;
}

function pmodeLegForSignal(legno, type) {
	var body = "";
	// 1. protocol
	body += pmodeLegProtocol(legno, type);

	// 2. errHandling
	body += '<br>';
	body += pmodeLegErrHandling(legno, type);
	return body;
}

function pmodeLegProtocol(legno, type) {
	var body = "";

	body += '<table class="FieldTable">';
	body += '  <tr>';
	body += '    <td width="120" class="FieldLabel"><%= _i18n.get("pmd10ms001.protocol.address") %><font color="red"><%=_i18n.get("global.start.msg")%></font></td>';
	body += '    <td colspan="3" class="FieldData">';
	body += '    	<input type="text" name="protocolAddress'+legno+type+'" id="protocolAddress'+legno+type+'" value="" size="50" class="FormText">';
	body += '    </td>';
	body += '  </tr>';
	body += '  <tr>';
	body += '    <td width="120" class="FieldLabel"><%= _i18n.get("pmd10ms001.protocol.soapver") %></td>';
	body += '    <td colspan="3" class="FieldData">';
	body += '		<select name="protocolSoapVersion'+legno+type+'" id="protocolSoapVersion'+legno+type+'" class="FormSelect">';
<%
		for (int i=0; i < Eb3Constants.SOAPVerString.length; i++){
%>
	body += '           <option value="<%=i%>"><%=Eb3Constants.SOAPVerString[i]%></option>';
<%      }%>
	body += '		</select>';
	body += '    </td>';
	body += '  </tr>';
	body += '</table>';

	return body;
}

function pmodeLegBusinessInfo(legno, type) {
	var body = "";
	body += '<table class="FieldTable">';
	body += '  <tr>';
	body += '    <td width="120" class="FieldLabel"><%= _i18n.get("pmd10ms001.bizinfo.service") %><font color="red"><%=_i18n.get("global.start.msg")%></font></td>';
	body += '    <td colspan="3" class="FieldData">';
	body += '    	<input type="text" name="bizinfoService'+legno+type+'" id="bizinfoService'+legno+type+'" value="" size="50" class="FormText">';
	body += '    </td>';
	body += '  </tr>';
	body += '  <tr>';
	body += '    <td width="120" class="FieldLabel"><%= _i18n.get("pmd10ms001.bizinfo.action") %><font color="red"><%=_i18n.get("global.start.msg")%></font></td>';
	body += '    <td colspan="3" class="FieldData">';
	body += '    	<input type="text" name="bizinfoAction'+legno+type+'" id="bizinfoAction'+legno+type+'" value="" size="50" class="FormText">';
	body += '    </td>';
	body += '  </tr>';
	body += '  <tr>';
	body += '    <td width="120" class="FieldLabel"><%= _i18n.get("pmd10ms001.bizinfo.MPC")%></td>';
	body += '    <td colspan="3" class="FieldData">';
	body += '    	<input type="text" name="mpc'+legno+type+'Name" id="mpc'+legno+type+'Name" value="" size="50" class="FormTextReadOnly" readOnly>';
	body += '    	<input type="hidden" name="mpc'+legno+type+'" id="mpc'+legno+type+'" value="">';
	body += '    	<input type="hidden" name="mpc'+legno+type+'IsLocal" id="mpc'+legno+type+'IsLocal" value="">';
	body += '    	<input type="hidden" name="mpc'+legno+type+'Uri" id="mpc'+legno+type+'Uri" value="">';
	body += '        &nbsp;&nbsp;';
	body += '		<a href="javascript:selectMpc(\'mpc'+legno+type+'\')"><%=_i18n.get("pmd10ms001.btn.select") %></a>';
	body += '		&nbsp;&nbsp;';
	body += '		&nbsp;&nbsp;';
	body += '		<a href="javascript:viewSelectedMpc(\'mpc'+legno+type+'\')"><%=_i18n.get("pmd10ms001.btn.view") %></a>';
	body += '		&nbsp;&nbsp;';
	body += '		<a href="javascript:deleteMpc(\'mpc'+legno+type+'\')"><%=_i18n.get("pmd10ms001.btn.delete") %></a>    	';
	body += '    </td>';
	body += '  </tr>';
	body += '</table>';
	body += '<br>';
	body += '&nbsp;&nbsp;&nbsp;<img src="images/bu_search.gif" > <%= _i18n.get("pmd10ms001.column.msgproperties") %>';
	body += '<table class="FieldTable" id="msgPropTbl'+legno+type+'">';
	body += '  <tr>';
	body += '    <td width="25%" class="ResultHeader"><%= _i18n.get("pmd10ms001.msgproperties.name") %></td>';
	body += '    <td width="15%" class="ResultHeader"><%= _i18n.get("pmd10ms001.msgproperties.type") %></td>';
	body += '    <td class="ResultHeader"><%= _i18n.get("pmd10ms001.msgproperties.desc") %></td>';
	body += '    <td width="15%" class="ResultLastHeader"><%= _i18n.get("pmd10ms001.msgproperties.required") %></td>';
	body += '  </tr>';
	body += '  <tr>';
	body += '  	<td class="ResultData"><input type="text" name="msgPropName'+legno+type+'" id="msgPropName'+legno+type+'" value="" size="25" class="FormText"></td>';
	body += '  	<td class="ResultData">';
	body += '		<select name="msgPropType'+legno+type+'" id="msgPropType'+legno+type+'" class="FormSelect">';
<%
		for (int i=0; i < Eb3Constants.MsgPropDataTypeStr.length; i++){
			String type = Eb3Constants.MsgPropDataTypeStr[i];
%>
	body += '		<option value="<%=type%>"><%=type%></option>';
<%		}%>
	body += '		</select>';
	body += '  	</td>';
	body += '  	<td class="ResultData"><input type="text" name="msgPropDesc'+legno+type+'" id="msgPropDesc'+legno+type+'" value="" size="50" class="FormText"></td>';
	body += '  	<td class="ResultLastData">';
	body += '  		<input type="checkBox" name="msgPropRequired'+legno+type+'" id="msgPropRequired'+legno+type+'" class="">';
	body += '  		&nbsp;';
	body += '  		<a href="javascript:addRowMsgPropTbl(\''+legno+type+'\')"><img src="images/btn_big_add.gif" width="39" height="23" border="0" align="absmiddle"></a>';
	body += '  	</td>';
	body += '  </tr>';
	body += '</table>';
	body += '<br>';
	body += '&nbsp;&nbsp;&nbsp;<img src="images/bu_search.gif" > <%= _i18n.get("pmd10ms001.column.payloadprofile") %>';
	body += '&nbsp; (<%= _i18n.get("pmd10ms001.payloadprofile.totalsize.msg1") %>';
	body += '&nbsp; <input type="text" name="payloadMaxSize'+legno+type+'" id="payloadMaxSize'+legno+type+'" class="FormTextReadOnly" readOnly size=5>';
	body += '&nbsp; <%= _i18n.get("pmd10ms001.payloadprofile.totalsize.msg2") %>)';
	body += '<table class="FieldTable" id="payloadProfTbl'+legno+type+'">';
	body += '  <tr>';
	body += '    <td width="20%" class="ResultHeader"><%= _i18n.get("pmd10ms001.payloadprofile.name") %></td>';
	body += '    <td width="15%" class="ResultHeader"><%= _i18n.get("pmd10ms001.payloadprofile.type") %></td>';
	body += '    <td width="15%" class="ResultHeader"><%= _i18n.get("pmd10ms001.payloadprofile.schemafile") %></td>';
	body += '    <td width="10%" class="ResultHeader"><%= _i18n.get("pmd10ms001.payloadprofile.maxsize") %></td>';
	body += '    <td width="15%" class="ResultLastHeader"><%= _i18n.get("pmd10ms001.payloadprofile.required") %></td>';
	body += '  </tr>';
	body += '  <tr>';
	body += '  	<td class="ResultData"><input type="text" name="payloadProfName'+legno+type+'" id="payloadProfName'+legno+type+'" value="" size="25" class="FormText"></td>';
	body += '  	<td class="ResultData">';
	body += '        <input type="text" name="payloadProfType'+legno+type+'" id="payloadProfType'+legno+type+'" value="" size="20" class="FormText" onKeyup="javascript:checkPayloadType(\''+legno+type+'\')";>';
	body += '  	</td>';
	body += '  	<td class="ResultData"><input type="text" name="payloadProfschemaFile'+legno+type+'" id="payloadProfschemaFile'+legno+type+'" value="" size="50" disabled class="FormTextReadOnly"></td>';
	body += '  	<td class="ResultData"><input type="text" name="payloadProfSize'+legno+type+'" id="payloadProfSize'+legno+type+'" value="" size="10" class="FormText"></td>';
	body += '  	<td class="ResultLastData">';
	body += '  		<input type="checkBox" name="payloadProfRequired'+legno+type+'" id="payloadProfRequired'+legno+type+'" class="">';
	body += '  		<a href="javascript:addRowPayloadProfTbl(\''+legno+type+'\')"><img src="images/btn_big_add.gif" width="39" height="23" border="0" align="absmiddle"></a>';
	body += '  	</td>';
	body += '  </tr>';
	body += '</table>';

	return body;
}

function pmodeLegErrHandling(legno, type) {
	var body = "";

	body += '<table class="FieldTable">';
	body += '  <tr>';
	body += '    <td width="200" class="FieldLabel"><%= _i18n.get("pmd10ms001.column.err_snd_err_to") %></td>';
	body += '    <td class="FieldData">';
	body += '    	<input type="text" name="errSndErrTo'+legno+type+'" id="errSndErrTo'+legno+type+'" value="" size="70" class="FormText">';
	body += '    	<br>';
	body += '    	<font color=red><%= _i18n.get("pmd10ms001.err.to.url") %></font>';
	body += '    </td>';
	body += '  </tr>';
	body += '  <tr>';
	body += '    <td width="200" class="FieldLabel"><%= _i18n.get("pmd10ms001.column.err_rcv_err_to") %></td>';
	body += '    <td class="FieldData">';
	body += '    	<input type="text" name="errRcvErrTo'+legno+type+'" id="errRcvErrTo'+legno+type+'" value="" size="70" class="FormText">';
	body += '    	<br>';
	body += '    	<font color=red><%= _i18n.get("pmd10ms001.err.to.url") %></font>';
	body += '    </td>';
	body += '  </tr>';
	body += '  <tr>';
	body += '    <td width="200" class="FieldLabel"><%= _i18n.get("pmd10ms001.column.err_as_response") %></td>';
	body += '    <td class="FieldData">';
	body += '    	<input type="radio" name="errAsResponse'+legno+type+'" id="errAsResponse'+legno+type+'" value="<%=Eb3Constants.PMODE_ERR_REPORT_TRUE%>"><%= _i18n.get("global.msg.yes") %>&nbsp;&nbsp;';
	body += '    	<input type="radio" name="errAsResponse'+legno+type+'" id="errAsResponse'+legno+type+'" value="<%=Eb3Constants.PMODE_ERR_REPORT_FALSE%>"><%= _i18n.get("global.msg.no") %>';
	body += '	</td>';
	body += '  </tr>';
	body += '  <tr>';
	body += '    <td width="200" class="FieldLabel"><%= _i18n.get("pmd10ms001.column.err_pe_notify_consumer") %></td>';
	body += '    <td class="FieldData">';
	body += '    	<input type="radio" name="errPeNotifyConsumer'+legno+type+'" id="errPeNotifyConsumer'+legno+type+'" value="<%=Eb3Constants.PMODE_ERR_REPORT_TRUE%>" disabled><%= _i18n.get("global.msg.yes") %>&nbsp;&nbsp;';
	body += '    	<input type="radio" name="errPeNotifyConsumer'+legno+type+'" id="errPeNotifyConsumer'+legno+type+'" value="<%=Eb3Constants.PMODE_ERR_REPORT_FALSE%>" checked disabled><%= _i18n.get("global.msg.no") %>';
	body += '	</td>';
	body += '  </tr>';
	body += '  <tr>';
	body += '    <td width="200" class="FieldLabel"><%= _i18n.get("pmd10ms001.column.err_pe_notify_producer") %></td>';
	body += '    <td class="FieldData">';
	body += '    	<input type="radio" name="errPeNotifyProducer'+legno+type+'" id="errPeNotifyProducer'+legno+type+'" value="<%=Eb3Constants.PMODE_ERR_REPORT_TRUE%>"><%= _i18n.get("global.msg.yes") %>&nbsp;&nbsp;';
	body += '    	<input type="radio" name="errPeNotifyProducer'+legno+type+'" id="errPeNotifyProducer'+legno+type+'" value="<%=Eb3Constants.PMODE_ERR_REPORT_FALSE%>"><%= _i18n.get("global.msg.no") %>';
	body += '	</td>';
	body += '  </tr>';
	body += '  <tr>';
	body += '    <td width="200" class="FieldLabel"><%= _i18n.get("pmd10ms001.column.err_df_notify_producer") %></td>';
	body += '    <td class="FieldData">';
	body += '    	<input type="radio" name="errDfNotifyProducer'+legno+type+'" id="errDfNotifyProducer'+legno+type+'" value="<%=Eb3Constants.PMODE_ERR_REPORT_TRUE%>" disabled><%= _i18n.get("global.msg.yes") %>&nbsp;&nbsp;';
	body += '    	<input type="radio" name="errDfNotifyProducer'+legno+type+'" id="errDfNotifyProducer'+legno+type+'" value="<%=Eb3Constants.PMODE_ERR_REPORT_FALSE%>" checked disabled><%= _i18n.get("global.msg.no") %>';
	body += '	</td>';
	body += '  </tr>';
	body += ' </table>';

	return body;
}

function viewPMode(obid) {
	window.open("pmd22ac001.jsp?obid=" + obid, "View", "width=1010,height=800,left=0,top=0,resizable=yes,scrollbars=yes");
}

function downloadPMode(obid) {
	frm = document.form1;
	frm.action = "pmd50ac001.jsp?obid=" + obid;
	frm.method = "post";
	frm.submit();
}

window.onload = initialize;
//
--></script>
</head>
<body bgcolor=#FFFFFF leftmargin=0 topmargin=0 marginwidth=0 marginheight=0>
<!-- 검색 Form 시작 ... -->
<form name="form1" method="POST" enctype="multipart/form-data">
<input type="hidden" name="nameCheckFlag" id="nameCheckFlag" value = "0">
<input type="hidden" name="idCheckFlag" id="idCheckFlag" value = "0">
<input type="hidden" name="obid" value="<%=obid %>">
<input type="hidden" name="filepath" value="<%=pmode.getFilePath() %>">
<!-- 제목테이블 -->
<table class="TableLayout" border=0>
  <tr>
    <td width="200" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get(menuKey)%></td>
    <td width="560" class="MessageDisplay"><div id="messageDisplay"></div></td>
  </tr>
  <tr>
    <td colspan="2" height="10"></td>
  </tr>
  <tr>
    <td colspan="2" height="10"><font color="red"><%=_i18n.get("global.notnull.startmsg")%></font></td>
  </tr>
</table>

<!-- 상세정보 테이블-->
<table class="FieldTable">
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("pmd20ms001.column.name") %><font color="red"><%=_i18n.get("global.start.msg")%></font></td>
    <td colspan="3" class="FieldData">
    	<table style= "border:0;   padding:0;   margin-left:0px;  border-collapse:collapse ;">
    		<tr>
    			<td><input type="text" name="name" id="name" onKeyUp="javascript:enterDown(1);" value="" size="50" class="FormText"></td>
    			<td><div id="nameCheckBtnDisplay"></div></td>
    		</tr>
    	</table>
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("pmd20ms001.column.id") %><font color="red"><%=_i18n.get("global.start.msg")%></font></td>
    <td colspan="3" class="FieldData">
    	<table style= "border:0;   padding:0;   margin-left:0px;  border-collapse:collapse ;">
    		<tr>
    			<td><input type="text" name="id" id="id" onKeyDown="javascript:enterDown(2);" value="" size="50" class="FormText"></td>
    			<td><div id="idCheckBtnDisplay"></div></td>
    		</tr>
    	</table>
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("pmd10ms001.column.agreement") %><font color="red"><%=_i18n.get("global.start.msg")%></font></td>
    <td colspan="3" class="FieldData">
      <input type="text" name="agreement" id="agreement" class="FormText" value="" size="90">
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("pmd10ms001.column.mep") %><font color="red"><%=_i18n.get("global.start.msg")%></font></td>
    <td width="260" class="FieldData">
      <input type="radio" name="mep" id="mep" value="<%= Eb3Constants.PMODE_MEP_ONEWAY%>" onClick="javascript:viewMepBinding(this.value)"><%= Eb3Constants.PModeMepString[Eb3Constants.PMODE_MEP_ONEWAY] %>&nbsp;&nbsp;
      <input type="radio" name="mep" id="mep" value="<%= Eb3Constants.PMODE_MEP_TWOWAY%>" onClick="javascript:viewMepBinding(this.value)"><%= Eb3Constants.PModeMepString[Eb3Constants.PMODE_MEP_TWOWAY] %>&nbsp;&nbsp;
    </td>
    <td width="120" class="FieldLabel"><%= _i18n.get("pmd10ms001.column.mepbinding") %><font color="red"><%=_i18n.get("global.start.msg")%></font></td>
    <td width="260" class="FieldData">
        <div id="mepBindingDisplay"></div>
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("pmd10ms001.column.myrole") %><font color="red"><%=_i18n.get("global.start.msg")%></font></td>
    <td colspan="3" class="FieldData">
     <input type="radio" name="myrole" id="myrole" value="<%=Eb3Constants.PMODE_MYROLE_INITIATOR%>" ><%= _i18n.get("pmd10ms001.role.initiator") %>&nbsp;&nbsp;
     <input type="radio" name="myrole" id="myrole" value="<%=Eb3Constants.PMODE_MYROLE_RESPONDER%>" ><%= _i18n.get("pmd10ms001.role.responder") %>&nbsp;&nbsp;
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("pmd10ms001.column.initinfo") %></td>
    <td colspan="3" class="FieldData">
		<table style= "border:0;   padding:0;   margin-left:0px;  border-collapse:collapse ;" width=100%>
		  <tr>
		    <td width="15%">
		    	<%=_i18n.get("pmd10ms001.role.info.partyid")%><font color="red"><%=_i18n.get("global.start.msg")%></font>
		    </td>
		    <td width="35%">
			    <input type="text" name="initPartyId" id="initPartyId" class="FormText" value="" size="30">
		    </td>
		    <td width="15%">
		    	<%=_i18n.get("pmd10ms001.role.info.role")%><font color="red"><%=_i18n.get("global.start.msg")%></font>
		    </td>
		    <td width="35%">
			    <input type="text" name="initRole" id="initRole" class="FormText" value="" size="30">
		    </td>
		  </tr>
		  <tr>
		    <td width="15%">
		    	<%=_i18n.get("pmd10ms001.role.info.wssuser")%>
		    </td>
		    <td width="35%" colspan=3>
			    <input type="text" name="initWssuserTxt" id="initWssuserTxt" class="FormTextReadOnly" readOnly value="" size="50">
			    <input type="hidden" name="initWssuser" id="initWssuser" value="">
			    <input type="hidden" name="initWssuserPwd" id="initWssuserPwd" value="">
			    &nbsp;&nbsp;
			    <a href="javascript:selectWssUser('initWssuser')"><%=_i18n.get("pmd10ms001.btn.select") %></a>
			    &nbsp;&nbsp;
			    <a href="javascript:viewSelectedWssUser('initWssuser')"><%=_i18n.get("pmd10ms001.btn.view") %></a>
			    &nbsp;&nbsp;
			    <a href="javascript:deleteWssUser('initWssuser')"><%=_i18n.get("pmd10ms001.btn.delete") %></a>
		    </td>
		  </tr>
		</table>
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("pmd10ms001.column.respinfo") %></td>
    <td colspan="3" class="FieldData">
		<table style= "border:0;   padding:0;   margin-left:0px;  border-collapse:collapse ;" width=100%>
		  <tr>
		    <td width="15%">
		    	<%=_i18n.get("pmd10ms001.role.info.partyid")%><font color="red"><%=_i18n.get("global.start.msg")%></font>
		    </td>
		    <td width="35%">
			    <input type="text" name="respPartyId" id="respPartyId" class="FormText" value="" size="30">
		    </td>
		    <td width="15%">
		    	<%=_i18n.get("pmd10ms001.role.info.role")%><font color="red"><%=_i18n.get("global.start.msg")%></font>
		    </td>
		    <td width="35%">
			    <input type="text" name="respRole" id="respRole" class="FormText" value="" size="30">
		    </td>
		  </tr>
		  <tr>
		    <td width="15%">
		    	<%=_i18n.get("pmd10ms001.role.info.wssuser")%>
		    </td>
		    <td width="35%" colspan=3>
			    <input type="text" name="respWssuserTxt" id="respWssuserTxt" class="FormTextReadOnly" readOnly value="" size="50">
			    <input type="hidden" name="respWssuser" id="respWssuser" value="">
			    <input type="hidden" name="respWssuserPwd" id="respWssuserPwd" value="">
			    &nbsp;&nbsp;
			    <a href="javascript:selectWssUser('respWssuser')"><%=_i18n.get("pmd10ms001.btn.select") %></a>
			    &nbsp;&nbsp;
			    <a href="javascript:viewSelectedWssUser('respWssuser')"><%=_i18n.get("pmd10ms001.btn.view") %></a>
			    &nbsp;&nbsp;
			    <a href="javascript:deleteWssUser('respWssuser')"><%=_i18n.get("pmd10ms001.btn.delete") %></a>

		    </td>
		  </tr>
		</table>
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("pmd20ms001.column.desc") %></td>
    <td colspan="3" class="FieldData">
      <input type="text" name="desc" id="desc" value="" size="90" class="FormText">
    </td>
  </tr>
<%
if (!"insert".equalsIgnoreCase(command)) {
%>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("pmd20ms001.column.file")%></td>
    <td colspan="3" class="FieldData"><img src="images/xml.gif" width="39" height="20" align="absmiddle">
      <a href="javascript:viewPMode('<%=obid%>');"><img src="images/btn_inview.gif" width="39" height="13" align="absmiddle" border="0"></a>
      <a href="javascript:downloadPMode('<%= obid%>');"><img src="images/btn_indown.gif" width="62" height="13" align="absmiddle" border="0"></a>
    </td>
  </tr>
<%} %>
</table>

<!-- Leg  -->
<br>
<div id="legDisplay"></div>
<br>
<!-- 버튼테이블 -->
<table class="TableLayout" >
  <tr>
    <td align="right" style="padding-top:15">
      <a href="pmd20ms001.jsp"><img src="images/btn_big_list.gif" width="39" height="23" border="0"></a>
<%
if ("insert".equalsIgnoreCase(command)) {
%>
      <a href="javascript:storePMode(1);"><img src="images/btn_big_create.gif" width="39" height="23" border="0"></a>
<%
} else if ("update".equalsIgnoreCase(command)){
%>
      <a href="javascript:storePMode(2);"><img src="images/btn_big_change.gif" width="39" height="23" border="0"></a>
      <a href="javascript:deletePMode()"><img src="images/btn_big_delete.gif" width="39" height="23" border="0"></a>
<%
} else {
%>
      <a href="javascript:storePMode(2);"><img src="images/btn_big_change.gif" width="39" height="23" border="0"></a>
      <a href="javascript:deletePMode()"><img src="images/btn_big_delete.gif" width="39" height="23" border="0"></a>
<%
}
%>
    </td>
  </tr>
</table>
</form>
</body>
</html>
