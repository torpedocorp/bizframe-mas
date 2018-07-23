<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.wsms.model.Wsdl" %>
<%@ page import="kr.co.bizframe.mxs.web.I18nStrings" %>
<%
/**
 * Delete WSDL
 *
 * @author Ho-Jin Seo
 * @version 1.0
 */
I18nStrings _i18n = I18nStrings.getInstance();
String checkIndex = "";
String[]  checkIndexs = request.getParameterValues("checkIndex");

QueryCondition qc = null;
String wsdlObid = request.getParameter("obid");

MxsEngine engine = MxsEngine.getInstance();
ServletContext context = session.getServletContext();

if (wsdlObid != null) {	// 1 °Ç delete
	qc = new QueryCondition();
	qc.add("obid", wsdlObid);
	Wsdl wsdlVO = (Wsdl) engine.getObject("Wsdl", qc, DAOFactory.WSMS);
	engine.deleteObject("Wsdl", wsdlVO, DAOFactory.WSMS);

//	ServletMapper mapper = new ServletMapper(context.getRealPath(""), wsdlVO.getName());
//	mapper.remove();
} else {
	for (int i=0; i<checkIndexs.length; i++) {
		checkIndex = checkIndexs[i];
		wsdlObid = (String)request.getParameter("wsdlObid"+checkIndex);
		if (wsdlObid != null && wsdlObid.length() > 0) {
			qc = new QueryCondition();
			qc.add("obid", wsdlObid);
			Wsdl wsdlVO = (Wsdl) engine.getObject("Wsdl", qc, DAOFactory.WSMS);
			engine.deleteObject("Wsdl", wsdlVO, DAOFactory.WSMS);

//			ServletMapper mapper = new ServletMapper(context.getRealPath(""), wsdlVO.getName());
//			mapper.remove();
		}
	}
}

%>
