<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.AppChannelVO"%>
<%@ page import="kr.co.bizframe.util.PagingMgtUtil" %>
<%@ page import="kr.co.bizframe.mxs.dao.MxsDAO"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%
/**
 *
 * @author Gemini Kim
 * @author Ho-Jin Seo
 * @author Mi-Young Kim
 * @version 1.0
 */
// ============ get subscribers list ================
   // paging
   int curPage    = 1;
   int totalRows  = 0;

   String item_Cnt      = request.getParameter("item_Cnt");
   String page_Cnt      = request.getParameter("page_Cnt");
   String cur_Page      = request.getParameter("curPage");
   String channelName   = request.getParameter("channelName");
   String channelObid   = request.getParameter("channelObid");

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

   try {
      DAOFactory df = DAOFactory.getDAOFactory(DAOFactory.EBMS);
      MxsDAO dao = df.getDAO("AppChannel");
      QueryCondition qc = new QueryCondition();
      if(channelName!=null && !channelName.equals("") ) {
         qc.add("name", channelName);
      }

      startNum = PagingMgtUtil.getStartRow(curPage);
      endNum   = PagingMgtUtil.getEndRow(curPage);
      array    = dao.findObjects(qc);
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


	AppChannelVO channelVO = null;

	json.put("pagelist", PagingMgtUtil.GetPageIndexForScript(curPage,totalRows,"javascript:searchList"));

	for (int i=startNum; i<=endNum; i++) {

      if(i>totalRows) break;

      channelVO = (AppChannelVO) array.get(i-1);

      JSONObject channelJS = new JSONObject();

      channelJS.put("obid",        channelVO.getObid());
      channelJS.put("name",        channelVO.getName());
      channelJS.put("description", StringUtil.nullCheck(channelVO.getDescription()));
      channelJS.put("numsubscriber", channelVO.getNumSubscriber());

      json_array.put(channelJS);
	}

	out.print(json);
%>
