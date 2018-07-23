<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.dto.PartInfoVO"%>
<%@ page import="kr.co.bizframe.mxs.wsms.dto.WsMessageVO"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.mxs.web.I18nStrings"%>
<%@ page import="java.io.File"%>
<%@ page import="java.io.FileInputStream"%>
<%@ page import="java.io.BufferedOutputStream"%>
<%@ page import="java.io.BufferedInputStream"%>
<%@ page import="java.io.ByteArrayInputStream"%>
<%@ page import="kr.co.bizframe.mxs.wsms.model.WsMessage"%>
<%@ page import="kr.co.bizframe.mxs.wsms.parser.WsParser"%>
<%
 /**
 * download message or payload
 *
 * @author Ho-Jin Seo
 * @author Mi-Young Kim
 * @version 1.0
 */
//============ download ================

String obid = request.getParameter("obid");
String msgId = request.getParameter("msgId");
String refmsgId = request.getParameter("refmsgId");
String num = request.getParameter("num");

String value = null;
String key = null;
if (obid == null && msgId != null ) {
	key = "wsa_message_id";
	value = msgId;
} else if (obid == null && refmsgId != null) {
	key = "wsa_message_id";
	value = refmsgId;
}
else {
	key = "obid";
	value = obid;
}

if (key != null && value != null && num != null) {
	MxsEngine engine = MxsEngine.getInstance();
	QueryCondition qc = new QueryCondition();
	qc.add(key, value);

	BufferedInputStream bis = null;
	int seq = Integer.parseInt(num);
	File file = null;

	WsMessageVO msgVO = (WsMessageVO)engine.getObject("WsMessage", qc, DAOFactory.WSMS);
	if (refmsgId != null && msgVO != null) {
		qc = new QueryCondition();
		qc.add("ref_to_message", msgVO.getObid());
		msgVO = (WsMessageVO)engine.getObject("WsMessage", qc, DAOFactory.WSMS);
	}
	if (msgVO == null) {
		I18nStrings i18n = I18nStrings.getInstance();
%>
	<script>
		location.href="msg22ac902.jsp?err=global.notfound&close=0";
	</script>
<%
		return;
	}
	WsMessage wsMsg = (WsMessage)new WsParser().createMessage(msgVO);

	response.setContentType("application/octet-stream");
	response.setHeader("Content-Transfer-Encoding", "binary;");
	String filename = msgVO.getWsaMessageId();
	if (filename == null) {
		filename = msgVO.getObid();
	}
	String headerStr = "attachment; filename=" + filename + ".xml";
	response.setHeader("Content-Disposition", headerStr);

	if (seq == 0) {
		bis = new BufferedInputStream(
		new ByteArrayInputStream(wsMsg.getHeaderContainer().getContent()));
		//bis = new BufferedInputStream(bodyPart.getInputStream());
		//response.setHeader("Content-Length", String.valueOf(wsMsg.getHeaderContainer().getContent().length));
	} else {
		/* file = new File(msgVO.getMessageFilePath());
		FileDataSource fs = new FileDataSource(file);
		multipart = new MimeMultipart(fs);
		MimeBodyPart bodyPart = (MimeBodyPart) multipart.getBodyPart(seq);
		Enumeration headers = bodyPart.getAllHeaders();
	    while(headers.hasMoreElements()) {
	        Header h = (Header) headers.nextElement();
	    	response.setHeader(h.getName(), h.getValue());
	    } */
	    //file.close();

	    PartInfoVO partInfo = (PartInfoVO)msgVO.getPartInfos().get(seq - 1);
		file = new File(partInfo.getPartFilePath());

		bis = new BufferedInputStream(new FileInputStream(file));
		//response.setHeader("Content-Length", String.valueOf(file.length()));
	}

	BufferedOutputStream bos = new BufferedOutputStream(response.getOutputStream());

	int read = 0;
	try {
		byte[] buf = new byte[4096];

		while ((read = bis.read(buf)) != -1) {
	bos.write(buf,0,read);
		}
		bos.close();
		bis.close();
	} catch (Exception e) {
		e.printStackTrace();
		throw e;
	} finally {
		if(bos != null) bos.close();
		if(bis != null) bis.close();
	}

}
%>



