<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.dao.MxsDAO" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.AgreementRef" %>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.Eb3Constants" %>
<%@ page import="kr.co.bizframe.mxs.common.MxsObject" %>
<%@ page import="kr.co.bizframe.BizFrame" %>
<%
/**
 * update AgreementRef
 *
 * @author Ho-Jin Seo 2008.10.27
 * @version 1.0
 */

    MxsEngine engine = MxsEngine.getInstance();
	String obid = StringUtil.nullCheck(request.getParameter("obid"));
	if (obid.equals(""))
		throw new Exception("agr30ac001 : obid is null");

	String id = StringUtil.nullCheck(request.getParameter("id"));
	String type = StringUtil.nullCheck(request.getParameter("type"));
	String reftype = StringUtil.nullCheck(request.getParameter("reftype"));
	String refObid = "";
	if (reftype.equals("0")) {
		refObid = "";
	} else if (reftype.equals("1")) {
		refObid = StringUtil.nullCheck(request.getParameter("ref_cpaobid"));
		if (refObid.equals(""))
			throw new Exception("Reference obid error!");
	} else if (reftype.equals("2")) {
		refObid = StringUtil.nullCheck(request.getParameter("ref_pmodeobid"));
		if (refObid.equals(""))
			throw new Exception("Reference obid error!");
	} else {
		throw new Exception("Reference Type error!");
	}

	String description = StringUtil.nullCheck(request.getParameter("description"));


	QueryCondition qc = new QueryCondition();
	qc.add("obid", obid);
	MxsObject obj = engine.getObject("Eb3AgreementRef", qc, DAOFactory.EBMS3);
	AgreementRef vo = (AgreementRef)obj.getExtension(Eb3Constants.MXSOBJ_EXTENSION_AGREEMENT_REF);
	vo.setContent(id);
	vo.setType(type);
	vo.setRefType(Integer.parseInt(reftype));
	vo.setRefObid(refObid);
	vo.setDescription(description);

	obj.setObid(vo.getObid());
    obj.putExtension(Eb3Constants.MXSOBJ_EXTENSION_AGREEMENT_REF, vo);
	obj.setModifiedBy(BizFrame.SYSTEM_USER_OBID);

	DAOFactory df  = DAOFactory.getDAOFactory(DAOFactory.EBMS3);
	MxsDAO dao     = df.getDAO("Eb3AgreementRef");
	dao.updateObject(obj);
%>

