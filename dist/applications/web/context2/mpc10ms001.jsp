<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%
/**
 * Register MPC
 *
 * @author Mi-Young Kim
 * @version 1.0 2008.10.01
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
   document.form1.policy[0].checked = true;
   $('messageDisplay').innerHTML = '';
}

function enterDown(){
  var checkNameBtnStr = '<a href="javascript:nameCheck(this.form)"><img src="images/btn_checkunique.gif" width="59" height="20" align="absmiddle" border="0"></a>';
  checkNameBtnStr += '&nbsp; <font color="red"><%=_i18n.get("global.duplication.check") %></font>';
  if (this.document.getElementById('displayName').readOnly == false
  		&& $('checkNameBtnDisplay').innerHTML != checkNameBtnStr) {
	  $('checkNameBtnDisplay').innerHTML = checkNameBtnStr;
	  this.document.getElementById('nameCheckFlag').value = "0";
  }
}

function insertMpc() {
	var nowDisplayName = this.document.getElementById('displayName').value;
	if (nowDisplayName == "") {
      $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("mpc10ms002.name.empty") %>';
      //alert('<%=_i18n.get("mpc10ms002.name.empty") %>');
      return;
	}

    if (this.document.getElementById('nameCheckFlag').value == "0") {
      $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("mpc10ms002.name.inform") %>';
      //alert('<%=_i18n.get("mpc10ms002.name.inform") %>');
      return;
    }

	if (this.document.getElementById('uri').value == "") {
      $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("mpc10ms002.uri.empty") %>';
      //alert('<%=_i18n.get("mpc10ms002.uri.empty") %>');
      return;
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
	    	    var msg = '<img src="images/bu_query.gif" align="absmiddle" > ' + res.msg;
		    	$('messageDisplay').innerHTML = msg;
	    	} else {
				Dialog.setInfoMessage('<%=_i18n.get("mpc21ms002.operation.insert") %>');
		    	timeout=2; setTimeout(goList, 1000);
	    	}
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

	var myAjax = new Ajax.Request('./mpc10ac001.jsp', opt);
}

function nameCheck() {
   $('messageDisplay').innerHTML = '';
   check_name = this.document.getElementById('displayName').value;

   if(check_name == null || check_name == '') {
      $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("mpc21ms001.msg.displayNullConfirm") %>';
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
   var checkNameBtnStr = '<a href="javascript:nameCheck(this.form)"><img src="images/btn_checkunique.gif" width="59" height="20" align="absmiddle" border="0"></a>';
   if(result == 'true') {
      this.document.getElementById('nameCheckFlag').value = "1";
      $('messageDisplay').innerHTML ='<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("mpc10ms002.name.use") %>';
      //alert('<%=_i18n.get("mpc10ms002.name.use") %>');
   } else {
      $('messageDisplay').innerHTML ='<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("mpc10ms002.name.nouse") %>';
      //alert('<%=_i18n.get("mpc10ms002.name.nouse") %>');
      checkNameBtnStr += '&nbsp; <font color="red"><%=_i18n.get("global.duplication.check") %></font>';
   }
   $('checkNameBtnDisplay').innerHTML = checkNameBtnStr;
}

function loading() {
   $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%= _i18n.get("global.loading")%>';
}

function goList() {
	timeout--;
	if (timeout >0) {
		setTimeout(goList, 1000) ;
	} else {
		location.href= "mpc20ms001.jsp";
	}
}

window.onload = initialize;
//-->
</script>
</head>
<body bgcolor=#FFFFFF leftmargin=0 topmargin=0 marginwidth=0 marginheight=0>

<!-- 검색 Form 시작 ... -->
<form name="form1" method="POST">
<input type="hidden" name="nameCheckFlag" id="nameCheckFlag" value = "0">
<!-- 제목테이블 -->
<table class="TableLayout" border=0>
  <tr>
    <td width="200" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.mpc.localmpc.view")%></td>
    <td width="560" class="MessageDisplay"><div id="messageDisplay"></div></td>
  </tr>
  <tr>
    <td colspan="2" height="10"></td>
  </tr>
</table>

<!-- 상세정보 테이블-->
<table class="FieldTable">
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("mpc20ms001.column.displayname") %></td>
    <td colspan="3" class="FieldData">
    	<table style= "border:0;   padding:0;   margin-left:0px;  border-collapse:collapse ;">
    		<tr>
    			<td><input type="text" name="displayName" id="displayName" onKeyDown="javascript:enterDown();" value="" size="50"' class="FormText"></td>
    			<td><div id="checkNameBtnDisplay"></div></td>
    		</tr>
    	</table>
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("mpc20ms001.column.uri") %></td>
    <td colspan="3" class="FieldData">
      <input type="text" name="uri" id="uri" class="FormText" value="" size="90">
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("mpc20ms001.column.status") %></td>
    <td width="260" class="FieldData">
      <input type="radio" name="status" id="status" value="1" ><%= _i18n.get("mpc20ms001.str.active") %>&nbsp;&nbsp;
      <input type="radio" name="status" id="status" value="0" ><%= _i18n.get("mpc20ms001.str.inactive") %>&nbsp;&nbsp;
    </td>
    <td width="120" class="FieldLabel"><%= _i18n.get("mpc21ms001.column.wssauth") %></td>
    <td width="260" class="FieldData">
     <input type="radio" name="wssauth" id="wssauth" value="1"><%= _i18n.get("mpc21ms001.str.usewssauth") %>&nbsp;&nbsp;
     <input type="radio" name="wssauth" id="wssauth" value="0"><%= _i18n.get("mpc21ms001.str.notusewssauth") %>&nbsp;&nbsp;
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("mpc21ms001.column.policy") %></td>
    <td colspan="3" class="FieldData">
     <input type="radio" name="policy" id="policy" value="0" ><%= _i18n.get("mpc21ms001.str.FIFO") %>&nbsp;&nbsp;
     <input type="radio" name="policy" id="policy" value="1" ><%= _i18n.get("mpc21ms001.str.LIFO") %>&nbsp;&nbsp;
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("mpc20ms001.column.desc") %></td>
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
      <a href="mpc20ms001.jsp"><img src="images/btn_big_list.gif" width="39" height="23" border="0"></a>
      <a href="javascript:insertMpc();"><img src="images/btn_big_create.gif" width="39" height="23" border="0"></a>
    </td>
  </tr>
</table>

</form>
</body>
</html>
