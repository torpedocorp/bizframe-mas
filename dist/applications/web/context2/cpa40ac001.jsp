<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.CpaVO" %>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%
/**
 * Delete CPA
 *
 * @author Mi-Young Kim
 * @author Jae-Heon Kim
 * @author Ho-Jin Seo
 * @version 1.0
 */
   String[] cpa_obid_arr = request.getParameterValues("cpa.obid");
  try {
	  for (int i = 0; i <cpa_obid_arr.length; i++) {
		     String cpa_obid = cpa_obid_arr[i];
		     QueryCondition qc = new QueryCondition();
		     qc.add("obid", cpa_obid);
			 qc.setQueryLargeData(false);
		     CpaVO vo = (CpaVO)MxsEngine.getInstance().getObject("Cpa", qc, DAOFactory.EBMS);
		     MxsEngine.getInstance().deleteObject("Cpa", vo, DAOFactory.EBMS);
		  }
  } catch (Exception e) {
	  e.printStackTrace();
  }
%>