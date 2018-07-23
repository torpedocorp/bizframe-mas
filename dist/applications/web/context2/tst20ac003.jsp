<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Iterator" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.mxs.dao.MxsDAO"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.web.I18nStrings" %>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.ServiceBindingVO" %>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.PartyIdVO" %>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.ActionVO" %>
<%@ page import="kr.co.bizframe.util.PagingMgtUtil" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>

<%
/**
 * ebXML test ¿ë cpa Äõ¸®
 *
 * @author Mi-Young Kim
 * @version 1.0
 */
// ============ get subscribers list ================
	I18nStrings _i18n = I18nStrings.getInstance();


   String cpa_obid   = request.getParameter("obid");

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
   String fromPartyId = "";
   String fromPartyIdType = "";
   String toPartyId = "";
   String toPartyIdType = "";
   try {

      DAOFactory df = DAOFactory.getDAOFactory(DAOFactory.EBMS);
      MxsDAO dao = df.getDAO("ServiceBinding");
      QueryCondition qc = new QueryCondition();
      qc.add("obid", cpa_obid);
      array       = dao.executeQuery(4, qc);
      totalRows   = array.size();

      // partyInfo
      dao = df.getDAO("PartyId");
      qc = new QueryCondition();
      qc.add("cpa_obid", cpa_obid);
      ArrayList partyIds = dao.findObjects(qc);

      for (Iterator i = partyIds.iterator(); i.hasNext();) {
    	  PartyIdVO vo = (PartyIdVO) i.next();
    	  if (vo.getMine() == 1 ) {
    		  fromPartyId = vo.getPartyId();
    		  fromPartyIdType = vo.getType();
    	  } else {
    		  toPartyId = vo.getPartyId();
    		  toPartyIdType = vo.getType();
    	  }
      }
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
    json.put("fromPartyId", fromPartyId);
    json.put("fromPartyIdType", fromPartyIdType);
    json.put("toPartyId", toPartyId);
    json.put("toPartyIdType", toPartyIdType);

	for (int i=0; i<totalRows; i++) {
      ServiceBindingVO vo = (ServiceBindingVO) array.get(i);

      JSONObject cpaJS = new JSONObject();
      cpaJS.put("sb_obid", vo.getObid());
      cpaJS.put("service", vo.getService());

      JSONArray action_array = new JSONArray();
      cpaJS.put("action",  action_array);
      for (Iterator j = vo.getActionVOs().iterator(); j.hasNext();) {
    	  JSONObject actionJS = new JSONObject();
    	  ActionVO action = (ActionVO) j.next();
    	  actionJS.put("name", action.getAbAction());
    	  actionJS.put("obid", action.getObid());
    	  action_array.put(actionJS);
      }

      json_array.put(cpaJS);
	}

	out.print(json);
%>

