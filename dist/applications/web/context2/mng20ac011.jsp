<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="kr.co.bizframe.security.npki.x509.X509CertificateManager"%>
<%@ page import="kr.co.bizframe.util.ServerProperties" %>
<%@ page import="kr.co.bizframe.security.crypto.utils.ByteUtil" %>
<%
	/**
	 * 메시지 서명 인증서 정보 가져오기
	 *
	 * @version 1.0 2009.08.24
	 * @author Mi-Young Kim
	 */

	JSONObject info = new JSONObject();

	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	Date today = new Date(System.currentTimeMillis());

	ServerProperties sp = ServerProperties.getInstance();
	String certFilePath = sp.getProperty("etax.cert.path");
	X509CertificateManager xMgr = new X509CertificateManager(certFilePath);
	String serial = ByteUtil.toHexString(xMgr.getSerialNumber());
	String issuer = xMgr.getIssuer().toString();
	String start = sdf.format(xMgr.getNotBefore());
	Date endDate = xMgr.getNotAfter();
	String end = sdf.format(endDate);
	String subject = xMgr.getSubject().toString();

	// 만료 30일 전 체크
	Calendar cal = Calendar.getInstance();
	cal.setTime(endDate);
	cal.add(Calendar.DATE, -30);
	Date before30 = cal.getTime();

	// 30일 기한 내
	if (today.compareTo(before30) >= 0 && today.compareTo(endDate) <= 0 ){
		info.put("sign_status", "0");
	} else if (endDate.compareTo(today) < 0) {
		//만료
		info.put("sign_status", "1");
	} else {
		//정상
		info.put("sign_status", "2");
	}

	info.put("sign_start", start);
	info.put("sign_end", end);
	out.print(info);
%>
