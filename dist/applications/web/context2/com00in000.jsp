<%@ page import="kr.co.bizframe.mxs.web.I18nStrings" %>
<!-- Common include file -->
<%
/**
 * Common stylesheets and javascripts, should be included in every JSP file
 *
 * @author Jae-Heon Kim
 * @version 1.0
 */
I18nStrings _i18n = I18nStrings.getInstance();
String _previousPage = (String)session.getAttribute("_currentPage");
String _currentPage = request.getRequestURI();
if (_currentPage.equals(_previousPage)) {
	session.setAttribute("_previousPage", null); // TODO:: Set to home
} else {
	session.setAttribute("_previousPage", _previousPage);
}
session.setAttribute("_currentPage", _currentPage);

%>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<script type="text/javascript" src="js/prototype.js"> </script>
<script type="text/javascript" src="js/effects.js"> </script>
<script type="text/javascript" src="js/window.js"> </script>
<script type="text/javascript" src="js/debug.js"> </script>
<script type="text/javascript" src="js/error.js"> </script>
<script type="text/javascript" src="js/deserialize.js"> </script>
<script type="text/javascript" src="js/tooltip.js"> </script>
<link href="./css/error.css" rel="stylesheet" type="text/css" />
<link href="./css/BizFrameMxs.css" rel="stylesheet" type="text/css" />
<link href="./css/default.css" rel="stylesheet" type="text/css" />
<link href="./css/debug.css" rel="stylesheet" type="text/css" />
<link href="./css/alphacube.css" rel="stylesheet" type="text/css" />
<link href="./css/lighting.css" rel="stylesheet" type="text/css" />

<script language="JavaScript" type="text/JavaScript">

function openAlert(msg, title, okStr) {
	if (msg == null || msg == '') {
		msg = "<%=_i18n.get("com00in000.empty.msg")%>";
	}
	if (okStr == null || okStr == '') {
		okStr = "<%=_i18n.get("global.ok")%>";
	}
	if (title == null || title == '') {
		title = "<%=_i18n.get("global.alert")%>";
	}
	Dialog.alert("<br>" + msg,
		{
		width:300,
		okLabel: okStr,
		title: title,
		className: "bluelighting",
		id: "mxsDefaultDialogId",
		buttonClass: "mxsButtonClass",
		ok:function(win) {Dialog._closeInfo(); return true;}
		}
	);

}

function openConfirm(msg, okFn, cancelFn, title, okStr, cancelStr) {
	if (msg == null || msg == '') {
		msg = "<%=_i18n.get("com00in000.empty.msg")%>";
	}
	if (title == null || title == '') {
		title = "<%=_i18n.get("global.warning")%>";
	}
	if (okStr == null || okStr == '') {
		okStr = "<%=_i18n.get("global.ok")%>";
	}
	if (cancelStr == null || cancelStr == '') {
		cancelStr = "<%=_i18n.get("global.cancel")%>";
	}
	//error("aaaaaaaaaaaa");
	//error(okStr);
	Dialog.confirm("<br>" + msg,
		{
		width:250,
		className: "bluelighting",
		title: title,
		okLabel: okStr,
		draggable:true,
		cancelLabel: cancelStr,
		id: "mxsDefaultDialogId2",
		//effectOptions: {backgroundColor: #c0c0c0},
		buttonClass: "mxsButtonClass",
		//cancel:function(win) {Dialog._closeInfo(); return false;},
		ok:okFn,
		cancel:cancelFn
		}
	);
}

var timeout;
function openInfo(msg) {
	if (msg == null || msg == '') {
		msg = "<%=_i18n.get("com00in000.empty.msg")%>";
	}
	Dialog.info("<br>" + msg,
		{
		//top: 10,
		width:200,
		hight:100,
		className: "alphacube",
		showProgress: "1",
		closable: "1",
		destroyOnClose: true,
		resizable: false,
		showEffect: Effect.BlindDown,
		hideEffect: Effect.SwitchOff,
		showEffect: Element.show,
		//hideEffect: Element.hide,
		showEffectOptions: {duration:0},
		hideEffectOptions: {duration:0.2},
		overlayShowEffectOptions: {duration:0},
		overlayHideEffectOptions: {duration:0},
		id: "mxsDefaultDialogId3",
		//effectOptions: {backgroundColor: #c0c0c0},
		buttonClass: "mxsButtonClass"
		}
	);

	//timeout=2; setTimeout(infoTimeout, 1000);
}

function closeInfo() {
	//timeout=1; setTimeout(infoTimeout, 1000);
	//alert('dd');
	setTimeout(function() {Dialog._closeInfo()}, 10);
}

function infoTimeout() {
	timeout--;
	if (timeout >0) {
		//Dialog.setInfoMessage("Test of info panel, it will close <br>in " + timeout + "s ...") ;
		setTimeout(infoTimeout, 1000) ;
	} else {
		Dialog._closeInfo() ;
	}
}
function showError(msg, title, okStr, cancelStr) {
	if (okStr == null || okStr == '') {
		okStr = "<%=_i18n.get("err00zz500.ok")%>";
	}
	if (cancelStr == null || cancelStr == '') {
		cancelStr = "<%=_i18n.get("err00zz500.cancel")%>";
	}
	if (title == null || title == '') {
		title = "<%=_i18n.get("err00zz500.title")%>";
	}
	_showError(msg, title, okStr, cancelStr);
}

function showErrorPopup(msg, title, okStr, cancelStr) {
	if (okStr == null || okStr == '') {
		okStr = "<%=_i18n.get("err00zz500.ok")%>";
	}
	if (cancelStr == null || cancelStr == '') {
		cancelStr = "<%=_i18n.get("err00zz500.cancel")%>";
	}
	if (title == null || title == '') {
		title = "<%=_i18n.get("err00zz500.title")%>";
	}
	_showErrorPopup(msg, title, okStr, cancelStr);
}

function clearNotify() {
	$('messageDisplay').innerHTML = '';
}

</script>
