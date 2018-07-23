<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.wsms.model.Wsdl" %>
<%@ page import="kr.co.bizframe.mxs.wsms.model.Service" %>
<%@ page import="kr.co.bizframe.mxs.wsms.model.PortBinding" %>
<%@ page import="kr.co.bizframe.mxs.wsms.dto.WsAppPerformerVO"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%
/**
 * Get wsdl detail information
 *
 * @author Ho-Jin Seo
 * @author Mi-Young Kim
 * @version 1.0
 */
// ============ get performerList ================
    MxsEngine engine = MxsEngine.getInstance();
	String obid = request.getParameter("obid");
	Wsdl wsdlVO = null;
	ArrayList serviceList = new ArrayList();
	ArrayList portList = new ArrayList();
	ArrayList operationList = new ArrayList();

	QueryCondition qc = null;
	qc = new QueryCondition();
	qc.add("obid", obid);
	wsdlVO = (Wsdl) engine.getObject("Wsdl",  qc, DAOFactory.WSMS);

	qc = new QueryCondition();
	qc.add("wsdl_obid", obid);
	serviceList = engine.getObjects("Service",  qc, DAOFactory.WSMS);

	JSONObject json = new JSONObject();

	JSONObject wsdl = new JSONObject();
	JSONArray jServices = new JSONArray();

	json.put("wsdl", wsdl);
	wsdl.put("name", wsdlVO.getName());
	wsdl.put("service", jServices);

	for (int i=0; i<serviceList.size(); i++) {
		Service serviceVO = (Service)serviceList.get(i);
		qc = new QueryCondition();
		qc.add("service_obid", serviceVO.getObid());
        portList = engine.getObjects("PortBinding",  qc, DAOFactory.WSMS);

        JSONObject service = new JSONObject();
		JSONArray jPorts = new JSONArray();

		service.put("id", serviceVO.getObid());
		service.put("name", serviceVO.getName());
        service.put("binding", jPorts);
        jServices.put(service);

        for (int j=0; j<portList.size(); j++) {
			PortBinding portVO = (PortBinding)portList.get(i);
			qc = new QueryCondition();
			qc.add("portBindingObid", portVO.getObid());
			operationList = engine.getObjects("WsAppPerformer", 1, qc, DAOFactory.WSMS);
			JSONObject port = new JSONObject();
			JSONArray jOperations = new JSONArray();
			port.put("operation", jOperations);
			port.put("address", portVO.getAddressLocation());
			jPorts.put(port);
			for (int k=0; k<operationList.size(); k++) {
				WsAppPerformerVO vo = (WsAppPerformerVO)operationList.get(k);
				JSONObject jOperation = new JSONObject();
				jOperation.put("id", vo.getOperationObid());
				jOperation.put("name", vo.getExtension("operationName"));
				jOperation.put("performer", vo.getPerformerName());
				jOperation.put("performerType", vo.getPerformerType());
				jOperation.put("pbId" , portVO.getObid());
				jOperations.put(jOperation);
			}
        }
	}
	out.print(json);
%>
