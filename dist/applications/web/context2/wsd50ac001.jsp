<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.wsms.model.Wsdl" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="java.io.*" %>
<%
/**
 * Download WSDL
 *
 * @author Ho-Jin Seo
 * @version 1.0
 */
String obid = request.getParameter("obid");
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd-HH-mm-ss");
String dateStr = sdf.format(Calendar.getInstance().getTime());
String headerStr = "attachment; filename=" + dateStr + ".xml";

response.setContentType("text/xml;charset=ksc5601");
response.setHeader("Content-Disposition", headerStr);
response.setHeader("Content-Description", "JSP Generated Data");
if (obid != null) {
	MxsEngine engine = MxsEngine.getInstance();
	QueryCondition qc = new QueryCondition();
	qc.add("obid", obid);
	qc.setQueryLargeData(true);
	Wsdl wsdlVO = (Wsdl) engine.getObject("Wsdl", qc, DAOFactory.WSMS);

	BufferedInputStream bis = new BufferedInputStream(new ByteArrayInputStream(wsdlVO.getContent().toByteArray()));
	BufferedOutputStream outs = new BufferedOutputStream(response.getOutputStream());

	int read = 0;
	try {
		byte[] buf = new byte[4096];
		while ((read = bis.read(buf)) != -1) {
			outs.write(buf,0,read);
		}
		outs.flush();
		outs.close();
		bis.close();
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		if(bis!=null) bis.close();
	}
}
%>

