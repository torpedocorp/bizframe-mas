<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.InputStream"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.mxs.wsa.AddressingConstants"%>
<%@ page import="kr.co.bizframe.mxs.wsms.msi.WsClientMessage"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.wsms.model.Wsdl"%>
<%@ page import="kr.co.bizframe.mxs.wsms.model.Operation"%>
<%@ page import="kr.co.bizframe.mxs.wsms.dto.WsMessageVO"%>
<%@ page import="kr.co.bizframe.util.UUIDFactory" %>
<%@ page import="kr.co.bizframe.mxs.web.MimeMultipartRequestEntity" %>
<%@ page import="javax.mail.internet.ContentType" %>
<%@ page import="javax.mail.internet.InternetHeaders" %>
<%@ page import="javax.mail.internet.MimeBodyPart" %>
<%@ page import="javax.mail.internet.MimeMultipart" %>
<%@ page import="org.apache.commons.httpclient.HttpClient" %>
<%@ page import="org.apache.commons.httpclient.MultiThreadedHttpConnectionManager" %>
<%@ page import="org.apache.commons.httpclient.methods.PostMethod" %>


<%
/**
 * Webservice Self-Test Report Page
 *
 * @author Ho-Jin Seo
 * @version 1.0
 */

WsClientMessage msg = null;
String msgid = UUIDFactory.getInstance().newUUID().toString();
String obid = "#";

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
	String from_endpoint ="";
	String to_endpoint ="";
	String wsa_sync="";
	String reply_endpoint ="";
	String service="";
	String operation="";
	String userid = (String)session.getAttribute("userid");
	String soapaction = "";
	String action_type = "";
	String action = "";

	DiskFileUpload upload = new DiskFileUpload();
	List items = null;

	try{
		items = upload.parseRequest(request);
	}
	catch(Exception e){
		throw new Exception("Failed to upload the file: "+e.getMessage());
	}

	Iterator iter = items.iterator();
	InputStream uploadedStream = null;
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


		}
	} //while end

	StringBuffer sb = new StringBuffer();
	sb.append("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
	sb.append("<SOAP:Envelope xmlns:SOAP=\"http://schemas.xmlsoap.org/soap/envelope/\"");
	sb.append("    xmlns:wsa=\"http://schemas.xmlsoap.org/ws/2004/08/addressing\"");
	sb.append("    xmlns:wsrm=\"http://schemas.xmlsoap.org/ws/2005/02/rm/\"");
	sb.append("    xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"");
	sb.append("    xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://schemas.xmlsoap.org/soap/envelope/ http://www.oasis-open.org/committees/ebxml-msg/schema/envelope.xsd\">");
	sb.append("<SOAP:Header>");
	sb.append("@HEADER@");
	sb.append("</SOAP:Header>");
	sb.append("    <SOAP:Body>");
	sb.append("@BODY@");
	sb.append("    </SOAP:Body>");
	sb.append("</SOAP:Envelope>");


	//DAOFactory df = DAOFactory.getDAOFactory(DAOFactory.WSMS);
	// J-.H. Kim 2008.01.21
	//MxsDAO wsdlDAO = df.getDAO("Wsdl");
    QueryCondition qc = new QueryCondition();
	qc.add("obid", wsdlId);
	//Wsdl wsdlVO = (Wsdl)wsdlDAO.findObject(qc);
	MxsEngine engine = MxsEngine.getInstance();
	Wsdl wsdlVO = (Wsdl)engine.getObject("Wsdl", qc, DAOFactory.WSMS);

	StringBuffer header = new StringBuffer();

	if (wsa_use.equals("1")) {
		if (wsa_sync.equals("1")) {
			reply_endpoint = AddressingConstants.WSA_200408_ANONYMOUS_URI;
		}

		// J-.H. Kim 2008.01.21
		//OperationOracleDAO opDAO = (OperationOracleDAO)df.getDAO("Operation");
		//MxsDAO opDAO = df.getDAO("Operation");
	    qc = new QueryCondition();
		qc.add("obid", operation);

		//Operation opVO = (Operation)opDAO.findObject(qc);
		Operation opVO = (Operation)engine.getObject("Operation", qc, DAOFactory.WSMS);

		if (action_type.equals("0")) {
			action = opVO.getInputAction();
		} else if (action_type.equals("1")) {
			action = opVO.getOutputAction();
		} else {
			action = opVO.getFaultAction();
		}

		header.append("   <wsa:From>" + from_endpoint + "</wsa:From>");
		header.append("	  <wsa:To>" + to_endpoint + "</wsa:To>");
		header.append("	  <wsa:MessageID>" + msgid + "</wsa:MessageID>");
		header.append("	  <wsa:Action>" + action + "</wsa:Action>");
		header.append("	  <wsa:ReplyTo SOAP:mustUnderstand=\"1\">");
		header.append("	  <wsa:Address>" + reply_endpoint + "</wsa:Address>");
		header.append("	  </wsa:ReplyTo>");
		//sb.toString().replaceFirst("@HEADER@", header.toString());
	} else {
		//MxsDAO opDAO = df.getDAO("Operation");
	    qc = new QueryCondition();
		qc.add("obid", operation);

		//Operation opVO = (Operation)opDAO.findObject(qc);
		Operation opVO = (Operation)engine.getObject("Operation", qc, DAOFactory.WSMS);

		if (action_type.equals("0")) {
			action = opVO.getInputAction();
		} else if (action_type.equals("1")) {
			action = opVO.getOutputAction();
		} else {
			action = opVO.getFaultAction();
		}

		header.append("	  <wsa:MessageID>" + msgid + "</wsa:MessageID>");
	}

	MimeMultipart multipart = new MimeMultipart("Related; type=\"text/xml\";start=\"<" + msgid + ">\"");

	InternetHeaders headers = new InternetHeaders();

	// Content-Type
	ContentType type = new ContentType("text/xml");
	type.setParameter("charset", "UTF-8");
	headers.setHeader("Content-Type", type.toString());

	headers.setHeader("Content-Id", "<" + msgid + ">");

	MimeBodyPart bodyPart = new MimeBodyPart(headers,
			sb.toString().replaceFirst("@HEADER@", header.toString()).replaceFirst("@BODY@", bodyMsg).getBytes());

	multipart.addBodyPart(bodyPart);

	// payload
	if (uploadedStream != null) {
		MimeBodyPart part = new MimeBodyPart(uploadedStream);
		part.setHeader("Content-Type", "application/octet-stream");
		part.setHeader("Content-ID", "<" + UUIDFactory.getInstance().newUUID().toString() + ">");

		multipart.addBodyPart(part);
	}

	MultiThreadedHttpConnectionManager connectionManager =
  		new MultiThreadedHttpConnectionManager();
	HttpClient client = new HttpClient(connectionManager);
	client.getHttpConnectionManager().getParams().setMaxTotalConnections(100);

	PostMethod post = new PostMethod(to_endpoint);
	post.setRequestHeader("SOAPAction", action);
	post.setRequestHeader("Content-Type", multipart.getContentType());
	post.setRequestEntity(new MimeMultipartRequestEntity(multipart));

	boolean isError = false;
	int status = client.executeMethod(post);
	if (status == 404)
		throw new Exception("Service is not available. Check service address!");
	//if(status == 500)
	//	isError = true;
		//saveRequestAndResponse(post, isError);
		//return status;
	post.releaseConnection();

	qc = new QueryCondition();
	qc.add("wsa_message_id", msgid);
	System.out.println("msgid=" + msgid);
	WsMessageVO msgVO = (WsMessageVO)engine.getObject("WsMessage", qc, DAOFactory.WSMS);
	if (msgVO != null) {
		obid = msgVO.getObid();
	}

} catch (Exception e) {
	e.printStackTrace();
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
    <td colspan="3" class="FieldData"><a href="javascript:viewMessage('<%=obid%>')"><%=msgid%></a></td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("tst.message.received") %></td>
    <td colspan="3" class="FieldData"><a href="javascript:viewRefMessage('<%=obid%>')"><%= _i18n.get("tst.result.view") %></a></td>
  </tr>
</table>

<!-- 버튼테이블 -->
<table class="TableLayout" >
  <tr>
    <td align="right" style="padding-top:15">
      <a href="tst00ms902.jsp"><img src="images/btn_big_list.gif" width="39" height="23" border="0"></a>
    </td>
  </tr>
</table>

</body>
</html>
