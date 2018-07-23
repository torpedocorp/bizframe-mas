<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
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

function openChannelList(obid) {
     window.open("msi21pu101.jsp?obid="+obid,"channel","width=630,height=620,left=0,top=0,resizable=yes,scrollbars=yes");
}

function subscriberPopup(channelObid) {
   window.open("msi20pu201.jsp?channel.obid="+channelObid,"subscriber","width=630,height=620,left=0,top=0,resizable=yes,scrollbars=yes");
}

function onSubmit(frm) {
   if (frm.name == "form1") {
      if (frm.channelName.value == "" ) {
		  alert("<%=_i18n.get("msi21ms201.empty.channel.name")%>");
      return;
      }
   }
   frm.submit();
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

function updateSubscriber() {

   msg = "<%=_i18n.get("msi21ms201.update.confirm")%>";
	var bChoice = openConfirm(msg, updateFunction, null, "<%=_i18n.get("global.warning")%>");
}

function deleteSubscribeChannel() {
   var check_index = getSelectedId_Index();
	if(check_index == null || check_index == '') {
	   msg = "<%=_i18n.get("msi21ms201.non.selected")%>";
	   openAlert(msg, "<%=_i18n.get("global.alert")%>", "<%=_i18n.get("global.ok")%>");
	} else {
		msg = "<%=_i18n.get("msi21ms201.unsubscribe.confirm")%>";
		var bChoice = openConfirm(msg, deleteUnsubscribeFunction, null, "<%=_i18n.get("global.warning")%>");
	}

}

function deleteSubscriber() {
   msg = "<%=_i18n.get("msi21ms201.delete.confirm")%>";
	var bChoice = openConfirm(msg, deleteSubscriberFunction, null, "<%=_i18n.get("global.warning")%>");
}

function updateFunction() {

   closeInfo();

   var params = Form.serialize(document.form1);
   var opt = {
      method: 'post',
      parameters: params,
      onSuccess: function(t) {
         $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%= _i18n.get("msi21ms201.subscriber.channel.updated") %>';
         setTimeout(searchChannel, 1000);
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
   var myAjax = new Ajax.Request("msi30ac201.jsp", opt);

}

function deleteUnsubscribeFunction() {

   closeInfo();

   var params = Form.serialize(document.form2);
   var opt = {
      method: 'post',
      parameters: params,
      onSuccess: function(t) {
         $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%= _i18n.get("msi21ms201.subscriber.channel.unsubscribed") %>';
         setTimeout(searchChannel, 1000);

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
   var myAjax = new Ajax.Request("msi40ac202.jsp", opt);

}

function deleteSubscriberFunction() {

   closeInfo();

   var params = Form.serialize(document.form1);
   var opt = {
      method: 'post',
      parameters: params,
      onSuccess: function(t) {
         $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%= _i18n.get("msi21ms201.subscriber.channel.deleted") %>';
         alert('<%= _i18n.get("msi21ms201.subscriber.channel.deleted") %>');
         setTimeout(searchChannel, 1000);

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
   var myAjax = new Ajax.Request("msi40ac201.jsp", opt);

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

function getList() {

   loading();

   var params = Form.serialize(document.form2);
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

   var myAjax = new Ajax.Request("msi21ac201.jsp", opt);
}

function loading() {

   var body = "";

   body += '<table class="TableLayout">';
   body += '   <col width="">';
   body += '   <col width="" align="right">';
   body += '   <col width="" align="center">';
   body += '   <col width="30" align="center">';
   body += '   <tr>';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.channel.name") %></td>';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.channel.num.subscriber") %></td>';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.channel.description") %></td>';
   body += '      <td class="ResultLastHeader">';
   body += '         <input id="chbox" type="checkbox" name="allChkBtn" class="gray-text" onClick="javascript:mainAllCheck();"></td>';
   body += '   </tr>';

   body += '<tr>';
   body += '   <td class="ResultLastData" align="center" colspan="4"><%= _i18n.get("global.loading")%></td></tr>';

   body += "</table>";

   $('listContent').innerHTML = body;

}

function showList(originalRequest) {

   var res = eval("(" + originalRequest.responseText + ")");

   var operations = "";
   var performers = "";
   var body = "";

   body += '<table class="TableLayout">';
   body += '   <col width="">';
   body += '   <col width="" align="right">';
   body += '   <col width="" align="center">';
   body += '   <col width="30" align="center">';
   body += '   <tr>';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.channel.name") %></td>';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.channel.num.subscriber") %></td>';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.channel.description") %></td>';
   body += '      <td class="ResultLastHeader">';
   body += '         <input id="chbox" type="checkbox" name="allChkBtn" class="gray-text" onClick="javascript:mainAllCheck();"></td>';
   body += '   </tr>';

   for (var i=0; i<res.list.length; i++) {
      var color = i % 2 == 0 ? "#FFFFFF" : "#F9F9F9";

      body += '<tr>';
      body += '   <td class="ResultData" bgcolor="'+color+'">';
      body += '      <a href="javascript:subscriberPopup(\''+res.list[i].channelObid+'\')">'+res.list[i].channelName +' </td>';

      body += '   <td class="ResultData"" bgcolor="'+color+'">'+res.list[i].channelNumSubscriber+'</td>';
      body += '   <td class="ResultData" bgcolor="'+color+'">';
      body += '      <input type="text" name="'+res.list[i].channelObid+'_description" class="FormTextReadOnly" readonly size="30" maxlength="200" value="'+res.list[i].channelDescription+'"></td>';
      body += '   <td class="ResultLastData" bgcolor="'+color+'">';
      body += '      <input type="checkbox" name="chToSubObid" value="'+res.list[i].obid+'"></td>';

      body += '</tr>';
      body += '<input type="hidden" name="'+res.list[i].obid+'_channelObid" value="'+res.list[i].channelObid+'"></td>';

   }

   if (res.totalRows == 0) {
      body += '<tr>';
      body += '   <td class="ResultLastData" align="center" colspan="4"><%= _i18n.get("msi21ms201.not.found")%></td></tr>';
   }

   body += "</table>";

   $('subscriberObid').value        = res.obid;
   $('subscriberName').value        = res.name;
   $('<%=request.getParameter("obid")%>_description').value = res.description;

   $('listContent').innerHTML = body;
   $('row_size').innerHTML = res.totalRows;
   $('pagelist').innerHTML = res.pagelist;
}

function searchChannel(page) {

   if (page == null || page == "") {
       page = 1;
   }

   $('curPage').value = page;
   $('messageDisplay').innerHTML = '';

   var params = Form.serialize(document.form2);
//   dhtmlHistory.add((new Date()).toString(), params);

   getList();
}

//-->
</script>
</head>

<body bgcolor=#FFFFFF leftmargin=0 topmargin=0 marginwidth=0 marginheight=0>

<form name="form1" method="post">
<!-- 제목 테이블 -->
<table class="TableLayout">
  <tr>
    <td width="160" class="Title" ><img src="images/bu_tit.gif" ><%= _i18n.get("menu.subscriber.channel.list")%></td>
    <td width="600" class="MessageDisplay" >
      <div id=messageDisplay></div></td>
  </tr>
  <tr>
    <td colspan="3" height="6"></td>
  </tr>
</table>

<!--  -->
<table border="0" cellpadding="0" cellspacing="0" class="space_search" >
  <tr class="SelectTable"  >
    <td width="120" class="SelectTablein" ><%= _i18n.get("global.subscriber.name")%></td>
    <td width="230">
      <input type="hidden" name="subscriberObid" id="subscriberObid">
      <input name="subscriberName" id="subscriberName" type="text" class="FormTextReadOnly" readonly size="25" />
      </td>
    <td width="120" class="SelectTablein" ><%= _i18n.get("global.subscriber.description")%></td>
    <td width="230">
      <input name="<%=request.getParameter("obid")%>_description" id="<%=request.getParameter("obid")%>_description" type="text" class="FormText" size="25" />
      </td>
    <td width="60">&nbsp;</td>
  </tr>
</table>
</form>

<form name="form2" method="post">

<input type="hidden" name="curPage" id="curPage" value="1">
<input type="hidden" name="obid" value="<%= request.getParameter("obid")%>">

<!-- 총개수 테이블 -->
<table class="TotalTable" >
  <tr>
    <td align="left">[<%= _i18n.get("global.search") %> : <span id="row_size"></span> <%= _i18n.get("global.case") %>] &nbsp;&nbsp;
      <select name="page_Cnt" id="page_Cnt" size="1" class="FormSelect" onChange="javascript:searchChannel(1)">
         <option value="5">5</option>
         <option value="10" selected>10</option>
         <option value="15">15</option>
         <option value="20">20</option>
      </select>
      <span class="gray-text"><%= _i18n.get("global.pages") %>
      <select name="item_Cnt" id="item_Cnt" size="1" class="FormSelect" onChange="javascript:searchChannel(1)">
         <option value="5">5</option>
         <option value="10" selected>10</option>
         <option value="20">20</option>
         <option value="30">30</option>
         <option value="50">50</option>
         <option value="100">100</option>
      </select>
      <%= _i18n.get("global.rows") %>
    </td>
    <td width="300" align="right">
      <a href="javascript:openChannelList('<%= request.getParameter("obid")%>')">
         <img src="images/btn_subscribe.gif" width="37" height="20" border="0" style="cursor:hand;"> </a>
      <a href="javascript:deleteSubscribeChannel()">
         <img src="images/btn_subscribecancel.gif" width="59" height="20" border="0" style="cursor:hand;"> </a>
    </td>
  </tr>
</table>

<table>
   <tr>
      <td>
         <div id="listContent"></div>
         <script>
         getList();
         </script>
      </td>
   </tr>
</table>

<!-- 페이징  -->
<table class="PageNavigationTable" >
  <tr>
    <td height="34" align="center"> <table cellpadding="0" cellspacing="0" border="0">
        <tr>
          <td class="listAPaging" valign="center"><span id="pagelist"></span></td>
        </tr>
      </table></td>
  </tr>
</table>


<!-- 버튼테이블 -->
<table class="TableLayout" >
  <tr>
    <td align="right" style="padding-top:15">
      <a href="msi20ms201.jsp"><img src="images/btn_big_list.gif" width="39" height="23" border="0" style="cursor:hand;"> </a>
      <a href="javascript:updateSubscriber()"><img src="images/btn_big_change.gif" width="39" height="23" border="0" style="cursor:hand;"> </a>
      <a href="javascript:deleteSubscriber()"><img src="images/btn_big_delete.gif" width="39" height="23" border="0" style="cursor:hand;"> </a>
    </td>
  </tr>
</table>

</form>

</body>
</html>
