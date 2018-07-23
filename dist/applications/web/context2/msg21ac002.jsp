<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.dto.PartInfoVO"%>
<%@ page import="kr.co.bizframe.mxs.wsms.dto.WsMessageVO"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="java.util.Iterator" %>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<%
	/**
	 * 외부에서 사용하는 페이로드 정보
	 * @author Mi-Young Kim 2009.04.17
	 * @version 1.0
	 */
	String obid = request.getParameter("obid");
	String msgId = request.getParameter("msgId");

	String value = null;
	String key = null;
	if (obid == null && msgId != null) {
		key = "wsa_message_id";
		value = msgId;
	} else {
		key = "obid";
		value = obid;
	}

	JSONObject json = new JSONObject();
	JSONArray list = new JSONArray();
	json.put("list", list);

	if (key != null && value != null) {
		MxsEngine engine = MxsEngine.getInstance();
		QueryCondition qc = new QueryCondition();
		qc.add(key, value);
		WsMessageVO msgVO = (WsMessageVO)engine.getObject("WsMessage", qc, DAOFactory.WSMS);

		if (msgVO != null) {
			int cnt = 0;
			for (Iterator i = msgVO.getPartInfos().iterator(); i.hasNext();) {
				PartInfoVO vo = (PartInfoVO) i.next();
				String contentType = (vo.getContentType()).replaceAll("\r\n", "");
				JSONObject obj = new JSONObject();
				obj.put("obid", vo.getObid());
				obj.put("contentId", vo.getObid());
				obj.put("contentType", vo.getContentType());
				list.put(obj);
			}
		}
	}

	out.print(list);
%>
