<%@ page contentType="text/xml; charset=EUC-KR" language="java"%>
<%@ page import="java.io.FileInputStream"%>
<%@ page import="java.io.ByteArrayInputStream"%>
<%@ page import="java.io.BufferedInputStream"%>
<%@ page import="java.io.BufferedOutputStream"%>
<%@ page import="java.io.File"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.Eb3Message"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.parser.Eb3Parser"%>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%@ page import="kr.co.bizframe.mxs.soap.PayloadContainer"%>
<%
/**
 * download message
 & @author Ho-Jin Seo
 * @version 1.0
 */
	String obid = StringUtil.nullCheck(request.getParameter("obid"));
	String href = StringUtil.nullCheck(request.getParameter("href"));

	if (!obid.equals("")) {

		MxsEngine engine = MxsEngine.getInstance();
		QueryCondition qc = new QueryCondition();
		qc.add("obid", obid);
		Eb3Message msgVO = (Eb3Message)engine.getObject("Eb3UserMessage", qc, DAOFactory.EBMS3);

		Eb3Parser parser = new Eb3Parser();
		Eb3Message ebMsg = parser.createEbMessage(msgVO);

		BufferedInputStream bis = null;

		response.setContentType("application/octet-stream");
		response.setHeader("Content-Transfer-Encoding", "binary;");

		if (href.equals("")) {
			// soap+xml 은 웹브라우저가 인식못하는 타입
			//response.setContentType(ebMsg.getHeaderContainer().getContentType());
			bis = new BufferedInputStream(new ByteArrayInputStream(ebMsg.getHeaderContainer().getContent()));

			String headerStr = "attachment; filename=" + msgVO.getUserMessageId() + ".xml";
			response.setHeader("Content-Disposition", headerStr);
			//response.setHeader("Content-Length", String.valueOf(ebMsg.getHeaderContainer().getContent().length));

		} else {
			PayloadContainer pc = ebMsg.getPayloadContainer(href);

			String headerStr = "attachment; filename=" + pc.getFileName();
			response.setHeader("Content-Disposition", headerStr);

			File file = new File(pc.getContentPath());
			//response.setHeader("Content-Length", String.valueOf(file.length()));

			bis = new BufferedInputStream(new FileInputStream(file));
		}

		BufferedOutputStream bos = new BufferedOutputStream(response.getOutputStream());

		int read = 0;
		try {
			byte[] buf = new byte[4096];

			while ((read = bis.read(buf)) != -1) {
			bos.write(buf,0,read);
			}
			bos.close();
			bis.close();
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			if(bos != null) bos.close();
			if(bis != null) bis.close();
		}

	}
%>