<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.wsms.model.Wsdl" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%
/**
 * @author Ho-Jin Seo
 * @version 1.0
 */

String obid = request.getParameter("obid");

MxsEngine engine = MxsEngine.getInstance();
QueryCondition qc = new QueryCondition();
qc.add("obid", obid);
Wsdl wsdlVO = (Wsdl) engine.getObject("Wsdl", qc, DAOFactory.WSMS);

String wsdlType = (wsdlVO.getBeClient() == 1 ? "Client" : "Provider");


%>
<%@page import="kr.co.bizframe.mxs.wsms.WsConstants"%>
<html>
<head>
<%@ include file="./com00in000.jsp" %>
<%@ include file="./com00in003.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>
<script language="JavaScript" type="text/JavaScript">
<!--
function init() {
	var body = getHeader();
	body += '<tr>';
	body += '<td class="ResultData" colspan="6" align="center"><%=_i18n.get("global.processing") %></td>';
	body += '</tr>';
	body += '</table>';
	$('listContent').innerHTML = body;

	var params = 'obid=<%=obid%>';
	var opt = {
			method: 'get',
			parameters: params,
			asynchronous : false,
			onSuccess: showList,
		    on404: function(t) {
	        	$('messageDisplay').innerHTML = '<%=_i18n.get("err00zz404.message") %>';
	        //	showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
		    },
		    onFailure: function(t) {
	        	$('messageDisplay').innerHTML = '<%=_i18n.get("global.error.retry") %>';
	        //	showErrorPopup(t.responseText, null, null, null);
		    }
		}
	var myAjax = new Ajax.Request( './msi20ac902.jsp', opt);
}

function appTypeChange(obj) {
    var val = obj.options[obj.selectedIndex].value;
    if (val=="<%=WsConstants.REMOTE_PERFORMER%>") {
    	alert("<%=_i18n.get("msi20ms902.alert.msg")%>");
    }

}

function showList(originalRequest)
{
	var res = eval("(" + originalRequest.responseText + ")");

	var operations = "";
	var performers = "";
	var body = "";
	body = getHeader();
	var num = 0;

	for (var i=0; i<res.wsdl.service.length; i++) {
		row = 0;
		var serviceName = res.wsdl.service[i].name;
		for (var j=0; j<res.wsdl.service[i].binding.length; j++) {
			for (var k=0; k<res.wsdl.service[i].binding[j].operation.length; k++) {
				body += "<tr>";
				if (k==0 ) {
					body += '<td class="ResultData" rowspan="'
						+ res.wsdl.service[i].binding[j].operation.length + '">' + serviceName + '</td>';
				}

				var opId = res.wsdl.service[i].binding[j].operation[k].id;
				var opName = res.wsdl.service[i].binding[j].operation[k].name;
				var opPerformer = res.wsdl.service[i].binding[j].operation[k].performer;
				var opPerformerType = res.wsdl.service[i].binding[j].operation[k].performerType;
				var localPerformer = " selected";
				var remotePerformer = " ";
				if (opPerformerType == "<%=WsConstants.REMOTE_PERFORMER%>") {
					localPerformer = "";
					remotePerformer = " selected";
				}

				if (opPerformer == null) {
				    opPerformer = "";
					localPerformer = "";
					remotePerformer = "";
				}

				body += '<td class="ResultData">' + opName + '</td>';
		        body += ' <td class="ResultData">';
		        body += '         <select id="performerType' + num + '" name="performerType' + num + '" class="FormSelect"  onChange="javascript:appTypeChange(this)">';
		        body += '            <option value = "<%=WsConstants.LOCAL_PERFORMER %>"'+localPerformer +'><%=_i18n.get("msi20ms902.performer.type.local")%></option>';
		        body += '            <option value = "<%=WsConstants.REMOTE_PERFORMER %>"'+remotePerformer +'><%=_i18n.get("msi20ms902.performer.type.remote")%> </option>';
		        body += '         </select>';
		        body += '</td>';
				body += '<td class="ResultLastData"><input type="text" id="performerName' + num + '" name="performerName' + num + '" value="' + opPerformer + '" size=50 class="FormText">&nbsp;';
				body += '<input type="hidden" id="operationId' + num + '" name="operationId' + num + '" value="' + opId + '">';
				body += '<a href="javascript:updatePerformer(' + num + ')"><img src="images/btn_update.gif" border="0" align="absmiddle"></a>';
				body += '</td>';
				num++;

				body += '</tr>';
			}
		}
	}

    if (num == 0) {
        body += '<tr><td align="center" class="ResultLastData" colspan="4"><%= _i18n.get("msi20ms002.notfound")%></td></tr>';
    }
	body += "</table>";
	body += '<input type="hidden" name="idx_count" value="' + num + '">';
	$('listContent').innerHTML = body;

}

function getHeader() {
	var body = "";
	body += '<table class="TableLayout" >';
	body += '  <tr> ';
	body += '    <td class="ResultHeader"><%=_i18n.get("msi20ms902.colhead.1")%></td>';
	body += '    <td class="ResultHeader"><%=_i18n.get("msi20ms902.colhead.2")%></td>';
	body += '    <td class="ResultHeader"><%=_i18n.get("msi20ms902.colhead.4")%></td>';
	body += '    <td class="ResultLastHeader"><%=_i18n.get("msi20ms902.colhead.3")%></td>';
	body += '  </tr>';
	return body;
}

function updatePerformer(num) {
	clearNotify();

	var performerClass = $('performerName' + num).value;
	var performerType = $('performerType' + num).value;
	var operationId = $('operationId' + num).value;
	var wsdlName = $('wsdlName').value;
	openInfo('<%=_i18n.get("global.processing") %>');
	var param = "obid="+operationId + "&performerClass=" + performerClass+"&wsdlName=" + wsdlName + "&type=" + performerType;
	var opt = {
	    method: 'post',
	    postBody: param,
	    onSuccess: function(t) {
	    	closeInfo();
	    	$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("msi20ms902.operation.update") %>';
	        //timeout=2; setTimeout(infoTimeout, 1000);
	        //openInfo('<%=_i18n.get("msi20ms902.operation.update") %>');
	    },
	    on404: function(t) {
	    	closeInfo();
	        $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("err00zz404.message") %>';
	        //showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
	    },
	    onFailure: function(t) {
	    	closeInfo();
	        $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("global.error.retry") %>';
	        //showErrorPopup(t.responseText, null, null, null);
	    }
	}

	var myAjax = new Ajax.Request('./msi30ac901.jsp', opt);
}

function updateAll() {
	clearNotify();

	var params = Form.serialize(document.form1);

	openInfo('<%=_i18n.get("global.processing") %>');
	var opt = {
	    method: 'post',
	    postBody: params,
	    onSuccess: function(t) {
	    	closeInfo();
	    	$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("msi20ms902.operation.update") %>';
	    },
	    on404: function(t) {
	    	closeInfo();
	        $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("err00zz404.message") %>';
	        //showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
	    },
	    onFailure: function(t) {
	    	closeInfo();
	        $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("global.error.retry") %>';
	        //showErrorPopup(t.responseText, null, null, null);
	    }
	}

	var myAjax = new Ajax.Request('./msi30ac901.jsp', opt);
}
function goList() {
	history.go(-1);
}
window.onload=init;

//-->
</script>
</head>
<body>
<!-- 제목테이블 -->
<table class="TableLayout">
  <tr>
    <td width="160" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.msi.setting")%></td>
    <td width="600" class="MessageDisplay"><div id=messageDisplay></div></td>
  </tr>
  <tr>
    <td colspan="2" height="6"></td>
  </tr>
</table>
<!--SelectTable 시작 -->
<form name="form1" method="post" >
<input type="hidden" name="obid" value="<%= obid %>">
<input type="hidden" name="wsdlName" value="<%= wsdlVO.getName() %>">
<!-- 등록테이블-->
<table class="FieldTable">
        <tr>
          <td width="120" class="FieldLabel"><%=_i18n.get("global.wsdl.name")%></td>
          <td width="260" class="FieldData">
		  <input name="text22" type="text" class="FormTextReadOnly" readonly value="<%= wsdlVO.getName() %>" size="32">
          </td>
          <td width="120" class="FieldLabel"><%=_i18n.get("global.wsdl.type")%></td>
          <td width="260" class="FieldData">
            <input name="textfield22222" type="text" class="FormTextReadOnly" readonly value="<%= wsdlType %>" size="32">
          </td>
        </tr>
</table>
<br>
<!-- 결과 목록 테이블 코드 시작-->
<div id="listContent"></div>
<!-- 버튼테이블 -->
<table class="TableLayout" >
  <tr>
    <td align="right" style="padding-top:15"><a href="javascript:goList()"><img src="images/btn_big_list.gif" width="39" height="23" border="0"></a>
       <a href="javascript:updateAll()"><img src="images/btn_big_save.gif" width="39" height="23" border="0"></a>
    </td>
  </tr>
</table>
</form>
</body>
</html>
