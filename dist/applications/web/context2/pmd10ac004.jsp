<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.io.InputStream"%>
<%@ page import="java.io.ByteArrayOutputStream"%>
<%@ page import="java.io.ByteArrayInputStream" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="org.apache.commons.fileupload.DiskFileUpload"%>
<%@ page import="org.apache.commons.fileupload.FileUpload"%>
<%@ page import="org.apache.commons.fileupload.FileItem"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.PModeManager" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.Eb3Constants" %>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.common.MxsObject"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.pmode.PMode" %>
<%
/**
 * insert PMode File
 *
 * @author Mi-Young Kim
 * @version 1.0 2008.10.25
 */

String url = "pmd20ms001.jsp";
boolean isMultipart = FileUpload.isMultipartContent(request);
if (isMultipart) {
	DiskFileUpload upload = new DiskFileUpload();
	List items = null;
	items = upload.parseRequest(request);
	Iterator iter = items.iterator();
	byte[] pmodeByte = null;
	while (iter.hasNext()) {
		Object ob = iter.next();
		FileItem item = (FileItem) ob;
		if (item != null && !item.isFormField()) {
				if (item.getName() != null && item.getName().length() > 0) {
					try {
						InputStream uploadedStream = item.getInputStream();
						pmodeByte = null;
						int size2 = 0;
						byte[] buffer2 = new byte[4096];
						final ByteArrayOutputStream baos = new ByteArrayOutputStream();
						while ((size2 = uploadedStream.read(buffer2)) != -1) {
							baos.write(buffer2, 0, size2);
						}
						pmodeByte = baos.toByteArray();
						baos.close();
						uploadedStream.close();

					} catch (Exception e) {
						e.printStackTrace();
					}
				}
		}
	}

	if (pmodeByte != null) {

		ByteArrayInputStream bais = new ByteArrayInputStream(pmodeByte);
		PMode pmode = PModeManager.parse(bais);
		bais.close();

		// check pmodeId Duplicate
		MxsEngine engine  = MxsEngine.getInstance();
		QueryCondition qc = new QueryCondition();
		qc.add("pmode_id", pmode.getId());
		MxsObject obj = engine.getObject("PMode", qc, DAOFactory.EBMS3);
		PMode vo = null;
		if (obj != null) {
			vo = (PMode)obj.getExtension(Eb3Constants.MXSOBJ_EXTENSION_PMODE);
		}

		if (vo != null) {
			// to DetailForm
			url = "pmd20ms001.jsp?command=update&obid=" + vo.getObid();
			pmode.setObid(vo.getObid());
			pmode.setFilePath(vo.getFilePath());
			if (vo.getDisplayName().equals(pmode.getDisplayName())) {
				url = url + "&nameCheckFlag=1";
			}

		} else {
			// to insertForm
			url = "pmd21ms001.jsp?command=insert";
		}
		session.setAttribute("pmode", pmode);

	}
}
%>
<html>
<head></head>
<body>
<script>
 location.href = "<%=url%>";
</script>
</body>
</html>
