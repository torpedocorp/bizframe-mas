<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.dto.PartInfoVO"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.EbMessageVO"%>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.SpamLetterVO" %>
<%@ page import="kr.co.bizframe.mxs.MxsConstants"%>
<%@ page import="kr.co.bizframe.mxs.ebms.EbConstants"%>
<%@ page import="kr.co.bizframe.mxs.common.MxsObject" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="java.util.ArrayList" %>
<%
 /**
 * @author Gemini Kim
 * @author Mi-Young Kim
 * @version 1.0
 */
// ============ get messageList ================
   String obid = request.getParameter("msg.obid");
   String id = request.getParameter("msg.id");
   String refId = request.getParameter("msg.refId");
   SimpleDateFormat sd = new SimpleDateFormat("yyyy.MM.dd HH:mm:ss");
   MxsEngine engine = MxsEngine.getInstance();
   QueryCondition qc = new QueryCondition();
   if (id != null && id.length() > 0 && !id.equalsIgnoreCase("null")) {
	   qc.add("message_id", id);
   } else if (refId != null && refId.length() > 0 && !refId.equalsIgnoreCase("null")) {
	   qc.add("ref_to_message_id", refId);
   } else {
	   qc.add("obid", obid);
   }
	// 변경내역_40
   MxsObject obj = engine.getObject("Message", qc, DAOFactory.EBMS);
   if (obj == null ) {
	   // find in spam letter
	   obj = engine.getObject("SpamLetter", qc, DAOFactory.EBMS);
   }

   if (obj != null) {
	    JSONObject json = new JSONObject();
	    JSONArray json_array = new JSONArray();
	    String msgObid = null;
	    String msgId = null;
	    String cpaId = null;
	    int inOut = -1;
	    String serviceName = null;
	    String actionName = null;
	    String timeStamp = null;
	    String status = null;
	    String referralMsgId = null;
	    String referrerMsgId = null;
	    String comment = null;
		ArrayList partInfos = null;
		String type = "EbMessage";
		if (obj instanceof EbMessageVO) {
			EbMessageVO vo = (EbMessageVO)obj;
			msgObid = vo.getObid();
			msgId = vo.getMessageId();
			cpaId = vo.getCpaId();
			inOut = vo.getBoundFor();
			serviceName = vo.getService();
			actionName = vo.getAction();
			timeStamp = sd.format(vo.getTimestamp());
			status = EbConstants.getMessageStatusString(vo.getStatus());
			referralMsgId = vo.getRefToMessageId()==null? "" : vo.getRefToMessageId();

			// Mi-Young Kim on 2008.09.05 본 메시지를 참조하는 메시지
			qc = new QueryCondition();
			qc.add("ref_to_message_id", vo.getMessageId());
			EbMessageVO referrerMsgVO = (EbMessageVO)engine.getObject("Message", qc, DAOFactory.EBMS);
			if (referrerMsgVO != null) {
				referrerMsgId = referrerMsgVO.getMessageId()==null? "" : referrerMsgVO.getMessageId();
			}

			comment = vo.getUserComment()==null? "" : vo.getUserComment();
			partInfos = vo.getPartInfos();

		} else if (obj instanceof SpamLetterVO) {
			SpamLetterVO vo = (SpamLetterVO)obj;
			msgObid = vo.getObid();
			msgId = vo.getMessageId();
			cpaId = vo.getCpaId();
			inOut = MxsConstants.MESSAGE_BOUND_FOR_IN;
			serviceName = vo.getService();
			actionName = vo.getAction();
			timeStamp = sd.format(vo.getTimestamp());
			status = EbConstants.getMessageStatusString(EbConstants.MESSAGE_STATUS_RECEIVED);
			referralMsgId = vo.getRefToMessageId()==null? "" : vo.getRefToMessageId();
			// Mi-Young Kim on 2008.09.05 본 메시지를 참조하는 메시지
			qc = new QueryCondition();
			qc.add("ref_to_message_id", vo.getMessageId());
			EbMessageVO referrerMsgVO = (EbMessageVO)engine.getObject("Message", qc, DAOFactory.EBMS);
			if (referrerMsgVO != null) {
				referrerMsgId = referrerMsgVO.getMessageId()==null? "" : referrerMsgVO.getMessageId();
			}
			comment = "SpamLetter Message";
			type = "SpamLetter";
		}

		json.put("obid",        msgObid);
		json.put("msgId",       msgId);
		json.put("cpaId",       cpaId);
		json.put("inOut",       inOut);
		json.put("serviceName", serviceName);
		json.put("actionName",  actionName);
		json.put("timeStamp",   timeStamp);
		json.put("status",      status);
		json.put("referralid", referralMsgId);
		json.put("referrerid", referrerMsgId);
		json.put("comment", comment);
		json.put("msgType", type);
	    json.put("list",        json_array);
		if (partInfos != null) {

			for (int i=0; i<partInfos.size(); i++) {
				PartInfoVO partVO = (PartInfoVO)partInfos.get(i);
			      JSONObject json_obj = new JSONObject();
			      
			      json_obj.put("no",          (i+1));
			      json_obj.put("contentId",    partVO.getContentId());
			      json_obj.put("contentType",  partVO.getContentType());
			      json_obj.put("description",  partVO.getDescription()==null?"":partVO.getDescription());
			      json_obj.put("obid",         partVO.getObid());

			      json_array.put(json_obj);
			   }
		}
		out.print(json);
  }
%>
