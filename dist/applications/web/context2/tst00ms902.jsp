<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%
/**
 * Webservice Self-Test Page
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

var global_wsdl;

function initialize() {
	getWsdl();
}

function getWsdl() {
	var opt = {
		method: 'get',
		parameters: 'wsdltype=0&item_Cnt=999',
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

function displayWsdlList(originalRequest) {
	var res = eval("(" + originalRequest.responseText + ")");

	var operations = "";
	var performers = "";
	var body = "";
	for (var i=0; i<res.wsdl.length; i++) {
		$('wsdlId').options[i] = new Option(res.wsdl[i].name,res.wsdl[i].obid);
		if (i==0) {
			$('wsdlId').options[i].selected = true;
		}
	}
	getWsdlDetail();
}

function getWsdlDetail() {
	var params = 'obid=' + $('wsdlId').options[$('wsdlId').selectedIndex].value;
	var opt = {
			method: 'get',
			parameters: params,
			asynchronous : false,
			onSuccess: displayWsdlDetail,
			on404: function(t) {
				$('messageDisplay').innerHTML = '<%=_i18n.get("err00zz404.message") %>';
			},
			onFailure: function(t) {
				$('messageDisplay').innerHTML = '<%=_i18n.get("global.error.retry") %>';
				showErrorPopup(t.responseText, null, null, null);
			}
		}
	var myAjax = new Ajax.Request( './msi20ac902.jsp', opt);

}

function displayWsdlDetail(originalRequest)
{
	global_wsdl = eval("(" + originalRequest.responseText + ")");
	getService();
}
function getService() {
	$('service').length = 0;

	for (var i=0; i<global_wsdl.wsdl.service.length; i++) {
		var serviceName = global_wsdl.wsdl.service[i].name;
		var serviceId = global_wsdl.wsdl.service[i].id;
		$('service').options[i] = new Option(serviceName,serviceId);

		if (i==0)
			$('service').options[i].selected = true;
	}

	getOperation();

}

function getOperation() {
	$('operation').length = 0;

	selectedId = $('service').options[$('service').selectedIndex].value;
	for (var i=0; i<global_wsdl.wsdl.service.length; i++) {
		row = 0;
		var serviceName = global_wsdl.wsdl.service[i].name;
		var serviceId = global_wsdl.wsdl.service[i].id;
		if (serviceId == selectedId) {
			for (var j=0; j<global_wsdl.wsdl.service[i].binding.length; j++) {
				if (j!=0) break;

				var bindingName = global_wsdl.wsdl.service[i].binding[j].name;
				operations = "";
				performers = "";

				//$('from_endpoint').value = "";
				$('to_endpoint').value = global_wsdl.wsdl.service[i].binding[j].address;
				$('reply_endpoint').value = "<%=request.getRequestURL().substring(0,request.getRequestURL().toString().lastIndexOf('/'))%>/msh?wsdl=" + global_wsdl.wsdl.name;
				$('from_endpoint').value = $('reply_endpoint').value;

				for (var k=0; k<global_wsdl.wsdl.service[i].binding[j].operation.length; k++) {
					var opId = global_wsdl.wsdl.service[i].binding[j].operation[k].id;
					var opName = global_wsdl.wsdl.service[i].binding[j].operation[k].name;

					$('operation').options[k] = new Option(opName,opId);

				}
				break;
			}
		}
	}
}

function sendMessage() {
	document.form1.action = "tst21ms902.jsp";
	document.form1.submit();

	/*
	var params = Form.serialize(document.form1);

	openInfo('<%=_i18n.get("global.processing") %>');
	var opt = {
			method: 'post',
			parameters: params,
			asynchronous : false,
			onSuccess: displayResult,
			on404: function(t) {
				closeInfo();
				$('messageDisplay').innerHTML = '<%=_i18n.get("err00zz404.message") %>';
			},
			onFailure: function(t) {
				closeInfo();
				//$('messageDisplay').innerHTML = '<%=_i18n.get("global.error.retry") %>';
				showErrorPopup(t.responseText, null, null, null);
			}
		}
	var myAjax = new Ajax.Request( './tst21ms902.jsp', opt);
	*/
}

function displayResult(originalRequest)
{
	res = eval("(" + originalRequest.responseText + ")");

	$('response_msg').innerHTML = res.result;
}

function reform() {
	var browserName = navigator.appName;

	if ($('wsa_use').checked) {
		$('wsa_block1').style.display = 'none';
		$('wsa_block2').style.display = 'none';
		$('wsa_block3').style.display = 'none';
		$('sync_block').style.display = 'none';
	} else {
		if (browserName == "Microsoft Internet Explorer") {
			$('wsa_block1').style.display = 'block';
			$('wsa_block2').style.display = 'block';
			$('wsa_block3').style.display = 'block';
		} else {
			$('wsa_block1').style.display = 'table-row';
			$('wsa_block2').style.display = 'table-row';
			$('wsa_block3').style.display = 'table-row';
		}

		if ($('wsa_sync').checked) {
			$('sync_block').style.display = 'none';
		} else {
			if (browserName == "Microsoft Internet Explorer") {
				$('sync_block').style.display = 'block';
			} else {
				$('sync_block').style.display = 'table-row';
			}
		}
	}
}

function setSync(val) {
	if (val == true) {

	} else {

	}
}

window.onload = initialize;
//-->
</script>
</head>
<body>
<!-- 제목테이블 -->
<table class="TableLayout">
  <tr>
    <td width="180" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.test.ws.self")%></td>
    <td width="580" class="MessageDisplay" >&nbsp;<div id=messageDisplay></td>
  </tr>
  <tr>
    <td colspan="2" height="10"></td>
  </tr>
</table>
<form name="form1" method="post" enctype="multipart/form-data">
<input type="hidden" name="command" id="command" value="send">
<!-- 상세정보 테이블-->
<table class="FieldTable">
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("global.wsdl") %></td>
    <td colspan="3" class="FieldData">
      <select name="wsdlId" id="wsdlId" onChange="getWsdlDetail()" style="width:220;"></select>
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("global.service") %></td>
    <td colspan="3" class="FieldData">
      <select name="service" id="service" onChange="getOperation()" style="width:220;"></select>
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("global.msg.operation") %></td>
    <td colspan="3" class="FieldData">
      <select name="operation" id="operation" style="width:220;"></select>
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("global.wsa") %></td>
    <td colspan="3" class="FieldData">
      <input type="radio" name="wsa_use" id="wsa_use" value="0" onClick="reform()" checked><%= _i18n.get("global.not.use") %>&nbsp;&nbsp;
      <input type="radio" name="wsa_use" id="wsa_use" value="1" onClick="reform()"><%= _i18n.get("global.use") %></td>
    </td>
  </tr>
  <tr id="wsa_block1" style="display:none">
    <td width="120" class="FieldLabel"><%= _i18n.get("tst.operation.type") %></td>
    <td colspan="3" class="FieldData">
		<input type="radio" name="action_type" id="action_type" value="0" checked><%= _i18n.get("tst.operation.input") %>&nbsp;&nbsp;
		<!--input type="radio" name="action_type" id="action_type" value="1"><%= _i18n.get("tst.operation.output") %> &nbsp;&nbsp;-->
		<!--input type="radio" name="action_type" id="action_type" value="2"><%= _i18n.get("tst.operation.fault") %> &nbsp;&nbsp;-->
    </td>
  </tr>
  <tr id="wsa_block2" style="display:none">
    <td width="120" class="FieldLabel"><%= _i18n.get("tst.endpoint") %></td>
    <td colspan="3" class="FieldData">
		<%= _i18n.get("tst.endpoint.from") %> <input type="text" name="from_endpoint" id="from_endpoint" value="http://192.168.10.5:9095/imxs/ARCService">&nbsp;&nbsp;
		<%= _i18n.get("tst.endpoint.to") %> <input type="text" name="to_endpoint" id="to_endpoint" value="http://192.168.10.5:9005/imxs/ARCService9005"></span>
    </td>
  </tr>
  <tr id="wsa_block3" style="display:none">
    <td width="120" class="FieldLabel"><%= _i18n.get("tst.transfer") %></td>
    <td colspan="3" class="FieldData">
	<input type="radio" name="wsa_sync" id="wsa_sync" value="1" onClick="reform()" checked><%= _i18n.get("tst.sync") %> &nbsp;&nbsp;
	<input type="radio" name="wsa_sync" id="wsa_sync" value="0" onClick="reform()"><%= _i18n.get("tst.async") %></td>
    </td>
  </tr>
  <tr id="sync_block" style="display:none">
    <td width="120" class="FieldLabel"><%= _i18n.get("tst.endpoint.reply") %></td>
    <td colspan="3" class="FieldData">
	<%= _i18n.get("tst.endpoint.replyto") %> <input type="text" name="reply_endpoint" id="reply_endpoint" value="http://schemas.xmlsoap.org/ws/2004/08/addressing/role/anonymous">
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("tst.body") %></td>
    <td colspan="3" class="FieldData">
	  <textarea name="body_content" id="body_content" cols="80" rows="10"></textarea>
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("tst.attach.1") %></td>
    <td colspan="3" class="FieldData">
	  <input name="payload" id="payload" type="file" size=40>
    </td>
  </tr>
</table>

<table width="650" border="0" cellspacing="0" cellpadding="0">
  <tr>
	<td height="45" align="center" valign="bottom"><img src="images/send_b.gif" align="absmiddle" onclick="javascript:sendMessage()"></td>
  </tr>
</table>
</form>
</body>
</html>
