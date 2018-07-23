<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="org.json.JSONObject" %>
<%@ page import="kr.co.bizframe.mxs.monitor.MonitorManager" %>
<%@ page import="kr.co.bizframe.mxs.web.AjaxProxy" %>
<%
/**
 * Monitor : 송신처리현황
 *
 * @author Ho-Jin Seo
 * @version 1.0
 */
 	String url = request.getParameter("s");
	if (url != null && url.length() > 0) {
		out.print(AjaxProxy.getInstance().getResult(url + "/mon21ac001.jsp"));
		return;
	}

	JSONObject json = new JSONObject();

	MonitorManager mon = MonitorManager.getInstance();

	//mon.increaseSendSuccessCountWS();
	//mon.increaseSendFailCountWS();
	json.put("e1", mon.getSendSuccessTotalCount());
	json.put("e2", mon.getSendFailTotalCount());

	out.print(json);


%>
