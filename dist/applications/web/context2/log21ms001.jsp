<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%
/**
 * 로그 트레이스
 *
 * @version 1.0 2009.06.22
 * @author Ho-Jin Seo
 */

 	String id = StringUtil.checkNull(request.getParameter("id"));
%>
<html>
<head>
<%@ include file="./com00in000.jsp"%>
<%@ include file="./com00in001.jsp"%>
<%@ include file="./com00in003.jsp"%>
<title><%=_i18n.get("global.page.title")%></title>
<style type="text/css">
.shaper {
    border: 1px solid #ddd;
    padding: 10px;
    width:750px;
}
#file_content {
    width: 100%;
    overflow: auto;
    font-size: 11px;
    white-space: nowrap;
}
.ajax_activity {
    height: 30px;
}
.line {
    padding-left: 10px;
    padding-right: 10px;
    border: 1px solid #fff;
}
.line_error {
    padding-left: 10px;
    padding-right: 10px;
    border: 1px solid #fff;
    color: red;
}
.line_warn {
    padding-left: 10px;
    padding-right: 10px;
    border: 1px solid #fff;
    color: blue;
}

</style>
<script language="javascript">

var file_content_div = "file_content";

var updater = new Ajax.PeriodicalUpdater(file_content_div, "log21ac001.jsp?id=<%=id%>", {frequency: 3});
var top = -1;
var updaterRunning = true;

Ajax.Responders.register({
    onComplete: function() {
        objDiv = document.getElementById(file_content_div);
        if (top == -1) {
            objDiv.scrollTop = objDiv.scrollHeight;
        } else {
            objDiv.scrollTop = top
        }
    },

    onCreate: function() {
        objDiv = document.getElementById(file_content_div);
        if (objDiv.scrollTop + objDiv.clientHeight == objDiv.scrollHeight) {
            top = -1;
        } else {
            top = objDiv.scrollTop;
        }
    }
})

function getTitle() {

	var params = Form.serialize(document.form1);

	var opt = {
	    method: 'post',
	    postBody: "",
	    aynchronous:false,
	    onSuccess: updateTitle,
	    on404: function(t) {
	    },
	    onFailure: function(t) {
	    }
	}

	var myAjax = new Ajax.Request('./log21ac002.jsp?id=<%=id%>', opt);
}

function updateTitle(originalRequest) {
	var res = eval("(" + originalRequest.responseText + ")");
	
	$('file_title').innerHTML = res.filepath;
}

function pauseLog() {
    updater.stop();
    Element.hide('pause');
    Element.show('resume');
}

function resumeLog() {
    updater.start();
    Element.hide('resume');
    Element.show('pause');
}

function clearLog() {
    new Ajax.Updater(file_content_div, "./log21ac003.jsp?id=<%=id%>");
}

function downloadLog() {
	location.href = "./log50ac001.jsp?id=<%=id%>";
}


function initialize() {
	Element.hide('resume');
    
	getTitle();
}

window.onload = initialize;
</script>
</head>
<body>

<form name="form1" method="POST">
 <!-- 제목 테이블 -->
 <table class="TableLayout">
	<tr>
		<td width="30%" class="Title"><img src="images/bu_tit.gif" ><%=_i18n.get("log21ms001.title." + id.toLowerCase())%></td>
		<td width="70%" class="MessageDisplay">
		<div id="messageDisplay"></div>
		</td>
	</tr>
	<tr>
		<td colspan="3" height="6"></td>
	</tr>
</table>
 
<table class="FieldTable">
	<tr>
		<td width="25%"  class="FieldLabel"><img src="images/bu_search.gif"><%= _i18n.get("log21ms001.file") %></td>
		<td width="75%"  class="FieldData"><div id="file_title"></div></td>
	</tr>
</table>
<br>
<table class="TableLayout">
	<tr align="center" valign="middle">
		<td>
		<a href="javascript:resumeLog()" id="resume">resume&nbsp;&nbsp;</a>
		<a href="javascript:pauseLog()" id="pause">pause&nbsp;&nbsp;</a>
		<a href="javascript:clearLog()" id="clear">clear&nbsp;&nbsp;</a>
		<a href="javascript:downloadLog()" id="download">download&nbsp;&nbsp;</a>
		</td>
	</tr>
</table>
    <div class="shaper">
        <div id="file_content" class="fixed_width" style="height: 305px;">
            <div class="ajax_activity"></div>
        </div>
    </div>
</form>
</body>
</html>