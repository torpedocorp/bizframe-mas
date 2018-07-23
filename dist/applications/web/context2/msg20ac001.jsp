<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="kr.co.bizframe.mxs.ebms.EbHandler"%>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.EbMessageVO"%>
<%@ page import="kr.co.bizframe.util.PagingMgtUtil" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="kr.co.bizframe.mxs.MxsConstants"%>
<%@ page import="kr.co.bizframe.mxs.ebms.EbConstants"%>
<%@ page import="kr.co.bizframe.mxs.web.I18nStrings" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%
 /**
 * @author Gemini Kim
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
   Date toDate   = null ;

   String strFromDate = request.getParameter("f_date");
   String strToDate   = request.getParameter("t_date");

   String strCpaId   = request.getParameter("cpaId");
   String strAction  = request.getParameter("msgAction");
   String strStatus  = request.getParameter("msgStatus");
   String strType  = request.getParameter("msgType");
   String strMsgId   = request.getParameter("msgId");

   String item_Cnt   = request.getParameter("item_Cnt");
   String page_Cnt   = request.getParameter("page_Cnt");

   curPage = Integer.parseInt(request.getParameter("curPage"));

   strCpaId       = (strCpaId==null  ?  "" : strCpaId);
   strAction      = (strAction==null  ?  "" : strAction);
   strStatus      = (strStatus==null  ?  "" : strStatus);
   strType        = (strType==null  ?  "" : strType);
   strMsgId       = (strMsgId==null  ?  "" : strMsgId);
   item_Cnt       = (item_Cnt==null  ?  "100" : item_Cnt);
   page_Cnt       = (page_Cnt==null  ?  "10" : page_Cnt);

   PagingMgtUtil.setPageCnt(page_Cnt);
   PagingMgtUtil.setItemCnt(item_Cnt);

   Date today = new Date(System.currentTimeMillis());
	try {
		if(strFromDate!=null) fromDate = sdf.parse(strFromDate);
		else fromDate = today;

		if(strToDate!=null)   toDate   = sdf.parse(strToDate);
		else toDate   = today;

   } catch (Exception e) {

	}
   
	EbHandler eh = new EbHandler();
	QueryCondition qc = new QueryCondition();
	qc.add("fromDate", sdf.format(fromDate));
	qc.add("toDate", sdf.format(toDate));

	// where
	if (!strAction.equals(""))
		qc.add("action", strAction);
	if (!strCpaId.equals(""))
		qc.add("cpa_id", strCpaId);
	if (!strStatus.equals(""))
		qc.add("status", Integer.valueOf(strStatus));
	if (!strMsgId.equals(""))
		qc.add("message_id", strMsgId);
	if (!"".equals(strType)) {
		qc.add("bound_for", Integer.valueOf(strType));
	}
	
	totalRows = eh.getMessageNum(qc);

	// start, end
	qc.add("start", new Integer(PagingMgtUtil.getStartRow(curPage)));
	qc.add("end", new Integer(PagingMgtUtil.getEndRow(curPage)));
	array = eh.getMessages(qc);
	size = array.size();

	JSONObject json = new JSONObject();
	JSONArray messages = new JSONArray();
	json.put("messages", messages);
	json.put("curpage", curPage);
	json.put("totalRows", totalRows);
	json.put("item_cnt", item_Cnt);


	EbMessageVO msgVO = null;

	String inoutStr = null;
	String statusStr = null;

	json.put("pagelist", PagingMgtUtil.GetPageIndexForScript(curPage,totalRows,"javascript:searchMessage"));

	for (int i=0; i< size; i++) {

      msgVO = (EbMessageVO) array.get(i);

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

      message.put("obid", msgVO.getObid());
      message.put("inout", type);
      message.put("status", EbConstants.getMessageStatusString(msgVO.getStatus()));
      message.put("time", sd.format(msgVO.getTimestamp()));
      message.put("cpaid", msgVO.getCpaId());
      message.put("service", msgVO.getService());
      message.put("action", msgVO.getAction());
      message.put("messageid", msgVO.getMessageId());

      messages.put(message);
	}
	out.print(json);
%>
