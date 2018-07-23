<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.wsms.dto.WsMessageVO"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="java.io.File"%>
<%@ page import="java.io.BufferedOutputStream"%>
<%@ page import="java.io.BufferedInputStream"%>
<%@ page import="kr.co.bizframe.mxs.wsms.model.WsMessage"%>
<%@ page import="kr.co.bizframe.mxs.wsms.parser.WsParser"%>
<%@ page import="java.util.ArrayList"%>
<%
 /**
 * download message and payload
 *
 * @author Ho-Jin Seo
 * @version 1.0
 */
//============ download ================

String obid = request.getParameter("obid");
String msgId = request.getParameter("msgId");
String refId = request.getParameter("refId");

MxsEngine engine = MxsEngine.getInstance();
QueryCondition qc = new QueryCondition();

String value = null;
String key = null;
if (obid == null && msgId != null) {
	key = "wsa_message_id";
	value = msgId;
} else if (obid != null) {
	key = "obid";
	value = obid;
} else if (refId != null) {
	qc = new QueryCondition();
	qc.add("wsa_message_id", refId);

	ArrayList arr = engine.getObjects("WsMessage", qc, DAOFactory.WSMS);
	if (arr.size() > 0) {
		WsMessageVO tmpVO = (WsMessageVO)arr.get(0);

		key = "ref_to_message";
		value = tmpVO.getObid();
	}
}

if (key != null && value != null) {
	qc = new QueryCondition();
	qc.add(key, value);

	BufferedInputStream bis = null;
	File file = null;

	WsMessageVO msgVO = (WsMessageVO)engine.getObject("WsMessage", qc, DAOFactory.WSMS);

    if (msgVO == null) {
        throw new Exception("Cannot find Message by " + key + " : " + value);
    }
	WsMessage wsMsg = (WsMessage)new WsParser().createMessage(msgVO);

	response.setContentType("application/octet-stream");
	response.setHeader("Content-Transfer-Encoding", "binary;");
	String headerStr = "attachment; filename=" + value;
	response.setHeader("Content-Disposition", headerStr);

	BufferedOutputStream os = new BufferedOutputStream(response.getOutputStream());
	os.write(("Content-Type: " + msgVO.getContentType() + "\n\n").getBytes());
	wsMsg.writeTo(os);
	os.close();
}
%>



