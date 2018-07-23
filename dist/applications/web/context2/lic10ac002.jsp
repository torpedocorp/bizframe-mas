<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.io.InputStream"%>
<%@ page import="java.io.ByteArrayOutputStream"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="org.apache.commons.fileupload.DiskFileUpload"%>
<%@ page import="org.apache.commons.fileupload.FileUpload"%>
<%@ page import="org.apache.commons.fileupload.FileItem"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.mxs.dto.LicenseVO"%>
<%
 /**
 * Import client license
 *
 * @author Yoon-Soo Lee
 * @version 1.0
 */
%>
<html>
<head>
<%@ include file="./com00in000.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>
</head>
<body>
<%
String result = "";
byte[] license = null;
String command = "error";
String actionUrl = "lic20ms001.jsp";
boolean isMultipart = FileUpload.isMultipartContent(request);

if (isMultipart) {
	DiskFileUpload upload = new DiskFileUpload();
	List items = null;
	try {
		items = upload.parseRequest(request);
	} catch (Exception e) {
		result = _i18n.get("lic10ac002.license.upload.failed") + " : " + e.getMessage();
	}
	Iterator iter = items.iterator();
	while (iter.hasNext()) {
		Object ob = iter.next();
		FileItem item = (FileItem) ob;
		if (item != null) {
	if (!item.isFormField()) {
		if (item.getName() != null && item.getName().length() > 0) {
			try {
		InputStream uploadedStream = item.getInputStream();

		int size2;
		byte[] buffer2 = new byte[4096];
		final ByteArrayOutputStream baos2 = new ByteArrayOutputStream();
		while ((size2 = uploadedStream.read(buffer2)) != -1) {
			baos2.write(buffer2, 0, size2);
		}
		license = baos2.toByteArray();
		baos2.close();
		uploadedStream.close();
			} catch (Exception e) {
		e.printStackTrace();
			}
		}
	}
		}

	}
	try {
		MxsEngine engine = MxsEngine.getInstance();
		LicenseVO lvo = engine.loadLicense(license);
		engine.storeLicense("insert", lvo);
		out.println("<script>");
		out.println("  location.href='" + actionUrl + "';");
		out.println("</script>");
	} catch(Exception e) {
	   out.println("<script>");
	   out.println("alert('" + e.getMessage() + "');");
	   out.println("location.href = '" + actionUrl + "';");
	   out.println("</script>");
	}
}
%>
</body>
</html>