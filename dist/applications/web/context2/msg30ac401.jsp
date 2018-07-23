<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%
/**
 * Update signalMessage
 * @author Mi-Young Kim
 * @version 1.0 2008.09.03
 */

 MxsEngine engine = MxsEngine.getInstance();
 String signalMsgObid = request.getParameter("obid");
 String comment = request.getParameter("comment");

 if (signalMsgObid != null && comment != null) {
     engine.updateObject("Eb3SignalMessage", signalMsgObid, "user_comment", comment, DAOFactory.EBMS3);
 }
%>

