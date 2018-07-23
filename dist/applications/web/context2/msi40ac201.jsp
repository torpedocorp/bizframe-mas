<%@ page contentType="text/html; charset=euc-kr" language="java"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.AppSubscriberVO"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.BizFrame"%>
<%
/**
 * @author Gemini Kim
 * @author Mi-Young Kim
 * @version 1.0
 */
   String[] subscriberObid_arr       = request.getParameterValues("subscriberObid");

   //deltete subscriber
   try {
      if(subscriberObid_arr == null) return;

      DAOFactory df = DAOFactory.getDAOFactory(DAOFactory.EBMS);
      // J-.H. Kim 2008.01.21
      //AppSubscriberOracleDAO subscriber_dao = (AppSubscriberOracleDAO) df.getDAO("AppSubscriber");
      //AppChToSubRelOracleDAO chtosubrel_dao = (AppChToSubRelOracleDAO) df.getDAO("AppChToSubRel");
      //MxsDAO subscriber_dao = df.getDAO("AppSubscriber");
      //MxsDAO chtosubrel_dao = df.getDAO("AppChToSubRel");

      MxsEngine engine = MxsEngine.getInstance();
      for (int i = 0; i < subscriberObid_arr.length; i++) {
         // Step.1 : 구독자 테이블에서 구독자를 삭제.
         AppSubscriberVO vo = new AppSubscriberVO();
         vo.setObid(subscriberObid_arr[i]);
         vo.setModifiedBy(BizFrame.SYSTEM_USER_OBID);
         engine.deleteObject("AppSubscriber", vo, DAOFactory.EBMS);
         //subscriber_dao.deleteObject(vo);

         // 구독자 삭제할 때 한 트랜잭션으로 처리 by bumma on 2008.05.22
         //QueryCondition qc = new QueryCondition();
         // Step.2 : 채널-구독자 테이블에서 구독자가 구독하는 채널관계정보를 삭제.
         //qc.add("subscriber_obid", subscriberObid_arr[i]);
         // bumma on 20080218
         //engine.getObjects("AppChToSubRel", 2, qc, DAOFactory.EBMS);
         //chtosubrel_dao.executeQuery(2, qc);
         //Step.3 : 채널의 구독자 수를 줄인다

      }
   } catch (Exception e) {
      e.printStackTrace();
   }

%>

