<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.CpaVO" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.ebms.CpaManager" %>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.MxsConstants" %>
<%@ page import="kr.co.bizframe.BizFrame"%>

<%
   /**
    * @author Gemini Kim
    * @author Mi-Young Kim
    * @version 1.0
    */
//============ Update CPA ... ================
   String cpa_id           = (String)request.getParameter("cpa_id");
   String cpa_name         = (String)request.getParameter("cpa_name");
   String cpa_description  = (String)request.getParameter("cpa_description");
   String cpa_party        = (String)request.getParameter("cpa_party");
   String keystore  = (String) request.getParameter("keystore");
   String cpaObid = (String) request.getParameter("cpa.obid");
   String command = (String) request.getParameter("command");
   String storageType = request.getParameter("storage_type");
   storageType = (storageType== null ? String.valueOf(MxsConstants.AGREEMENT_STORAGE_TYPE_FILE) : storageType);
   int st = Integer.parseInt(storageType);

   //try	{
      QueryCondition qc = new QueryCondition();
      qc.add("cpa_id", cpa_id);
      qc.setQueryLargeData(true);
      CpaVO cpaVO = (CpaVO)MxsEngine.getInstance().getObject("Cpa", qc, DAOFactory.EBMS);
      if (st != cpaVO.getStorageType()) {
    	  cpaVO.setStorageType(Integer.parseInt(storageType));
    	  cpaVO.putExtension("stUpdate", "1");

		} else {
			cpaVO.putExtension("stUpdate", "0");
		}

	  cpaVO.setModifiedBy(BizFrame.SYSTEM_USER_OBID);
      cpaVO.setCpaName(cpa_name);
      cpaVO.setPartyName(cpa_party);
      cpaVO.setDescription(cpa_description);
      cpaVO.setKeyStoreObid(keystore);

      CpaManager cpaMgr = new CpaManager();
      if(command.equalsIgnoreCase("updateInfo")) {
    	  // update only cpa
          QueryCondition qc1 = new QueryCondition();
          qc1.add("cpa", cpaVO);
          MxsEngine.getInstance().getObjects("Cpa", 1, qc1, DAOFactory.EBMS);
          cpaMgr.removeCacheCpa(cpa_id);

      } else if (command.equalsIgnoreCase("update")) {
		   // delete and insert
    	  CpaVO vo = (CpaVO) session.getAttribute("cpaVO");
    	  if (vo != null && vo.getCpaId().equalsIgnoreCase(cpa_id)) {
    		  cpaVO.setCpa(vo.getCpa());

    	  } else {
    		  String errMsg = "CPA in session is null";
    		  System.out.println(errMsg);
    		  throw new Exception(errMsg);
    	  }

          cpaMgr.storeCpa("update", cpaVO);
          cpaMgr.removeCacheCpa(cpaVO.getCpa().getCpaId());
      }

   /*} catch (Exception e) {
      e.printStackTrace();
   }*/
%>



