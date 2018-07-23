<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.org.MxsUser" %>
<%@ page import="kr.co.bizframe.BizFrame"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.util.HashEncryption" %>
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
String email = request.getParameter("email");
String cell = request.getParameter("cell");

MxsUser userVO = new MxsUser(userid, HashEncryption.getInstance().encryptSHA1(passwd));
userVO.setCreatedBy (BizFrame.SYSTEM_USER_OBID);
userVO.setDescription(description);
userVO.setEmail(email);
userVO.setCellphone(cell);

//DAOFactory df  = DAOFactory.getDAOFactory(DAOFactory.COMMON);
//MxsDAO dao     = df.getDAO("User");
//dao.insertObject(userVO);
MxsEngine engine = MxsEngine.getInstance();
engine.insertObject("User", userVO, DAOFactory.COMMON);


%>
