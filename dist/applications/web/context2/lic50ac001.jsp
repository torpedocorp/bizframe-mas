<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.ByteArrayInputStream" %>
<%@ page import="java.io.OutputStream"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.dto.LicenseVO"%>
<%@ page import="kr.co.bizframe.mxs.license.LicenseSecurity"%>
<%
 /**
 * Export license
 *
 * @author Yoon-Soo Lee
 * @author Ho-Jin Seo
 * @version 1.0
 */
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd-HH-mm-ss");

String obid = request.getParameter("obid");
String c_id = request.getParameter("customerId");
LicenseVO license_f = null;
MxsEngine engine = MxsEngine.getInstance();
byte[] lic_b = null;
ByteArrayInputStream bis = null;

try {
    String headerStr = "attachment; filename=License_" + c_id + ".dat";

	response.setContentType("application/octet-stream");
	response.setHeader("Content-Disposition", headerStr);
	response.setHeader("Content-Description", "JSP Generated Data");

    QueryCondition qc = new QueryCondition();
    qc.add("obid", obid);
    license_f = (LicenseVO)engine.getObject("ClientLicense", qc, DAOFactory.COMMON);
    lic_b = license_f.getContent();

    LicenseSecurity ls = new LicenseSecurity();
    byte[] ret = ls.encryptByte(lic_b);

	OutputStream os = response.getOutputStream();
	os.write(ret);
    os.flush();
} catch (Exception e){
   e.printStackTrace();
   throw e;
} finally {
	if(bis != null) bis.close();
}
%>