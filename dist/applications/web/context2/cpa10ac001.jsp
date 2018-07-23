<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.CpaVO" %>
<%@ page import="kr.co.bizframe.mxs.ebms.CpaManager" %>
<%@ page import="kr.co.bizframe.mxs.ebms.EbException" %>
<%@ page import="kr.co.bizframe.mxs.MxsException" %>
<%@ page import="kr.co.bizframe.mxs.MxsConstants" %>
<%
/**
 * Insert CPA
 *
 * @author Mi-Young Kim
 * @author Jae-Heon Kim
 * @version 1.0
 */
   session = request.getSession(false);
   String command = request.getParameter("command");
   command = (command == null ? "insert" : command);
   String partyName = request.getParameter("party_name");
   String storageType = request.getParameter("storage_type");
   storageType = (storageType== null ? String.valueOf(MxsConstants.AGREEMENT_STORAGE_TYPE_FILE) : storageType);
   String keystoreObid = request.getParameter("keystore");
   String cpaName = request.getParameter("cpa_name");
   String cpaDescription = request.getParameter("cpa_description");
   CpaVO vo = (CpaVO) session.getAttribute("cpaVO");

   try {
      vo.setPartyName(partyName);
      vo.setKeyStoreObid(keystoreObid);
      vo.setCpaName(cpaName);
      vo.setDescription(cpaDescription);
      vo.setStorageType(Integer.parseInt(storageType));
      CpaManager cpaMgr = new CpaManager();
      cpaMgr.storeCpa(command, vo);
      cpaMgr.removeCacheCpa(vo.getCpa().getCpaId());

   } catch (EbException e) {
      e.printStackTrace();
      String i18nCode = "cpa10ac002.cpa.register.license.failed";
      int errorCode = e.getCode();
      if (errorCode == MxsException.MXS_LICENSE_LIMIT) {
    	  session.setAttribute("i18nCode", i18nCode);
      }
      throw e;
   }
%>
