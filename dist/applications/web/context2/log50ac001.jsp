<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.io.FileInputStream"%>
<%@ page import="java.io.ByteArrayInputStream"%>
<%@ page import="java.io.BufferedInputStream"%>
<%@ page import="java.io.BufferedOutputStream"%>
<%@ page import="java.io.File"%>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%@ page import="java.net.URL"%>
<%@ page import="java.net.URLConnection"%>
<%@ page import="org.apache.log4j.Appender"%>
<%@ page import="kr.co.bizframe.logging.CommonsLoggerAccessor"%>
<%@ page import="kr.co.bizframe.logging.Log4JAppenderAccessor"%>
<%@ page import="kr.co.bizframe.logging.Log4JLoggerAccessor"%>
<%@ page import="kr.co.bizframe.logging.Log4JManagerAccessor"%>
<%@ page import="kr.co.bizframe.logging.LoggerManager"%>
<%@ page import="kr.co.bizframe.logging.TailingFile"%>
<%@ page import="kr.co.bizframe.logging.BackwardsFileStream"%>
<%@ page import="kr.co.bizframe.logging.BackwardsLineReader"%>
<%
/**
 * Download log file
 *
 * @author Ho-Jin Seo
 * @version 1.0
 */
	String id = StringUtil.checkNull(request.getParameter("id"));

	if (id.length() == 0) {
		return;	
	}
	LoggerManager mgr = LoggerManager.getInstance();
	Log4JAppenderAccessor lacc = (Log4JAppenderAccessor)mgr.getLogAccessor(id);
	File file = lacc.getFile();
	BufferedInputStream bis = new BufferedInputStream(new FileInputStream(file));

	String header_str = "attachment; filename="+file.getName();
	response.setHeader("Content-Transfer-Encoding", "binary;");
	response.setContentType("application/octet-stream");
	response.setHeader("Content-Disposition", header_str);

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
		if(bis != null) bis.close();
	}
%>
