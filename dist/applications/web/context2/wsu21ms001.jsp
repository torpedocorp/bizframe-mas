<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.PartyIdVO" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.WSSUserVO" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.MpcVO" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.Eb3Constants" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%
/**
 * detail for user
 *
 * @author Ho-Jin Seo
 * @version 1.0
 */
 	String obid = request.getParameter("obid");

	MxsEngine engine = MxsEngine.getInstance();
	QueryCondition qc = new QueryCondition();
	qc.add("obid", obid);
	ArrayList list = engine.getObjects("WSSUser", qc, DAOFactory.EBMS3);

%>
<html>
<head>
<%@ include file="./com00in000.jsp" %>
<%@ include file="./com00in003.jsp" %>
<%
	if (list.size() < 1) {
	    out.println("<script>alert('" + _i18n.get("wsu21ms001.notfound") + "');history.back();</script>");
	    return;
	}

	WSSUserVO userVO = (WSSUserVO) list.get(0);
	String mine = (String)userVO.getExtension(Eb3Constants.MXSOBJ_EXTENSION_MINE);
	String description = StringUtil.nullCheck(userVO.getDescription());
	String party_obid = StringUtil.nullCheck(userVO.getPartyIdObid());
	String party_id = "";
	PartyIdVO partyVO = null;
	if (!"".equals(party_obid)) {
		qc = new QueryCondition();
		qc.add("obid", party_obid);
		partyVO = (PartyIdVO)engine.getObject("PartyId", qc, DAOFactory.EBMS);
	}

	if (partyVO != null)
		party_id = partyVO.getPartyId();

	qc = new QueryCondition();
	qc.add("username", userVO.getUsername());
	ArrayList mpcList = engine.getObjects("Mpc", 2, qc, DAOFactory.EBMS3);


%>
<title><%=_i18n.get("global.page.title")%></title>
<script language="JavaScript" type="text/JavaScript">
<!--
function initialize() {
	$('party_obid').value = '<%=party_obid%>';
	$('party_id').value = '<%=party_id%>';
	updateAuthType("<%=mine%>");
<%
	for(int i=0; i<mpcList.size(); i++) {
		MpcVO mpcVO = (MpcVO)mpcList.get(i);
		String mpcObid = mpcVO.getObid();
		String mpcName = mpcVO.getDisplayName();
		String mpcUri = mpcVO.getMpcUri();

		int isDefault = mpcVO.getIsDefault();
		String isDefaultStr = "";
		if (isDefault == Eb3Constants.MPC_DEFAULT) {
			isDefaultStr = _i18n.get("mpc20ms001.str.default");
		}
		else if (isDefault == Eb3Constants.MPC_NON_DEFAULT) {
			isDefaultStr = _i18n.get("mpc20ms001.str.nondefault");
		}

		String isActiveStr = "";
		int isActive = mpcVO.getIsActive();
		if (isActive == Eb3Constants.MPC_ACTIVE) {
			isActiveStr = _i18n.get("mpc20ms001.str.active");
		} else if (isActive == Eb3Constants.MPC_INACTIVE) {
			isActiveStr = _i18n.get("mpc20ms001.str.inactive");
		}

%>
	addMpc('<%=mpcObid%>', '<%=mpcName%>', '<%=isDefaultStr%>', '<%=isActiveStr%>', "<%=mpcUri%>");
<%
	}
%>
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

function deleteUser() {
	msg = "<%=_i18n.get("wsu21ms001.delete.confirm")%>";
	openConfirm(msg, deleteOkFunction, null, "<%=_i18n.get("global.warning")%>");
}

function deleteOkFunction() {
	Windows.closeAllModalWindows();
	clearNotify();

	var params = Form.serialize(document.form1);

	openInfo('<%=_i18n.get("global.processing") %>');
	var opt = {
	    method: 'post',
	    postBody: params,
	    asynchronous : false,
	    onSuccess: function(t) {
	    	//closeInfo();

	    	Dialog.setInfoMessage('<%=_i18n.get("wsu21ms001.operation.delete") %>');
	    	$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("wsu21ms001.operation.delete") %>';
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
	        //showErrorPopup(t.responseText, null, null, null);
	    }
	}

	var myAjax = new Ajax.Request('./wsu40ac001.jsp', opt);
}

function updateUser() {
	if ($('passwd').value != $('passwd2').value) {
		alert("<%=_i18n.get("wsu21ms001.passwd.incorrect")%>");
		return;
	}
	msg = "<%=_i18n.get("wsu21ms001.update.confirm")%>";
	openConfirm(msg, updateOkFunction, null, "<%=_i18n.get("global.warning")%>");
}

function updateOkFunction() {
	Windows.closeAllModalWindows();
	clearNotify();

	var params = Form.serialize(document.form1);

	openInfo('<%=_i18n.get("global.processing") %>');
	var opt = {
	    method: 'post',
	    postBody: params,
	    onSuccess: function(t) {
	    	closeInfo();
	    	$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("wsu21ms001.operation.update") %>';
	    	//Dialog.setInfoMessage('<%=_i18n.get("wsu21ms001.operation.update") %>');
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

	var myAjax = new Ajax.Request('./wsu30ac001.jsp', opt);
}

function goList() {
	timeout--;
	if (timeout >0) {
		setTimeout(goList, 1000) ;
	} else {
		history.go(-1);
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

window.onload = initialize;
//-->
</script>
</head>
<body>
<%
	if (userVO == null) {
		out.write("<script>alert('" + _i18n.get("wsu21ms001.notfound") +"'); history.go(-1);</script>");
		return;
	}
%>
<!-- 제목테이블 -->
<table class="TableLayout">
  <tr>
    <td width="210" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.wsuser.info")%></td>
    <td width="550" class="MessageDisplay"><div id=messageDisplay></div></td>
  </tr>
  <tr>
    <td colspan="2" height="6"></td>
  </tr>
</table>
<!-- 등록테이블-->
<form name="form1" method="post" >
<input type="hidden" name="obid" value="<%=obid%>">
<input type="hidden" name="party_obid" id="party_obid">
<input name="authType" id="authType" type="hidden">
<table class="FieldTable">
  <tr>
    <td width="120" class="FieldLabel"><%=_i18n.get("global.user.id")%></td>
    <td width="260" class="FieldData" colspan="3"><input name="userid" id="userid" type="text" class="FormTextReadOnly" readonly size="32" value="<%= userVO.getUsername() %>">
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%=_i18n.get("global.user.password")%></td>
    <td width="260" class="FieldData" colspan="3">
      <input name="passwd" id="passwd" type="password" class="FormText" size="32"></td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%=_i18n.get("global.user.password.confirm")%></td>
    <td width="260" class="FieldData" colspan="3">
      <input name="passwd2" id="passwd2" type="password" class="FormText" size="32"></td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("global.user.link.cpa")%></td>
    <td width="260" class="FieldData" colspan="3"><input name="party_id" id="party_id" type="text" class="FormTextReadOnly" readonly size="32" >
    	<a href="javascript:openPartyList()"><img src="images/btn_inview.gif" width="39" height="13" align="absmiddle" border="0" style="cursor:hand;"></a>
    </td>
  </tr>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("global.user.description")%></td>
    <td class="FieldData" colspan="3"><input name="description" id="description" type="text" class="FormText" size="100" value="<%= description %>"></td>
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
            <th class="ResultHeader" ><%= _i18n.get("mpc20ms002.column.uri") %></th>
            <th class="ResultLastHeader" style="width:30;"><input type="checkbox" id="chbox" name="allChkBtn" value="" class="gray-text" onClick="javascript:mainAllCheck();"></th>
        </tr>
    </thead>
    <tbody id="mpctbody">

    </tbody>
</table>
<!-- 버튼테이블 -->
<table class="TableLayout" >
  <tr>
    <td align="right" style="padding-top:15"><a href="javascript:history.go(-1)"><img src="images/btn_big_list.gif" width="39" height="23" border="0"></a>
      <a href="javascript:updateUser()"><img src="images/btn_big_change.gif" width="39" height="23" border="0"></a>
      <a href="javascript:deleteUser()"><img src="images/btn_big_delete.gif" width="39" height="23" border="0"></a></td>
  </tr>
</table>
</form>
</body>
</html>
