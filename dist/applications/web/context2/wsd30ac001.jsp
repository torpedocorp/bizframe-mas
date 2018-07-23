<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.BizFrame" %>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.MxsConstants" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.mxs.wsms.model.Wsdl" %>

<%
/**
 * update wsdl
 *
 * @author Ho-Jin Seo
 * @author Mi-Young Kim
 * @version 1.0
 */

    MxsEngine engine = MxsEngine.getInstance();
	String obid = request.getParameter("obid");
	String keystoreObid = request.getParameter("keystore");
	String status = request.getParameter("wsdlstatus");
	String storageType = request.getParameter("storage_type");
	storageType = (storageType== null ? String.valueOf(MxsConstants.AGREEMENT_STORAGE_TYPE_FILE) : storageType);
    int st = Integer.parseInt(storageType);
	if (obid != null) {	// 1 °Ç update

		QueryCondition qc = new QueryCondition();
		qc.add("obid", obid);
		qc.setQueryLargeData(true);
		Wsdl vo = (Wsdl) engine.getObject("Wsdl", qc, DAOFactory.WSMS);
		if (st != vo.getStorageType()) {
			vo.setStorageType(st);
			vo.putExtension("stUpdate", "1");
		} else {
			vo.putExtension("stUpdate", "0");
		}
		vo.setKeystoreObid(keystoreObid);
		vo.setStatus(Integer.parseInt(status));
		vo.setModifiedBy(BizFrame.SYSTEM_USER_OBID);
		engine.updateObject("Wsdl", vo, DAOFactory.WSMS);
	}
%>

