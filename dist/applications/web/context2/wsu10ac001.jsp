<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.WSSUserVO" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.MpcToWSSUserRelVO" %>
<%@ page import="kr.co.bizframe.BizFrame"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%
/**
 * Insert user
 *
 * @author Ho-Jin Seo
 * @version 1.0
 */
String userid = request.getParameter("userid");
String passwd = request.getParameter("passwd");
String description = request.getParameter("description");
String party_obid = request.getParameter("party_obid");

WSSUserVO userVO = new WSSUserVO();
userVO.setUsername(userid);
userVO.setPassword(passwd);
userVO.setCreatedBy (BizFrame.SYSTEM_USER_OBID);
userVO.setDescription(description);
userVO.setPartyIdObid(party_obid);

MxsEngine engine = MxsEngine.getInstance();
engine.insertObject("WSSUser", userVO, DAOFactory.EBMS3);

String[] mpcObid_arr = request.getParameterValues("mpcObid");
if(mpcObid_arr == null) return;

for (int i = 0; i <mpcObid_arr.length; i++) {
	MpcToWSSUserRelVO relvo = new MpcToWSSUserRelVO();
	relvo.setMpcObid(mpcObid_arr[i]);
	relvo.setWssUserObid(userVO.getObid());

	engine.insertObject("MpcToWSSUserRel", relvo, DAOFactory.EBMS3);
}

%>
