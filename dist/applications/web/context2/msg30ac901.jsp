<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%
/**
 * @author Ho-Jin Seo
 * @version 1.0
 */

// ============ update message ================
    MxsEngine engine = MxsEngine.getInstance();
	String obid = request.getParameter("obid");
	String comment = request.getParameter("comment");

	if (obid != null && comment != null) {	// 1 °Ç update
		engine.updateObject("WsMessage", obid, "user_comment", comment, DAOFactory.WSMS);
	}
%>

