<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%@ page import="kr.co.bizframe.mxs.common.MxsObject" %>
<%@ page import="org.json.JSONObject" %>
<%
/**
 * duplication check for agreementRef
 *
 * @author Ho-Jin Seo
 * @version 1.0
 */
String id = StringUtil.nullCheck(request.getParameter("id"));

MxsEngine engine  = MxsEngine.getInstance();
QueryCondition qc = new QueryCondition();
qc.add("agreement_ref", id);

MxsObject vo = engine.getObject("Eb3AgreementRef", qc, DAOFactory.EBMS3);
JSONObject json = new JSONObject();
if(vo == null) {
	json.put("name", id);
	json.put("can_use", "true");
} else {
	json.put("name", id);
	json.put("can_use", "false");
}
out.print(json);
%>