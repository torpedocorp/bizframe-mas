<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.ByteArrayOutputStream" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.apache.commons.fileupload.DiskFileUpload" %>
<%@ page import="org.apache.commons.fileupload.FileUpload" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.wsms.WsdlManager" %>
<%@ page import="kr.co.bizframe.mxs.wsms.model.Wsdl" %>
<%@ page import="kr.co.bizframe.mxs.wsms.model.Service" %>
<%@ page import="kr.co.bizframe.mxs.wsms.model.PortBinding" %>
<%@ page import="java.net.URL" %>
<%@ page import="kr.co.bizframe.mxs.dto.SecurityKeyStoreVO" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.mxs.MxsConstants" %>
<%
 /**
 * @author Ho-Jin Seo
 * @version 1.0
 */
%>
<html>
<head>
<%@ include file="./com00in000.jsp" %>
<%@ include file="./com00in003.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>
<%
byte[] caByte = null;
boolean isMultipart = FileUpload.isMultipartContent(request);
String doctype = null;
String wsdlname = null;
Wsdl wsdlVO = null;
String servletName = null;
boolean success = false;
MxsEngine engine = MxsEngine.getInstance();
QueryCondition qc = null;
ArrayList endPoints = new ArrayList();
ArrayList portTypes = new ArrayList();

if (isMultipart) {
	DiskFileUpload upload = new DiskFileUpload();
	List items = null;
	try {
		items = upload.parseRequest(request);
	} catch (Exception e) {
		success = false;
	}

	Iterator iter = items.iterator();
	while (iter.hasNext()) {
		Object ob = iter.next();
		FileItem item = (FileItem)ob;
		if (item != null) {
			if (!item.isFormField()) {
				if (item.getName() != null
						&& !item.getName().equals("")
						&& item != null) {
					try {
						InputStream uploadedStream = item.getInputStream();
						caByte = null;
						int size2;
						byte[] buffer2 = new byte[4096];
						final ByteArrayOutputStream baos2 = new ByteArrayOutputStream();
						while ((size2 = uploadedStream.read(buffer2)) != -1) {
							baos2.write(buffer2, 0, size2);
						}
						caByte = baos2.toByteArray();
						baos2.close();
						uploadedStream.close();
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			} else {
				if (item.getFieldName().equals("doctype")) {
					doctype = item.getString();
				}
				if (item.getFieldName().equals("wsdlname")) {
					wsdlname = item.getString();
				}
			}
		}
	}
} else {
	out.println("<script>alert('"
			+ _i18n.get("wsd10ms001.wsdl.register.failed2")
			+ "');location.href='wsd20ms001.jsp';</script>");
	return;
}
if (caByte != null) {
	wsdlVO = new WsdlManager().getWSDL(caByte);
	for (Iterator i = wsdlVO.getServices(); i.hasNext();) {
		Service service = (Service)i.next();
		for (Iterator h = service.getPorts().iterator(); h.hasNext();) {
			PortBinding port = (PortBinding)h.next();
			String address = port.getAddressLocation();
			endPoints.add(address);
			portTypes.add(port.getPorttypeName());

			// TODO : 중복주소체크
			qc = new QueryCondition();
			qc.add("address_location", address);
			ArrayList exist = engine.getObjects("PortBinding", qc,
					DAOFactory.WSMS);
			if (exist.size() > 0) {
				out.println("<script>alert('"
						+ _i18n.get("wsd10ms001.wsdl.register.failed3")
						+ "');location.href='wsd20ms001.jsp';</script>");
				return;
			}

			URL endPoint = new URL(address);
			String[] folder = endPoint.getPath().split("/");
			if (folder.length > 1) {
				servletName = folder[folder.length - 1];
				if (servletName.equals("msh")
						&& endPoint.getQuery().length() > 5
						&& "wsdl=".equals(endPoint.getQuery().substring(
								0, 5))) {
					servletName = endPoint.getQuery().substring(5);
				}
				break;
			}
		}
		session.setAttribute("wsdlVO", wsdlVO);
		success = true;
	}
} else {
	out.println("<script>alert('"
			+ _i18n.get("wsd10ms001.wsdl.register.failed2")
			+ "');location.href='wsd20ms001.jsp';</script>");
	return;
}
%>
<script language="JavaScript" type="text/JavaScript">
<!--
function insertWSDL(val) {
	var frm = document.wsdlUpload;

	/*
	if (frm.keystore.value == "" ) {
		msg = "<%=_i18n.get("wsd10ms001.select.keystore")%>";
		openAlert(msg);
		return;
	}
	*/

	openInfo('<%=_i18n.get("global.processing") %>');

   var params = Form.serialize(document.wsdlUpload);
   var opt = {
      method: 'post',
      parameters: params,
      onSuccess: function(t) {
         $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%= _i18n.get("wsd10ms001.wsdl.registered") %>';
	    Dialog.setInfoMessage('<%= _i18n.get("wsd10ms001.wsdl.registered") %>');
	    timeout=2; setTimeout(goList, 1000);

      },
       on404: function(t) {
           $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("err00zz404.message") %>';
        //   showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
           closeInfo();
       },
       onFailure: function(t) {
           $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("global.error.retry") %>';
           showErrorPopup(t.responseText, null, null, null);
           closeInfo();
       }
   }
   var myAjax = new Ajax.Request("./wsd10ac001.jsp", opt);

}
function goList() {
	timeout--;
	if (timeout >0) {
		setTimeout(goList, 1000) ;
	} else {
		location.href='wsd20ms001.jsp';
	}
}


//-->
</script>
</head>
<body>
<!-- 제목테이블 -->
<table class="TableLayout">
  <tr>
    <td width="25%" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.wsdl.provider.register")%></td>
    <td width="75%" class="MessageDisplay"><div id=messageDisplay></div></td>
  </tr>
  <tr>
    <td colspan="2" height="6"></td>
  </tr>
</table>
<!-- 등록테이블-->
<form name="wsdlUpload" method="post" >
<input type = hidden name="beClient" value="0">
<table class="FieldTable">
  <tr>
    <td width="120" class="FieldLabel"><%=_i18n.get("global.wsdl.name")%></td>
    <td width="260" class="FieldData" colspan="3"><input name="wsdlName" id="wsdlName" value="<%= servletName %>" type="text" class="FormTextReadOnly" readonly size="32"></td>
  </tr>
<%
for(int i=0; i<portTypes.size(); i++) {
%>
  <tr>
    <td width="120" class="FieldLabel"><%=_i18n.get("global.wsdl.porttype")%> </td>
    <td width="260" class="FieldData"><input name="porttype" value="<%= portTypes.get(i) %>" type="text" class="FormTextReadOnly" readonly size="32"></td>
    <td width="120" class="FieldLabel"><%=_i18n.get("global.wsdl.endpoint")%> </td>
    <td width="260" class="FieldData"><input name="endpoint" value="<%= endPoints.get(i) %>" type="text" class="FormTextReadOnly" readonly size="32"></td>
  </tr>
<%
}
%>
  <tr>
    <td width="120" class="FieldLabel"><%=_i18n.get("global.keystore.name")%></td>
    <td width="260" class="FieldData">
        <select name="keystore">
			  <option value=""><%=_i18n.get("wsd10ms001.select.keystore")%></option>
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
		System.out.println("wsd10ms001.jsp Error due to " + e.toString());
	}
%>
			</select>
      </td>
      <td class="FieldLabel"><%=_i18n.get("global.agreement.storage.type")%></td>
      <td class="FieldData">
      	<input type="radio" name="storage_type" value="<%=MxsConstants.AGREEMENT_STORAGE_TYPE_FILE %>" checked><%=_i18n.get("global.agreement.storage.type.file")%>
      	&nbsp;&nbsp;&nbsp;&nbsp;
      	<input type="radio" name="storage_type" value="<%=MxsConstants.AGREEMENT_STORAGE_TYPE_DB %>"><%=_i18n.get("global.agreement.storage.type.db") %>
      </td>
  </tr>
</table>
<table class="TableLayout" >
  <tr>
    <td align="right" style="padding-top:15">
      <a href="javascript:history.go(-1)"><img src="images/btn_big_list.gif" width="39" height="23" border="0"></a>
      <a href="javascript:insertWSDL()"><img src="images/btn_big_create.gif" width="39" height="23" border="0"></a>
      <a href="javascript:document.wsdlUpload.reset()"><img src="images/btn_big_reset.gif" width="47" height="23" border="0"></a>
    </td>
  </tr>
</table>
</form>
</body>
</html>
