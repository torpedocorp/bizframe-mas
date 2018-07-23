<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.dto.SecurityKeyStoreVO" %>
<%
 /**
 * Delete Security Keystore
 *
 * @author Yoon-Soo Lee
 * @author Mi-Young Kim
 * @version 1.0
 */
String obid ="";
try {
	String[]  checkIndexs = request.getParameterValues("obid");
	for (int i=0; i<checkIndexs.length; i++) {
		obid = checkIndexs[i];
		if (obid != null && obid.length() > 0) {
	MxsEngine engine = MxsEngine.getInstance();
	QueryCondition qc = new QueryCondition();
	qc.add("obid", obid);
	ArrayList list = engine.getObjects("SecurityKeyStore", 1, qc, DAOFactory.COMMON);
	if (list != null && list.size() > 0) {
		// get KeystoreVO
		SecurityKeyStoreVO vo = (SecurityKeyStoreVO) list.get(0);

		// delete keystore
		engine.deleteObject("SecurityKeyStore", vo, DAOFactory.COMMON);

                // update keystore_obid of cpa
                ArrayList cpaObIds = vo.getCpaObids();
                if (cpaObIds.size() > 0) {
                	for (int j = 0 ; j < cpaObIds.size(); j++)  {
                		String cpaObid = (String) cpaObIds.get(j);
                		if (cpaObid != null && cpaObid.length() > 0) {
                  	engine.updateObject("Cpa", cpaObid, "KEYSTORE_OBID", "", DAOFactory.EBMS);
                		}
                	}
                }

	}
		}
	}
} catch (Exception e) {
	e.printStackTrace();
	throw e;
}
%>
