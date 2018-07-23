<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine" %>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.MpcBindingVO" %>
<%@ page import="kr.co.bizframe.mxs.web.I18nStrings"%>
<%@ page import="org.json.JSONObject" %>
<%@ page import="java.util.ArrayList"%>
<%
/**
 * Store MPC-CPA Relation
 *
 * @author Mi-Young Kim
 * @version 1.0 2008.10.02
 */

 JSONObject json = new JSONObject();
 I18nStrings _i18n = I18nStrings.getInstance();
 String cpaObid = request.getParameter("cpaObid");
 String[] mpcObid_arr = request.getParameterValues("mpcObid");
 String[] actionObid_arr = request.getParameterValues("actionObid");
 try {
    ArrayList bindings = new ArrayList();
    bindings.add(cpaObid);

    if(mpcObid_arr != null) {
        for (int i = 0; i <mpcObid_arr.length; i++) {
            String mpcObid = mpcObid_arr[i];
            String actionObid = actionObid_arr[i];
            if (mpcObid != null && mpcObid.length() > 0
         		   && actionObid != null && actionObid.length() > 0) {
         	   MpcBindingVO vo = new MpcBindingVO();
         	   vo.setMpcObid(mpcObid);
         	   vo.setActionObid(actionObid);

         	   // 이건 기존에 있었는데 삭제했을때를 알수가 없음
         	   /*qc = new QueryCondition();
         	   qc.add("action_obid", actionObid);
         	   ArrayList list = MxsEngine.getInstance().getObjects("MpcBinding", qc, DAOFactory.EBMS3);
         	   if (list == null || list.size() == 0) {
         		   MxsEngine.getInstance().insertObject("MpcBinding", vo, DAOFactory._EBMS3);
         	   } else {
         		   for (Iterator j = list.iterator(); j.hasNext();) {
         			   MpcBindingVO binding = (MpcBindingVO) j.next();
         			   if (binding.getMpcObid().equals(mpcObid)) {
         				   continue;
         			   } else {
         				   MxsEngine.getInstance().insertObject("MpcBinding", vo, DAOFactory.EBMS3);
         			   }
         		   }
         	   }*/

         	   // 일단 모두 삭제하고 새로 입력하는걸로 구현
         	   bindings.add(vo);
            }
         }
    }

    // 저장
    MxsEngine.getInstance().insertObjects("MpcBinding", bindings, DAOFactory.EBMS3);
    json.put("msg", _i18n.get("mpc21ms002.operation.insert"));
	out.print(json);

 } catch (Exception e) {
    e.printStackTrace();
 }
%>
