<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%
/**
 * @author Gemini Kim
 * @author Ho-Jin Seo
 * @version 1.0
 */

String channelObid = request.getParameter("channel.obid");

%>
<html>
<head>
<%@ include file="com00in000.jsp" %>
<%@ include file="./com00in004.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>
<script language="JavaScript" type="text/JavaScript">
<!--

function onSubmit(frm) {
/*
   if (frm.name == "form1") {
      if (frm.subscriberName.value == "" ) {
         alert("Subscriber 이름을 입력해 주십시오.");
         return;
      }
   }
   else if (frm.name == "form1") {
      var sb_Index =getSelectedId_Index();
      if (sb_Index != "") {
         var sbName = eval('document.form1.subscriberName_'+sb_Index+'.value');
         msg = "선택된 Subscriber("+sbName+") 를  적용하시겠습니까?";
         bChoice = window.confirm (msg);
         if (bChoice == true) {
            frm.submit();  
            return; 
         }
         else return;	    	
      }
      else {
         alert("선택된 Subscriber가  없습니다.");
         return;
      }
   }      
*/
   getList();
}   

function getSelectedId_Index() {
   var inputs      = document.getElementsByTagName('input');
   var sb_Index = "" ;
   for (var i = 0; i < inputs.length; i++) {
      if (inputs[i].type == 'radio' && inputs[i].checked==true) {           
         sb_Index = inputs[i].value;
      }
   }
   return sb_Index;
}  

function loading() {
   var body = "";

   body += '<table class="PopupLayoutTable">';
   body += '   <col width="100">';
   body += '   <col width="460">';
   body += '   <tr>';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.subscriber.name") %></td>';
   body += '      <td class="ResultLastHeader"><%=_i18n.get("global.subscriber.description") %></td>';
   body += '   </tr>';
   body += '   <tr>';
   body += '      <td colspan="4" align="center" class="ResultLastData"><%= _i18n.get("global.loading")%></td></tr>';
   body += "</table>";
   
   
   $('listContent').innerHTML = body;

}

function getList() {   

   loading();

   var params = Form.serialize(document.form1);
   var opt = {
      method: 'post', 
      parameters: params, 
      onSuccess: showList,
       on404: function(t) {
           $('messageDisplay').innerHTML = '<%=_i18n.get("err00zz404.message") %>';
           showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
       },
       onFailure: function(t) {
           $('messageDisplay').innerHTML = '<%=_i18n.get("global.error.retry") %>';
           showErrorPopup(t.responseText, null, null, null);
       }
   }

   var myAjax = new Ajax.Request("msi20ac201.jsp", opt);
}  

function searchList(page) {
   $('curPage').value = page;

   var params = Form.serialize(document.form1);
   dhtmlHistory.add((new Date()).toString(), params);
   
   getList();
}

function showList(originalRequest) {

   var res = eval("(" + originalRequest.responseText + ")");

   var operations = "";
   var performers = "";
   var body = "";

   body += '<table class="PopupLayoutTable">';
   body += '   <col width="100">';
   body += '   <col width="460">';
   body += '   <tr>';
   body += '      <td class="ResultHeader"><%=_i18n.get("global.subscriber.name") %></td>';
   body += '      <td class="ResultLastHeader"><%=_i18n.get("global.subscriber.description") %></td>';
   body += '   </tr>';

   for (var i=0; i<res.list.length; i++) {
      var color = i % 2 == 0 ? "#FFFFFF" : "#F9F9F9";

      body += '   <tr>';
      body += '      <td class="ResultData">'+res.list[i].name+'</td>';
      body += '      <td class="ResultLastData">'+res.list[i].description+'</td>';
      body += '   </tr>';
      body += '';
   }


   if (res.totalRows == 0) {
      body += '<tr>';
        body += '<td colspan="4" align="center" class="ResultLastData"><%= _i18n.get("msi20pu201.not.found")%></td></tr>';
   }

   body += "</table>";
   
   
   $('listContent').innerHTML = body;
   
   $('row_size').innerHTML = res.totalRows;
   $('pagelist').innerHTML = res.pagelist;
}   
//-->
</script>
</head>

<body style="margin : 0 0 0 0">

<br>


<table width="610" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td height="45" background="images/pop_topbg.gif" class="PopupTitle" > <img src="images/pop_tit_01.gif" width="5" height="13" align="absmiddle"> 
	<%= _i18n.get("menu.subscriber.list")%></td>
  </tr>
  <tr> 
    <td style="padding:10px 20 10 20"> 
      
      <!-- 검색  -->
		<form name="form1" method="post" action="msi20pu201.jsp?cmn=search">
      <input type="hidden" name="channel.obid" value="<%=channelObid %>">
      <input type="hidden" name="command" value="apply">
      <input type="hidden" name="curPage" id="curPage" value="1">

      <table>
        <tr> 
          <td  style="padding:5px 0 5 10"  class="PopSearchTable"><%= _i18n.get("global.search")%> 
            <input type="text" name="subscriberName" class="FormText" onFocus="" size="30" />
            <a href="javascript:onSubmit()">
               <img src="images/btn_go.gif" width="37" height="20" border="0" align="absmiddle"></a></td>
        </tr>
        <tr>
          <td height="5">
		  </td>
        </tr>
      </table> 
      </form>
     
      <table>
         <!-- 리스트  -->
         <tr>
            <td>
               <div id="listContent"></div>
                        <script>                        
                        getList();
                        </script>
            </td>
         </tr>
      </table>      

      <table class="PopupLayoutTable">
        <tr>
          <td height="26" align="center" valign="bottom"> 
			<table>
			  <tr> 
			    <td height="34" align="center"> <table cellpadding="0" cellspacing="0" border="0">
			        <tr> 
			          <td class="listAPaging" valign="center"><span id="pagelist"></span></td> 
			        </tr>
			      </table></td>
			  </tr>
			</table>
          </td>
        </tr>
      </table>
      
    </td>
  </tr>
  <tr> 
    <td align="right" bgcolor="#F5F5F5" style="padding:10px  10  10  0"> 
      <a href="javascript:window.close()"><img src="images/btn_big_close.gif" width="39" height="23" border="0"></a> 
    </td>
  </tr>
</table>


</body>
</html>
