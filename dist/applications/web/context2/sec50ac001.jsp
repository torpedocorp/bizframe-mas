<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.io.OutputStream"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.dto.SecurityKeyStoreVO" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%
 /**
 * @author Mi-Young Kim
 * @version 1.0
 */

//============ download KeyStore ================
String obid = request.getParameter("obid");
if (obid != null) {
   try	{
		MxsEngine engine = MxsEngine.getInstance();
		QueryCondition qc = new QueryCondition();
		qc.add("obid", obid);
		SecurityKeyStoreVO vo = (SecurityKeyStoreVO)engine.getObject("SecurityKeyStore", qc, DAOFactory.COMMON);
		byte[] content = vo.getKeystoreContent();

		String header_str = "attachment; filename="+vo.getName();
	    response.setContentType("application/octet-stream");
	    response.setHeader("Content-Disposition", header_str);
	    OutputStream os = response.getOutputStream();
	    os.write(content);
	    os.flush();
	    os.close();

   } catch (Exception e) {
	   e.printStackTrace();
   }
}
%>
<script>
   window.close();
</script>

