<%@ page contentType="text/html; charset=EUC_KR"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.List"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.dto.LicenseVO"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.MxsConstants" %>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%@ page import="kr.co.bizframe.mxs.license.LicenseSecurity"%>
<%
 /**
 * detail view of Client License
 *
 * @author Yoon-Soo Lee
 * @version 1.0
 */
%>
<html>
<head>
<%@ include file="./com00in000.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>
<script type="text/javascript">
<!--
/* Commented out by J-.H. Kim on 2008.05.19
function download(obid, customerId){
	window.open("lic50ac801.jsp?obid=" + obid + "&customerId=" + customerId, "License", "width=100,height=100,left=5000,top=100,resizable=yes,scrollbars=yes");

}*/

function updateDaughterState(obid, state) {
   closeInfo();


   var params = "obid=" + obid + "&status=" + state;
   var opt = {
      method: 'post',
      asynchronous: false,
      parameters: params,
      onSuccess: function(t) {
	     var res = eval("(" + t.responseText + ")");
	     if (res.result.length > 0)
	    	 alert(res.result);
	     else
	    	 location.reload(true);
      },
       on404: function(t) {
           $('messageDisplay').innerHTML = '<%=_i18n.get("err00zz404.message") %>';
       },
       onFailure: function(t) {
           $('messageDisplay').innerHTML = '<%=_i18n.get("global.error.retry") %>';
           showErrorPopup(t.responseText, null, null, null);
       }
   }
   var myAjax = new Ajax.Request("lic30ac002.jsp", opt);

}

// -->
</script>
</head>
<%
	String obid = request.getParameter("obid");
	LicenseVO license_f = null;
	LicenseVO license = null;
	LicenseVO license_m = null;
    MxsEngine engine = MxsEngine.getInstance();
    String motherLicenseObid = "";
    try {
        QueryCondition qc = new QueryCondition();
        qc.add("obid", obid);
        license_f = (LicenseVO)engine.getObject("ClientLicense", qc, DAOFactory.COMMON);
        byte[] lic_b = license_f.getContent();

        LicenseSecurity ls = new LicenseSecurity();
        byte[] ret = ls.encryptByte(lic_b);

        license = engine.loadLicense(ret);

        motherLicenseObid = license_f.getMotherLicenseObid();
        if(motherLicenseObid != null && !"null".equals(motherLicenseObid) && motherLicenseObid.length() > 0  ) {
        	QueryCondition qc2 = new QueryCondition();
        	qc2.add("obid", motherLicenseObid);
        	license_m = (LicenseVO)engine.getObject("ClientLicense", qc2, DAOFactory.COMMON);
        }
    }
    catch (Exception e){
       e.printStackTrace();
    }
%>

<body>
<!-- 제목테이블 -->
<table class="TableLayout">
  <tr>
    <td width="180" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.license.details")%></td>
    <td width="580" class="MessageDisplay" ><div id=messageDisplay></div></td>
  </tr>
  <tr>
    <td colspan="2" height="10"></td>
  </tr>
</table>
<!-- 등록테이블-->
<table class="FieldTable">
  <col width="140">
  <col width="240">
  <col width="140">
  <col width="240">
  <tr>
    <td class="FieldLabel"><%=_i18n.get("license.product.name")%></td>
    <td colspan="3" class="FieldData">
    	<input type="text" name="productName" class="FormTextReadOnly" size="32" disabled value="<%=license.getProductName()%>">
    </td>
  </tr>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("license.module")%></td>
    <td colspan="3" class="FieldData">
    <%
      	String module = Integer.toBinaryString(license.getModule());
      	double r = 0;
      	String check = "";
      	ArrayList list = new ArrayList();
            for(int i = 0; i < module.length(); i++) {
                int m = module.length() - i - 1;
                int t = Integer.parseInt(module.substring(i, i+1));
                if(m == 0) {
                	r = 1.0;
                } else {
                	r = Math.pow(2, m);
                }
                Double d = new Double(r);
                int g = d.intValue();
                if(t == 1) {
                	list.add(new Integer(g));
                }
            }
    	double rr = 0;
            for(int i = 0; i < MxsConstants.getModuleSize(); i++) {
    	        if(i == 0) {
    	            rr = 1.0;
    	        } else {
    	            rr = Math.pow(2, i);
    	        }
    	        Double d = new Double(rr);
    	        int g = d.intValue();
    	        for (int it = 0; it < list.size(); it++) {
    	        	if(rr == ((Integer)list.get(it)).doubleValue()) {
    	        		check = "checked";
    	        		break;
    	        	}
    	        }
    %>
      <%=MxsConstants.getModuleString(g)%><input name="module" type="checkbox" disabled <%=check%> value="<%=g%>">
      <%
              check = "";
              }
      %>
    </td>
  </tr>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("license.msi.support")%></td>
    <td colspan="3" class="FieldData">
<%
  	String msi = Integer.toBinaryString(license.getMsi());
  	double r2 = 0;
  	String check2 = "";
  	ArrayList list2 = new ArrayList();
        for(int i = 0; i < msi.length(); i++) {
            int m = msi.length() - i - 1;
            int t = Integer.parseInt(msi.substring(i, i+1));
            if(m == 0) {
            	r2 = 1.0;
            } else {
            	r2 = Math.pow(2, m);
            }
            Double d = new Double(r2);
            int g = d.intValue();
            if(t == 1) {
            	list2.add(new Integer(g));
            }
        }
	double rr2 = 0;
        for(int i = 0; i < MxsConstants.getMSISize(); i++) {
	        if(i == 0) {
	            rr2 = 1.0;
	        } else {
	            rr2 = Math.pow(2, i);
	        }
	        Double d = new Double(rr2);
	        int g = d.intValue();
	        for (int it = 0; it < list2.size(); it++) {
	        	if(rr2 == ((Integer)list2.get(it)).doubleValue()) {
	        		check2 = "checked";
	        		break;
	        	}
	        }
%>
      <%=MxsConstants.getMSIString(g)%><input name="msi" type="checkbox" disabled <%=check2%> value="<%=g%>">
      <%
              check2 = "";
              }
      %>
    </td>
  </tr>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("license.customer.name")%></td>
    <td class="FieldData">
    	<input name="customer" type="text" disabled class="FormTextReadOnly" size="32" value="<%=license.getCustomerName()%>">
    </td>
    <td class="FieldLabel"><%=_i18n.get("license.customer.id")%></td>
    <td class="FieldData">
    	<input name="customerId" type="text" disabled class="FormTextReadOnly" size="32" value="<%=license.getCustomerId()%>">
    </td>
  </tr>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("license.license.number")%></td>
    <td class="FieldData">
    	<input name="licenseNum" type="text" disabled class="FormTextReadOnly" size="32" value="<%=license.getLicenseNumber()%>">
    </td>
    <td class="FieldLabel"><%=_i18n.get("license.serial.number")%></td>
    <td class="FieldData">
    	<input name="serialNum" type="text" disabled class="FormTextReadOnly" size="32" value="<%=license.getSerialNumber()%>">
    </td>
  </tr>
  <%
    	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    	String start = sdf.format(new Date(license.getStart().getTime()));
    	String end = sdf.format(new Date(license.getEnd().getTime()));
  %>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("license.valid.through")%></td>
    <td class="FieldData">
	<input name="f_date" id="f_date_Id" type="text" class="FormTextReadOnly" size="15" maxlength="10" value="<%=start%>" disabled >

	~
	<input name="t_date" id="t_date_Id" type="text" class="FormTextReadOnly" size="15" maxlength="10" value="<%=end%>" disabled >

    </td>
    <%
    String status = MxsConstants.getIsExpiredString(license.getIsExpired());
    %>
    <td class="FieldLabel"><%=_i18n.get("global.status")%></td>
    <td class="FieldData">
    	<input name="status" type="text" disabled class="FormTextReadOnly" size="15" value="<%=status%>">
    </td>
  </tr>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("global.description")%></td>
    <td colspan="3" class="FieldData">
    	<input type="text" name="description" disabled class="FormTextReadOnly" size="100" value="<%=StringUtil.nullCheck(license.getDescription())%>">
    </td>
  </tr>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("license.concurrent.processing.capability")%></td>
    <td class="FieldData">
    	<input name="cPNum" type="text" disabled class="FormTextReadOnly" size="15" value="<%=license.getNumConcurrentTx()%>">
    </td>
    <td class="FieldLabel"><%=_i18n.get("license.partner.num")%></td>
    <td class="FieldData">
    	<input name="pNum" type="text" disabled class="FormTextReadOnly" size="15" value="<%=license.getNumPartyId()%>">
      <span class="FieldDataHelpTex"> (<%=_i18n.get("global.zero.infinite")%>)</span>
    </td>
  </tr>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("license.portaddress.num")%></td>
    <td class="FieldData" colspan="3">
    	<input name="numPortAddress" type="text" disabled class="FormTextReadOnly" size="15" value="<%=license.getNumPortAddress()%>">
      <span class="FieldDataHelpTex"> (<%=_i18n.get("global.zero.infinite")%>)</span>
    </td>
  </tr>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("license.host.name")%></td>
    <td class="FieldData">
    	<input name="hostName" type="text" disabled class="FormTextReadOnly" size="15" value="<%=license.getHostName()%>">
    </td>
    <td class="FieldLabel"><%=_i18n.get("license.cpu.num")%></td>
    <td class="FieldData">
    	<input name="cpuNum" type="text" disabled class="FormTextReadOnly" size="15" value="<%=license.getNumCPU()%>">
    </td>
  </tr>
  <tr>
    <td valign="top" class="FieldLabel"><%=_i18n.get("license.ip.address")%></td>
    <td class="FieldData">
    <%
             List ips = license.getIpAddress();
             if (ips != null ) {
                for (Iterator k = ips.iterator(); k.hasNext();) {
    %>
    <input name="ipAddr" type="text" disabled class="FormTextReadOnly" size="32" value="<%=(String)k.next()%>">
    <%
             }
             }
    %>
    </td>
    <td valign="top" class="FieldLabel"><%=_i18n.get("license.mac.address")%></td>
    <td class="FieldData">
    <%
             List macs = license.getMacAddress();
             if (macs != null ) {
                for (Iterator k = macs.iterator(); k.hasNext();) {
    %>
    <input name="macAddr" type="text" disabled class="FormTextReadOnly" size="32" value="<%=(String)k.next()%>">
    <%
             }
             }
    %>
     </td>
  </tr>
  <%
  if(motherLicenseObid == null || "null".equals(motherLicenseObid) || motherLicenseObid.length() == 0  ) {
  %>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("license.mxs.partner.num")%></td>
    <td colspan="3" class="FieldData">
      <input type="text" name="mxsNum" disabled class="FormTextReadOnly" size="15" value="<%=license.getNumDaughters()%>">
      <span class="FieldDataHelpTex"> (<%=_i18n.get("global.zero.infinite")%>)</span>
    </td>
  </tr>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("license.daughter.license")%></td>
    <td colspan="3" class="FieldData">
    <table width="550" border="0" cellspacing="0" cellpadding="0">
        <col width="60">
        <col width="130">
        <col width="120">
        <col width="220">
        <col width="40">
        <%
                	String daughterState = "";
					QueryCondition qc3 = new QueryCondition();
					qc3.add("mother_license_obid", obid);
					ArrayList daughterLicenses = engine.getObjects("ClientLicense", qc3, DAOFactory.COMMON);

                	for(int i = 0; i < daughterLicenses.size(); i++) {
                		LicenseVO license_d = (LicenseVO) daughterLicenses.get(i);
                		int state = license_d.getIsExpired();
                		if (state == 1) {
                	daughterState = "<img src='images/btn_activate.gif' border='0'>";
                	state = 0;
                		} else {
                	daughterState = "<img src='images/btn_deactivate.gif' border='0'>";
                	state = 1;
                		}
        %>
        <tr>
          <td><%=_i18n.get("license.customer.name")%></td>
          <td >
          	<input name="cusName" type="text" class="FormTextReadOnly" disabled value="<%=license_d.getCustomerName()%>" size="15">
          </td>
          <td><%=_i18n.get("license.license.number")%></td>
          <td>
          	<input name="dlicenseNum" type="text" class="FormTextReadOnly" disabled value="<%=license_d.getLicenseNumber()%>" size="32">
          </td>
          <td><a href="lic21ms001.jsp?obid=<%=license_d.getObid()%>"><img src="images/btn_inview.gif" width="39" height="13" align="absmiddle" border="0"></a></td>
          <td><a href="javascript:updateDaughterState('<%=license_d.getObid()%>', <%=state%>)"><span id="daughter_state"><%=daughterState%></span></a></td>
        </tr>
        <%
        	}
        %>
        <!-- 연계라이선스 생성 -->
        <form name="generateDaughter" method="post" action="lic10ms001.jsp">
        <tr align="right">
          <td height="24" colspan="6">
          	<input type="image" src="images/btn_daughter.gif">
          	<input type="hidden" name="obid" value="<%=obid%>">
          </td>
        </tr>
        </form>
      </table></td>
  </tr>
  <%
  	} else {
  %>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("license.mother.license")%></td>
    <td colspan="3" class="FieldData"><table width="550" border="0" cellspacing="0" cellpadding="0">
	<col width="60">
	<col width="130">
	<col width="100">
	<col width="220">
	<col width="40">
        <tr>
          <td><%=_i18n.get("license.customer.name")%></td>
          <td>
          	<input name="oCLicense" type="text" disabled class="FormTextReadOnly" size="15" value="<%=license_m.getCustomerName()%>">
          </td>
          <td><%=_i18n.get("license.license.number")%></td>
          <td>
          	<input name="licenseNum" type="text" disabled class="FormTextReadOnly" size="32" value="<%=license_m.getLicenseNumber()%>">
          </td>
          <td><a href="lic21ms001.jsp?obid=<%=motherLicenseObid%>"><img src="images/btn_inview.gif" width="39" height="13" align="absmiddle" border="0"></a></td>
        </tr>
      </table></td>
  </tr>
  <%
  	}
  %>
</table>
<!-- 버튼테이블 -->
<form name="updater" method="post">
<table class="TableLayout" >
  <tr>
    <td align="right" style="padding-top:15">
    	<input type="hidden" name="obid" value="<%=obid%>">
    	<input type="hidden" name="customerId" value="<%=license.getCustomerId()%>">
    	<a href="lic20ms001.jsp"><img src="images/btn_big_list.gif" width="39" height="23" border="0"></a>
<%
	if (license_m != null) {
%>
      	<a href="lic50ac001.jsp?obid=<%=obid%>&customerId=<%=license.getCustomerId()%>"><img src="images/btn_big_out.gif" width="58" height="23" border="0"></a>
<%	} %>
      	<!--a href="lic20ac002.jsp"><img src="images/btn_big_validate.gif" width="70" height="23" border="0"></a-->
      	<!--a href="lic30ac001.jsp?obid=<%=obid%>"><img src="images/btn_big_renewal.gif" width="39" height="23" border="0"></a--></td>
  </tr>
</table>
</form>
</body>
</html>
