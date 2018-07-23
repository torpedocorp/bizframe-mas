<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.Eb3Constants"%>
<%
/**
 * List Remote MPC
 *
 * @author Ho-Jin Seo
 * @version 1.0 2008.09.29
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
function initialize() {
	getMpcs();
}

function getHeader() {
	var body = "";
	body += '<table class="TableLayout" style="table-layout: fixed">';
	body += '  <COLGROUP>';
	body += '  <COL span="1" style="width:150;">';
	body += '  <COL span="1" style="width:30;">';
	body += '  <COL span="1" style="width:30;">';
	body += '  <COL span="1" style="width:250;">';
	body += '  </COLGROUP>';
	body +='<tr>';
	body +='  <td class="ResultHeader"><%= _i18n.get("mpc20ms002.column.displayname") %></td>';
	body +='  <td class="ResultHeader"><%= _i18n.get("mpc20ms002.column.default") %></td>';
	body +='  <td class="ResultHeader"><%= _i18n.get("mpc20ms002.column.status") %></td>';
	body +='  <td class="ResultLastHeader"><%= _i18n.get("mpc20ms002.column.uri") %></td>';
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

   var operations = "";
   var performers = "";
   var body = "";

   body = getHeader();
   for (var i=0; i<res.mpcs.length; i++) {
      color = i % 2 == 0 ? "#FFFFFF" : "#F9F9F9";

      body += '<tr>';
      body += '   <td class="ResultData" ><a href="mpc21ms002.jsp?obid='+res.mpcs[i].obid+'">' + res.mpcs[i].displayName + '</a></td>';
      body += '   <td class="ResultData" align=center>' + res.mpcs[i].isDefault + '</td>';
      body += '   <td class="ResultData" align=center>' + res.mpcs[i].status + '</td>';
      body += '   <td class="ResultLastData" >' + res.mpcs[i].uri + '</td>';
      body += '</tr>';
   }
   if (res.totalRows == 0) {
      body += '<tr>';
        body += '<td colspan="4" class="ResultLastData" align="center"><%= _i18n.get("mpc20ms002.notfound")%></td></tr>';
   }
   body += "</table>";
   $('listContent').innerHTML = body;
   $('row_size').innerHTML = res.totalRows;
   $('pagelist').innerHTML = res.pagelist;
}

function getMpcs() {

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
   var myAjax = new Ajax.Request("mpc20ac002.jsp", opt);
}

function searchList(page) {
   $('curPage').value = page;

   var params = Form.serialize(document.form1);
   getMpcs();
}

function LoginEnterDown(){
   if(event.keyCode==13){
      getMpcs();
   }
}
window.onload = initialize;


//-->
</script>
</head>
<body bgcolor=#FFFFFF leftmargin=0 topmargin=0 marginwidth=0 marginheight=0 onLoad="initialize()">

<form name="form1" method="POST">
<input type="hidden" name="curPage" id="curPage" value="1">
<!-- 제목 테이블 -->
<table class="TableLayout">
  <tr>
    <td width="200" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.mpc.remotempc.list")%></td>
    <td width="560" class="MessageDisplay"><div id="messageDisplay"></div></td>
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
          <td width="95"><img src="images/bu_search.gif" ><%= _i18n.get("mpc20ms002.column.displayname") %></td>
          <td width="250">
            <input type="text" name="displayName" id="displayName" class="FormText" size="32" onKeyDown="javascript:LoginEnterDown();" >
          </td>
          <td width="95"><img src="images/bu_search.gif" ><%= _i18n.get("mpc20ms002.column.status") %></td>
          <td width="250">
            <select name="status" id="status" style="width:187;" class='FormSelect'>
               <option value=""><%= _i18n.get("global.all") %></option>
                 <option value="<%= Eb3Constants.MPC_ACTIVE %>"><%= _i18n.get("mpc20ms002.str.active") %></option>
                 <option value="<%= Eb3Constants.MPC_INACTIVE %>"><%= _i18n.get("mpc20ms002.str.inactive") %></option>
            </select>
          </td>
          <td width="50" align="right">&nbsp;</td>
        </tr>
        <tr>
          <td width="95"><img src="images/bu_search.gif" ><%= _i18n.get("mpc20ms002.column.uri") %></td>
          <td width="250">
			<input type="text" name="uri" id="uri" class="FormText" size="32" onKeyDown="javascript:LoginEnterDown();" >
          </td>
          <td><img src="images/bu_search.gif" ><%= _i18n.get("mpc20ms002.column.desc") %></td>
	          <td width="250"><input type="text" name="desc" id="desc" class="FormText" size="32" onKeyDown="javascript:LoginEnterDown();" >
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
    <td width="300" align="right"></td>
  </tr>
</table>


<!-- ---------------->
<!-- 검색결과 목록 -->
<!-- ---------------->
<table>
  <tr>
    <td>
        <div id="listContent"></div>
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

<br>
<!-- 버튼테이블 -->
<table class="TableLayout" >
  <tr>
    <td align="right" style="padding-top:15">
      <a href="mpc10ms002.jsp"><img src="images/btn_big_create.gif" width="39" height="23" border="0"></a>
    </td>
  </tr>
</table>

</form>
</body>
</html>
