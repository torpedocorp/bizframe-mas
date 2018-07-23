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
<title><%=_i18n.get("global.page.title")%></title>
<script language="JavaScript" type="text/JavaScript">
<!--
function subscriberPopup(obid) {
   window.open("msi20pu201.jsp?channel.obid="+obid,"subscriber","width=630,height=500,left=0,top=0,resizable=yes,scrollbars=yes");
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

function insertChannel() {
   var channelName = this.document.form1.channelName.value;

	if(channelName == null || channelName == '') {
	   msg = "<%=_i18n.get("msi20ms101.channelname.inform")%>";
	   openAlert(msg, "<%=_i18n.get("global.alert")%>", "<%=_i18n.get("global.ok")%>");
	} else {
		msg = "<%=_i18n.get("msi20ms101.register.confirm")%>";
		var bChoice = openConfirm(msg, insertFunction, null, "<%=_i18n.get("global.warning")%>");
	}

}

function updateChannel() {
   var check_index = getSelectedId_Index();
	if(check_index == null || check_index == '') {
	   msg = "<%=_i18n.get("msi20ms101.non.selected")%>";
	   openAlert(msg, "<%=_i18n.get("global.alert")%>", "<%=_i18n.get("global.ok")%>");
	} else {
		msg = "<%=_i18n.get("msi20ms101.update.confirm")%>";
		var bChoice = openConfirm(msg, updateFunction, null, "<%=_i18n.get("global.warning")%>");
	}
}

function deleteChannel() {
   var check_index = getSelectedId_Index();
	if(check_index == null || check_index == '') {
      msg = "<%=_i18n.get("msi20ms101.non.selected")%>";
	   openAlert(msg, "<%=_i18n.get("global.alert")%>", "<%=_i18n.get("global.ok")%>");
	} else {
		msg = "<%=_i18n.get("msi20ms101.delete.confirm")%>";
		var bChoice = openConfirm(msg, deleteFunction, null, "<%=_i18n.get("global.warning")%>");
	}

}

function insertFunction() {
   closeInfo();

   var params = Form.serialize(document.form1);
   var opt = {
      method: 'post',
      parameters: params,
      onSuccess: function(t) {
         $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%= _i18n.get("msi20ms101.channel.registered") %>';
         $('channelName').value = '';
         $('description').value = '';
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
   var myAjax = new Ajax.Request("msi10ac101.jsp", opt);

}

function updateFunction() {
   closeInfo();

   var params = Form.serialize(document.form2);
   var opt = {
      method: 'post',
      parameters: params,
      onSuccess: function(t) {
        $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%= _i18n.get("msi20ms101.channel.updated") %>';
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
   var myAjax = new Ajax.Request("msi30ac101.jsp", opt);

}

function deleteFunction() {
   closeInfo();

   var params = Form.serialize(document.form2);
   var opt = {
      method: 'post',
      parameters: params,
      onSuccess: function(t) {
         $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%= _i18n.get("msi20ms101.channel.deleted") %>';
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
   var myAjax = new Ajax.Request("msi40ac101.jsp", opt);

}

function getChannels() {

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

   var myAjax = new Ajax.Request("msi20ac101.jsp", opt);
}

function loading() {

   var body = "";

   body += '<table class="TableLayout">';
   body += '   <col width="">';
   body += '   <col width="" align="right">';
   body += '   <col width="440" align="center">';
   body += '   <col width="30" align="center">';
   body += '   <tr>';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.channel.name") %></td>';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.channel.num.subscriber") %></td>';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.channel.description") %></td>';
   body += '      <td class="ResultLastHeader">';
   body += '         <input id="chbox" type="checkbox" name="allChkBtn" class="gray-text" onClick="javascript:mainAllCheck();"></td>';
   body += '   </tr>';
   body += '<tr>';
   body += '   <td colspan="4" align="center" class="ResultLastData"><%= _i18n.get("global.loading")%></td></tr>';

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
   body += '   <col width="440" align="center">';
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
      body += '      <a href="javascript:subscriberPopup(\''+res.list[i].obid+'\')">'+res.list[i].name +'</td>';
      body += '   <td class="ResultData" bgcolor="'+color+'">'+res.list[i].numsubscriber+'</td>';
      body += '   <td class="ResultData" bgcolor="'+color+'">';
      body += '      <input type="text" name="'+res.list[i].obid+'_description" class="textfield-3" size="30" maxlength="200" value="'+res.list[i].description+'"></td>';
      body += '   <td class="ResultLastData" bgcolor="'+color+'">';
      body += '      <input type="checkbox" name="channelObid" value="'+res.list[i].obid+'"></td>';
      body += '</tr>';

   }

   if (res.totalRows == 0) {
      body += '<tr>';
        body += '<td colspan="4" class="ResultLastData" align="center" valign="middle" ><%= _i18n.get("msi20ms101.not.found")%></td></tr>';
   }

   body += "</table>";


   $('listContent').innerHTML = body;

   $('row_size').innerHTML = res.totalRows;
   $('pagelist').innerHTML = res.pagelist;
}

function searchList(page) {

   loading();

   if (page == null || page == "") {
       page = 1;
   }

   $('curPage').value = page;
   $('messageDisplay').innerHTML = '';

   var params = Form.serialize(document.form2);
//   dhtmlHistory.add((new Date()).toString(), params);

   getChannels();
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

//-->
</script>
</head>

<body bgcolor=#FFFFFF leftmargin=0 topmargin=0 marginwidth=0 marginheight=0>

<!-- 제목 테이블 -->
<table class="TableLayout">
  <tr>
    <td width="120" class="Title" ><img src="images/bu_tit.gif" ><%= _i18n.get("menu.channel.list")%></td>
    <td width="640" class="MessageDisplay" >
      <div id=messageDisplay></div></td>
  </tr>
  <tr>
    <td colspan="3" height="6"></td>
  </tr>
</table>

<form name="form1" method="post">
<!--  -->
<table border="0" cellpadding="0" cellspacing="0" class="space_search" >
  <tr class="SelectTable"  >
    <td width="120" class="SelectTablein" ><%= _i18n.get("global.channel.name")%></td>
    <td width="230">
      <input name="channelName" id="channelName" type="text" class="FormText" size="25" />
      </td>
    <td width="120" class="SelectTablein" ><%= _i18n.get("global.channel.description")%></td>
    <td width="230">
      <input name="description" id="description" type="text" class="FormText" size="25" />
      </td>
    <td width="60">
      <a href="javascript:insertChannel()">
         <img src="images/btn_create.gif" width="37" height="20" align="absmiddle" border="0" style="cursor:hand;"></a></td>
  </tr>
</table>
</form>

<form name="form2" method="post">
<input type="hidden" name="curPage" id="curPage" value="1">

<!-- 총개수 테이블 -->
<table class="TotalTable" >
  <tr>
    <td align="left">[<%= _i18n.get("global.search") %> : <span id="row_size"></span> <%= _i18n.get("global.case") %>]
      <select name="page_Cnt" id="page_Cnt" size="1" class="FormSelect" onChange="javascript:searchList(1)">
         <option value="5">5</option>
         <option value="10" selected>10</option>
         <option value="15">15</option>
         <option value="20">20</option>
      </select>
      <%= _i18n.get("global.pages") %>
      <select name="item_Cnt" id="item_Cnt" size="1" class="FormSelect" onChange="javascript:searchList(1)">
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
      <a href="javascript:updateChannel();"><img src="images/btn_update.gif" border="0" width="37" height="20" style="cursor:hand"></a>
      <a href="javascript:deleteChannel();"><img src="images/btn_delete.gif" border="0" style="cursor:hand"></a></td>
  </tr>
</table>

<table>
   <!-- 리스트  -->
   <tr>
      <td>
         <div id="listContent"></div>
         <script>
         getChannels();
         </script>

      </td>
   </tr>
</table>

<!-- 페이징  -->
<table class="PageNavigationTable" >
  <tr>
    <td width="50%"  align="left"> <table cellpadding="0" cellspacing="0" border="0">
        <tr>
          <td class="listAPaging" valign="center"><span id="pagelist"></span></td>
        </tr>
      </table></td>
    <td width="50%"  align="right"> <%= _i18n.get("global.search") %>
      <input name="Input222222222" class="FormText" onFocus="clearText(this)" size="25" />
      <a href="#"><img src="images/btn_go.gif" width="37" height="20" border="0" align="absmiddle"></a>
    </td>
  </tr>
</table>

</form>

</body>
</html>
