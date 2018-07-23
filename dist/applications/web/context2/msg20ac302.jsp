<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory" %>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.Eb3Constants" %>
<%@ page import="kr.co.bizframe.mxs.common.MxsObject" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.AgreementRef"%>
<%
/**
 * AgreementRef 목록 구하기
 *
 * @author Ho-Jin Seo
 * @version 1.0
 */
// ============ get agreementRef list ================
   MxsEngine engine = MxsEngine.getInstance();
   ArrayList agreement_array = new ArrayList();

   try {
      QueryCondition qc = new QueryCondition();
      agreement_array = engine.getObjects("Eb3AgreementRef", qc, DAOFactory.EBMS3);
      session.setAttribute("agreementlist", agreement_array);
   } catch (Exception e) {
      e.printStackTrace();
   }

   JSONObject json   = new JSONObject();
   JSONArray agreementRefs  = new JSONArray();
   json.put("agreementlist", agreementRefs);

   for (int i = 0; i < agreement_array.size(); i++) {

      JSONObject cpas   = new JSONObject();
      MxsObject obj = (MxsObject) agreement_array.get(i);
      AgreementRef vo = (AgreementRef)obj.getExtension(Eb3Constants.MXSOBJ_EXTENSION_AGREEMENT_REF);

      cpas.put("obid", vo.getObid());
      cpas.put("agreement_ref", vo.getContent());
      cpas.put("agreement_ref_type", vo.getType());
      cpas.put("agreement_ref_pmode", vo.getPMode());
      cpas.put("ref_type", vo.getRefType());
      cpas.put("ref_obid", vo.getRefObid());
      agreementRefs.put(cpas);
   }
   out.print(json);

%>
