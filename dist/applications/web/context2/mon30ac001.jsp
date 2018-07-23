<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.util.PropertiesEx" %>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%@ page import="java.util.Properties"%>
<%@ page import="java.io.File"%>
<%@ page import="java.io.FileWriter"%>
<%@ page import="java.io.IOException"%>
<%@ page import="java.io.OutputStreamWriter"%>
<%@ page import="java.io.BufferedWriter"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Enumeration"%>
<%
	/**
	 * update monitor.properties
	 *
	 * @author Ho-Jin Seo
	 * @version 1.0
	 */
	String[] monitor_arr = request.getParameterValues("stype");
	String wait_status = StringUtil.nullCheck(request.getParameter("wait_status"));
	String process_status = StringUtil.nullCheck(request.getParameter("process_status"));
	String error_status = StringUtil.nullCheck(request.getParameter("error_status"));
	String refreshTime = request.getParameter("refreshTime");
	String gridY = request.getParameter("gridY");
	
	if (monitor_arr == null)
		return;
	
	String path = session.getServletContext().getRealPath("/WEB-INF/monitor.properties");
	
	//Properties props = new Properties();
	
    FileWriter fout = new FileWriter(new File( path ));
    BufferedWriter buff_out = new BufferedWriter(fout);
    	
	buff_out.write("msg.monitor.cnt=" + monitor_arr.length);
	buff_out.newLine();
	for(int i=0; i<monitor_arr.length; i++) {
		buff_out.write("msg.monitor." + i + "=" + StringUtil.nullCheck(monitor_arr[i]));
		buff_out.newLine();
		//props.setProperty("msg.monitor." + i, StringUtil.nullCheck(monitor_arr[i]));
	}
	
	buff_out.write("monitor.refresh=" + StringUtil.nullCheck(refreshTime));
	buff_out.newLine();
	buff_out.write("monitor.gridY=" + StringUtil.nullCheck(gridY));
	buff_out.newLine();
	//props.setProperty("monitor.refresh", StringUtil.nullCheck(refreshTime));
	//props.setProperty("monitor.cntY", StringUtil.nullCheck(gridY));
	
	buff_out.flush();
	fout.flush();	
%>

