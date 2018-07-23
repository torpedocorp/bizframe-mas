<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Date"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.dto.LicenseVO"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.MxsConstants" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%
 /**
 * get list of Client License
 *
 * @author Yoon-Soo Lee
 * @author Ho-Jin Seo
 * @version 1.0
 */
    MxsEngine engine = MxsEngine.getInstance();
    ArrayList array = new ArrayList();
    QueryCondition qc = new QueryCondition();
    //qc.add("mother_license_obid", "");
    array = engine.getObjects("ClientLicense", qc, DAOFactory.COMMON);
    int size = array.size();

	int totalRows = size;//MxsEngine.getInstance().getMessageNum(fromDate, toDate, strOperation, strWsdlName, strStatus, strMsgId, strType);

	JSONObject json = new JSONObject();

	JSONArray licenses = new JSONArray();
	json.put("licenses", licenses);
	json.put("totalRows", totalRows);

	for (int i=0; i< size; i++) {
		LicenseVO licenseVO = (LicenseVO) array.get(i);
		if (licenseVO.getMotherLicenseObid() != null && !licenseVO.getMotherLicenseObid().equals(""))
	continue;
		String obid = licenseVO.getObid();
		Date start = new Date(licenseVO.getStart().getTime());
		Date end = new Date(licenseVO.getEnd().getTime());
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

		JSONObject license = new JSONObject();

		license.put("obid", licenseVO.getObid());
		license.put("productname", licenseVO.getProductName());
		license.put("customername", licenseVO.getCustomerName());
		license.put("licensenumber", licenseVO.getLicenseNumber());
		license.put("start", sdf.format(start));
		license.put("end", sdf.format(end));
		license.put("status", MxsConstants.getIsExpiredString(licenseVO.getIsExpired()));

		licenses.put(license);
	}
	out.print(json);
%>
