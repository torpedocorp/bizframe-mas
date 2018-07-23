<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.mxs.org.MxsUser" %>
<%@ page import="kr.co.bizframe.util.ServerProperties" %>
<%@ page import="kr.co.bizframe.util.HashEncryption" %>
<%
	/**
	 * Do login
	 *
	 * @author Ho-Jin Seo
	 * @version 1.0
	 */

	String userid = request.getParameter("loginid");
	String pass  = request.getParameter("loginpw");
	MxsUser userVO = null;

	session.setMaxInactiveInterval(99999999);

	JSONObject login = new JSONObject();
	if (userid == null) {
		login.put("result", "101");
		session.setAttribute("status", null);
	} else if (pass == null) {
		login.put("result", "102");
		session.setAttribute("status", null);
	} else {
	    ServerProperties props	= ServerProperties.getInstance();
	   	String user1 = props.getProperty("mxs.admin.user","admin");
		if (userid.equals(user1)) {
		
			String pass1 = props.getProperty("mxs.admin.password");
			if (pass1.equals(HashEncryption.getInstance().encryptSHA1(pass))) {	// correct
			//if (pass1.equals(pass)) {	// correct
				userVO = new MxsUser("obid");
				userVO.setUserId(user1);
				userVO.setObid("01234567-0123-0123-0123-0123456789AB");

				String userId = userVO.getUserId();
				session.setAttribute("userobid", userVO.getObid());
				session.setAttribute("passwd", pass);
				session.setAttribute("userid", userid);
				session.setAttribute("status", "true");
				login.put("result", "001");

			} else {
				login.put("result", "103");
				session.setAttribute("status", null);
			}
		} else {

			/*
			QueryCondition qc = new QueryCondition();
			qc.add("user_id", userid);
			qc.add("passwd", pass);

			userVO = (MxsUser) MxsEngine.getInstance().getObject("User", qc, DAOFactory.COMMON);
		}

		if (userVO != null) {
			if (userVO.getUserId().equals(user1) {
				String userId = userVO.getUserId();
				session.setAttribute("userobid", userVO.getObid());
				session.setAttribute("passwd", pass);
				session.setAttribute("userid", userid);
				session.setAttribute("status", "true");
				login.put("result", "001");
			} else {
				login.put("result", "103");
				session.setAttribute("status", null);
			}
		} else {
			login.put("result", "103");
			session.setAttribute("status", null);
		}
		*/
			login.put("result", "103");
			session.setAttribute("status", null);
		}

	}
	out.print(login);
%>
