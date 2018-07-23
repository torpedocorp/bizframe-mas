<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%
/**
 * List WssUser with PMode
 *
 * @author Mi-Young Kim
 * @version 1.0 2008.10.20
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

String fieldId = request.getParameter("fieldId");
%>
<title><%=_i18n.get("global.page.title")%></title>
<script language="JavaScript" type="text/JavaScript">
<!--
function getHeader() {
	var body = "";
	body += '<table class="TableLayout">';
	body +='<tr>';
	body += '<td class="ResultHeader" width="30%"><%=_i18n.get("global.user.id")%></td>';
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
	var auth_type = "";
	for (var i=0; i<res.user.length; i++) {
		body += '<tr>';
		body += '<td class="ResultData" align="left">';
        body += '    <input type="radio" name="wssuserIndex" id="wssuserIndex_'+i+'" value="' + i + '">';
	    body += '    <a href="javascript:selectWssUser(' + i + ')">&nbsp;';
		body += '<font class="blue-text03">' + res.user[i].id + '</font></td>'
		body += '<td class="ResultLastData" align="left">' + res.user[i].description + '</td>';
        body += '<input type="hidden" name="wssuserObid_'+i+'" value="'+res.user[i].obid+'">';
        body += '<input type="hidden" name="wssuserId_'+i+'" value="'+res.user[i].id+'">';
        body += '<input type="hidden" name="wssuserPwd_'+i+'" value="'+res.user[i].passwd+'">';
		body += '</tr>';
	}

	if (res.user.length == 0) {
		body += '<tr>';
		body += '<td class="ResultLastData" colspan="2" align="center"><%= _i18n.get("wsu20ms001.notfound")%></td></tr>';
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

function searchList(page) {
   $('curPage').value = page;

   var params = Form.serialize(document.form1);
   getWssUsers();
}


function getSelectedId_Index() {
   var inputs = document.getElementsByTagName('input');
   var sb_Index = "" ;
   for (var i = 0; i < inputs.length; i++) {
      if (inputs[i].type == 'radio' && inputs[i].checked==true) {
          sb_Index = inputs[i].value;
      }
   }
   return sb_Index;
}

function applyWssUser() {
	var sb_Index = getSelectedId_Index();
	if (sb_Index != "" && "<%=fieldId%>" != "") {
		var wssuserObid = eval('document.form1.wssuserObid_'+sb_Index+'.value');
		var wssuserId = eval('document.form1.wssuserId_'+sb_Index+'.value');
		var wssuserPwd = eval('document.form1.wssuserPwd_'+sb_Index+'.value');
		opener.applyWssUser("<%=fieldId%>", wssuserObid, wssuserId, wssuserPwd);
		window.close();
	}
}

function selectWssUser(index) {
	$('wssuserIndex_' + index).checked = true;
}

//-->
</script>
</head>
<body bgcolor=#FFFFFF leftmargin=0 topmargin=0 marginwidth=0 marginheight=0 >

<form name="form1" method="POST">
<input type="hidden" name="curPage" id="curPage" value="1">
<!-- 제목 테이블 -->
<table class="TableLayout">
  <tr>
    <td width="200" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.pmd.wssuser.list")%></td>
    <td width="560" class="MessageDisplay" >
      <div id="messageDisplay"></div></td>
  </tr>
  <tr>
    <td colspan="3" height="6"></td>
  </tr>
</table>

<!--SelectTable 시작 -->
<table class="SearchTable">
  <tr>
      <td style="padding:10px" align="center"><table>
        <tr>
          <td width="95"><img src="images/bu_search.gif" ><%= _i18n.get("global.user.id") %></td>
          <td width="200">
            <input type="text" name="username" id="username" class="FormText" size="32">
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
      <a href="javascript:applyWssUser()"><img src="images/btn_big_apply.gif" border="0" /></a>
      <a href="javascript:self.close();"><img src="images/btn_big_close.gif" width="39" height="23" border="0"></a>
    </td>
  </tr>
</table>
</form>
</body>
</html>
