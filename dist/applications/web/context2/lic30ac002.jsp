<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.dto.LicenseVO"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.license.LicenseManager"%>
<%
 /**
 * Change state of daughter license
 *
 * @author Ho-Jin Seo
 * @version 1.0
 */

	LicenseVO lvo = new LicenseVO();

	String obid = request.getParameter("obid");
	String status = request.getParameter("status");

	//engine.updateObject("ClientLicense", obid, "is_expired", status, DAOFactory.COMMON);
	try {
		LicenseManager.getInstance().updateDaughterLicense(obid, Integer.parseInt(status));
		out.print("{\"result\": \"\"}");
	} catch (Exception e) {
		out.print("{\"result\": \"" + e.getMessage() + "\"}");
	}
%>
