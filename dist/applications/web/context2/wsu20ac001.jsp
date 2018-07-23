<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.WSSUserVO" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.Eb3Constants"%>
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

   String username   = request.getParameter("username");
   String party_obid   = request.getParameter("partyid");
   String mine   = request.getParameter("mine");

   // 특정 mpc를 사용하는 wssuser Mi-Young Kim 2008.10.06
   String mpcObid = request.getParameter("mpcObid");

   String item_Cnt   = request.getParameter("item_Cnt");
   String page_Cnt   = request.getParameter("page_Cnt");
   String cur_Page   = request.getParameter("curPage");

   username  = (username==null  ?  "" : username);
   party_obid = (party_obid==null ?  "" : party_obid);
   mine  = (mine==null  ?  "" : mine);

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
	if (mpcObid != null && mpcObid.length() > 0) {
		qc.add("mpc_obid", mpcObid);
		array = engine.getObjects("WSSUser", 1, qc, DAOFactory.EBMS3);
	} else {
		if (username.length() > 0) {
			qc.add("username", username);
		}
		if (party_obid.length() > 0 ) {
			qc.add("party_obid", party_obid);
		}
		array = engine.getObjects("WSSUser", qc, DAOFactory.EBMS3);
	}

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

      WSSUserVO userVO = (WSSUserVO) array.get(i-1);

		JSONObject user = new JSONObject();

		user.put("obid", userVO.getObid());
		user.put("id", userVO.getUsername());
		user.put("passwd", StringUtil.nullCheck(userVO.getPassword()));
		user.put("description", StringUtil.nullCheck(userVO.getDescription()));
		user.put("party_obid", StringUtil.nullCheck(party_obid));
		user.put("party_id", StringUtil.nullCheck((String)userVO.getExtension(Eb3Constants.MXSOBJ_EXTENSION_PARTY_ID)));
		user.put("mine", StringUtil.nullCheck((String)userVO.getExtension(Eb3Constants.MXSOBJ_EXTENSION_MINE)));

		users.put(user);
	}
	out.print(json);
%>
