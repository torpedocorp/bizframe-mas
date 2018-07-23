<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%
/**
 * User registration form
 *
 * @author Ho-Jin Seo 2008.09.25
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
function insertUser() {
	closeInfo();

    if($('userid').value == "") {
       alert("<%=_i18n.get("wsu10ms001.userid.empty")%>");
       return;
    }

    if ($('dupname').value != $('userid').value || $('dupflag_result').value != 'true') {
        alert('<%=_i18n.get("wsu10ms001.userid.inform")%>');
        $('dup_notice').innerHTML = '<%= _i18n.get("global.duplication.check")%>';
        return;
     }

    if($('passwd').value == "") {
       alert("<%=_i18n.get("wsu10ms001.passwd.empty")%>");
       return;
    }

    if($('passwd').value != $('passwd2').value) {
        alert("<%=_i18n.get("wsu21ms001.passwd.incorrect")%>");
        return;
     }

	/*
    if($('party_obid').value == "")
    {
       alert("<%=_i18n.get("wsu10ms001.party.empty")%>");
       return;
    }
    */

   var params = Form.serialize(document.form2);

   Windows.closeAllModalWindows();
   clearNotify();
   openInfo('<%=_i18n.get("global.processing") %>');
   var opt = {
      method: 'post',
      parameters: params,
      onSuccess: function(t) {
        closeInfo();
    	$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("wsu10ms001.register.ok") %>';
    	Dialog.setInfoMessage('<%=_i18n.get("wsu10ms001.register.ok") %>');
    	timeout=2; setTimeout(goList, 1000);

      },
       on404: function(t) {
	       closeInfo();
           $('messageDisplay').innerHTML = '<%=_i18n.get("err00zz404.message") %>';
           //showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
           closeInfo();
       },
       onFailure: function(t) {
	       closeInfo();
           $('messageDisplay').innerHTML = '<%=_i18n.get("global.error.retry") %>';
           showErrorPopup(t.responseText, null, null, null);
           closeInfo();
       }
   }
   var myAjax = new Ajax.Request("wsu10ac001.jsp", opt);

}

function goList() {
	timeout--;
	if (timeout >0) {
		setTimeout(goList, 1000) ;
	} else {
		history.go(-1);
	}
}

function nameCheck() {

	$('messageDisplay').innerHTML = '';

	check_name = $('userid').value;
	if(check_name == null || check_name == '') {
		//$('messageDisplay').innerHTML = '<%=_i18n.get("wsu10ms001.userid.empty") %>';
		alert('<%=_i18n.get("wsu10ms001.userid.empty") %>');
		return;
	}

	var params = Form.serialize(document.form2);
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
	var myAjax = new Ajax.Request("./wsu10ac002.jsp", opt);
}

function dupCheckResult(check_name, result) {
   $('dupname').value = check_name;
   $('dupflag_result').value = result;

   if(result == 'true') {
      //$('messageDisplay').innerHTML ='<%=_i18n.get("wsu10ms001.userid.use") %>';
      alert('<%=_i18n.get("wsu10ms001.userid.use") %>');
      $('dup_notice').innerHTML = '';

      return true;
   }
   else {
      //$('messageDisplay').innerHTML ='<%=_i18n.get("wsu10ms001.userid.nouse") %>';
      alert('<%=_i18n.get("wsu10ms001.userid.nouse") %>');
      $('dup_notice').innerHTML = '<%= _i18n.get("global.duplication.check")%>';
      return false;
   }
}

function openPartyList(obid) {
     win = window.open("wsu20pu001.jsp","party","width=630,height=620,left=0,top=0,resizable=yes,scrollbars=yes");
     win.opener = self;
}

function applyParty(party_obid, party_id, mine) {
	$('party_obid').value = party_obid;
	$('party_id').value = party_id;
	updateAuthType(mine);
}

function updateAuthType(auth) {
	if ($('authType').value != auth) {
		deleteAllMpc();
		$('authType').value = auth;
	}
}

function insertMpc() {
	if ($('authType').value == "0") {
		window.open("mpc20pu101.jsp", "View", "width=830,height=500,left=0,top=0,resizable=yes,scrollbars=yes");
	} else if ($('authType').value == "1") {
		window.open("mpc20pu102.jsp", "View", "width=830,height=500,left=0,top=0,resizable=yes,scrollbars=yes");
	} else {
		window.open("mpc20pu001.jsp", "View", "width=830,height=500,left=0,top=0,resizable=yes,scrollbars=yes");
	}
}

function addMpc(obid, mpc_name, is_default, is_active, mpc_uri) {
   var inputs = document.getElementsByTagName('input');
   var sb_Index = "" ;
   for (var i = inputs.length-1; i >= 0; i--) {
      if (inputs[i].type == 'checkbox') {
          obid2 = inputs[i].value;
          if (obid == obid2)
             return;
      }
   }

   var tr = document.createElement("tr");
   tr.setAttribute('id', obid);
   var td1 = document.createElement("td");
   td1.setAttribute('className', 'ResultData');	// IE bug??
   td1.setAttribute('class', 'ResultData');
   td1.appendChild(document.createTextNode(mpc_name));
   var td2 = document.createElement("td");
   td2.setAttribute('className', 'ResultData');	// IE bug??
   td2.setAttribute('class', 'ResultData');
   td2.setAttribute('align', 'center');
   td2.appendChild(document.createTextNode(is_default));
   var td3 = document.createElement("td");
   td3.setAttribute('className', 'ResultData');	// IE bug??
   td3.setAttribute('align', 'center');
   td3.setAttribute('class', 'ResultData');
   td3.appendChild(document.createTextNode(is_active));
   var td4 = document.createElement("td");
   td4.setAttribute('className', 'ResultData');	// IE bug??
   td4.setAttribute('class', 'ResultData');
   td4.appendChild(document.createTextNode(mpc_uri));
   var td5 = document.createElement("td");
   td5.setAttribute('className', 'ResultLastData');	// IE bug??
   td5.setAttribute('class', 'ResultLastData');
   td5.setAttribute('align', 'center');
   var radio = document.createElement("input");
   radio.setAttribute('type', 'checkbox');
   radio.setAttribute('value', obid);
   td5.appendChild(radio);

   var mpc = document.createElement("input");
   mpc.setAttribute('name', 'mpcObid');
   mpc.setAttribute('id', 'mpcObid');
   mpc.setAttribute('type', 'hidden');
   mpc.setAttribute('value', obid);
   td5.appendChild(mpc);

   tr.appendChild(td1);
   tr.appendChild(td2);
   tr.appendChild(td3);
   tr.appendChild(td4);
   tr.appendChild(td5);
   $('mpctbody').appendChild(tr);
}

function deleteMpc() {
   var inputs = document.getElementsByTagName('input');
   var sb_Index = "" ;
   for (var i = inputs.length-1; i >= 0; i--) {
      if (inputs[i].type == 'checkbox' && inputs[i].checked==true) {
          obid = inputs[i].value;
          if (obid != "")
	          $('mpctbody').removeChild($(obid));
      }
   }
}

function deleteAllMpc() {
	var RowsLength = $('mpctbody').rows.length;
	for (var i=RowsLength - 1; i >= 0; i--)
	{
		$('mpctbody').deleteRow(i);
	}
}

function mainAllCheck()
{
    var inputs     = document.getElementsByTagName('input');
    var checkboxes = new Array();
    var count = 0;
    for (var i = 0; i < inputs.length; i++) {
       if (inputs[i].type == 'checkbox' && inputs[i].name != 'allChkBtn') {
           checkboxes[count++] = inputs[i];
       }
    }

    for (var i = 0; i < checkboxes.length; i++) {
       checkboxes[i].checked = document.all.allChkBtn.checked;
    }
}
//-->
</script>
</head>
<body>
<!-- 제목테이블 -->
<table class="TableLayout">
  <tr>
    <td width="25%" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.wsuser.register")%></td>
    <td width="75%" class="MessageDisplay"><div id=messageDisplay></div></td>
  </tr>
  <tr>
    <td colspan="2" height="6"></td>
  </tr>
</table>

<!-- 등록테이블  -->
<form name="form2" method="post">
<input name="authType" id="authType" type="hidden">
<table class="FieldTable">
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("global.user.id")%></td>
    <td class="FieldData" colspan="3">
      <input name="userid" id="userid" type="text" class="FormText" size="25" />
      <a href="javascript:nameCheck()"><img src="images/btn_checkunique.gif" width="59" height="20" align="absmiddle" border="0"></a>
      <span id="dup_notice"><%= _i18n.get("global.duplication.check")%></span>
      <input type="hidden" id="dupname"  value="">
      <input type="hidden" id="dupflag_result"  value="">
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("global.user.password")%></td>
    <td width="260" class="FieldData" colspan="3"><input name="passwd" id="passwd" type="password" class="FormText" value="" size="20" maxlength="20"></td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("global.user.password.confirm")%></td>
    <td width="260" class="FieldData" colspan="3"><input name="passwd2" id="passwd2" type="password" class="FormText" value="" size="20" maxlength="20"></td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("global.user.link.cpa")%></td>
    <td width="260" class="FieldData" colspan="3"><input name="party_id" id="party_id" type="text" value="" size="32" class="FormTextReadOnly" readonly >
      <input type="hidden" name="party_obid" id="party_obid">
      <a href="javascript:openPartyList()"><img src="images/btn_inview.gif" width="39" height="13" align="absmiddle" border="0" style="cursor:hand;"></a>
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("global.user.description")%></td>
    <td width="260" class="FieldData" colspan="3"><input name="description" id="description" type="text" class="FormText" size="100" /></td>
  </tr>
</table>

<!-- 토탈테이블 -->
<table class="TotalTable" >
  <tr>
    <td align="left"><h3><%= _i18n.get("wsu21ms001.mpc") %></h3></td>
    <td width="300" align="right">
    <a href="javascript:insertMpc()"><img src="images/btn_big_add.gif" border="0"></a>
    <a href="javascript:deleteMpc()"><img src="images/btn_big_delete.gif" border="0" /></a></td>
  </tr>
</table>

<table class="TableLayout">
    <thead>
        <tr>
            <th class="ResultHeader" style="width:200;"><%= _i18n.get("mpc20ms002.column.displayname") %></th>
            <th class="ResultHeader" style="width:30;"><%= _i18n.get("mpc20ms002.column.default") %></th>
            <th class="ResultHeader" style="width:30;"><%= _i18n.get("mpc20ms002.column.status") %></th>
            <th class="ResultHeader"><%= _i18n.get("mpc20ms002.column.uri") %></th>
            <th class="ResultLastHeader" style="width:30;"><input type="checkbox" id="chbox" name="allChkBtn" value="" class="gray-text" onClick="javascript:mainAllCheck();"></th>
        </tr>
    </thead>
    <tbody id="mpctbody">

    </tbody>
</table>

<table class="TableLayout" >
  <tr>
    <td align="right" style="padding-top:15">
      <a href="javascript:history.go(-1)"><img src="images/btn_big_list.gif" width="39" height="23" border="0"></a>
      <a href="javascript:insertUser()"><img src="images/btn_big_create.gif" width="39" height="23" border="0"></a>
      <a href="javascript:document.form2.reset()"><img src="images/btn_big_reset.gif" width="47" height="23" border="0"></a>
    </td>
  </tr>
</table>
</body>
</html>
