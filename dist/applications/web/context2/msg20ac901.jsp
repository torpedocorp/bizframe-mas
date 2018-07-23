<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="kr.co.bizframe.mxs.wsms.dto.WsMessageVO" %>
<%@ page import="kr.co.bizframe.mxs.wsms.model.Wsdl" %>
<%@ page import="kr.co.bizframe.mxs.wsms.WsdlManager" %>
<%@ page import="kr.co.bizframe.util.PagingMgtUtil" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="kr.co.bizframe.mxs.wsms.WsConstants" %>
<%@ page import="kr.co.bizframe.mxs.web.I18nStrings" %>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%
/**
 * @author Ho-Jin Seo
 * @author Mi-Young Kim
 * @version 1.0
 */
// ============ get messageList ================
	I18nStrings _i18n = I18nStrings.getInstance();

	ArrayList array = null;
	int totalRows = 0;
	int curPage = 1;
	int size = 0;

    Date fromDate = null;
    Date toDate   = null ;

    String strFromDate = request.getParameter("f_date");
    String strToDate   = request.getParameter("t_date");

    String strWsdlName  = request.getParameter("wsdlName");
    String strOperation = request.getParameter("msgOperation");
    String strStatus = request.getParameter("status");
    String strMsgId = request.getParameter("msgId");
	String position = request.getParameter("curPage");
    String strType = request.getParameter("msgType");

    strWsdlName  = (strWsdlName==null  ?  "" : strWsdlName);
    strOperation = (strOperation==null ?  "" : strOperation);
    strStatus = (strStatus==null ?  "" : strStatus);
    strMsgId = (strMsgId==null ?  "" : strMsgId);
    strType = (strType==null ?  "" : strType);

    String item_Cnt = request.getParameter("item_Cnt") == null ? "10" : request.getParameter("item_Cnt"); ;
    String page_Cnt = request.getParameter("page_Cnt") == null ? "10" : request.getParameter("page_Cnt") ;

   	PagingMgtUtil.setPageCnt(page_Cnt);
   	PagingMgtUtil.setItemCnt(item_Cnt);


     // Normalize parameter values

    SimpleDateFormat sdf  = new SimpleDateFormat("yyyy-MM-dd");

    Date today = new Date(System.currentTimeMillis());
	try {
		if(strFromDate!=null) fromDate = sdf.parse(strFromDate);
		else fromDate = today;

		if(strToDate!=null)   toDate   = sdf.parse(strToDate);
		else toDate   = today;
    } catch (Exception e){

	}

    try {
		if (position != null) curPage = Integer.parseInt(position);
		else curPage = 1;
    } catch (Exception e) {
		curPage = 1;
	}

    // J-.H. Kim on 2008.02.28
	//totalRows = MxsEngine.getInstance().getMessageNum(fromDate, toDate, strOperation, strWsdlName, strStatus, strMsgId, strType);
    //array = MxsEngine.getInstance().getMessages(fromDate, toDate, strOperation, strWsdlName, strStatus, strMsgId, strType,
	//                          PagingMgtUtil.getStartRow(curPage), PagingMgtUtil.getEndRow(curPage);
    //WsHandler wh = new WsHandler();
    
	QueryCondition qc = new QueryCondition();

	qc.add("from", fromDate);
	qc.add("to", toDate);

	if (strOperation != null && !strOperation.equals(""))
		qc.add("operation", strOperation);
	if (strWsdlName != null && !strWsdlName.equals(""))
		qc.add("wsdl", strWsdlName);
	if (strStatus != null && !strStatus.equals(""))
		qc.add("status", Integer.valueOf(strStatus));
	if (strMsgId != null && !strMsgId.equals(""))
		qc.add("messageId", strMsgId);
	if (strType != null && !strType.equals(""))
		qc.add("type", strType);

	totalRows = MxsEngine.getInstance().getCount("WsMessage", qc, DAOFactory.WSMS);
   	//totalRows = wh.getMessageNum(fromDate, toDate, strOperation, strWsdlName, strStatus, strMsgId, strType);
   	
   	qc = new QueryCondition();

	qc.add("from", fromDate);
	qc.add("to", toDate);
	qc.add("wsdl", strWsdlName);
	qc.add("operation", strOperation);
	qc.add("status", strStatus);
	qc.add("messageId", strMsgId);
	qc.add("type", strType);
	qc.add("start", strType);
	qc.add("type", strType);
    qc.add("start", new Integer(PagingMgtUtil.getStartRow(curPage)));
    qc.add("end", new Integer(PagingMgtUtil.getEndRow(curPage)));

   	array = MxsEngine.getInstance().getObjects("WsMessage", 2, qc, DAOFactory.WSMS);
	//array = wh.getMessages(fromDate, toDate, strOperation, strWsdlName, strStatus, strMsgId, strType,
	//		PagingMgtUtil.getStartRow(curPage), PagingMgtUtil.getEndRow(curPage));

	size = array.size();

	JSONObject json = new JSONObject();

	JSONArray messages = new JSONArray();
	json.put("messages", messages);
	json.put("curpage", curPage);
	json.put("totalRows", totalRows);
	json.put("item_cnt", item_Cnt);

	WsMessageVO msgVO = null;
	SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy.MM.dd HH:mm:ss.S");
	String inoutStr = null;
	String statusStr = null;

	json.put("pagelist", PagingMgtUtil.GetPageIndexForScript(curPage,totalRows,"javascript:searchMessage"));

	for (int i=0; i< size; i++) {

        msgVO = (WsMessageVO) array.get(i);

        /*
	    if(msgVO.getBoundFor() == WsConstants.INBOUND_MSG) {
			inoutStr = _i18n.get("global.msg.inbound");
	    } else {
	    	inoutStr = _i18n.get("global.msg.outbound");
	    }
	    */

	    statusStr = WsConstants.getMessageStatusString(msgVO.getStatus());

		if(statusStr == null || statusStr.equals("")) {
			statusStr = "n/a";
		}else if(statusStr.equalsIgnoreCase("UnAuthorized")) {
			statusStr = _i18n.get("global.msg.status.unauthorized");
		} else if(statusStr.equalsIgnoreCase("Forwarded")) {
			statusStr = _i18n.get("global.msg.status.forwarded");
		} else if(statusStr.equalsIgnoreCase("Processed")) {
			statusStr = _i18n.get("global.msg.status.processed");
			if(msgVO.getBoundFor() == WsConstants.OUTBOUND_MSG) {
				statusStr = _i18n.get("global.msg.status.send");
			}
		} else if(statusStr.equalsIgnoreCase("Received")) {
			statusStr = _i18n.get("global.msg.status.received");
		} else if(statusStr.equalsIgnoreCase("NotRecognized")) {
			if(msgVO.getBoundFor() == WsConstants.INBOUND_MSG){
				statusStr = _i18n.get("global.msg.status.recverror");
			} else {
				statusStr = _i18n.get("global.msg.status.senderror");
			}
		} else if(statusStr.equalsIgnoreCase("Error")) {
			statusStr = _i18n.get("global.msg.status.error");
			if(msgVO.getBoundFor() == WsConstants.OUTBOUND_MSG) {
				statusStr = _i18n.get("global.msg.status.senderror");
			}
		} else {
			statusStr = "---";
		}

		JSONObject message = new JSONObject();

		String[] operation = msgVO.getOperationObid().split(":");

		message.put("obid", msgVO.getObid());
		message.put("inout", msgVO.getBoundFor());
		message.put("messageId", msgVO.getWsaMessageId());

		if (operation.length > 0) {
			message.put("operationId", operation[0]);
			// J-.H. Kim on 2008.02.28
			//wsdlVO = MxsEngine.getInstance().getWsdlByOperation(operation[0]);
			WsdlManager wm = new WsdlManager();
			Wsdl wsdlVO = wm.getWsdlByOperation(operation[0]);
			if (wsdlVO != null) {
				message.put("wsdlName", wsdlVO.getName());
			} else {
				message.put("wsdlName", "");
			}
		}
		if (operation.length > 1)
			message.put("operationName", operation[1]);

		message.put("fromUri", msgVO.getWsaFromUri());
		message.put("toUri", msgVO.getWsaToUri());
		message.put("relatesTo", msgVO.getWsaRelatesTo());
		message.put("time", sdf1.format(msgVO.getTimestamp()));
		message.put("status", msgVO.getStatus());
		message.put("statusStr", statusStr);


		messages.put(message);
	}
	out.print(json);
%>
