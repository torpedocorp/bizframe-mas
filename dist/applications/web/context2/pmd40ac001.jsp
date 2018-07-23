<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.web.I18nStrings" %>
<%@ page import="kr.co.bizframe.mxs.common.MxsObject" %>

<%
/**
 * Delete pmode
 *
 * @author Ho-Jin Seo 2008.10.28
 * @version 1.0
 */
I18nStrings _i18n = I18nStrings.getInstance();
QueryCondition qc = null;

String[] obid_arr = request.getParameterValues("obid");
if (obid_arr == null) {
	obid_arr = request.getParameterValues("obid");
}

if(obid_arr == null) return;

MxsEngine engine = MxsEngine.getInstance();
for (int i = 0; i <obid_arr.length; i++) {
	qc = new QueryCondition();
	qc.add("obid", obid_arr[i]);
	MxsObject vo = engine.getObject("PMode", qc, DAOFactory.EBMS3);
	engine.deleteObject("PMode", vo, DAOFactory.EBMS3);
}
%>
