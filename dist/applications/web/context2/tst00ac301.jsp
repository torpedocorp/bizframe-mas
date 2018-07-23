<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.MpcVO"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.Eb3Constants"%>
<%@ page import="kr.co.bizframe.util.PagingMgtUtil"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.web.I18nStrings"%>
<%
/**
 * Remote MPC List
 *
 * @author Ho-Jin Seo
 * @version 1.0 2008.10.08
 */

    String actionObid	= request.getParameter("actionObid");

	actionObid = (actionObid==null  ?  "" : actionObid);
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

	// get Mpcs
	ArrayList array = new ArrayList();
    QueryCondition qc = new QueryCondition();
    qc.add("is_local", new Integer(Eb3Constants.MPC_LOCAL));

	if(!actionObid.equals("") && actionObid.length() > 0) qc.add("binding.action_obid", actionObid);

    array = MxsEngine.getInstance().getObjects("Mpc", 0, qc, DAOFactory.EBMS3);
    totalRows   = array.size();

	JSONObject json      = new JSONObject();
	JSONArray mpcs = new JSONArray();
	json.put("mpcs",        mpcs);
	json.put("curpage",     curPage);
	json.put("totalRows",   totalRows);
	json.put("item_cnt",    item_Cnt);

	json.put("pagelist", PagingMgtUtil.GetPageIndexForScript(curPage,totalRows,"javascript:searchList"));

	I18nStrings _i18n = I18nStrings.getInstance();
	for (int i=startNum; i<=endNum; i++) {
	      if(i>totalRows) break;

	      MpcVO mpc = (MpcVO) array.get(i-1);

	      int isDefault = mpc.getIsDefault();
	      String isDefaultStr = "";
	      if (isDefault == Eb3Constants.MPC_DEFAULT) {
	         isDefaultStr = _i18n.get("mpc20ms001.str.default");
	      }
	      else if (isDefault == Eb3Constants.MPC_NON_DEFAULT) {
	    	  isDefaultStr = _i18n.get("mpc20ms001.str.nondefault");
	      }

	      String isActiveStr = "";
	      int isActive = mpc.getIsActive();
	      if (isActive == Eb3Constants.MPC_ACTIVE) {
	    	isActiveStr = _i18n.get("mpc20ms001.str.active");
		  } else if (isActive == Eb3Constants.MPC_INACTIVE) {
		    isActiveStr = _i18n.get("mpc20ms001.str.inactive");
		  }

	      JSONObject mpcJS = new JSONObject();
	      mpcJS.put("obid", mpc.getObid());
	      mpcJS.put("displayName", mpc.getDisplayName());
	      mpcJS.put("isDefault", isDefaultStr);
	      mpcJS.put("isDefaultVal", isDefault);
	      mpcJS.put("status", isActiveStr);
	      mpcJS.put("uri", mpc.getMpcUri());
	      mpcJS.put("isActive", mpc.getIsActive());
	      mpcs.put(mpcJS);
	}
	out.print(json);

%>
