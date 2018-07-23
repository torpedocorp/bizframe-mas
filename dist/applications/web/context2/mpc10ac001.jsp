<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.dao.MxsDAO" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.MpcVO" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.Eb3Constants"%>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%@ page import="kr.co.bizframe.mxs.web.I18nStrings"%>
<%@ page import="org.json.JSONObject" %>
<%
/**
 * Register Local MPC
 *
 * @author Mi-Young Kim
 * @version 1.0 2008.10.01
 */
    MxsEngine engine = MxsEngine.getInstance();
	String displayName = StringUtil.checkNull(request.getParameter("displayName"));
	String uri = StringUtil.checkNull(request.getParameter("uri"));
	String statusStr = request.getParameter("status");
	int status = Integer.parseInt(statusStr);
	String wssauth = StringUtil.checkNull(request.getParameter("wssauth"));
	String policy = StringUtil.checkNull(request.getParameter("policy"));
	String desc = StringUtil.checkNull(request.getParameter("desc"));

	JSONObject json = new JSONObject();
	I18nStrings _i18n = I18nStrings.getInstance();
	if (status == Eb3Constants.MPC_ACTIVE) {
		// active인 상태의 로컬 mpcuri는 유일해야한다.
			QueryCondition qc = new QueryCondition();
			qc.add("mpc_uri", uri);
			qc.add("is_local", new Integer(Eb3Constants.MPC_LOCAL));
			qc.add("is_active", new Integer(Eb3Constants.MPC_ACTIVE));
			MpcVO mpc = (MpcVO)engine.getObject("Mpc", qc, DAOFactory.EBMS3);
			if (mpc != null) {
				// 중복된 uri값이 있으므로 에러처리
				json.put("err", "true");
				json.put("msg", _i18n.get("mpc21ms001.msg.DuplicateUri"));
				out.print(json);
				return;
			}
    }

	MpcVO vo = new MpcVO();
	vo.setDisplayName(displayName);
	vo.setMpcUri(uri);
	vo.setIsActive(status);
	vo.setUseWssAuth(Integer.parseInt(wssauth));
	vo.setPolicy(Integer.parseInt(policy));
	vo.setDescription(desc);
	vo.setIsDefault(Eb3Constants.MPC_NON_DEFAULT);
	vo.setIsLocal(Eb3Constants.MPC_LOCAL);

	DAOFactory df  = DAOFactory.getDAOFactory(DAOFactory.EBMS3);
	MxsDAO dao     = df.getDAO("Mpc");
	dao.insertObject(vo);

	json.put("err", "false");
	out.print(json);
%>

