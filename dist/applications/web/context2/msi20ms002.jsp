<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.ebms.EbConstants" %>
<%
/**
 * @author Gemini Kim
 * @author Ho-Jin Seo
 * @version 1.0
 */
%>
<html>
<head>
<%@ include file="com00in000.jsp" %>
<%@ include file="./com00in003.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>
<script language="JavaScript" type="text/JavaScript">
<!--

function appTypeChange(obj, id) {	
	var val = obj.options[obj.selectedIndex].value;
    var display = document.getElementById(id).style.visibility;

    if (val==<%=EbConstants.APP_REMOTE_PERFORMER%>) { 	
    	alert("<%=_i18n.get("msi20ms902.alert.msg")%>");
	    document.getElementById(id).style.visibility = 'hidden';
 	    document.getElementById(id).value = "";
 	    document.getElementById(id).readOnly = true;
    	
    } else if (val==<%=EbConstants.APP_CONSUMEER_QUEUE%>) {
 	      document.getElementById(id).style.visibility = 'visible';
 	      
    } else {
	      document.getElementById(id).style.visibility = 'hidden';
 	      document.getElementById(id).value = "";
 	      document.getElementById(id).readOnly = true;
    }
}

function openChannelList(obid) {
     window.open("msi20pu101.jsp?performer.obid="+obid,"channel","width=630,height=620,left=0,top=0,resizable=yes,scrollbars=yes");
}

function insertPerformer() {

/*
   var subscriberName = this.document.form1.subscriberName.value;
	if(subscriberName == null || subscriberName == '') {
	   msg = "<%=_i18n.get("cpa20ms001.non.selected")%>";
      msg = "수행자이름을 입력하세요.!";
	   openAlert(msg, "<%=_i18n.get("global.alert")%>", "<%=_i18n.get("global.ok")%>");
	} else {
		msg = "<%=_i18n.get("cpa20ms001.delete.confirm")%>";
      msg = "수행자[" + subscriberName + "]를 등록하시겠습니까 ?";
		var bChoice = openConfirm(msg, insertFunction, null, "<%=_i18n.get("global.warning")%>");
	}
*/
   insertFunction();

}

function insertFunction() {
   closeInfo();

   var params = Form.serialize(document.form1);
   var opt = {
      method: 'post',
      parameters: params,
      onSuccess: function(t) {
		  $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("msi20ms002.saved") %>';
         setTimeout(searchList, 1000);
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
   var myAjax = new Ajax.Request("msi30ac001.jsp", opt);

}

function getList() {

   loading();

   var params = Form.serialize(document.form1);
   var opt = {
      method: 'post',
      parameters: params,
      onSuccess: showList,
       on404: function(t) {
           $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("err00zz404.message") %>';
           showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
       },
       onFailure: function(t) {
           $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("global.error.retry") %>';
           showErrorPopup(t.responseText, null, null, null);
       }
   }

   var myAjax = new Ajax.Request("msi20ac002.jsp", opt);
}

function searchList(page) {
   if (page == null || page == "") {
       page = 1;
   }

   $('curPage').value = page;
   $('messageDisplay').innerHTML = '';
   var params = Form.serialize(document.form2);

   getList();
}

function getHeader() {
	var body = "";
   //<!-- CPA 목록 : [서비스] [액션] [유형] [수행자]  -->
   body += '<table class="TableLayout">';
   body += '   <col width="" >';
   body += '   <col width="">';
   body += '   <col width="" align="center">';
   body += '   <col width="" align="center">';
   body += '   <tr>';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.cpa.service.name")%></td>';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.cpa.action.name")%></td>';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.perfomer.type")%></td>';
   body += '      <td class="ResultLastHeader"><%=_i18n.get("global.perfomer.name")%></td>';
   body += '   </tr>';

	return body;
}

function loading() {
   var body = "";

   body += getHeader();

   body += '   <tr>';
   body += '      <td align="center" class="ResultLastData" colspan="4"><%= _i18n.get("global.loading")%></td></tr>';
   body += "</table>";


   $('listContent').innerHTML = body;

}

function showList(originalRequest) {

   var res = eval("(" + originalRequest.responseText + ")");

   var operations = "";
   var performers = "";
   var body = "";

   body += getHeader();

   for (var i=0; i<res.list.length; i++) {
      body += '   <tr>';
      body += '      <td class="ResultData">'+res.list[i].service+'</td>';
      body += '      <td class="ResultData">'+res.list[i].action+' </td>';
      body += '      <td class="ResultData">';
      body += '         <select name = "performer.type" class="FormSelect"  onChange="javascript:appTypeChange(this, \''+res.list[i].performObid+'_ch\')">';
      body += '            <option value = "<%=EbConstants.APP_PERFORMER %>" '+res.list[i].perform_selected +'><%=_i18n.get("msi20ms902.colhead.3")%> </option>';
      body += '            <option value = "<%=EbConstants.APP_CONSUMEER_QUEUE %>"'+res.list[i].channel_selected +'><%=_i18n.get("msi20ms902.colhead.5")%> </option>';
      body += '            <option value = "<%=EbConstants.APP_REMOTE_PERFORMER %>"'+res.list[i].remote_selected +'><%=_i18n.get("msi20ms902.performer.type.remote")%> </option>';
      body += '         </select>';
      body += '      </td>';
      body += '      <td class="ResultLastData" align="left">';
      body += '         <input type="text" name="performer.name" id="'+res.list[i].performObid+'_performer.name" class="FormText" value="'+res.list[i].performName+'" size=40>';
      body += '            <div id="'+res.list[i].performObid+'_ch" style="visibility:'+res.list[i].visible+'; position=absolute;">';
      body += '               <a href="javascript:openChannelList(\''+res.list[i].performObid+'\')">';
      body += '                  <img src="images/btn_channel.gif" valign="middle" border="0">';
      body += '            </div>';
      body += '      </td>';
      body += '   </tr>';
      body += '';
      body += '      <input type="hidden" name="service.name"               value="'+res.list[i].service+'">';
      body += '      <input type="hidden" name="action.name"                value="'+res.list[i].action+'">';
      body += '      <input type="hidden" name="servicebinding.obid"        value="'+res.list[i].serviceObid+'">';
      body += '      <input type="hidden" name="action.obid"                value="'+res.list[i].actionObid+'">';
      body += '      <input type="hidden" name="cpa.obid"                   value="'+res.list[i].cpaObid+'">';
      body += '      <input type="hidden" name="cpa.id"                     value="'+res.list[i].cpaid+'">';
      body += '      <input type="hidden" name="channel.obid"   id="'+res.list[i].performObid+'_channel.obid" value="'+res.list[i].channelObid+'">';
   }

   if (res.list.length == 0) {
      body += '<tr >';
        body += '<td align="center" class="ResultLastData" colspan="4"><%= _i18n.get("msi20ms002.notfound")%></td></tr>';
   }

   body += "</table>";


   $('listContent').innerHTML = body;

   $('cpa.id').value   = res.cpaid;
   $('cpa.name').value = res.cpaName;
   $('cpa.role').value = res.cpaRole;

//   $('row_size').innerHTML = res.totalRows;
   $('pagelist').innerHTML = res.pagelist;
}

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

<!-- <!-- 수행자 CPA 기본정보 : CPA이름, CPD아이디, 수행역할 -->
<table class="FieldTable">
  <tr>
    <td width="120" class="FieldLabel"><%=_i18n.get("global.cpa.name")%></td>
    <td width="260" class="FieldData">
      <input name="cpa.name" id="cpa.name" type="text" class="FormTextReadOnly" readonly value="" size="32">
    </td>
    <td width="120" class="FieldLabel"><%=_i18n.get("global.cpa.id")%></td>
    <td width="260" class="FieldData">
      <input name="cpa.id" id="cpa.id" type="text" class="FormTextReadOnly" readonly value="" size="45"></td>
  </tr>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("global.cpa.party.role")%></td>
    <td colspan="3" class="FieldData">
      <input name="cpa.role" id="cpa.role" type="text" class="FormTextReadOnly" readonly value="" size="32">
    </td>
  </tr>
</table>

<!-- 수행자 목록  -->

<form name="form1" method="post">
<input type="hidden" name="cpa.obid" value="<%=request.getParameter("cpa.obid")%>">
<input type="hidden" name="curPage" id="curPage" value="1">

<table>
   <!-- 리스트  -->
   <tr>
      <td>
         <div id="listContent"></div>
                  <script>
                  getList();
                  </script>
      </td>
   </tr>
</table>

<!-- <!-- 하단 메뉴 : 목록 / 저장 / 페이징  -->
<table class="PageNavigationTable" >
  <tr>
    <td width="50%"  align="left"> <!--
      <table cellpadding="0" cellspacing="0" border="0">
        <tr>
          <td><a href="#"><img src="images/btn_first.gif" border="0"  class="btn_first" /></a></td>
          <td><a href="#"><img src="images/btn_prev.gif" border="0" class="btn_prev" /></a></td>
          <td class="listAPaging">
            <span class="gray-text02" id="pagelist"></span></td>
          <td><a href="#"><img src="images/btn_next.gif" border="0"  class="btn_next" /></a></td>
          <td><a href="#"><img src="images/btn_last.gif" border="0"  class="btn_last" /></a></td>
        </tr>
      </table></td>-->
    <td width="50%"  align="right">
      <a href="msi20ms001.jsp"><img src="images/btn_big_list.gif" width="39" height="23" border="0"></a>
      <a href="javascript:insertPerformer()"><img src="images/btn_big_save.gif" width="39" height="23" border="0"></a>
    </td>
  </tr>
</table>

</form>

</body>

</html>
