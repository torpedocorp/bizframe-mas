<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.org.MxsUser" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%
/**
 * detail for user
 *
 * @author Ho-Jin Seo
 * @version 1.0
 */
 	String obid = request.getParameter("obid");

	MxsEngine engine = MxsEngine.getInstance();
	QueryCondition qc = new QueryCondition();
	qc.add("obid", obid);
	MxsUser userVO = (MxsUser) engine.getObject("User", qc, DAOFactory.COMMON);

	String description = StringUtil.nullCheck(userVO.getDescription());
	String email = StringUtil.nullCheck(userVO.getEmail());
	String cell = StringUtil.nullCheck(userVO.getCellphone());
	String cell1 = "";
	String cell2 = "";
	String cell3 = "";
	if(cell.length()==10)
	{
		cell1 = cell.substring(0,3);
		cell2 = cell.substring(3,6);
		cell3 = cell.substring(6);
	}
	else if(cell.length()==11)
	{
		cell1 = cell.substring(0,3);
		cell2 = cell.substring(3,7);
		cell3 = cell.substring(7);
	}
%>
<html>
<head>
<%@ include file="./com00in000.jsp" %>
<%@ include file="./com00in003.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>
<script language="JavaScript" type="text/JavaScript">
<!--

function deleteUser() {
	msg = "<%=_i18n.get("usr21ms001.delete.confirm")%>";
	openConfirm(msg, deleteOkFunction, null, "<%=_i18n.get("global.warning")%>");
}

function deleteOkFunction() {
	Windows.closeAllModalWindows();
	clearNotify();

	var params = Form.serialize(document.form1);

	openInfo('<%=_i18n.get("global.processing") %>');
	var opt = {
	    method: 'post',
	    postBody: params,
	    asynchronous : false,
	    onSuccess: function(t) {
	    	//closeInfo();

	    	Dialog.setInfoMessage('<%=_i18n.get("usr21ms001.operation.delete") %>');
	    	$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("usr21ms001.operation.delete") %>';
	    	timeout=2; setTimeout(goList, 1000);
	    },
	    on404: function(t) {
	    	closeInfo();
	        $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("err00zz404.message") %>';
	        //showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
	    },
	    onFailure: function(t) {
	    	closeInfo();
	        $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("global.error.retry") %>';
	        //showErrorPopup(t.responseText, null, null, null);
	    }
	}

	var myAjax = new Ajax.Request('./usr40ac001.jsp', opt);
}

function updateUser() {
	if ($('passwd').value != $('passwd2').value) {
		alert("<%=_i18n.get("usr21ms001.passwd.incorrect")%>");
		return;
	}
	tel1 = $('cell1').value;
	tel2 = $('cell2').value;
	tel3 = $('cell3').value;
	telnum =  tel1  + tel2 +  tel3;
	if(tel1 != "" || tel2 !="" || tel3 !="") {
		if(!isNumeric(telnum)) {
			alert("<%=_i18n.get("usr21ms001.cellphone.incorrect")%>");
			return;
		} else if (tel1 == "" || tel2 == "" || tel3 == "" || telnum.length < 10 || tel3.length !=4 || tel2.length < 3) {
			alert("<%=_i18n.get("usr21ms001.cellphone.incorrect")%>");
			return;
		}
	}

	$('cell').value= telnum;
	msg = "<%=_i18n.get("usr21ms001.update.confirm")%>";
	openConfirm(msg, updateOkFunction, null, "<%=_i18n.get("global.warning")%>");
}

function updateOkFunction() {
	Windows.closeAllModalWindows();
	clearNotify();

	var params = Form.serialize(document.form1);

	openInfo('<%=_i18n.get("global.processing") %>');
	var opt = {
	    method: 'post',
	    postBody: params,
	    onSuccess: function(t) {
	    	closeInfo();
	    	$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("usr21ms001.operation.update") %>';
	    	//Dialog.setInfoMessage('<%=_i18n.get("usr21ms001.operation.update") %>');
	    },
	    on404: function(t) {
	    	closeInfo();
	        $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("err00zz404.message") %>';
	        //showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
	    },
	    onFailure: function(t) {
	    	closeInfo();
	        $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("global.error.retry") %>';
	        //showErrorPopup(t.responseText, null, null, null);
	    }
	}

	var myAjax = new Ajax.Request('./usr30ac001.jsp', opt);
}

function goList() {
	timeout--;
	if (timeout >0) {
		setTimeout(goList, 1000) ;
	} else {
		history.go(-1);
	}
}

function validEMAIL( str )
{
     /* check whether input value is included space or not  */
     if(str == ""){
     	alert("<%=_i18n.get("usr21ms001.email.empty")%>");
     	return 0;
     }
     var retVal = checkSpace( str );
     if( retVal != "") {
         alert("<%=_i18n.get("usr21ms001.email.notspace")%>");
         return 0;
     }

     /* checkFormat */
     var isEmail = /[-!#$%&'*+\/^_~{}|0-9a-zA-Z]+(\.[-!#$%&'*+\/^_~{}|0-9a-zA-Z]+)*@[-!#$%&'*+\/^_~{}|0-9a-zA-Z]+(\.[-!#$%&'*+\/^_~{}|0-9a-zA-Z]+)*/;
     if( !isEmail.test(str) ) {
         alert("<%=_i18n.get("usr21ms001.email.incorrect")%>");
         return 0;
     }
     if( str.length > 64 ) {
         alert("<%=_i18n.get("usr21ms001.email.long")%>");
         return 0;
     }
     return 1;
}

function checkSpace( str )
{
     if(str.search(/\s/) != -1){
     	return 1;
     }

     else {
         return "";
     }
}

function isNumeric(s) {
        for (i=0; i<s.length; i++) {
                c = s.substr(i, 1);
                if (c < "0" || c > "9") return false;
        }
        return true;
}
//-->
</script>
</head>
<body>
<%
	if (userVO == null) {
		out.write("<script>alert('" + _i18n.get("usr21ms001.notfound") +"'); history.go(-1);</script>");
		return;
	}
%>
<!-- 제목테이블 -->
<table class="TableLayout">
  <tr>
    <td width="210" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.user.info")%></td>
    <td width="550" class="MessageDisplay"><div id=messageDisplay></div></td>
  </tr>
  <tr>
    <td colspan="2" height="6"></td>
  </tr>
</table>
<!-- 등록테이블-->
<form name="form1" method="post" >
<input type="hidden" name="obid" value="<%=obid%>">
<input name="cell" id="cell" type="hidden">
<table class="FieldTable">
        <tr>
          <td width="120" class="FieldLabel"><%=_i18n.get("global.user.id")%></td>
          <td width="260" class="FieldData" colspan="3"><input name="userid" id="userid" type="text" class="FormTextReadOnly" readonly size="32" value="<%= userVO.getUserId() %>">
          </td>
        </tr>
        <tr>
          <td width="120" class="FieldLabel"><%=_i18n.get("global.user.password")%></td>
          <td width="260" class="FieldData" colspan="3">
            <input name="passwd" id="passwd" type="password" class="FormText" size="32"></td>
        </tr>
        <tr>
          <td width="120" class="FieldLabel"><%=_i18n.get("global.user.password.confirm")%></td>
          <td width="260" class="FieldData" colspan="3">
            <input name="passwd2" id="passwd2" type="password" class="FormText" size="32"></td>
        </tr>
        <tr>
          <td class="FieldLabel"><%=_i18n.get("global.user.email")%></td>
          <td class="FieldData" colspan="3"><input name="email" id="email" type="text" class="FormText" size="64" maxlength="100" value="<%= email %>"></td>
        </tr>
        <tr>
          <td class="FieldLabel"><%=_i18n.get("global.user.cellphone")%></td>
          <td class="FieldData" colspan="3">
          <select name="cell1" id="cell1" style='width:67px' class="FormText">
            <option value="" selected><%=_i18n.get("global.user.cell.id")%></option>
            <option value="010" <%if(cell1.equals("010"))out.print("selected"); %>>010</option>
            <option value="011" <%if(cell1.equals("011"))out.print("selected"); %>>011</option>
            <option value="016" <%if(cell1.equals("016"))out.print("selected"); %>>016</option>
            <option value="017" <%if(cell1.equals("017"))out.print("selected"); %>>017</option>
            <option value="018" <%if(cell1.equals("018"))out.print("selected"); %>>018</option>
            <option value="019" <%if(cell1.equals("019"))out.print("selected"); %>>019</option>
          </select>
		       -
		      <input name="cell2" id="cell2" type="text" class="FormText" value="<%= cell2%>" size="4" maxlength="4">
		      -
		      <input name="cell3" id="cell3" type="text" class="FormText" value="<%= cell3 %>" size="4" maxlength="4">
          </td>
        </tr>
        <tr>
          <td class="FieldLabel"><%=_i18n.get("global.user.description")%></td>
          <td class="FieldData" colspan="3"><input name="description" id="description" type="text" class="FormText" size="100" value="<%= description %>"></td>
        </tr>
</table>
<!-- 버튼테이블 -->
<table class="TableLayout" >
  <tr>
    <td align="right" style="padding-top:15"><a href="javascript:history.go(-1)"><img src="images/btn_big_list.gif" width="39" height="23" border="0"></a>
      <a href="javascript:updateUser()"><img src="images/btn_big_change.gif" width="39" height="23" border="0"></a>
      <a href="javascript:deleteUser()"><img src="images/btn_big_delete.gif" width="39" height="23" border="0"></a></td>
  </tr>
</table>
</form>
</body>
</html>
