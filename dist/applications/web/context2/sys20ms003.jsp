<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.util.PropertiesEx" %>
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
	String path = session.getServletContext().getRealPath("/WEB-INF/classes/dbpools.properties");
	
	PropertiesEx props = new PropertiesEx();
	props.load(path);
	
    String DB_DRIVER					= (String)props.getProperty("db.pool.mxs.driver", "oracle.jdbc.driver.OracleDriver"); 
    String DB_URL						= (String)props.getProperty("db.pool.mxs.url", "oracle.jdbc.driver.OracleDriver"); 
    String DB_USER						= (String)props.getProperty("db.pool.mxs.user", ""); 
    String DB_PASSWD					= (String)props.getProperty("db.pool.mxs.password", ""); 
    String DB_MAXPOOL					= (String)props.getProperty("db.pool.mxs.maxpool", "5"); 
    String DB_MAXCON					= (String)props.getProperty("db.pool.mxs.maxconn", "20"); 
    String DB_LOG						= (String)props.getProperty("db.pool.mxs.logfile", "dbpool_mxs.log");
    
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
	
	var myAjax = new Ajax.Request('./sys30ac003.jsp', opt);	
}

//-->
</script>
</head>
<body>

<table class="TableLayout">
  <tr> 
    <td width="120" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.sys.db")%></td>
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
    <td class="SubTitle" colspan="2"><%=_i18n.get("sys20ms003.db.pool")%></td>
  </tr>
  <tr>
    <td style="padding:10px">
      <table>
        <tr>
          <td width="150" ><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms003.db.pool.mxs.driver")%></td>
          <td width="260">
            <input name="db.pool.mxs.driver" id="db.pool.mxs.driver" type="text" value="<%= DB_DRIVER%>" size="25" maxlength="255" class="FormText">
          </td>
          <td width="150" ><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms003.db.pool.mxs.url")%></td>
          <td width="260">
            <input name="db.pool.mxs.url" id="db.pool.mxs.url" type="text" value="<%= DB_URL%>" size="25" maxlength="255" class="FormText">
          </td>
        </tr>
        <tr>
          <td width="150" ><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms003.db.pool.mxs.user")%></td>
          <td width="260">
            <input name="db.pool.mxs.user" id="db.pool.mxs.user" type="text" value="<%= DB_USER%>" size="25" maxlength="255" class="FormText">
          </td>
          <td width="150" ><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms003.db.pool.mxs.password")%></td>
          <td width="260">
            <input name="db.pool.mxs.password" id="db.pool.mxs.password" type="text" value="<%= DB_PASSWD%>" size="25" maxlength="255" class="FormText">
          </td>
        </tr>
        <tr>
        <td width="150" ><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms003.db.pool.mxs.maxconn")%></td>
        <td width="260">
          <input name="db.pool.mxs.maxconn" id="db.pool.mxs.maxconn" type="text" value="<%= DB_MAXCON%>" size="25" maxlength="255" class="FormText">
        </td>
        <td width="150" ><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms003.db.pool.mxs.maxpool")%></td>
        <td width="260">
          <input name="db.pool.mxs.maxpool" id="db.pool.mxs.maxpool" type="text" value="<%= DB_MAXPOOL%>" size="25" maxlength="255" class="FormText">
        </td>
        </tr>
        <tr>
          <td width="150" ><img src="images/bu_search.gif" ><%=_i18n.get("sys20ms003.db.pool.mxs.logfile")%></td>
          <td width="260">
            <input name="db.pool.mxs.logfile" id="db.pool.mxs.logfile" type="text" value="<%= DB_LOG%>" size="25" maxlength="255" class="FormText">
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
