<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.wsms.dto.WsAppPerformerVO"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.BizFrame"%>
<%
/**
 * @author Ho-Jin Seo
 * @version 1.0
 */

// ============ update performer ================
    MxsEngine engine = MxsEngine.getInstance();
	String obid = request.getParameter("obid");
	String performer = request.getParameter("performerClass");
	String performerType= request.getParameter("type");
	String idx_count = request.getParameter("idx_count");
	String wsdlName = request.getParameter("wsdlName");
	int size = 0;

	if (obid != null && performer != null) {	// 1 °Ç update
		QueryCondition qc =  new QueryCondition();
		qc.add("operation_obid", obid);
		WsAppPerformerVO vo =  (WsAppPerformerVO)engine.getObject("WsAppPerformer", qc, DAOFactory.WSMS);
		if (vo == null)  {
			vo =  new WsAppPerformerVO();
			vo.setCreatedBy(BizFrame.SYSTEM_USER_OBID);
			vo.setOperationObid(obid);
			vo.setPerformerName(performer);
			vo.setPerformerType(Integer.parseInt(performerType));
			engine.insertObject("WsAppPerformer", vo, DAOFactory.WSMS);
		}  else {
			vo.setPerformerName(performer);
			vo.setPerformerType(Integer.parseInt(performerType));
			vo.setModifiedBy(vo.getCreatedBy());
			engine.updateObject("WsAppPerformer", vo, DAOFactory.WSMS);
		}

	} else {
		size = Integer.parseInt(idx_count);
		for (int i=0; i<size; i++) {
			obid = request.getParameter("operationId" + i);
			performer = request.getParameter("performerName" + i);
			performerType = request.getParameter("performerType" + i);

			QueryCondition qc =  new QueryCondition();
			qc.add("operation_obid", obid);
			WsAppPerformerVO vo =  (WsAppPerformerVO)engine.getObject("WsAppPerformer", qc, DAOFactory.WSMS);
			if (vo == null)  {
				vo =  new WsAppPerformerVO();
				vo.setCreatedBy(BizFrame.SYSTEM_USER_OBID);
				vo.setOperationObid(obid);
				vo.setPerformerName(performer);
				vo.setPerformerType(Integer.parseInt(performerType));
				engine.insertObject("WsAppPerformer", vo, DAOFactory.WSMS);
			}  else {
				vo.setPerformerName(performer);
				vo.setPerformerType(Integer.parseInt(performerType));
				vo.setModifiedBy(vo.getCreatedBy());
				engine.updateObject("WsAppPerformer", vo, DAOFactory.WSMS);
			}
		}
	}
%>

