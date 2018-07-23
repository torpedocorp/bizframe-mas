<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.Eb3MessageManager"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.Eb3Message"%>
<%@ page import="kr.co.bizframe.util.PagingMgtUtil" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="kr.co.bizframe.mxs.MxsConstants"%>
<%@ page import="kr.co.bizframe.mxs.ebms.EbConstants"%>
<%@ page import="kr.co.bizframe.mxs.web.I18nStrings" %>
<%
 /**
 * @author Ho-Jin Seo
 * @author Mi-Young Kim
 * @version 1.0
 */
// ============ get messageList ================
	I18nStrings _i18n = I18nStrings.getInstance();

	SimpleDateFormat sd = new SimpleDateFormat("yyyy.MM.dd HH:mm:ss");
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

	ArrayList array = null;
	int totalRows = 0;
	int curPage = 1;
	int size = 0;

	Date fromDate = null;
	Date toDate	= null ;

	String strFromDate = request.getParameter("f_date");
	String strToDate	= request.getParameter("t_date");

	String strAgreementRefObid	= request.getParameter("agreementRef");
	String strAction  = request.getParameter("msgAction");
	String strStatus  = request.getParameter("msgStatus");
	String strMsgId	= request.getParameter("msgId");

	// mpc사용 메시지를 위한 조건 추가 Mi-Young Kim 2008.09.26
	String strMpcUri = request.getParameter("mpcUri");
	String strPullMode = request.getParameter("pullMode");

	String item_Cnt	= request.getParameter("item_Cnt");
	String page_Cnt	= request.getParameter("page_Cnt");

	curPage = Integer.parseInt(request.getParameter("curPage"));

	strAgreementRefObid	= (strAgreementRefObid==null  ?  "" : strAgreementRefObid);
	strAction		= (strAction==null  ?  "" : strAction);
	strStatus		= (strStatus==null  ?  "" : strStatus);
	strMsgId		= (strMsgId==null  ?  "" : strMsgId);
	strMpcUri		= (strMpcUri==null  ?  "" : strMpcUri);
	strPullMode		= (strPullMode==null  ?  "" : strPullMode);

	item_Cnt		= (item_Cnt==null  ?  "10" : item_Cnt);
	page_Cnt		= (page_Cnt==null  ?  "10" : page_Cnt);

	PagingMgtUtil.setPageCnt(page_Cnt);
	PagingMgtUtil.setItemCnt(item_Cnt);

	Date today = new Date(System.currentTimeMillis());
	try {
		if(strFromDate !=null && strFromDate.length() > 0) {
			fromDate = sdf.parse(strFromDate);
		} else {
			fromDate = today;
		}

		if(strToDate!=null && strToDate.length() > 0)	{
			toDate	= sdf.parse(strToDate);
		} else {
			toDate	= today;
		}

	} catch (Exception e) {

	}

	// ==== where 조건 ========
	QueryCondition qc = new QueryCondition();

	qc.add("fromDate", sdf.format(fromDate));
	qc.add("toDate", sdf.format(toDate));

	// where
	if (strAction != null && !strAction.equals("")) {
		qc.add("action", strAction);
	}

	if (strAgreementRefObid != null && !strAgreementRefObid.equals("")) {
		qc.add("agreement_ref_obid", strAgreementRefObid);
	}

	if (strStatus != null && !strStatus.equals("")) {
		qc.add("status", Integer.valueOf(strStatus));
	}

	if (strMsgId != null && !strMsgId.equals("")) {
		qc.add("message_id", strMsgId);
	}

	if (strMpcUri != null && !strMpcUri.equals("")) {
		qc.add("mpc_uri", strMpcUri);
	}

	if (strPullMode != null && !strPullMode.equals("")) {
		qc.add("pulling_mode", new Integer(strPullMode));
	}

	Eb3MessageManager msgMgr = new Eb3MessageManager();
	totalRows = msgMgr.getUserMessageNum(qc);

	// start, end
	qc.add("start", new Integer(PagingMgtUtil.getStartRow(curPage)));
	qc.add("end", new Integer(PagingMgtUtil.getEndRow(curPage)));

	array = msgMgr.getUserMessages(qc);
	size = array.size();

	JSONObject json = new JSONObject();

	JSONArray messages = new JSONArray();
	json.put("messages", messages);
	json.put("curpage", curPage);
	json.put("totalRows", totalRows);
	json.put("item_cnt", item_Cnt);


	Eb3Message msgVO = null;
	String inoutStr = null;
	String statusStr = null;
	json.put("pagelist", PagingMgtUtil.GetPageIndexForScript(curPage,totalRows,"javascript:searchMessage"));

	for (int i=0; i< size; i++) {

		msgVO = (Eb3Message) array.get(i);

		if(msgVO.getBoundFor() == MxsConstants.MESSAGE_BOUND_FOR_IN) {
			inoutStr = _i18n.get("global.msg.inbound");
		} else {
			inoutStr = _i18n.get("global.msg.outbound");
		}

		JSONObject message = new JSONObject();

		String type = "Out";
		if(msgVO.getBoundFor() == MxsConstants.MESSAGE_BOUND_FOR_IN ) {
			type = "In";
		}

		message.put("obid", msgVO.getUserMessage().getObid());
		message.put("inout", type);
		message.put("status", EbConstants.getMessageStatusString(msgVO.getStatus()));
		message.put("time", sd.format(msgVO.getUserMessageInfo().getTimestamp().toDate()));
		message.put("agreementRef", msgVO.getAgreementRefVal());
		message.put("service", msgVO.getCollaborationInfo().getService());
		message.put("action", msgVO.getCollaborationInfo().getAction());
		message.put("messageid", msgVO.getUserMessage().getMessageId());

		messages.put(message);
	}
	out.print(json);
%>
