<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%
/**
 * ebMS Test Page
 *
 * @author Mi-Young Kim
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
	var myAjax = new Ajax.Request( './tst20ac003.jsp', opt);

}

function displayCpaDetail(originalRequest)
{   
	global_cpa = eval("(" + originalRequest.responseText + ")");
	getService();	
}
function getService() {
	$('service').length = 0;
	for (var i=0; i<global_cpa.list.length; i++) {
		var serviceName = global_cpa.list[i].service;
		$('service').options[i] = new Option(serviceName,global_cpa.list[i].sb_obid);
		if (i==0) 
			$('service').options[i].selected = true;
	}
	getAction();

}

function getAction() {
	$('actionName').length = 0;
	
	selectedId = $('service').options[$('service').selectedIndex].value;
	for (var i=0; i<global_cpa.list.length; i++) {
		row = 0;
		var serviceName = global_cpa.list[i].service;
		var serviceId = global_cpa.list[i].sb_obid;
		if (serviceId == selectedId) { 
			for (var j=0; j<global_cpa.list[i].action.length; j++) {
				var actionName = global_cpa.list[i].action[j].name;
				var actionId = global_cpa.list[i].action[j].obid;
				$('actionName').options[j] = new Option(actionName,actionName);
				if (i==0) 
					$('actionName').options[i].selected = true;				
			}
		}		
	}
}

function getDelivery() {
	$('delName').length = 0;
	selectedId = $('actionName').options[$('actionName').selectedIndex].value;
	for (var i=0; i<global_cpa.list.length; i++) {
		row = 0;
		var serviceName = global_cpa.list[i].service;
		var serviceId = global_cpa.list[i].sb_obid;
		if (serviceId == selectedId) { 
			for (var j=0; j<global_cpa.list[i].action.length; j++) {
				var actionName = global_cpa.list[i].action[j].name;
				var actionId = global_cpa.list[i].action[j].obid;
				$('actionName').options[j] = new Option(actionName,actionName);
				if (i==0) 
					$('actionName').options[i].selected = true;				
			}
		}		
	}
	
}

function sendMessage() {
    frm = document.form1;
	frm.action = "tst21ms001.jsp";
	frm.cpaIdVal.value = frm.cpaId.options[frm.cpaId.selectedIndex].text;
	frm.serviceVal.value = frm.service.options[frm.service.selectedIndex].text;
	
	frm.fromPartyId.value = global_cpa.fromPartyId;
	frm.fromPartyIdType.value = global_cpa.fromPartyIdType;
	frm.toPartyId.value = global_cpa.toPartyId;
	frm.toPartyIdType.value = global_cpa.toPartyIdType;
	
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
<input type="hidden" name="fromPartyId" value="">
<input type="hidden" name="fromPartyIdType" value="">
<input type="hidden" name="toPartyId" value="">
<input type="hidden" name="toPartyIdType" value="">
<input type="hidden" name="deliveryChannel" value="">

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
      <select name="service" id="service" onChange="getOperation()" class="FormSelect" style="width:220;"></select>
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("global.cpa.action.name") %></td>
    <td colspan="3" class="FieldData">
      <select name="actionName" id="actionName" onChange="getDelivery()" class="FormSelect" style="width:220;"></select>
    </td>
  </tr>
  <tr>
  <td width="120" class="FieldLabel"><%= _i18n.get("global.cpa.action.name") %></td>
  <td colspan="3" class="FieldData">
    <select name="delName" id="delName" class="FormSelect" style="width:220;"></select>
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
</body>
</html>
