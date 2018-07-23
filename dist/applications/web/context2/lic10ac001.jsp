<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.sql.Date"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.mxs.dto.LicenseVO"%>
<%@ page import="kr.co.bizframe.util.UUIDFactory"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.license.LicenseManager"%>
<%
	 /**
	 * Generate daughter license
	 *
	 * @author Yoon-Soo Lee
	 * @author Ho-Jin Seo
	 * @version 1.0
	 */
	String result = "";
	byte[] license = null;

	String command = request.getParameter("command");

	if (command == null) {
		LicenseVO lvo = new LicenseVO();
		MxsEngine engine = MxsEngine.getInstance();
		lvo.setCustomerId(request.getParameter("customerId"));
		lvo.setCustomerName(request.getParameter("customerName"));
		//lvo.setDaughterId("");
		lvo.setDescription(request.getParameter("description"));

		lvo.setStart(new Timestamp(Date.valueOf(request.getParameter("start")).getTime()));
		lvo.setEnd(new Timestamp(Date.valueOf(request.getParameter("end")).getTime()));
		lvo.setHostName(request.getParameter("hostName"));
		ArrayList ip = new ArrayList();
		String ips[] = request.getParameterValues("ipAddr");
		for(int i = 0; i < ips.length; i++) {
			ip.add(ips[i]);
		}
		lvo.setIpAddress(ip);
		lvo.setLang(request.getParameter("lang"));
		lvo.setLicenseNumber(request.getParameter("licenseNumber"));
		String macs[] = request.getParameterValues("macAddr");
		ArrayList mac = new ArrayList();
		for(int i = 0; i < macs.length; i++) {
			mac.add(macs[i]);
		}
		lvo.setMacAddress(mac);
		String module = request.getParameter("module");
		lvo.setModule(Integer.parseInt(module));
		String msi = request.getParameter("msi");
		lvo.setMsi(Integer.parseInt(msi));
		lvo.setNumConcurrentTx(Integer.parseInt(request.getParameter("numConcurrentTx")));
		lvo.setNumCPU(Integer.parseInt(request.getParameter("numCpu")));
		//lvo.setNumDaughters(Integer.parseInt(request.getParameter("numDaughters")));
		lvo.setNumPartyId(Integer.parseInt(request.getParameter("numPartyId")));
		lvo.setNumPortAddress(Integer.parseInt(request.getParameter("numPortAddress")));
		//lvo.setProductName(request.getParameter("productName"));
		lvo.setSerialNumber(request.getParameter("serialNumber"));
		//lvo.setIsExpired(1);

        long start = lvo.getStart().getTime();
		long end = lvo.getEnd().getTime();
		long current = System.currentTimeMillis();

		if (start <= current && end >= current)
            lvo.setIsExpired(0);
        else
            lvo.setIsExpired(1);

	    QueryCondition qc = new QueryCondition();
		qc.add("license_number", request.getParameter("motherLicenseNumber"));

	    LicenseVO mother_lic = (LicenseVO)engine.getObject("ClientLicense", qc, DAOFactory.COMMON);

		lvo.setMotherLicenseObid(mother_lic.getObid());

		//engine.storeLicense("insert", lvo);

		LicenseManager.getInstance().addDaughterLicense(lvo);

	} else if (command != null) {
		// TODO : generate License Number, Customer ID and Serial Number
		result = UUIDFactory.getInstance().newUUID().toString();
	}
%>
<%= result%>