<%@ page contentType="text/html; charset=euc-kr" language="java"%>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.EbMessageVO"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>

<%

   /**
    * @author Gemini Kim
    * @version 1.0
    */
   String[] msgObid_arr = request.getParameterValues("msgObid");
   if (msgObid_arr == null) {
	   msgObid_arr = request.getParameterValues("msg.obid");
   }
   try {
      if(msgObid_arr == null) return;
      for (int i = 0; i <msgObid_arr.length; i++) {
         QueryCondition qc = new QueryCondition();
         qc.add("obid", msgObid_arr[i]);
         MxsEngine engine = MxsEngine.getInstance();
         EbMessageVO vo = (EbMessageVO)engine.getObject("Message", qc,
					DAOFactory.EBMS);
         engine.deleteObject("Message", vo, DAOFactory.EBMS);
      }
   } catch (Exception e) {
      e.printStackTrace();
   }

%>

