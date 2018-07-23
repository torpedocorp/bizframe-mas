<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.MpcVO"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.Eb3Constants"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%
/**
 * Detail MPC (로컬, 원격에 맞게 분기)
 *
 * @author Mi-Young Kim
 * @version 1.0 2008.10.28
 */

   String obid = request.getParameter("obid");
   String url = "";
   obid = (obid == null ? "" : obid);
   QueryCondition qc = new QueryCondition();
   qc.add("obid", obid);
   MpcVO mpc = (MpcVO)MxsEngine.getInstance().getObject("Mpc", qc, DAOFactory.EBMS3);
   if (mpc != null) {
	    if (mpc.getIsLocal() == Eb3Constants.MPC_LOCAL) {
	    	url = "mpc21ms001.jsp";
	    } else if (mpc.getIsLocal() == Eb3Constants.MPC_REMOTE) {
		    url = "mpc21ms002.jsp";
	    }
   }
   if (url.length() > 0) {
%>
	<script>
		location.href = "<%=url%>";
	</script>
<%
 	 return;
   }
%>
<script>
self.close();
</script>
