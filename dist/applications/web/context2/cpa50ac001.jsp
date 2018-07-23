<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.CpaVO" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="java.io.*" %>
<%
/**
 * @author Mi-Young Kim
 * @version 1.0
 */
//============ download CPA ================
String cpaId = request.getParameter("cpa.obid");
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd-HH-mm-ss");
String dateStr = sdf.format(Calendar.getInstance().getTime());
String headerStr = "attachment; filename=" + cpaId + ".xml";

//response.setContentType("text/xml;charset=ksc5601");
response.setHeader("Content-Disposition", headerStr);
response.setHeader("Content-Description", "JSP Generated Data");
if (cpaId != null) {
	try	{
		MxsEngine engine = MxsEngine.getInstance();
		QueryCondition qc = new QueryCondition();
		qc.add("obid", cpaId);
		qc.setQueryLargeData(true);
		CpaVO cpaVO = (CpaVO) engine.getObject("Cpa", qc, DAOFactory.EBMS);
		byte[] content = cpaVO.getContent().toByteArray();

		BufferedInputStream bis = new BufferedInputStream(new ByteArrayInputStream(content));
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

		//String cpa_str = new String(content,"ksc5601");
		//out.write(cpa_str);
		//out.flush();

	} catch (Exception e) {
		e.printStackTrace();
	}
}

%>

