<%@ page contentType="text/html; charset=euc-kr" language="java"%>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.AppChannelVO"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.dao.MxsDAO"%>
<%@ page import="kr.co.bizframe.BizFrame"%>

<%

   /**
    * @author Gemini Kim
    * @version 1.0
    */

   String channelName      = request.getParameter("channelName");
   String description      = request.getParameter("description");

   try {

         DAOFactory df = DAOFactory.getDAOFactory(DAOFactory.EBMS);
         MxsDAO dao = df.getDAO("AppChannel");
         AppChannelVO  channelVO = new AppChannelVO();
         channelVO.setCreatedBy(BizFrame.SYSTEM_USER_OBID);
         channelVO.setName(channelName);
         channelVO.setDescription(description);
         channelVO.setNumSubscriber(0);
         dao.insertObject(channelVO);

   } catch (Exception e) {
      e.printStackTrace();
   }
%>

