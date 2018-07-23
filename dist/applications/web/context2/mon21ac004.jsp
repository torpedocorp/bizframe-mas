<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="org.json.JSONObject" %>
<%@ page import="kr.co.bizframe.mxs.web.AjaxProxy" %>
<%
/**
 * Monitor : Memory ÇöÈ²
 *
 * @author Ho-Jin Seo
 * @version 1.0
 */
	String url = request.getParameter("s");
	if (url != null && url.length() > 0) {
		out.print(AjaxProxy.getInstance().getResult(url + "/mon21ac004.jsp"));
		return;
	}

	JSONObject json = new JSONObject();

	long free = Runtime.getRuntime().freeMemory();
	long total = Runtime.getRuntime().totalMemory();
	long max = Runtime.getRuntime().maxMemory();
	long mem = 100 - (free * 100 / total);

	json.put("e1", mem);
	json.put("e2", 0);

	out.print(json);
%>
