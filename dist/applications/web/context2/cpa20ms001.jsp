<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%
   String command = request.getParameter("command");
   command = command==null?"":command;

   String update_cpa_obid = request.getParameter("cpa.obid");
   update_cpa_obid = update_cpa_obid==null?"":update_cpa_obid;
%>
<html>
<head>
<%@ include file="com00in000.jsp" %>
<%@ include file="./com00in003.jsp" %>
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

function insertCpa(frm) {

   closeInfo();

   var params = Form.serialize(frm);

   var opt = {
      method: 'post; enctype=multipart/form-data',
      parameters: params,
       onSuccess: function(t) {
         $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%= _i18n.get("msi20ms101.operation.deleted") %>';
//         insertFunction();
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
   var myAjax = new Ajax.Request("cpa10ac002.jsp", opt);

}
/* Commented out by J-.H. Kim on 2008.05.19
function insertFunction(originalRequest) {

   var command = res.command;
   alert(command);

}*/

function updateCpa() {
   closeInfo();
   location.href = "cpa21ms001.jsp?command=update&cpa.obid="+"<%=update_cpa_obid%>";
}

function deleteCPA() {
	var check_index = getSelectedId_Index();
	if(check_index == null || check_index == '') {
	   msg = "<%=_i18n.get("cpa20ms001.non.selected")%>";
	   openAlert(msg, "<%=_i18n.get("global.alert")%>",
			   "<%=_i18n.get("global.ok")%>");
	} else {
		msg = "<%=_i18n.get("cpa20ms001.delete.confirm")%>";
		bChoice = openConfirm(msg, deleteFunction, null, "<%=_i18n.get("global.warning")%>");
	}
}

function deleteFunction() {
   closeInfo();

   var params = Form.serialize(document.form2);
   var opt = {
      method: 'post',
      parameters: params,
      onSuccess: function(t) {
         $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%= _i18n.get("cpa40ac001.cpa.deleted") %>';
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
   var myAjax = new Ajax.Request("cpa40ac001.jsp", opt);

}

function viewCPA(obid) {
   window.open("cpa22ac001.jsp?obid=" + obid, "CPA", "width=1010,height=800,left=0,top=0,resizable=yes,scrollbars=yes");
}
/* Commented out by J-.H. Kim on 2008.05.19
function downloadCPA() {

   var inputs = document.getElementsByTagName('input');
   var id_Index = "" ;
   var selCnt = 0;
   for (var i = 0; i < inputs.length; i++) {
	  if (inputs[i].type == 'checkbox' && inputs[i].checked==true && inputs[i].name != 'allChkBtn') {
		  id_Index = inputs[i].value;
		  selCnt++;
	  }
   }

   if(download_flag) {
      window.open("cpa50ac001.jsp?obid=" + id_Index, "CPA", "width=100,height=100,left=5000,top=100,resizable=yes,scrollbars=yes");
   }
   else {
      var msg = "<%=_i18n.get("cpa20ms001.non.selected")%>";
		openAlert(msg);
   }
}

var download_flag = true;
*/

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

   var myAjax = new Ajax.Request("cpa20ac001.jsp", opt);
}

function searchList(page) {
   if (page == null || page == "") {
       page = 1;
   }

   $('curPage').value = page;
   $('messageDisplay').innerHTML = '';

   var params = Form.serialize(document.form2);
   //dhtmlHistory.add((new Date()).toString(), params);

   getList();
}

function loading() {

   var body = "";

   body += '<table class="TableLayout" >';
   body += '   <tr> ';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.cpa.name")%></td>';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.cpa.party.role")%></td>';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.cpa.lifetime")%></td>';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.cpa.status")%></td>';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.cpa.register")%></td>';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.download")%>/<%=_i18n.get("global.view")%></td>';
   body += '      <td class="ResultLastHeader">';
   body += '         <input id="chbox" type="checkbox" name="allChkBtn" onClick="javascript:mainAllCheck();">';
   body += '      </td>';
   body += '   </tr>';

   body += '<tr>';
   body += '<td class="ResultLastData" colspan="7" align="center"><%= _i18n.get("global.loading")%></td></tr>';

   $('listContent').innerHTML = body;

}

function showList(originalRequest) {

   var res = eval("(" + originalRequest.responseText + ")");

   var operations = "";
   var performers = "";
   var body = "";

   body += '<table class="TableLayout" >';
   body += '   <tr> ';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.cpa.name")%></td>';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.cpa.party.role")%></td>';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.cpa.lifetime")%></td>';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.cpa.status")%></td>';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.cpa.register")%></td>';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.download")%>/<%=_i18n.get("global.view")%></td>';
   body += '      <td class="ResultLastHeader">';
   body += '         <input id="chbox" type="checkbox" name="allChkBtn" onClick="javascript:mainAllCheck();">';
   body += '      </td>';
   body += '   </tr>';

   for (var i=0; i<res.list.length; i++) {
      var color = i % 2 == 0 ? "#FFFFFF" : "#F9F9F9";

      body += '<tr>';
      body += '   <td class="ResultData">';
      body += '      <a href="cpa21ms001.jsp?cpa.obid='+res.list[i].obid+'">'+res.list[i].name+'</a>';
      body += '   </td>';
      body += '   <td class="ResultData">'+res.list[i].partyName+'</td>';
      body += '   <td class="ResultData">'+res.list[i].start+ ' ~ ' + res.list[i].end+'</td>';
      body += '   <td class="ResultData">'+res.list[i].status+'</td>';
      body += '   <td class="ResultData">'+res.list[i].userId+'</td>';
      body += '   <td class="ResultData" align="center">';
      body += '      <a href="cpa50ac001.jsp?cpa.obid='+res.list[i].obid+'"><img src="images/btn_indown.gif" width="62" height="13" align="absmiddle" border="0" style="cursor:hand;"></a> / ';
      body += '      <a href="javascript:viewCPA(\''+res.list[i].obid+'\');"><img src="images/btn_inview.gif" width="39" height="13" align="absmiddle" border="0" style="cursor:hand;"></a> ';
      body += '   </td>';
      body += '   <td class="ResultLastData">';
      body += '      &nbsp;<input type="checkbox" name="cpa.obid" value="'+res.list[i].obid+'"></td>';
      body += '</tr>';

      body += '<input type=hidden name="cpaObid'+(i+1)+'" value="'+res.list[i].obid+'">';

   }

   if (res.totalRows == 0) {
      body += '<tr>';
        body += '<td class="ResultLastData" colspan="7" align="center"><%= _i18n.get("cpa20ms001.not.found")%></td></tr>';
   }

   body += "</table>";

   $('listContent').innerHTML = body;

   $('row_size').innerHTML = res.totalRows;
   $('pagelist').innerHTML = res.pagelist;
}
//-->
</script>

</head>
<body bgcolor=#FFFFFF leftmargin=0 topmargin=0 marginwidth=0 marginheight=0>

<%
   if(command.equals("update")) {
%>

<script>
   msg = "<%=_i18n.get("cpa20ms001.overwrite")%>";
   bChoice = openConfirm(msg, updateCpa, null, "<%=_i18n.get("global.warning")%>");
</script>

<%
   }
%>



<!-- title : CPA 목록  -->
<table class="TableLayout" border="0">
  <tr>
    <td width="120" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.cpa.list")%></td>
    <td width="640" class="MessageDisplay" >
          <span id=messageDisplay></span></td>
  </tr>
  <tr>
    <td colspan="3" height="6"></td>
  </tr>
</table>

<!-- CPA 업로드 ... -->
<form name="cpaUpload"  action="cpa10ac002.jsp" method="post" enctype="multipart/form-data" >
<table border="0" cellpadding="0" cellspacing="0" class="space_search" >
  <tr class="SelectTable"  >
    <td width="120" class="SelectTablein" ><%=_i18n.get("cpa20ms001.cpa.register")%></td>
    <td width="640">
      <input type="file" name="uploadFile" class="FormText" size="40" id="uploadFile" />
      <a href="javascript:this.document.cpaUpload.submit();"><img src="images/btn_create.gif" width="37" height="20" border="0" align="absmiddle" style="cursor:hand;"></a></td>
  </tr>
</table>
</form>

<!-- CPA 검색 ... -->
<form name="form2" method="post" >
<input type="hidden" name="command">
<input type="hidden" name="curPage" id="curPage" value="1">

<table class="SearchTable"  >
  <tr>
      <td style="padding:10px"><table>
        <tr>
          <td width="95"><img src="images/bu_search.gif" ><%=_i18n.get("global.cpa.name")%></td>
          <td width="250"><input name="cpaName" value="" class="FormText" size="32" >
          </td>
          <td width="95"><img src="images/bu_search.gif" ><%=_i18n.get("global.cpa.status")%></td>
          <td width="250">
             <select name="cpaStatus" id="cpaStatus" class='FormSelect'>
                <option value="0">agreed</option>
                <option value="1">proposed</option>
                <option value="2">signed</option>
             </select></td>
          <td width="50" align="right"><a href="javascript:getList()"><img src="images/btn_go.gif" border="0" style="cursor:hand;"></a></td>
        </tr>
      </table></td>
  </tr>
</table>

<!-- 총개수 테이블 -->
<table class="TotalTable" >
  <tr>
    <td align="left">
       <!-- [검색 : 999 건] -->
       [<%= _i18n.get("global.search") %> : <span id="row_size"></span> <%= _i18n.get("global.case") %>] &nbsp;&nbsp;

       <select name="page_Cnt" id="page_Cnt" size="1" class="selectfield" onChange="javascript:searchChannel(1)">
               <option value="5">5</option>
               <option value="10" selected>10</option>
               <option value="15">15</option>
               <option value="20">20</option>
        </select>
        <%= _i18n.get("global.pages") %>

        <select name="item_Cnt" id="item_Cnt" size="1" class="selectfield" onChange="javascript:searchChannel(1)">
               <option value="5">5</option>
               <option value="10" selected>10</option>
               <option value="20">20</option>
               <option value="30">30</option>
               <option value="50">50</option>
               <option value="100">100</option>
        </select>
        <%= _i18n.get("global.rows") %> </td>
    <td width="300" align="right">
      <a href="javascript:deleteCPA()"><img src="images/btn_delete.gif" width="34" height="20" border="0" style="cursor:hand;"></a>
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

</form>
<script>
<%
	if (command.equals("error")) {
		String result = (String) request.getParameter("msg");

%>
	    alert("<%=_i18n.get(result)%>");
        //$('messageDisplay').innerHTML = '<%=_i18n.get(result)%>';
<%
	}
%>

</script>


</body>

</html>
