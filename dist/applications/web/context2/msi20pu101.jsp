<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.AppChannelVO"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.dao.MxsDAO"%>
<%
/**
 * @author Gemini Kim
 * @author Ho-Jin Seo
 * @version 1.0
 */

   String performer_obid   = request.getParameter("performer.obid");
   String command          = request.getParameter("command");

   if (command != null && command.equals("apply")) {
      String channel_index       = request.getParameter("channel.index");
      String channelObid         = request.getParameter("channelObid_"+channel_index);
      String channelName         = request.getParameter("channelName_"+channel_index);

      DAOFactory df = DAOFactory.getDAOFactory(DAOFactory.EBMS);
      MxsDAO dao = df.getDAO("AppChannel");
      QueryCondition qc = new QueryCondition();
      qc.add("obid", channelObid);
      AppChannelVO channel = (AppChannelVO)dao.findObject(qc);
%>
   <script>
      opener.document.getElementById('<%=performer_obid%>_performer.name').value='<%=channel.getName()%>';
      opener.document.getElementById('<%=performer_obid%>_channel.obid').value='<%=channelObid%>';
      self.close();
   </script>
<%
      return;
   }
%>

<html>
<head>
<%@ include file="com00in000.jsp" %>
<%@ include file="./com00in004.jsp" %>
<script type="text/javascript" src="js/dhtmlHistory.js"> </script>
<title><%=_i18n.get("global.page.title")%></title>

<script language="JavaScript" type="text/JavaScript">
<!--
function onSubmit(frm, command) {
   if (command == "apply") {
     var sb_Index = getSelectedId_Index();
     if (sb_Index != "") {
       var channelName = eval('document.form1.channelName_'+sb_Index+'.value');
       //선택한 채널("channelName")을 수행자로 설정하시겠습니까?
       msg = "<%=_i18n.get("msi20pu101.register.confirm")%>";
       bChoice = window.confirm (msg);
       if (bChoice == true) {
         frm.submit();
         return;
       }
       else
         return;
     }
     else {
         alert("<%=_i18n.get("msi20pu101.non.selected")%>");
         return;
     }
   }
   else if (command = 'search') {
      getList();
   }
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
   body += '   <col width="40">';
   body += '   <col width="190" >';
   body += '   <col width="20" align="center">';
   body += '   <tr>';
   body += '      <td class="ResultHeader" bgcolor="#eff4fb"><%= _i18n.get("global.channel.name")%></td>';
   body += '      <td class="ResultHeader" bgcolor="#eff4fb"><%= _i18n.get("global.channel.num.subscriber")%></td>';
   body += '      <td class="ResultHeader" bgcolor="#eff4fb"><%= _i18n.get("global.channel.description")%></td>';
   body += '      <td class="ResultLastHeader"  bgcolor="#eff4fb"></td>';
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

   var myAjax = new Ajax.Request("msi20ac101.jsp", opt);
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
   body += '   <col width="40">';
   body += '   <col width="190" >';
   body += '   <col width="20" align="center">';
   body += '   <tr>';
   body += '      <td class="ResultHeader" bgcolor="#eff4fb"><%= _i18n.get("global.channel.name")%></td>';
   body += '      <td class="ResultHeader" bgcolor="#eff4fb"><%= _i18n.get("global.channel.num.subscriber")%></td>';
   body += '      <td class="ResultHeader" bgcolor="#eff4fb"><%= _i18n.get("global.channel.description")%></td>';
   body += '      <td class="ResultLastHeader"  bgcolor="#eff4fb"></td>';
   body += '   </tr>';


   for (var i=0; i<res.list.length; i++) {
      var color = i % 2 == 0 ? "#FFFFFF" : "#F9F9F9";

      body += '   <tr>';
      body += '      <td class="ResultData" bgcolor="'+color+'">'+res.list[i].name+'</td>';
      body += '      <td class="ResultData" align="center" bgcolor="'+color+'">'+res.list[i].numsubscriber+'</td>';
      body += '      <td class="ResultData" bgcolor="'+color+'">'+res.list[i].description+'</td>';
      body += '      <td class="ResultLastData" bgcolor="'+color+'">';
      body += '         <input type="radio" name="channel.index" value="'+i+'"></td>';

      body += '   </tr>';
      body += '';
      body += '   <input type="hidden" name="channelObid_'+i+'" value="'+res.list[i].obid+'">';
      body += '   <input type="hidden" name="channelName_'+i+'" value="'+res.list[i].name+'">';
   }


   if (res.totalRows == 0) {
      body += '<tr>';
        body += '<td colspan="4" align="center" class="ResultLastData"><%= _i18n.get("msi20pu101.not.found")%></td></tr>';
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

<table width="600" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td height="45" background="images/pop_topbg.gif" class="PopupTitle">
      <img src="images/pop_tit_01.gif" width="5" height="13" align="absmiddle">
      <%= _i18n.get("menu.channel.select")%></td>
  </tr>
  <tr>
    <td style="padding:10px 20 10 20">

      <form name="form1" method="post">
      <input type="hidden" name="performer.obid" value="<%=performer_obid %>">
      <table>
        <tr>
          <td  style="padding:5px 0 5 10"  class="PopSearchTable"><%= _i18n.get("global.channel.name")%>
            <input type="text" name="channelName" class="FormText" onFocus="clearText(this)" size="30" />
            <a href="javascript:onSubmit(document.form1, 'search')">
               <img src="images/btn_go.gif" width="37" height="20" border="0" align="absmiddle"></a></td>
        </tr>
        <tr>
          <td height="5">
		  </td>
        </tr>
      </table>

       <table width="550" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td width="400" height="25" align="left" valign="top" class="gray-text">
            [<%= _i18n.get("global.search") %> : <span id="row_size"></span> <%= _i18n.get("global.case") %>] &nbsp;&nbsp;
           </td>
        </tr>
      </table>

		<input type="hidden" name="performer.obid" value="<%=performer_obid %>">
      <input type="hidden" name="command" value="apply">
      <input type="hidden" name="curPage" id="curPage" value="1">

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
      </form>

    </td>
  </tr>
  <tr>
    <td>
       <table class="PopupLayoutTable">
          <tr>
             <td height="26" align="center" valign="bottom">
               <table cellpadding="0" cellspacing="0" border="0">
                 <tr>
                   <td><a href="#"><img src="images/btn_first.gif" border="0"  class="btn_first" /></a></td>
                   <td><a href="#"><img src="images/btn_prev.gif" border="0" class="btn_prev" /></a></td>
                   <td class="listAPaging"> <span class="gray-text02" id="pagelist"></span> </td>
                   <td><a href="#"><img src="images/btn_next.gif" border="0"  class="btn_next" /></a></td>
                   <td><a href="#"><img src="images/btn_last.gif" border="0"  class="btn_last" /></a></td>
                 </tr>
               </table>
             </td>
          </tr>
       </table>
    </td>
  </tr>
  <tr>
    <td align="right" bgcolor="#F5F5F5" style="padding:10px  10  10  0">
      <a href="javascript:onSubmit(document.form1, 'apply')"><img src="images/btn_big_apply.gif" width="39" height="23" border="0"> </a>
      <a href="javascript:window.close()"><img src="images/btn_big_close.gif" width="39" height="23" border="0"> </a> </td>
  </tr>
</table>



</body>
</html>
