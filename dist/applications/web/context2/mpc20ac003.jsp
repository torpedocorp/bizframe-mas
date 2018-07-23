<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.MpcVO" %>
<%@ page import="org.json.JSONObject" %>
<%
/**
 * duplication check for MPC
 *
 * @author Ho-Jin Seo
 * @authro Mi-Young Kim
 * @version 1.0
 */

String displayName = request.getParameter("displayName");

MxsEngine engine  = MxsEngine.getInstance();
QueryCondition qc = new QueryCondition();
qc.add("display_name", displayName);

MpcVO vo = (MpcVO) engine.getObject("Mpc", qc, DAOFactory.EBMS3);

JSONObject json = new JSONObject();

if(vo == null) {
	json.put("name", displayName);
	json.put("can_use", "true");
} else {
	json.put("name", vo.getDisplayName());
	json.put("can_use", "false");
}
out.print(json);
%>