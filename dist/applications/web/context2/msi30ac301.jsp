<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.BizFrame" %>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.AppPerformerVO" %>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%@ page import="kr.co.bizframe.mxs.dao.MxsDAO" %>
<%
/**
 * update PMode MSI
 *
 * @author Ho-Jin Seo
 * @version 1.0
 */

    MxsEngine engine = MxsEngine.getInstance();
	String obid = StringUtil.nullCheck(request.getParameter("performer.obid"));
	String name = StringUtil.nullCheck(request.getParameter("performer.name"));
	String apptype = StringUtil.nullCheck(request.getParameter("performer.type"));
	String channel_obid = StringUtil.nullCheck(request.getParameter("channel.obid"));
	String action_obid = StringUtil.nullCheck(request.getParameter("action.obid"));
	boolean isNew = false;

	QueryCondition qc = new QueryCondition();
	qc.add("action_obid", action_obid);
	AppPerformerVO vo = (AppPerformerVO)engine.getObject("AppPerformer", qc, DAOFactory.EBMS);
	if (vo == null) {
		vo = new AppPerformerVO();
		isNew = true;
	}
	vo.setCanReceiveObid(action_obid);
	vo.setAppType(Integer.parseInt(apptype));
	vo.setPerformerName(name);
	vo.setQueueObid(channel_obid);

	DAOFactory df  = DAOFactory.getDAOFactory(DAOFactory.EBMS);
	MxsDAO dao     = df.getDAO("AppPerformer");
	if (isNew == true) {
		vo.setCreatedBy(BizFrame.SYSTEM_USER_OBID);
		dao.insertObject(vo);
	} else {
		vo.setModifiedBy(BizFrame.SYSTEM_USER_OBID);
		dao.updateObject(vo);
	}
%>

