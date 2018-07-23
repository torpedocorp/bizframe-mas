<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.ebms.EbConstants" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.common.MxsObject" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.Eb3Constants" %>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.AppPerformerVO" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.pmode.PMode" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.pmode.PModeLeg" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%
/**
 * PMode MSI 설정
 * @author Ho-Jin Seo 2008.10.30
 * @author Mi-Young Kim
 * @version 1.0
 */
%>
<html>
<head>
<%@ include file="com00in000.jsp" %>
<%@ include file="./com00in003.jsp" %>
<%
String obid = request.getParameter("obid");
String legType = "";

MxsEngine engine = MxsEngine.getInstance();
QueryCondition qc = new QueryCondition();
qc.add("obid", obid);
MxsObject pmodeObj = engine.getObject("PMode", qc, DAOFactory.EBMS3);
if (pmodeObj == null) {
%>
<script>
	alert("<%=_i18n.get("global.error.retry")%>");
	location.href="msi20ms301.jsp";
</script>
<%
}

PMode pmode = (PMode)pmodeObj.getExtension(Eb3Constants.MXSOBJ_EXTENSION_PMODE);
%>
<title><%=_i18n.get("global.page.title")%></title>
<script language="JavaScript" type="text/JavaScript">
<!--
function initialize() {
	// pmode 정보 셋팅
	$('pmode.name').value = "<%=pmode.getDisplayName()%>";
	$('pmode.id').value = "<%=pmode.getId()%>";
	$('pmode.ref').value = "<%= pmode.getAgreement()%>";
	$('pmode.mep').value = "<%= Eb3Constants.PModeMepString[pmode.getMep()]%>";
	$('pmode.binding').value = "<%= Eb3Constants.PModeMepBindingString[pmode.getMepbinding()]%>";
	if (<%= pmode.getMyRole()%> == 0) {
		$('pmode.myrole').value = "<%= _i18n.get("pmd10ms001.role.initiator") %>"
	}
	else {
		$('pmode.myrole').value = "<%= _i18n.get("pmd10ms001.role.responder") %>"
	}
}

function appTypeChange(id) {
	$(id + '_performer.name').value = "";
	$(id + '_channel.obid').value = "";
	displayType(id);
}

function displayType(id) {
	if ($('performer.type').value == 0) {
		$(id + "_ch").style.visibility = 'hidden';
		$(id + "_ch").style.readOnly = true;
	} else {
		$(id + "_ch").style.visibility = 'visible';
	}
}

function openChannelList(obid) {
     window.open("msi20pu101.jsp?performer.obid="+obid,"channel","width=630,height=620,left=0,top=0,resizable=yes,scrollbars=yes");
}

function insertPerformer() {
   closeInfo();

   var params = Form.serialize(document.form1);
   var opt = {
      method: 'post',
      parameters: params,
      onSuccess: function(t) {
		  $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("msi20ms002.saved") %>';
         searchList(1);
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
   var myAjax = new Ajax.Request("msi30ac301.jsp", opt);
}

window.onload = initialize;

//-->
</script>
</head>
<body bgcolor=#FFFFFF leftmargin=0 topmargin=0 marginwidth=0 marginheight=0>

<!-- 제목테이블 :수행자 설정 -->
<table class="TableLayout">
  <tr>
    <td width="160" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.msi.setting")%></td>
    <td width="600" class="MessageDisplay" ><div id=messageDisplay>&nbsp;</div></td>
  </tr>
  <tr>
    <td colspan="2" height="10"></td>
  </tr>
</table>

<!-- 수행자 기본정보 -->
<table class="FieldTable">
  <tr>
    <td width="120" class="FieldLabel"><%=_i18n.get("pmd20ms001.column.name")%></td>
    <td width="260" class="FieldData" colspan="3">
      <input name="pmode.name" id="pmode.name" type="text" class="FormTextReadOnly" readonly value="" size="45">
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%=_i18n.get("pmd20ms001.column.id")%></td>
    <td width="260" class="FieldData" colspan="3">
      <input name="pmode.id" id="pmode.id" type="text" class="FormTextReadOnly" readonly value="" size="45"></td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%=_i18n.get("pmd10ms001.column.agreement")%></td>
    <td width="260" class="FieldData" colspan="3">
      <input name="pmode.ref" id="pmode.ref" type="text" class="FormTextReadOnly" readonly value="" size="45"></td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%=_i18n.get("pmd10ms001.column.mep")%></td>
    <td width="260" class="FieldData">
      <input name="pmode.mep" id="pmode.mep" type="text" class="FormTextReadOnly" readonly value="" size="45"></td>
    <td width="120" class="FieldLabel"><%=_i18n.get("pmd10ms001.column.mepbinding")%></td>
    <td width="260" class="FieldData">
      <input name="pmode.binding" id="pmode.binding" type="text" class="FormTextReadOnly" readonly value="" size="45"></td>
  </tr>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("pmd10ms001.column.myrole")%></td>
    <td colspan="3" class="FieldData">
      <input name="pmode.myrole" id="pmode.myrole" type="text" class="FormTextReadOnly" readonly value="" size="45">
    </td>
  </tr>
</table>

<!-- 수행자 목록  -->
<br/>
<form name="form1" method="post">

<table class="TableLayout">
   <col width="" >
   <col width="" >
   <col width="">
   <col width="" align="center">
   <col width="" align="center">
   <tr>
   <td class="ResultHeader">LEG</td>
   <td class="ResultHeader"><%=_i18n.get("global.cpa.service.name")%></td>
   <td class="ResultHeader"><%=_i18n.get("global.cpa.action.name")%></td>
   <td class="ResultHeader"><%=_i18n.get("global.perfomer.type")%></td>
   <td class="ResultLastHeader"><%=_i18n.get("global.perfomer.name")%></td>
   </tr>
<%
	AppPerformerVO performerVO = null;
	PModeLeg leg = null;
	if (pmode.getMyRole() == Eb3Constants.PMODE_MYROLE_INITIATOR) {
		leg = pmode.getLeg(1, "u");
		legType = "LEG[1][u]";
		if (leg == null) {
			leg = pmode.getLeg(2, null);
			legType = "LEG[2]";
		}
		if (leg == null) {
			leg = pmode.getLeg(2, "u");
			legType = "LEG[2][u]";
		}
	} else {
		leg = pmode.getLeg(1, null);
		legType = "LEG[1]";
		if (leg == null) {
			leg = pmode.getLeg(2, null);
			legType = "LEG[2]";
		}
	}
	if (leg != null) {
		qc = new QueryCondition();
		qc.add("action_obid", leg.getObid());
		performerVO = (AppPerformerVO)engine.getObject("AppPerformer", qc, DAOFactory.EBMS);
		String legObid = leg.getObid();
%>
   <input type="hidden" name="action.obid" id="action.obid" value="<%=legObid%>">
   <tr>
         <td class="ResultData"><%=legType %></td>
         <td class="ResultData"><%=leg.getService() %></td>
         <td class="ResultData"><%=leg.getAction() %></td>
         <td class="ResultData">
            <select name = "performer.type" id="performer.type" class="FormSelect"  onChange="javascript:appTypeChange('pmode')">
               <option value = "<%=EbConstants.APP_PERFORMER %>">수행자 </option>
               <option value = "<%=EbConstants.APP_CONSUMEER_QUEUE %>">큐 </option>
            </select>
         </td>
         <td class="ResultLastData" align="left">
            <input type="text" name="performer.name" id="pmode_performer.name" class="FormText" size=50>
               <span id="pmode_ch" style="position=absolute;">
                  <a href="javascript:openChannelList('pmode')">
                     <img src="images/btn_channel.gif" valign="middle" border="0">
               </span>
         </td>
    </tr>
<%
	} else {
%>
	<tr><td colspan="5" class="ResultLastData" align="center"><%= _i18n.get("msi20ms002.notfound")%></td></tr>
<%
	}
%>
	<input type="hidden" name="channel.obid" id="pmode_channel.obid">
   </table>
<script>
<%if (performerVO != null) { %>

$('performer.type').value = "<%=performerVO.getAppType()%>";
$('pmode_performer.name').value = "<%= StringUtil.checkNull(performerVO.getPerformerName())%>";
$('pmode_channel.obid').value = "<%=StringUtil.nullCheck(performerVO.getQueueObid())%>";
displayType('pmode');
<%
} else {
%>
appTypeChange('pmode');
<%
}
%>
</script>

<!-- 하단 메뉴 : 목록 / 저장 / 페이징  -->
<table class="PageNavigationTable" >
  <tr>
    <td width="50%"  align="left">
    <td width="50%"  align="right">
      <a href="msi20ms301.jsp"><img src="images/btn_big_list.gif" width="39" height="23" border="0"></a>
      <a href="javascript:insertPerformer()"><img src="images/btn_big_save.gif" width="39" height="23" border="0"></a>
    </td>
  </tr>
</table>
</form>
</body>
</html>
