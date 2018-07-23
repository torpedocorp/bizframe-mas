<%@ page contentType="text/xml; charset=EUC-KR" language="java"%>
<%@ page import="java.io.OutputStream"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.wsms.model.Wsdl"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%
/**
 * @author Ho-Jin Seo
 * @version 1.0
 */

String obid = request.getParameter("obid");
if (obid != null) {
	try {
		MxsEngine engine = MxsEngine.getInstance();
		QueryCondition qc = new QueryCondition();
		qc.add("obid", obid);
		qc.setQueryLargeData(true);

		Wsdl wsdlVO = (Wsdl) engine.getObject("Wsdl", qc, DAOFactory.WSMS);
		byte[] content = wsdlVO.getContent().toByteArray();
		OutputStream os = response.getOutputStream();
		os.write(content);
		os.flush();
	} catch (Exception e) {

	}

}
%>
