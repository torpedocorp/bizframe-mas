<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%
/**
 * Agreement mofification form
 *
 * @author Ho-Jin Seo 2008.10.27
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
function initialize() {
	getAgreementInfo();
}

function loading() {
   $('messageDisplay').innerHTML = '<%= _i18n.get("global.loading")%>';
}

function getAgreementInfo() {
   loading();
   var params = Form.serialize(document.form2);
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
   var myAjax = new Ajax.Request("agr21ac001.jsp", opt);
}

function show(originalRequest) {
	var browserName = navigator.appName;
   var res = eval("(" + originalRequest.responseText + ")");

   $('obid').value = res.obid;
   $('id').value = res.id;
   $('currentName').value = res.id;
   $('dupname').value = res.id;
   $('dupflag_result').value = "true";
   $('type').value = res.type;

   if (res.reftype == "0") {
	   $('type.none').checked = true;
	   document.form2.id.readOnly = false;

   } else if(res.reftype == "1") {
	   $('type.cpa').checked = true;
		$('ref_cpaobid').value = res.refobid;
		$('refcpa').value = res.ref_cpaid;
		if (browserName == "Microsoft Internet Explorer") {
			$('cpa_block').style.display = 'block';
		} else {
			$('cpa_block').style.display = 'table-row';
		}
	   document.form2.id.readOnly = true;
   } else if(res.reftype == "2") {
	   $('type.pmode').checked = true;
		$('ref_pmodeobid').value = res.refobid;
		$('refpmode').value = res.ref_pmodeid;
		if (browserName == "Microsoft Internet Explorer") {
			$('pmode_block').style.display = 'block';
		} else {
			$('pmode_block').style.display = 'table-row';
		}
	   document.form2.id.readOnly = true;
   }

   $('description').value = res.desc;
   $('description').value = res.desc;
   $('messageDisplay').innerHTML = '';
}

function validateURI(str){
	if(!str) {
		return false;
	}

    var regexUri = /^([a-z0-9+.-]+):/; // scheme

	if(!regexUri.exec(str)) {
		return false; //invalid URI
	} else {
		return true;
	}
}

function updateAgreement() {
    if($('id').value == "") {
       alert("<%=_i18n.get("agr10ms001.id.empty")%>");
       return;
    }

    if ($('dupname').value != $('id').value || $('dupflag_result').value != 'true') {
//        alert('<%=_i18n.get("agr10ms001.id.inform")%>');
//        $('dup_notice').innerHTML = '<%= _i18n.get("global.duplication.check")%>';
//        return;
     }

    if($('type.cpa').checked && $('ref_cpaobid').value == "") {
       alert("<%=_i18n.get("agr10ms001.cpa.selected.none")%>");
       return;
    } else if($('type.pmode').checked && $('ref_pmodeobid').value == "") {
       alert("<%=_i18n.get("agr10ms001.pmode.selected.none")%>");
       return;
    }

	if ($('type').value == "" && !validateURI($('id').value)) {
		alert("<%=_i18n.get("agr10ms001.type.desc")%>");
		return;
	}

   Windows.closeAllModalWindows();
   clearNotify();
   openInfo('<%=_i18n.get("global.processing") %>');
   var params = Form.serialize(document.form2);

   var opt = {
      method: 'post',
      parameters: params,
      onSuccess: function(t) {
        closeInfo();
    	$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("agr10ms001.operation.update") %>';
    	$('currentName').value = $('id').value;
      },
       on404: function(t) {
	       closeInfo();
           $('messageDisplay').innerHTML = '<%=_i18n.get("err00zz404.message") %>';
           //showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
       },
       onFailure: function(t) {
	       closeInfo();
           $('messageDisplay').innerHTML = '<%=_i18n.get("global.error.retry") %>';
           showErrorPopup(t.responseText, null, null, null);
       }
   }
   var myAjax = new Ajax.Request("agr30ac001.jsp", opt);
}

function showNotice(){
	if ($('currentName').value == $('id').value) {
	    $('dup_notice').innerHTML = '';
	} else if ($('dupname').value == $('id').value && $('dupflag_result').value == "true") {
	    $('dup_notice').innerHTML = '';
    } else {
       $('dup_notice').innerHTML = '&nbsp;<font color="red"><%= _i18n.get("global.duplication.check")%></font>';
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

function nameCheck() {

	$('messageDisplay').innerHTML = '';

	check_name = $('id').value;
	if(check_name == null || check_name == '') {
		//$('messageDisplay').innerHTML = '<%=_i18n.get("agr10ms001.id.empty") %>';
		alert('<%=_i18n.get("agr10ms001.id.empty") %>');
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
	var myAjax = new Ajax.Request("./agr10ac002.jsp", opt);
}

function dupCheckResult(check_name, result) {
   $('dupname').value = check_name;
   $('dupflag_result').value = result;

   if(result == 'true') {
      alert('<%=_i18n.get("agr10ms001.id.use") %>');
      $('dup_notice').innerHTML = '';

      return true;
   }
   else {
      alert('<%=_i18n.get("agr10ms001.id.nouse") %>');
      $('dup_notice').innerHTML = '<%= _i18n.get("global.duplication.check")%>';
      return false;
   }
}

function openRefList(obid) {
	if ($('type.cpa').checked == true) {
		win = window.open("cpa20pu001.jsp","RefList","width=830,height=550,left=0,top=0,resizable=yes,scrollbars=yes");
		win.opener = self;
	} else if ($('type.pmode').checked == true) {
		win = window.open("pmd20pu001.jsp","RefList","width=830,height=550,left=0,top=0,resizable=yes,scrollbars=yes");
		win.opener = self;
	}
}

function applyRef(obid, check_name, id) {
	if ($('type.cpa').checked == true) {
		$('ref_cpaobid').value = obid;
		$('refcpa').value = check_name;
		$('id').value = id;
	} else if ($('type.pmode').checked == true) {
		$('ref_pmodeobid').value = obid;
		$('refpmode').value = check_name;
		$('id').value = id;
	}
}

function changeRef() {
	var browserName = navigator.appName;

	if ($('type.none').checked == true) {
		$('cpa_block').style.display = 'none';
		$('pmode_block').style.display = 'none';
		$('ref_cpaobid').value = "";
		$('refcpa').value = "";
		$('ref_pmodeobid').value = "";
		$('refpmode').value = "";

		state = false;

	} else if ($('type.cpa').checked == true) {
		$('ref_pmodeobid').value = "";
		$('refpmode').value = "";
		if (browserName == "Microsoft Internet Explorer") {
			$('cpa_block').style.display = 'block';
			$('pmode_block').style.display = 'none';
		} else {
			$('cpa_block').style.display = 'table-row';
			$('pmode_block').style.display = 'none';
		}

		state = true;
	} else if ($('type.pmode').checked == true) {
		$('ref_cpaobid').value = "";
		$('refcpa').value = "";
		if (browserName == "Microsoft Internet Explorer") {
			$('cpa_block').style.display = 'none';
			$('pmode_block').style.display = 'block';
		} else {
			$('cpa_block').style.display = 'none';
			$('pmode_block').style.display = 'table-row';
		}
		state = true;
	}
	document.form2.id.readOnly = state;
	//$('id').disabled = state ;
	//$('id').style.backgroundColor = state?"yellow":"white" ;

}

function deleteAgreement() {
	msg = "<%=_i18n.get("agr21ms001.delete.confirm")%>";
	openConfirm(msg, deleteOkFunction, null, "<%=_i18n.get("global.warning")%>");
}

function deleteOkFunction() {
	Windows.closeAllModalWindows();
	clearNotify();

	var params = Form.serialize(document.form2);

	openInfo('<%=_i18n.get("global.processing") %>');
	var opt = {
	    method: 'post',
	    postBody: params,
	    asynchronous : false,
	    onSuccess: function(t) {
	    	//closeInfo();

	    	Dialog.setInfoMessage('<%=_i18n.get("agr21ms001.operation.delete") %>');
	    	$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("agr21ms001.operation.delete") %>';
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

	var myAjax = new Ajax.Request('./agr40ac001.jsp', opt);
}

window.onload = initialize;
//-->
</script>
</head>
<body>
<!-- 제목테이블 -->
<table class="TableLayout">
  <tr>
    <td width="25%" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.agreement.detail")%></td>
    <td width="75%" class="MessageDisplay"><div id=messageDisplay></div></td>
  </tr>
  <tr>
    <td colspan="2" height="6"></td>
  </tr>
</table>

<!-- 등록테이블  -->
<form name="form2" method="post">
<input type="hidden" name="obid" id="obid" value="<%=request.getParameter("obid")%>">
<input type="hidden" name="currentName" id="currentName">
<table class="FieldTable">
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("global.agreement.id")%></td>
    <td class="FieldData" colspan="3">
      <input name="id" id="id" type="text" class="FormText" size="25" onKeyUp="javascript:showNotice();"/>
      <a href="javascript:nameCheck()"><img src="images/btn_checkunique.gif" width="59" height="20" align="absmiddle" border="0"></a>
      <span id="dup_notice"></span>
      <input type="hidden" id="dupname"  value="">
      <input type="hidden" id="dupflag_result"  value="">
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("global.agreement.type")%></td>
    <td class="FieldData" colspan="3"><input name="type" id="type" type="text" class="FormText" value="" size="20" maxlength="20">
    <%= _i18n.get("agr10ms001.type.desc")%>
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("global.agreement.ref.type")%></td>
    <td width="260" class="FieldData" colspan="3">
      <input type="radio" name="reftype" id="type.none" value="0" onClick="changeRef()" checked><%= _i18n.get("agr20ms001.ref.type.none") %>&nbsp;&nbsp;
      <input type="radio" name="reftype" id="type.cpa" value="1" onClick="changeRef()"><%= _i18n.get("agr20ms001.ref.type.cpa") %>
      <input type="radio" name="reftype" id="type.pmode" value="2" onClick="changeRef()"><%= _i18n.get("agr20ms001.ref.type.pmode") %>
    </td>
  </tr>
  <tr id="cpa_block" style="display:none">
    <td width="120" class="FieldLabel"><%= _i18n.get("agr10ms001.ref.cpa")%></td>
    <td width="260" class="FieldData" colspan="3"><input name="refcpa" id="refcpa" type="text" value="" size="32" class="FormTextReadOnly" readonly >
      <input type="hidden" name="ref_cpaobid" id="ref_cpaobid">
      <a href="javascript:openRefList()"><img src="images/btn_inview.gif" width="39" height="13" align="absmiddle" border="0" style="cursor:hand;"></a>
    </td>
  </tr>
  <tr id="pmode_block" style="display:none">
    <td width="120" class="FieldLabel"><%= _i18n.get("agr10ms001.ref.pmode")%></td>
    <td width="260" class="FieldData" colspan="3"><input name="refpmode" id="refpmode" type="text" value="" size="32" class="FormTextReadOnly" readonly >
      <input type="hidden" name="ref_pmodeobid" id="ref_pmodeobid">
      <a href="javascript:openRefList()"><img src="images/btn_inview.gif" width="39" height="13" align="absmiddle" border="0" style="cursor:hand;"></a>
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("global.description")%></td>
    <td width="260" class="FieldData" colspan="3"><input name="description" id="description" type="text" class="FormText" size="100" /></td>
  </tr>
</table>

<table class="TableLayout" >
  <tr>
    <td align="right" style="padding-top:15">
      <a href="javascript:history.go(-1)"><img src="images/btn_big_list.gif" width="39" height="23" border="0"></a>
      <a href="javascript:updateAgreement()"><img src="images/btn_big_change.gif" width="39" height="23" border="0"></a>
      <a href="javascript:deleteAgreement()"><img src="images/btn_big_delete.gif" width="39" height="23" border="0"></a>
    </td>
  </tr>
</table>
</body>
</html>
