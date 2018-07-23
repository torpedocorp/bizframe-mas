<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsConstants" %>
<%
/**
 * Rmoete MPC Registration
 *
 * @author Ho-Jin Seo
 * @version 1.0 2008.09.30
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
function initialize() {
   document.form1.status[0].checked = true;
   document.form1.wssauth[0].checked = true;
   $('interval').value = "0";
   $('usedemon').checked = false;
   $('is_default').checked = false;

   checkInterval();

   $('messageDisplay').innerHTML = '';
}

function showNotice(){
	if ($('currentName').value == $('displayName').value) {
	    $('dup_notice').innerHTML = '';
	} else if ($('dupname').value == $('displayName').value && $('dupflag_result').value == "true") {
	    $('dup_notice').innerHTML = '';
    } else {
       $('dup_notice').innerHTML = '<a href="javascript:nameCheck()"><img src="images/btn_checkunique.gif" width="59" height="20" align="absmiddle" border="0"></a>';
       $('dup_notice').innerHTML += '&nbsp;<font color="red"><%= _i18n.get("global.duplication.check")%></font>';
    }
}

function nameCheck() {

	$('messageDisplay').innerHTML = '';

	check_name = $('displayName').value;

	if(check_name == null || check_name == '') {
		//$('messageDisplay').innerHTML = '<%=_i18n.get("mpc10ms002.name.empty") %>';
		alert('<%=_i18n.get("mpc10ms002.name.empty") %>');
		return;
	}

	var params = Form.serialize(document.form1);
	var opt = {
		method: 'post',
		parameters: params,
		asynchronous: false,
		onSuccess: function(t) {
			var res = eval("(" + t.responseText + ")");
			dupCheckResult(res.name, res.can_use);
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
	var myAjax = new Ajax.Request("./mpc20ac003.jsp", opt);
}

function dupCheckResult(check_name, result) {
   $('dupname').value = check_name;
   $('dupflag_result').value = result;

   if(result == 'true') {
      //$('messageDisplay').innerHTML ='<%=_i18n.get("mpc10ms002.name.use") %>';
      alert('<%=_i18n.get("mpc10ms002.name.use") %>');
      $('dup_notice').innerHTML = '';

      return true;
   }
   else {
      //$('messageDisplay').innerHTML ='<%=_i18n.get("mpc10ms002.name.nouse") %>';
      alert('<%=_i18n.get("mpc10ms002.name.nouse") %>');
      $('dup_notice').innerHTML = '<a href="javascript:nameCheck()"><img src="images/btn_checkunique.gif" width="59" height="20" align="absmiddle" border="0"></a>';
      $('dup_notice').innerHTML += '&nbsp;<font color="red"><%= _i18n.get("global.duplication.check")%></font>';
      return false;
   }
}

function insertMpc() {
	Windows.closeAllModalWindows();
	clearNotify();

    if($('displayName').value == "") {
       alert("<%=_i18n.get("mpc10ms002.name.empty")%>");
       return;
    }

    if ($('dupname').value != $('displayName').value || $('dupflag_result').value != 'true') {
        alert('<%=_i18n.get("mpc10ms002.name.inform")%>');
        return;
     }

    if($('uri').value == "") {
       alert("<%=_i18n.get("mpc10ms002.uri.empty")%>");
       return;
    }

	var params = Form.serialize(document.form1);

	openInfo('<%=_i18n.get("global.processing") %>');
	var opt = {
	    method: 'post',
	    postBody: params,
	    onSuccess: function(t) {
	    	closeInfo();
	    	$('currentName').value = $('displayName').value;
	    	$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("mpc21ms002.operation.insert") %>';
	    	Dialog.setInfoMessage('<%=_i18n.get("mpc21ms002.operation.insert") %>');
	    	timeout=2; setTimeout(goList, 1000);
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

	var myAjax = new Ajax.Request('./mpc10ac002.jsp', opt);
}

function loading() {
   $('messageDisplay').innerHTML = '<%= _i18n.get("global.loading")%>';
}

function checkInterval() {
	if ($('usedemon').checked == true) {
		$('interval').disabled = false;
	} else {
		$('interval').disabled = true;
	}
}

function goList() {
	timeout--;
	if (timeout >0) {
		setTimeout(goList, 1000) ;
	} else {
		history.go(-1);
	}
}

function setDefaultMpc() {
	if ($('is_default').checked == true) {
		$('uri').value = "<%= MxsConstants.DEFAULT_MPC %>";
		$('uri').disabled = true;
	} else {
		$('uri').value = "";
		$('uri').disabled = false;
	}
}

window.onload = initialize;
//-->
</script>
</head>
<body bgcolor=#FFFFFF leftmargin=0 topmargin=0 marginwidth=0 marginheight=0>

<!-- 검색 Form 시작 ... -->
<form name="form1" method="POST">
<input type="hidden" name="obid" id="obid" value="<%=request.getParameter("obid")%>">
<input type="hidden" name="currentName" id="currentName">
<!-- 제목테이블 -->
<table class="TableLayout" border=0>
  <tr>
    <td width="200" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.mpc.remotempc.register")%></td>
    <td width="560" class="MessageDisplay"><div id="messageDisplay"></div></td>
  </tr>
  <tr>
    <td colspan="2" height="10"></td>
  </tr>
</table>

<!-- 상세정보 테이블-->
<table class="FieldTable">
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("mpc20ms002.column.displayname") %></td>
    <td colspan="3" class="FieldData">
    	<table style= "border:0;   padding:0;   margin-left:0px;  border-collapse:collapse ;">
    		<tr>
    			<td><input type="text" name="displayName" id="displayName" onKeyUp="javascript:showNotice();" value="" size="50"' class="FormText">
                <span id="dup_notice"></span>
                <input type="hidden" id="dupname"  value="">
                <input type="hidden" id="dupflag_result"  value="">
    			</td>
    		</tr>
    	</table>
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("mpc20ms002.column.uri") %></td>
    <td colspan="3" class="FieldData">
      <input type="text" name="uri" id="uri" class="FormText" value="" size="90">
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("mpc20ms002.column.status") %></td>
    <td width="260" class="FieldData">
      <input type="radio" name="status" id="status" value="1" ><%= _i18n.get("mpc20ms002.str.active") %>&nbsp;&nbsp;
      <input type="radio" name="status" id="status" value="0" ><%= _i18n.get("mpc20ms002.str.inactive") %>&nbsp;&nbsp;
    </td>
    <td width="120" class="FieldLabel"><%= _i18n.get("mpc21ms002.column.wssauth") %></td>
    <td width="260" class="FieldData">
     <input type="radio" name="wssauth" id="wssauth" value="1" ><%= _i18n.get("mpc21ms002.str.usewssauth") %>&nbsp;&nbsp;
     <input type="radio" name="wssauth" id="wssauth" value="0" ><%= _i18n.get("mpc21ms002.str.notusewssauth") %>&nbsp;&nbsp;
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("mpc21ms002.column.priority") %></td>
    <td width="260" class="FieldData">
      <select name="priority" id="priority" class="FormSelect" style="width:60;">
        <option value="9">9</option>
        <option value="8">8</option>
        <option value="7">7</option>
        <option value="6">6</option>
        <option value="5">5</option>
        <option value="4">4</option>
        <option value="3">3</option>
        <option value="2">2</option>
        <option value="1">1</option>
      </select>
    </td>
    <td width="120" class="FieldLabel"><%= _i18n.get("mpc21ms002.column.default") %></td>
    <td width="260" class="FieldData">
     <input type="checkbox" name="is_default" id="is_default" value="1" onClick="setDefaultMpc()">
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("mpc21ms002.column.usedemon") %></td>
    <td width="260" class="FieldData">
     <input type="checkbox" name="usedemon" id="usedemon" onClick="checkInterval()" value="1"><%= _i18n.get("global.use") %>
    </td>
    <td width="120" class="FieldLabel"><%= _i18n.get("mpc21ms002.column.interval") %></td>
    <td class="FieldData">
      <input type="text" name="interval" id="interval" size="4"><%= _i18n.get("mpc21ms002.column.second") %>
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("mpc20ms002.column.desc") %></td>
    <td colspan="3" class="FieldData">
      <input type="text" name="desc" id="desc" value="" size="90" class="FormText">
    </td>
  </tr>
</table>

<br>
<!-- 버튼테이블 -->
<table class="TableLayout" >
  <tr>
    <td align="right" style="padding-top:15">
      <a href="mpc20ms002.jsp"><img src="images/btn_big_list.gif" width="39" height="23" border="0"></a>
      <a href="javascript:insertMpc();"><img src="images/btn_big_create.gif" width="39" height="23" border="0"></a>
    </td>
  </tr>
</table>

</form>
</body>
</html>
