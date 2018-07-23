<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%
/**
 * Detail MPC
 *
 * @author Mi-Young Kim
 * @version 1.0 2008.09.25
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
function enterDown(){
  var checkNameBtnStr = '<a href="javascript:nameCheck(this.form)"><img src="images/btn_checkunique.gif" width="59" height="20" align="absmiddle" border="0"></a>';
  checkNameBtnStr += '&nbsp; <font color="red"><%=_i18n.get("global.duplication.check") %></font>';
  if (this.document.getElementById('displayName').readOnly == false
  		&& $('checkNameBtnDisplay').innerHTML != checkNameBtnStr) {
	  $('checkNameBtnDisplay').innerHTML = checkNameBtnStr;
	  this.document.getElementById('nameCheckFlag').value = "0";
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
   var myAjax = new Ajax.Request("mpc21ac001.jsp", opt);
}

function changeReadOnly(id) {
	var inputType = this.document.getElementById(id).type;
	if (inputType == 'radio') {
		this.document.getElementById(id).disabled = true;
	} else if (inputType == 'text') {
		this.document.getElementById(id).className = "FormTextReadOnly";
		this.document.getElementById(id).readOnly = true;
	}
}

function show(originalRequest) {
   var res = eval("(" + originalRequest.responseText + ")");

   this.document.getElementById('obid').value = res.obid;
   this.document.getElementById('uri').value = res.uri;
   this.document.getElementById('displayName').value = res.displayName;
   $('oldDisplayName').value = res.displayName;
   this.document.getElementById('isDefault').value = res.isDefault;

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
   if (res.policy == "1") {
   		document.form1.policy[1].checked = true;
   } else if(res.policy == "0") {
	   document.form1.policy[0].checked = true;
   }
   this.document.getElementById('desc').value = res.desc;
   this.document.getElementById('agreementRefCnt').value = res.agreementRefCnt + ' <%= _i18n.get("global.rows") %>';
   this.document.getElementById('pullwaitingCnt').value = res.pullwaitingCnt + ' <%= _i18n.get("global.rows") %>';
   this.document.getElementById('wssUserCnt').value = res.wssuserCnt + ' <%= _i18n.get("global.person") %>';

   if (res.isDefault == "1") {
	   $('messageDisplay').innerHTML = '<%=_i18n.get("mpc21ms001.msg.Default") %>';
	   changeReadOnly('displayName');
	   changeReadOnly('uri');
	   changeReadOnly('use_wssauth');
	   changeReadOnly('nouse_wssauth');
   } else {
	   $('messageDisplay').innerHTML = '';
   }
}

function updateMpc() {
	var nowDisplayName = this.document.getElementById('displayName').value;
	var oldDisplayName = this.document.getElementById('oldDisplayName').value;
	if (nowDisplayName == "") {
      $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("mpc10ms002.name.empty") %>';
      //alert('<%=_i18n.get("mpc10ms002.name.empty") %>');
      return;
	}

    if (nowDisplayName != oldDisplayName && this.document.getElementById('nameCheckFlag').value == "0") {
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
	    	var msg = '<img src="images/bu_query.gif" align="absmiddle" > ' + res.msg;
	    	$('messageDisplay').innerHTML = msg;
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

	var myAjax = new Ajax.Request('./mpc30ac001.jsp', opt);
}

function nameCheck() {
   $('messageDisplay').innerHTML = '';
   check_name = this.document.getElementById('displayName').value;

   if(check_name == null || check_name == '') {
      $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("mpc10ms002.name.empty") %>';
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

function viewPullWaitMessage() {
    var uri = this.document.getElementById('uri').value;
	window.open("msg20pu301.jsp?uri=" + uri, "View", "width=830,height=500,left=0,top=0,resizable=yes,scrollbars=yes");
}

function viewPullSentMessage() {
    var uri = this.document.getElementById('uri').value;
    window.open("msg20pu302.jsp?uri=" + uri, "View", "width=830,height=500,left=0,top=0,resizable=yes,scrollbars=yes");
}

function viewAgreementRef() {
    var obid = this.document.getElementById('obid').value;
    window.open("agr20pu001.jsp?mpcObid=" + obid, "View", "width=830,height=500,left=0,top=0,resizable=yes,scrollbars=yes");
}

function viewWssUser() {
    var obid = this.document.getElementById('obid').value;
    window.open("wsu20pu002.jsp?mpcObid=" + obid, "View", "width=830,height=500,left=0,top=0,resizable=yes,scrollbars=yes");
}

//-->
</script>
</head>
<body bgcolor=#FFFFFF leftmargin=0 topmargin=0 marginwidth=0 marginheight=0>

<!-- 검색 Form 시작 ... -->
<form name="form1" method="POST">
<input type="hidden" name="obid" id="obid" value="<%=request.getParameter("obid")%>">
<input type="hidden" name="nameCheckFlag" id="nameCheckFlag" value = "0">
<input type="hidden" name="oldDisplayName" id="oldDisplayName" value="">
<input type="hidden" name="isDefault" id="isDefault" value ="">

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
     <input type="radio" name="wssauth" id="use_wssauth" value="1"><%= _i18n.get("mpc21ms001.str.usewssauth") %>&nbsp;&nbsp;
     <input type="radio" name="wssauth" id="nouse_wssauth" value="0"><%= _i18n.get("mpc21ms001.str.notusewssauth") %>&nbsp;&nbsp;
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
    <td class="FieldLabel" width=250><%=_i18n.get("mpc21ms001.column.pullwaitingCnt")%></td>
    <td colspan="3" class="FieldData">
        <input type="text" name="pullwaitingCnt" id="pullwaitingCnt" readonly value="" style='border: 0px  solid  #7F9DB9;  font-size:8pt;  font-family:"arial", "돋움";  color:#666666;  width:30; height:20;'>
        <a href="javascript:viewPullWaitMessage();"><img src="images/btn_inview.gif" width="39" height="13" align="absmiddle" border="0"></a>
    </td>
  </tr>
  <tr>
    <td class="FieldLabel" width=250><%=_i18n.get("mpc21ms001.column.pullsentList")%></td>
    <td colspan="3" class="FieldData">
    <input type="text" style='border: 0px  solid  #7F9DB9;  font-size:8pt;  font-family:"arial", "돋움";  color:#666666;  width:30; height:20;'>
    <a href="javascript:viewPullSentMessage();"><img src="images/btn_inview.gif" width="39" height="13" align="absmiddle" border="0"></a>
    </td>
  </tr>
  <tr>
    <td class="FieldLabel" width=250><%=_i18n.get("mpc21ms001.column.wssuserCnt")%></td>
    <td colspan="3" class="FieldData">
    <input type="text" name="wssUserCnt" id="wssUserCnt" style='border: 0px  solid  #7F9DB9;  font-size:8pt;  font-family:"arial", "돋움";  color:#666666;  width:30; height:20;'>
    <a href="javascript:viewWssUser();"><img src="images/btn_inview.gif" width="39" height="13" align="absmiddle" border="0"></a>
    </td>
  </tr>
</table>

<!-- 상세 내용 로딩 -->
<script language="JavaScript" type="text/JavaScript">
<!--
 getMpcInfo();
//-->
</script>

<br>
<!-- 버튼테이블 -->
<table class="TableLayout" >
  <tr>
    <td align="right" style="padding-top:15">
      <a href="mpc20ms001.jsp"><img src="images/btn_big_list.gif" width="39" height="23" border="0"></a>
      <a href="javascript:updateMpc();"><img src="images/btn_big_change.gif" width="39" height="23" border="0"></a>
    </td>
  </tr>
</table>

</form>
</body>
</html>
