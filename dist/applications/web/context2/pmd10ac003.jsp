<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.storage.MxsFileManager"%>
<%
/**
 * delete PMode payload schemaFile
 *
 * @author Mi-Young Kim
 * @version 1.0 2008.10.25
 */
%>
<html>
<head></head>
<body>
<table border=0 align=center>file deleting....</table>
<%
String num = request.getParameter("num");
String filepath = request.getParameter("payloadPschemaFilePath" + num);

if (filepath != null && filepath.length() > 0 ) {
	// delete
	MxsFileManager fm = MxsFileManager.getInstance();
	fm.delete(filepath);
}
%>
</body>
</html>

