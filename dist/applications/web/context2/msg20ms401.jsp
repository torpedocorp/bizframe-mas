<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="kr.co.bizframe.mxs.ebms.EbConstants"%>
<%@ page import="kr.co.bizframe.mxs.MxsConstants" %>
<%
/**
 * List Eb3SignalMessage
 *
 * @author Mi-Young Kim
 * @version 1.0 2008.09.02
 */
String itemSet[]= {"5","10","20","30","50","100"};
String pageSet[]= {"5","10","15","20"};//,"30","40","50"};

Date today = new Date(System.currentTimeMillis());

SimpleDateFormat sdf  = new SimpleDateFormat("yyyy-MM-dd");
String strFromDate = sdf.format(today);
String strToDate = sdf.format(today);
%>
<html>
<head>
<%@ include file="./com00in000.jsp" %>
<%@ include file="./com00in001.jsp" %>
<%@ include file="./com00in003.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>
<script language="JavaScript" type="text/JavaScript">
<!--
function initialize() {
/*
   dhtmlHistory.initialize();
   dhtmlHistory.addListener(historyChange);
   if (dhtmlHistory.isFirstLoad()) {
      var params = Form.serialize(document.form1);
      dhtmlHistory.add((new Date()).toString(), params);
   }
*/
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

function deleteFunction() {
   Windows.closeAllModalWindows();
   var params = Form.serialize(document.form1);
   var opt = {
      method: 'post',
      parameters: params,
      onSuccess: function(t) {
         $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%= _i18n.get("msg20ms001.message.deleted") %>';
         searchMessage(1);
      },
       on404: function(t) {
           $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("err00zz404.message") %>';
        //   showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
       },
       onFailure: function(t) {
           $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("global.error.retry") %>';
           showErrorPopup(t.responseText, null, null, null);
       }
   }
   var myAjax = new Ajax.Request("msg40ac401.jsp", opt);
}

function getSelectedId_Index() {
   var inputs = document.getElementsByTagName('input');
   var id_Index = "" ;
   var selCnt = 0;
   for (var i = 0; i < inputs.length; i++) {
     if (inputs[i].type == 'checkbox' && inputs[i].checked==true && inputs[i].name != 'allChkBtn')
     {
        id_Index = inputs[i].value;
        selCnt++;
     }
   }
   return id_Index;
}

function deleteMessage() {
   var check_index = getSelectedId_Index();
   if(check_index == null || check_index == '') {
      msg = "<%=_i18n.get("msg20ms001.non.selected")%>";
      openAlert(msg, "<%=_i18n.get("global.alert")%>",
            "<%=_i18n.get("global.ok")%>");
   } else {
      msg = "<%=_i18n.get("msg20ms001.delete.confirm")%>";
      openConfirm(msg, deleteFunction, null, "<%=_i18n.get("global.warning")%>");
   }
}

function getHeader() {
	var body = "";
	body += '<table class="TableLayout" style="table-layout: fixed">';
	body += '  <COLGROUP>';
	body += '  <COL span="1" style="width:40;">';
	body += '  <COL span="1" style="width:80;">';
	body += '  <COL span="1" style="width:120;">';
	body += '  <COL span="1" style="width:200;">';
	body += '  <COL span="1" style="width:120;">';
	body += '  <COL span="1" style="width:120;">';
	body += '  <COL span="1" style="width:30;">';
	body += '  </COLGROUP>';
	body +='<tr>';
	body +='  <td class="ResultHeader"><%= _i18n.get("msg20ms001.list.inout") %></td>';
	body +='  <td class="ResultHeader"><%= _i18n.get("msg20ms401.list.type") %></td>';
	body +='  <td class="ResultHeader"><%= _i18n.get("msg20ms001.list.timestamp") %></td>';
	body +='  <td class="ResultHeader"><%= _i18n.get("msg20ms001.list.status") %></td>';
	body +='  <td class="ResultHeader"><%= _i18n.get("msg20ms401.list.errcode") %></td>';
	body +='  <td class="ResultHeader"><%= _i18n.get("msg20ms401.list.severity") %></td>';
	body +='  <td class="ResultLastHeader"><input type="checkbox" id="chbox" name="allChkBtn" value="" class="gray-text" onClick="javascript:mainAllCheck();"></td>';
	body +='</tr>';
	return body;
}

function loading() {
   var body = "";

   body = getHeader();
   body += '<tr>';
   body += '   <td colspan="7" class="ResultLastData" align="center"><%= _i18n.get("global.loading")%></td></tr>';

   body += "</table>";

   $('listContent').innerHTML = body;

}

function showList(originalRequest) {

   var res = eval("(" + originalRequest.responseText + ")");

   var operations = "";
   var performers = "";
   var body = "";

   body = getHeader();

   for (var i=0; i<res.messages.length; i++) {
      color = i % 2 == 0 ? "#FFFFFF" : "#F9F9F9";

      body += '<tr>';
      body += '   <td class="ResultData" >' + res.messages[i].inout + '</td>';
      if (res.messages[i].status == 0 || res.messages[i].status == 1 || res.messages[i].status == 5 ) {
         textcolor = 'red';
      } else {
         textcolor = 'blue';
      }
      body += '   <td class="ResultData" ><a href="msg21ms401.jsp?obid='+res.messages[i].obid+'">' + res.messages[i].type + '</a></td>';
      body += '   <td class="ResultData" >' + res.messages[i].time + '</td>';
      body += '   <td class="ResultData" >' + res.messages[i].status + '</td>';
      body += '   <td class="ResultData" >' + res.messages[i].errcode + '</td>';
      body += '   <td class="ResultData" >' + res.messages[i].severity + '</td>';
      body += '   <td class="ResultLastData" align=center><input type="checkbox" name="obid" id="obid" value="'+res.messages[i].obid+'"></td>';
      body += '</tr>';
   }
   if (res.totalRows == 0) {
      body += '<tr>';
        body += '<td colspan="7" class="ResultLastData" align="center"><%= _i18n.get("msg20ms001.notfound")%></td></tr>';
   }
   body += "</table>";

   $('listContent').innerHTML = body;
   $('row_size').innerHTML = res.totalRows;
   $('pagelist').innerHTML = res.pagelist;
}

function getMessages() {

   loading();

   var params = Form.serialize(document.form1);
   var opt = {
      method: 'post',
      parameters: params,
      onSuccess: showList,
       on404: function(t) {
           $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("err00zz404.message") %>';
        //   showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
       },
       onFailure: function(t) {
           $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("global.error.retry") %>';
           showErrorPopup(t.responseText, null, null, null);
       }
   }
   var myAjax = new Ajax.Request("msg20ac401.jsp", opt);
}

function searchMessage(page) {
   $('curPage').value = page;

   var params = Form.serialize(document.form1);
//   dhtmlHistory.add((new Date()).toString(), params);

   getMessages();
}

function LoginEnterDown(){
   if(event.keyCode==13){
      getMessages();
   }
}

//-->
</script>
</head>
<body bgcolor=#FFFFFF leftmargin=0 topmargin=0 marginwidth=0 marginheight=0 onLoad="initialize()">

<form name="form1" method="POST">
<input type="hidden" name="curPage" id="curPage" value="1">
<!-- 제목 테이블 -->
<table class="TableLayout">
  <tr>
    <td width="200" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.msg.signalmessage.list")%></td>
    <td width="560" class="MessageDisplay" >
      <div id="messageDisplay"></div></td>
  </tr>
  <tr>
    <td colspan="3" height="6"></td>
  </tr>
</table>


<!--SelectTable 시작 -->
<table class="SearchTable"  >
  <tr>
      <td style="padding:10px"><table>
        <tr>
          <td width="95"><img src="images/bu_search.gif" ><%= _i18n.get("msg20ms001.search.message.id") %></td>
          <td width="250">
            <input type="text" name="msgId" id="msgId" class="FormText" size="32" onKeyDown="javascript:LoginEnterDown();" >
          </td>
          <td width="95"><img src="images/bu_search.gif" ><%= _i18n.get("msg20ms401.list.type") %></td>
          <td width="250">
            <select name="msgType" id="msgType" style="width:187;" class='FormSelect'>
               <option value=""><%= _i18n.get("global.all") %></option>
                 <option value="<%= MxsConstants.SIGNAL_PULLREQUEST %>"><%= MxsConstants._eb3SignalString[MxsConstants.SIGNAL_PULLREQUEST] %></option>
                 <option value="<%= MxsConstants.SIGNAL_RECEIPT %>"><%= MxsConstants._eb3SignalString[MxsConstants.SIGNAL_RECEIPT] %></option>
                 <option value="<%= MxsConstants.SIGNAL_ERROR %>"><%= MxsConstants._eb3SignalString[MxsConstants.SIGNAL_ERROR] %></option>
            </select>
          </td>
          <td width="50" align="right">&nbsp;</td>
        </tr>
        <tr>
          <td width="95"><img src="images/bu_search.gif" ><%= _i18n.get("msg20ms001.search.date") %></td>
          <td width="250">
 		  	  <input name="f_date" id="f_date" type="text" class="FormText" size="8" maxlength="10" value="<%=strFromDate%>" onKeyDown="javascript:LoginEnterDown();" >
	          <img src="images/bu_day.gif" style="cursor: pointer; " title="Date selector" onClick="return showCalendar('f_date', '%Y-%m-%d');" align="absmiddle">
    	      ~
        	  <input name="t_date" id="t_date" type="text" class="FormText" size="8" maxlength="10" value="<%=strToDate%>" onKeyDown="javascript:LoginEnterDown();" >
	          <img src="images/bu_day.gif" style="cursor: pointer; " title="Date selector" onClick="return showCalendar('t_date', '%Y-%m-%d');" align="absmiddle">
          </td>
          <td><img src="images/bu_search.gif" ><%= _i18n.get("msg20ms001.search.message.status") %></td>
          <td width="250">
            <select name="msgStatus" id="msgType" size="1" class="FormSelect" style="width:187;">
                 <option value="" selected><%= _i18n.get("global.all") %></option>
                 <option value="<%= EbConstants.MESSAGE_STATUS_UNAUTHORIZED %>"><%= _i18n.get("global.msg.status.unauthorized") %></option>
                 <option value="<%= EbConstants.MESSAGE_STATUS_NOT_RECOGNIZED %>"><%= _i18n.get("global.msg.status.notrecognized") %></option>
                 <option value="<%= EbConstants.MESSAGE_STATUS_RECEIVED %>"><%= _i18n.get("global.msg.status.received") %></option>
                 <option value="<%= EbConstants.MESSAGE_STATUS_PROCESSED %>"><%= _i18n.get("global.msg.status.processed") %></option>
                 <option value="<%= EbConstants.MESSAGE_STATUS_FORWARDED %>"><%= _i18n.get("global.msg.status.forwarded") %></option>
                 <option value="-1"><%= _i18n.get("global.msg.status.error") %></option>
            </select>
            </td>
          <td width="50" align="right">
            <a href="javascript:searchMessage(1);"><img src="images/btn_go.gif" border="0" style="cursor:hand;"></a>
          </td>
        </tr>
      </table>
      </td>
  </tr>
</table>

<!-- 총개수 테이블 -->
<table class="TotalTable" >
  <tr>
    <td align="left">[<%= _i18n.get("global.search") %> : <span id="row_size"></span> <%= _i18n.get("global.case") %>]
      <select name="page_Cnt" id="page_Cnt" size="1" class="FormSelect" onChange="javascript:searchMessage(1)">
<%
	    String selectedStr = "";
		String pageStr = "";
		for(int i = 0; i < pageSet.length; i++) {
			pageStr = pageSet[i];
			if (pageStr.equals("10")) {
				selectedStr = "selected";
			} else {
				selectedStr = "";
			}
			out.println("<option value='"+pageStr+"' "+selectedStr+">"+pageStr+"</option>");
		}
%>
      </select>
      <%= _i18n.get("global.pages") %>
      <select name="item_Cnt" id="item_Cnt" size="1" class="FormSelect" onChange="javascript:searchMessage(1)">
<%
		String item = "";
		for(int i = 0; i < itemSet.length; i++) {
			item = itemSet[i];
			if (item.equals("10")) {
				selectedStr = "selected";
			} else {
				selectedStr = "";
			}
			out.println("<option value='"+item+"' "+selectedStr+">"+item+"</option>");
		}
%>
      </select>
      <%= _i18n.get("global.rows") %>
    </td>
    <td width="300" align="right">
      <a href="javascript:deleteMessage();" >
         <img src="images/btn_delete.gif" width="34" height="20" border="0" style="cursor:hand;"></a>
    </td>
  </tr>
</table>

<!-- ---------------->
<!-- 검색결과 목록 -->
<!-- ---------------->
<table>
  <tr>
    <td>
        <div id="listContent"></div>
            <script>
               getMessages();
            </script>
    </td>
  </tr>
</table>

<table class="PageNavigationTable" >
  <tr>
    <td height="34" align="center"> <table cellpadding="0" cellspacing="0" border="0">
        <tr>
          <td class="listAPaging" valign="center"><span id="pagelist"></span></td>
        </tr>
      </table></td>
  </tr>
</table>


</form>
</body>
</html>
