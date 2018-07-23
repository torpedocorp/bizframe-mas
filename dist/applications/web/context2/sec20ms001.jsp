<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%
/**
 * @author Yoon-Soo Lee
 * @author Mi-Young Kim
 * @version 2.0
 */
 String command = (String) request.getParameter("command");
 command = (command == null ? "" : command);
 String msg = (String) request.getParameter("result");
 msg = (msg == null ? "" : msg);
%>
<html>
<head>
<%@ include file="com00in000.jsp" %>
<%@ include file="com00in003.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>
<!--
<script type="text/javascript" src="js/dhtmlHistory.js"> </script>-->
<script language="JavaScript" type="text/JavaScript">
<!--
function mainAllCheck() {
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

function deleteKeyStore() {
	var check_index = getSelectedId_Index();
	if(check_index == null || check_index == '') {
	   msg = "<%=_i18n.get("sec20ms001.non.selected")%>";
	   openAlert(msg, "<%=_i18n.get("global.alert")%>", 
			   "<%=_i18n.get("global.ok")%>");
	} else {	
		msg = "<%=_i18n.get("sec20ms001.delete.confirm")%>";
		bChoice = openConfirm(msg, deleteFunction, null, "<%=_i18n.get("global.warning")%>");
	}    
}

function deleteFunction() {
   closeInfo();
   
   var params = Form.serialize(document.form1);
   var opt = {
      method: 'post', 
      parameters: params, 
      onSuccess: function(t) {
         $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%= _i18n.get("sec20ms001.keystore.delete.success") %>';
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
   var myAjax = new Ajax.Request("sec40ac001.jsp", opt);

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
   var myAjax = new Ajax.Request("sec20ac001.jsp", opt);
}  

function searchList(page) {
   if(page != null && page != "0") 
     $('curPage').value = page;
   var params = Form.serialize(document.form1);   
   getList();
}

function loading() {

   var body = "";

   body += '<table class="TableLayout" >';
   body += '   <tr> ';
   body += '      <td class="ResultHeader"><%=_i18n.get("sec20ms001.column.1")%></td>';
   body += '      <td class="ResultHeader"><%=_i18n.get("sec20ms001.column.2")%></td>';
   body += '      <td class="ResultHeader"><%=_i18n.get("sec20ms001.column.3")%></td>';
   body += '      <td class="ResultHeader"><%=_i18n.get("sec20ms001.column.4")%></td>';
   body += '      <td class="ResultHeader">다운로드</td>';
   body += '      <td class="ResultLastHeader">';
   body += '         <input id="chbox" type="checkbox" name="allChkBtn" onClick="javascript:mainAllCheck();">';
   body += '      </td>';
   body += '   </tr>';

   body += '<tr>';
   body += '<td class="ResultLastData" colspan="6" align="center"><%= _i18n.get("global.loading")%></td></tr>';
   
   $('listContent').innerHTML = body;
   
}

function showList(originalRequest) {

   var res = eval("(" + originalRequest.responseText + ")");

   var operations = "";
   var performers = "";
   var body = "";

   body += '<table class="TableLayout" >';
   body += '   <tr> ';
   body += '      <td class="ResultHeader"><%=_i18n.get("sec20ms001.column.1")%></td>';
   body += '      <td class="ResultHeader"><%=_i18n.get("sec20ms001.column.2")%></td>';
   body += '      <td class="ResultHeader"><%=_i18n.get("sec20ms001.column.3")%></td>';
   body += '      <td class="ResultHeader"><%=_i18n.get("sec20ms001.column.4")%></td>';
   body += '      <td class="ResultHeader">다운로드</td>';
   body += '      <td class="ResultLastHeader" align="center">';
   body += '         <input id="chbox" type="checkbox" name="allChkBtn" onClick="javascript:mainAllCheck();">';
   body += '      </td>';
   body += '   </tr>';

   body += '<tr>';

   for (var i=0; i<res.list.length; i++) {
      var color = i % 2 == 0 ? "#FFFFFF" : "#F9F9F9";
      
      body += '<tr>';
      body += '   <td class="ResultData">';
      body += '      <a href="sec21ms001.jsp?obid='+res.list[i].obid+'">'+res.list[i].name+'</a>';
      body += '   </td>';      
      body += '   <td class="ResultData">'+res.list[i].type+'</td>';
      body += '   <td class="ResultData">'+res.list[i].alias+'</td>';
      body += '   <td class="ResultData">'+res.list[i].desc+'</td>';
      body += '   <td class="ResultData" align="center">';
      body += '      <a href="sec50ac001.jsp?obid='+res.list[i].obid+'"><img src="images/btn_indown.gif" width="62" height="13" align="absmiddle" border="0" style="cursor:hand;"></a>';
      body += '   </td>';  
      body += '   <td class="ResultLastData" align="center">';
      body += '     <input type="checkbox" name="obid" value="'+res.list[i].obid+'"></td>';
      body += '</tr>';  
   }

   if (res.totalRows == 0) {
      body += '<tr>';
        body += '<td class="ResultLastData" colspan="6" align="center"><%= _i18n.get("sec20ms001.non.selected")%></td></tr>';
   }

   body += "</table>";
   
   $('listContent').innerHTML = body;
   $('curPage').value = res.curpage;
   $('row_size').innerHTML = res.totalRows;
   $('pagelist').innerHTML = res.pagelist;
}   
//-->
</script>

</head>
<body bgcolor=#FFFFFF leftmargin=0 topmargin=0 marginwidth=0 marginheight=0>

<form name="form1" method="POST">
<input type="hidden" name="curPage" id="curPage" value="1">
<!-- title : 키스토어 목록  -->
<table class="TableLayout" border="0">
  <tr> 
    <td width="120" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.sec.list")%></td>
    <td width="640" class="MessageDisplay" >
          <span id=messageDisplay></span></td>
  </tr>
  <tr> 
    <td colspan="3" height="6"></td>
  </tr>
</table>

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
      <a href="javascript:deleteKeyStore();" >
         <img src="images/btn_delete.gif" width="34" height="20" border="0" style="cursor:hand;"></a> 
    </td>
  </tr>
</table>       

         
<!-- 리스트  -->      
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

<table class="TableLayout">
  <tr> 
    <td height="34" align="center"> 
      <table cellpadding="0" cellspacing="0" border="0">
        <tr> 
          <td width="95"><img src="images/bu_search.gif" ><%=_i18n.get("sec20ms001.column.1")%></td>
          <td width="200"><input name="search" value="" class="FormText" size="32" > 
          </td>
          <td width="50" align="left"><a href="javascript:searchList(0)"><img src="images/btn_go.gif" border="0" style="cursor:hand;"></a></td>
        </tr>
      </table>
      </td>
  </tr>
</table>

<!-- 버튼  -->
<table class="TableLayout" >
  <tr> 
    <td align="right" style="padding-top:10">
      <a href="sec10ms001.jsp"><img src="images/btn_big_create.gif" width="39" height="23" border="0"></a> 
    </td>
  </tr>
</table>

</form> 

<script>
<%
	if (command.equals("update")) {
		 msg = (msg.equals("success") ? "sec20ms001.keystore.update.success" : "global.error.retry");
%>
   
         $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get(msg)%>';
<%		
	}
	else if (command.equals("insert")) {
	     msg = (msg.equals("success") ? "sec.keystore.register.success" : "global.error.retry");
%>

         $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get(msg)%>';
<%		
}
%>
</script>         

</body>
</html>
