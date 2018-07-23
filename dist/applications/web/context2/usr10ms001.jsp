<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%
/**
 * User registration form
 *
 * @author Ho-Jin Seo
 * @version 1.0
 */
%>
<html>
<head>
<%@ include file="./com00in000.jsp" %>
<%@ include file="./com00in003.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>
<script language="JavaScript" type="text/JavaScript">
<!--
function insertUser() {
	closeInfo();

    if($('userid').value == "") {
       alert("<%=_i18n.get("usr10ms001.userid.empty")%>");
       return;
    }

    if ($('dupname').value != $('userid').value || $('dupflag_result').value != 'true') {
        alert('<%=_i18n.get("usr10ms001.userid.inform")%>');
        return;
     }

    if($('passwd').value == "") {
       alert("<%=_i18n.get("usr10ms001.passwd.empty")%>");
       return;
    }

    if($('passwd').value != $('passwd2').value) {
        alert("<%=_i18n.get("usr21ms001.passwd.incorrect")%>");
        return;
     }


    if($('email').value != "")
    {
	    if(!validEMAIL($('email').value ))
	    {
	        return;
	    }
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

   var params = Form.serialize(document.form2);

   openInfo('<%=_i18n.get("global.processing") %>');
   var opt = {
      method: 'post',
      parameters: params,
      onSuccess: function(t) {
    	$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("usr10ms001.register.ok") %>';
    	Dialog.setInfoMessage('<%=_i18n.get("usr10ms001.register.ok") %>');
    	timeout=2; setTimeout(goList, 1000);

      },
       on404: function(t) {
           $('messageDisplay').innerHTML = '<%=_i18n.get("err00zz404.message") %>';
           //showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
           closeInfo();
       },
       onFailure: function(t) {
           $('messageDisplay').innerHTML = '<%=_i18n.get("global.error.retry") %>';
           showErrorPopup(t.responseText, null, null, null);
           closeInfo();
       }
   }
   var myAjax = new Ajax.Request("usr10ac001.jsp", opt);

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

function goList() {
	timeout--;
	if (timeout >0) {
		setTimeout(goList, 1000) ;
	} else {
		history.go(-1);
	}
}

function nameCheck() {

	$('messageDisplay').innerHTML = '';

	check_name = $('userid').value;
	if(check_name == null || check_name == '') {
		//$('messageDisplay').innerHTML = '<%=_i18n.get("usr10ms001.userid.empty") %>';
		alert('<%=_i18n.get("usr10ms001.userid.empty") %>');
		return;
	}

	var params = Form.serialize(document.form2);
	var opt = {
		method: 'post',
		parameters: params,
		asynchronous: false,
		onSuccess: function(t) {
			var res = eval("(" + t.responseText + ")");
			dupCheckResult(res.name, res.can_use);
		},
		on404: function(t) {
			$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("err00zz404.message") %>';
			closeInfo();
		},
		onFailure: function(t) {
			$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("global.error.retry") %>';
			showErrorPopup(t.responseText, null, null, null);
			closeInfo();
		}
	}
	var myAjax = new Ajax.Request("./usr10ac002.jsp", opt);
}

function dupCheckResult(check_name, result) {
   $('dupname').value = check_name;
   $('dupflag_result').value = result;

   if(result == 'true') {
      //$('messageDisplay').innerHTML ='<%=_i18n.get("usr10ms001.userid.use") %>';
      alert('<%=_i18n.get("usr10ms001.userid.use") %>');
      return true;
   }
   else {
      //$('messageDisplay').innerHTML ='<%=_i18n.get("usr10ms001.userid.nouse") %>';
      alert('<%=_i18n.get("usr10ms001.userid.nouse") %>');
      return false;
   }
}
//-->
</script>
</head>
<body>
<!-- 제목테이블 -->
<table class="TableLayout">
  <tr>
    <td width="25%" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.user.register")%></td>
    <td width="75%" class="MessageDisplay"><div id=messageDisplay></div></td>
  </tr>
  <tr>
    <td colspan="2" height="6"></td>
  </tr>
</table>

<!-- 등록테이블  -->
<form name="form2" method="post">
<input type=hidden name=cell id="cell" value="">
<table class="FieldTable">
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("global.user.id")%></td>
    <td width="260" class="FieldData" colspan="3">
      <input name="userid" id="userid" type="text" class="FormText" size="25" />
      <a href="javascript:nameCheck()"><img src="images/btn_checkunique.gif" width="59" height="20" align="absmiddle" border="0"></a>
      <input type="hidden" id="dupname"  value="">
      <input type="hidden" id="dupflag_result"  value="">
    </td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("global.user.password")%></td>
    <td width="260" class="FieldData" colspan="3"><input name="passwd" id="passwd" type="password" class="FormText" value="" size="20" maxlength="20"></td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("global.user.password.confirm")%></td>
    <td width="260" class="FieldData" colspan="3"><input name="passwd2" id="passwd2" type="password" class="FormText" value="" size="20" maxlength="20"></td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("global.user.email")%></td>
    <td width="260" class="FieldData" colspan="3"><input name="email" id="email" type="text" value="" size="64" maxlength="100" class="FormText" ></td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("global.user.cellphone")%></td>
    <td width="260" class="FieldData" colspan="3">
      <select name=cell1 id="cell1" style='width:67px' class="FormText" >
        <option value=""><%=_i18n.get("global.user.cell.id")%></option>
        <option value="010" >010</option>
        <option value="011" >011</option>
        <option value="016" >016</option>
        <option value="017" >017</option>
        <option value="018" >018</option>
       <option value="019" >019</option>
     </select>
   -
     <input name="cell2" id="cell2" type="text" class="FormText" value="" size="4" maxlength="4">
  -
     <input name="cell3" id="cell3" type="text" class="FormText" value="" size="4" maxlength="4">

    </td>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("global.user.description")%></td>
    <td width="260" class="FieldData" colspan="3"><input name="description" id="description" type="text" class="FormText" size="100" /></td>
  </tr>
  </tr>
</table>
<table class="TableLayout" >
  <tr>
    <td align="right" style="padding-top:15">
      <a href="javascript:history.go(-1)"><img src="images/btn_big_list.gif" width="39" height="23" border="0"></a>
      <a href="javascript:insertUser()"><img src="images/btn_big_create.gif" width="39" height="23" border="0"></a>
      <a href="javascript:document.form2.reset()"><img src="images/btn_big_reset.gif" width="47" height="23" border="0"></a>
    </td>
  </tr>
</table>
</body>
</html>
