<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%
/**
 * ebMS Test Page
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

var global_cpa;

function initialize() {
	getCpa();
}

function getCpa() {
	var opt = {
		method: 'get', 
		parameters: 'item_Cnt=999', 
		onSuccess: displayCpaList,
		on404: function(t) {
			$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" ><%=_i18n.get("err00zz404.message") %>';
		//	showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
		},
		onFailure: function(t) {
			$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" ><%=_i18n.get("global.error.retry") %>';
			showErrorPopup(t.responseText, null, null, null);
		}
	}
	var myAjax = new Ajax.Request("./cpa20ac001.jsp", opt);

}		

function displayCpaList(originalRequest) {
	var res = eval("(" + originalRequest.responseText + ")");

	var operations = "";
	var performers = "";
	var body = "";
	for (var i=0; i<res.list.length; i++) {
		$('cpaId').options[i] = new Option(res.list[i].cpaId, res.list[i].obid);
		if (i==0) {
			$('cpaId').options[i].selected = true;
		}
	}
	getCpaDetail();
}	

function getCpaDetail() {
	var params = 'obid=' + $('cpaId').options[$('cpaId').selectedIndex].value;
	var opt = {
			method: 'get', 
			parameters: params,
			asynchronous : false,
			onSuccess: displayCpaDetail,
			on404: function(t) {
				$('messageDisplay').innerHTML = '<%=_i18n.get("err00zz404.message") %>';
			},
			onFailure: function(t) {
				$('messageDisplay').innerHTML = '<%=_i18n.get("global.error.retry") %>';
				showErrorPopup(t.responseText, null, null, null);
			}
		}
	var myAjax = new Ajax.Request( './tst20ac001.jsp', opt);

}

function displayCpaDetail(originalRequest)
{   
	global_cpa = eval("(" + originalRequest.responseText + ")");
	getService();	
}
function getService() {
	$('service').length = 0;
	for (var i=0; i<global_cpa.service.length; i++) {
		var serviceName = global_cpa.service[i].service;
		var partyName = global_cpa.service[i].party_name;
		var role = global_cpa.service[i].role;
		if (global_cpa.partyName == partyName) {
			$('service').options[$('service').options.length] = new Option(serviceName,global_cpa.service[i].obid);
			$('fromRole').value = role;
			$('service').options[$('service').options.length-1].selected = true;
		} else {
			$('toRole').value = role;
		}
	}
	getAction();
}

function getAction() {
	$('actionName').length = 0;
	
	selectedId = $('service').options[$('service').selectedIndex].value;
	for (var i=0; i<global_cpa.service.length; i++) {
		row = 0;
		var serviceName = global_cpa.service[i].service;
		var serviceId = global_cpa.service[i].obid;
		if (serviceId == selectedId) { 
			for (var j=0; j<global_cpa.service[i].action.length; j++) {
				var actionName = global_cpa.service[i].action[j].name;
				var actionId = global_cpa.service[i].action[j].obid;
				$('actionName').options[j] = new Option(actionName,actionId);
				if (i==0) 
					$('actionName').options[j].selected = true;				
			}
		}		
	}
	getDeliveryChannel();
}
function getDeliveryChannel() {
	$('deliveryChannel').length = 0;
	
	selectedId = $('actionName').options[$('actionName').selectedIndex].value;
	for (var i=0; i<global_cpa.service.length; i++) {
		row = 0;
		var serviceName = global_cpa.service[i].service;
		var serviceId = global_cpa.service[i].obid;
		for (var j=0; j<global_cpa.service[i].action.length; j++) {
			
			var actionName = global_cpa.service[i].action[j].name;
			var actionId = global_cpa.service[i].action[j].obid;
			
			if (actionId == selectedId) { 
				
				for (var k=0; k<global_cpa.service[i].action[j].dcrel.length; k++) {
					var delobid = global_cpa.service[i].action[j].dcrel[k].delivery_channel_obid;
					
					for(var m=0; m<global_cpa.delivery.length; m++) {
						if (global_cpa.delivery[m].obid == delobid) {
							$('deliveryChannel').options[k] = new Option(global_cpa.delivery[m].id,delobid);
							
							if (k==0) 
								$('deliveryChannel').options[k].selected = true;				
							
						}
					}
				}
			}
		}
	}
	getTransport();
}

function getTransport() {
	delobid = $('deliveryChannel').options[$('deliveryChannel').selectedIndex].value;
	
	for(var m=0; m<global_cpa.delivery.length; m++) {
		if (global_cpa.delivery[m].obid == delobid) {
			$('transportId').value = global_cpa.delivery[m].transport_obid;
			
			for(var i=0; i<global_cpa.transport.length; i++) {
				if (global_cpa.transport[i].obid == $('transportId').value) {
					for(var k=0; k<global_cpa.transport[i].endpoint.length; k++) {
						$('endpoint').value = global_cpa.transport[i].endpoint[k].uri;
						$('endpoint_comment').innerHTML = "<font color='#ffffff'>" 
							+ global_cpa.transport[i].endpoint[k].uri + "</font>";
					}
				}
			}
		}
	}
	
}

function sendMessage() {
    frm = document.form1;
	frm.action = "tst21ms001.jsp";
	frm.cpaIdVal.value = frm.cpaId.options[frm.cpaId.selectedIndex].text;
	frm.serviceVal.value = frm.service.options[frm.service.selectedIndex].text;
	frm.actionVal.value = frm.actionName.options[frm.actionName.selectedIndex].text;
	frm.fromPartyId.value = global_cpa.fromPartyId;
	frm.fromPartyIdType.value = global_cpa.fromPartyIdType;
	frm.toPartyId.value = global_cpa.toPartyId;
	frm.toPartyIdType.value = global_cpa.toPartyIdType;
	
	frm.deliveryId.value = frm.deliveryChannel.options[frm.deliveryChannel.selectedIndex].value;
	
	frm.submit();
}

function displayResult(originalRequest)
{
	res = eval("(" + originalRequest.responseText + ")");
	
	$('response_msg').innerHTML = res.result;
}

window.onload = initialize;
//-->
</script>
</head>
<body>
<!-- 제목테이블 -->
<table class="TableLayout">
  <tr> 
    <td width="180" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.tst.form")%></td>
    <td width="580" class="MessageDisplay" >&nbsp;<div id=messageDisplay></td>
  </tr>
  <tr> 
    <td colspan="2" height="10"></td>
  </tr>
</table>
<form name="form1" method="post" enctype="multipart/form-data">
<input type="hidden" name="command" id="command" value="send">
<input type="hidden" name="cpaIdVal" value="">
<input type="hidden" name="serviceVal" value="">
<input type="hidden" name="fromPartyId" id="fromPartyId" value="">
<input type="hidden" name="fromPartyIdType" id="fromPartyIdType" value="">
<input type="hidden" name="fromRole" id="fromRole" value="">
<input type="hidden" name="toPartyId" id="toPartyId" value="">
<input type="hidden" name="toPartyIdType" id="toPartyIdType" value="">
<input type="hidden" name="toRole" id="toRole" value="">
<input type="hidden" name="deliveryId" value="">
<input type="hidden" name="transportId" id="transportId" value="">
<input type="hidden" name="actionVal" id="actionVal" value="">

<!-- 상세정보 테이블-->
<table class="FieldTable">
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("menu.cpa") %></td>
    <td colspan="3" class="FieldData">
      <select name="cpaId" id="cpaId" onChange="getCpaDetail()" class="FormSelect" style="width:220;"></select>
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("global.service") %></td>
    <td colspan="3" class="FieldData">
      <select name="service" id="service" onChange="getAction()" class="FormSelect" style="width:220;"></select>
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("global.cpa.action.name") %></td>
    <td colspan="3" class="FieldData">
      <select name="actionName" id="actionName" onChange="getDeliveryChannel()" class="FormSelect" style="width:220;"></select>
    </td>
  </tr>
  <tr>
  <td width="120" class="FieldLabel"><%= _i18n.get("global.cpa.channel.name") %></td>
  <td colspan="3" class="FieldData">
    <select name="deliveryChannel" id="deliveryChannel" onChange="getTransport()" class="FormSelect" style="width:220;"></select>
    <input type="hidden" name="endpoint" id="endpoint" readonly size="50">
  </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("tst.body") %></td>
    <td colspan="3" class="FieldData">
	  <textarea name="body_content" id="body_content" cols="80" rows="10" ></textarea>
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("tst.attach.1") %></td>
    <td colspan="3" class="FieldData">
	  <input name="payload" id="payload" type="file" size=40 class="FormText">
    </td>
  </tr>
</table>  

<table width="650" border="0" cellspacing="0" cellpadding="0">
  <tr> 
	<td height="45" align="center" valign="bottom"><img src="images/send_b.gif"  align="absmiddle" onclick="javascript:sendMessage()"></td>
  </tr>
</table>
</form>
<div id="endpoint_comment"></div>
</body>
</html>
