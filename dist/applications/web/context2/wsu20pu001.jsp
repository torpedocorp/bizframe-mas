<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%
/**
 * Party ID 선택창
 *
 * @author Ho-Jin Seo
 * @version 1.0 2008.09.25
 */
%>
<html>
<head>
<%@ include file="./com00in000.jsp" %>
<%@ include file="./com00in003.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>
<!-- script type="text/javascript" src="js/dhtmlHistory.js"> </script-->
<script language="JavaScript" type="text/JavaScript">
<!--
function initialize() {
	searchList(1);
}

function showList(originalRequest) {
   	//closeInfo();

	var res = eval("(" + originalRequest.responseText + ")");

	var operations = "";
	var performers = "";
	var body = "";
	body = getHeader();

	var num = 0;
	var party_type = "";
	for (var i=0; i<res.party.length; i++) {
		if (res.party[i].mine == "0")
			party_type = "<%=_i18n.get("wsu20pu001.other.party")%>";
		else
			party_type = "<%=_i18n.get("wsu20pu001.my.party")%>";

		body += '<tr>';
		body += '<td class="ResultData" align="left">';
		body += '	<input type="radio" name="partyIndex" id="partyIndex_'+i+'" value="' + i + '">';
		body += '	<a href="javascript:selectParty(' + i + ')"><font class="blue-text03">' + res.party[i].partyid + '</font></a></td>';
		body += '<td class="ResultData" align="center">' + party_type + '</td>';
		body += '<td class="ResultLastData" align="left">' + res.party[i].cpa_name + '</td>';
		body += '   <input type="hidden" name="partyObid_'+i+'" value="'+res.party[i].obid+'">';
		body += '   <input type="hidden" name="partyName_'+i+'" value="'+res.party[i].partyid+'">';
		body += '   <input type="hidden" name="mine_'+i+'" value="'+res.party[i].mine+'">';
		body += '</tr>';
	}

	if (res.party.length == 0) {
		body += '<tr>';
		body += '<td class="ResultData" colspan="3" align="center"><%= _i18n.get("wsu20ms301.notfound")%></td></tr>';
	}

	body += "</table>";
	$('listContent').innerHTML = body;

	$('pagelist').innerHTML = res.pagelist;
	$('row_size').innerHTML = res.party.length;

}
function getHeader() {
	var body = "";
	body += '<table class="TableLayout" style="width:580">';
	body += '  <COLGROUP>';
	body += '  <COL span="1" style="width:30%;">';
	body += '  <COL span="1" style="width:12%;">';
	body += '  <COL span="1" style="width:50%;">';
	body += '  </COLGROUP>';
	body += '<tr>';
	body += '<td class="ResultHeader"><%=_i18n.get("wsu20pu001.col.1")%></td>';
	body += '<td class="ResultHeader"><%=_i18n.get("wsu20pu001.col.2")%></td>';
	body += '<td class="ResultLastHeader"><%=_i18n.get("wsu20pu001.col.3")%></td>';
	body += '</tr>';

	return body;
}

function getCpaPartyList() {

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
	var myAjax = new Ajax.Request("./wsu20ac003.jsp", opt);

}

function getPModePartyList() {

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
	var myAjax = new Ajax.Request("./wsu20ac004.jsp", opt);

}

function searchList(page) {
	$('curPage').value = page;
	if ($('partytype').value == "1") {
		getCpaPartyList();
	} else if ($('partytype').value == "2") {
		getPModePartyList();
	}
}

function applyParty() {
	var sb_Index = getSelectedId_Index();
	if (sb_Index != "") {
		var partyObid = eval('document.form1.partyObid_'+sb_Index+'.value');
		var partyName = eval('document.form1.partyName_'+sb_Index+'.value');
		var mine = eval('document.form1.mine_'+sb_Index+'.value');
		opener.applyParty(partyObid, partyName, mine);
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

function selectParty(index) {
	$('partyIndex_' + index).checked = true;
}

window.onload = initialize;

//-->
</script>
</head>

<body>
<form name="form1" method="POST">
<input type="hidden" name="curPage" id="curPage" value="1">
<input type="hidden" name="partytype" id="partytype" value="1">
<table class="TableLayout" style="width:580">
  <tr>
    <td width="180" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.cpaparty.list")%></td>
    <td width="380" class="MessageDisplay" ><div id=messageDisplay></div></td>
  </tr>
  <tr>
    <td colspan="2" height="6"></td>
  </tr>
</table>
<!--SelectTable 시작 -->
<table class="SearchTable" style="width:580">
  <tr>
    <td style="padding:10px" align="center"><table>
        <tr>
          <td width="95"><img src="images/bu_search.gif" ><%= _i18n.get("wsu20pu001.agreement.search") %></td>
          <td width="120"><input name="cpa_name" id="cpa_name" type="text" class="FormText" size="32"></td>
          <td align="right"><a href="javascript:searchList(1);"><img src="images/btn_go.gif" border="0" ></a></td>
        </tr>
      </table></td>
  </tr>
</table>
<!-- 토탈테이블 -->
<table class="TotalTable" style="width:580">
  <tr>
    <td align="left">[ <%= _i18n.get("global.search") %> : <span id="row_size"></span> <%= _i18n.get("global.case") %> ]
            <select name="page_Cnt2" id="page_Cnt2" size="1" class="selectfield" onChange="javascript:searchList(1)">
	            <option value="5">5</option>
	            <option value="10" selected>10</option>
	            <option value="15">15</option>
	            <option value="20">20</option>
            </select>
            <span><%= _i18n.get("global.pages") %>
            <select name="item_Cnt2" id="item_Cnt2" size="1" class="selectfield" onChange="javascript:searchList(1)">
	            <option value="5">5</option>
	            <option value="10" selected>10</option>
	            <option value="20">20</option>
	            <option value="30">30</option>
	            <option value="50">50</option>
	            <option value="100">100</option>
            </select>
            <%= _i18n.get("global.rows") %></span>
    </td>
  </tr>
</table>
<!-- 결과 목록 테이블 코드 시작-->
<div id="listContent"></div>
</form>
<!--naiigation-->
<table class="PageNavigationTable" style="width:580">
  <tr>
    <td height="34" align="center">
      <table cellpadding="0" cellspacing="0" border="0">
        <tr>
          <td><span id="pagelist"></span></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td align="center">
	  <a href="javascript:applyParty()"><img src="images/btn_big_apply.gif" border="0" /></a>
      <a href="javascript:this.close()"><img src="images/btn_big_close.gif" border="0" /></a>
    </td>
  </tr>
</table>
</body>
</html>