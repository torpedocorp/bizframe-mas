<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="kr.co.bizframe.mxs.org.MxsUser" %>
<%@ page import="kr.co.bizframe.util.PagingMgtUtil" %>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%
/**
 * Get users
 *
 * @author Ho-Jin Seo
 * @version 1.0
 */

    MxsEngine engine = MxsEngine.getInstance();
    ArrayList array = new ArrayList();

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

	QueryCondition qc = new QueryCondition();
	array = engine.getObjects("User", qc, DAOFactory.COMMON);

    totalRows = array.size();

	JSONObject json = new JSONObject();

	JSONArray users = new JSONArray();
	json.put("user",users);

	json.put("curpage",     curPage);
	json.put("totalRows",   totalRows);
	json.put("item_cnt",    item_Cnt);

	json.put("pagelist", PagingMgtUtil.GetPageIndexForScript(curPage,totalRows,"javascript:searchList"));

	for (int i=startNum; i<=endNum; i++) {

      if(i>totalRows) break;

		MxsUser userVO = (MxsUser) array.get(i-1);

		JSONObject user = new JSONObject();

		user.put("obid", userVO.getObid());
		user.put("id", userVO.getUserId());
		//user.put("passwd", StringUtil.nullCheck(userVO.getPasswd()));
		user.put("description", StringUtil.nullCheck(userVO.getDescription()));
		user.put("cellphone", StringUtil.nullCheck(userVO.getCellphone()));
		user.put("email", StringUtil.nullCheck(userVO.getEmail()));

		String cell = StringUtil.nullCheck(userVO.getCellphone());
		String cell1 = "";
		String cell2 = "";
		String cell3 = "";
		if(cell.length()==10)
		{
			cell1 = cell.substring(0,3);
			cell2 = cell.substring(3,6);
			cell3 = cell.substring(6);
		}
		else if(cell.length()==11)
		{
			cell1 = cell.substring(0,3);
			cell2 = cell.substring(3,7);
			cell3 = cell.substring(7);
		}

		user.put("cell1", cell1);
		user.put("cell2", cell2);
		user.put("cell3", cell3);

		users.put(user);
	}
	out.print(json);
%>
