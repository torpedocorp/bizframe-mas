<%@ page import="java.util.ArrayList"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.ServiceBindingVO" %>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.CpaVO"%>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.ActionVO"%>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.AppPerformerVO"%>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="kr.co.bizframe.mxs.ebms.EbConstants"%>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%
	/**
	 * @author Gemini Kim
	 * @author Ho-Jin Seo
	 * @author Mi-Young Kim
	 * @version 1.0
	 */

	// ============ get cpaList ================
	String cpa_obid	 = request.getParameter("cpa.obid");

	int totalRows  = 0;

	ArrayList performerVOList				  = null;
	CpaVO cpaVO	 = null;

	ServiceBindingVO  serviceBindingVO  = null;
	ArrayList actionVOList				  = null;
	ActionVO actionVO						 = null;
	AppPerformerVO performerVO			 = null;
	// CanSend 밑의 CanReceive 를 구분하기 위한 식별자 변수... "(*)" 로 표시함...
	//String optional_flag					 = null;

	MxsEngine engine  = MxsEngine.getInstance();
	QueryCondition qc = new QueryCondition();

	qc.add("obid", cpa_obid);
	cpaVO = (CpaVO)engine.getObject("Cpa", qc, DAOFactory.EBMS);


	qc = new QueryCondition();
	qc.add("cpa_obid", cpa_obid);
	qc.add("party_name", cpaVO.getPartyName());
	serviceBindingVO = (ServiceBindingVO)engine.getObject("ServiceBinding", qc, DAOFactory.EBMS);

	qc = new QueryCondition();
	qc.add("service_binding_obid", serviceBindingVO.getObid());
	actionVOList = (ArrayList)engine.getObjects("Action", qc, DAOFactory.EBMS);

	qc = new QueryCondition();
	qc.add("servicebinding.obid", serviceBindingVO.getObid());
	performerVOList = (ArrayList)engine.getObjects("AppPerformer", qc, DAOFactory.EBMS);

	if(performerVOList==null)
		performerVOList = new ArrayList();

	int service_action_num  = actionVOList.size();
	int performer_size		= performerVOList.size();

	totalRows = actionVOList.size();

	JSONObject json		= new JSONObject();
	JSONArray json_array = new JSONArray();

	json.put("list", json_array);
	json.put("totalRows", totalRows);
	json.put("cpaid", cpaVO.getCpaId());
	json.put("cpaName", cpaVO.getCpaName());
	json.put("cpaRole", cpaVO.getPartyName());

	// CPA, Service 밑에 있는 모든 Action 에 대해서 Performer 를 설정함...
	// Action에 해당하는 Performer가 없는 경우는 [performerVO.setPerformerName("UnDefined");] 로 해서
	// 신규로 생성하여 performerVOList[ArrayList]에 추가함...

	for(int i=0; i<service_action_num; i++) {
		boolean find = false;
		actionVO = (ActionVO)actionVOList.get(i);

		if(actionVO.getType() == EbConstants.ACTION_CANSEND) {
			continue;
		}
		// cansend의 canreceive는 dispacher로 안넘기기로했음 by MY-Kim on 2008.03.14
		// cansend의 canreceive도 performer가 설정되어있으면 thread로 dispatcher넘기도록  by MY-Kim on 2008.11.27
	    /*if(actionVO.getParentObid() != null && actionVO.getParentObid().length() > 0) {
	    	continue;
	    }*/
		//optional_flag = actionVO.getParentObid() != null?optional_flag="(*)":"";
		for(int j=0; j<performer_size; j++) {
			performerVO = (AppPerformerVO)performerVOList.get(j);
			if(performerVO.getCanReceiveObid().equals(actionVO.getObid())) {
				find = true;
				performerVO.setAction(actionVO.getAbAction());
				break;
			}
		}

		if(!find) {
			performerVO = new AppPerformerVO();
			performerVO.setCpaId(cpaVO.getObid());
			performerVO.setService(serviceBindingVO.getService());
			performerVO.setServiceBindingObid(serviceBindingVO.getObid());
			performerVO.setCanReceiveObid(actionVO.getObid());
			performerVO.setAppType(EbConstants.APP_PERFORMER);
			//performerVO.setPerformerName("UnDefined");
			performerVO.setPerformerName("");
			performerVO.setAction(actionVO.getAbAction());
			performerVOList.add(performerVO);
		}

		JSONObject jsonObj = new JSONObject();
		jsonObj.put("cpaObid",		cpaVO.getObid());
		jsonObj.put("service",		performerVO.getService());
		jsonObj.put("serviceObid",	performerVO.getServiceBindingObid());
		jsonObj.put("actionObid",	performerVO.getCanReceiveObid());
		jsonObj.put("appType",		performerVO.getAppType());
		jsonObj.put("performObid",	performerVO.getObid());
		jsonObj.put("performName",	StringUtil.nullCheck(performerVO.getPerformerName()));
		// by bumma on 2008.05.22 channelObid 추가(기존에 빠져있어서 로긴후 처음으로 수정버튼을 누르면 채널정보사라짐 버그)
		jsonObj.put("channelObid",	performerVO.getQueueObid());
		jsonObj.put("action",		performerVO.getAction());

		String perform_selected = performerVO.getAppType()==EbConstants.APP_PERFORMER?" selected":"";
		String channel_selected = performerVO.getAppType()==EbConstants.APP_CONSUMEER_QUEUE?" selected":"";
		String remote_selected = performerVO.getAppType()==EbConstants.APP_REMOTE_PERFORMER?" selected":"";
		String visible_val		= channel_selected.equals("selected")?"visible":"hidden";
		jsonObj.put("visible",			visible_val);

		jsonObj.put("perform_selected",			  perform_selected);
		jsonObj.put("channel_selected",			  channel_selected);
		jsonObj.put("remote_selected",			  remote_selected);
		json_array.put(jsonObj);
	}
	out.print(json);
%>
