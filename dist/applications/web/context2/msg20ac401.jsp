<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.Eb3MessageManager"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.Eb3Message"%>
<%@ page import="kr.co.bizframe.util.PagingMgtUtil"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="kr.co.bizframe.mxs.MxsConstants"%>
<%@ page import="kr.co.bizframe.mxs.ebms.EbConstants"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.SignalMessage" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.Error" %>
<%@ page import="kr.co.bizframe.mxs.web.I18nStrings"%>
<%
 /**
 * @author Mi-Young Kim
 * @version 1.0 2008.09.02
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

	String strType  = request.getParameter("msgType");
	String strStatus  = request.getParameter("msgStatus");
	String strMsgId	= request.getParameter("msgId");

	String item_Cnt	= request.getParameter("item_Cnt");
	String page_Cnt	= request.getParameter("page_Cnt");

	curPage = Integer.parseInt(request.getParameter("curPage"));

	strType = (strType==null  ?  "" : strType);
	strStatus = (strStatus==null  ?  "" : strStatus);
	strMsgId = (strMsgId==null  ?  "" : strMsgId);
	item_Cnt = (item_Cnt==null  ?  "10" : item_Cnt);
	page_Cnt = (page_Cnt==null  ?  "10" : page_Cnt);

	PagingMgtUtil.setPageCnt(page_Cnt);
	PagingMgtUtil.setItemCnt(item_Cnt);

	Date today = new Date(System.currentTimeMillis());
	try {
		if(strFromDate!=null) fromDate = sdf.parse(strFromDate);
		else fromDate = today;

		if(strToDate!=null)	toDate	= sdf.parse(strToDate);
		else toDate	= today;

	} catch (Exception e) {

	}
	Eb3MessageManager msgMgr = new Eb3MessageManager();
	array = msgMgr.getSignalMessages(fromDate, toDate, strType, strStatus, strMsgId,
									 PagingMgtUtil.getStartRow(curPage),
									 PagingMgtUtil.getEndRow(curPage));
	totalRows = msgMgr.getSignalMessageNum(fromDate, toDate, strType, strStatus, strMsgId);
	size = array.size();

	JSONObject json = new JSONObject();

	JSONArray messages = new JSONArray();
	json.put("messages", messages);
	json.put("curpage", curPage);
	json.put("totalRows", totalRows);
	json.put("item_cnt", item_Cnt);


	Eb3Message msg = null;

	String inoutStr = null;
	String statusStr = null;

	json.put("pagelist", PagingMgtUtil.GetPageIndexForScript(curPage,totalRows,
			"javascript:searchMessage"));

	for (int i=0; i< size; i++) {

		msg = (Eb3Message) array.get(i);

		if(msg.getBoundFor() == MxsConstants.MESSAGE_BOUND_FOR_IN) {
			inoutStr = _i18n.get("global.msg.inbound");
		} else {
			inoutStr = _i18n.get("global.msg.outbound");
		}

		JSONObject message = new JSONObject();

		String type = "Out";
		if(msg.getBoundFor() == MxsConstants.MESSAGE_BOUND_FOR_IN ) {
			type = "In";
		}
		SignalMessage signalMsg = msg.getSignalMessage();
		message.put("obid", signalMsg.getObid());
		message.put("inout", type);
		message.put("status", EbConstants.getMessageStatusString(msg.getStatus()));
		message.put("messageid", signalMsg.getMessageId());
		message.put("time", sd.format(signalMsg.getMessageTimestamp().toDate()));
		message.put("type", MxsConstants._eb3SignalString[signalMsg.getType()]);
		if (signalMsg.getErrors() != null && signalMsg.getErrors().size() > 0) {
			Error err = (Error)signalMsg.getErrors().get(0);
			message.put("errcode", err.getErrorCode());
			message.put("severity", err.getSeverity());
		} else {
			message.put("errcode", "");
			message.put("severity", "");
		}
		messages.put(message);
	}
	out.print(json);
%>
