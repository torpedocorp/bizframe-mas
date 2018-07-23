<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.AppSubscriberVO"%>
<%@ page import="kr.co.bizframe.util.PagingMgtUtil" %>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%
/**
 * @author Gemini Kim
 * @author Ho-Jin Seo
 * @author Mi-Young Kim
 * @version 1.0
 */
// ============ get subscribers list ================
   // channelObid is not null... in case calling from msi20pu201.jsp
   // channelObid is null...     in case calling from msi20ms201.jsp
   String channelObid      = request.getParameter("channel.obid");
   String subscriberName   = request.getParameter("subscriberName");

   // paging
   int curPage    = 1;
   int totalRows  = 0;

   String item_Cnt   = request.getParameter("item_Cnt");
   String page_Cnt   = request.getParameter("page_Cnt");
   String cur_Page   = request.getParameter("curPage");

   item_Cnt = item_Cnt == null?"10":item_Cnt;
   page_Cnt = page_Cnt == null?"10":page_Cnt;
   cur_Page = cur_Page == null?"1":cur_Page;

   curPage = Integer.parseInt(cur_Page);

   //page setting
   PagingMgtUtil.setPageCnt(page_Cnt);
   PagingMgtUtil.setItemCnt(item_Cnt);

   int startNum = PagingMgtUtil.getStartRow(curPage);
   int endNum   = PagingMgtUtil.getEndRow(curPage);

   ArrayList array = new ArrayList();
   MxsEngine engine = MxsEngine.getInstance();
   QueryCondition qc = null;

   if(channelObid == null) {
      qc = new QueryCondition();
      array = engine.getObjects("AppSubscriber", qc, DAOFactory.EBMS);
   } else {
      qc = new QueryCondition();
      qc.add("relation.channel_obid", channelObid);
      if(subscriberName!=null && !subscriberName.equals("")) {
         qc.add("subscriber.name", subscriberName);
      }
      array = engine.getObjects("AppSubscriber", 1, qc,DAOFactory.EBMS);
   }
   totalRows = array.size();

	JSONObject json      = new JSONObject();
	JSONArray json_array = new JSONArray();

	json.put("list",        json_array);
	json.put("curpage",     curPage);
	json.put("totalRows",   totalRows);
	json.put("item_cnt",    item_Cnt);


	AppSubscriberVO subscriberVO = null;

	json.put("pagelist", PagingMgtUtil.GetPageIndexForScript(curPage,totalRows,"javascript:searchList"));

	for (int i=startNum; i<=endNum; i++) {

      if(i>totalRows) break;

      subscriberVO = (AppSubscriberVO) array.get(i-1);

      JSONObject jsonObj = new JSONObject();

      jsonObj.put("obid",        subscriberVO.getObid());
      jsonObj.put("name",        subscriberVO.getName());
      jsonObj.put("description", StringUtil.nullCheck(subscriberVO.getDescription()));

      // 구독자의 구독하고있는 채널의 수 설정.
      qc = new QueryCondition();
      qc.add("subscriber_obid", subscriberVO.getObid());
      ArrayList list = engine.getObjects("AppChToSubRel", 0, qc, DAOFactory.EBMS);
      if(list == null) list = new ArrayList();

      jsonObj.put("numChannels", list.size());
      json_array.put(jsonObj);
	}

	out.print(json);
%>
