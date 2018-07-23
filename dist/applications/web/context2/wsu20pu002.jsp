<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%
/**
 * List WssUser with MPC
 *
 * @author Mi-Young Kim
 * @version 1.0 2008.09.26
 */
%>
<html>
<head>
<%@ include file="./com00in000.jsp" %>
<%@ include file="./com00in001.jsp" %>
<%@ include file="./com00in003.jsp" %>
<%
String itemSet[]= {"5","10","20","30","50","100"};
String pageSet[]= {"5","10","15","20"};//,"30","40","50"};

String mpcObid = request.getParameter("mpcObid");
if (mpcObid == null || mpcObid.equals("")) {
    out.println("<script>alert('" + _i18n.get("wsu20pu002.notfound") + "');history.back();</script>");
   	return;
}
%>
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

function getHeader() {
	var body = "";
	body += '<table class="TableLayout">';
	body +='<tr>';
	body += '<td class="ResultHeader"><%=_i18n.get("global.user.id")%></td>';
	body += '<td class="ResultLastHeader"><%=_i18n.get("global.user.description")%></td>';
	body +='</tr>';
	return body;
}

function loading() {
   var body = "";

   body = getHeader();
   body += '<tr>';
   body += '   <td colspan="2" class="ResultLastData" align="center"><%= _i18n.get("global.loading")%></td></tr>';

   body += "</table>";

   $('listContent').innerHTML = body;

}

function showList(originalRequest) {
	var res = eval("(" + originalRequest.responseText + ")");
	var body = "";
	body = getHeader();

	var num = 0;
	for (var i=0; i<res.user.length; i++) {
		body += '<tr>';
		body += '<td class="ResultData" align="left"><a href="javascript:viewWssUser(\'' + res.user[i].obid + '\')"><font class="blue-text03">' + res.user[i].id + '</font></a></td>';
		body += '<td class="ResultLastData" align="left">' + res.user[i].description + '</td>';
		body += '</tr>';
	}

	if (res.user.length == 0) {
		body += '<tr>';
		body += '<td class="ResultLastData" colspan="2" align="center"><%= _i18n.get("wsu20pu002.notfound")%></td></tr>';
	}

	body += "</table>";
	$('listContent').innerHTML = body;
	$('row_size').innerHTML = res.user.length;
	$('pagelist').innerHTML = res.pagelist;
}

function getWssUsers() {

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
   var myAjax = new Ajax.Request("wsu20ac001.jsp", opt);
}

function searchWssUsers(page) {
   $('curPage').value = page;

   var params = Form.serialize(document.form1);
   getWssUsers();
}

function viewWssUser(obid) {
	opener.location.href='wsu21ms001.jsp?obid='+obid;
}

//-->
</script>
</head>
<body bgcolor=#FFFFFF leftmargin=0 topmargin=0 marginwidth=0 marginheight=0 onLoad="initialize()">

<form name="form1" method="POST">
<input type="hidden" name="curPage" id="curPage" value="1">
<input type="hidden" name="mpcObid" id="mpcObid" value="<%= mpcObid %>">
<!-- 제목 테이블 -->
<table class="TableLayout">
  <tr>
    <td width="200" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.wsu.usempc.list")%></td>
    <td width="560" class="MessageDisplay" >
      <div id="messageDisplay"></div></td>
  </tr>
  <tr>
    <td colspan="3" height="6"></td>
  </tr>
</table>


<!-- 총개수 테이블 -->
<table class="TotalTable" >
  <tr>
    <td align="left">[<%= _i18n.get("global.search") %> : <span id="row_size"></span> <%= _i18n.get("global.case") %>]
      <select name="page_Cnt" id="page_Cnt" size="1" class="FormSelect" onChange="javascript:searchWssUsers(1)">
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
      <select name="item_Cnt" id="item_Cnt" size="1" class="FormSelect" onChange="javascript:searchWssUsers(1)">
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
            <script>
               getWssUsers();
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
<br>
<!-- 버튼테이블 -->
<table class="TableLayout" >
  <tr>
    <td align="center" style="padding-top:15">
      <a href="javascript:self.close();"><img src="images/btn_big_close.gif" width="39" height="23" border="0"></a>
    </td>
  </tr>
</table>
</form>
</body>
</html>
