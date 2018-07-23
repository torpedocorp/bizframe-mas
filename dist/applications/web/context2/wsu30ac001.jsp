<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.dao.MxsDAO" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.WSSUserVO" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.MpcToWSSUserRelVO" %>
<%
/**
 * update user
 *
 * @author Ho-Jin Seo 2008.09.25
 * @version 1.0
 */

    MxsEngine engine = MxsEngine.getInstance();
	String obid = request.getParameter("obid");
	String passwd = request.getParameter("passwd");
	String description = request.getParameter("description");
	String party_obid = request.getParameter("party_obid");

	QueryCondition qc = new QueryCondition();
	qc.add("obid", obid);
	WSSUserVO userVO = (WSSUserVO) engine.getObject("WSSUser", qc, DAOFactory.EBMS3);

	if (passwd != null && !passwd.equals("") && passwd.length() > 0) {
		userVO.setPassword(passwd);
	}

	userVO.setDescription(description);
	userVO.setPartyIdObid(party_obid);

	DAOFactory df  = DAOFactory.getDAOFactory(DAOFactory.EBMS3);
	MxsDAO dao     = df.getDAO("WSSUser");
	dao.updateObject(userVO);

	MxsDAO reldao = df.getDAO("MpcToWSSUserRel");
	QueryCondition qc3 = new QueryCondition();
	qc3.add("wss_user_obid", userVO.getObid());
	reldao.deleteObjects("bf_mxs_mpc_to_wss_user_rel", qc3);

	String[] mpcObid_arr = request.getParameterValues("mpcObid");
	if(mpcObid_arr == null) return;

	for (int i = 0; i <mpcObid_arr.length; i++) {
		MpcToWSSUserRelVO relvo = new MpcToWSSUserRelVO();
		relvo.setMpcObid(mpcObid_arr[i]);
		relvo.setWssUserObid(userVO.getObid());

		engine.insertObject("MpcToWSSUserRel", relvo, DAOFactory.EBMS3);
	}
%>

