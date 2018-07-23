<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%
/**
 * PMode Selection
 *
 * @author Ho-Jin Seo
 * @version 1.0 2008.10.28
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
	getPMode();
}

function getHeader() {
	var body = "";
	body += '<table class="TableLayout" style="table-layout: fixed">';
	body +='<tr>';
	body +='  <td class="ResultHeader" width="40%"><%= _i18n.get("pmd20ms001.column.name") %></td>';
	body +='  <td class="ResultHeader" width="25%"><%= _i18n.get("pmd20ms001.column.id") %></td>';
	body +='  <td class="ResultLastHeader"><%= _i18n.get("pmd20ms001.column.desc") %></td>';
	body +='</tr>';
	return body;
}

function loading() {
   var body = "";

   body = getHeader();
   body += '<tr>';
   body += '   <td colspan="3" class="ResultLastData" align="center"><%= _i18n.get("global.loading")%></td></tr>';

   body += "</table>";

   $('listContent').innerHTML = body;

}

function showList(originalRequest) {

   var res = eval("(" + originalRequest.responseText + ")");

   var operations = "";
   var performers = "";
   var body = "";

   body = getHeader();
   for (var i=0; i<res.pmodes.length; i++) {
      color = i % 2 == 0 ? "#FFFFFF" : "#F9F9F9";

      body += '<tr>';
      body += '   <td class="ResultData" align="left">';
      body += '	     <input type="radio" name="pmodeIndex" id="pmodeIndex_'+i+'" value="' + i + '">';
      body += '	     <a href="javascript:selectPMode(' + i + ')"><font class="blue-text03">' + res.pmodes[i].name + '</font></a></td>';
      body += '   <td class="ResultData">'+res.pmodes[i].id+'</td>';
      body += '   <td class="ResultLastData">'+res.pmodes[i].desc +'</td>';
      body += '   <input type="hidden" name="pmodeObid_'+i+'" value="'+res.pmodes[i].obid+'">';
      body += '   <input type="hidden" name="pmodeId_'+i+'" value="'+res.pmodes[i].id+'">';
      body += '   <input type="hidden" name="agreement_'+i+'" value="'+res.pmodes[i].agreement+'">';
      body += '</tr>';
   }
   if (res.totalRows == 0) {
      body += '<tr>';
        body += '<td colspan="3" class="ResultLastData" align="center"><%= _i18n.get("pmd20ms001.notfound")%></td></tr>';
   }
   body += "</table>";
   $('listContent').innerHTML = body;
   $('row_size').innerHTML = res.totalRows;
   $('pagelist').innerHTML = res.pagelist;
}

function getPMode() {

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
   getPMode();
}

function apply() {
	var sb_Index = getSelectedId_Index();
	if (sb_Index != "") {
		var pmodeObid = eval('document.form1.pmodeObid_'+sb_Index+'.value');
		var pmodeId = eval('document.form1.pmodeId_'+sb_Index+'.value');
		var agreement = eval('document.form1.agreement_'+sb_Index+'.value');
		opener.applyRef(pmodeObid, pmodeId, agreement);
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

function selectPMode(index) {
	$('pmodeIndex_' + index).checked = true;
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
    <td width="200" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.pmd.list")%></td>
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
          <td width="95"><img src="images/bu_search.gif" ><%= _i18n.get("pmd20ms001.column.name") %></td>
          <td width="200">
            <input type="text" name="name" id="name" class="FormText" size="32">
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
	  <a href="javascript:apply()"><img src="images/btn_big_apply.gif" border="0" /></a>
      <a href="javascript:this.close()"><img src="images/btn_big_close.gif" border="0" /></a>
    </td>
  </tr>
</table>

</form>
</body>
</html>
