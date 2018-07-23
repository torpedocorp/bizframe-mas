<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.Eb3MessageManager" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.Eb3Message" %>
<%
/**
 * Delete SignalMessage
 *
 * @author Mi-Young Kim
 * @version 1.0 2008.09.03
 */

 String[] msgObid_arr = request.getParameterValues("obid");

 try {
    if(msgObid_arr == null) return;
    QueryCondition qc = null;
    for (int i = 0; i <msgObid_arr.length; i++) {
       qc = new QueryCondition();
	   qc.add("obid", msgObid_arr[i]);
	   Eb3Message msg = (Eb3Message)new Eb3MessageManager().getSignalMessage(qc);
	   MxsEngine.getInstance().deleteObject("Eb3SignalMessage", msg, DAOFactory.EBMS3);
    }
 } catch (Exception e) {
    e.printStackTrace();
 }
%>
