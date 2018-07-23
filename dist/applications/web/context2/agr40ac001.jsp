<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.web.I18nStrings" %>
<%@ page import="kr.co.bizframe.mxs.common.MxsObject" %>
<%
/**
 * Delete agreementRef
 *
 * @author Ho-Jin Seo 2008.10.27
 * @version 1.0
 */
I18nStrings _i18n = I18nStrings.getInstance();
String checkIndex = "";
String[]  checkIndexs = request.getParameterValues("checkIndex");

QueryCondition qc = null;
String agrObid = request.getParameter("obid");

MxsEngine engine = MxsEngine.getInstance();

if (agrObid != null) {	// 1 °Ç delete
	qc = new QueryCondition();
	qc.add("obid", agrObid);
	MxsObject obj = engine.getObject("Eb3AgreementRef", qc, DAOFactory.EBMS3);
	engine.deleteObject("Eb3AgreementRef", obj, DAOFactory.EBMS3);
} else {
	for (int i=0; i<checkIndexs.length; i++) {
		checkIndex = checkIndexs[i];
		agrObid = (String)request.getParameter("obid"+checkIndex);
		if (agrObid != null && agrObid.length() > 0) {
			qc = new QueryCondition();
			qc.add("obid", agrObid);
			MxsObject obj = engine.getObject("Eb3AgreementRef", qc, DAOFactory.EBMS3);
			engine.deleteObject("Eb3AgreementRef", obj, DAOFactory.EBMS3);
		}
	}
}
%>
