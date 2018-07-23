<%@ page contentType="text/html; charset=EUC_KR"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.dto.LicenseVO"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.MxsConstants" %>
<%@ page import="kr.co.bizframe.mxs.license.LicenseSecurity"%>
<%@ page import="kr.co.bizframe.mxs.license.LicenseManager"%>
<%
 /**
 * Generate daughter license
 *
 * @author Yoon-Soo Lee
 * @author Ho-Jin Seo
 * @version 1.0
 */

	if (!LicenseManager.getInstance().canMakeDaughter()) {
		out.println("<script>");
		out.println("alert('Maximum number of client licenses exceeded more than "
				+ LicenseManager.getInstance().getLicenseVO().getNumDaughters() + "');");
		out.println("history.back();</script>");
		return;
	}
%>
<html>
<head>
<%@ include file="./com00in000.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>
<script type="text/javascript">
<!--

function addIpField() {
	ip_list = $('ips');
	ipcount = ip_list.childNodes.length;
	if(ipcount>=10){
		alert('<%=_i18n.get("lic10ms001.upload.limited")%>');
		return false;

	}
	list_item = document.createElement("div");
	list_item.innerHTML="<input name='ipAddr' type='text' class='FormText' size='32'> <span onclick='delIpField(this.parentNode)' style='cursor:pointer'> <%=_i18n.get("global.delete")%> </span>";
	ip_list.appendChild(list_item);
}

function addMacField() {
	ip_list = document.getElementById('macs');
	ipcount = ip_list.childNodes.length;
	if(ipcount>=10){
		alert('<%=_i18n.get("lic10ms001.upload.limited")%>');
		return false;

	}
	list_item = document.createElement("div");
	list_item.innerHTML="<input name='macAddr' type='text' class='FormText' size='32'> <span onclick='delMacField(this.parentNode)' style='cursor:pointer'> <%=_i18n.get("global.delete")%> </span>";

	ip_list.appendChild(list_item);
}

function delIpField(node){
	upload_list = document.getElementById('ips');
	uplicount = upload_list.childNodes.length;
	if(uplicount<=1) return false;
	upload_list.removeChild(node);
}

function delMacField(node){
	upload_list = document.getElementById('macs');
	uplicount = upload_list.childNodes.length;
	if(uplicount<=1) return false;
	upload_list.removeChild(node);
}

function generateCustomerId() {
   closeInfo();

   var params = "command=customer";
   var opt = {
      method: 'post',
      parameters: params,
      onSuccess: function(t) {
         $('customerId').value = t.responseText;
      },
       on404: function(t) {
           $('messageDisplay').innerHTML = '<%=_i18n.get("err00zz404.message") %>';
       },
       onFailure: function(t) {
           $('messageDisplay').innerHTML = '<%=_i18n.get("global.error.retry") %>';
           showErrorPopup(t.responseText, null, null, null);
       }
   }
   var myAjax = new Ajax.Request("lic10ac001.jsp", opt);
}
function generateLicenseNumber() {
   closeInfo();

   var params = "command=license";
   var opt = {
      method: 'post',
      parameters: params,
      onSuccess: function(t) {
         $('licenseNumber').value = t.responseText;
      },
       on404: function(t) {
           $('messageDisplay').innerHTML = '<%=_i18n.get("err00zz404.message") %>';
       },
       onFailure: function(t) {
           $('messageDisplay').innerHTML = '<%=_i18n.get("global.error.retry") %>';
           showErrorPopup(t.responseText, null, null, null);
       }
   }
   var myAjax = new Ajax.Request("lic10ac001.jsp", opt);
}

function generateSerialNumber() {
   closeInfo();

   var params = "command=serial";
   var opt = {
      method: 'post',
      parameters: params,
      onSuccess: function(t) {
         $('serialNumber').value = t.responseText;
      },
       on404: function(t) {
           $('messageDisplay').innerHTML = '<%=_i18n.get("err00zz404.message") %>';
       },
       onFailure: function(t) {
           $('messageDisplay').innerHTML = '<%=_i18n.get("global.error.retry") %>';
           showErrorPopup(t.responseText, null, null, null);
       }
   }
   var myAjax = new Ajax.Request("lic10ac001.jsp", opt);
}


function insertLicense() {
   closeInfo();

   var params = Form.serialize(document.register);
   var opt = {
      method: 'post',
      parameters: params,
      onSuccess: function(t) {
         location.href="lic20ms001.jsp";
      },
       on404: function(t) {
           $('messageDisplay').innerHTML = '<%=_i18n.get("err00zz404.message") %>';
       },
       onFailure: function(t) {
           //$('messageDisplay').innerHTML = '<%=_i18n.get("global.error.retry") %>';
           $('messageDisplay').innerHTML = '<%=_i18n.get("lic10ms001.license.insert.failed") %>';
           showErrorPopup(t.responseText, null, null, null);
       }
   }
   var myAjax = new Ajax.Request("lic10ac001.jsp", opt);
}

function init() {
	generateCustomerId();
	generateLicenseNumber();
	generateSerialNumber();
}

window.onload = init;

// -->
</script>
</head>
<%
	String obid = request.getParameter("obid");
	LicenseVO license_f = null;
	LicenseVO license = null;
    MxsEngine engine = MxsEngine.getInstance();
    try {
        QueryCondition qc = new QueryCondition();
        qc.add("obid", obid);
        license_f = (LicenseVO)engine.getObject("ClientLicense", qc, DAOFactory.COMMON);
        byte[] lic_b = license_f.getContent();

        LicenseSecurity ls = new LicenseSecurity();
        byte[] ret = ls.encryptByte(lic_b);

        license = engine.loadLicense(ret);
    }
    catch (Exception e){
       e.printStackTrace();
    }
%>

<body>
<!-- 제목테이블 -->
<table class="TableLayout">
  <tr>
    <td width="180" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.license.daughter.create")%></td>
    <td width="580" class="MessageDisplay" ><div id=messageDisplay></div></td>
  </tr>
  <tr>
    <td colspan="2" height="10"></td>
  </tr>
</table>
<!-- 등록테이블-->
<form name="register" method="post">
<table class="FieldTable">
  <col width="140">
  <col width="240">
  <col width="140">
  <col width="240">
  <tr>
    <td class="FieldLabel"><%=_i18n.get("license.product.name")%></td>
    <td colspan="3" class="FieldData">
    	<input type="text" name="productName" class="FormTextReadOnly" size="32" readonly value="<%=license.getProductName()%>">
    </td>
  </tr>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("license.module")%></td>
    <td colspan="3" class="FieldData">
    <input type="hidden" name="module" value="<%=license.getModule()%>">
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
      <%=MxsConstants.getModuleString(g)%><input name="module_display" type="checkbox" disabled <%=check%> value="<%=g%>">
      <%
      		check = "";
        }
      %>
    </td>
  </tr>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("license.msi.support")%></td>
    <td colspan="3" class="FieldData">
    <input type="hidden" name="msi" value="<%=license.getMsi()%>">
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
      <%=MxsConstants.getMSIString(g)%><input name="msi_display" type="checkbox" disabled <%=check2%> value="<%=g%>">
      <%
      		check2 = "";
        }
      %>
    </td>
  </tr>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("license.customer.name")%></td>
    <td class="FieldData">
    	<input name="customerName" type="text" class="FormText" size="32">
    </td>
    <td class="FieldLabel"><%=_i18n.get("license.customer.id")%></td>
    <td class="FieldData">
    	<input name="customerId" id="customerId" type="text" class="FormTextReadOnly" size="32" readonly>
    </td>
  </tr>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("license.license.number")%></td>
    <td class="FieldData">
    	<input name="licenseNumber" id="licenseNumber" type="text" class="FormTextReadOnly" size="32" readonly>
    </td>
    <td class="FieldLabel"><%=_i18n.get("license.serial.number")%></td>
    <td class="FieldData">
    	<input name="serialNumber" id="serialNumber" type="text" class="FormTextReadOnly" size="32" readonly>
    </td>
  </tr>
  <%
  	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
  	String start = sdf.format(new Date(license.getStart().getTime()));
  	String end = sdf.format(new Date(license.getEnd().getTime()));
  %>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("license.valid.through")%></td>
    <td class="FieldData" colspan="3">
	<input name="start" id="f_date_Id" type="text" readonly class="FormTextReadOnly" size="15" maxlength="10" value="<%=start%>">
	~
	<input name="end" id="t_date_Id" type="text" readonly class="FormTextReadOnly" size="15" maxlength="10" value="<%=end%>">

    </td>
    <%
    	String status = MxsConstants.getIsExpiredString(license.getIsExpired());
    %>
  </tr>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("global.description")%></td>
    <td colspan="3" class="FieldData">
    	<input type="text" name="description" class="FormText" size="100">
    </td>
  </tr>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("license.concurrent.processing.capability")%></td>
    <td class="FieldData">
    	<input name="numConcurrentTx" type="text" readonly class="FormTextReadOnly" size="15" value="<%=license.getNumConcurrentTx()%>">
    </td>
    <td class="FieldLabel"><%=_i18n.get("license.partner.num")%></td>
    <td class="FieldData">
    	<input name="numPartyId" type="text" readonly class="FormTextReadOnly" size="15" value="<%=license.getNumPartyId()%>">
      <span class="FieldDataHelpTex"> (<%=_i18n.get("global.zero.infinite")%>)</span>
    </td>
  </tr>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("license.portaddress.num")%></td>
    <td class="FieldData" colspan="3">
    	<input name="numPortAddress" type="text" readonly class="FormTextReadOnly" size="15" value="<%=license.getNumPortAddress()%>">
      <span class="FieldDataHelpTex"> (<%=_i18n.get("global.zero.infinite")%>)</span>
    </td>
  </tr>
  <tr>
    <td class="FieldLabel"><%=_i18n.get("license.host.name")%></td>
    <td class="FieldData">
    	<input name="hostName" type="text" class="FormText" size="15">
    </td>
    <td class="FieldLabel"><%=_i18n.get("license.cpu.num")%></td>
    <td class="FieldData">
    	<input name="numCpu" type="text" class="FormText" size="15">
    </td>
  </tr>
  <tr>
    <td valign="top" class="FieldLabel"><%=_i18n.get("license.ip.address")%></td>
    <td class="FieldData" id="ips">
	<input name="ipAddr" type="text" class="FormText" size="32">
      	<span onclick="addIpField()" style='cursor:pointer;font-weight:;font-size:12px;'><%=_i18n.get("global.add")%></span>
    </td>
    <td valign="top" class="FieldLabel"><%=_i18n.get("license.mac.address")%></td>
    <td class="FieldData" id="macs">
    	<input name="macAddr" type="text" class="FormText" size="32">
    	<span onclick="addMacField()" style='cursor:pointer;font-weight:;font-size:12px;'><%=_i18n.get("global.add")%></span>
    </td>
  </tr>
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
          	<input name="motherLicenseName" type="text" readonly class="FormTextReadOnly" size="15" value="<%=license.getCustomerName()%>">
          </td>
          <td><%=_i18n.get("license.license.number")%></td>
          <td>
          	<input name="motherLicenseNumber" type="text" readonly class="FormTextReadOnly" size="32" value="<%=license.getLicenseNumber()%>">
          </td>
        </tr>
      </table></td>
  </tr>
</table>
<!-- 버튼테이블 -->
<table class="TableLayout" >
  <tr>
    <td align="right" style="padding-top:15">
    	<a href="lic20ms001.jsp"><img src="images/btn_big_list.gif" width="39" height="23" border="0"></a>
      	<span onclick="insertLicense()" style='cursor:pointer'><img src="images/btn_big_plus.gif" width="39" height="23" border="0"></span>
  </tr>
</table>
</form>
</body>
</html>
