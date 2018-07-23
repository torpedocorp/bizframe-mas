<%@ page contentType="text/xml; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.dto.PartInfoVO"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.mxs.wsms.dto.WsMessageVO"%>
<%@ page import="java.io.File"%>
<%@ page import="java.io.FileInputStream"%>
<%@ page import="java.io.BufferedOutputStream"%>
<%@ page import="java.io.BufferedInputStream"%>
<%
	/**
	 * download payload
	 *
	 * @author Mi-Young Kim
	 * @version 1.0
	 */
	//============ download ================
    String msgId = request.getParameter("msgId");
	if (msgId != null) {
		MxsEngine engine = MxsEngine.getInstance();
		QueryCondition qc = new QueryCondition();
		qc.add("wsa_message_id", msgId);
		WsMessageVO msgVO = (WsMessageVO)engine.getObject("WsMessage", qc, DAOFactory.WSMS);

		if (msgVO == null || msgVO.getPartInfos().size() == 0) {
			throw new Exception("PartInfo is null");
		}

        PartInfoVO partInfo = (PartInfoVO)msgVO.getPartInfos().get(0);
		File file = new File(partInfo.getPartFilePath());

		BufferedInputStream bis = null;
		response.setContentType("application/octet-stream");
		response.setHeader("Content-Transfer-Encoding", "binary;");
		String headerStr = "attachment; filename=" + partInfo.getObid() + ".xml";
		response.setHeader("Content-Disposition", headerStr);

		bis = new BufferedInputStream(new FileInputStream(file));
		//response.setHeader("Content-Length", String.valueOf(file.length()));
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
			e.printStackTrace();
			throw e;
		} finally {
			if (bos != null)
				bos.close();
			if (bis != null)
				bis.close();
		}

	}
%>



