<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%@ page import="kr.co.bizframe.mxs.web.ServletMapper" %>

<%
	/**
	 * add context
	 *
	 * @author Ho-Jin Seo
	 * @version 1.0
	 */

	String serviceName = StringUtil.nullCheck(request.getParameter("serviceName"));	

	if (!"".equals(serviceName)) {	// 1 °Ç update
		ServletContext ctx = session.getServletContext();	
		ServletMapper mapper = new ServletMapper(ctx.getRealPath(""));

		mapper.add(serviceName);
	
	}
%>

