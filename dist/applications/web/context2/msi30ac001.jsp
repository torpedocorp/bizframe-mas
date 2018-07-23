<%@ page contentType="text/html; charset=euc-kr" language="java"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="kr.co.bizframe.BizFrame"%>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.AppPerformerVO"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%
   String[] service_arr       = request.getParameterValues("service.name");
   String[] action_arr        = request.getParameterValues("action.name");
   String[] sbObid_arr        = request.getParameterValues("servicebinding.obid");
   String[] actionObid_arr    = request.getParameterValues("action.obid");
   String[] cpaId_arr         = request.getParameterValues("cpa.id");
   String[] cpaObid_arr       = request.getParameterValues("cpa.obid");
   String[] channelObid_arr   = request.getParameterValues("channel.obid");
   String[] performerName_arr = request.getParameterValues("performer.name");
   String[] performerType_arr = request.getParameterValues("performer.type");

   ArrayList insertList = new ArrayList();

   for (int i = 0; i <service_arr.length; i++) {

      AppPerformerVO vo = new AppPerformerVO();

      String service     = service_arr[i];
      String action      = action_arr[i];
      String sbObid      = sbObid_arr[i];
      String actionObid  = actionObid_arr[i];
      String cpaObid     = cpaObid_arr[i];
      String cpaId       = cpaId_arr[i];
//      String appType     = performerType_arr[i];
      //System.out.println(performerType_arr[i]);
      int    appTypeInt  = Integer.parseInt(performerType_arr[i]);

//      if (appType.equals("0"))      appTypeInt = EbConstants.APP_PERFORMER;
//      else if (appType.equals("1")) appTypeInt = EbConstants.APP_CHANNEL;

      String performerName  = performerName_arr[i];
      String channelObid    = channelObid_arr[i];

      vo.setCreatedBy(BizFrame.SYSTEM_USER_OBID);
      vo.setModifiedBy(BizFrame.SYSTEM_USER_OBID);
      vo.setService(service);
      vo.setAction(action);
      vo.setServiceBindingObid(sbObid);
      vo.setCanReceiveObid(actionObid);
      vo.setCpaObid(cpaObid);
      vo.setCpaId(cpaId);
      vo.setAppType(appTypeInt);
      vo.setPerformerName(performerName);
      vo.setQueueObid(channelObid);
      insertList.add(vo);

   }

   //insert performers
   try {
      MxsEngine.getInstance().insertObjects("AppPerformer", insertList, DAOFactory.EBMS);
   } catch (Exception e) {
      e.printStackTrace();
   }

//   String return_url = "msi20ms002.jsp?obid="+cpaObid_arr[0];
//   response.sendRedirect(return_url);

%>

