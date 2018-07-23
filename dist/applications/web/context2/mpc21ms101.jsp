<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%
/**
 * MPC 설정
 * @author Mi-Young Kim
 * @version 1.0 2008.10.01
 */
%>
<html>
<head>
<%@ include file="com00in000.jsp" %>
<%@ include file="./com00in003.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>
<script language="JavaScript" type="text/JavaScript">
<!--
var seqno =0;

function delRow_MpcTbl(actionObid, trnum) {
  var mpcTbl = document.getElementById(actionObid+'_mpcTbl');
  var targetObj = document.getElementById(trnum);
  mpcTbl.deleteRow(targetObj.rowIndex);

}

function addRow_MpcTbl(kind, actionObid) {
  seqno++;
  var newRow = document.getElementById(actionObid+'_mpcTbl').insertRow(0);
  newRow.setAttribute("id","tr_" + (seqno));
  var body = "";
  body += '           <input type="text" name="mpcName" id="N_'+actionObid+'_'+seqno+'" class="FormTextReadOnly" readonly size="35" value="" class="FormTextReadOnly" readonly>';
  body += '           <a href="javascript:settingMpc('+kind+', \'_'+actionObid+'_'+seqno+'\')"><img src="images/btn_big_generate.gif" width="39" height="23" border="0" align="absmiddle"></a>';
  body += '           <a href="javascript:delRow_MpcTbl(\''+actionObid+'\', \'tr_'+seqno+'\')"><img src="images/btn_big_delete.gif" width="39" height="23" border="0" align="absmiddle">';
  body += '<input type="hidden" name="mpcObid" id="O_'+actionObid+'_'+seqno+'" value="">';
  body += '<input type="hidden" name="actionObid" id="actionObid" value="'+ actionObid +'">';      
  
  var cell1 = newRow.insertCell(0); // td를 만드는 방법
  cell1.innerHTML = body;
}

function getInfo() {
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
   var myAjax = new Ajax.Request("mpc21ac101.jsp", opt);
}


function show(originalRequest) {
   
   var res = eval("(" + originalRequest.responseText + ")");
   $('cpaId').value   = res.cpaid;
   $('cpaName').value = res.cpaName;
   $('cpaRole').value = res.cpaRole;
   
   var localbody = "";
   localbody = getHeader();
   for (var i=0; i<res.localList.length; i++) {
      color = i % 2 == 0 ? "#FFFFFF" : "#F9F9F9";
      var actionObid = res.localList[i].actionObid;
      var mpcObid = "";
      localbody += '<tr>';
      localbody += '   <td class="ResultData">' + res.localList[i].service + '</td>';
      localbody += '   <td class="ResultData">' + res.localList[i].action + '</td>';
      localbody += '   <td class="ResultData">';
      localbody += '       <table id="'+actionObid+'_mpcTbl" class="TableLayout">';
      for (var j=0; j<res.localList[i].mpcList.length; j++) {
          mpcObid = res.localList[i].mpcList[j].mpcObid;
	      localbody += '       	<tr id="trD_'+j+'"><td>';
		  localbody += '           <input type="text" name="mpcName" id="ND_'+actionObid+'_'+j+'" class="FormTextReadOnly" readonly size="35" value="'+ res.localList[i].mpcList[j].mpcDisplayName +'" class="FormTextReadOnly" readonly>';
		  localbody += '           <a href="javascript:settingMpc(1, \'D_'+actionObid+'_'+j+'\')"><img src="images/btn_big_generate.gif" width="39" height="23" border="0" align="absmiddle"></a>'
          localbody += '           <a href="javascript:delRow_MpcTbl(\''+actionObid+'\', \'trD_'+j+'\')"><img src="images/btn_big_delete.gif" width="39" height="23" border="0" align="absmiddle">';
		  localbody += '<input type="hidden" name="mpcObid" id="OD_'+actionObid+'_'+j+'" value="'+ mpcObid +'">';
		  localbody += '<input type="hidden" name="actionObid" id="actionObid" value="'+ actionObid +'">';      
	      localbody += '       	</td></tr>';
      }
      localbody += '       </table>';
      localbody += '   </td>';
      localbody += '   <td class="ResultLastData"><a href="javascript:addRow_MpcTbl(1, \''+actionObid+'\')"><img src="images/btn_big_add.gif" width="39" height="23" border="0" align="absmiddle" ></a></td>';
      localbody += '</tr>';
   }

   if (res.localList.length == 0) {
       localbody += '<tr><td colspan="4" class="ResultLastData" align="center"><%= _i18n.get("mpc21ms101.notfound")%></td></tr>';
   }
   localbody += "</table>";
   
   var remotebody = "";
   remotebody = getHeader();
   for (var i=0; i<res.remoteList.length; i++) {
      color = i % 2 == 0 ? "#FFFFFF" : "#F9F9F9";
      var actionObid = res.remoteList[i].actionObid;
      var mpcObid = "";
      remotebody += '<tr>';
      remotebody += '   <td class="ResultData">' + res.remoteList[i].service + '</td>';
      remotebody += '   <td class="ResultData">' + res.remoteList[i].action + '</td>';
      remotebody += '   <td class="ResultData">';
      remotebody += '       <table id="'+actionObid+'_mpcTbl" class="TableLayout">';
      for (var j=0; j<res.remoteList[i].mpcList.length; j++) {
          mpcObid = res.remoteList[i].mpcList[j].mpcObid;
	      remotebody += '       	<tr id="trD_'+j+'"><td>';
		  remotebody += '           <input type="text" name="mpcName" id="ND_'+actionObid+'_'+j+'" class="FormTextReadOnly" readonly size="35" value="'+ res.remoteList[i].mpcList[j].mpcDisplayName +'" class="FormTextReadOnly" readonly>';
		  remotebody += '           <a href="javascript:settingMpc(2, \'D_'+actionObid+'_'+j+'\')"><img src="images/btn_big_generate.gif" width="39" height="23" border="0" align="absmiddle"></a>'
          remotebody += '           <a href="javascript:delRow_MpcTbl(\''+actionObid+'\', \'trD_'+j+'\')"><img src="images/btn_big_delete.gif" width="39" height="23" border="0" align="absmiddle">';
		  remotebody += '<input type="hidden" name="mpcObid" id="OD_'+actionObid+'_'+j+'" value="'+ mpcObid +'">';
		  remotebody += '<input type="hidden" name="actionObid" id="actionObid" value="'+ actionObid +'">';      
	      remotebody += '       	</td></tr>';
      }
      remotebody += '       </table>';
      remotebody += '   </td>';
      remotebody += '   <td class="ResultLastData"><a href="javascript:addRow_MpcTbl(2, \''+actionObid+'\')"><img src="images/btn_big_add.gif" width="39" height="23" border="0" align="absmiddle" ></a></td>';
      remotebody += '</tr>';
   }

   if (res.remoteList.length == 0) {
       remotebody += '<tr><td colspan="4" class="ResultLastData" align="center"><%= _i18n.get("mpc21ms101.notfound")%></td></tr>';
   }
   remotebody += "</table>";   
   
   $('localMpcContent').innerHTML = localbody;
   $('remoteMpcContent').innerHTML = remotebody;
}   

function getHeader() {
	var body = "";
	body += '<table class="TableLayout" style="table-layout: fixed">';
	body +='  <tr>';
	body +='      <td class="ResultHeader" width="27%"><%=_i18n.get("global.cpa.service.name")%></td>';
	body +='  	  <td class="ResultHeader" width="27%"><%=_i18n.get("global.cpa.action.name")%></td>';
	body +='  	  <td class="ResultHeader"><%=_i18n.get("menu.mpc.name")%></td>';
	body +='  	  <td class="ResultLastHeader" width="6%"></td>';
	body +='  </tr>';
	return body;
}

function storeMpc() {
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
	
	var myAjax = new Ajax.Request('mpc30ac101.jsp', opt);	
}

function loading() {
   var body = "";

   body = getHeader();
   body += '<tr><td colspan="4" class="ResultLastData" align="center"><%= _i18n.get("global.loading")%></td></tr>';
   body += "</table>";
   
   $('localMpcContent').innerHTML = body;
   $('remoteMpcContent').innerHTML = body;

}

function applyMpc(id, mpcObid, mpcName) {
  document.getElementById("N"  + id).value = mpcName;
  document.getElementById("O"  + id).value = mpcObid;
}

function settingMpc(kind, id) {
    var url = "";
    if (kind == "1") { // local
        url = "mpc20pu101.jsp?id=" + id;
    } else if (kind == "2") { // remote
        url = "mpc20pu102.jsp?id=" + id;
    } 
    window.open(url, "View", "width=830,height=500,left=0,top=0,resizable=yes,scrollbars=yes");
}

//-->
</script>

</head>
<body bgcolor=#FFFFFF leftmargin=0 topmargin=0 marginwidth=0 marginheight=0>
<form name="form1" method="POST">
<input type=hidden name="cpaObid" value="<%=request.getParameter("obid")%>">
<!-- 제목테이블 :수행자 설정 -->
<table class="TableLayout">
  <tr> 
    <td width="160" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.mpc.setting")%></td>
    <td width="600" class="MessageDisplay" ><div id=messageDisplay>&nbsp;</div></td>
  </tr>
  <tr> 
    <td colspan="2" height="10"></td>
  </tr>
</table>

<!-- 수행자 CPA 기본정보 : CPA이름, CPD아이디, 수행역할 --> 
<table class="FieldTable">
  <tr> 
    <td width="120" class="FieldLabel"><%=_i18n.get("global.cpa.name")%></td>
    <td width="260" class="FieldData">
      <input name="cpaName" id="cpaName" type="text" class="FormTextReadOnly" readonly value="" size="32"> 
    </td>
    <td width="120" class="FieldLabel"><%=_i18n.get("global.cpa.id")%></td>
    <td width="260" class="FieldData">
      <input name="cpaId" id="cpaId" type="text" class="FormTextReadOnly" readonly value="" size="45"></td>
  </tr>
  <tr> 
    <td class="FieldLabel"><%=_i18n.get("global.cpa.party.role")%></td>
    <td colspan="3" class="FieldData"> 
      <input name="cpaRole" id="cpaRole" type="text" class="FormTextReadOnly" readonly value="" size="32"> 
    </td>
  </tr>
</table>





<!-- Local MPC 설정 대상 목록  -->
<br>
<h3><%=_i18n.get("mpc21ms101.localmpc.setting")%></h3>
<table class="TableLayout">
  <tr>
    <td>
        <div id="localMpcContent"></div>
    </td>
  </tr>
</table>

<!-- Remote MPC 설정 대상 목록  -->
<br>
<h3><%=_i18n.get("mpc21ms101.remotempc.setting")%></h3>
<table class="TableLayout">
  <tr>
    <td>
        <div id="remoteMpcContent"></div>
    </td>
  </tr>
</table>

<!-- 상세 내용 로딩 -->
<script language="JavaScript" type="text/JavaScript">
<!--
 getInfo();
//-->
</script>

<br>
<!-- 버튼테이블 -->
<table class="TableLayout" >
  <tr> 
    <td align="right" style="padding-top:15">      
      <a href="mpc20ms101.jsp"><img src="images/btn_big_list.gif" width="39" height="23" border="0"></a>
      <a href="javascript:storeMpc();"><img src="images/btn_big_save.gif" width="39" height="23" border="0"></a>
    </td>
  </tr>
</table>
      
</form>
</body>
</html>
