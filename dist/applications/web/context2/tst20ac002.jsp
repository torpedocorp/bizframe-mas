<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.web.I18nStrings" %>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.ServiceBindingVO" %>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.PartyIdVO" %>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.CpaVO" %>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.ActionVO" %>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.ActionToDcRelVO" %>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.TransportVO" %>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.EndpointVO" %>
<%@ page import="kr.co.bizframe.mxs.ebms.dto.DeliveryChannelVO" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%
/**
 * Self-test ¿ë cpa Äõ¸®
 *
 * @author Ho-Jin Seo
 * @version 1.0
 */
// ============ get subscribers list ================
	I18nStrings _i18n = I18nStrings.getInstance();
	MxsEngine engine = MxsEngine.getInstance();

   String cpa_obid   = request.getParameter("obid");
   CpaVO cpa = null;

   ArrayList services = new ArrayList();
   ArrayList transports = new ArrayList();
   ArrayList partyIds = new ArrayList();
   ArrayList doc_exts = new ArrayList();
   ArrayList deliveries = new ArrayList();

   String myPartyId = "";
   String fromPartyId = "";
   String fromPartyIdType = "";
   String toPartyId = "";
   String toPartyIdType = "";

	JSONObject json      = new JSONObject();
	JSONArray jparty_array = new JSONArray();
	JSONArray jservice_array = new JSONArray();
	JSONArray jtransport_array = new JSONArray();
	JSONArray jdocext_array = new JSONArray();
	JSONArray jdelivery_array = new JSONArray();

   try {

      QueryCondition qc = new QueryCondition();
      qc.add("obid", cpa_obid);
      cpa = (CpaVO)engine.getObject("Cpa", qc, DAOFactory.EBMS);

	  qc = new QueryCondition();
      qc.add("cpa_obid", cpa_obid);
      services = engine.getObjects("ServiceBinding", qc, DAOFactory.EBMS);

      qc = new QueryCondition();
      qc.add("cpa_obid", cpa_obid);
      transports = engine.getObjects("Transport", qc, DAOFactory.EBMS);

      qc = new QueryCondition();
      qc.add("cpa_obid", cpa_obid);
      doc_exts = engine.getObjects("DocExchange", qc, DAOFactory.EBMS);

      qc = new QueryCondition();
      qc.add("cpa_obid", cpa_obid);
      deliveries = engine.getObjects("DeliveryChannel", qc, DAOFactory.EBMS);

      qc = new QueryCondition();
      qc.add("cpa_obid", cpa_obid);
      partyIds = engine.getObjects("PartyId", qc, DAOFactory.EBMS);

      for (int i=0; i< partyIds.size(); i++) {
    	  PartyIdVO vo = (PartyIdVO) partyIds.get(i);
    	  if (vo.getMine() == 1 ) {
    		  fromPartyId = vo.getPartyId();
    		  fromPartyIdType = vo.getType();
    	  } else {
    		  toPartyId = vo.getPartyId();
    		  toPartyIdType = vo.getType();
    	  }
      }

  	  for (int i=0; i<services.size(); i++) {
        ServiceBindingVO vo = (ServiceBindingVO) services.get(i);

        JSONObject serviceJS = new JSONObject();
        serviceJS.put("obid", vo.getObid());
        serviceJS.put("service", vo.getService());
        serviceJS.put("role", vo.getRoleHref());
        serviceJS.put("party_name", vo.getPartyName());

        JSONArray action_array = new JSONArray();
        serviceJS.put("action",  action_array);

        qc = new QueryCondition();
        qc.add("service_binding_obid", vo.getObid());
        qc.add("type", new Integer(0));	// CanReceive
        ArrayList actions = engine.getObjects("Action", qc, DAOFactory.EBMS);

        for(int k=0; k<actions.size(); k++) {
      	  ActionVO action = (ActionVO) actions.get(k);

      	if (action.getParentObid() != null && !"".equals(action.getParentObid()))
    		continue;

    	  JSONObject actionJS = new JSONObject();
      	  actionJS.put("name", action.getAbAction());
      	  actionJS.put("obid", action.getObid());

          qc = new QueryCondition();
          qc.add("action_obid", action.getObid());
          ArrayList dcrels = engine.getObjects("ActionToDcRel", qc, DAOFactory.EBMS);

          JSONArray rels_array = new JSONArray();
          for(int m=0; m<dcrels.size(); m++) {
          	JSONObject relJS = new JSONObject();
          	ActionToDcRelVO dcrelVO = (ActionToDcRelVO) dcrels.get(m);
          	relJS.put("delivery_channel_obid", dcrelVO.getDeliveryChannelObid());
          	rels_array.put(relJS);
          }
          actionJS.put("dcrel", rels_array);
      	  action_array.put(actionJS);
        }
        jservice_array.put(serviceJS);
  	}

  	  for (int i=0; i<transports.size(); i++) {
  		TransportVO vo = (TransportVO) transports.get(i);

          JSONObject transportJS = new JSONObject();
          transportJS.put("obid", vo.getObid());
          transportJS.put("id", vo.getTransportId());

          JSONArray endpoint_array = new JSONArray();
          transportJS.put("endpoint",  endpoint_array);

          qc = new QueryCondition();
          qc.add("transport_obid", vo.getObid());
          ArrayList endpoints = engine.getObjects("Endpoint", qc, DAOFactory.EBMS);

          for(int k=0; k<endpoints.size(); k++) {
        	  JSONObject endpointJS = new JSONObject();
        	  EndpointVO endpoint = (EndpointVO) endpoints.get(k);
        	  endpointJS.put("uri", endpoint.getUri());
        	  endpointJS.put("obid", endpoint.getObid());
        	  endpoint_array.put(endpointJS);
          }

          jtransport_array.put(transportJS);
    	}

  	  for (int i=0; i<deliveries.size(); i++) {
  		DeliveryChannelVO vo = (DeliveryChannelVO) deliveries.get(i);

            JSONObject deliveryJS = new JSONObject();
            deliveryJS.put("obid", vo.getObid());
            deliveryJS.put("id", vo.getChannelId());
            deliveryJS.put("transport_obid", vo.getTransportObid());
            deliveryJS.put("doc_exchange_obid", vo.getDocExchangeObid());

            jdelivery_array.put(deliveryJS);
      	}

	  	json.put("service",        jservice_array);
		json.put("transport",        jtransport_array);
		json.put("doc_ext",        jdocext_array);
		json.put("delivery",        jdelivery_array);
	    json.put("toPartyId", fromPartyId);
	    json.put("toPartyIdType", fromPartyIdType);
	    json.put("fromPartyId", toPartyId);
	    json.put("fromPartyIdType", toPartyIdType);
	    json.put("partyName", cpa.getPartyName());

   } catch (Exception e) {
      e.printStackTrace();
   }

	out.print(json);
%>

