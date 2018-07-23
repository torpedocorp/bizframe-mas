<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.CpaVO"%>
<%
/**
 * @author Gemini Kim
 * @version 1.0
 */
// ============ get cpaidlist ================
   MxsEngine engine = MxsEngine.getInstance();
   ArrayList cpa_array = new ArrayList();

   try {
      QueryCondition qc = new QueryCondition();
      cpa_array = engine.getObjects("Cpa", qc, DAOFactory.EBMS);
      if (cpa_array != null) {
    	   session.setAttribute("cpalist", cpa_array);

    	   JSONObject json   = new JSONObject();
    	   JSONArray cpaIds  = new JSONArray();
    	   json.put("cpa", cpaIds);

    	   for (int i = 0; i < cpa_array.size(); i++) {

    	      JSONObject cpas   = new JSONObject();
    	      CpaVO cpavo       = (CpaVO) cpa_array.get(i);

    	      cpas.put("id", cpavo.getCpaId());

    	      cpaIds.put(cpas);
    	   }

    	   out.print(json);
      }
   } catch (Exception e) {
      e.printStackTrace();
   }
%>
