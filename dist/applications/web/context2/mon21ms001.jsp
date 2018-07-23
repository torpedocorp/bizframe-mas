<%@ page contentType="text/html; charset=EUC_KR"%>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%@ page import="java.util.Properties"%>
<%@ page import="java.io.FileInputStream"%>
<%@ page import="java.util.ArrayList"%>
<%
/**
 * Monitoring
 *
 * @author Ho-Jin Seo
 * @version 1.0
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
	ArrayList monitor_arr = new ArrayList();
	String server = "";
	for(int i=0; i<cnt; i++) {
		server = props.getProperty("msg.monitor." + i,"");
		monitor_arr.add(server);
	}
	String unitY = props.getProperty("monitor.gridY","10");
	int refresh_time = Integer.parseInt(props.getProperty("monitor.refresh","60"));

	/*
	String[] monitor_arr = new String[] { "http://192.168.10.5:9095/etax,0",
			"http://192.168.10.5:9095/etax,1", "http://192.168.10.5:9095/etax,2",
			"http://192.168.10.5:9095/etax,3", "http://192.168.10.5:9095/etax,4",
			"http://192.168.10.5:9095/etax,5", "http://192.168.10.5:9095/etax,6",
			"http://192.168.10.105:7060/etax,0", "http://192.168.10.5:9005/etax,2" };
	String unitY = "10";
	int refresh_time = 5;
	*/

	int maxY = Integer.parseInt(unitY) * 5;
%>
<html>
<head>
<%@ include file="./com00in000.jsp" %>
<title><%=_i18n.get("global.page.title")%></title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<style type="text/css">
.monitorGraph {
	width: 303;
}
.subTitle {
	width: 303;
	text-align: center;
}
</style>
<script>
var refresh_time = <%= refresh_time * 1000%>;

function MonitorGraph(gid, caption, refreshTime, actionPage, minY, maxY, autoRange) {
	var cntElement = 0;
	var tick = 0;
	var minX = 0;
	var maxX = 30;
	var incX = 30;
	var incY = maxY - minY;

	var subTitle1;
	var subTitle2;
	var subUnit1;
	var subUnit2;

	this.init = function() {
		$(gid).caption = caption;
		$(gid).FrameStyle = 0;
		$(gid).SetRange(minX, maxX, minY, maxY);
		$(gid).PlotAreaColor = RGB(0,0,0);
		$(gid).ControlFrameColor = RGB(255,255,255);
		$(gid).ShowGrid = 1;
		$(gid).XGridNumber = 6;
		$(gid).ElementIdentify = true;
		$(gid).XLabel = "<%=_i18n.get("mon21ms001.time")%>";
	};

	this.addElement = function(title, eleTitle, unit) {
		if (cntElement == 0) {
			$(gid).Element = cntElement;
			$(gid).ElementLineColor = RGB(0,255,0);
			$(gid).ElementPointColor = RGB(0,255,0);
			$(gid).ElementName = title;
			subTitle1 = eleTitle;
			subUnit1 = " " + unit;
		} else if (cntElement > 0) {
			$(gid).AddElement();
			$(gid).Element = cntElement;
			$(gid).ElementLineColor = RGB(255,0,0);
			$(gid).ElementPointColor = RGB(255,0,0);
			$(gid).ElementName = title;
			subTitle2 = eleTitle;
			subUnit2 = " " + unit;
		}
		cntElement =+ 1;
	}

	var drawGraph;

	var refreshGraph = function() {
		var opt = {
		   method: 'get',
		   parameters: "",
		   crossSite: true,
		   asynchronous : true,
		   onSuccess: drawGraph,
		   on404: function(t) {
		   	$('messageDisplay').innerHTML = "404";
		   },
		   onFailure: function(t) {
		   	$('messageDisplay').innerHTML = "500";
		   }
		}
		var myAjax = new Ajax.Request(actionPage, opt);
	}

	drawGraph = function(originalRequest) {
		//$('messageDisplay').innerHTML += $(gid).id;
		var res = eval("(" + originalRequest.responseText + ")");

		//$('messageDisplay').innerHTML += "B" + gridNumY;
		if (tick == 0 && autoRange == true) {
			minY = Math.min(res.e1, res.e2);
			maxY1 = Math.max(res.e1, res.e2);

			while(maxY1 > maxY)
				maxY += incY;

			$(gid).SetRange(minX, maxX, minY, maxY);
		}

		valX = (refreshTime / 60000) * tick;
		valY = res.e1;
		minY1 = valY;
		maxY1 = valY;

		$(gid).Element = 0;
		$(gid).PlotXY(valX, valY, 0);
		if (subTitle1 != "")
			$(gid+"_sub1").innerHTML = subTitle1 + ":" + valY + subUnit1;

		if ($(gid).ElementCount > 1) {
			//$('messageDisplay').innerHTML += gid + ":" + "C";
			$(gid).Element = 1;
			$(gid).PlotXY(valX, res.e2, 1);
			$(gid+"_sub2").innerHTML = subTitle2 + ":<font color='red'>" + res.e2 + "</font>" + subUnit2;
			maxY1 = Math.max(maxY1, res.e2);
			minY1 = Math.min(minY1, res.e2);
		}
		//$('messageDisplay').innerHTML += "D";

		tick++;

		if (valX > maxX) {
			while(valX > maxX)
				maxX += incX;
			$(gid).SetRange(minX, maxX, minY, maxY);
			//$('messageDisplay').innerHTML += "R1";
		} else if (maxY1 > maxY) {
			while(maxY1 > maxY)
				maxY += incY;
			$(gid).SetRange(minX, maxX, minY, maxY);
			//$('messageDisplay').innerHTML += "R2";
		} else if (valX < minX) {
			while(valX < minX)
				minX -= incX;
			$(gid).SetRange(minX, maxX, minY, maxY);
			//$('messageDisplay').innerHTML += "R3";
		} else if (minY1 < minY) {
			while(minY1 < minY)
				minY -= incY;
			$(gid).SetRange(minX, maxX, minY, maxY);
			//$('messageDisplay').innerHTML += "R4";
		}

		//$('messageDisplay').innerHTML += "E";

		//$('messageDisplay').innerHTML += refreshTime;
		if (refreshTime != 0) {
			setTimeout(refreshGraph, refreshTime);
		}
		//$('messageDisplay').innerHTML += " END ";
	}

	this.start = function() {
		refreshGraph(drawGraph);
	}
}

function RGB(red, green, blue)
{
    var decColor = red + 256 * green + 65536 * blue;
    return decColor;
}

<%
	for(int i=0; i<monitor_arr.size(); i++) {
%>
	var mon<%=i%>;
<%
	}
%>

/*
var mon1;
var mon2;
var mon3;
var mon4;
var mon5;
var mon6;
*/

function initialize() {
<%
	for(int i=0; i<monitor_arr.size(); i++) {
		String[] mon = ((String)monitor_arr.get(i)).split(",");
		if (mon[1].equalsIgnoreCase("0")) {
%>
		mon<%=i%> = new MonitorGraph('graph<%=i%>', "<%=_i18n.get("mon21ms001.type1")%>", refresh_time, "mon21ac001.jsp?s=<%= mon[0]%>", 0, <%=maxY%>, true);
		mon<%=i%>.init();
		mon<%=i%>.addElement("Success", "<%=_i18n.get("mon21ms001.type1.sub1")%>", "<%=_i18n.get("mon21ms001.unit1")%>");
		mon<%=i%>.addElement("Fail", "<%=_i18n.get("mon21ms001.type1.sub2")%>", "<%=_i18n.get("mon21ms001.unit1")%>");
		mon<%=i%>.start();
<%

		} else if (mon[1].equalsIgnoreCase("1")) {
%>
		mon<%=i%> = new MonitorGraph('graph<%=i%>', "<%=_i18n.get("mon21ms001.type2")%>", refresh_time, "mon21ac002.jsp?s=<%= mon[0]%>", 0, <%=maxY%>, true);
		mon<%=i%>.init();
		mon<%=i%>.addElement("Success", "<%=_i18n.get("mon21ms001.type2.sub1")%>", "<%=_i18n.get("mon21ms001.unit1")%>");
		mon<%=i%>.addElement("Fail", "<%=_i18n.get("mon21ms001.type2.sub2")%>", "<%=_i18n.get("mon21ms001.unit1")%>");
		mon<%=i%>.start();
<%
		} else if (mon[1].equalsIgnoreCase("2")) {
%>
		mon<%=i%> = new MonitorGraph('graph<%=i%>', "<%=_i18n.get("mon21ms001.type3")%>", refresh_time, "mon21ac003.jsp?s=<%= mon[0]%>", 0, 100, false);
		mon<%=i%>.init();
		mon<%=i%>.addElement("Threads", "<%=_i18n.get("mon21ms001.type3.sub1")%>", "<%=_i18n.get("mon21ms001.unit2")%>" );
		mon<%=i%>.start();
<%
		} else if (mon[1].equalsIgnoreCase("3")) {
%>
		mon<%=i%> = new MonitorGraph('graph<%=i%>', "<%=_i18n.get("mon21ms001.type4")%>", refresh_time, "mon21ac004.jsp?s=<%= mon[0]%>", 0, 100, false);
		mon<%=i%>.init();
		mon<%=i%>.addElement("Memory", "<%=_i18n.get("mon21ms001.type4.sub1")%>", "%" );
		mon<%=i%>.start();
<%
		}
	}
%>
}

function updateRefreshTime() {
	refresh_time = $('rf_time').value * 1000;
}

function stopRefresh() {
	refresh_time = 0;
}

window.onload = initialize;

</script>
</head>
<body>
<!-- 제목테이블 -->
<table class="TableLayout">
  <tr>
    <td width="30%" class="Title" ><img src="images/bu_tit.gif" ><%=_i18n.get("menu.monitor.view")%></td>
    <td width="70%" class="MessageDisplay" ><div id=messageDisplay></div></td>
  </tr>
  <tr>
    <td colspan="2" height="10"></td>
  </tr>
</table>

<%
	int k=0;
	for(int i=0; i<monitor_arr.size(); i++) {
		String[] mon = ((String)monitor_arr.get(i)).split(",");

		if (!server.equals(mon[0])) {
			server = mon[0];
%>
			<!-- div><img src="images/bu_search.gif" >SERVER [<%=mon[0] %>]</div>
			<br/-->
<%
			k=i;
		}
		if(k-i%2 == 0) {
%>
<div style="clear:both"></div>
<p/>
<%
		}
%>
<span class="monitorGraph">
<OBJECT id=graph<%=i %> classid="clsid:C9FE01C2-2746-479B-96AB-E0BE9931B018"
 width=300 height=200 codebase="./NTGraph.cab#Version=1,0,0,1">
</OBJECT>
<span id="graph<%=i %>_sub1" class="subTitle"></span>
<span id="graph<%=i %>_sub2" class="subTitle"></span>
</span>
&nbsp;&nbsp;&nbsp;
<%
	}
%>
<!--
<a href="javascript:stopRefresh()">STOP</a>
 -->
</body>
</html>
