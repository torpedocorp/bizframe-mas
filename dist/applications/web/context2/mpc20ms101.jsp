<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%
/**
 * @author Mi-Young Kim 
 * @version 1.0 2008.10.01
 */
 
 String itemSet[]= {"5","10","20","30","50","100"};
 String pageSet[]= {"5","10","15","20"};//,"30","40","50"};
%>
<html>
<head>
<%@ include file="./com00in000.jsp" %>
<%@ include file="./com00in003.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>
<script language="JavaScript" type="text/JavaScript">
<!--
function viewCPA(obid) {
   window.open("cpa22ac001.jsp?obid=" + obid, "CPA", "width=1010,height=800,left=0,top=0,resizable=yes,scrollbars=yes"); 
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

   var myAjax = new Ajax.Request("cpa20ac001.jsp", opt);
}  

function searchList(page) {
   $('curPage').value = page;
   var params = Form.serialize(document.form1);
    getList();
}

function loading() {
   var body = "";

   body += '<table class="TableLayout">';
   body += '   <col width="">';
   body += '   <col width="">';
   body += '   <col width="">';
   body += '   <col width="">';
   body += '   <col width="">';
   body += '   <col width="" align="center">';
   body += '   <tr>';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.cpa.name")%></td>';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.cpa.party.role")%></td>';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.cpa.lifetime")%></td>';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.cpa.status")%></td>';
   body += '      <td class="ResultLastHeader"><%=_i18n.get("global.cpa.register")%></td>';
   body += '   </tr>';
   body += '<tr >';
   body += '   <td align="center" class="ResultLastData" colspan="5"><%= _i18n.get("global.loading")%></td></tr>';
   body += "</table>";
   
   $('listContent').innerHTML = body;
}

function showList(originalRequest) {

   var res = eval("(" + originalRequest.responseText + ")");

   var operations = "";
   var performers = "";
   var body = "";

   body += '<table class="TableLayout">';
   body += '   <col width="">';
   body += '   <col width="">';
   body += '   <col width="">';
   body += '   <col width="">';
   body += '   <col width="" align="center">';
   body += '   <tr>';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.cpa.name")%></td>';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.cpa.party.role")%></td>';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.cpa.lifetime")%></td>';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.cpa.status")%></td>';
   body += '      <td class="ResultLastHeader"><%=_i18n.get("global.cpa.register")%></td>';
   body += '   </tr>';

   for (var i=0; i<res.list.length; i++) {
      var color = i % 2 == 0 ? "#FFFFFF" : "#F9F9F9";
      
      body += '<tr>';
      body += '   <td class="ResultData" bgcolor="'+color+'">';
      body += '      <a href="mpc21ms101.jsp?obid='+res.list[i].obid+'"><font class="blue-text03">'+res.list[i].name+'</font></a>';
      body += '   </td>';      
      body += '   <td class="ResultData" bgcolor="'+color+'">'+res.list[i].partyName+'</td>';
      body += '   <td class="ResultData" bgcolor="'+color+'">'+res.list[i].start+ ' ~ ' + res.list[i].end+'</td>';
      body += '   <td class="ResultData" bgcolor="'+color+'">'+res.list[i].status+'</td>';
      body += '   <td class="ResultLastData" align="center" bgcolor="'+color+'">'+res.list[i].userId+'</td>';
      body += '</tr>';  

      body += '<input type=hidden name="cpaObid'+(i+1)+'" value="'+res.list[i].obid+'">';  
   }

   if (res.totalRows == 0) {
      body += '<tr>';
        body += '<td align="center" class="ResultLastData" colspan="5"><%= _i18n.get("msg20ms001.notfound")%></td></tr>';
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
<form name="form1" method="post">
<input type="hidden" name="curPage" id="curPage" value="1">

<!-- 제목 테이블 -->
<table class="TableLayout">
  <tr> 
    <td width="17%" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.cpa.list")%></td>
    <td width="83%" class="MessageDisplay" >
      <div id=messageDisplay></div></td>
  </tr>
  <tr> 
    <td colspan="2" height="10"></td>
  </tr>
</table>

<!--SelectTable 시작 --> 
<table class="SearchTable"  >
  <tr> 
    <td style="padding:10px"><table>
        <tr> 
          <td width="95"><img src="images/bu_search.gif" ><%=_i18n.get("global.cpa.name")%></td>
          <td width="250"><input name="cpaName" id="cpaName" type="text" class="FormTextReadOnly" size="32"> 
          </td>
          <td width="95"><img src="images/bu_search.gif" ><%=_i18n.get("global.cpa.status")%></td>
          <td width="250">
            <select name="cpaStatus" name="cpaStatus" id="cpaStatus" class="FormSelect">
               <option value="0">agreed</option>
               <option value="1">proposed</option>
               <option value="2">signed</option>
            </select>
            </td>
          <td width="50" align="right">
            <a href="javascript:searchList(1)"><img src="images/btn_go.gif" border="0" ></a></td>
        </tr>
      </table></td>
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

<!-- 검색결과 목록 -->
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

</body>
</html>
