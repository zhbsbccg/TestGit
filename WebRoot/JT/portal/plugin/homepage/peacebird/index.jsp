<%@ page contentType="text/html; charset=gb2312" language="java" import="java.sql.*" %>
<%@ page import="weaver.hrm.*" %>
<%
User user = HrmUserVarify.getUser (request , response) ;

 %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>̫ƽ����OAϵͳ</title>
<style type="text/css">
@import url("/portal/plugin/homepage/peacebird/css/dhtml-vert.css");
body,td,th {
	font-size: 12px;
}
body {
	background-color: #FFF;
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
a:link {
	text-decoration: none;
}
a:visited {
	text-decoration: none;
}
a:hover {
	text-decoration: underline;
}
a:active {
	text-decoration: none;
}
</style>



<script>
function logout(){
	var isout=confirm("��ȷ��Ҫ�˳�ϵͳ��");
	if(isout) top.location.href="/login/logout.jsp";
	
	}
function sub1(){
	var url="/system/QuickSearchOperation.jsp";
	var s=hrm.value;
	window.open(url+"?searchtype=2&searchvalue="+s);
	}
function sub2(){
	var url="/system/QuickSearchOperation.jsp";
	var s=doc.value;
	window.open(url+"?searchtype=1&searchvalue="+s);
	}
function setbg(a,b,c){
	document.getElementById(a).background='images/toolbarbg22.jpg';
	document.getElementById(b).background='images/toolbarbg11.jpg';
	document.getElementById(c).background='images/toolbarbg11.jpg';
	
	
	}
function setbg1(a,b,c){
	document.getElementById(a).background='images/toolbarbg22.jpg';
	document.getElementById(b).background='images/toolbarbg11.jpg';
	document.getElementById(c).background='images/toolbarbg11.jpg';
	
	
	}
function gotoPage(_url){
	document.getElementById("mainIframe").src = _url;
}
</script>

<!--[if gte IE 5.5]>
<SCRIPT language=JavaScript src="/portal/plugin/homepage/peacebird/js/dhtml.js" 
type=text/JavaScript></SCRIPT>
<![endif]-->
</head>

<body bgcolor="#F7F7F7">

<table width="980" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#F7F7F7">
  <tr style="background-image:url(images/topbg.jpg); color:#FFF">
    <td height="42"  width="195" align="right">
    
    <img src="images/logo.jpg" width="170" height="42" style="margin-right:4px"></td>
    <td align="right">
    <div style="margin-right:150px">
      <a href="/hrm/resource/HrmResource.jsp?id=<%=user.getUID()%>"target="_blank" style="color:#FFF" ><img src="images/m_header.jpg" style="vertical-align:middle;" border="0"><%=user.getLastname()%></a> ��ӭ��&nbsp;&nbsp;<a href="/hrm/resource/HrmResourcePassword.jsp" target="_blank"  style="color:#FFF" >�޸�����</a>	    
     <a style="cursor:hand; color:#FFF" onClick="javascript:location.reload();"> <img src="images/m_ref.jpg" style="vertical-align:middle;" border="0">ˢ�� </a><a style="cursor:hand; color:#FFF" onClick="javascript:logout();"><img src="images/m_exit.jpg" style="vertical-align:middle;" border="0">�˳�</a>&nbsp;
      <a href="/weaverplugin/PluginMaintenance.jsp" target="_blank"  style="color:#FFF" ><img src="images/m_down.jpg" style="vertical-align:middle;" border="0">�������</a>
      </div>
      
       </td>
  </tr>
  <tr>
    <td width="195" align="left" valign="top">
    <div style="margin-right:4px;background-image:url(images/left1_2.jpg); height:326px; background-repeat:no-repeat; background-position:right;">
    <div style="height:58px"></div>
    
    
    <table width="100" border="0" align="right" cellpadding="0" cellspacing="0" style="margin-left: 16px;">
      <tr>
        <td align="center">
         <UL id=navmenu>
   <LI><A href="/portal/plugin/homepage/peacebird/index.jsp">�����Ż�</A>
   
  <LI><A href="#">��������</A> 
  <UL>
    <LI><A href="#" onClick="javascript:gotoPage('/workflow/request/RequestType.jsp?needPopupNewPage=true&isfromportal=1');">�½�����</A> 
    <LI><A  href="#" onClick="javascript:gotoPage('/workflow/request/RequestView.jsp?isfromportal=1');">��������</A> 
    <LI><A  href="#" onClick="javascript:gotoPage('/workflow/request/RequestHandled.jsp?isfromportal=1');">�Ѱ�����</A>
    <LI><A  href="#" onClick="javascript:gotoPage('/workflow/request/RequestComplete.jsp?isfromportal=1');">�������</A>
    <LI><A  href="#" onClick="javascript:gotoPage('/workflow/request/MyRequestView.jsp?isfromportal=1');">�ҵ�����</A>
	<LI><A  href="#" onClick="javascript:gotoPage('/workflow/request/wfAgentStatistic.jsp?isfromportal=1');">���̴���</A>
	<LI><A  href="#" onClick="javascript:gotoPage('/system/systemmonitor/workflow/WorkflowMonitor.jsp?isfromportal=1');">���̼��</A>
<LI><A  href="#" onClick="javascript:gotoPage('/workflow/search/CustomSearch.jsp');">���̲鿴</A>

    </LI></UL>
  <LI><A href="#">֪ʶ����</A> 
  <UL>
    <LI><A href="#" onClick="javascript:gotoPage('/docs/docs/DocList.jsp?isuserdefault=1&isfromportal=1');">�½��ĵ�</A> 
    <LI><A  href="#" onClick="javascript:gotoPage('/docs/search/DocView.jsp?isfromportal=1');">�ҵ��ĵ�</A> 
    <LI><A  href="#" onClick="javascript:gotoPage('/docs/search/DocSearchTemp.jsp?list=all&isNew=yes&loginType=1&containreply=1&isfromportal=1');">�����ĵ�</A>
    <LI><A  href="#" onClick="javascript:gotoPage('/docs/search/DocSummary.jsp?isfromportal=1');">�ĵ�Ŀ¼</A>
    <LI><A  href="#" onClick="javascript:gotoPage('/docs/search/DocSearch.jsp?isfromportal=1');">��ѯ�ĵ�</A>
	<LI><A  href="#" onClick="javascript:gotoPage('/system/systemmonitor/docs/DocMonitor.jsp?isfromportal=1');">�ĵ����</A>
    </LI></UL>
  
  <LI><A href="#">������Ϣ</A> 
  <UL>
    <LI><A href="#" onClick="javascript:gotoPage('/hrm/resource/HrmResource_frm.jsp?isfromportal=1');">�½���Ա</A> 
    <LI><A  href="#" onClick="javascript:gotoPage('/hrm/resource/HrmResource.jsp?isfromportal=1');">�ҵĿ�Ƭ</A> 
    <LI><A  href="#" onClick="javascript:gotoPage('/hrm/search/HrmResourceView.jsp?isfromportal=1');">�ҵ�����</A>
    <LI><A  href="#" onClick="javascript:gotoPage('/hrm/resource/OnlineUser.jsp?isfromportal=1');">������Ա</A>
    <LI><A  href="#" onClick="javascript:gotoPage('/hrm/resource/HrmResourcePassword.jsp?isfromportal=1');">��������</A>
	<LI><A  href="#" onClick="javascript:gotoPage('/hrm/search/HrmResourceSearch.jsp?isfromportal=1');">��ѯ��Ա</A>
    </LI></UL>

<LI><A  href="#">�ճ�����</A>
<UL>
    <LI><A href="#">�������</A> 
	<UL>
        <LI><A href="#" onClick="javascript:gotoPage('/meeting/data/AddMeeting.jsp?isfromportal=1');">�½�����</A> 
        <LI><A href="#" onClick="javascript:gotoPage('/meeting/report/MeetingRoomPlan.jsp?isfromportal=1');">�����ұ���</A>  
        <LI><A href="#" onClick="javascript:gotoPage('/meeting/search/Search.jsp?isfromportal=1');">�����ѯ</A>  
        </LI>
        </UL>
    <LI><A  href="#">Э������</A> 
	<UL>
        <LI><A href="#" onClick="javascript:gotoPage('/cowork/coworkview.jsp?isfromportal=1');">�ҵ�Э��</A> 
        <LI><A href="#" onClick="javascript:gotoPage('/cowork/coworkview.jsp?flag=add&isfromportal=1');">�½�Э��</A>  
        <LI><A href="#" onClick="javascript:gotoPage('/cowork/coworkview.jsp?flag=search&isfromportal=1');">��ѯЭ��</A>  
        </LI>
        </UL>
    <LI><A  href="#">�ճ̹���</A>
	<UL>
        <LI><A href="#" onClick="javascript:gotoPage('/workplan/data/WorkPlan.jsp?add=1&isfromportal=1');">�½��ճ�</A> 
        <LI><A href="#" onClick="javascript:gotoPage('/workplan/data/WorkPlan.jsp?isfromportal=1');">�ҵ��ճ�</A>  
        <LI><A href="#" onClick="javascript:gotoPage('/workplan/search/WorkPlanSearchTerm.jsp?isfromportal=1');">��ѯ�ճ�</A>
		<LI><A href="#" onClick="javascript:gotoPage('/workplan/data/WorkPlanShare.jsp?isfromportal=1');">�����ճ�</A>  
        </LI>
        </UL>
    </LI></UL>
<LI><A href="#">��Ŀ����</A> 
<UL>
    <LI><A href="#" onClick="javascript:gotoPage('/proj/Templet/ProjTempletSele.jsp?isfromportal=1');">�½���Ŀ</A> 
    <LI><A  href="#" onClick="javascript:gotoPage('/proj/data/MyProject.jsp?isfromportal=1');">��Ŀִ��</A> 
    <LI><A  href="#" onClick="javascript:gotoPage('/proj/data/ProjectApproval.jsp?isfromportal=1');">������Ŀ</A>
    <LI><A  href="#" onClick="javascript:gotoPage('/proj/search/Search.jsp?isfromportal=1');">��ѯ��Ŀ</A>
    <LI><A  href="#" onClick="javascript:gotoPage('/system/systemmonitor/proj/ProjMonitor.jsp?isfromportal=1');">��Ŀ���</A>
    </LI></UL>
<LI><A href="#">�ʲ�����</A>
<UL>
    <LI><A href="#" onClick="javascript:gotoPage('/cpt/capital/CptCapMain_frm.jsp?isfromportal=1');">�ʲ�����ά��</A> 
    <LI><A  href="#" onClick="javascript:gotoPage('/cpt/search/CptMyCapital.jsp?addorsub=3&isfromportal=1');">�ҵ��ʲ�</A> 
    <LI><A  href="#" onClick="javascript:gotoPage('/cpt/search/CptSearch.jsp?isdata=2&isfromportal=1');">��ѯ�ʲ�</A>
    </LI></UL> 
<LI><A href="#">�������</A>
<UL>
    <LI><A href="#">���̱���</A>
	 <UL>
      <LI><A href="#" onClick="javascript:gotoPage('/workflow/flowReport/FlowTypeStat.jsp');">��������ͳ�Ʊ�</A> 
        <LI><A href="#" onClick="javascript:gotoPage('/workflow/flowReport/PendingRequestStat.jsp');">��������ͳ�Ʊ�</A> 
        <LI><A href="#" onClick="javascript:gotoPage('/workflow/flowReport/FlowTimeAnalyse.jsp');">������תʱ�������</A>  
        <LI><A href="#" onClick="javascript:gotoPage('/workflow/flowReport/HandleRequestAnalyse.jsp');">��Ա����ʱ�������</A>
		<LI><A href="#" onClick="javascript:gotoPage('/workflow/flowReport/SpendTimeStat.jsp');">���̺�ʱͳ�Ʊ�</A>
		<LI><A href="#" onClick="javascript:gotoPage('/workflow/report/ViewLogRp.jsp');">���ڶ�ȡ</A> 
        <LI><A href="#" onClick="javascript:gotoPage('/workflow/report/OperateLogRp.jsp');">���ڲ���</A>  
        <LI><A href="#" onClick="javascript:gotoPage('/workflow/flowReport/DocWfReport.jsp');">���̰������ͳ�Ʊ�</A>
		<LI><A href="#">����Ч������</A> 
	   <UL>
        <LI><A href="#" onClick="javascript:gotoPage('/workflow/flowReport/MostPendingRequest.jsp');">�������������Ա������</A> 
        <LI><A href="#" onClick="javascript:gotoPage('/workflow/flowReport/MostSpendTime.jsp');">��ʱ���Ա������</A>  
        <LI><A href="#" onClick="javascript:gotoPage('/workflow/flowReport/NodeOperatorfficiency.jsp');">�ڵ����Ч����Ա������</A>
		<LI><A href="#" onClick="javascript:gotoPage('/workflow/flowReport/MostExceedFlow.jsp');">�����������������</A>
		<LI><A href="#" onClick="javascript:gotoPage('/workflow/flowReport/MostExceedPerson.jsp');">���������Ա������</A>    
        </LI>
        </UL>
		<LI><A href="#" onClick="javascript:gotoPage('/workflow/report/CustomReportView.jsp');">���屨��</A>    
        </LI>
        </UL>
    <LI><A  href="#">֪ʶ����</A>
	 <UL>
        <LI><A href="#" onClick="javascript:gotoPage('/docs/report/DocRpDocSum.jsp');">��౻�Ķ�����</A> 
        <LI><A href="#" onClick="javascript:gotoPage('/docs/report/DocCreateRp.jsp');">�ĵ���������</A>  
        <LI><A href="#" onClick="javascript:gotoPage('/docs/report/DocRpOrganizationSum.jsp?organizationtype=3');">�����ĵ�ͳ��</A>
		<LI><A href="#" onClick="javascript:gotoPage('/docs/report/VotingResultRp.jsp');">����������</A>  
        </LI>
        </UL>
    <LI><A  href="#">��Ŀ����</A>
     <UL>
        <LI><A href="#" onClick="javascript:gotoPage('/proj/report/ProjectTypeRpSum.jsp');">��Ŀ����</A> 
        <LI><A href="#" onClick="javascript:gotoPage('/proj/report/WorkTypeRpSum.jsp');">��������</A> 
        <LI><A href="#" onClick="javascript:gotoPage('/proj/report/ProjectStatusRpSum.jsp');">��Ŀ״̬</A>
		<LI><A href="#" onClick="javascript:gotoPage('/proj/report/ManagerRpSum.jsp');">��Ŀ����</A>        
		<LI><A href="#" onClick="javascript:gotoPage('/proj/report/DepartmentRpSum.jsp');">��Ŀ����</A>
        <LI><A href="#" onClick="javascript:gotoPage('/proj/report/ProjectModifyLogRp.jsp');">�����޸�</A>
		<LI><A href="#" onClick="javascript:gotoPage('/proj/report/ProjectViewLogRp.jsp');">���ڶ�ȡ</A>
        </LI>
        </UL>
    <LI><A  href="#">�ʲ�����</A>
    <UL>
        <LI><A href="#" onClick="javascript:gotoPage('/cpt/report/CptRpCapGroupSum_frm.jsp');">�ʲ��鱨��</A> 
        <LI><A href="#" onClick="javascript:gotoPage('/cpt/report/CptRpCapResSum_frm.jsp');">��Ա�ʲ�</A> 
        <LI><A href="#" onClick="javascript:gotoPage('/cpt/report/CptRpCapDepSum_frm.jsp');">�����ʲ�</A>
		<LI><A href="#" onClick="javascript:gotoPage('/cpt/report/CptRpCapitalStateSum_frm.jsp');">�ʲ�״̬</A>        
		<LI><A href="#" onClick="javascript:gotoPage('/cpt/report/CptRpCapital_frm.jsp');">�ʲ����</A>
        <LI><A href="#" onClick="javascript:gotoPage('/cpt/report/CptRpCapitalFlow_frm.jsp');">��ת���</A>
        </LI>
        </UL>
	<LI><A  href="#">ϵͳ��־</A>
    <UL>
        <LI><A href="#" onClick="javascript:gotoPage('/docs/docs/DocDownloadLog.jsp');">�ĵ�������־</A> 
        <LI><A href="#" onClick="javascript:gotoPage('/CRM/report/CRMLoginLogRp.jsp');">�ͻ�������־</A> 
        <LI><A href="#" onClick="javascript:gotoPage('/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where%20operateitem=60');">��Ա������־</A>
        </LI>
        </UL>
        </LI>
        </UL>

<LI><A href="#">�ʼ�����</A>
 <UL>
        <LI><A href="/interface/Entrance.jsp?id=11" target= "_blank ">��������</A> 
        <LI><A href="/interface/Entrance.jsp?id=163" target= "_blank ">��ó����</A> 
        <LI><A href="/interface/AccountSetting.jsp" target= "_blank ">�û���/����</A> 
 
 </LI>
 </UL>
       </td>
      </tr>
    </table>
    </div>
    <div align="right">
      <a href="http://www.peacebird.com.cn" target="_blank"><img src="images/gw.jpg" width="173" height="80" style="margin-right:4px" border="0"></a>
      
      </div>
      
    <div align="right">
      <a href="http://www.pb89.com" target="_blank"> <img src="images/gw1.jpg" width="173" height="80" style="margin-right:4px; margin-top:8px" border="0">
</a>      
      </div>
    
    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="220">
        <tr>
          <td align="right">
            <div style="width:173; height:90px; margin-right:4px; background-image:url(images/s_bg.jpg); background-repeat:no-repeat" align="center">
<script>
function gourl(s){
window.open(s);
}
</script>
              <form name="form1" method="post" action="/system/QuickSearchOperation.jsp" target="_blank" style="margin-top:14px">
              <select name="website" onChange="gourl(this.options[this.selectedIndex].value)">
               <option value="#">----��վ����----</option>
                <option value="http://www.pbwcn.com">̫ƽ��Ůװ</option>
				<option value="http://www.pbmen.com">̫ƽ����װ</option>
				<option value="http://www.hphomepages.com/">������</option>
                            <option value="http://www.cntozone.com">;�ڶ��ֳ�</option>

              </select>
<br>
<div style="height:20px"></div>
<div>
<select name="searchtype" id="searchtype" style="height:26px;">
                  <option value="1">�ĵ�</option>
                  <option value="2">��Ա</option>
                  <option value="5">����</option>
                  <option value="7">�ʼ�</option>
                </select>
                <input type="text" name="searchvalue" style="width:60px; height:20px">
                <img src="images/s.jpg" style="vertical-align:top; cursor:hand" border="0" onClick="form1.submit()">
</div>
              </form>
            </div>          </td>
        </tr>
        <tr>
          <td align="right" valign="bottom"> 

          <div style="width:173; height:120px; margin-right:4px;padding-left:-10px; background-image:url(images/w_bg.jpg); background-repeat:no-repeat" align="center"><div style="height:2px"></div>
     <iframe src="http://www.thinkpage.cn/weather/weather.aspx?uid=U400130642&cid=101210401&l=zh-CHS&p=CMA&a=0&u=C&s=3&m=0&x=0&d=2&fc=&bgc=&bc=&ti=0&in=0&li=&ct=iframe" frameborder="0" scrolling="no" width="160" height="120" allowTransparency="true"></iframe>
                <!--
              <iframe src="http://www.thinkpage.cn/weather/weather.aspx?uid=U400130642&cid=101210401&l=zh-CHS&p=CMA&a=0&u=C&s=1&m=2&x=1&d=3&fc=&bgc=&bc=&ti=1&in=1&li=&ct=iframe" frameborder="0" scrolling="no" width="200" height="230" allowTransparency="true"></iframe>

          
           <iframe name="portlet" allowtransparency="true"  style="border:0px; padding:0;"  width="160" height="100" id="pserver_index2_pcms_WorkflwCtntPortlet3_iframe" frameborder="0"  vspace="0" hspace="0" scr="http://192.168.2.168:8112/peacebird/view/weather_frame.jsp?$portletWind=pserver_index2_pcms_WorkflwCtntPortlet3&_h3ra=192.168.2.168/portal">
</iframe>
        
             <iframe src="/page/element/Weather/View1.jsp?ebaseid=weather&eid=65&styleid=1&hpid=1&subCompanyId=1" scrolling="no" frameborder="0" width="160" height="100">
                </iframe>
     -->
          </div>
          
          </td>
        </tr>
    </table></td>
    <td rowspan="2" valign="top">
    	<iframe id="mainIframe" style="background-color:transparent;overflow: auto;margin-top: 5px;" src="/portal/plugin/homepage/peacebird/frameIndex.jsp"  width="100%" height="735px" scrolling="auto" frameborder="0" allowtransparency="true"></iframe>
    </td>
  </tr>
  <tr>
    <td height="100" colspan="2" align="center" valign="middle" style="color:#fff; background-image:url(images/bobg2.jpg); background-position:center; background-repeat:no-repeat">Copyright 2011 &copy; PEACEBIRD. All rights reserved. <a href="/main.jsp" target="_top" style="color:#fff">�л����</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>      
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
  </tr>
</table><br>
<br>
</body>
</html>