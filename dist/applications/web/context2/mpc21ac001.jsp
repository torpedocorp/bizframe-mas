<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.MpcVO"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.Eb3MessageManager"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.Eb3Constants"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%@ page import="org.json.JSONObject" %>
<%
/**
 * Detail MPC
 *
 * @author Mi-Young Kim
 * @version 1.0 2008.09.25
 */

   String obid = request.getParameter("obid");

   obid = (obid == null ? "" : obid);
   QueryCondition qc = new QueryCondition();
   qc.add("obid", obid);
   MpcVO mpc = (MpcVO)MxsEngine.getInstance().getObject("Mpc", qc, DAOFactory.EBMS3);
   if (mpc != null) {
	    // 이 mpc를 사용 중인 거래 합의 개수
	    int agreementRefCnt = 0;
	    qc = new QueryCondition();
	    qc.add("mpcObid", mpc.getObid());
	    ArrayList array = MxsEngine.getInstance().getObjects("Eb3AgreementRef", 0, qc, DAOFactory.EBMS3);
	    agreementRefCnt +=  array.size();

	    // 이 mpc에 대기 중인 메시지 개수
	    qc = new QueryCondition();
	    qc.add("pulling_mode", new Integer(Eb3Constants.PULLING_MODE_WAITING));
	    qc.add("mpc_uri", mpc.getMpcUri());
	    Eb3MessageManager msgMgr = new Eb3MessageManager();
	    int pullwaitingCnt = msgMgr.getUserMessageNum(qc);

	    // 이 mpc를 사용하는 wss사용자
	    qc = new QueryCondition();
	    qc.add("mpc_obid", mpc.getObid());
	    ArrayList wssUserList = MxsEngine.getInstance().getObjects("WSSUser", 1, qc, DAOFactory.EBMS3);
	    int wssuserCnt = wssUserList.size();

   		JSONObject json = new JSONObject();
	    json.put("obid", mpc.getObid());
	    json.put("displayName", mpc.getDisplayName());
	    json.put("uri", mpc.getMpcUri());
	    json.put("isDefault", mpc.getIsDefault());
	    json.put("isLocal", mpc.getIsLocal());
	    json.put("status", mpc.getIsActive());
	    json.put("wssauth", mpc.getUseWssAuth());
	    json.put("policy", mpc.getPolicy());
	    json.put("desc", StringUtil.checkNull(mpc.getDescription()));
	    json.put("agreementRefCnt", agreementRefCnt);
	    json.put("pullwaitingCnt", pullwaitingCnt);
	    json.put("wssuserCnt", wssuserCnt);

		out.print(json);
   }
%>
