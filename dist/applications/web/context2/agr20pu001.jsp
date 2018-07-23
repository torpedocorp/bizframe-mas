<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%
/**
 * List AgreementRef
 *
 * @author Mi-Young Kim
 * @author Ho-Jin Seo
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
    out.println("<script>alert('" + _i18n.get("agr20pu001.notfound") + "');history.back();</script>");
   	return;
}
%>
<title><%=_i18n.get("global.page.title")%></title>
<script language="JavaScript" type="text/JavaScript">
<!--
function initialize() {
	getAgreementList();
}

function detail(obid) {
   location = "agr21ms001.jsp?obid=" + obid;
}

function showList(originalRequest) {
   	//closeInfo();

	var res = eval("(" + originalRequest.responseText + ")");
	var operations = "";
	var performers = "";
	var body = "";
	body = getHeader();

	var num = 0;
	var auth_type = "";
	for (var i=0; i<res.agreement.length; i++) {
		if (res.agreement[i].reftype == "0")
			ref_type = "<%=_i18n.get("agr20ms001.ref.type.none")%>";
		else if (res.agreement[i].reftype == "1")
			ref_type = "<%=_i18n.get("agr20ms001.ref.type.cpa")%>";
		else if (res.agreement[i].reftype == "2")
			ref_type = "<%=_i18n.get("agr20ms001.ref.type.pmode")%>";


		body += '<tr>';
		body += '<input type=hidden name="obid' + i + '" id="obid' + i + '" value="' + res.agreement[i].obid + '">';
		body += '<td class="ResultData" align="left"><a href="javascript:detail(\'' + res.agreement[i].obid + '\')"><font class="blue-text03">' + res.agreement[i].id + '</font></a></td>';
		body += '<td class="ResultData" align="left">' + res.agreement[i].type + '</td>';
		body += '<td class="ResultLastData" align="left">' + ref_type + '</td>';
		body += '</tr>';
	}

	if (res.agreement.length == 0) {
		body += '<tr>';
		body += '<td class="ResultData" colspan="3" align="center"><%= _i18n.get("agr20ms001.notfound")%></td></tr>';
	}

	body += "</table>";
	$('listContent').innerHTML = body;

	$('row_size').innerHTML = res.agreement.length;
	$('pagelist').innerHTML = res.pagelist;
}
function getHeader() {
	var body = "";
	body += '<table class="TableLayout" >';
	body += '  <COLGROUP>';
	body += '  <COL span="1" style="width:60%;">';
	body += '  <COL span="1" style="width:20%;">';
	body += '  <COL span="1" style="width:20%;">';
	body += '  </COLGROUP>';
	body += '<tr>';
	body += '<td class="ResultHeader"><%=_i18n.get("global.agreement.id")%></td>';
	body += '<td class="ResultHeader"><%=_i18n.get("global.agreement.type")%></td>';
	body += '<td class="ResultLastHeader"><%=_i18n.get("global.agreement.ref.type")%></td>';
	body += '</tr>';

	return body;
}

function getAgreementList() {

	var body = getHeader();
	body += '<tr>';
	body += '<td class="ResultData" colspan="3" align="center"><%=_i18n.get("global.processing") %></td>';
	body += '</tr>';
	body += '</table>';
	$('listContent').innerHTML = body;

	var params = Form.serialize(document.form1);
	//openInfo('<%=_i18n.get("global.processing") %>');
	var opt = {
		method: 'post',
		asynchronous : false,
		parameters: params,
		onSuccess: showList,
	    on404: function(t) {
	    	//closeInfo();
        	$('messageDisplay').innerHTML = '<%=_i18n.get("err00zz404.message") %>';
        //	showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
	    },
	    onFailure: function(t) {
	    	//closeInfo();
        	$('messageDisplay').innerHTML = '<%=_i18n.get("global.error.retry") %>';
        	//showErrorPopup(t.responseText, null, null, null);
	    }
	}
	var myAjax = new Ajax.Request("./agr20ac001.jsp", opt);

}
function searchList(page) {
	$('curPage').value = page;
	getAgreementList();
}

function searchList(page) {
	$('curPage').value = page;

	var params = Form.serialize(document.form1);
	getAgreementList();
}

window.onload = initialize;

//-->
</script>
</head>
<body bgcolor=#FFFFFF leftmargin=0 topmargin=0 marginwidth=0 marginheight=0 >

<form name="form1" method="POST">
<input type="hidden" name="curPage" id="curPage" value="1">
<input type="hidden" name="mpcObid" id="mpcObid" value="<%= mpcObid %>">
<!-- 제목 테이블 -->
<table class="TableLayout">
  <tr>
    <td width="200" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.mpc.agreementref.list")%></td>
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
      <select name="page_Cnt" id="page_Cnt" size="1" class="FormSelect" onChange="javascript:searchCpas(1)">
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
      <select name="item_Cnt" id="item_Cnt" size="1" class="FormSelect" onChange="javascript:searchCpas(1)">
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
<!--SelectTable 시작 -->
<table class="SearchTable">
  <tr>
      <td style="padding:10px" align="center"><table>
        <tr>
          <td width="95"><img src="images/bu_search.gif" ><%=_i18n.get("global.agreement.id")%></td>
          <td width="250"><input name="id" id="id" type="text" class="FormText" size="32"></td>
          <td width="95"><img src="images/bu_search.gif" ><%= _i18n.get("global.agreement.ref.type") %></td>
          <td width="250"><select name="reftype" id="reftype" class="FormSelect" style="width:187;">
              <option value=""><%= _i18n.get("global.all") %>&nbsp;&nbsp;&nbsp;&nbsp;</option>
              <option value="1"><%= _i18n.get("agr20ms001.ref.type.cpa") %></option>
              <option value="2"><%= _i18n.get("agr20ms001.ref.type.pmode") %></option>
              <option value="0"><%= _i18n.get("agr20ms001.ref.type.none") %></option>
            </select></td>
          <td align="right"><a href="javascript:searchList(1);"><img src="images/btn_go.gif" border="0" ></a></td>
        </tr>
      </table>
      </td>
  </tr>
</table>
<br>

<!-- ---------------->
<!-- 검색결과 목록 -->
<!-- ---------------->
<table class="TableLayout">
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
    <td align="center" style="padding-top:15">
      <a href="javascript:self.close();"><img src="images/btn_big_close.gif" width="39" height="23" border="0"></a>
    </td>
  </tr>
</table>
</form>
</body>
</html>
