<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.AgreementRef" %>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%@ page import="kr.co.bizframe.BizFrame"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.mxs.common.MxsObject" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.Eb3Constants" %>
<%
/**
 * Insert agreementRef
 *
 * @author Ho-Jin Seo
 * @version 1.0
 */
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

MxsObject obj = new MxsObject();
obj.setCreatedBy (BizFrame.SYSTEM_USER_OBID);

AgreementRef vo = new AgreementRef();
vo.setContent(id);
vo.setType(type);
vo.setPMode(request.getParameter("refpmode"));
vo.setObid(obj.getObid());
vo.setDescription(description);
vo.setRefType(Integer.parseInt(reftype));
vo.setRefObid(refObid);

obj.putExtension(Eb3Constants.MXSOBJ_EXTENSION_AGREEMENT_REF, vo);
MxsEngine engine = MxsEngine.getInstance();
engine.insertObject("Eb3AgreementRef", obj, DAOFactory.EBMS3);

%>
