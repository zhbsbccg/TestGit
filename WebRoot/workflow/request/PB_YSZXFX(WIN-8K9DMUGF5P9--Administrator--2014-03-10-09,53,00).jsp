<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%><!--added by xwj for td2023 on 2005-05-20-->
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type="text/css" rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>

</head>
<%//劳动争议情况统计表
BaseBean bb = new BaseBean();

String userid=""+user.getUID();

int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
String imagefilename = "/images/hdDOC.gif";
String titlename = "预算执行分析报表";
String needfav ="1";
String needhelp ="";
//权限控制
/* if(!HrmUserVarify.checkUserRight("SAP:Z_OSAP_AP_AGING_ANALYSIS_GET", user))
	{
		response.sendRedirect("/notice/noright.jsp");
		return;
	} */

int perpage=10;

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<FORM id=weaver name=frmmain method=post action="/sap/Z_OSAP_AP_AGING_ANALYSIS_GET.jsp">

<input id="frompage" name="frompage" value="Z_OSAP_AP_AGING_ANALYSIS_GET" type="hidden" />

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:OnSearch(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>

<script type="text/javascript">


function OnSearch(){
	document.frmmain.submit();
}


</script>

<div id='divshowreceivied' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
<table width=100% height=94% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<table class="viewform">
  <colgroup>
  <col width="10%">
  <col width="35%">
  <col width="5">
  <col width="10%">
  <col width="40%">
  <tbody>
  <tr>
    <td>部门</td>
    <td class=field>
    	
    </td>

    <td>&nbsp;</td>
    
    <td>年度</td>
    <td class=field>
    	
    </td>
	
  </tr>
  <TR style="height:1px;"><TD class=Line colSpan=5></TD></TR>
  
  <tr>
    <td></td>
    <td class=field>
    	
    </td>

    <td>&nbsp;</td>
    
    <td></td>
    <td class=field>
    		
    </td>
	
  </tr>
  <TR style="height:1px;"><TD class=Line colSpan=5></TD></TR>
  </tbody>
</table>

</form>

<TABLE width="100%">
  <tr>
    <td valign="top">                                                                                    
       
    </td>
  </tr>
</TABLE>

<!--   added by xwj for td2023 on 2005-05-20  end  -->
     
<table align=right>
   <tr>
   <td>&nbsp;</td>
   <td>
   
 <td>&nbsp;</td>
   </tr>
	  </TABLE>
	  
	  </td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>



<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</body>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</html>