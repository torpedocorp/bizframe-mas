<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.web.ServletMapper" %>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%
 	/**
	 * delete context
	 *
	 * @author Ho-Jin Seo
	 * @version 1.0
	 */

	String oldName = StringUtil.nullCheck(request.getParameter("oldName"));	

	if (!"".equals(oldName)) {	// 1 °Ç update
		ServletContext ctx = session.getServletContext();	
		ServletMapper mapper = new ServletMapper(ctx.getRealPath(""));

		mapper.remove(oldName);
	
	}
%>
