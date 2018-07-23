<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%@ page import="kr.co.bizframe.mxs.web.ServletMapper" %>

<%
	/**
	 * update context
	 *
	 * @author Ho-Jin Seo
	 * @version 1.0
	 */

	String oldName = StringUtil.nullCheck(request.getParameter("oldName"));	
	String newName = StringUtil.nullCheck(request.getParameter("newName"));	

	if (!"".equals(oldName) && !"".equals(newName)) {	// 1 °Ç update
		ServletContext ctx = session.getServletContext();	
		ServletMapper mapper = new ServletMapper(ctx.getRealPath(""));

		mapper.modify(oldName, newName);
	}
%>

