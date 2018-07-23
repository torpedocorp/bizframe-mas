<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.wsms.model.Wsdl" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="org.json.JSONObject" %>
<%
/**
 * @author Ho-Jin Seo
 * @version 1.0
 */
//============ Check Wsdl Name Duplication ================
String wsdl_name = request.getParameter("wsdlName");
boolean flag = false;

   MxsEngine engine  = MxsEngine.getInstance();
   QueryCondition qc = new QueryCondition();
   qc.add("name", wsdl_name);

   Wsdl wsdlVO = (Wsdl) engine.getObject("Wsdl", qc, DAOFactory.WSMS);

	JSONObject json = new JSONObject();

   if(wsdlVO == null) {
   		json.put("name", wsdl_name);
   		json.put("can_use", "true");
   } else {
   		json.put("name", wsdl_name);
   		json.put("can_use", "false");
   }
   out.print(json);
%>