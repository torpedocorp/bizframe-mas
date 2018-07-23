<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.CpaVO" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.pmode.PMode" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.AgreementRef" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.Eb3Constants" %>
<%@ page import="kr.co.bizframe.mxs.common.MxsObject" %>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%
/**
 * Get Agreement
 *
 * @author Ho-Jin Seo
 * @version 1.0
 */

    MxsEngine engine = MxsEngine.getInstance();

   String obid = StringUtil.nullCheck(request.getParameter("obid"));

   QueryCondition qc = new QueryCondition();
	if (obid.equals("") == false) {
		qc.add("obid", obid);
	}
	MxsObject obj = engine.getObject("Eb3AgreementRef", qc, DAOFactory.EBMS3);
	AgreementRef vo = (AgreementRef)obj.getExtension(Eb3Constants.MXSOBJ_EXTENSION_AGREEMENT_REF);
	JSONObject json = new JSONObject();

	JSONObject agreement = new JSONObject();

	agreement.put("obid", vo.getObid());
	agreement.put("id", vo.getContent());
	agreement.put("type", StringUtil.nullCheck(vo.getType()));
	agreement.put("pmode", StringUtil.nullCheck(vo.getPMode()));
	agreement.put("reftype", String.valueOf(vo.getRefType()));
	agreement.put("refobid", StringUtil.nullCheck(vo.getRefObid()));

	qc = new QueryCondition();
	if (vo.getRefType() == 1) {
		qc.add("obid", vo.getRefObid());
		CpaVO cpaVO = (CpaVO)engine.getObject("Cpa", qc, DAOFactory.EBMS);
		agreement.put("ref_cpaid", cpaVO.getCpaName());
	} else if (vo.getRefType() == 2) {
		qc.add("obid", vo.getRefObid());
		PMode pmode = (PMode)engine.getObject("PMode", qc, DAOFactory.EBMS3).getExtension(Eb3Constants.MXSOBJ_EXTENSION_PMODE);
		agreement.put("ref_pmodeid", pmode.getDisplayName());
	}

	agreement.put("desc", StringUtil.nullCheck(vo.getDescription()));

	out.print(agreement);
%>
