<%@ page contentType="text/xml; charset=EUC-KR" language="java"%>
<%@ page import="java.io.ByteArrayOutputStream"%>
<%@ page import="java.io.ByteArrayInputStream"%>
<%@ page import="java.io.BufferedInputStream"%>
<%@ page import="java.io.BufferedOutputStream"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.pmode.PMode"%>
<%@ page import="kr.co.bizframe.mxs.common.MxsObject"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.PModeManager"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.Eb3Constants"%>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%
/**
 * PMode XML download
 & @author Mi-Young Kim
 * @version 1.0 2008.10.31
 */
	String obid = StringUtil.nullCheck(request.getParameter("obid"));

	if (!obid.equals("")) {
		QueryCondition qc = new QueryCondition();
		qc.add("obid", obid);
		MxsObject obj = MxsEngine.getInstance().getObject("PMode", qc, DAOFactory.EBMS3);
		if (obj != null) {
			PMode pmode = (PMode)obj.getExtension(Eb3Constants.MXSOBJ_EXTENSION_PMODE);
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			PModeManager.writeTo(pmode, baos);
			byte[] pmodeByte = baos.toByteArray();

			response.setContentType("application/octet-stream");
			response.setHeader("Content-Transfer-Encoding", "binary;");

			BufferedInputStream bis = new BufferedInputStream(new ByteArrayInputStream(pmodeByte));
			String headerStr = "attachment; filename=" + pmode.getId() + ".xml";
			response.setHeader("Content-Disposition", headerStr);
			BufferedOutputStream bos = new BufferedOutputStream(response.getOutputStream());

			int read = 0;
			try {
				byte[] buf = new byte[4096];

				while ((read = bis.read(buf)) != -1) {
				bos.write(buf,0,read);
				}
				bos.close();
				bis.close();
			} catch (Exception e) {
				e.printStackTrace();
				throw e;
			} finally {
				if(bos != null) bos.close();
				if(baos != null) baos.close();
				if(bis != null) bis.close();
			}
		}
	}
%>