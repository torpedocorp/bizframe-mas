<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.org.MxsUser" %>
<%@ page import="org.json.JSONObject" %>
<%
/**
 * duplication check for user id
 *
 * @author Ho-Jin Seo
 * @version 1.0
 */
String userid = request.getParameter("userid");

MxsEngine engine  = MxsEngine.getInstance();
QueryCondition qc = new QueryCondition();
qc.add("user_id", userid);

MxsUser userVO = (MxsUser) engine.getObject("User", qc, DAOFactory.COMMON);

JSONObject json = new JSONObject();

if(userVO == null) {
	json.put("name", userid);
	json.put("can_use", "true");
} else {
	json.put("name", userid);
	json.put("can_use", "false");
}
out.print(json);
%>