<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.web.I18nStrings" %>
<%@ page import="kr.co.bizframe.mxs.org.MxsUser" %>

<%
/**
 * Delete user
 *
 * @author Ho-Jin Seo
 * @version 1.0
 */
I18nStrings _i18n = I18nStrings.getInstance();
String checkIndex = "";
String[]  checkIndexs = request.getParameterValues("checkIndex");

QueryCondition qc = null;
String userObid = request.getParameter("obid");

MxsEngine engine = MxsEngine.getInstance();

if (userObid != null) {	// 1 °Ç delete
	qc = new QueryCondition();
	qc.add("obid", userObid);
	MxsUser userVO = (MxsUser) engine.getObject("User", qc, DAOFactory.COMMON);
	// "admin" can't be deleted
	if (!userVO.getUserId().equals("admin"))
		engine.deleteObject("User", userVO, DAOFactory.COMMON);
} else {
	for (int i=0; i<checkIndexs.length; i++) {
		checkIndex = checkIndexs[i];
		userObid = (String)request.getParameter("userObid"+checkIndex);
		if (userObid != null && userObid.length() > 0) {
			qc = new QueryCondition();
			qc.add("obid", userObid);
			MxsUser userVO = (MxsUser) engine.getObject("User", qc, DAOFactory.COMMON);

			// "admin" can't be deleted
			if (!userVO.getUserId().equals("admin"))
				engine.deleteObject("User", userVO, DAOFactory.COMMON);
		}
	}
}

%>
