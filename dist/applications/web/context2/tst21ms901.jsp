<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.InputStream"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.mxs.wsms.msi.WsClientMessage"%>
<%@ page import="kr.co.bizframe.mxs.wsms.msi.WsClientPayload"%>
<%@ page import="kr.co.bizframe.mxs.wsms.msi.WsClientConfig"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.MxsConstants"%>
<%@ page import="kr.co.bizframe.mxs.wsms.model.Wsdl"%>
<%@ page import="kr.co.bizframe.mxs.wsms.model.Operation"%>
<%@ page import="kr.co.bizframe.mxs.wsa.AddressingVersion"%>
<%
/**
 * Webservice Test Report Page
 *
 * @author Ho-Jin Seo
 * @version 1.0
 */

WsClientMessage msg = null;

try {
 	String resultMsg="";
	byte[] payloadByte1 = null; //첨부파일
	byte[] bodyBytes = null; //입력한 텍스트파일
	String bodyMsg="";
	byte[] customHeaderBytes = null;
	String customHeader="";
	String strAction=null;
	String wsdlId ="";
	String wsdlName ="";
	String wsa_use="";
	String dsig_use="";
	String from_endpoint ="";
	String to_endpoint ="";
	String wsa_sync="";
	String reply_endpoint ="";
	String service="";
	String operation="";
	String userid = (String)session.getAttribute("userid");
	String soapaction = "";
	String action_type = "";
	String ssl_use = "";

	DiskFileUpload upload = new DiskFileUpload();
	List items = null;

	try{
		items = upload.parseRequest(request);
	}
	catch(Exception e){
		throw new Exception("Failed to upload the file: "+e.getMessage());
	}

	InputStream uploadedStream = null;
	Iterator iter = items.iterator();
	while (iter.hasNext()) {
		Object ob = iter.next();
		FileItem item = (FileItem)ob;
		if( !item.isFormField()){
			if(item.getName() != null && !item.getName().equals("") && item != null ){
				try{
					uploadedStream = item.getInputStream();
					/*
					payloadByte1 = null;
					int size2;
					byte[] buffer2 = new byte[4096];
					final ByteArrayOutputStream baos2 = new ByteArrayOutputStream();
					while((size2 = uploadedStream.read(buffer2)) != -1){
						baos2.write(buffer2, 0, size2);
					}
					payloadByte1 = baos2.toByteArray();
					baos2.close();
					uploadedStream.close();
					*/
				}
				catch(Exception e){
					e.printStackTrace();
				}
			}
		}
		else //폼필드
		{
			if(item.getFieldName().equals("wsdlId")) {
				wsdlId = item.getString();
			}

			if(item.getFieldName().equals("body_content")) {
				 bodyMsg = item.getString();
				 if(bodyMsg !=null && !bodyMsg.equals("") && bodyMsg.length() > 0)
					 bodyBytes = bodyMsg.getBytes();
			}

			if(item.getFieldName().equals("customHeader")) {
				 customHeader = item.getString();
				 if(customHeader !=null && !customHeader.equals("") && customHeader.length() > 0)
					 customHeaderBytes = customHeader.getBytes();
			}

			if(item.getFieldName().equalsIgnoreCase("wsa_use"))
			{
				 wsa_use=item.getString();
			}
			if(item.getFieldName().equalsIgnoreCase("ssl_use"))
			{
				 ssl_use=item.getString();
			}
			if(item.getFieldName().equals("from_endpoint")) {
				 from_endpoint = item.getString();
			}

			if(item.getFieldName().equals("to_endpoint")) {
				 to_endpoint = item.getString();
			}

			if(item.getFieldName().equalsIgnoreCase("wsa_sync"))
			{
				 wsa_sync=item.getString();
			}

			if(item.getFieldName().equals("reply_endpoint")) {
				 reply_endpoint = item.getString();
			}

		  if(item.getFieldName().equals("service")) {
				 service = item.getString();
			}

		  if(item.getFieldName().equals("operation")) {
				 operation = item.getString();
			}
		  if(item.getFieldName().equals("soapaction")) {
				 soapaction = item.getString();
			}
		  if(item.getFieldName().equals("action_type")) {
		  	action_type = item.getString();
		  }
		  if(item.getFieldName().equals("dsig_use")) {
			  	dsig_use = item.getString();
		  }


		}
	} //while end

	msg = new WsClientMessage(1.1);
	if (action_type.equals("0")) {
		msg.setOperationMsgKind(0);
	} else if (action_type.equals("1")) {
		msg.setOperationMsgKind(1);
	} else {
		msg.setOperationMsgKind(2);
	}


	//DAOFactory df = DAOFactory.getDAOFactory(DAOFactory.WSMS);
	// J-.H. Kim 2008.01.21
	//MxsDAO wsdlDAO = df.getDAO("Wsdl");
    QueryCondition qc = new QueryCondition();
	qc.add("obid", wsdlId);
	//Wsdl wsdlVO = (Wsdl)wsdlDAO.findObject(qc);
	MxsEngine engine = MxsEngine.getInstance();
	Wsdl wsdlVO = (Wsdl)engine.getObject("Wsdl", qc, DAOFactory.WSMS);

	msg.setWsdlName(wsdlVO.getName());

	msg.setBody(bodyBytes);

	// 변경내역 109
	// 전자서명 설정
    WsClientConfig clconfig = new WsClientConfig();
	if (dsig_use.equals("1")) {
	    clconfig.setSign(true);
	}
	if (ssl_use.equals("1")) {
		clconfig.setSSL(true);
	}
    msg.setConfig(clconfig);
	//msg.addCustomHeader(customHeader);

	System.out.println("wsa_use = " + wsa_use + ", sync = " + wsa_sync);

	if (wsa_use.equals("1")) {
		msg.setWSA(true);
		msg.setWSAFrom(from_endpoint);
		msg.setWSATo(to_endpoint);

		AddressingVersion addrVersion = AddressingVersion.getAddressingVersion(
			msg.getWSANamespace());

		if (wsa_sync.equals("1")) {
			msg.setWSAReplyTo(addrVersion.getAnonymousURI());
		} else {
			msg.setWSAReplyTo(reply_endpoint);
		}
		// J-.H. Kim 2008.01.21
		//OperationOracleDAO opDAO = (OperationOracleDAO)df.getDAO("Operation");
		//MxsDAO opDAO = df.getDAO("Operation");
	    qc = new QueryCondition();
		qc.add("obid", operation);

		System.out.println("operation obid = " + operation);

		//Operation opVO = (Operation)opDAO.findObject(qc);
		Operation opVO = (Operation)engine.getObject("Operation", qc, DAOFactory.WSMS);
		if (action_type.equals("0")) {
			msg.setSOAPAction(opVO.getInputAction());
			msg.setWSAAction(opVO.getInputAction());
		} else if (action_type.equals("1")) {
			msg.setSOAPAction(opVO.getOutputAction());
			msg.setWSAAction(opVO.getOutputAction());
		} else {
			msg.setSOAPAction(opVO.getFaultAction());
			msg.setWSAAction(opVO.getFaultAction());
		}
	} else {
		//MxsDAO opDAO = df.getDAO("Operation");
	    qc = new QueryCondition();
		qc.add("obid", operation);

		System.out.println("operation obid = " + operation);

		//Operation opVO = (Operation)opDAO.findObject(qc);
		Operation opVO = (Operation)engine.getObject("Operation", qc, DAOFactory.WSMS);
		if (action_type.equals("0")) {
			msg.setSOAPAction(opVO.getInputAction());
		} else if (action_type.equals("1")) {
			msg.setSOAPAction(opVO.getOutputAction());
		} else {
			msg.setSOAPAction(opVO.getFaultAction());
		}

	}

	// Payload 첨부
	if (uploadedStream != null) {
		WsClientPayload p1 = new WsClientPayload();
		p1.setSource(uploadedStream);
		msg.addPayload(p1);
	}
	WsClientMessage ret = (WsClientMessage) MxsEngine.getInstance().sendMessage(msg, MxsConstants.WSMS);

	System.out.println("=============ResponseMessage============");
	if (ret != null) {
		System.out.println(ret.toString());
		for (int k=0; k<ret.getPayloads().size(); k++) {
			WsClientPayload payload = (WsClientPayload)ret.getPayloads().get(k);
			System.out.println("payload-" + k + " : " + payload.getPartFilePath());
		}
	}
} catch (Exception e) {
%>
<script>
alert("<%= I18nStrings.getInstance().get("tst.result.fail") %>\r\n<%= e.getMessage() %>")
history.go(-1);
</script>
<%
	return;
}
%>
<html>
<head>
<%@ include file="./com00in000.jsp" %>
<%@ include file="./com00in003.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>
<script language="JavaScript" type="text/JavaScript">
<!--
function viewMessage(id)
{
	window.open("msg21ms901.jsp?obid=" + id, "_blank");
}
function viewRefMessage(id)
{
	window.open("msg21ms901.jsp?referenceId=" + id, "_blank");
}

//-->
</script>
</head>
<body>
<!-- 제목테이블 -->
<table class="TableLayout">
  <tr>
    <td width="180" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.tst.result")%></td>
    <td width="580" class="MessageDisplay" >&nbsp;<div id=messageDisplay></td>
  </tr>
  <tr>
    <td colspan="2" height="10"></td>
  </tr>
</table>

<!-- 상세정보 테이블-->
<table class="FieldTable">
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("tst.message.sent") %></td>
    <td colspan="3" class="FieldData"><a href="javascript:viewMessage('<%=msg.getWSAMessageId()%>')"><%=msg.getWSAMessageId()%></a></td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("tst.message.received") %></td>
    <td colspan="3" class="FieldData"><a href="javascript:viewRefMessage('<%=msg.getWSAMessageId()%>')"><%= _i18n.get("tst.result.view") %></a></td>
  </tr>
</table>

<!-- 버튼테이블 -->
<table class="TableLayout" >
  <tr>
    <td align="right" style="padding-top:15">
      <a href="tst00ms901.jsp"><img src="images/btn_big_list.gif" width="39" height="23" border="0"></a>
    </td>
  </tr>
</table>

</body>
</html>
