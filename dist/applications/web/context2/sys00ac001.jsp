<%@ page contentType="text/html; charset=EUC-KR" language="java" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Properties" %>
<%@ page import="javax.mail.Message" %>
<%@ page import="javax.mail.Session" %>
<%@ page import="javax.mail.Transport" %>
<%@ page import="javax.mail.internet.InternetAddress" %>
<%@ page import="javax.mail.internet.MimeMessage" %>
<%@ page import="kr.co.bizframe.mxs.web.ErrorReport" %>
<%@ page import="kr.co.bizframe.mxs.web.I18nStrings" %>
<%@ page import="kr.co.bizframe.util.ServerProperties" %>
<html>
<head>
<%@ include file="./com00in000.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>
</head>
<%
/**
 * @author Seong-Uk Eom
 * @author Jae-Heon Kim
 * @version 1.0
 */

String command = request.getParameter("command");
ErrorReport er = (ErrorReport)session.getAttribute("_errorReport");

String res;
String errorString = makeErrorReport(er, _i18n);
ServerProperties sp = ServerProperties.getInstance();

if (command.equals("ok")) {
	res = _i18n.get("sys00ac001.result.ok");
	send(
		sp.getProperty("error.report.smtp"),
		sp.getProperty("error.report.from"),
		sp.getProperty("error.report.to"),
		_i18n.get("sys00ac001.subject"), errorString);
} else {
	res = _i18n.get("sys00ac001.result.cancel");
}

%>
<body bgcolor=#FFFFFF leftmargin=0 topmargin=0 marginwidth=0 marginheight=0>
<table width="1003" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td align="center" valign="top" style="padding-top:10" class="gray-text">
<%=res%>
		</td>
	</tr>
</table>
</body>
</html>

<%!

public static void send(String smtpServer, String from, String to,
		String subject, String body) {
	try {
		Properties props = System.getProperties();

		props.put("mail.smtp.host", smtpServer);
		Session sess = Session.getDefaultInstance(props, null);

		MimeMessage msg = new MimeMessage(sess);

		msg.setFrom(new InternetAddress(from));
		msg.setRecipients(Message.RecipientType.TO,
				InternetAddress.parse(to, false));

		msg.setSubject(subject, "EUC-KR");
		//msg.setText(body);
		msg.setContent(body, "text/html;charset=EUC-KR");

		msg.setHeader("X-Mailer", "MXSMailer");
		msg.setSentDate(new Date());

		Transport.send(msg);
	} catch (Exception ex) {
		ex.printStackTrace();
	}
}

public String makeErrorReport(ErrorReport er, I18nStrings i18n) {

	StringBuffer buffer = new StringBuffer();
	buffer.append("<link href=\"" + i18n.get("sys00ac001.css.location") + "\" rel=stylesheet type=text/css />");

	buffer.append("<table width=980 border=0 cellspacing=0 cellpadding=0>");
	buffer.append("<tr>");
	buffer.append("<td align=left valign=top bgcolor=#d6d6d6>");

	buffer.append("<table width=100% border=0 cellspacing=1 cellpadding=2>");
	buffer.append("<tr align=center valign=middle bgcolor=#eff4fb class=gray_bold>");
	buffer.append("<td width=200 height=20 bgcolor=#eff4fb>" + i18n.get("sys00ac001.colhead.1") + "</td>");
	buffer.append("<td width=440 height=20 bgcolor=#eff4fb>" + i18n.get("sys00ac001.colhead.2") + "</td>");
	buffer.append("<td width=340 height=20 bgcolor=#eff4fb>" + i18n.get("sys00ac001.colhead.3") + "</td>");
	buffer.append("</tr>");

	buffer.append("<tr align=left valign=middle bgcolor=#FFFFFF class=gray-text>");
	buffer.append("<td height=18 bgcolor=#FFFFFF>forward.request_uri</td>");
	buffer.append("<td height=18 bgcolor=#FFFFFF>" + er.getForwardRequestUri() + "</td>");
	buffer.append("<td height=18 bgcolor=#FFFFFF>" + er.getForwardRequestUri().getClass().getName() + "</td>");
	buffer.append("</tr>");

	buffer.append("<tr align=left valign=middle bgcolor=#FFFFFF class=gray-text>");
	buffer.append("<td height=18 bgcolor=#FFFFFF>forward.context_path</td>");
	buffer.append("<td height=18 bgcolor=#FFFFFF>" + er.getForwardContextPath() + "</td>");
	buffer.append("<td height=18 bgcolor=#FFFFFF>" + er.getForwardContextPath().getClass().getName() + "</td>");
	buffer.append("</tr>");

	buffer.append("<tr align=left valign=middle bgcolor=#FFFFFF class=gray-text>");
	buffer.append("<td height=18 bgcolor=#FFFFFF>forward.servlet_path</td>");
	buffer.append("<td height=18 bgcolor=#FFFFFF>" + er.getForwardServletPath() + "</td>");
	buffer.append("<td height=18 bgcolor=#FFFFFF>" + er.getForwardServletPath().getClass().getName() + "</td>");
	buffer.append("</tr>");

	buffer.append("<tr align=left valign=middle bgcolor=#FFFFFF class=gray-text>");
	buffer.append("<td height=18 bgcolor=#FFFFFF>forward.path_info</td>");
	buffer.append("<td height=18 bgcolor=#FFFFFF>" + er.getForwardPathInfo() + "</td>");
	buffer.append("<td height=18 bgcolor=#FFFFFF>" + er.getForwardPathInfo().getClass().getName() + "</td>");
	buffer.append("</tr>");

	buffer.append("<tr align=left valign=middle bgcolor=#FFFFFF class=gray-text>");
	buffer.append("<td height=18 bgcolor=#FFFFFF>error.servlet_name</td>");
	buffer.append("<td height=18 bgcolor=#FFFFFF>" + er.getErrorServletName() + "</td>");
	buffer.append("<td height=18 bgcolor=#FFFFFF>" + er.getErrorServletName().getClass().getName() + "</td>");
	buffer.append("</tr>");

	buffer.append("<tr align=left valign=middle bgcolor=#FFFFFF class=gray-text>");
	buffer.append("<td height=18 bgcolor=#FFFFFF>error.message</td>");
	buffer.append("<td height=18 bgcolor=#FFFFFF><pre>" + er.getErrorMessage() + "</pre></td>");
	buffer.append("<td height=18 bgcolor=#FFFFFF>" + er.getErrorMessage().getClass().getName() + "</td>");
	buffer.append("</tr>");

	buffer.append("<tr align=left valign=middle bgcolor=#FFFFFF class=gray-text>");
	buffer.append("<td height=18 bgcolor=#FFFFFF>error.exception</td>");
	buffer.append("<td height=18 bgcolor=#FFFFFF>" + er.getErrorException() + "</td>");
	buffer.append("<td height=18 bgcolor=#FFFFFF>" + er.getErrorException().getClass().getName() + "</td>");
	buffer.append("</tr>");

	buffer.append("<tr align=left valign=middle bgcolor=#FFFFFF class=gray-text>");
	buffer.append("<td height=18 bgcolor=#FFFFFF>error.exception_type</td>");
	buffer.append("<td height=18 bgcolor=#FFFFFF>" + er.getErrorExceptionType() + "</td>");
	buffer.append("<td height=18 bgcolor=#FFFFFF>" + er.getErrorExceptionType().getClass().getName() + "</td>");
	buffer.append("</tr>");

	buffer.append("<tr align=left valign=middle bgcolor=#FFFFFF class=gray-text>");
	buffer.append("<td height=18 bgcolor=#FFFFFF>error.request_uri</td>");
	buffer.append("<td height=18 bgcolor=#FFFFFF>" + er.getErrorRequestUri() + "</td>");
	buffer.append("<td height=18 bgcolor=#FFFFFF>" + er.getErrorRequestUri().getClass().getName() + "</td>");
	buffer.append("</tr>");

	buffer.append("<tr align=left valign=middle bgcolor=#FFFFFF class=gray-text>");
	buffer.append("<td height=18 bgcolor=#FFFFFF>error.status_code</td>");
	buffer.append("<td height=18 bgcolor=#FFFFFF>" + er.getErrorStatusCode() + "</td>");
	buffer.append("<td height=18 bgcolor=#FFFFFF>" + er.getErrorStatusCode().getClass().getName() + "</td>");
	buffer.append("</tr>");

	buffer.append("<tr align=left valign=middle bgcolor=#FFFFFF class=gray-text>");
	buffer.append("<td height=18 bgcolor=#FFFFFF>jsp_classpath</td>");
	buffer.append("<td width=440 class=td_wrap height=18 bgcolor=#FFFFFF>" + er.getJspClasspath() + "</td>");
	buffer.append("<td height=18 bgcolor=#FFFFFF wrap>" + er.getJspClasspath().getClass().getName() + "</td>");
	buffer.append("</tr>");

	buffer.append("<tr align=left valign=middle bgcolor=#FFFFFF class=gray-text>");
	buffer.append("<td height=18 bgcolor=#FFFFFF>Stack Trace</td>");
	buffer.append("<td width=440 class=td_wrap height=18 bgcolor=#FFFFFF>" + er.getStackTrace() + "</td>");
	buffer.append("<td height=18 bgcolor=#FFFFFF wrap>" + er.getStackTrace().getClass().getName() + "</td>");
	buffer.append("</tr>");

	buffer.append("</table>");
	buffer.append("</td></tr></table>");

	return buffer.toString();
}


%>
