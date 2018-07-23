<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.io.InputStream"%>
<%@ page import="java.io.ByteArrayOutputStream"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="org.apache.commons.fileupload.DiskFileUpload"%>
<%@ page import="org.apache.commons.fileupload.FileUpload"%>
<%@ page import="org.apache.commons.fileupload.FileItem"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.mxs.dto.SecurityKeyStoreVO"%>
<%
 /**
 * @author Yoon-Soo Lee
 * @author Mi-Young Kim
 * @version 1.0
 */
byte[] sksByte = null;
String result = "fail";
boolean isMultipart = FileUpload.isMultipartContent(request);
try {
	if (isMultipart) {
		SecurityKeyStoreVO sksVO = new SecurityKeyStoreVO();
		DiskFileUpload upload = new DiskFileUpload();
		List items = null;
		items = upload.parseRequest(request);
		Iterator iter = items.iterator();
		while (iter.hasNext()) {
	Object ob = iter.next();
	FileItem item = (FileItem) ob;
	if (item != null) {
		if (!item.isFormField()) {
			if (item.getName() != null && item.getName().length() > 0) {
		try {
			InputStream uploadedStream = item.getInputStream();
			sksByte = null;
			int size2;
			byte[] buffer2 = new byte[4096];
			final ByteArrayOutputStream baos2 = new ByteArrayOutputStream();
			while ((size2 = uploadedStream.read(buffer2)) != -1) {
				baos2.write(buffer2, 0, size2);
			}
			sksByte = baos2.toByteArray();
			baos2.close();
			uploadedStream.close();
			sksVO.setKeystoreContent(sksByte);
		} catch (Exception e) {
			e.printStackTrace();
		}
			}
		} else {
			String name = item.getFieldName();
			String value = item.getString();
		if(name.equals("desc")) {
		sksVO.setDescription(value);
			} else if(name.equals("keystore_password")) {
		sksVO.setKeystorePassword(value);
			} else if(name.equals("keystore_type")) {
		sksVO.setKeystoreType(value);
			} else if(name.equals("keystore_name")) {
		sksVO.setName(value);
			} else if(name.equals("alias_name")) {
		sksVO.setPrivateKeyAlias(value);
			} else if(name.equals("alias_password")) {
		sksVO.setPrivateKeyPassword(value);
			}
		}
	}

		}
		MxsEngine engine = MxsEngine.getInstance();
		engine.storeSecurityKeystore("insert", sksVO);
		result = "success";
	}
} catch (Exception e) {
	e.printStackTrace();
}
%>
<html>
<head></head>
<body>
<script>
	location.href="sec20ms001.jsp?command=insert&result=<%=result%>";
</script>
</body>
</html>