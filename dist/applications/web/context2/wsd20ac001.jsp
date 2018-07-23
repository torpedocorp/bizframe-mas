<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="kr.co.bizframe.mxs.wsms.model.Wsdl" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="kr.co.bizframe.mxs.org.MxsUser" %>
<%@ page import="kr.co.bizframe.util.PagingMgtUtil" %>
<%
/**
 * Get WSDL list
 *
 * @author Ho-Jin Seo
 * @version 1.0
 */
    MxsEngine engine = MxsEngine.getInstance();
    ArrayList array = new ArrayList();

    String search_type = request.getParameter("wsdltype");
    String search_name = request.getParameter("wsdlname");
    String search_status = request.getParameter("wsdlstatus");

    if (search_type == null) search_type="";
    if (search_name == null) search_name="";
    if (search_status == null) search_status="";

    QueryCondition qc = new QueryCondition();

    if (search_type.equals("0") || search_type.equals("1")) {
    	qc.add("be_client", new Integer(search_type));
    }

    if (search_status.equals("0") || search_status.equals("1")) {
    	qc.add("status", new Integer(search_status));
    }

    if (search_name != null && !search_name.equals("")) {
    	qc.add("name", search_name);
    }

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

    array = engine.getObjects("Wsdl", qc, DAOFactory.WSMS);
    totalRows = array.size();

	JSONObject json = new JSONObject();

	JSONArray wsdls = new JSONArray();
	json.put("wsdl", wsdls);

	json.put("curpage",     curPage);
	json.put("totalRows",   totalRows);
	json.put("item_cnt",    item_Cnt);

	json.put("pagelist", PagingMgtUtil.GetPageIndexForScript(curPage,totalRows,"javascript:searchList"));

	for (int i=startNum; i<=endNum; i++) {

      if(i>totalRows) break;

		//Wsdl wsdlVO = (Wsdl) array.get(i);
		Wsdl wsdlVO = (Wsdl) array.get(i-1);
		String wsdlObid = wsdlVO.getObid();
		String wsdlType = (wsdlVO.getBeClient() == 1 ? "Client" : "Provider");
		String statusStr = (wsdlVO.getStatus() == 0 ? "Disabled" : "Enabled");
		int beClient = wsdlVO.getBeClient();

		String userId = null;

		qc = new QueryCondition();
		qc.add("obid", wsdlVO.getUserObid());
		MxsUser userVO = (MxsUser) engine.getObject("User", qc, DAOFactory.COMMON);

		if (userVO != null)
			userId = userVO.getUserId();

		userId = (userId == null ? "admin" : userId);
		java.util.Date creationDate = wsdlVO.getCreatedOn();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

		JSONObject wsdl = new JSONObject();

		wsdl.put("obid", wsdlVO.getObid());
		wsdl.put("name", wsdlVO.getName());
		wsdl.put("type", wsdlType);
		wsdl.put("isclient", beClient);
		wsdl.put("creation", sdf.format(creationDate));
		wsdl.put("status", statusStr);
		wsdl.put("owner", userId);

		wsdls.put(wsdl);
	}
	out.print(json);
%>
