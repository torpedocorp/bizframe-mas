<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.dao.MxsDAO" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.MpcVO" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.Eb3Constants" %>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%@ page import="kr.co.bizframe.mxs.web.I18nStrings"%>
<%@ page import="org.json.JSONObject" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Iterator" %>
<%
/**
 * update Local MPC
 *
 * @author Mi-Young Kim
 * @version 1.0  2008.10.01
 */

    MxsEngine engine = MxsEngine.getInstance();
	String obid = StringUtil.checkNull(request.getParameter("obid"));
	String displayName = StringUtil.checkNull(request.getParameter("displayName"));
	String uri = StringUtil.checkNull(request.getParameter("uri"));
	String statusStr = request.getParameter("status");
	int status = Integer.parseInt(statusStr);
	String wssauth = StringUtil.checkNull(request.getParameter("wssauth"));
	String policy = StringUtil.checkNull(request.getParameter("policy"));
	String is_default = StringUtil.checkNull(request.getParameter("isDefault"));
	String desc = StringUtil.checkNull(request.getParameter("desc"));

	JSONObject json = new JSONObject();
	I18nStrings _i18n = I18nStrings.getInstance();
	if (is_default.equals("0") && status == Eb3Constants.MPC_ACTIVE) {
		// active인 상태의 로컬 mpcuri는 유일해야한다.
			QueryCondition qc = new QueryCondition();
			qc.add("mpc_uri", uri);
			qc.add("is_local", new Integer(Eb3Constants.MPC_LOCAL));
			qc.add("is_active", new Integer(Eb3Constants.MPC_ACTIVE));
			ArrayList mpcs = engine.getObjects("Mpc", qc, DAOFactory.EBMS3);
			int duplicateCnt = 0;
			for (Iterator i = mpcs.iterator(); i.hasNext();) {
				MpcVO mpc = (MpcVO) i.next();
				if (!obid.equals(mpc.getObid())) {
					duplicateCnt++;
				}
			}
			if (duplicateCnt > 0) {
				// 중복된 uri값이 있으므로 에러처리
				json.put("msg", _i18n.get("mpc21ms001.msg.DuplicateUri"));
				out.print(json);
				return;
			}
    }

	QueryCondition qc = new QueryCondition();
	qc.add("obid", obid);
	MpcVO vo = (MpcVO) engine.getObject("Mpc", qc, DAOFactory.EBMS3);

	//공통 수정부분
	vo.setIsActive(status);
	vo.setPolicy(Integer.parseInt(policy));
	vo.setDescription(desc);

	if (is_default.equals("0")) {
		vo.setMpcUri(uri);
		vo.setDisplayName(displayName);
		vo.setUseWssAuth(Integer.parseInt(wssauth));
	}

	DAOFactory df  = DAOFactory.getDAOFactory(DAOFactory.EBMS3);
	MxsDAO dao = df.getDAO("Mpc");
	dao.updateObject(vo);
	json.put("msg", _i18n.get("mpc21ms002.operation.update"));
	out.print(json);
%>

