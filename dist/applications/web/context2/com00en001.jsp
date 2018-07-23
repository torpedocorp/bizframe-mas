<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsConstants" %>
<%@ page import="kr.co.bizframe.mxs.license.LicenseManager" %>
<%
/**
 * @author Jae-Heon Kim
 * @version 1.0
 */
String product_code = "pa";
if (MxsConstants.PRODUCT_FAMILY == MxsConstants.PRODUCT_FAMILY_ENTERPRISE) {
	product_code = "en";
}
%>

<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script type="text/JavaScript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script>
</head>
<body style="margin:0 0 0 0" onLoad="MM_preloadImages('./images/menu_01_on.gif','./images/menu_02_on.gif','./images/menu_03_on.gif','./images/menu_04_on.gif','./images/menu_05_on.gif','./images/menu_06_on.gif')">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="195" bgcolor="#F3F4F6"><img src="./images/top_logo01.gif" width="195" height="25"></td>
    <td style="padding-left:530" bgcolor="#F3F4F6"><table width="240" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td><img src="./images/top_home.gif" width="42" height="11"></td>
        <td><img src="./images/top_faq.gif" width="40" height="11"></td>
        <td><img src="./images/top_contact.gif" width="79" height="11"></td>
        <td><img src="./images/top_sitemap.gif" width="55" height="11"></td>
      </tr>
    </table></td>
    <td width="65"  bgcolor="#F3F4F6">&nbsp;</td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="195"><img src="./images/top_logo<%=product_code%>.gif" width="195" height="57"></td>
    <td width="100%" style="padding-left:40" bgcolor="#567CAA"><table width="690" border="0" cellspacing="0" cellpadding="0">
        <tr>
<%
if (MxsConstants.EB_MOD_SUPPORTED) {
%>
          <td><a target=menu href="com00en002.jsp?mod=ebms" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','./images/menu_01_on.gif',1)"><img src="./images/menu_01_off.gif" name="Image7" width="130" height="31" border="0"></a></td>
          <td><a target=menu href="com00en002.jsp?mod=ebms3" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image8','','./images/menu_07_on.gif',1)"><img src="./images/menu_07_off.gif" name="Image8" width="130" height="31" border="0"></a></td>
          <td><a target=menu href="com00en002.jsp?mod=ebms_common" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image9','','./images/menu_08_on.gif',1)"><img src="./images/menu_08_off.gif" name="Image9" width="130" height="31" border="0"></a></td>
<%
}
if (MxsConstants.WS_MOD_SUPPORTED) {
%>
          <td><a target=menu href="com00en002.jsp?mod=wsms" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image10','','./images/menu_02_on.gif',1)"><img src="./images/menu_02_off.gif" name="Image10" width="125" height="31" border="0"></a></td>
<%
}
%>
          <td><a target=menu href="com00en002.jsp?mod=usr" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image11','','./images/menu_03_on.gif',1)"><img src="./images/menu_03_off.gif" name="Image11" width="115" height="31" border="0"></a></td>
          <td><a target=menu href="com00en002.jsp?mod=sys" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image12','','./images/menu_04_on.gif',1)"><img src="./images/menu_04_off.gif" name="Image12" width="100" height="31" border="0"></a></td>
          <td><a target=menu href="com00en002.jsp?mod=sec" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image13','','./images/menu_05_on.gif',1)"><img src="./images/menu_05_off.gif" name="Image13" width="105" height="31" border="0"></a></td>
          <td><a target=menu href="com00en002.jsp?mod=lic" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image14','','./images/menu_06_on.gif',1)"><img src="./images/menu_06_off.gif" name="Image14" width="115" height="31" border="0"></a></td>
        </tr>
      </table></td>
  </tr>
</table>
<table width="100%" height="9" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td height="9" bgcolor="#F3F4F6">&nbsp;</td>
  </tr>
</table>
</body>
</html>
