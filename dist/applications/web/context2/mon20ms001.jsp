<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%@ page import="java.util.Properties"%>
<%@ page import="java.io.FileInputStream"%>
<%
/**
 * 모니터링 대상 설정
 *
 * @version 1.0 2009.04.16
 * @author Ho-Jin Seo
 */
 
	String path = session.getServletContext().getRealPath("/WEB-INF/monitor.properties");
	Properties props = new Properties();
 	try {
		FileInputStream fis = new FileInputStream(path);
		props.load(fis);
		fis.close();
 	} catch(Exception e) {
 	}

	int cnt = Integer.parseInt(props.getProperty("msg.monitor.cnt","0"));
	String unitY = props.getProperty("monitor.gridY","10");
	int refresh_time = Integer.parseInt(props.getProperty("monitor.refresh","10"));
%>
<html>
<head>
<%@ include file="./com00in000.jsp"%>
<%@ include file="./com00in001.jsp"%>
<%@ include file="./com00in003.jsp"%>
<title><%=_i18n.get("global.page.title")%></title>
<script language="JavaScript" type="text/JavaScript">
<!--
function initialize() {
<%
	String server = "";
	for(int i=0; i<cnt; i++) {
		server = props.getProperty("msg.monitor." + i,"");
%>
	var inputs = document.getElementsByTagName('input');
	var count = 0;
	for (var i = 0; i < inputs.length; i++) {
		if (inputs[i].type == 'checkbox' && inputs[i].name == 'stype' 
		  && inputs[i].value == "<%= server%>") {
			inputs[i].checked = true;
		}
	}
<%
	}	
%>
	inputs = document.getElementsByTagName('input');
	for (var i = 0; i < inputs.length; i++) {
		if (inputs[i].type == 'radio' && inputs[i].name == 'refreshTime' 
		  && inputs[i].value == "<%= refresh_time%>") {
			inputs[i].checked = true;
		}
	}

	inputs = document.getElementsByTagName('input');
	for (var i = 0; i < inputs.length; i++) {
		if (inputs[i].type == 'radio' && inputs[i].name == 'gridY' 
		  && inputs[i].value == "<%= unitY%>") {
			inputs[i].checked = true;
		}
	}	
}

function updateProperties() {
	clearNotify();

	var params = Form.serialize(document.form1);

	openInfo('<%=_i18n.get("global.processing") %>');
	var opt = {
	    method: 'post',
	    postBody: params,
	    onSuccess: function(t) {
	    	closeInfo();
	    	$('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > 수정되었습니다';
	    	//Dialog.setInfoMessage('수정되었습니다');
	    },
	    on404: function(t) {
	    	closeInfo();
	        $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("err00zz404.message") %>';
	        //showError('페이지를 찾을 수 없습니다', null, null, null);
	    },
	    onFailure: function(t) {
	    	closeInfo();
	        $('messageDisplay').innerHTML = '<img src="images/bu_query.gif" align="absmiddle" > <%=_i18n.get("global.error.retry") %>';
	        //showErrorPopup(t.responseText, null, null, null);
	    }
	}

	var myAjax = new Ajax.Request('./mon30ac001.jsp', opt);
}

//-->
</script>
</head>
<body bgcolor="#FFFFFF" leftmargin=0 topmargin=0 marginwidth=0 marginheight=0 onLoad="initialize()">

<form name="form1" method="POST">
<input type="hidden" name="curPage" id="curPage" value="1">

<!-- 제목 테이블 -->
<table class="TableLayout">
	<tr>
		<td width="30%" class="Title"><img src="images/bu_tit.gif" ><%=_i18n.get("menu.monitor.setting")%></td>
		<td width="70%" class="MessageDisplay">
		<div id="messageDisplay"></div>
		</td>
		<td><a href="./index.jsp"><img src="images/bu_home.gif" border="0" style="cursor: hand;"></a></td>
	</tr>
	<tr>
		<td colspan="3" height="6"></td>
	</tr>
</table>

<table class="TableLayout">
	<tbody>
		<tr>
			<td class="ResultLastHeader" colspan="5"><%=_i18n.get("mon20ms001.target")%></td>
		</tr>
		<tr>
			<td class="ResultHeader"><%=_i18n.get("mon20ms001.col1")%></td>
			<td class="ResultHeader"><%=_i18n.get("mon20ms001.col2")%></td>
			<td class="ResultHeader"><%=_i18n.get("mon20ms001.col3")%></td>
			<td class="ResultHeader"><%=_i18n.get("mon20ms001.col4")%></td>
			<td class="ResultLastHeader"><%=_i18n.get("mon20ms001.col5")%></td>
		</tr>
<%
	/*
	DAOManager daoMgr = DAOManager.getInstance();
	QueryCondition qc = new QueryCondition();
	List msglist = daoMgr.getObjects(ETaxConstants.DAO_MSG_SERVER_INFO, qc);
	*/
	//for(int i=0; i<msglist.size(); i++) {
	for(int i=0; i<1; i++) {
		//MessageServerInfoVO vo = (MessageServerInfoVO)msglist.get(i);
		String name = "Server_01";
		String enabled = "Enabled";
		String address = "";
%>
		<tr>
			<td class="ResultData"><%=enabled %></td>
			<td class="ResultData"><input type="checkbox" name="stype" value=",0"></td>
			<td class="ResultData"><input type="checkbox" name="stype" value=",1"></td>
			<td class="ResultData"><input type="checkbox" name="stype" value=",2"></td>
			<td class="ResultLastData"><input type="checkbox" name="stype" value=",3"></td>
		</tr>
<%
	}
%>
	</tbody>
</table>
<p/>

<table class="TableLayout">
	<tbody>
		<tr>
			<td width="30%" class="Title"><%=_i18n.get("menu.monitor.setting")%></td>
			<td width="70%" class="MessageDisplay">
		</tr>
		<tr>
			<td colspan="2" class="ResultLastData" height="1"></td>
		</tr>
		<tr>
			<td class="ResultHeader" width="150"><%=_i18n.get("mon20ms001.period")%></td>
			<td class="ResultLastData">
				<input type="radio" name="refreshTime" value="5">5<%=_i18n.get("mon20ms001.second")%>
				<input type="radio" name="refreshTime" value="10">10<%=_i18n.get("mon20ms001.second")%>
				<input type="radio" name="refreshTime" value="30">30<%=_i18n.get("mon20ms001.second")%>
				<input type="radio" name="refreshTime" value="60">1<%=_i18n.get("mon20ms001.minute")%>
				<input type="radio" name="refreshTime" value="300">5<%=_i18n.get("mon20ms001.minute")%>
				<input type="radio" name="refreshTime" value="600">10<%=_i18n.get("mon20ms001.minute")%>
			</td>
		</tr>
		<tr>
			<td class="ResultHeader">건수 간격</td>
			<td class="ResultLastData">
				<input type="radio" name="gridY" value="10">10<%=_i18n.get("mon21ms001.unit1")%>
				<input type="radio" name="gridY" value="50">50<%=_i18n.get("mon21ms001.unit1")%>
				<input type="radio" name="gridY" value="100">100<%=_i18n.get("mon21ms001.unit1")%>
				<input type="radio" name="gridY" value="500">500<%=_i18n.get("mon21ms001.unit1")%>
				<input type="radio" name="gridY" value="1000">1000<%=_i18n.get("mon21ms001.unit1")%>
				<input type="radio" name="gridY" value="10000">10000<%=_i18n.get("mon21ms001.unit1")%>
			</td>
		</tr>
	</tbody>
</table>
<p/>
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
