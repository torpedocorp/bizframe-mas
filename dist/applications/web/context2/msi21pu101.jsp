<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.AppChToSubRelVO"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.dao.MxsDAO"%>
<%@ include file="com00in000.jsp" %>
<%@ include file="./com00in004.jsp" %>
<%
   String command     = request.getParameter("command");
   command = command == null ? "":command;

   if (command.equals("apply")) {
      String channelObid_index   = request.getParameter("channelObid");
      String channelObid         = request.getParameter("channelObid_"+channelObid_index);
      String channelName         = request.getParameter("channelName_"+channelObid_index);
      String subscriberObid      = request.getParameter("subscriberObid");

      String subscriberName = request.getParameter("subscriberName");
      String description    = request.getParameter("description");

      //insert subscriber-channel info
      try {

            DAOFactory df  = DAOFactory.getDAOFactory(DAOFactory.EBMS);
            MxsDAO dao     = df.getDAO("AppChToSubRel");
            AppChToSubRelVO  vo = new AppChToSubRelVO();
            vo.setCreatedBy        ("01234567-0123-0123-0123-0123456789AC");
            vo.setQueueObid(channelObid);
            vo.setSubscriberObid   (subscriberObid);
            dao.insertObject       (vo);

      } catch (Exception e) {
         e.printStackTrace();
      }

%>
   <script>
      //var body = "";
      //body += '<table width="100%" border="0" cellspacing="1" cellpadding="2">';
      //body += '   <tr align="center" valign="middle" bgcolor="#eff4fb" class="gray_bold">';
      //body += '      <td width="5%" height="21" bgcolor="#eff4fb">';
      //body += '         <input id="chbox" type="checkbox" name="allChkBtn" class="gray-text" onClick="javascript:mainAllCheck();"></td>';
      //body += '      <td width="30%" height="21" bgcolor="#eff4fb">구독 채널 이름</td>';
      //body += '      <td width="10%" bgcolor="#eff4fb">구독자 수</td>';
      //body += '      <td width="55%" bgcolor="#eff4fb">설명</td>';
      //body += '   </tr>';
      //body += '';
      //opener.document.getElementById('listContent').innerHTML = '<table><tr colspan="4"><td>haha</td></tr></table>';
      window.opener.getList();
      self.close();
   </script>
<%
      return;
   }

%>

<html>
<head>
<title><%=_i18n.get("global.page.title")%></title>
<script type="text/javascript" src="js/dhtmlHistory.js"> </script>
<script language="JavaScript" type="text/JavaScript">
<!--
function onSubmit(frm, command) {
   if (command == "apply") {
     var sb_Index = getSelectedId_Index();
     if (sb_Index != "") {
       var sbName = eval('document.form1.channelName_'+sb_Index+'.value');

	   msg = "<%=_i18n.get("msi21pu101.apply.confirm")%>";
       bChoice = window.confirm (msg);
       if (bChoice == true) {
         frm.submit();
         return;
       }
       else
         return;
     }
     else {
		 alert("<%=_i18n.get("msi21pu101.none.selected")%>");
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
   body += '      <td class="ResultHeader"" bgcolor="#eff4fb"><%= _i18n.get("global.channel.num.subscriber")%></td>';
   body += '      <td class="ResultHeader" bgcolor="#eff4fb"><%= _i18n.get("global.channel.description")%></td>';
   body += '      <td class="ResultHeader"  bgcolor="#eff4fb"></td>';
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
   body += '      <td class="ResultHeader"" bgcolor="#eff4fb"><%= _i18n.get("global.channel.num.subscriber")%></td>';
   body += '      <td class="ResultHeader" bgcolor="#eff4fb"><%= _i18n.get("global.channel.description")%></td>';
   body += '      <td class="ResultHeader"  bgcolor="#eff4fb"></td>';
   body += '   </tr>';


   for (var i=0; i<res.list.length; i++) {
      var color = i % 2 == 0 ? "#FFFFFF" : "#F9F9F9";

      body += '   <tr>';
      body += '      <td class="ResultData" bgcolor="'+color+'">'+res.list[i].name+'</td>';
      body += '      <td class="ResultData" bgcolor="'+color+'">'+res.list[i].numsubscriber+'</td>';
      body += '      <td class="ResultData" bgcolor="'+color+'">'+res.list[i].description+'</td>';
      body += '      <td class="ResultLastData" bgcolor="'+color+'">';
      body += '         <input type="radio" name="channelObid" value="'+i+'"></td>';

      body += '   </tr>';
      body += '';
      body += '   <input type="hidden" name="channelObid_'+i+'" value="'+res.list[i].obid+'">';
      body += '   <input type="hidden" name="channelName_'+i+'" value="'+res.list[i].name+'">';
   }


   if (res.totalRows == 0) {
      body += '<tr>';
        body += '<td colspan="4" align="center" class="ResultLastData"><%= _i18n.get("msg20ms001.notfound")%></td></tr>';
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

 		<!-- 검색  -->
      <form name="form1" method="post">
		<input type="hidden" name="subscriberObid" value="<%=request.getParameter("obid") %>">
		<table border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td align=center class="gray-text">
				    <%= _i18n.get("global.channel.name")%> :
				    &nbsp;&nbsp;&nbsp;
					<input type="text" name="channelName" class="textfield-3" size="20" maxlength="100">
					&nbsp;&nbsp;&nbsp;
					<a href="javascript:onSubmit(document.form1, 'search')">
                  <img src="images/btn_go.gif" width="37" height="20" border="0" align="absmiddle"></a>
				</td>
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
      </table>


		<input type="hidden" name="subscriberObid" value="<%=request.getParameter("obid") %>">
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
      <a href="javascript:onSubmit(document.form1, 'apply')">
         <img src="images/btn_big_apply.gif" width="39" height="23" border="0"> </a>
      <a href="javascript:window.close()">
         <img src="images/btn_big_close.gif" width="39" height="23" border="0"> </a> </td>
  </tr>
</table>


</body>
</html>
