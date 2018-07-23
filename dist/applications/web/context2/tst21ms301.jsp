<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.ByteArrayInputStream" %>
<%@ page import="java.io.ByteArrayOutputStream" %>
<%@ page import="java.io.InputStream"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.mxs.MxsConstants"%>
<%@ page import="kr.co.bizframe.mxs.ebms.msi.EbClientMessage"%>
<%@ page import="kr.co.bizframe.mxs.ebms.msi.EbClientPayload"%>
<%
/**
 * ebXML Test Report Page
 *
 * @author Mi-Young Kim
 * @version 1.0
 */
 EbClientMessage msg = null;
try {
    String cpaId = "";
	byte[] payloadByte1 = null; //첨부파일
	byte[] bodyBytes = null; //입력한 텍스트파일
	String bodyMsg="";

	String fromPartyId = "";
	String fromPartyIdType = "";
	String toPartyId = "";
	String toPartyIdType = "";
	String mpc_uri = "";

	String service = "";
	String action="";

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

		    if(item.getFieldName().equals("toPartyId")) {
		    	toPartyId = item.getString();
			}

		    if(item.getFieldName().equals("toPartyIdType")) {
		    	toPartyIdType = item.getString();
			}
		    if(item.getFieldName().equals("mpc_uri")) {
		    	mpc_uri = item.getString();
			}

		}
	} //while end

	msg = new EbClientMessage();
    SimpleDateFormat sdf = new SimpleDateFormat("MMddhhmmss");
    String date = sdf.format(Calendar.getInstance().getTime());
    msg.setFromPartyId(fromPartyId);
    msg.setToPartyId(toPartyId);
    msg.setFromPartyIdType(fromPartyIdType);
    msg.setToPartyIdType(toPartyIdType);
    msg.setCpaId(cpaId);
    msg.setConversationId(cpaId + ":" + date.toString());
    msg.setService(service);
    msg.setAction(action);

	msg.setSpecVer(MxsConstants.EBMS3);
	msg.setAgreementRef(cpaId);

	// 저장될 mpc를 직접 설정
	if (mpc_uri != null && !mpc_uri.equals("")) {
		msg.useMpc(mpc_uri);
	}

	// Payload 첨부
	if (payloadByte1 != null && payloadByte1.length > 0) {
		EbClientPayload p1 = new EbClientPayload();
		p1.setSource(new ByteArrayInputStream(payloadByte1));
		msg.addPayload(p1);
	}

	if (bodyBytes != null && bodyBytes.length > 0) {
		EbClientPayload p1 = new EbClientPayload();
		p1.setSource(new ByteArrayInputStream(bodyBytes));
		msg.addPayload(p1);
	}
	EbClientMessage ret = (EbClientMessage)MxsEngine.getInstance().sendMessage(
			msg,MxsConstants.EBMS3);

	if (ret != null) {
		System.out.println("=============ResponseMessage============");
		System.out.println(ret.toString());
		for (int k=0; k<ret.getPayloads().size(); k++) {
			EbClientPayload payload = (EbClientPayload)ret.getPayloads().get(k);
			System.out.println("payload-" + k + " : " + payload.getPartFilePath());
		}
	}
} catch (Exception e) {
	e.printStackTrace();
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
    <td width="180" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.tst.result")%></td>
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
      <a href="tst00ms301.jsp"><img src="images/btn_big_list.gif" width="39" height="23" border="0"></a>
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
	window.open("msg21ms301.jsp?messageId=" + id, "_blank");
}
function viewRefMessage(id)
{
	window.open("msg21ms301.jsp?referenceId=" + id, "_blank");
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
    <td colspan="3" class="FieldData"><a href="javascript:viewMessage('<%=msg.getMessageId()%>')"><%=msg.getMessageId()%></a></td>
  </tr>
  <tr>
    <td width="120" class="FieldLabel"><%= _i18n.get("tst.message.received") %></td>
    <td colspan="3" class="FieldData"><a href="javascript:viewRefMessage('<%=msg.getMessageId()%>')"><%= _i18n.get("tst.result.view") %></a></td>
  </tr>
</table>

<!-- 버튼테이블 -->
<table class="TableLayout" >
  <tr>
    <td align="right" style="padding-top:15">
      <a href="tst00ms301.jsp"><img src="images/btn_big_list.gif" width="39" height="23" border="0"></a>
    </td>
  </tr>
</table>

</body>
</html>
