<%@ page contentType="text/html; charset=euc-kr" language="java"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.dao.MxsDAO"%>

<%

   /**
    * @author Gemini Kim
    * @version 1.0
    */

   String[] channelObid_arr            = request.getParameterValues("channelObid");

   //update channel
   try {

      if(channelObid_arr == null) return;

      for (int i = 0; i <channelObid_arr.length; i++) {
         String description = request.getParameter(channelObid_arr[i]+"_description");
         DAOFactory df  = DAOFactory.getDAOFactory(DAOFactory.EBMS);
         MxsDAO dao     =  df.getDAO("AppChannel");
         dao.updateObject(channelObid_arr[i], "DESCRIPTION", description);
      }
   } catch (Exception e) {
      e.printStackTrace();
   }

%>

