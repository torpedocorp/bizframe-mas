<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.Eb3Message" %>
<%
/**
 * Delete Message
 *
 * @author Ho-Jin Seo
 * @version 1.0
 */

String[] msgObid_arr = request.getParameterValues("msgObid");
if (msgObid_arr == null) {
   msgObid_arr = request.getParameterValues("obid");
}
try {
   if(msgObid_arr == null) return;
   for (int i = 0; i <msgObid_arr.length; i++) {
      QueryCondition qc = new QueryCondition();
      qc.add("obid", msgObid_arr[i]);
      MxsEngine engine = MxsEngine.getInstance();
      Eb3Message vo = (Eb3Message)engine.getObject("Eb3UserMessage", qc,
				DAOFactory.EBMS3);
      engine.deleteObject("Eb3UserMessage", vo, DAOFactory.EBMS3);
   }
} catch (Exception e) {
   e.printStackTrace();
}
%>
