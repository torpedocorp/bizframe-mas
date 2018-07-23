<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="kr.co.bizframe.mxs.ebms.model.cpa.CPA"%>
<%@ page import="kr.co.bizframe.mxs.ebms.model.cpa.PartyInfo"%>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.CpaVO"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.dto.SecurityKeyStoreVO"%>
<%@ page import="kr.co.bizframe.mxs.MxsConstants" %>
<%
    /**
    * @author Mi-Young Kim
    * @author Jae-Heon Kim
    * @author Ho-Jin Seo
    * @version 1.0
    */

   String command = request.getParameter("command");
   command = (command == null ? "insert" : command);

   CpaVO vo = (CpaVO) session.getAttribute("cpaVO");
   CPA cpa = vo.getCpa();

   String cpa_name = request.getParameter("cpa_name");
   cpa_name = (cpa_name == null ? "" : cpa_name);

   String cpa_description = request.getParameter("cpa_description");
   cpa_description = (cpa_description == null ? "" : cpa_description);

   String dupflag_result = request.getParameter("dupflag_result");
   dupflag_result = (dupflag_result == null ? "" : dupflag_result);

   String dupflag_value = request.getParameter("dupflag_value");
   dupflag_value = (dupflag_value == null ? "" : dupflag_value);

   String party_name = "";
   String selPartyName = request.getParameter("party_name");
   selPartyName = (selPartyName == null ? "" : selPartyName);

   java.text.SimpleDateFormat sd = new java.text.SimpleDateFormat("yyyy.MM.dd");
   QueryCondition qc = new QueryCondition();
   // get Keystores
   qc = new QueryCondition();
   ArrayList keystores = MxsEngine.getInstance().getObjects("SecurityKeyStore",  qc, DAOFactory.COMMON);
%>

<html>
<head>
<%@ include file="./com00in000.jsp" %>
<%@ include file="./com00in003.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>
<script language="JavaScript" type="text/JavaScript">
<!--
function insertCPA() {

   $('messageDisplay').innerHTML = '';

   var frm = document.cpaUpload;

   if ($('cpa_name').value == '') {
      $('messageDisplay').innerHTML ='<%=_i18n.get("cpa10ms001.cpaname.nullcheck")%>';
      alert('<%=_i18n.get("cpa10ms001.cpaname.nullcheck")%>');
      return;
   }
   if ($('dupflag_value').value != $('cpa_name').value || $('dupflag_result').value != 'true') {
      $('messageDisplay').innerHTML ='<%=_i18n.get("cpa10ms001.cpaname.inform")%>';
      alert('<%=_i18n.get("cpa10ms001.cpaname.inform")%>');
      return;
   }

   // CPA 수행역할 설정여부 체크...
   if(!frm.party_name[0].checked && !frm.party_name[1].checked) {
      $('messageDisplay').innerHTML = '<%=_i18n.get("cpa10ms001.partyname.inform") %>';
      alert('<%=_i18n.get("cpa10ms001.partyname.inform") %>');
      return;
   }

   openInfo('<%=_i18n.get("global.processing") %>');

   var params = Form.serialize(document.cpaUpload);
   var opt = {
      method: 'post',
      parameters: params,
      onSuccess: function(t) {
         $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%= _i18n.get("cpa10ms001.cpa.registered") %>';
	    Dialog.setInfoMessage('<%= _i18n.get("cpa10ms001.cpa.registered") %>');
	    timeout=2; setTimeout(goList, 1000);

      },
       on404: function(t) {
           $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("err00zz404.message") %>';
        //   showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
           closeInfo();
       },
       onFailure: function(t) {
           $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("global.error.retry") %>';
           showErrorPopup(t.responseText, null, null, null);
           closeInfo();
       }
   }
   var myAjax = new Ajax.Request("./cpa10ac001.jsp", opt);

}

function goList() {
	timeout--;
	if (timeout >0) {
		setTimeout(goList, 1000) ;
	} else {
		location.href = "cpa20ms001.jsp";
	}
}

function nameCheck(frm) {

   $('messageDisplay').innerHTML = '';
   check_name = $('cpa_name').value;

   if(check_name == null || check_name == '') {
      $('messageDisplay').innerHTML = '<%=_i18n.get("cpa10ms001.cpaname.nullcheck") %>';
      alert('<%=_i18n.get("cpa10ms001.cpaname.nullcheck") %>');
      return;
   }

   var params = Form.serialize(document.cpaUpload);
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
   var myAjax = new Ajax.Request("./cpa10ac003.jsp", opt);

}

function dupCheckResult(check_name, result) {

   $('dupflag_value').value = check_name;
   $('dupflag_result').value = result;

   if(result == 'true') {
      $('messageDisplay').innerHTML ='<%=_i18n.get("cpa10ms001.cpaname.use") %>';
      alert('<%=_i18n.get("cpa10ms001.cpaname.use") %>');
      return true;
   }
   else {
      $('messageDisplay').innerHTML ='<%=_i18n.get("cpa10ms001.cpaname.nouse") %>';
      alert('<%=_i18n.get("cpa10ms001.cpaname.nouse") %>');
      return false;
   }

}

//-->
</script>
</head>

<body>


<!-- 제목테이블 -->
<table class="TableLayout">
  <tr>
    <td width="150" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.cpa.register")%></td>
    <td width="610" class="MessageDisplay"> <div id=messageDisplay>&nbsp;</div></td>
  </tr>
  <tr>
    <td colspan="2" height="10"></td>
  </tr>
</table>

<form name="cpaUpload" method="post" >

<input type="hidden" name="command" value="<%=command %>">

<input type="hidden" name="dupflag_result" id="dupflag_result"  value="<%=dupflag_result%>">
<input type="hidden" name="dupflag_value" id="dupflag_value"   value="<%=dupflag_value%>">

<table class="FieldTable">
  <!-- CPA Name, Id -->
  <tr>
    <td width="130" class="FieldLabel"><%=_i18n.get("global.cpa.name")%> </td>
    <td width="250" class="FieldData">
      <input name="cpa_name" id="cpa_name" type="text" class="FormText" value="<%=cpa_name%>" size="25">
      <a href="javascript:nameCheck(this.form)"><img src="images/btn_checkunique.gif" width="59" height="20" align="absmiddle" border="0"></a>
    </td>
    <td width="140" class="FieldLabel"><%=_i18n.get("global.cpa.id")%></td>
    <td width="240" class="FieldData">
      <input name="cpa_id" type="text" class="FormTextReadOnly" readonly value="<%=vo.getCpaId()%>" size="32"></td>
  </tr>

  <!-- Party선택, 유효기간 -->
  <tr>
    <td class="FieldLabel"><%=_i18n.get("global.cpa.party.role")%></td>
    <td width="260" class="FieldData">
<%
      for (Iterator i = cpa.getPartyIds(); i.hasNext();) {
      PartyInfo pinfo = (PartyInfo)i.next();
      party_name = pinfo.getPartyName();
%>
      <input type="radio" name="party_name" id="party_1" value="<%=party_name %>" ><%=party_name%>&nbsp;&nbsp;
<%
}
%>
    <td width="120" class="FieldLabel"><%=_i18n.get("global.cpa.lifetime")%></td>
    <td width="260" class="FieldData">
      <input name="valid_start" type="text" class="FormTextReadOnly" readonly id="valid_start" value="<%=sd.format(vo.getCpa().getStart())%>" size="9">
      ~
      <input name="valid_end" type="text" class="FormTextReadOnly" readonly id="valid_end" value="<%=sd.format(vo.getCpa().getEnd())%>"></td>
  </tr>

  <tr>
    <td class="FieldLabel"><%=_i18n.get("global.cpa.status")%></td>
    <td class="FieldData">
      <input name="cpa_status" type="text" id="cpa_status" class="FormTextReadOnly" readonly size="32" value="<%=vo.getCpa().getStatus()%>">
    </td>
    <td class="FieldLabel"><%=_i18n.get("global.cpa.description")%> </td>
    <td class="FieldData">
      <input name="cpa_description" type="text" class="FormText" size="32" id="cpa_description" value="<%=cpa_description%>"></td>
  </tr>
   <!-- Keystore -->
   <tr>
      <td class="FieldLabel"><%=_i18n.get("cpa10ms001.keystore.name")%>
      </td>
      <td class="FieldData">
      <select name="keystore" id="keystore" class="FormSelect">
        <option value=""><%=_i18n.get("cpa10ms001.select.keystore")%></option>
<%
        int keystoreSize = keystores.size();
        if (keystoreSize > 0) {
        	for (int i = 0; i < keystoreSize; i++) {
        		SecurityKeyStoreVO svo = (SecurityKeyStoreVO) keystores.get(i);
%>
		<option value="<%=svo.getObid()%>"><%=svo.getName()%></option>
<%
        	}
        }
%>
      </select>
      </td>
      <td class="FieldLabel"><%=_i18n.get("global.agreement.storage.type")%></td>
      <td class="FieldData">
      	<input type="radio" name="storage_type" value="<%=MxsConstants.AGREEMENT_STORAGE_TYPE_FILE %>" checked><%=_i18n.get("global.agreement.storage.type.file")%>
      	&nbsp;&nbsp;&nbsp;&nbsp;
      	<input type="radio" name="storage_type" value="<%=MxsConstants.AGREEMENT_STORAGE_TYPE_DB %>"><%=_i18n.get("global.agreement.storage.type.db") %>
      </td>
   </tr>
</table>

<!-- 버튼테이블 -->
<table class="TableLayout" >
  <tr>
    <td align="right" style="padding-top:15">
      <a href="cpa20ms001.jsp"><img src="images/btn_big_list.gif" width="39" height="23" border="0"> </a>
      <a href="javascript:insertCPA()"><img src="images/btn_big_create.gif" width="39" height="23" border="0"></a>
  </tr>
</table>
</form>
</body>
</html>
