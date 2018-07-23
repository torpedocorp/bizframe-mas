<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.io.InputStream"%>
<%@ page import="java.io.ByteArrayOutputStream"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="org.apache.commons.fileupload.DiskFileUpload"%>
<%@ page import="org.apache.commons.fileupload.FileUpload"%>
<%@ page import="org.apache.commons.fileupload.FileItem"%>
<%@ page import="kr.co.bizframe.BizFrame"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.mxs.ebms.CpaManager"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.ebms.model.cpa.CPA"%>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.CpaVO"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>

<html>
<head>
<%@ include file="./com00in000.jsp"%>
<title><%=_i18n.get("global.page.title")%></title>
<%
/**
 * @author Mi-Young Kim
 * @author Jae-Heon Kim
 * @author Ho-Jin Seo
 * @version 1.0
 */

//============ get cpaInfo ================

byte[] cpaByte = null;
String cpaId = "";
String cpaObid = "";
String result = "";
String command = "error";
String actionUrl = "cpa20ms001.jsp";

boolean isMultipart = FileUpload.isMultipartContent(request);
if (isMultipart) {
   DiskFileUpload upload = new DiskFileUpload();
   List items = null;
   try {
      items = upload.parseRequest(request);

      Iterator iter = items.iterator();
      while (iter.hasNext()) {
         Object ob = iter.next();
         FileItem item = (FileItem) ob;
         if (item != null) {
            if (!item.isFormField()) {
               if (item.getName() != null && item.getName().length() > 0) {
                  try {
                     InputStream uploadedStream = item.getInputStream();
                     cpaByte = null;
                     int size2;
                     byte[] buffer2 = new byte[4096];
                     final ByteArrayOutputStream baos2 = new ByteArrayOutputStream();
                     while ((size2 = uploadedStream.read(buffer2)) != -1) {
                        baos2.write(buffer2, 0, size2);
                     }
                     cpaByte = baos2.toByteArray();
                     baos2.close();
                     uploadedStream.close();
                  } catch (Exception e) {
                     e.printStackTrace();
                  }
               }
            }
         }
      }
   } catch (Exception e) {
      cpaByte = null;
      result = _i18n.get("cpa10ac002.cpa.register.failed") + "  " + e.getMessage();
   }

} else {
   result = _i18n.get("cpa10ac002.cpa.register.failed2");
}


if (cpaByte != null) {
   CPA cpa = new CPA(cpaByte);
   cpaId = cpa.getCpaId();
   QueryCondition qc = new QueryCondition();
   qc.add("cpa_id", cpaId);
   qc.setQueryLargeData(false);

   CpaManager cpaMgr = new CpaManager();
   CpaVO cpaVO = (CpaVO)MxsEngine.getInstance().getObject("Cpa", qc, DAOFactory.EBMS);

   if (cpaVO != null ) {
      command = "update";
      session.setAttribute("cpa.command", command);
      cpaObid = cpaVO.getObid();
      actionUrl = "cpa20ms001.jsp";//?cpa.obid="+cpaVO.getObid();
      cpaVO.setModifiedBy(BizFrame.SYSTEM_USER_OBID);
      cpaVO.setCpa(cpa);

   } else {
	  // License Check Modified by Mi-Young. Kim on 2008.02.04
      if (!cpaMgr.isValidCpaLicense()) {
		result = "cpa10ac002.cpa.register.license.failed";
%>
		<script>
			location.href="cpa20ms001.jsp?command=error&msg=<%=result%>";
		</script>
<%
		return;
      }

      command = "insert";
      actionUrl = "cpa10ms001.jsp";
      cpaVO = new CpaVO();
      cpaVO.setCreatedBy(BizFrame.SYSTEM_USER_OBID);
      cpaVO.setCpa(cpa);
      cpaVO.setCpaId(cpaId);
   }

   session.setAttribute("cpaVO", cpaVO);
}


%>
</head>
<body>
<form name="frm" action="<%=actionUrl %>" method="post">
<input type="hidden" name="msg" value="<%=result %>">
<input type="hidden" name="command" value="<%=command %>">
<input type="hidden" name="cpa.obid" value="<%=cpaObid %>">
</form>
<script>
      document.frm.submit();
</script>
</body>
</html>
