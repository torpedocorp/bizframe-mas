<%@ page contentType="text/html; charset=euc-kr" language="java"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.dao.MxsDAO"%>
<%

   /**
    * @author Gemini Kim
    * @version 1.0
    */

   String[] subscriberObid_arr         = request.getParameterValues("subscriberObid");

   //deltete subscriber
   try {

      if(subscriberObid_arr == null) return;
      for (int i = 0; i <subscriberObid_arr.length; i++) {
         String description = request.getParameter(subscriberObid_arr[i]+"_description");

         DAOFactory df = DAOFactory.getDAOFactory(DAOFactory.EBMS);
         MxsDAO dao = df.getDAO("AppSubscriber");
         dao.updateObject(subscriberObid_arr[i], "DESCRIPTION", description);

      }
   } catch (Exception e) {
      e.printStackTrace();
   }

%>

