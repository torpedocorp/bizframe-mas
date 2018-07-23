<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.wsms.model.Wsdl" %>
<%@ page import="kr.co.bizframe.mxs.wsms.WsdlManager" %>
<%@ page import="kr.co.bizframe.mxs.web.I18nStrings" %>
<%@ page import="kr.co.bizframe.BizFrame" %>
<%
/**
 * Insert WSDL
 *
 * @author Ho-Jin Seo
 * @version 1.0
 */
I18nStrings _i18n = I18nStrings.getInstance();
session = request.getSession(false);	
String wsdlName = request.getParameter("wsdlName");
String keystoreObid = request.getParameter("keystore");	
String actionUrl = "wsd20ms001.jsp"; 	
String msg = "";

int beClient = 1;

Wsdl vo = (Wsdl) session.getAttribute("wsdlVO");
vo.setName(wsdlName);
vo.setKeystoreObid(keystoreObid);
vo.setBeClient(beClient);
vo.setCreatedBy(BizFrame.SYSTEM_USER_OBID);


//ServletContext ctx = session.getServletContext();	
//ServletMapper mapper = new ServletMapper(ctx.getRealPath(""), wsdlName);
//mapper.add();
// J-.H. Kim on 2008.02.28
//MxsEngine engine = MxsEngine.getInstance();
//engine.storeWsdl("insert", vo);
WsdlManager wsdlMgr = new WsdlManager();
wsdlMgr.storeWsdl("insert", vo);
wsdlMgr.removeCacheWSDL(vo.getName());

%>
