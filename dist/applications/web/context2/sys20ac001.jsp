<%@ page contentType="text/html; charset=EUC-KR" language="java" %>
<%@ page import="kr.co.bizframe.util.PropertiesEx"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>

<%
	/**
	 * mxs.properties 정보 추출
	 * (Etax Client에서 사용하기 위해 추가)
	 * 
	 * @version 1.0, 2009.04.21
	 * @author Hakju Oh
	 */
	String path = session.getServletContext().getRealPath(
		"/WEB-INF/classes/mxs.properties");

	PropertiesEx props = new PropertiesEx();
	props.load(path);
	
	JSONObject json = new JSONObject();
	
	json.put("msiAuthentication", props.getProperty("mxs.msi.authentication", "false"));

	json.put("httpConnectionTimeout", props.getProperty("mxs.http.connection.timeout", ""));
	json.put("httpTimeout", props.getProperty("mxs.http.timeout", ""));

	json.put("messageOrderSaveLimit", props.getProperty("mxs.message.order.save.limit", ""));
	
	json.put("fileStorage", props.getProperty("mxs.file.storage", ""));
	json.put("filesPerDirectory", props.getProperty("mxs.files.per.directory", ""));

	json.put("ebSignatureExecutor", props.getProperty("mxs.eb.signature.executor", ""));
	json.put("wsSignatureExecutor", props.getProperty("mxs.ws.signature.executor", ""));
	json.put("wsHashFunction", props.getProperty("mxs.ws.hash.function", ""));
	json.put("wsSignatureAlgorithm", props.getProperty("mxs.ws.signature.algorithm", ""));

	json.put("sslKeystore", props.getProperty("mxs.ssl.keystore", ""));
	json.put("sslKeystoreType", props.getProperty("mxs.ssl.keystore.type", ""));
	json.put("sslTruststore", props.getProperty("mxs.ssl.truststore", ""));
	json.put("sslTruststoreType", props.getProperty("mxs.ssl.truststore.type", ""));

	json.put("ebmsgPreprocessor", props.getProperty("mxs.ebmsg.preprocessor", ""));
	json.put("ebmsgPostprocessor", props.getProperty("mxs.ebmsg.postprocessor", ""));
	json.put("wsmsgPreprocessor", props.getProperty("mxs.wsmsg.preprocessor", ""));
	json.put("wsmsgPostprocessor", props.getProperty("mxs.wsmsg.postprocessor", ""));
	
	json.put("etaxCertPath", props.getProperty("etax.cert.path", ""));
	json.put("etaxKeyPath", props.getProperty("etax.key.path", ""));
	//json.put("etaxKeyPasswd", props.getProperty("etax.key.passwd", ""));
	json.put("etaxKeyPasswdCipher", props.getProperty("etax.key.passwd.cipher", "false"));
	json.put("etaxNtsCertPath", props.getProperty("etax.ntscert.path", ""));
	json.put("etaxHsjpkiProvider", props.getProperty("etax.hsjpki.provider", ""));

	out.print(json);
%>