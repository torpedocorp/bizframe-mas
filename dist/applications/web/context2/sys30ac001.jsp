<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.util.ServerProperties" %>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%@ page import="kr.co.bizframe.mxs.license.LicenseSecurity"%>
<%@ page import="kr.co.bizframe.persistence.db.BfPasswordCipher"%>

<%
	/**
	 * update properties
	 *
	 * @author Ho-Jin Seo
	 * @version 1.0
	 */

	ServerProperties props	= ServerProperties.getInstance();
	LicenseSecurity ls = new LicenseSecurity();

	props.setProperty("mxs.msi.authentication", StringUtil.nullCheck(request.getParameter("mxs.msi.authentication")));

	//props.setProperty("mxs.log.file.dir", StringUtil.nullCheck(request.getParameter("mxs.log.file.dir")));
	//props.setProperty("mxs.log.file.filename", StringUtil.nullCheck(request.getParameter("mxs.log.file.filename")));
	//props.setProperty("mxs.log.file.level", StringUtil.nullCheck(request.getParameter("mxs.log.file.level")));
	//props.setProperty("mxs.log.console.level", StringUtil.nullCheck(request.getParameter("mxs.log.console.level")));
	//props.setProperty("mxs.log.verbose", StringUtil.nullCheck(request.getParameter("mxs.log.verbose")));
	//props.setProperty("mxs.log.file.maxsize", StringUtil.nullCheck(request.getParameter("mxs.log.file.maxsize")));
	props.setProperty("mxs.http.connection.timeout", StringUtil.nullCheck(request.getParameter("mxs.http.connection.timeout")));
	props.setProperty("mxs.http.timeout", StringUtil.nullCheck(request.getParameter("mxs.http.timeout")));
	props.setProperty("mxs.server.ip", StringUtil.nullCheck(request.getParameter("mxs.server.ip")));
	props.setProperty("mxs.server.port", StringUtil.nullCheck(request.getParameter("mxs.server.port")));

	/** pop3 와 smtp 설정은 추후에... */
	/*
	props.setProperty("mxs.pop3.enabled", StringUtil.nullCheck(request.getParameter("mxs.pop3.enabled")));
	props.setProperty("mxs.pop3.host", StringUtil.nullCheck(request.getParameter("mxs.pop3.host")));
	props.setProperty("mxs.pop3.port", StringUtil.nullCheck(request.getParameter("mxs.pop3.port")));
	props.setProperty("mxs.pop3.foldername", StringUtil.nullCheck(request.getParameter("mxs.pop3.foldername")));
	props.setProperty("mxs.pop3.username", StringUtil.nullCheck(request.getParameter("mxs.pop3.username")));
	props.setProperty("mxs.pop3.password", StringUtil.nullCheck(request.getParameter("mxs.pop3.password")));
	props.setProperty("mxs.pop3.interval", StringUtil.nullCheck(request.getParameter("mxs.pop3.interval")));
	props.setProperty("mxs.smtp.host", StringUtil.nullCheck(request.getParameter("mxs.smtp.host")));
	props.setProperty("mxs.smtp.username", StringUtil.nullCheck(request.getParameter("mxs.smtp.username")));
	props.setProperty("mxs.smtp.password", StringUtil.nullCheck(request.getParameter("mxs.smtp.password")));
	*/
	//props.setProperty("mxs.keystore.type", StringUtil.nullCheck(request.getParameter("mxs.keystore.type")));
	//props.setProperty("mxs.keystore.file", StringUtil.nullCheck(request.getParameter("mxs.keystore.file")));
	//props.setProperty("mxs.keystore.passwd", StringUtil.nullCheck(request.getParameter("mxs.keystore.passwd")));
	//props.setProperty("mxs.sign.privatekey.alias", StringUtil.nullCheck(request.getParameter("mxs.sign.privatekey.alias")));
	//props.setProperty("mxs.sign.privatekey.passwd", StringUtil.nullCheck(request.getParameter("mxs.sign.privatekey.passwd")));
	//props.setProperty("mxs.monitor.enabled", StringUtil.nullCheck(request.getParameter("mxs.monitor.enabled")));
	//props.setProperty("mxs.monitor.ip", StringUtil.nullCheck(request.getParameter("mxs.monitor.ip")));
	//props.setProperty("mxs.monitor.port", StringUtil.nullCheck(request.getParameter("mxs.monitor.port")));
	//props.setProperty("mxs.page.count", StringUtil.nullCheck(request.getParameter("mxs.page.count")));
	//props.setProperty("mxs.page.item.count", StringUtil.nullCheck(request.getParameter("mxs.page.item.count")));

	props.setProperty("mxs.file.storage", StringUtil.nullCheck(request.getParameter("mxs.file.storage")));
	props.setProperty("mxs.files.per.directory", StringUtil.nullCheck(request.getParameter("mxs.files.per.directory")));

	props.setProperty("mxs.message.order.save.limit", StringUtil.nullCheck(request.getParameter("mxs.message.order.save.limit")));
	props.setProperty("mxs.eb.signature.executor", StringUtil.nullCheck(request.getParameter("mxs.eb.signature.executor")));
	props.setProperty("mxs.ws.signature.executor", StringUtil.nullCheck(request.getParameter("mxs.ws.signature.executor")));
	props.setProperty("mxs.ws.hash.function", StringUtil.nullCheck(request.getParameter("mxs.ws.hash.function")));
	props.setProperty("mxs.ws.signature.algorithm", StringUtil.nullCheck(request.getParameter("mxs.ws.signature.algorithm")));

	/** set SSL */
	String keystore = StringUtil.nullCheck(request.getParameter("mxs.ssl.keystore"));
	String keystorePassword = StringUtil.nullCheck(request.getParameter("mxs.ssl.keystore.password"));
	String keystoreType = StringUtil.nullCheck(request.getParameter("mxs.ssl.keystore.type"));

	String truststore = StringUtil.nullCheck(request.getParameter("mxs.ssl.truststore"));
	String truststorePassword = StringUtil.nullCheck(request.getParameter("mxs.ssl.truststore.password"));
	String truststoreType = StringUtil.nullCheck(request.getParameter("mxs.ssl.truststore.type"));

	props.setProperty("mxs.ssl.keystore", keystore);
	if (!keystorePassword.equals("")) {
		//props.setProperty("mxs.ssl.keystore.password", keystorePassword);
		String enc_key = new String(ls.encryptByte(keystorePassword.getBytes()));
		enc_key = enc_key.replaceAll("\r", "").replaceAll("\n", "");
			props.setProperty("mxs.ssl.keystore.password", enc_key);
	}
	props.setProperty("mxs.ssl.keystore.type", keystoreType);
	props.setProperty("mxs.ssl.truststore", truststore);
	if (!truststorePassword.equals("")) {
		//props.setProperty("mxs.ssl.truststore.password", truststorePassword);
		String enc_key = new String(ls.encryptByte(truststorePassword.getBytes()));
		enc_key = enc_key.replaceAll("\r", "").replaceAll("\n", "");
			props.setProperty("mxs.ssl.truststore.password", enc_key);
	}
	props.setProperty("mxs.ssl.truststore.type", truststoreType);

	// password must not be empty
	if (!keystorePassword.equals("") && !truststorePassword.equals("")) {
		System.setProperty("javax.net.ssl.keyStore", keystore);
		System.setProperty("javax.net.ssl.keyStorePassword", keystorePassword);
		System.setProperty("javax.net.ssl.keyStoreType", keystoreType);
		System.setProperty("javax.net.ssl.trustStore", truststore);
		System.setProperty("javax.net.ssl.trustStorePassword", truststorePassword);
		System.setProperty("javax.net.ssl.trustStoreType", truststoreType);
	}

	/** set license server */
	//props.setProperty("mxs.license.keystore", StringUtil.nullCheck(request.getParameter("mxs.license.keystore")));
	//props.setProperty("mxs.license.cert", StringUtil.nullCheck(request.getParameter("mxs.license.cert")));
	props.setProperty("mxs.license.server.url", StringUtil.nullCheck(request.getParameter("mxs.license.server.url")));

	/** set plugin */
	props.setProperty("mxs.ebmsg.preprocessor", StringUtil.nullCheck(request.getParameter("mxs.ebmsg.preprocessor")));
	props.setProperty("mxs.ebmsg.postprocessor", StringUtil.nullCheck(request.getParameter("mxs.ebmsg.postprocessor")));
	props.setProperty("mxs.wsmsg.preprocessor", StringUtil.nullCheck(request.getParameter("mxs.wsmsg.preprocessor")));
	props.setProperty("mxs.wsmsg.postprocessor", StringUtil.nullCheck(request.getParameter("mxs.wsmsg.postprocessor")));

	props.setProperty("etax.cert.path", StringUtil.nullCheck(request.getParameter("etax.cert.path")));
	props.setProperty("etax.key.path", StringUtil.nullCheck(request.getParameter("etax.key.path")));
	String passwd = StringUtil.nullCheck(request.getParameter("etax.key.passwd"));
	String cipher = StringUtil.nullCheck(request.getParameter("etax.key.passwd.cipher"));
	if(!"".equals(passwd)) {
		if("true".equals(cipher)) {
			BfPasswordCipher encoder = new BfPasswordCipher();
			passwd = encoder.encode(passwd);
		}
		props.setProperty("etax.key.passwd", passwd);
	}
	props.setProperty("etax.key.passwd.cipher", cipher);
	props.setProperty("etax.ntscert.path", StringUtil.nullCheck(request.getParameter("etax.ntscert.path")));
	props.setProperty("etax.hsjpki.provider", StringUtil.nullCheck(request.getParameter("etax.hsjpki.provider")));

	props.saveProperties();
%>

