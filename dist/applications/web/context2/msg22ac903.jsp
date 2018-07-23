<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.dto.PartInfoVO"%>
<%@ page import="kr.co.bizframe.mxs.wsms.dto.WsMessageVO"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.mxs.wsms.model.WsMessage"%>
<%@ page import="kr.co.bizframe.mxs.wsms.parser.WsParser"%>
<%@ page import="kr.co.bizframe.mxs.web.I18nStrings"%>
<%@ page import="kr.co.bizframe.mxs.common.MxsObject"%>
<%@ page import="java.io.FileInputStream"%>
<%@ page import="java.io.ByteArrayInputStream"%>
<%@ page import="java.io.BufferedInputStream"%>
<%@ page import="java.io.BufferedOutputStream"%>
<%@ page import="java.io.File"%>
<%
	/**
	 * view message or payload for bfm
	 *
	 * @author Mi-Young Kim
	 * @version 1.0
	 */
	String s_obid = request.getParameter("s_obid");
	String p_obid = request.getParameter("p_obid");
	String type = request.getParameter("type");

	String value = null;
	String key = null;

	QueryCondition qc = new QueryCondition();
	qc.add("obid", s_obid);

	// 변경내역_40
	MxsEngine engine = MxsEngine.getInstance();
	WsMessageVO msgVO = (WsMessageVO)engine.getObject("WsMessage", qc,
			DAOFactory.WSMS);
	if (msgVO == null) {
		out.print("본문 정보를 찾지 못했습니다. Message_Obid: " + s_obid);
		return;
	}

	WsMessage ebMsg = (WsMessage)new WsParser().createMessage(msgVO);
	BufferedInputStream bis = null;
	File file = null;
	byte[] content = null;
	if (type.equals("message")) {
		response.setContentType("text/xml;charset=utf-8");
		content = ebMsg.getHeaderContainer().getContent();
		bis = new BufferedInputStream(new ByteArrayInputStream(content));
		
	} else {
		PartInfoVO partInfo = null;
		for (int i = 0; i < msgVO.getPartInfos().size(); i++) {
			partInfo = (PartInfoVO)msgVO.getPartInfos().get(i);
			if (partInfo.getObid().equals(p_obid)) {
				response.setContentType(ebMsg.getPayloadContainer(
						partInfo.getContentId()).getContentType());
				file = new File(partInfo.getPartFilePath());
				bis = new BufferedInputStream(new FileInputStream(file));
				break;
			}
		}
		if (bis == null) {
			out.print("첨부 정보를 찾지 못했습니다. Payload_Obid: " + p_obid);
			return;
		}
	}

	BufferedOutputStream bos = new BufferedOutputStream(response.getOutputStream());
	int read = 0;

	try {
		byte[] buf = new byte[4096];

		while ((read = bis.read(buf)) != -1) {
			bos.write(buf, 0, read);
		}
		bos.close();
		bis.close();
	} catch (Exception e) {
		throw e;
	} finally {
		if (bos != null)
			bos.close();
		if (bis != null)
			bis.close();
	}
%>
