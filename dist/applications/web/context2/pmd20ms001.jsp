<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%
/**
 * P-Mode List
 *
 * @author Mi-Young Kim
 * @version 1.0 2008.10.20
 */

String itemSet[]= {"5","10","20","30","50","100"};
String pageSet[]= {"5","10","15","20"};//,"30","40","50"};
%>
<html>
<head>
<%@ include file="./com00in000.jsp" %>
<%@ include file="./com00in001.jsp" %>
<%@ include file="./com00in003.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>
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

function initialize() {
}

function getHeader() {
	var body = "";
	body += '<table class="TableLayout" style="table-layout: fixed">';
	body +='<tr>';
	body +='  <td class="ResultHeader" width="35%"><%= _i18n.get("pmd20ms001.column.name") %></td>';
	body +='  <td class="ResultHeader" width="25%"><%= _i18n.get("pmd20ms001.column.id") %></td>';
	body +='  <td class="ResultHeader"><%= _i18n.get("pmd20ms001.column.desc") %></td>';
	body +='  <td class="ResultLastHeader" width="5%">';
    body +='      <input id="chbox" type="checkbox" name="allChkBtn" onClick="javascript:mainAllCheck();">';
    body +='  </td>';
	body +='</tr>';
	return body;
}

function loading() {
   var body = "";

   body = getHeader();
   body += '<tr>';
   body += '   <td colspan="4" class="ResultLastData" align="center"><%= _i18n.get("global.loading")%></td></tr>';

   body += "</table>";

   $('listContent').innerHTML = body;

}

function showList(originalRequest) {

   var res = eval("(" + originalRequest.responseText + ")");
   var body = "";

   body = getHeader();
   for (var i=0; i<res.pmodes.length; i++) {
      color = i % 2 == 0 ? "#FFFFFF" : "#F9F9F9";

      body += '<tr>';
      body += '   <td class="ResultData"><a href="pmd21ms001.jsp?obid='+res.pmodes[i].obid+'">' + res.pmodes[i].name + '</a></td>';
      body += '   <td class="ResultData">' + res.pmodes[i].id + '</td>';
      body += '   <td class="ResultData">' + res.pmodes[i].desc + '</td>';
      body += '   <td class="ResultLastData" align="center">';
      body += '      &nbsp;<input type="checkbox" name="obid" value="'+res.pmodes[i].obid+'"></td>';
      body += '   </td>';
      body += '</tr>';
   }
   if (res.totalRows == 0) {
      body += '<tr>';
        body += '<td colspan="4" class="ResultLastData" align="center"><%= _i18n.get("pmd20ms001.notfound")%></td></tr>';
   }
   body += "</table>";
   $('listContent').innerHTML = body;
   $('row_size').innerHTML = res.totalRows;
   $('pagelist').innerHTML = res.pagelist;
}

function getPModes() {

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
   var myAjax = new Ajax.Request("pmd20ac001.jsp", opt);
}

function searchList(page) {
   $('curPage').value = page;

   var params = Form.serialize(document.form1);
   getPModes();
}

function LoginEnterDown(){
   if(event.keyCode==13){
      getPModes();
   }
}

function deletePMode() {
	var check_index = getSelectedId_Index();
	if(check_index == null || check_index == '') {
	   msg = "<%=_i18n.get("pmd20ms001.non.selected")%>";
	   openAlert(msg, "<%=_i18n.get("global.alert")%>",
			   "<%=_i18n.get("global.ok")%>");
	} else {
		msg = "<%=_i18n.get("pmd20ms001.delete.confirm")%>";
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
         $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%= _i18n.get("pmd40ac001.pmode.deleted") %>';
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
   var myAjax = new Ajax.Request("pmd40ac001.jsp", opt);
}

function updatePMode() {
   closeInfo();
   location.href = "pmd21ms001.jsp?command=update&obid=<%=request.getParameter("obid")%>&nameCheckFlag=<%=request.getParameter("nameCheckFlag")%>";
}
//-->
</script>
</head>
<body bgcolor=#FFFFFF leftmargin=0 topmargin=0 marginwidth=0 marginheight=0 onLoad="initialize()">
<%
   if("update".equalsIgnoreCase(request.getParameter("command"))) {
%>

<script>
   var msg = "<%=_i18n.get("pmd20ms001.overwrite")%>";
   var bChoice = openConfirm(msg, updatePMode, null, "<%=_i18n.get("global.warning")%>");
</script>

<%
   }
%>
<!-- 제목 테이블 -->
<table class="TableLayout">
  <tr>
    <td width="200" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.pmd.list")%></td>
    <td width="560" class="MessageDisplay"><div id="messageDisplay"></div></td>
  </tr>
  <tr>
    <td colspan="3" height="6"></td>
  </tr>
</table>

<!-- PMode 업로드  -->
<form name="pmodeUpload"  action="pmd10ac004.jsp" method="post" enctype="multipart/form-data" >
<table border="0" cellpadding="0" cellspacing="0" class="space_search" >
  <tr class="SelectTable"  >
    <td width="150" class="SelectTablein" ><%=_i18n.get("pmd20ms001.pmode.fileselect")%></td>
    <td width="600">
      <input type="file" name="uploadFile" class="FormText" size="40" id="uploadFile" />
      <a href="javascript:this.document.pmodeUpload.submit();"><img src="images/btn_create.gif" width="37" height="20" border="0" align="absmiddle" style="cursor:hand;"></a></td>
  </tr>
</table>
</form>

<!--SelectTable 시작 -->
<form name="form1" method="POST">
<input type="hidden" name="curPage" id="curPage" value="1">
<table class="SearchTable"  >
  <tr>
      <td style="padding:10px"><table>
        <tr>
          <td width="95"><img src="images/bu_search.gif" ><%= _i18n.get("pmd20ms001.column.name") %></td>
          <td width="250">
            <input type="text" name="name" id="name" class="FormText" size="32" onKeyDown="javascript:LoginEnterDown();" >
          </td>
          <td width="95"><img src="images/bu_search.gif" ><%= _i18n.get("pmd20ms001.column.id") %></td>
          <td width="250">
			<input type="text" name="id" id="id" class="FormText" size="32" onKeyDown="javascript:LoginEnterDown();" >
          </td>
          <td width="50" align="right">&nbsp;</td>
        </tr>
        <tr>
          <td width="95"><img src="images/bu_search.gif" ><%= _i18n.get("pmd20ms001.column.desc") %></td>
          <td width="250" colspan=3>
			<input type="text" name="desc" id="desc" class="FormText" size="101" onKeyDown="javascript:LoginEnterDown();" >
          </td>
          <td width="50" align="right">
            <a href="javascript:searchList(1);"><img src="images/btn_go.gif" border="0" style="cursor:hand;"></a>
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
      <select name="page_Cnt" id="page_Cnt" size="1" class="FormSelect" onChange="javascript:searchList(1)">
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
      <select name="item_Cnt" id="item_Cnt" size="1" class="FormSelect" onChange="javascript:searchList(1)">
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
      <a href="javascript:deletePMode()"><img src="images/btn_delete.gif" width="34" height="20" border="0" style="cursor:hand;"></a>
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
               getPModes();
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

<!-- 버튼테이블 -->
<table class="TableLayout" >
  <tr>
    <td align="right" style="padding-top:15">
      <a href="pmd10ms001.jsp"><img src="images/btn_big_plus.gif" width="39" height="23" border="0"></a>
    </td>
  </tr>
</table>

</form>
</body>
</html>
