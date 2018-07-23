<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.dto.SecurityKeyStoreVO" %>
<%@ page import="kr.co.bizframe.util.PagingMgtUtil" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%
 /**
 * @author Yoon-Soo Lee
 * @author Mi-Young Kim
 * @version 2.0
 */
//============ get KeystoreList ================
     // paging
    int curPage    = 1;
    int totalRows  = 0;

    String item_Cnt   = request.getParameter("item_Cnt");
    String page_Cnt   = request.getParameter("page_Cnt");
    String cur_Page   = request.getParameter("curPage");
    String search = request.getParameter("search");
    item_Cnt = item_Cnt == null?"10":item_Cnt;
    page_Cnt = page_Cnt == null?"10":page_Cnt;
    cur_Page = cur_Page == null?"1":cur_Page;
    search = (search == null  ? "" : search);
    item_Cnt       = (item_Cnt==null  ?  "100" : item_Cnt);
    page_Cnt       = (page_Cnt==null  ?  "10" : page_Cnt);

    curPage = Integer.parseInt(cur_Page);

    // page setting
    PagingMgtUtil.setPageCnt(page_Cnt);
    PagingMgtUtil.setItemCnt(item_Cnt);

    int startNum = PagingMgtUtil.getStartRow(curPage);
    int endNum   = PagingMgtUtil.getEndRow(curPage);

    // get Data
    MxsEngine engine = MxsEngine.getInstance();
    ArrayList array = new ArrayList();
    try {
        QueryCondition qc = new QueryCondition();
        if (search != null && search.length() > 0)
	        qc.add("name", search);
        array = engine.getObjects("SecurityKeyStore",  qc, DAOFactory.COMMON);
        totalRows   = array.size();
    }
    catch (Exception e){
       throw e;
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
       JSONObject keystoreJS = new JSONObject();
	   SecurityKeyStoreVO vo = (SecurityKeyStoreVO) array.get(i-1);
	   keystoreJS.put("obid", vo.getObid());
	   keystoreJS.put("alias", vo.getPrivateKeyAlias());
	   keystoreJS.put("type", vo.getKeystoreType());
	   keystoreJS.put("name", vo.getName());
	   String desc = vo.getDescription();
	   desc = (desc == null ? "" : desc);
	   keystoreJS.put("desc", desc);
       json_array.put(keystoreJS);
 	}
 	out.print(json);
%>

