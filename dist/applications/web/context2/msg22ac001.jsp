<%@ page contentType="text/xml; charset=EUC-KR" language="java"%>
<%@ page import="java.io.FileInputStream"%>
<%@ page import="java.io.ByteArrayInputStream"%>
<%@ page import="java.io.BufferedInputStream"%>
<%@ page import="java.io.BufferedOutputStream"%>
<%@ page import="java.io.File"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.EbMessageVO"%>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.SpamLetterVO" %>
<%@ page import="kr.co.bizframe.mxs.common.MxsObject" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.mxs.ebms.model.EbMessage"%>
<%@ page import="kr.co.bizframe.mxs.ebms.parser.EbParser"%>
<%@ page import="kr.co.bizframe.mxs.dto.PartInfoVO"%>
<%
 /**
 * @author Gemini Kim
   @author MiYoung Kim
 * @version 1.0
 */
      String s_obid = request.getParameter("s_obid");
      String p_obid = request.getParameter("p_obid");
      String type = request.getParameter("type");
      String msgId = request.getParameter("msgId");
      
      String value = null;
      String key = null;
      if (s_obid == null && msgId != null ) {
      	key = "message_id";
      	value = msgId;
      	type = "message";
      } 
      else {
      	key = "obid";
      	value = s_obid;
      }
      
      QueryCondition qc = new QueryCondition();
      qc.add(key, value);

	  // 변경내역_40
      EbMessageVO msgVO = null;
      MxsEngine engine = MxsEngine.getInstance();
      MxsObject obj = engine.getObject("Message", qc, DAOFactory.EBMS);
      if (obj == null ) {
   	    // find in spam letter
	   	   obj = engine.getObject("SpamLetter", qc, DAOFactory.EBMS);
      }
      if (obj != null) {
    	  if (obj instanceof EbMessageVO) {
    		  msgVO = (EbMessageVO)obj;
    	  } else if(obj instanceof SpamLetterVO) {
    		  SpamLetterVO vo = (SpamLetterVO)obj;
    		  msgVO = new EbMessageVO();
    		  msgVO.setContentType(vo.getContentType());
    		  msgVO.setContent(vo.getContent());
    		  msgVO.setObid(vo.getObid());
    	  }
      }

      if (msgVO != null) {
  	    EbMessage ebMsg = (EbMessage)new EbParser().createMessage(msgVO);
  	    BufferedInputStream bis = null;
  	    File file = null;
  	    byte[] content = null;
  		if (type.equals("message")) {
  		    //response.setContentType(ebMsg.getHeaderContainer().getContentType());
  		    response.setContentType("text/xml;charset=utf-8");
  			content = ebMsg.getHeaderContainer().getContent();
  			bis = new BufferedInputStream(new ByteArrayInputStream(content));
  		} else {
  			PartInfoVO partInfo = null;
  			for (int i=0; i < msgVO.getPartInfos().size(); i++) {
  			 	partInfo = (PartInfoVO)msgVO.getPartInfos().get(i);
  			 	if (partInfo.getObid().equals(p_obid)) {
  			 		response.setContentType(ebMsg.getPayloadContainer(partInfo.getContentId()).getContentType());
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