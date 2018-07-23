<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.AgreementRef" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.Eb3Constants" %>
<%@ page import="kr.co.bizframe.mxs.common.MxsObject" %>
<%@ page import="kr.co.bizframe.util.PagingMgtUtil" %>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%
/**
 * Get users
 *
 * @author Ho-Jin Seo
 * @author Mi-Young Kim
 * @version 1.0
 */

    MxsEngine engine = MxsEngine.getInstance();
    ArrayList array = new ArrayList();

   // paging
   int curPage    = 1;
   int totalRows  = 0;

   String id = StringUtil.nullCheck(request.getParameter("id"));
   String type = StringUtil.nullCheck(request.getParameter("type"));
   String reftype = StringUtil.nullCheck(request.getParameter("reftype"));
   String desc = StringUtil.nullCheck(request.getParameter("desc"));
   String mpcObid = StringUtil.nullCheck(request.getParameter("mpcObid"));

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
	if (id.equals("") == false) {
		qc.addLikeClause("agreement_ref", id);
	}
	if (type.equals("") == false) {
		qc.addLikeClause("agreement_ref_type", type);
	}
	if (reftype.equals("") == false) {
		qc.add("ref_type", reftype);
	}
	if (desc.equals("") == false) {
		qc.addLikeClause("description", desc);
	}
	if (mpcObid.equals("") == false) {
		if (id.equals("") == false) {
			qc.add("agreement_ref", id);
		}
		qc.add("mpcObid", mpcObid);
		array = engine.getObjects("Eb3AgreementRef", 0, qc, DAOFactory.EBMS3);
	} else {
		array = engine.getObjects("Eb3AgreementRef", qc, DAOFactory.EBMS3);
	}

    totalRows = array.size();

	JSONObject json = new JSONObject();
	JSONArray agreements = new JSONArray();
	json.put("agreement",agreements);

	json.put("curpage",     curPage);
	json.put("totalRows",   totalRows);
	json.put("item_cnt",    item_Cnt);

	json.put("pagelist", PagingMgtUtil.GetPageIndexForScript(curPage,totalRows,"javascript:searchList"));

	for (int i=startNum; i<=endNum; i++) {

      if(i>totalRows) break;
		MxsObject obj = (MxsObject) array.get(i-1);
        AgreementRef vo = (AgreementRef)obj.getExtension(Eb3Constants.MXSOBJ_EXTENSION_AGREEMENT_REF);

        JSONObject agreement = new JSONObject();
		agreement.put("obid", vo.getObid());
		agreement.put("id", vo.getContent());
		agreement.put("type", StringUtil.nullCheck(vo.getType()));
		agreement.put("pmode", StringUtil.nullCheck(vo.getPMode()));
		agreement.put("reftype", String.valueOf(vo.getRefType()));
		agreement.put("refobid", StringUtil.nullCheck(vo.getRefObid()));
		agreement.put("desc", StringUtil.nullCheck(vo.getDescription()));

		agreements.put(agreement);
	}
	out.print(json);
%>
