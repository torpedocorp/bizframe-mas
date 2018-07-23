<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="kr.co.bizframe.mxs.ebms.EbConstants"%>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%@ page import="kr.co.bizframe.mxs.ebms.model.cpa.CPA"%>
<%@ page import="kr.co.bizframe.mxs.ebms.model.cpa.PartyInfo"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.CpaVO"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.mxs.dto.SecurityKeyStoreVO"%>
<%@ page import="kr.co.bizframe.mxs.MxsConstants" %>
<%
 /**
 * @author Gemini Kim
 * @author Ho-Jin Seo
 * @author Mi-Young Kim
 * @version 1.0
 */

   String command = request.getParameter("command");
   // 변경내역_29 on 2008.06.25 by Mi-Young Kim
   command = (command == null ? "updateInfo" : command);
   String cpa_obid   = request.getParameter("cpa.obid");
   CPA cpa = null;
   CpaVO cpaVO = null;
   MxsEngine engine = MxsEngine.getInstance();

   // cpa리스트에서 파일 등록한 경우
   if ("update".equalsIgnoreCase(command)) {
	   cpaVO = (CpaVO) session.getAttribute("cpaVO");
	   if (cpaVO == null) {
%>
			<script>
				location.href="cpa20ms001.jsp?command=error&msg=cpa21ms001.cpa.file.empty";
			</script>
<%
	   }
	   cpa = cpaVO.getCpa();
   }
   // cpa리스트에서 상세보기 클릭 경우
   if (cpa == null) {
	   try {
		   // get Data
		   QueryCondition qc = new QueryCondition();
		   qc.add("obid", cpa_obid);
		   qc.setQueryLargeData(true);
		   cpaVO = (CpaVO) engine.getObject("Cpa", qc, DAOFactory.EBMS);
		   cpa = new CPA(cpaVO.getContent().toByteArray());

	   } catch (Exception e) {
		   e.printStackTrace();
%>
			<script>
				location.href="cpa20ms001.jsp?command=error&msg=cpa21ms001.cpa.file.empty";
			</script>
<%
	   return;
	   }
   }

   int status = cpaVO.getStatus();
   String statusStr = "";

   if (status == EbConstants.CPA_STATUS_AGREED)
      statusStr = "agreed";
   else if (status == EbConstants.CPA_STATUS_SIGNED)
      statusStr = "signed";
   else if (status == EbConstants.CPA_STATUS_PROPOSED)
      statusStr = "proposed";

   java.util.Date start = cpaVO.getLifetimeStart();
   java.util.Date end   = cpaVO.getLifetimeEnd();
   SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

   int party_num = 0;
   String party_1_name = "";
   boolean party_1_selected = false;
   String party_2_name = "";
   boolean party_2_selected = false;
   boolean storageType_file = true;
   boolean storageType_db = false;

   if (cpaVO.getStorageType() == MxsConstants.AGREEMENT_STORAGE_TYPE_DB) {
	   storageType_db = true;
	   storageType_file = false;

   } else {
	   storageType_db = false;
	   storageType_file = true;
   }

   for (Iterator i = cpa.getPartyIds(); i.hasNext();) {
      PartyInfo pinfo = (PartyInfo)i.next();
      String partyName = pinfo.getPartyName();
      boolean checked   = true;

      if(cpaVO.getPartyName().equals(partyName)) checked = true;
      else checked = false;

      if(party_num == 0) {
         party_1_name = partyName;
         party_1_selected = checked;
      }else {
         party_2_name = partyName;
         party_2_selected = checked;
      }
      party_num++;
   }

   // get Keystores
   String keystore = cpaVO.getKeyStoreObid();
   QueryCondition qc = new QueryCondition();
   ArrayList keystores = engine.getObjects("SecurityKeyStore",  qc, DAOFactory.COMMON);

%>
<html>
<head>
<%@ include file="./com00in000.jsp" %>
<%@ include file="./com00in003.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>
<script language="JavaScript" type="text/JavaScript">
<!--
function downCPA() {
   frm = document.cpaDetailForm;
   frm.action = "cpa50ac001.jsp";
   frm.method = "post";
   frm.submit();
}

function viewCPA() {
   var obid = this.document.getElementById('cpa.obid').value;
   window.open("cpa22ac001.jsp?obid=" + obid, "CPA", "width=1010,height=800,left=0,top=0,resizable=yes,scrollbars=yes");
}

function viewPerformer() {
   var obid = this.document.getElementById('cpa.obid').value;
   var url  = 'msi20ms002.jsp?cpa.obid='+obid;
   location.href = url;
}

function nameCheck() {

   $('messageDisplay').innerHTML = '';
   check_name = $('cpa_name').value;

   if(check_name == null || check_name == '') {
      $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("cpa10ms001.cpaname.nullcheck") %>';
      alert('<%=_i18n.get("cpa10ms001.cpaname.nullcheck") %>');
      return;
   }

   if ($('cpa_name_old').value == check_name) {
   		dupCheckResult(check_name, "true");
   		return;
   }

   var params = Form.serialize(document.cpaDetailForm);
   var opt = {
      method: 'post',
      parameters: params,
      asynchronous: false,
      onSuccess: function(t) {
	      var res = eval("(" + t.responseText + ")");
      		dupCheckResult(res.name, res.can_use);
      },
       on404: function(t) {
           $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("err00zz404.message") %>';
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
   var dupflag_result = document.getElementById("dupflag_result");
   dupflag_result.value = result;
   var dupflag_value = document.getElementById("dupflag_value");
   dupflag_value.value = check_name;
   if(result == 'true') {
      alert('<%=_i18n.get("cpa10ms001.cpaname.use") %>');
      return true;
   }
   else {
      alert('<%=_i18n.get("cpa10ms001.cpaname.nouse") %>');
      return false;
   }
}

function showDupFlag() {
   var dup_flag = document.getElementById("dupflag_id");
   alert(dup_flag.value);
}

function updateCpa() {

   $('messageDisplay').innerHTML = '';

   var _req_cpa_name    = document.cpaDetailForm.cpa_name.value;
   var _check_cpa_name  = document.getElementById("dupflag_value").value;
   if(_req_cpa_name != _check_cpa_name) {
      $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("cpa21ms001.duplicate.check.confirm") %>';
      alert('<%=_i18n.get("cpa21ms001.duplicate.check.confirm") %>');
      return;
   } else {
      dupflag_result = document.getElementById("dupflag_result").value;
      if(dupflag_result != 'true') {
         $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("cpa21ms001.duplicate.check.confirm") %>';
         alert('<%=_i18n.get("cpa21ms001.duplicate.check.confirm") %>');
         return ;
      }
   }

   var params = Form.serialize(document.cpaDetailForm);
   var opt = {
      method: 'post',
      parameters: params,
       onSuccess: function(t) {
         $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("cpa21ms001.operation.update") %>';
         timeout=2; setTimeout(goList, 1000);
       },
       on404: function(t) {
           $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("err00zz404.message") %>';
           showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
       },
       onFailure: function(t) {
           $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("global.error.retry") %>';
           showErrorPopup(t.responseText, null, null, null);
       }
   }

   var myAjax = new Ajax.Request("cpa30ac001.jsp", opt);

}

function deleteCpa() {

   $('messageDisplay').innerHTML = '';

   var params = Form.serialize(document.cpaDetailForm);
   var opt = {
      method: 'post',
      parameters: params,
       onSuccess: function(t) {
         $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("cpa21ms001.operation.delete") %>';
         timeout=1; setTimeout(goList, 1000);
       },
       on404: function(t) {
           $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("err00zz404.message") %>';
           showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
       },
       onFailure: function(t) {
           $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("global.error.retry") %>';
           showErrorPopup(t.responseText, null, null, null);
       }
   }

   var myAjax = new Ajax.Request("cpa40ac001.jsp", opt);

}

function initialize() {

   $('cpa_name').value          = '<%=cpaVO.getCpaName()%>';
   $('cpa_name_old').value      = '<%=cpaVO.getCpaName()%>';
   $('cpa_id').value            = '<%=cpaVO.getCpaId()%>';

   $('cpa_status').value        = '<%=statusStr%>';
   $('valid_start').value       = '<%=sdf.format(start)%>';
   $('valid_end').value         = '<%=sdf.format(end)%>';
   $('cpa_description').value   = '<%=StringUtil.nullCheck(cpaVO.getDescription())%>';

   $('party_1').value = '<%=party_1_name%>';
   $('party_2').value = '<%=party_2_name%>';
   $('party_1').checked = <%=party_1_selected%>;
   $('party_2').checked = <%=party_2_selected%>;
   $('party_1_name').innerHTML = '<%=party_1_name%>';
   $('party_2_name').innerHTML = '<%=party_2_name%>';

   $('dupflag_value').value = '<%=cpaVO.getCpaName()%>';
   $('dupflag_result').value = 'true';

   $('storage_type_file').checked = <%=storageType_file%>;
   $('storage_type_db').checked = <%=storageType_db%>;

}

function goList() {
	timeout--;
	if (timeout >0) {
		setTimeout(goList, 1000) ;
	} else {
		location.href = "cpa20ms001.jsp";
	}
}


window.onload = initialize;
//-->
</script>
</head>

<body bgcolor=#FFFFFF leftmargin=0 topmargin=0 marginwidth=0 marginheight=0>

<form name="cpaDetailForm" method="post" >

<input type="hidden" name="dupflag_result"  id="dupflag_result"  value="">
<input type="hidden" name="dupflag_value" id="dupflag_value"   value="">
<input type="hidden" name="cpa.obid" id="cpa.obid" value="<%=cpa_obid%>">

<input type="hidden" name="curPage" id="curPage" value="1">
<input type="hidden" name="command" id="commannd" value="<%=command%>">
<!-- 제목테이블 -->
<table class="TableLayout">
  <tr>
    <td width="150" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.cpa.detail")%></td>
    <td width="610" class="MessageDisplay"> <div id=messageDisplay>&nbsp;</div></td>
  </tr>
  <tr>
    <td colspan="2" height="10"></td>
  </tr>
</table>

<!-- 정보 테이블-->
<table class="FieldTable">
  <tr>
    <td width="130" class="FieldLabel"><%=_i18n.get("global.cpa.name")%> </td>
    <td width="250" class="FieldData">
      <input name="cpa_name" id="cpa_name" type="text" class="FormText" value="" size="25">
      <a href="javascript:nameCheck(this.form)"><img src="images/btn_checkunique.gif" width="59" height="20" align="absmiddle" border="0"></a>
      <input name="cpa_name_old" id="cpa_name_old" type="hidden">
    </td>
    <td width="140" class="FieldLabel"><%=_i18n.get("global.cpa.id")%></td>
    <td width="240" class="FieldData">
      <input name="cpa_id" id="cpa_id" type="text" class="FormTextReadOnly" readonly value="" size="32"></td>
  </tr>

  <tr>
    <td class="FieldLabel"><%=_i18n.get("global.cpa.party.role")%></td>
    <td width="260" class="FieldData">
      <input type="radio" name="cpa_party" id="party_1" value="" ><span id="party_1_name"></span>&nbsp;&nbsp;
      <input type="radio" name="cpa_party" id="party_2" value="" ><span id="party_2_name"></span>&nbsp;&nbsp;</td>
    <td width="120" class="FieldLabel"><%=_i18n.get("global.cpa.lifetime")%></td>
    <td width="260" class="FieldData">
      <input name="valid_start" type="text" class="FormTextReadOnly" readonly id="valid_start" value="" size="9">
      ~
      <input name="valid_end" type="text" class="FormTextReadOnly" readonly id="valid_end" value=""></td>
  </tr>

  <tr>
    <td class="FieldLabel"><%=_i18n.get("global.cpa.status")%></td>
    <td class="FieldData">
      <input name="cpa_status" type="text" id="cpa_status" class="FormTextReadOnly" readonly size="32" value="">
    </td>
    <td class="FieldLabel"><%=_i18n.get("global.cpa.description")%> </td>
    <td class="FieldData">
      <input name="cpa_description" type="text" class="FormText" size="32" id="cpa_description" value=""></td>
  </tr>


  <tr>
    <td class="FieldLabel"><%=_i18n.get("cpa10ms001.keystore.name")%></td>
    <td class="FieldData">
      <select name="keystore" id="keystore" class="FormSelect">
        <option value=""><%=_i18n.get("cpa10ms001.keystore.select")%></option>
<%
        int keystoreSize = keystores.size();
        if (keystoreSize > 0) {
        	for (int i = 0; i < keystoreSize; i++) {
        		SecurityKeyStoreVO vo = (SecurityKeyStoreVO) keystores.get(i);
%>
		<option value="<%=vo.getObid()%>" <%if (vo.getObid().equals(keystore)) out.println("selected"); %>><%=vo.getName()%></option>
<%
        	}
        }
%>
      </select>
    </td>
    <td class="FieldLabel"><%=_i18n.get("cpa21ms001.cpa.performer")%></td>
    <td class="FieldData">
      <a href="javascript:viewPerformer()"><img src="images/btn_ok.gif" width="37" height="20" align="absmiddle" border="0"></a></td>
  </tr>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("global.agreement.storage.type")%></td>
    <td class="FieldData">
      	<input type="radio" name="storage_type" id="storage_type_file" value="<%=MxsConstants.AGREEMENT_STORAGE_TYPE_FILE %>" checked><%=_i18n.get("global.agreement.storage.type.file")%>
      	&nbsp;&nbsp;&nbsp;&nbsp;
      	<input type="radio" name="storage_type" id="storage_type_db" value="<%=MxsConstants.AGREEMENT_STORAGE_TYPE_DB %>"><%=_i18n.get("global.agreement.storage.type.db") %>
    </td>
    <td class="FieldLabel"><%=_i18n.get("global.cpa.file")%> *</td>
    <td class="FieldData"><img src="images/xml.gif" width="39" height="20">
      <a href="javascript:viewCPA(this.form)"><img src="images/btn_inview.gif" width="39" height="13" align="absmiddle" border="0" style="cursor:hand;"> </a>
      <a href="javascript:downCPA(this.form)"><img src="images/btn_indown.gif" width="62" height="13" align="absmiddle" border="0" style="cursor:hand;"> </a>
    </td>
  </tr>
</table>

<!-- 버튼테이블 -->
<table class="TableLayout" >
  <tr>
    <td align="right" style="padding-top:15">
      <a href="cpa20ms001.jsp"><img src="images/btn_big_list.gif" width="39" height="23" border="0"> </a>
      <a href="javascript:updateCpa()"><img src="images/btn_big_change.gif" width="39" height="23" border="0"></a>
      <a href="javascript:deleteCpa()"><img src="images/btn_big_delete.gif" width="39" height="23" border="0"></a></td>
  </tr>
</table>

</form>



</body>
</html>
