<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%
/**
 * Local MPC Selection
 *
 * @author Ho-Jin Seo
 * @version 1.0 2008.09.29
 */

String itemSet[]= {"5","10","20","30","50","100"};
String pageSet[]= {"5","10","15","20"};//,"30","40","50"};

String textId = StringUtil.checkNull(request.getParameter("id"));

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
	body += '<table class="TableLayout">';
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
      body += '   <td class="ResultData" align="left">';
      if (res.mpcs[i].isActive == 0) {
	      body += '	     <input type="radio" name="mpcIndex" id="mpcIndex_'+i+'" value="' + i + '" disabled>';
	      body += '	     ' + res.mpcs[i].displayName + '</td>';
      } else {
	      body += '	     <input type="radio" name="mpcIndex" id="mpcIndex_'+i+'" value="' + i + '">';
	      body += '	     <a href="javascript:selectMpc(' + i + ')"><font class="blue-text03">' + res.mpcs[i].displayName + '</font></a></td>';
	  }
      body += '   <td class="ResultData" align=center>' + res.mpcs[i].isDefault + '</td>';
      body += '   <td class="ResultData" align=center>' + res.mpcs[i].status + '</td>';
      body += '   <td class="ResultLastData" >' + res.mpcs[i].uri + '</td>';
      body += '   <input type="hidden" name="mpcObid_'+i+'" value="'+res.mpcs[i].obid+'">';
      body += '   <input type="hidden" name="mpcName_'+i+'" value="'+res.mpcs[i].displayName+'">';
      body += '   <input type="hidden" name="mpcIsDefault_'+i+'" value="'+res.mpcs[i].isDefault+'">';
      body += '   <input type="hidden" name="mpcIsActive_'+i+'" value="'+res.mpcs[i].status+'">';
      body += '   <input type="hidden" name="mpcUri_'+i+'" value="'+res.mpcs[i].uri+'">';
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

function applyMpc() {
	var sb_Index = getSelectedId_Index();
	if (sb_Index != "" && "<%=textId%>" != "") {
		var mpcObid = eval('document.form1.mpcObid_'+sb_Index+'.value');
		var mpcName = eval('document.form1.mpcName_'+sb_Index+'.value');
		opener.applyMpc("<%=textId%>", mpcObid, mpcName);
		window.close();
	} else if (sb_Index != "") {
		var mpcObid = eval('document.form1.mpcObid_'+sb_Index+'.value');
		var mpcName = eval('document.form1.mpcName_'+sb_Index+'.value');
		var is_default = eval('document.form1.mpcIsDefault_'+sb_Index+'.value');
		var is_active = eval('document.form1.mpcIsActive_'+sb_Index+'.value');
		var mpcUri = eval('document.form1.mpcUri_'+sb_Index+'.value');
		opener.addMpc(mpcObid, mpcName, is_default, is_active, mpcUri);
		window.close();

	}
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

function selectMpc(index) {
	$('mpcIndex_' + index).checked = true;
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
    <td width="200" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.mpc.remotempc.select")%></td>
    <td width="560" class="MessageDisplay"><div id="messageDisplay"></div></td>
  </tr>
  <tr>
    <td colspan="3" height="6"></td>
  </tr>
</table>


<!--SelectTable 시작 -->
<table class="SearchTable" >
  <tr>
      <td style="padding:10px" align="center"><table>
        <tr>
          <td width="95"><img src="images/bu_search.gif" ><%= _i18n.get("mpc20ms002.column.displayname") %></td>
          <td width="200">
            <input type="text" name="displayName" id="displayName" class="FormText" size="32">
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
<table class="TotalTable">
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

<table class="PageNavigationTable">
  <tr>
    <td height="34" align="center"> <table cellpadding="0" cellspacing="0" border="0">
        <tr>
          <td class="listAPaging" valign="center"><span id="pagelist"></span></td>
        </tr>
      </table></td>
  </tr>
</table>
<!-- 버튼테이블 -->
<table class="TableLayout">
  <tr>
    <td align="center">
	  <a href="javascript:applyMpc()"><img src="images/btn_big_apply.gif" border="0" /></a>
      <a href="javascript:this.close()"><img src="images/btn_big_close.gif" border="0" /></a>
    </td>
  </tr>
</table>

</form>
</body>
</html>
