<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.pmode.PMode"%>
<%@ page import="kr.co.bizframe.mxs.common.MxsObject"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.Eb3Constants" %>
<%@ page import="kr.co.bizframe.util.PagingMgtUtil"%>
<%@ page import="kr.co.bizframe.util.StringUtil"%>

<%
 /**
 * @author Mi-Young Kim
 * @version 1.0 2008.10.20
 */

// ============ get pmodeList ================

	// search cmn
    String strName	= request.getParameter("name");
	String strId  = request.getParameter("id");
	String strDesc = request.getParameter("desc");

	strName = (strName==null  ?  "" : strName);
	strId = (strId==null  ?  "" : strId);
	strDesc = (strDesc==null  ?  "" : strDesc);

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

	// get PModes
	ArrayList array = new ArrayList();
	try {
	      QueryCondition qc = new QueryCondition();
	      if(!strName.equals("") && strName.length() > 0) qc.addLikeClause("name", strName);
	      if(!strId.equals("") && strId.length() > 0) qc.add("pmode_id",  strId);
	      if(!strDesc.equals("") && strDesc.length() > 0) qc.addLikeClause("description", strDesc);
	      qc.setOrderByClause("ORDER BY name");

	      array = MxsEngine.getInstance().getObjects("PMode", qc, DAOFactory.EBMS3);
	      totalRows   = array.size();

	} catch (Exception e) {
	      e.printStackTrace();
	}

	JSONObject json      = new JSONObject();
	JSONArray pmodes = new JSONArray();
	json.put("pmodes",        pmodes);
	json.put("curpage",     curPage);
	json.put("totalRows",   totalRows);
	json.put("item_cnt",    item_Cnt);

	json.put("pagelist", PagingMgtUtil.GetPageIndexForScript(curPage,totalRows,"javascript:searchList"));

	for (int i=startNum; i<=endNum; i++) {
	      if(i>totalRows) break;

	      MxsObject obj = (MxsObject) array.get(i-1);
	      PMode pmode = (PMode)obj.getExtension(Eb3Constants.MXSOBJ_EXTENSION_PMODE);
	      if (pmode != null) {
		      JSONObject pmodeJS = new JSONObject();
		      pmodeJS.put("obid", pmode.getObid());
		      pmodeJS.put("name", StringUtil.checkNull(pmode.getDisplayName()));
		      pmodeJS.put("id", StringUtil.checkNull(pmode.getId()));
		      pmodeJS.put("desc", StringUtil.checkNull(pmode.getDescription()));
		      pmodeJS.put("agreement", StringUtil.checkNull(pmode.getAgreement()));
		      pmodes.put(pmodeJS);
	      }
	}
	out.print(json);
%>
