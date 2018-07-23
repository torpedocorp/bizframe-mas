<%@ page contentType="text/html; charset=euc-kr" language="java"%>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.AppSubscriberVO"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.dao.MxsDAO"%>

<%

   String subscriberName = request.getParameter("subscriberName");
   String description    = request.getParameter("description");

   //deltete subscriber
   try {

         DAOFactory df  = DAOFactory.getDAOFactory(DAOFactory.EBMS);
         MxsDAO dao     = df.getDAO("AppSubscriber");
         AppSubscriberVO  subscriberVO = new AppSubscriberVO();
         subscriberVO.setCreatedBy     ("01234567-0123-0123-0123-0123456789AC");
         subscriberVO.setName          (subscriberName);
         subscriberVO.setDescription   (description);
         dao.insertObject              (subscriberVO);

   } catch (Exception e) {
      e.printStackTrace();
   }


%>

