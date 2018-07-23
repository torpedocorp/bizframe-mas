<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.wsms.model.Wsdl" %>
<%@ page import="kr.co.bizframe.mxs.wsms.model.Service" %>
<%@ page import="kr.co.bizframe.mxs.wsms.model.PortBinding" %>
<%@ page import="kr.co.bizframe.mxs.dto.SecurityKeyStoreVO" %>
<%@ page import="kr.co.bizframe.mxs.org.MxsUser" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.mxs.MxsConstants" %>
<%
 /**
 * @author Ho-Jin Seo
 * @version 1.0
 */
 //============ detail view of WSDL ================

 	String obid = request.getParameter("obid");

	MxsEngine engine = MxsEngine.getInstance();
	QueryCondition qc = new QueryCondition();
	qc.add("obid", obid);
	Wsdl wsdlVO = (Wsdl) engine.getObject("Wsdl", qc, DAOFactory.WSMS);

	String userId = null;

	qc = new QueryCondition();
	qc.add("obid", wsdlVO.getUserObid());
	MxsUser userVO = (MxsUser) engine.getObject("User", qc, DAOFactory.COMMON);

	if (userVO != null)
		userId = userVO.getUserId();
	userId = (userId == null ? "admin" : userId);

	String wsdlType = (wsdlVO.getBeClient() == 1 ? "Client" : "Provider");
%>
<html>
<head>
<%@ include file="./com00in000.jsp" %>
<%@ include file="./com00in003.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>
<script language="JavaScript" type="text/JavaScript">
<!--

function updateWSDL() {
	frm = document.form1;
	msg = "<%=_i18n.get("wsd21ms001.update.confirm")%>";
	openConfirm(msg, updateWsdlOkFunction, null, "<%=_i18n.get("global.warning")%>");
}

function viewWSDL(obid) {
   window.open("wsd22ac001.jsp?obid=" + obid, "WSDL", "width=1010,height=800,left=0,top=0,resizable=yes,scrollbars=yes");
}

function downloadWSDL(obid) {
   frm = document.form1;
   frm.action = "wsd50ac001.jsp";
   frm.method = "post";
   frm.submit();

//   window.open("wsd50ac001.jsp?obid=" + obid, "WSDL", "width=100,height=100,left=5000,top=100,resizable=yes,scrollbars=yes");
}

function deleteWSDL() {
	msg = "<%=_i18n.get("wsd21ms001.delete.confirm")%>";
	openConfirm(msg, deleteWsdlOkFunction, null, "<%=_i18n.get("global.warning")%>");
}

function deleteWsdlOkFunction() {
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

	    	Dialog.setInfoMessage('<%=_i18n.get("wsd21ms001.operation.delete") %>');
	    	$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("wsd21ms001.operation.delete") %>';
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

	var myAjax = new Ajax.Request('./wsd40ac001.jsp', opt);
}

function updateWsdlOkFunction() {
	Windows.closeAllModalWindows();
	clearNotify();

	var params = Form.serialize(document.form1);

	openInfo('<%=_i18n.get("global.processing") %>');
	var opt = {
	    method: 'post',
	    postBody: params,
	    onSuccess: function(t) {
	    	closeInfo();
	    	$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("wsd21ms001.operation.update") %>';
	    	//Dialog.setInfoMessage('<%=_i18n.get("wsd21ms001.operation.update") %>');
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

	var myAjax = new Ajax.Request('./wsd30ac001.jsp', opt);
}

function goList() {
	timeout--;
	if (timeout >0) {
		setTimeout(goList, 1000) ;
	} else {
		history.go(-1);
	}
}

function init() {
	if (<%= (wsdlVO.getKeystoreObid() == null? 1: 0) %>) {
		$('keystore').selectedIndex = 0;
	} else {
		$('keystore').value='<%= wsdlVO.getKeystoreObid() %>';
	}
	$('wsdlstatus').value='<%= wsdlVO.getStatus() %>';
}

window.onload=init;
//-->
</script>
</head>
<body>
<!-- 제목테이블 -->
<table class="TableLayout">
  <tr>
    <td width="210" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.wsdl.view")%></td>
    <td width="550" class="MessageDisplay"><div id=messageDisplay></div></td>
  </tr>
  <tr>
    <td colspan="2" height="6"></td>
  </tr>
</table>
<!-- 등록테이블-->
<form name="form1" method="post" >
<input type="hidden" name="obid" value="<%=obid%>">
<table class="FieldTable">
  <tr>
          <td width="120" class="FieldLabel"><%=_i18n.get("global.wsdl.name")%></td>
          <td width="260" class="FieldData"><input name="textfield" type="text" class="FormTextReadOnly" readonly size="32" value="<%= wsdlVO.getName() %>">
          </td>
          <td width="120" class="FieldLabel"><%=_i18n.get("global.wsdl.type")%></td>
          <td width="260" class="FieldData"><input name="textfield" type="text" class="FormTextReadOnly" readonly size="32" value="<%= wsdlType %>"></td>
        </tr>
        <tr>
          <td class="FieldLabel"><%=_i18n.get("global.date.creation")%></td>
          <td class="FieldData"><input name="textfield" type="text" class="FormTextReadOnly" readonly size="32" value="<%= wsdlVO.getCreatedOn() %>"></td>
          <td class="FieldLabel"><%=_i18n.get("global.registrar")%></td>
          <td class="FieldData"><input name="textfield" type="text" class="FormTextReadOnly" readonly size="32" value="<%= userId %>"></td>
        </tr>
<%
	qc = new QueryCondition();
	qc.add("wsdl_obid", wsdlVO.getObid());
	ArrayList services = engine.getObjects("Service", qc, DAOFactory.WSMS);
	for (int k=0; k<services.size(); k++) {
		Service serviceVO = (Service)services.get(k);
		qc = new QueryCondition();
		qc.add("service_obid", serviceVO.getObid());
		ArrayList bindings = engine.getObjects("PortBinding", qc, DAOFactory.WSMS);
		for (int n=0; n<bindings.size(); n++) {
	PortBinding portVO = (PortBinding)bindings.get(n);
%>
        <tr>
		    <td width="120" class="FieldLabel"><%=_i18n.get("global.wsdl.porttype")%> </td>
		    <td width="260" class="FieldData"><input name="porttype" value="<%= portVO.getPortName() %>" type="text" class="FormTextReadOnly" readonly size="32"></td>
		    <td width="120" class="FieldLabel"><%=_i18n.get("global.wsdl.endpoint")%> </td>
		    <td width="260" class="FieldData"><input name="endpoint" value="<%= portVO.getAddressLocation() %>" type="text" class="FormTextReadOnly" readonly size="32"></td>
        </tr>
<%
	}
	}
%>
        <tr>
          <td class="FieldLabel"><%=_i18n.get("global.keystore.name")%></td>
          <td class="FieldData">
						      	<select name="keystore" id="keystore" class="FormSelect" style="width:187;">
						      		<option value=""><%=_i18n.get("wsd21ms001.keystore.select")%></option>
<%
    ArrayList array = new ArrayList();
    try {
        qc = new QueryCondition();
        array = engine.getObjects("SecurityKeyStore", qc, DAOFactory.COMMON);

		for (int i=0; i<array.size(); i++) {
	SecurityKeyStoreVO vo = (SecurityKeyStoreVO) array.get(i);
%>
	<option value="<%=vo.getObid() %>"><%=vo.getName() %></option>
<%
		}
    }
    catch (Exception e){
       //e.printStackTrace();
       System.out.println("wsd21ms001.jsp Error due to " + e.toString());
    }
%>
						      	</select>
          </td>
          <td class="FieldLabel"><%=_i18n.get("global.status")%></td>
          <td class="FieldData">
            <select name="wsdlstatus"  id="wsdlstatus" class="FormSelect" style="width:187;">
              <option value="1">Enabled</option>
              <option value="0">Disabled</option>
            </select>
          </td>
        </tr>
<%
String storageType_file = " checked";
String storageType_db = "";

if (wsdlVO.getStorageType() == MxsConstants.AGREEMENT_STORAGE_TYPE_DB) {
	   storageType_db = " checked";
	   storageType_file = "";

} else {
	   storageType_db = "";
	   storageType_file = " checked";
}
%>
        <tr>
	      <td class="FieldLabel"><%=_i18n.get("global.agreement.storage.type")%></td>
	      <td class="FieldData">
	      	<input type="radio" name="storage_type" value="<%=MxsConstants.AGREEMENT_STORAGE_TYPE_FILE %>" <%=storageType_file %>><%=_i18n.get("global.agreement.storage.type.file")%>
	      	&nbsp;&nbsp;&nbsp;&nbsp;
	      	<input type="radio" name="storage_type" value="<%=MxsConstants.AGREEMENT_STORAGE_TYPE_DB %>" <%=storageType_db %>><%=_i18n.get("global.agreement.storage.type.db") %>
	      </td>
          <td class="FieldLabel"><%=_i18n.get("wsd21ms001.wsdl.file")%></td>
          <td class="FieldData"><img src="images/xml.gif" width="39" height="20">
            <a href="javascript:viewWSDL('<%=obid%>');"><img src="images/btn_inview.gif" width="39" height="13" align="absmiddle" border="0"></a>
            <a href="javascript:downloadWSDL('<%= obid%>');"><img src="images/btn_indown.gif" width="62" height="13" align="absmiddle" border="0"></a>
          </td>
        </tr>
</table>
<!-- 버튼테이블 -->
<table class="TableLayout" >
  <tr>
    <td align="right" style="padding-top:15"><a href="javascript:history.go(-1)"><img src="images/btn_big_list.gif" width="39" height="23" border="0"></a>
      <a href="javascript:updateWSDL()"><img src="images/btn_big_change.gif" width="39" height="23" border="0"></a>
      <a href="javascript:deleteWSDL()"><img src="images/btn_big_delete.gif" width="39" height="23" border="0"></a></td>
  </tr>
</table>
</form>
</body>
</html>
