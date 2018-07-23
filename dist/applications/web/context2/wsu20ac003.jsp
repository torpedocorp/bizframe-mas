<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.PartyIdVO" %>
<%@ page import="kr.co.bizframe.util.PagingMgtUtil" %>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%
/**
 * Get parties
 *
 * @author Ho-Jin Seo
 * @version 1.0
 */

    MxsEngine engine = MxsEngine.getInstance();
    ArrayList array = new ArrayList();

   // paging
   int curPage    = 1;
   int totalRows  = 0;

   String item_Cnt   = request.getParameter("item_Cnt2");
   String page_Cnt   = request.getParameter("page_Cnt2");
   String cur_Page   = request.getParameter("curPage");
   String mine   = request.getParameter("mine");
   String cpa_name   = request.getParameter("cpa_name");

   item_Cnt = item_Cnt == null?"10":item_Cnt;
   page_Cnt = page_Cnt == null?"10":page_Cnt;
   cur_Page = cur_Page == null?"1":cur_Page;
   mine  = (mine==null  ?  "" : mine);
   cpa_name  = (cpa_name==null  ?  "" : cpa_name);

   curPage = Integer.parseInt(cur_Page);

   //page setting
   PagingMgtUtil.setPageCnt(page_Cnt);
   PagingMgtUtil.setItemCnt(item_Cnt);

   int startNum = PagingMgtUtil.getStartRow(curPage);
   int endNum   = PagingMgtUtil.getEndRow(curPage);

	QueryCondition qc = new QueryCondition();
	if (mine.equals("0"))
		qc.add("mine", new Integer(0));
	else if (mine.equals("1"))
		qc.add("mine", new Integer(1));

	if (!cpa_name.equals(""))
		qc.add("cpa_name", cpa_name);

	array = engine.getObjects("PartyId", 0, qc, DAOFactory.EBMS);

    totalRows = array.size();

	JSONObject json = new JSONObject();

	JSONArray parties = new JSONArray();
	json.put("party",parties);

	json.put("curpage",     curPage);
	json.put("totalRows",   totalRows);
	json.put("item_cnt",    item_Cnt);

	json.put("pagelist", PagingMgtUtil.GetPageIndexForScript(curPage,totalRows,"javascript:searchList"));

	for (int i=startNum; i<=endNum; i++) {

      if(i>totalRows) break;

      PartyIdVO vo = (PartyIdVO) array.get(i-1);

		JSONObject party = new JSONObject();

		party.put("obid", vo.getObid());
		party.put("partyid", vo.getPartyId());
		party.put("mine", vo.getMine());
		party.put("cpaid", StringUtil.nullCheck(vo.getCpaId()));
		party.put("cpa_obid", StringUtil.nullCheck(vo.getCpaObid()));
		party.put("cpa_name", StringUtil.nullCheck(vo.getCpaName()));
		parties.put(party);
	}
	out.print(json);
%>
