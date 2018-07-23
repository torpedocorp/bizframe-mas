<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsConstants" %>
<%
/**
 * Rmoete MPC Detail
 *
 * @author Ho-Jin Seo
 * @version 1.0 2008.09.29
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

	getMpcInfo();
}

function convertCharacter(str) {
   var result = '';
   for(i=0; i<str.length; i++) {
      var ch = str.charAt(i);
      if(ch == '<') result += '&lt;';
      else if(ch == '>') result += '&gt;';
      else result += ch;
   }

   return result;
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

function getMpcInfo() {
   loading();
   var params = Form.serialize(document.form1);
   var opt = {
      method: 'post',
      parameters: params,
      onSuccess: show,
       on404: function(t) {
           $('messageDisplay').innerHTML = '<%=_i18n.get("err00zz404.message") %>';
           showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
       },
       onFailure: function(t) {
           $('messageDisplay').innerHTML = '<%=_i18n.get("global.error.retry") %>';
           showErrorPopup(t.responseText, null, null, null);
       }
   }
   var myAjax = new Ajax.Request("mpc21ac002.jsp", opt);
}

function show(originalRequest) {
   var res = eval("(" + originalRequest.responseText + ")");

   $('obid').value = res.obid;
   $('uri').value = res.uri;
   $('displayName').value = res.displayName;
   $('currentName').value = res.displayName;
   $('dupname').value = res.displayName;
   $('dupflag_result').value = "true";
   if (res.status == "1") {
	   document.form1.status[0].checked = true;
   } else if(res.status == "0") {
	   document.form1.status[1].checked = true;
   }
   if (res.wssauth == "1") {
   	  document.form1.wssauth[0].checked = true;
   } else if(res.wssauth == "0") {
	  document.form1.wssauth[1].checked = true;
   }
   $('priority').value = res.priority;
   $('interval').value = res.interval;
   $('desc').value = res.desc;
   $('agreementRefCnt').value = res.agreementRefCnt + ' <%= _i18n.get("global.rows") %>';
   $('wssUserCnt').value = res.wssuserCnt + ' <%= _i18n.get("global.person") %>';
   $('messageDisplay').innerHTML = '';

   if (res.interval == 0) {
      $('usedemon').checked = false;
   } else {
      $('usedemon').checked = true;
   }

   if (res.isDefault == 1) {
      $('is_default').checked = true;
   } else {
      $('is_default').checked = false;
   }

   checkInterval();
}

function updateMpc() {
	Windows.closeAllModalWindows();
	clearNotify();

    if($('displayName').value == "") {
       alert("<%=_i18n.get("mpc10ms002.name.empty")%>");
       return;
    }

	if ($('currentName').value == $('displayName').value) {
	} else if ($('dupname').value == $('displayName').value && $('dupflag_result').value == "true") {
	} else {
        alert('<%=_i18n.get("mpc10ms002.name.inform")%>');
        return;
     }

    if($('uri').value == "") {
       alert("<%=_i18n.get("mpc10ms002.uri.empty")%>");
       return;
    }

	var params = Form.serialize(document.form1);

	//openInfo('<%=_i18n.get("global.processing") %>');
	var opt = {
	    method: 'post',
	    postBody: params,
	    onSuccess: function(t) {
	    	closeInfo();
	    	$('currentName').value = $('displayName').value;
	    	$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("mpc21ms002.operation.update") %>';
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

	var myAjax = new Ajax.Request('./mpc30ac002.jsp', opt);
}

function loading() {
   $('messageDisplay').innerHTML = '<%= _i18n.get("global.loading")%>';
}

function viewPullRecvMessage() {
    var uri = $('uri').value;
    window.open("msg20pu303.jsp?uri=" + uri, "View", "width=830,height=500,left=0,top=0,resizable=yes,scrollbars=yes");
}

function viewAgreementRef() {
    var obid = $('obid').value;
    window.open("agr20pu001.jsp?mpcObid=" + obid, "View", "width=830,height=500,left=0,top=0,resizable=yes,scrollbars=yes");
}

function viewWssUser() {
    var obid = this.document.getElementById('obid').value;
    window.open("wsu20pu002.jsp?mpcObid=" + obid, "View", "width=830,height=500,left=0,top=0,resizable=yes,scrollbars=yes");
}

function checkInterval() {
	if ($('usedemon').checked == true) {
		$('interval').disabled = false;
	} else {
		$('interval').disabled = true;
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

/*
// onKeyPress="numCheck()"
function numCheck() {
    event.returnValue=false;
    if (event.keyCode == 8) event.returnValue=true;
    if (event.keyCode >= 48 && event.keyCode <= 57) event.returnValue=true;
}
*/

function viewAgreementRef() {
    var uri = $('obid').value;
    window.open("agr20pu001.jsp?mpcObid=" + uri, "View", "width=830,height=500,left=0,top=0,resizable=yes,scrollbars=yes");
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
    <td width="200" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.mpc.remotempc.view")%></td>
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
     <input type="checkbox" name="is_default" id="is_default" onClick="setDefaultMpc()" value="1">
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
<!-- MPC에 관련된 정보보기 -->
<table class="FieldTable">
  <tr>
    <td class="FieldLabel" width=250><%=_i18n.get("mpc21ms001.column.agreementRefCnt")%></td>
    <td colspan="3" class="FieldData">
    	<input type="text" name="agreementRefCnt" id="agreementRefCnt" readonly value="" style='border: 0px  solid  #7F9DB9;  font-size:8pt;  font-family:"arial", "돋움";  color:#666666;  width:30; height:20;'>
        <a href="javascript:viewAgreementRef();"><img src="images/btn_inview.gif" width="39" height="13" align="absmiddle" border="0"></a>
    </td>
  </tr>
  <tr>
    <td class="FieldLabel" width=250><%=_i18n.get("mpc21ms002.column.pullrecvList")%></td>
    <td colspan="3" class="FieldData">
    <input type="text" readonly style='border: 0px  solid  #7F9DB9;  font-size:8pt;  font-family:"arial", "돋움";  color:#666666;  width:30; height:20;'>
    <a href="javascript:viewPullRecvMessage();"><img src="images/btn_inview.gif" width="39" height="13" align="absmiddle" border="0"></a>
    </td>
  </tr>
  <tr>
    <td class="FieldLabel" width=250><%=_i18n.get("mpc21ms001.column.wssuserCnt")%></td>
    <td colspan="3" class="FieldData">
    <input type="text" name="wssUserCnt" id="wssUserCnt" readonly style='border: 0px  solid  #7F9DB9;  font-size:8pt;  font-family:"arial", "돋움";  color:#666666;  width:30; height:20;'>
    <a href="javascript:viewWssUser();"><img src="images/btn_inview.gif" width="39" height="13" align="absmiddle" border="0"></a>
    </td>
  </tr>
</table>

<br>
<!-- 버튼테이블 -->
<table class="TableLayout" >
  <tr>
    <td align="right" style="padding-top:15">
      <a href="mpc20ms002.jsp"><img src="images/btn_big_list.gif" width="39" height="23" border="0"></a>
      <a href="javascript:updateMpc();"><img src="images/btn_big_change.gif" width="39" height="23" border="0"></a>
    </td>
  </tr>
</table>

</form>
</body>
</html>
