<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.wsms.dto.WsMessageVO" %>
<%@ page import="kr.co.bizframe.mxs.web.I18nStrings" %>
<%
/**
 * Delete Message
 *
 * @author Ho-Jin Seo
 * @version 1.0
 */
I18nStrings _i18n = I18nStrings.getInstance();
String checkIndex = "";
String[]  checkIndexs = request.getParameterValues("checkIndex");
QueryCondition qc = null;

String msgObid = request.getParameter("obid");

MxsEngine engine = MxsEngine.getInstance();
if (msgObid != null) {	// 1 °Ç delete
	qc = new QueryCondition();
	qc.add("obid", msgObid);
	WsMessageVO msgVO = (WsMessageVO) engine.getObject("WsMessage", qc, DAOFactory.WSMS);
	engine.deleteObject("WsMessage", msgVO, DAOFactory.WSMS);
} else {
	for (int i=0; i<checkIndexs.length; i++) {
		checkIndex = checkIndexs[i];
		msgObid = (String)request.getParameter("msgObid"+checkIndex);
		if (msgObid != null && msgObid.length() > 0) {
			qc = new QueryCondition();
			qc.add("obid", msgObid);
			WsMessageVO msgVO = (WsMessageVO) engine.getObject("WsMessage", qc, DAOFactory.WSMS);
			engine.deleteObject("WsMessage", msgVO, DAOFactory.WSMS);
		}
	}
}
%>
