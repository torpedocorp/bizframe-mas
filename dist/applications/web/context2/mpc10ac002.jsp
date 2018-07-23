<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.dao.MxsDAO" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.MpcVO" %>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%@ page import="kr.co.bizframe.mxs.MxsConstants"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.mpc.MpcPullingManager"%>
<%
/**
 * Add Remote MPC
 *
 * @author Ho-Jin Seo 2008.09.30
 * @version 1.0
 */

    MxsEngine engine = MxsEngine.getInstance();
	String displayName = StringUtil.checkNull(request.getParameter("displayName"));
	String uri = StringUtil.checkNull(request.getParameter("uri"));
	String wssauth = StringUtil.checkNull(request.getParameter("wssauth"));
	String priority = StringUtil.checkNull(request.getParameter("priority"));
	String is_default = StringUtil.checkNull(request.getParameter("is_default"));
	String usedemon = StringUtil.checkNull(request.getParameter("usedemon"));
	String interval = StringUtil.checkNull(request.getParameter("interval"));
	String status = request.getParameter("status");
	String desc = StringUtil.checkNull(request.getParameter("desc"));

	MpcVO vo = new MpcVO();
	vo.setDisplayName(displayName);
	vo.setUseWssAuth(Integer.parseInt(wssauth));
	vo.setPriority(Integer.parseInt(priority));
	if (is_default.equals("1")) {
		vo.setIsDefault(1);
		vo.setMpcUri(MxsConstants.DEFAULT_MPC);
	} else {
		vo.setIsDefault(0);
		vo.setMpcUri(uri);
	}
	if (usedemon.equals("1")) {
		vo.setPullInterval(Integer.parseInt(interval));
	} else {
		vo.setPullInterval(0);
	}
	vo.setIsActive(Integer.parseInt(status));
	vo.setDescription(desc);
	vo.setIsLocal(0);
	vo.setPolicy(0);

	DAOFactory df  = DAOFactory.getDAOFactory(DAOFactory.EBMS3);
	MxsDAO dao     = df.getDAO("Mpc");
	dao.insertObject(vo);

	MpcPullingManager.getInstance().putMpc(vo, 0);
%>

