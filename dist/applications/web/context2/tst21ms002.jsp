<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.io.ByteArrayOutputStream" %>
<%@ page import="java.io.InputStream"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="kr.co.bizframe.mxs.ebms.msi.EbClientMessage"%>
<%@ page import="kr.co.bizframe.mxs.web.MimeMultipartRequestEntity" %>
<%@ page import="kr.co.bizframe.util.UUIDFactory" %>
<%@ page import="javax.mail.internet.ContentType" %>
<%@ page import="javax.mail.internet.InternetHeaders" %>
<%@ page import="javax.mail.internet.MimeBodyPart" %>
<%@ page import="javax.mail.internet.MimeMultipart" %>
<%@ page import="org.apache.commons.httpclient.HttpClient" %>
<%@ page import="org.apache.commons.httpclient.MultiThreadedHttpConnectionManager" %>
<%@ page import="org.apache.commons.httpclient.methods.PostMethod" %>
<%@ page import="kr.co.bizframe.util.UTC" %>
<%
/**
 * ebXML Self-Test Report Page
 *
 * @author Ho-Jin Seo
 * @version 1.0
 */
EbClientMessage msg = null;
String msgid = UUIDFactory.getInstance().newUUID().toString();

try {
    String cpaId = "";
	byte[] payloadByte1 = null; //첨부파일
	byte[] bodyBytes = null; //입력한 텍스트파일
	String bodyMsg="";

	String fromPartyId = "";
	String fromPartyIdType = "";
	String fromRole = "";
	String toPartyId = "";
	String toPartyIdType = "";
	String toRole = "";

	String service = "";
	String action="";
	String transportId = "";
	String endpoint = "";
	String deliveryId = "";
	String payload1 = "Payload-0";
	String payload2 = "Payload-1";


	DiskFileUpload upload = new DiskFileUpload();
	List items = null;

	try{
		items = upload.parseRequest(request);
	}
	catch(Exception e){
		throw new Exception("Failed to upload the file: "+e.getMessage());
	}

	Iterator iter = items.iterator();
	while (iter.hasNext()) {
		Object ob = iter.next();
		FileItem item = (FileItem)ob;
		if( !item.isFormField()){
			if(item.getName() != null && !item.getName().equals("") && item != null ){
				try{
					InputStream uploadedStream = item.getInputStream();
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
				}
				catch(Exception e){
					e.printStackTrace();
				}
			}
		}
		else //폼필드
		{
			if(item.getFieldName().equals("cpaIdVal")) {
				cpaId = item.getString();
			}

			if(item.getFieldName().equals("body_content")) {
				 bodyMsg = item.getString();
				 if(bodyMsg !=null && !bodyMsg.equals("") && bodyMsg.length() > 0)
					 bodyBytes = bodyMsg.getBytes();
			}

		    if(item.getFieldName().equals("serviceVal")) {
				 service = item.getString();
			}

		    if(item.getFieldName().equals("actionVal")) {
				 action = item.getString();
			}

		    if(item.getFieldName().equals("fromPartyId")) {
		    	fromPartyId = item.getString();
			}

		    if(item.getFieldName().equals("fromPartyIdType")) {
		    	fromPartyIdType = item.getString();
			}
		    if(item.getFieldName().equals("fromRole")) {
		    	fromRole = item.getString();
			}

		    if(item.getFieldName().equals("toPartyId")) {
		    	toPartyId = item.getString();
			}

		    if(item.getFieldName().equals("toPartyIdType")) {
		    	toPartyIdType = item.getString();
			}
		    if(item.getFieldName().equals("toRole")) {
		    	toRole = item.getString();
			}

		    if(item.getFieldName().equals("transportId")) {
		    	transportId = item.getString();
			}
		    if(item.getFieldName().equals("endpoint")) {
		    	endpoint = item.getString();
			}
		    if (item.getFieldName().equals("deliveryId")) {
		    	deliveryId = item.getString();
		    }
		}
	} //while end

	StringBuffer sb = new StringBuffer();
	sb.append("<?xml version=\"1.0\" encoding=\"EUC-KR\" ?>\n");
	sb.append("<SOAP:Envelope xmlns:SOAP=\"http://schemas.xmlsoap.org/soap/envelope/\"\n");
	sb.append("	xmlns:xlink=\"http://www.w3.org/1999/xlink\" \n");
	sb.append("	xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" \n");
	sb.append("	xsi:schemaLocation=\"http://schemas.xmlsoap.org/soap/envelope/ http://www.oasis-open.org/committees/ebxml-msg/schema/envelope.xsd\">\n");
	sb.append("<SOAP:Header xmlns:eb=\"http://www.oasis-open.org/committees/ebxml-msg/schema/msg-header-2_0.xsd\" ");
	sb.append("   xsi:schemaLocation=\"http://www.oasis-open.org/committees/ebxml-msg/schema/msg-header-2_0.xsd http://www.oasis-open.org/committees/ebxml-msg/schema/msg-header-2_0.xsd\">\n");
	sb.append("	<eb:MessageHeader SOAP:mustUnderstand=\"1\" eb:id=\"MessageHeader\" eb:version=\"2.0\">\n");
	sb.append("	<eb:From>\n");
	sb.append("		<eb:PartyId eb:type=\"" + fromPartyIdType + "\">" + fromPartyId + "</eb:PartyId>\n");
	//sb.append("		<eb:Role>123</eb:Role>\n");
	sb.append("		<eb:Role>" + fromRole + "</eb:Role>\n");
	sb.append("	</eb:From>\n");
	sb.append("	<eb:To>\n");
	sb.append("		<eb:PartyId eb:type=\"" + toPartyIdType + "\">" + toPartyId + "</eb:PartyId>\n");
	//sb.append("		<eb:Role>345</eb:Role>\n");
	sb.append("		<eb:Role>" + toRole + "</eb:Role>\n");
	sb.append("	</eb:To>\n");
	sb.append("	<eb:CPAId>" + cpaId + "</eb:CPAId>\n");
	sb.append("	<eb:ConversationId>" + msgid + "</eb:ConversationId>\n");
	sb.append("	<eb:Service>" + service + "</eb:Service>\n");
	sb.append("	<eb:Action>" + action + "</eb:Action>\n");
	sb.append("	<eb:MessageData>\n");
	sb.append("		<eb:MessageId>" + msgid + "</eb:MessageId>\n");
	sb.append("		<eb:Timestamp>" + UTC.toUTCString(new Date(System.currentTimeMillis())) + "</eb:Timestamp>\n");
	sb.append("	</eb:MessageData>\n");
	//sb.append("	<eb:DuplicateElimination />\n");
	sb.append("	</eb:MessageHeader>\n");
	sb.append("</SOAP:Header>\n");
	sb.append("<SOAP:Body xmlns:eb=\"http://www.oasis-open.org/committees/ebxml-msg/schema/msg-header-2_0.xsd\" ");
	sb.append("	xsi:schemaLocation=\"http://www.oasis-open.org/committees/ebxml-msg/schema/msg-header-2_0.xsd http://www.oasis-open.org/committees/ebxml-msg/schema/msg-header-2_0.xsd\">\n");
	if ((payloadByte1 != null && payloadByte1.length > 0)
			|| (bodyBytes != null && bodyBytes.length > 0)) {
		sb.append("<eb:Manifest eb:id=\"Manifest\" eb:version=\"2.0\">\n");
	}

	if (bodyBytes != null && bodyBytes.length > 0) {
		sb.append("<eb:Reference eb:id=\"Reference-0\" xlink:href=\"cid:" + payload1 + "\" xlink:type=\"simple\" />\n");
	}
	if (payloadByte1 != null && payloadByte1.length > 0) {
		sb.append("<eb:Reference eb:id=\"Reference-0\" xlink:href=\"cid:" + payload2 + "\" xlink:type=\"simple\" />\n");
	}
	if ((payloadByte1 != null && payloadByte1.length > 0)
			|| (bodyBytes != null && bodyBytes.length > 0)) {

		sb.append("</eb:Manifest>\n");
	}
	sb.append("</SOAP:Body>\n");
	sb.append("</SOAP:Envelope>\n");

	MimeMultipart multipart = new MimeMultipart("Related; type=\"text/xml\";start=\"<" + msgid + ">\"");

	InternetHeaders headers = new InternetHeaders();

	// Content-Type
	ContentType type = new ContentType("text/xml");
	type.setParameter("charset", "UTF-8");
	headers.setHeader("Content-Type", type.toString());
	headers.setHeader("Content-Id", "<" + msgid + ">");

	MimeBodyPart bodyPart = new MimeBodyPart(headers, sb.toString().getBytes());

	multipart.addBodyPart(bodyPart);

	if (bodyBytes != null && bodyBytes.length > 0) {
		InternetHeaders payloadHeader = new InternetHeaders();
		MimeBodyPart part = new MimeBodyPart(payloadHeader, bodyBytes);
		part.setHeader("Content-Type", "text/xml");
		part.setHeader("Content-ID", "<" + payload1 + ">");

		multipart.addBodyPart(part);
	}

	if (payloadByte1 != null && payloadByte1.length > 0) {
		InternetHeaders payloadHeader = new InternetHeaders();
		MimeBodyPart part = new MimeBodyPart(payloadHeader, payloadByte1);
		part.setHeader("Content-Type", "application/octet-stream");
		part.setHeader("Content-ID", "<" + payload2 + ">");

		multipart.addBodyPart(part);
	}

	MultiThreadedHttpConnectionManager connectionManager =
  		new MultiThreadedHttpConnectionManager();
	HttpClient client = new HttpClient(connectionManager);
	client.getHttpConnectionManager().getParams().setMaxTotalConnections(100);

	/*
    QueryCondition qc = new QueryCondition();
    qc.add("obid", transportId);
    ArrayList transports = engine.getObjects("Transport", qc, DAOFactory.EBMS);


	  for (int i=0; i<transports.size(); i++) {
		TransportVO vo = (TransportVO) transports.get(i);

		  qc = new QueryCondition();
		  qc.add("transport_obid", vo.getObid());
		  ArrayList endpoints = engine.getObjects("Endpoint", qc, DAOFactory.EBMS);

		  for(int k=0; k<endpoints.size(); k++) {
			  EndpointVO endpointVO = (EndpointVO) endpoints.get(k);
			  endpoint = endpointVO.getUri();
		  }
	}

	*/

	PostMethod post = new PostMethod(endpoint);
	post.setRequestHeader("SOAPAction", "ebXML");
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
} catch (Exception e) {
%>
<html>
<head>
<%@ include file="./com00in000.jsp" %>
<%@ include file="./com00in003.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>
</head>
<body>
<!-- 제목테이블 -->
<table class="TableLayout">
  <tr>
    <td width="180" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.tst.result1")%></td>
    <td width="580" class="MessageDisplay" >&nbsp;<div id=messageDisplay></td>
  </tr>
  <tr>
    <td colspan="2" height="10"></td>
  </tr>
</table>
<%= I18nStrings.getInstance().get("tst.result.fail") %>
<br>
<%= e.getMessage() %>
<br>
<!-- 버튼테이블 -->
<table class="TableLayout" >
  <tr>
    <td align="left" style="padding-top:15">
      <a href="tst00ms001.jsp"><img src="images/btn_big_list.gif" width="39" height="23" border="0"></a>
    </td>
  </tr>
</table>
</body>
</html>
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
	window.open("msg21ms001.jsp?id=" + id, "_blank");
}
function viewRefMessage(id)
{
	window.open("msg21ms001.jsp?refId=" + id, "_blank");
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
    <td colspan="3" class="FieldData"><a href="javascript:viewMessage('<%=msgid%>')"><%=msgid%></a></td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("tst.message.received") %></td>
    <td colspan="3" class="FieldData"><a href="javascript:viewRefMessage('<%=msgid%>')"><%= _i18n.get("tst.result.view") %></a></td>
  </tr>
</table>

<!-- 버튼테이블 -->
<table class="TableLayout" >
  <tr>
    <td align="right" style="padding-top:15">
      <a href="tst00ms002.jsp"><img src="images/btn_big_list.gif" width="39" height="23" border="0"></a>
    </td>
  </tr>
</table>

</body>
</html>
