<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="org.apache.commons.fileupload.DiskFileUpload"%>
<%@ page import="org.apache.commons.fileupload.FileUpload"%>
<%@ page import="org.apache.commons.fileupload.FileItem"%>
<%@ page import="java.io.InputStream"%>
<%@ page import="java.io.ByteArrayOutputStream"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="kr.co.bizframe.mxs.storage.PModeFileSaveStrategy"%>
<%@ page import="kr.co.bizframe.mxs.storage.MxsFileManager"%>
<%@ page import="kr.co.bizframe.persistence.file.BfFile" %>
<%
/**
 * upload PMode payload schemaFile
 *
 * @author Mi-Young Kim
 * @version 1.0 2008.10.24
 */
%>
<html>
<head></head>
<body>
<table border=0 align=center>file uploading....</table>
<%
boolean isMultipart = FileUpload.isMultipartContent(request);
String filepath = "";
String num = request.getParameter("num");
if (isMultipart) {
	DiskFileUpload upload = new DiskFileUpload();
	List items = null;
	items = upload.parseRequest(request);
	Iterator iter = items.iterator();
	byte[] schemaByte = null;
	while (iter.hasNext()) {
		Object ob = iter.next();
		FileItem item = (FileItem) ob;
		if (item != null && !item.isFormField()) {
				if (item.getName() != null && item.getName().length() > 0) {
					try {
						InputStream uploadedStream = item.getInputStream();
						schemaByte = null;
						int size2 = 0;
						byte[] buffer2 = new byte[4096];
						final ByteArrayOutputStream baos = new ByteArrayOutputStream();
						while ((size2 = uploadedStream.read(buffer2)) != -1) {
							baos.write(buffer2, 0, size2);
						}
						schemaByte = baos.toByteArray();
						baos.close();
						uploadedStream.close();

						// save
						MxsFileManager fm = MxsFileManager.getInstance();
						PModeFileSaveStrategy pmodeFss = new PModeFileSaveStrategy(fm.getRootDir(), fm.getNumFiles());
						BfFile schemaFile = new BfFile(schemaByte);
						filepath = fm.save(schemaFile, pmodeFss);

					} catch (Exception e) {
						e.printStackTrace();
					}
				}
		}
	}
}
if (filepath.length() > 0 ) {
%>
<script>
opener.applySchemaFile("<%=num%>", "<%=filepath%>");
</script>
<%
}
%>
<script>
window.close();
</script>
<input type=button value="close" onClick="javascript:self.close();">
</body>
</html>

