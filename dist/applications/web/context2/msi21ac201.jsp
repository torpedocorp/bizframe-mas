<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.AppChToSubRelVO"%>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.AppSubscriberVO"%>
<%@ page import="kr.co.bizframe.util.PagingMgtUtil" %>
<%@ page import="kr.co.bizframe.mxs.dao.MxsDAO"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%
 /**
 * @author Gemini Kim
 * @author Ho-Jin Seo
 * @version 1.0
 */
// ============ get subscriber-channel list ================

   String subscriberObid   = request.getParameter("obid");
   String subscriberName            = "";
   String subscriberDescription     = "";

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

   try {

      DAOFactory df = DAOFactory.getDAOFactory(DAOFactory.EBMS);
      MxsDAO dao = df.getDAO("AppSubscriber");
      QueryCondition qc = new QueryCondition();
      qc.add("obid", subscriberObid);

      AppSubscriberVO vo = (AppSubscriberVO)dao.findObject(qc);
      subscriberName = vo.getName();
      subscriberDescription = vo.getDescription();
   } catch (Exception e) {
      e.printStackTrace();
   }


   ArrayList array = null;

   try {
      DAOFactory df = DAOFactory.getDAOFactory(DAOFactory.EBMS);
      MxsDAO dao = df.getDAO("AppChToSubRel");
      QueryCondition qc = new QueryCondition();
      qc.add("subscriber.obid", subscriberObid);
      startNum = PagingMgtUtil.getStartRow(curPage);
      endNum   = PagingMgtUtil.getEndRow(curPage);
      array    = dao.executeQuery(1, qc);
      totalRows = array.size();

   } catch (Exception e) {
      e.printStackTrace();
   }

	JSONObject json      = new JSONObject();
	JSONArray json_array = new JSONArray();

	json.put("list",        json_array);
	json.put("curpage",     curPage);
	json.put("totalRows",   totalRows);
	json.put("item_cnt",    item_Cnt);

   json.put("obid",             subscriberObid);
   json.put("name",             subscriberName);
   json.put("description",      StringUtil.nullCheck(subscriberDescription));

	json.put("pagelist", PagingMgtUtil.GetPageIndexForScript(curPage,totalRows,"javascript:searchChannel"));


	for (int i=startNum; i<=endNum; i++) {

      if(i>totalRows) break;

      AppChToSubRelVO vo = (AppChToSubRelVO) array.get(i-1);

      JSONObject jsonObj = new JSONObject();

      jsonObj.put("obid",                       vo.getObid());
      jsonObj.put("channelObid",                vo.getQueueObid());
      jsonObj.put("channelName",                vo.getQueuelName());
      jsonObj.put("channelDescription",         StringUtil.nullCheck(vo.getQueueDescription()));
      jsonObj.put("channelNumSubscriber",       vo.getQueueNumSubscriber());
      jsonObj.put("subscriberObid",             vo.getSubscriberObid());
      jsonObj.put("subscriberName",             vo.getSubscriberName());
      jsonObj.put("subscriberDescription",      StringUtil.nullCheck(vo.getSubscriberDescription()));

      json_array.put(jsonObj);
	}


	out.print(json);
%>
