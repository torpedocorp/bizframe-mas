<%@page import="kr.co.bizframe.mxs.MxsConstants"%>
<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.web.I18nStrings" %>
<%@page import="kr.co.bizframe.mxs.MxsEngine"%>
<%
/**
 * Bulk Delete Message by Date
 *
 * @author Mi-Young Kim
 * @version 1.0 2009.08.25
 */
I18nStrings _i18n = I18nStrings.getInstance();
String fromDate = request.getParameter("f_date");
String toDate   = request.getParameter("t_date");

if (fromDate != null && toDate != null) {
	QueryCondition qc = new QueryCondition();
	qc.add("fromDate", fromDate + " 00:00");
	qc.add("toDate", toDate + " 00:00");
	MxsEngine.getInstance().deleteMessage(qc, MxsConstants.WSMS);
}
%>
