<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.ebms.EbConstants"%>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.CpaVO" %>
<%@ page import="kr.co.bizframe.util.PagingMgtUtil" %>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>

<%
/**
 * @author Gemini Kim
 * @author Ho-Jin Seo
 * @version 1.0
 */
// ============ get subscribers list ================
   String cpa_name   = request.getParameter("cpaName");
   String cpa_status = request.getParameter("cpaStatus");

   // mpc사용하는 관련 합의 목록관련 추가 Mi-Young Kim 2008.10.01
   String mpcObid = request.getParameter("mpcObid");

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

   try {
      QueryCondition qc = new QueryCondition();
      // mpc사용하는 관련 합의 목록관련 추가 Mi-Young Kim 2008.10.01
      if (mpcObid != null && mpcObid.length() > 0) {
  	    qc.add("mpc.obid", mpcObid);
  	    array = MxsEngine.getInstance().getObjects("Cpa", 0, qc, DAOFactory.EBMS);
      } else {
          if(cpa_name != null   && !cpa_name.equals("")) {
        	  qc.add("cpa_name", cpa_name);
          }
          if(cpa_status != null && !cpa_status.equals("")) {
        	  qc.add("status", new Integer(cpa_status));
          }
          qc.setQueryLargeData(false);
          array = MxsEngine.getInstance().getObjects("Cpa", qc, DAOFactory.EBMS);
      }
      totalRows   = array.size();

   } catch (Exception e) {
      e.printStackTrace();
   }

	JSONObject json      = new JSONObject();
	JSONArray json_array = new JSONArray();

	json.put("list",        json_array);
	json.put("curpage",     curPage);
	json.put("totalRows",   totalRows);
	json.put("item_cnt",    item_Cnt);

	json.put("pagelist", PagingMgtUtil.GetPageIndexForScript(curPage,totalRows,"javascript:searchList"));


	for (int i=startNum; i<=endNum; i++) {

      if(i>totalRows) break;

      CpaVO cpaVO = (CpaVO) array.get(i-1);

      JSONObject cpaJS = new JSONObject();

      int status = cpaVO.getStatus();
      String statusStr = "";

      if (status == EbConstants.CPA_STATUS_AGREED)
         statusStr = "agreed";
      else if (status == EbConstants.CPA_STATUS_SIGNED)
         statusStr = "signed";
      else if (status == EbConstants.CPA_STATUS_PROPOSED)
         statusStr = "proposed";

      java.util.Date start = cpaVO.getLifetimeStart();
      java.util.Date end   = cpaVO.getLifetimeEnd();
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

      cpaJS.put("obid",          cpaVO.getObid());
      cpaJS.put("cpaId",          cpaVO.getCpaId());
      cpaJS.put("name",          cpaVO.getCpaName());
      cpaJS.put("partyName",     cpaVO.getPartyName());
      cpaJS.put("status",        statusStr);
      cpaJS.put("userId",        StringUtil.nullCheck(cpaVO.getUserId()));
      cpaJS.put("start",         sdf.format(start));
      cpaJS.put("end",           sdf.format(end));

      json_array.put(cpaJS);

	}

	out.print(json);

%>

