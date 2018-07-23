<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.dao.MxsDAO" %>
<%@ page import="kr.co.bizframe.mxs.org.MxsUser" %>
<%@ page import="kr.co.bizframe.util.HashEncryption" %>
<%@ page import="kr.co.bizframe.util.ServerProperties" %>
<%
/**
 * update user
 *
 * @author Ho-Jin Seo
 * @version 1.0
 */

    MxsEngine engine = MxsEngine.getInstance();
	String obid = request.getParameter("obid");
	String passwd = request.getParameter("passwd");
	String description = request.getParameter("description");
	String email = request.getParameter("email");
	String cell = request.getParameter("cell");

	QueryCondition qc = new QueryCondition();
	qc.add("obid", obid);
	MxsUser userVO = (MxsUser) engine.getObject("User", qc, DAOFactory.COMMON);

	if (passwd != null && !passwd.equals(""))
		userVO.setPasswd(HashEncryption.getInstance().encryptSHA1(passwd));

	userVO.setDescription(description);
	userVO.setEmail(email);
	userVO.setCellphone(cell);

	DAOFactory df  = DAOFactory.getDAOFactory(DAOFactory.COMMON);
	MxsDAO dao     = df.getDAO("User");
	dao.updateObject(userVO);

	if (userVO.getUserId().equals("admin")) {
		ServerProperties props	= ServerProperties.getInstance();
		props.setProperty("mxs.admin.password", userVO.getPasswd());
		props.saveProperties();
	}
%>

