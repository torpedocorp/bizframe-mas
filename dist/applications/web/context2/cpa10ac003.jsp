<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.CpaVO" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="org.json.JSONObject" %>
<%
/**
 * @author Gemini Kim
 * @author Ho-Jin Seo
 * @version 1.0
 */
//============ Check Cpa Name Duplication ================
String cpa_name = request.getParameter("cpa_name");
boolean flag = false;

try	{
   MxsEngine engine  = MxsEngine.getInstance();
   QueryCondition qc = new QueryCondition();
   qc.add("cpa_name", cpa_name);
   qc.setQueryLargeData(false);
   CpaVO cpaVO = (CpaVO) engine.getObject("Cpa", qc, DAOFactory.EBMS);

	JSONObject json = new JSONObject();

   if(cpaVO == null) {
   		json.put("name", cpa_name);
   		json.put("can_use", "true");
   } else {
   		json.put("name", cpa_name);
   		json.put("can_use", "false");
   }
   out.print(json);
} catch (Exception e) {
   e.printStackTrace();
}
%>
