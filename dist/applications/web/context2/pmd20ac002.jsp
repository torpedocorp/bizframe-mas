<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.common.MxsObject"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.pmode.PMode" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.Eb3Constants" %>
<%@ page import="org.json.JSONObject" %>
<%
/**
 * duplication check for P-Mode Name
 *
 * @authro Mi-Young Kim
 * @version 1.0 2008.10.21
 */

String id = request.getParameter("id");

MxsEngine engine  = MxsEngine.getInstance();
QueryCondition qc = new QueryCondition();
qc.add("pmode_id", id);
MxsObject obj = engine.getObject("PMode", qc, DAOFactory.EBMS3);
PMode vo = null;
if (obj != null) {
	vo = (PMode)obj.getExtension(Eb3Constants.MXSOBJ_EXTENSION_PMODE);
}
JSONObject json = new JSONObject();
json.put("id", id);
if(vo == null) {
	json.put("can_use", "true");
} else {
	json.put("can_use", "false");
}
out.print(json);
%>