<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="kr.co.bizframe.util.PagingMgtUtil" %>
<%@ page import="kr.co.bizframe.mxs.web.ServletMapper" %>
<%
	/**
	 * Get Context List
	 *
	 * @author Ho-Jin Seo
	 * @version 1.0
	 */

	ArrayList array = new ArrayList();

	// paging
	int curPage	= 1;
	int totalRows  = 0;

	String item_Cnt   = request.getParameter("item_Cnt");
	String page_Cnt   = request.getParameter("page_Cnt");
	String cur_Page   = request.getParameter("curPage");

	item_Cnt = item_Cnt == null?"1000":item_Cnt;
	page_Cnt = page_Cnt == null?"10":page_Cnt;
	cur_Page = cur_Page == null?"1":cur_Page;

	curPage = Integer.parseInt(cur_Page);

	//page setting
	PagingMgtUtil.setPageCnt(page_Cnt);
	PagingMgtUtil.setItemCnt(item_Cnt);

	int startNum = PagingMgtUtil.getStartRow(curPage);
	int endNum   = PagingMgtUtil.getEndRow(curPage);

	ServletContext ctx = session.getServletContext();
	ServletMapper mapper = new ServletMapper(ctx.getRealPath(""));

	array = mapper.getList();
	totalRows = array.size();

	JSONObject json = new JSONObject();

	JSONArray contexts = new JSONArray();
	json.put("web", contexts);

	json.put("curpage",	 curPage);
	json.put("totalRows",   totalRows);
	json.put("item_cnt",	item_Cnt);

	json.put("pagelist", PagingMgtUtil.GetPageIndexForScript(curPage,totalRows,"javascript:searchList"));

	for (int i=startNum; i<=endNum; i++) {

		if(i>totalRows) break;

		JSONObject context = new JSONObject();

		String wsdlname = (String)array.get(i-1);

		context.put("service", wsdlname);
		contexts.put(context);
	}
	out.print(json);
%>
