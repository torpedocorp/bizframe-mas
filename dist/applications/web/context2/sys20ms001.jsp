<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.util.ServerProperties" %>
<%@ page import="kr.co.bizframe.mxs.MxsConstants"%>
<%
/**
 * System Properties
 *
 * @author Ho-Jin Seo
 * @version 1.0
 */
%>
<html>
<head>
<%@ include file="./com00in000.jsp" %>
<%@ include file="./com00in003.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>

<%
	ServerProperties props	= ServerProperties.getInstance();
    String AUTHENTICATE_DISABLED	= (String)props.getProperty("mxs.msi.authentication", "false");

    /* 2008.02.04 LOG 는 log4j.properties 에서 설정 */
    String LOG_VERBOSE					= (String)props.getProperty("mxs.log.verbose", "");
    String LOG_FILE_LEVEL				= (String)props.getProperty("mxs.log.file.level", "");
    String LOG_FILE_DIR					= (String)props.getProperty("mxs.log.file.dir", "");
    String LOG_FILE_FILENAME			= (String)props.getProperty("mxs.log..file.filename", "");
    String LOG_FILE_MAXSIZE				= (String)props.getProperty("mxs.log.file.maxsize", "");
    String LOG_CONSOLE_LEVEL			= (String)props.getProperty("mxs.log.console.level", "");

    String HTTP_CONNECTION_TIMEOUT		= (String)props.getProperty("mxs.http.connection.timeout", "");
    String HTTP_TIMEOUT					= (String)props.getProperty("mxs.http.timeout", "");

    String POP3_ENABLED					= (String)props.getProperty("mxs.pop3.enabled", "");
    String POP3_HOST					= (String)props.getProperty("mxs.pop3.host", "");
    String POP3_PORT					= (String)props.getProperty("mxs.pop3.port", "");
    String POP3_FOLDERNAME				= (String)props.getProperty("mxs.pop3.foldername", "");
    String POP3_USERNAME				= (String)props.getProperty("mxs.pop3.username", "");
    String POP3_PASSWORD				= (String)props.getProperty("mxs.pop3.password", "");
    String POP3_INTERVAL				= (String)props.getProperty("mxs.pop3.interval", "");

    String SMTP_HOST					= (String)props.getProperty("mxs.smtp.host", "");
    String SMTP_USERNAME				= (String)props.getProperty("mxs.smtp.username", "");
    String SMTP_PASSWORD				= (String)props.getProperty("mxs.smtp.password", "");

    /* 2008.02.04 keystore 사용안함 */
    String KEYSTORE_TYPE				= (String)props.getProperty("mxs.keystore.type", "");
    String KEYSTORE_FILE				= (String)props.getProperty("mxs.keystore.file", "");
    String KEYSTORE_PASSWD				= (String)props.getProperty("mxs.keystore.passwd", "");

    /* 2008.02.04 sign 사용안함 */
    String SIGN_PRIVATEKEY_ALIAS		= (String)props.getProperty("mxs.sign.privatekey.alias", "");
    String SIGN_PRIVATEKEY_PASSWD		= (String)props.getProperty("mxs.sign.privatekey.passwd", "");

    /* 2008.02.04 monitor 사용안함 */
    String MONITOR_ENABLED				= (String)props.getProperty("mxs.monitor.enabled", "");
    String MONITOR_IP					= (String)props.getProperty("mxs.monitor.ip", "");
    String MONITOR_PORT					= (String)props.getProperty("mxs.monitor.port", "");

    /* 2008.02.04 각 page 에서 사용 */
    String PAGE_COUNT					= (String)props.getProperty("mxs.page.count", "");
    String PAGE_ITEM_COUNT				= (String)props.getProperty("mxs.page.item.count", "");

    /* 2008.02.04 사용안함 */
    String SERVER_IP					= (String)props.getProperty("mxs.server.ip", "");
    String SERVER_PORT   				= (String)props.getProperty("mxs.server.port", "");

	String FILE_STORAGE					= (String)props.getProperty("mxs.file.storage", "");
	String FILES_PER 					= (String)props.getProperty("mxs.files.per.directory", "");

	String MESSAGE_ORDER_SAVE			= (String)props.getProperty("mxs.message.order.save.limit", "");

	String EBSE_EXECUTOR				= (String)props.getProperty("mxs.eb.signature.executor", "");
	String WSSE_EXECUTOR				= (String)props.getProperty("mxs.ws.signature.executor", "");
	String WSSE_HASH					= (String)props.getProperty("mxs.ws.hash.function", "");
	String WSSE_ALGO 					= (String)props.getProperty("mxs.ws.signature.algorithm", "");

	/** 2008.05.02 password must hide */
	String SSL_KEYSTORE					= (String)props.getProperty("mxs.ssl.keystore", "");
	//String SSL_KEYSTORE_PASSWD			= (String)props.getProperty("mxs.ssl.keystore.password", "");
	String SSL_KEYSTORE_PASSWD			= "";
	String SSL_KEYSTORE_TYPE			= (String)props.getProperty("mxs.ssl.keystore.type", "");
	String SSL_TRUST_KEYSTORE			= (String)props.getProperty("mxs.ssl.truststore", "");
	//String SSL_TRUST_KEYSTORE_PASSWD	= (String)props.getProperty("mxs.ssl.truststore.password", "");
	String SSL_TRUST_KEYSTORE_PASSWD 	= "";
	String SSL_TRUST_KEYSTORE_TYPE		= (String)props.getProperty("mxs.ssl.truststore.type", "");

	String LICENSE_KEYSTORE				= (String)props.getProperty("mxs.license.keystore", "");
	String LICENSE_CERT 				= (String)props.getProperty("mxs.license.cert", "");
	String LICENSE_SERVER				= (String)props.getProperty("mxs.license.server.url", "");

	String EBMS_PRE_PROCESSOR			= (String)props.getProperty("mxs.ebmsg.preprocessor", "");
	String EBMS_POST_PROCESSOR			= (String)props.getProperty("mxs.ebmsg.postprocessor", "");
	String WSMS_PRE_PROCESSOR 			= (String)props.getProperty("mxs.wsmsg.preprocessor", "");
	String WSMS_POST_PROCESSOR			= (String)props.getProperty("mxs.wsmsg.postprocessor", "");

    String contextPath = request.getContextPath();
%>

<script language="JavaScript" type="text/JavaScript">
<!--

function updateProperties() {
	msg = "<%=_i18n.get("sys20ms001.env.warn1")%>";
	msg += "\r\n<%=_i18n.get("sys20ms001.env.warn2")%>";

	openConfirm(msg, updateOkFunction, null, "<%=_i18n.get("global.warning")%>");
}

function updateOkFunction() {
	Windows.closeAllModalWindows();
	clearNotify();

	var params = Form.serialize(document.form1);

	openInfo('<%=_i18n.get("global.processing") %>');
	var opt = {
	    method: 'post',
	    postBody: params,
	    onSuccess: function(t) {
	    	closeInfo();
	    	$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("sys20ms001.env.update") %>';
	    	//Dialog.setInfoMessage('<%=_i18n.get("sys20ms001.env.update") %>');
	    },
	    on404: function(t) {
	    	closeInfo();
	        $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("err00zz404.message") %>';
	        //showError('<%=_i18n.get("err00zz404.message") %>', null, null, null);
	    },
	    onFailure: function(t) {
	    	closeInfo();
	        $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("global.error.retry") %>';
	        //showErrorPopup(t.responseText, null, null, null);
	    }
	}

	var myAjax = new Ajax.Request('./sys30ac001.jsp', opt);
}

//-->
</script>
</head>
<body>

<table class="TableLayout">
  <tr>
    <td width="120" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.props.sys")%></td>
    <td width="640" class="MessageDisplay" ><div id=messageDisplay></div></td>
  </tr>
  <tr>
    <td colspan="2" height="6"></td>
  </tr>
</table>

<form name="form1" method="post">

      <table class="TableLayout">
        <tr align="right" valign="middle">
          <td>
          <a href="javascript:updateProperties()"><img src="images/btn_big_save.gif" width="39" height="23" border="0"></a>
          </td>
        </tr>
      </table>
<table class="SearchTable">
  <tr>
    <td width="150" class="SubTitle" colspan="2"><%=_i18n.get("sys20ms001.authentication")%></td>
  </tr>
  <tr>
    <td style="padding:10px">
      <table>
        <tr>
          <td width="150" ><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.authentication.client")%></td>
          <td width="260" >
                    <select name="mxs.msi.authentication" id="mxs.msi.authentication" class="FormText">
                   <%AUTHENTICATE_DISABLED = AUTHENTICATE_DISABLED == null ? "" : AUTHENTICATE_DISABLED;
                     if(AUTHENTICATE_DISABLED.equalsIgnoreCase("true")){
                     %>
                      <option value="true" selected><%=_i18n.get("global.use")%></option>
                     <%}else{%>
                      <option value="true"><%=_i18n.get("global.use")%></option>
                     <%}%>
                     <%if(AUTHENTICATE_DISABLED.equalsIgnoreCase("false")){%>
                      <option value="false" selected><%=_i18n.get("global.not.use")%></option>
                     <%}else{%>
                      <option value="false"><%=_i18n.get("global.not.use")%></option>
                     <%}%>
                  </select>


          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<!-- 2008.02.04 log4j.properties 에서 설정
<table class="SearchTable">
  <tr>
    <td width="150" class="SubTitle" colspan="2"><%=_i18n.get("sys20ms001.log")%></td>
  </tr>
  <tr>
    <td style="padding:10px">
      <table>
        <tr>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.log.file.dir")%></td>
          <td width="260">
            <input name="mxs.log.file.dir" id="mxs.log.file.dir" type="text" value="<%= LOG_FILE_DIR==null?"":LOG_FILE_DIR%>" size="25" maxlength="70">
          </td>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.log.verbose")%></td>
          <td width="260">
            <input name="mxs.log.verbose" id="mxs.log.verbose" type="text" value="<%= LOG_VERBOSE==null?"":LOG_VERBOSE%>" size="25" maxlength="15">
          </td>
        </tr>
        <tr>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.log.file.filename")%></td>
          <td width="260">
            <input name="mxs.log.file.filename" id="mxs.log.file.filename" type="text" value="<%= LOG_FILE_FILENAME==null?"":LOG_FILE_FILENAME%>" size="25" maxlength="15">
          </td>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.log.file.level")%></td>
          <td width="260">
            <input name="mxs.log.file.level" id="mxs.log.file.level" type="text" value="<%= LOG_FILE_LEVEL==null?"":LOG_FILE_LEVEL%>" size="25" maxlength="15">
          </td>
        </tr>
        <tr>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.log.file.maxsize")%></td>
          <td width="260">
            <input name="mxs.log.file.maxsize" id="mxs.log.file.maxsize" type="text" value="<%= LOG_FILE_MAXSIZE==null?"":LOG_FILE_MAXSIZE%>" size="25" maxlength="15">
          </td>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.log.console.level")%></td>
          <td width="260">
            <input name="mxs.log.console.level" id="mxs.log.console.level" type="text" value="<%= LOG_CONSOLE_LEVEL==null?"":LOG_CONSOLE_LEVEL%>" size="25" maxlength="15">
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
-->
<table class="SearchTable">
  <tr>
    <td width="150" class="SubTitle" colspan="2"><%=_i18n.get("sys20ms001.http")%></td>
  </tr>
  <tr>
    <td style="padding:10px">
      <table>
        <tr>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.http.connection.timeout")%></td>
          <td width="260">
            <input name="mxs.http.connection.timeout" id="mxs.http.connection.timeout" type="text" value="<%= HTTP_CONNECTION_TIMEOUT%>" size="25" maxlength="15" class="FormText">
          </td>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.http.timeout")%></td>
          <td width="260">
            <input name="mxs.http.timeout" id="mxs.http.timeout" type="text" value="<%= HTTP_TIMEOUT%>" size="25" maxlength="15" class="FormText">
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<!-- F. DSIG정보 ... -->
<!--
<table class="SearchTable">
  <tr>
    <td width="150" class="SubTitle" colspan="2"><%=_i18n.get("sys20ms001.dsig")%></td>
  </tr>
  <tr>
    <td style="padding:10px">
      <table>
        <tr>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.sign.privatekey.alias")%></td>
          <td width="260">
            <input name="mxs.sign.privatekey.alias" id="mxs.sign.privatekey.alias" type="text" value="<%= SIGN_PRIVATEKEY_ALIAS==null?"":SIGN_PRIVATEKEY_ALIAS%>" size="25" maxlength="15">
          </td>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.sign.privatekey.passwd")%></td>
          <td width="260">
            <input name="mxs.sign.privatekey.passwd" id="mxs.sign.privatekey.passwd" type="text" value="<%= SIGN_PRIVATEKEY_PASSWD==null?"":SIGN_PRIVATEKEY_PASSWD%>" size="25" maxlength="15">
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
-->
<!-- F. POP3정보 ... -->
<!--
<table class="SearchTable">
  <tr>
    <td width="150" class="SubTitle" colspan="2"><%=_i18n.get("sys20ms001.pop3")%></td>
  </tr>
  <tr>
    <td style="padding:10px">
      <table>
        <tr>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.pop3.enabled")%></td>
          <td width="260">
            <input name="mxs.pop3.enabled" id="mxs.pop3.enabled" type="text" value="<%= POP3_ENABLED==null?"":POP3_ENABLED%>" size="25" maxlength="15" class="FormText">
          </td>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.pop3.foldername")%></td>
          <td width="260">
            <input name="mxs.pop3.foldername" id="mxs.pop3.foldername" type="text" value="<%= POP3_FOLDERNAME==null?"":POP3_FOLDERNAME%>" size="25" maxlength="15" class="FormText">
          </td>
        </tr>
        <tr>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.pop3.host")%></td>
          <td width="260">
            <input name="mxs.pop3.host" id="mxs.pop3.host" type="text" value="<%= POP3_HOST==null?"":POP3_HOST%>" size="25" maxlength="15" class="FormText">
          </td>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.pop3.username")%></td>
          <td width="260">
            <input name="mxs.pop3.username" id="mxs.pop3.username" type="text" value="<%= POP3_USERNAME==null?"":POP3_USERNAME%>" size="25" maxlength="15" class="FormText">
          </td>
        </tr>
        <tr>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.pop3.port")%></td>
          <td width="260">
            <input name="mxs.pop3.port" id="mxs.pop3.port" type="text" value="<%= POP3_PORT==null?"":POP3_PORT%>" size="25" maxlength="15" class="FormText">
          </td>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.pop3.password")%></td>
          <td width="260">
            <input name="mxs.pop3.password" id="mxs.pop3.password" type="text" value="<%= POP3_PASSWORD==null?"":POP3_PASSWORD%>" size="25" maxlength="15" class="FormText">
          </td>
        </tr>
        <tr>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.pop3.interval")%></td>
          <td width="260" colspan="3">
            <input name="mxs.pop3.interval" id="mxs.pop3.interval" type="text" value="<%= POP3_INTERVAL==null?"":POP3_INTERVAL%>" size="25" maxlength="15" class="FormText">
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
-->
<!-- H. SMTP_INFO ... -->
<!--
<table class="SearchTable">
  <tr>
    <td width="150" class="SubTitle" colspan="2"><%=_i18n.get("sys20ms001.smtp")%></td>
  </tr>
  <tr>
    <td style="padding:10px">
      <table>
        <tr>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.smtp.host")%></td>
          <td width="260">
                  <input name="mxs.smtp.host" id="mxs.smtp.host" type="text" value="<%= SMTP_HOST==null?"":SMTP_HOST%>" size="25" maxlength="15" class="FormText">
          </td>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.smtp.username")%></td>
          <td width="260">
                  <input name="mxs.smtp.username" id="mxs.smtp.username" type="text" value="<%= SMTP_USERNAME==null?"":SMTP_USERNAME%>" size="25" maxlength="15" class="FormText">
          </td>
        </tr>
        <tr>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.smtp.password")%></td>
          <td width="260" colspan="3">
                  <input name="mxs.smtp.password" id="mxs.smtp.password" type="text" value="<%= SMTP_PASSWORD==null?"":SMTP_PASSWORD%>" size="25" maxlength="15" class="FormText">
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
-->
<!-- I. KeyStore 정보 ... -->
<!--
<table class="SearchTable">
  <tr>
    <td width="150" class="SubTitle" colspan="2"><%=_i18n.get("sys20ms001.keystore")%></td>
  </tr>
  <tr>
    <td style="padding:10px">
      <table>
        <tr>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.keystore.type")%></td>
          <td width="260">
                  <input name="mxs.keystore.type" id="mxs.keystore.type" type="text" value="<%= KEYSTORE_TYPE==null?"":KEYSTORE_TYPE%>" size="25" maxlength="30" >
          </td>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.keystore.passwd")%></td>
          <td width="260">
                  <input name="mxs.keystore.passwd" id="mxs.keystore.passwd" type="text" value="<%= KEYSTORE_PASSWD==null?"":KEYSTORE_PASSWD%>" size="25" maxlength="30">
          </td>
        </tr>
        <tr>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.keystore.file")%></td>
          <td width="260" colspan="3">
                  <input name="mxs.keystore.file" id="mxs.keystore.file" type="text" value="<%= KEYSTORE_FILE==null?"":KEYSTORE_FILE%>" size="25" maxlength="30">
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
-->
        <!-- J. 모니터링 정보 ... -->
<!--
<table class="SearchTable">
  <tr>
    <td width="150" class="SubTitle" colspan="2"><%=_i18n.get("sys20ms001.monitor")%></td>
  </tr>
  <tr>
    <td style="padding:10px">
      <table>
        <tr>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.monitor.enabled")%></td>
          <td width="260">
                  <select name="mxs.monitor.enabled" id="mxs.monitor.enabled" class="textfield-3">
                   <%MONITOR_ENABLED = MONITOR_ENABLED == null ? "" : MONITOR_ENABLED;
                     if(MONITOR_ENABLED.equals("Y")) {
                    	 out.println("<option value='Y' selected>ENABLED</option>");
                     } else {
                    	 out.println("<option value='Y'>ENABLED</option>");
                     }
                     if(MONITOR_ENABLED.equals("N")){
                    	 out.println("<option value='N' selected>DISABLED</option>");
                     } else {
                    	 out.println("<option value='N'>DISABLED</option>");
                     }
                     %>
                  </select>
          </td>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.monitor.port")%></td>
          <td width="260">
                  <input name="mxs.monitor.port" id="mxs.monitor.port" type="text" value="<%= MONITOR_PORT==null?"":MONITOR_PORT%>" size="25" maxlength="15">
          </td>
        </tr>
        <tr>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.monitor.ip")%></td>
          <td width="260" colspan="3">
                  <input name="mxs.monitor.ip" id="mxs.monitor.ip" type="text" value="<%= MONITOR_IP==null?"":MONITOR_IP%>" size="25" maxlength="15">
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
-->
<%
if (MxsConstants.WS_MOD_SUPPORTED) {
%>
<!-- K. WS-R 버퍼링 ... -->
<table class="SearchTable">
  <tr>
    <td width="150" class="SubTitle" colspan="2"><%=_i18n.get("sys20ms001.wsr")%></td>
  </tr>
  <tr>
    <td style="padding:10px">
      <table>
        <tr>
          <td width="140"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.wsr.save.limit")%></td>
          <td width="670"><input name="mxs.message.order.save.limit" id="mxs.message.order.save.limit" type="text" value="<%= MESSAGE_ORDER_SAVE%>" size="25" maxlength="30" class="FormText">
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<%} %>
<!-- L. SIGNATURE ... -->
<table class="SearchTable">
  <tr>
    <td width="150" class="SubTitle" colspan="2"><%=_i18n.get("sys20ms001.signature")%></td>
  </tr>
  <tr>
    <td style="padding:10px">
      <table>
<%
if (MxsConstants.EB_MOD_SUPPORTED && MxsConstants.WS_MOD_SUPPORTED) {
%>
        <tr>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.eb.signature.executor")%></td>
          <td width="260">
          	<input name="mxs.eb.signature.executor" id="mxs.eb.signature.executor" type="text" value="<%= EBSE_EXECUTOR%>" size="25" maxlength="255" class="FormText">
          </td>
		  <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.ws.signature.executor")%></td>
          <td width="260">
          	<input name="mxs.ws.signature.executor" id="mxs.ws.signature.executor" type="text" value="<%= WSSE_EXECUTOR%>" size="25" maxlength="255" class="FormText">
          </td>
        </tr>
<%} else if (MxsConstants.EB_MOD_SUPPORTED && !MxsConstants.WS_MOD_SUPPORTED) {
%>
        <tr>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.eb.signature.executor")%></td>
          <td colspan=3 width=670 align=left>
          	<input name="mxs.eb.signature.executor" id="mxs.eb.signature.executor" type="text" value="<%= EBSE_EXECUTOR%>" size="25" maxlength="255" class="FormText">
          </td>
        </tr>
<%
} else if (!MxsConstants.EB_MOD_SUPPORTED && MxsConstants.WS_MOD_SUPPORTED) {
	%>
    <tr>
		  <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.ws.signature.executor")%></td>
          <td colspan=3 width=670 align=left>
          	<input name="mxs.ws.signature.executor" id="mxs.ws.signature.executor" type="text" value="<%= WSSE_EXECUTOR%>" size="25" maxlength="255" class="FormText">
          </td>
    </tr>
<%
}
if (MxsConstants.WS_MOD_SUPPORTED) {
%>
        <tr>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.ws.hash.function")%></td>
          <td width="260">
          	<input name="mxs.ws.hash.function" id="mxs.ws.hash.function" type="text" value="<%= WSSE_HASH%>" size="25" maxlength="255" class="FormText">
          </td>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.ws.signature.algorithm")%></td>
          <td width="260">
          	<input name="mxs.ws.signature.algorithm" id="mxs.ws.signature.algorithm" type="text" value="<%= WSSE_ALGO%>" size="25" maxlength="255" class="FormText">
          </td>
        </tr>
<%} %>
      </table>
    </td>
  </tr>
</table>
<!-- L. SSL ... -->
<table class="SearchTable">
  <tr>
    <td width="150" class="SubTitle" colspan="2"><%=_i18n.get("sys20ms001.ssl")%></td>
  </tr>
  <tr>
    <td style="padding:10px">
      <table>
        <tr>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.ssl.keystore")%></td>
          <td width="260">
          	<input name="mxs.ssl.keystore" id="mxs.ssl.keystore" type="text" value="<%= SSL_KEYSTORE%>" size="25" maxlength="255" class="FormText">
          </td>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.ssl.keystore.password")%></td>
          <td width="260">
          	<input name="mxs.ssl.keystore.password" id="mxs.ssl.keystore.password" type="text" value="<%= SSL_KEYSTORE_PASSWD%>" size="25" maxlength="255" class="FormText">
          </td>
        </tr>
        <tr>
        <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.ssl.keystore.type")%></td>
        <td width="260">
        	<input name="mxs.ssl.keystore.type" id="mxs.ssl.keystore.type" type="text" value="<%= SSL_KEYSTORE_TYPE%>" size="25" maxlength="255" class="FormText">
        </td>
        <td width="150" colspan="2">&nbsp;&nbsp;<%=_i18n.get("sys20ms001.password.desc")%></td>
      </tr>
      <tr>
        <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.ssl.truststore")%></td>
        <td width="260">
        	<input name="mxs.ssl.truststore" id="mxs.ssl.truststore" type="text" value="<%= SSL_TRUST_KEYSTORE%>" size="25" maxlength="255" class="FormText">
        </td>
        <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.ssl.truststore.password")%></td>
        <td width="260">
        	<input name="mxs.ssl.truststore.password" id="mxs.ssl.truststore.password" type="text" value="<%= SSL_TRUST_KEYSTORE_PASSWD%>" size="25" maxlength="255" class="FormText">
        </td>
      </tr>
      <tr>
        <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.ssl.truststore.type")%></td>
        <td width="260" >
          <input name="mxs.ssl.truststore.type" id="mxs.ssl.truststore.type" type="text" value="<%= SSL_TRUST_KEYSTORE_TYPE%>" size="25" maxlength="255" class="FormText">
        </td>
        <td width="150" colspan="2">&nbsp;&nbsp;<%=_i18n.get("sys20ms001.password.desc")%></td>
      </tr>
      </table>
    </td>
  </tr>
</table>
<!-- M. LICENSE ... -->
<!--
<table class="SearchTable">
  <tr>
    <td width="150" class="SubTitle" colspan="2"><%=_i18n.get("sys20ms001.license")%></td>
  </tr>
  <tr>
    <td style="padding:10px">
      <table>
      <tr>
        <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.license.server.url")%></td>
        <td width="670">
        	<input name="mxs.license.server.url" id="mxs.license.server.url" type="text" value="<%= LICENSE_SERVER%>" size="60" maxlength="255" class="FormText">
        </td>
      </tr>
      </table>
    </td>
  </tr>
</table>
-->
<!-- N. PLUGIN ... -->
<table class="SearchTable">
  <tr>
    <td width="150" class="SubTitle" colspan="2"><%=_i18n.get("sys20ms001.plugin")%></td>
  </tr>
  <tr>
    <td style="padding:10px">
      <table>
<%
if (MxsConstants.EB_MOD_SUPPORTED) {
%>
        <tr>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.ebmsg.preprocessor")%></td>
          <td width="260">
          	<input name="mxs.ebmsg.preprocessor" id="mxs.ebmsg.preprocessor" type="text" value="<%= EBMS_PRE_PROCESSOR%>" size="25" maxlength="255" class="FormText">
          </td>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.ebmsg.postprocessor")%></td>
          <td width="260">
          	<input name="mxs.ebmsg.postprocessor" id="mxs.ebmsg.postprocessor" type="text" value="<%= EBMS_POST_PROCESSOR%>" size="25" maxlength="255" class="FormText">
          </td>
        </tr>
<%}
if (MxsConstants.WS_MOD_SUPPORTED) {
%>
        <tr>
        <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.wsmsg.preprocessor")%></td>
        <td width="260">
        	<input name="mxs.wsmsg.preprocessor" id="mxs.wsmsg.preprocessor" type="text" value="<%= WSMS_PRE_PROCESSOR%>" size="25" maxlength="255" class="FormText">
        </td>
        <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.wsmsg.postprocessor")%></td>
        <td width="260">
        	<input name="mxs.wsmsg.postprocessor" id="mxs.wsmsg.postprocessor" type="text" value="<%= WSMS_POST_PROCESSOR%>" size="25" maxlength="255" class="FormText">
        </td>
      </tr>
<%} %>
    </table>
    </td>
  </tr>
</table>
        <!-- 저장 정보 ... -->
<table class="SearchTable">
  <tr>
    <td width="150" class="SubTitle" colspan="2"><%=_i18n.get("sys20ms001.filesave")%></td>
  </tr>
  <tr>
    <td style="padding:10px">
      <table>
        <tr>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.file.storage")%></td>
          <td width="260">
                  <input name="mxs.file.storage" id="mxs.file.storage" type="text" value="<%= FILE_STORAGE==null?"":FILE_STORAGE%>" size="25" maxlength="256" class="FormText">
          </td>
          <td width="150"><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms001.files.per.directory")%></td>
          <td width="260">
                  <input name="mxs.files.per.directory" id="mxs.files.per.directory" type="text" value="<%= FILES_PER==null?"":FILES_PER%>" size="25" maxlength="15" class="FormText">
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
      <table class="TableLayout">
        <tr align="right" valign="middle">
          <td>
          <a href="javascript:updateProperties()"><img src="images/btn_big_save.gif" width="39" height="23" border="0"></a>
          </td>
        </tr>
      </table>
</form>
</body>
</html>
