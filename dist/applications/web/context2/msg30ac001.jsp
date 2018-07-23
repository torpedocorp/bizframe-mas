<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%
/**
 * @author Mi-Young Kim
 * @version 1.0
 */

// ============ update message ================
    MxsEngine engine = MxsEngine.getInstance();
	String obid = request.getParameter("msg.obid");
	String comment = request.getParameter("comment");

	if (obid != null && comment != null) {	// 1 °Ç update
		engine.updateObject("Message", obid, "user_comment", comment, DAOFactory.EBMS);
	}
%>

