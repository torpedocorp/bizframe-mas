<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.ServiceBindingVO"%>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.CpaVO"%>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.ActionVO"%>
<%@ page import="kr.co.bizframe.mxs.ebms.EbConstants"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.MpcVO"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<%
/**
 * @author Mi-Young Kim
 * @version 1.0 2008.10.01
 */
	String cpa_obid	 = request.getParameter("cpaObid");

	MxsEngine engine  = MxsEngine.getInstance();
	QueryCondition qc = new QueryCondition();

	// 1. getCpaVO
	qc.add("obid", cpa_obid);
	CpaVO cpaVO = (CpaVO)engine.getObject("Cpa", qc, DAOFactory.EBMS);


	qc = new QueryCondition();
	qc.add("cpa_obid", cpa_obid);
	ArrayList sbList = engine.getObjects("ServiceBinding", qc, DAOFactory.EBMS);
	ServiceBindingVO mySb = null;
	ServiceBindingVO partnerSb = null;
	// TODO 일단 한 cpaid에 해당하는 serviceBinding은 두개만 있다는 가정하에서 만듬
	for (Iterator i = sbList.iterator(); i.hasNext();) {
		ServiceBindingVO vo = (ServiceBindingVO) i.next();
		if (vo.getPartyName().equalsIgnoreCase(cpaVO.getPartyName())) {
			mySb = vo;
		} else {
			partnerSb = vo;
		}
	}
	if (mySb == null || partnerSb == null) {
		throw new Exception("Cannot get ServiceBindingVO");
	}

    // 2. getCansend for LocalMpc
	qc = new QueryCondition();
	qc.add("service_binding_obid", mySb.getObid());
	qc.add("type", new Integer(EbConstants.ACTION_CANSEND));
	ArrayList localMpcActionList = (ArrayList)engine.getObjects("Action", 1, qc, DAOFactory.EBMS);

	// 3. getCansend for RemoteMpc
	qc = new QueryCondition();
	qc.add("service_binding_obid", partnerSb.getObid());
	qc.add("type", new Integer(EbConstants.ACTION_CANSEND));
	ArrayList remoteMpcActionList = (ArrayList)engine.getObjects("Action", 1, qc, DAOFactory.EBMS);

	JSONObject json		= new JSONObject();
	JSONArray local_array = new JSONArray();
	JSONArray remote_array = new JSONArray();

	json.put("localList", local_array);
	json.put("remoteList", remote_array);
	json.put("cpaid", cpaVO.getCpaId());
	json.put("cpaName", cpaVO.getCpaName());
	json.put("cpaRole", cpaVO.getPartyName());

	// local
	for(int i=0; i< localMpcActionList.size(); i++) {
		ActionVO action = (ActionVO)localMpcActionList.get(i);
	    if(action.getParentObid() != null && action.getParentObid().length() > 0) {
	    	continue;
	    }
    	JSONObject jsonObj = new JSONObject();
		jsonObj.put("service", action.getService());
		jsonObj.put("action", action.getAbAction());
		jsonObj.put("actionObid", action.getObid());

		JSONArray mpc_array = new JSONArray();
		for (Iterator j = action.getMpcList().iterator(); j.hasNext();) {
			MpcVO mpc = (MpcVO) j.next();
			JSONObject obj = new JSONObject();
			String mpcObid = mpc.getObid();
			mpcObid = (mpcObid == null ? "" : mpcObid);
			obj.put("mpcDisplayName", (mpcObid.equals("") ? "" : mpc.getDisplayName()));
			obj.put("mpcObid", mpcObid);
			mpc_array.put(obj);
		}
		jsonObj.put("mpcList", mpc_array);

		local_array.put(jsonObj);
	}

	// remote
	for(int i=0; i< remoteMpcActionList.size(); i++) {
		ActionVO action = (ActionVO)remoteMpcActionList.get(i);
	    if(action.getParentObid() != null && action.getParentObid().length() > 0) {
	    	continue;
	    }
    	JSONObject jsonObj = new JSONObject();
		jsonObj.put("service", action.getService());
		jsonObj.put("action", action.getAbAction());
		jsonObj.put("actionObid", action.getObid());

		JSONArray mpc_array = new JSONArray();
		for (Iterator j = action.getMpcList().iterator(); j.hasNext();) {
			MpcVO mpc = (MpcVO) j.next();
			JSONObject obj = new JSONObject();
			String mpcObid = mpc.getObid();
			mpcObid = (mpcObid == null ? "" : mpcObid);
			obj.put("mpcDisplayName", (mpcObid.equals("") ? "" : mpc.getDisplayName()));
			obj.put("mpcObid", mpcObid);
			mpc_array.put(obj);
		}
		jsonObj.put("mpcList", mpc_array);

		remote_array.put(jsonObj);
	}
	out.print(json);
%>
