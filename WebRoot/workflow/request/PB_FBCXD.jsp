<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo"/>
<jsp:useBean id="budgetUtil2" class="weaver.workflow.request.BudgetfeeUtil2"/>
<jsp:useBean id="SubcompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" />
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
String subcompany=Util.null2String(request.getParameter("subcompany"));
if("".equals(subcompany)){
	subcompany=ResourceComInfo.getSubCompanyID(userid);
}
String subcompanySpan=SubcompanyComInfo.getSubCompanyname(subcompany);
String year=Util.null2String(request.getParameter("year"));
String month=Util.null2String(request.getParameter("month"));
Date nowYear=new Date();
if("".equals(year)){
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy");
	year=sdf.format(nowYear);
}
if("".equals(month)){
	SimpleDateFormat sdf=new SimpleDateFormat("MM");
	month=sdf.format(nowYear);
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<FORM id=weaver name=frmmain method=post action="PB_FBCXD.jsp">

<input id="frompage" name="frompage" value="PB_FBCXD.jsp" type="hidden" />

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
    <td>分部</td>
    <td class=field>
 
                <button type=button  class=Browser id=SelectSubCompany onclick="onShowSubcompany()"></BUTTON>
           		 <SPAN id=subcompanyspan><%=subcompanySpan %></SPAN>
           		  <INPUT class=inputstyle id=subcompany type=hidden name=subcompany value="<%=subcompany%>">
    	    	
    </td>
    <td>&nbsp;</td>
    
    <td>年度</td>
    <td class=field>
    	<button class=browser onClick="browserShow('yearSpan','year','/systeminfo/BrowserMain.jsp?url=/workflow/field/Workflow_FieldYearBrowser.jsp')"></button>
    	<span id="yearSpan"><%=year %></span>
    	<input type="hidden" value="<%=year %>" id="year" name="year"/>
    </td>
	
  </tr>
  <TR style="height:1px;"><TD class=Line colSpan=5></TD></TR>
  <tr>
    <td>月份</td>
    <td class=field>
    	<select name="month" id="month">
    	    <%for(int i=1;i<=12;i++){%>
    	    		<option value="<%=i%>"><%=i %></option>
    	    <%} %>
    	    </select>
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
<a href="PB_YSZXFX_EXPORT.jsp" target="_blank">导出为excel</a>
<TABLE width="100%">
  <tr>
    <td valign="top">   
    <!-- 获取分部 -->    
                                       
       <!-- 报表内容实体 -->
       <table class="ListStyle">
       		<thead>
       			<tr class="HeaderForXtalbe">
       				<th rowspan="2">二级科目</th>
       				<%
       					Map<String,String> deptMap=budgetUtil2.getDepartments(subcompany);
       					for(String key:deptMap.keySet()){
       						out.println("<th colspan='2'>"+deptMap.get(key)+"</th>");
       					}
       				%>
       				<th rowspan="2">全年预算</th>
       				<th rowspan="2">12月累计实际</th>
       				<th rowspan="2">12月累计预算</th>
       				<th rowspan="2">累计达成率</th>
       			</tr>
       			<tr class="HeaderForXtalbe">
       				<%
       					for(String key:deptMap.keySet()){%>
       						<th>实际发生</th>
       						<th>预算额</th>
       					<%}%>
       				
       					
       				
       			</tr>
       		</thead>
       		<tbody>
       		
       		</tbody>
       </table>
       <!-- 一个部门结束 -->
            
    </td>
  </tr>
</TABLE>
<%
//存储excel数据
	/* session.setAttribute("yszxfx_year", year);
	session.setAttribute("yszxfx_depid", departmentid);
	session.setAttribute("yszxfx_list", excelMap); */
%>
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
<script>
function browserShow(spanname,inputname,url) {
	var ___id = window.showModalDialog(url, "", "dialogWidth=550px;dialogHeight=550px");
	if (___id != null) {
		$GetEle(spanname).innerHTML = ___id.id;
		$GetEle(inputname).value = ___id.id;
	}
}
function onShowDepartment(tdname,inputename) {
	var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" + $GetEle(inputename).value, "", "dialogWidth:550px;dialogHeight:550px;")
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "" && wuiUtil.getJsonValueByIndex(id, 0) != "0") {
			var name= wuiUtil.getJsonValueByIndex(id, 1).substr(1);
			var id=wuiUtil.getJsonValueByIndex(id, 0).substr(1);
			var ids=id.split(",");
			var names=name.split(",");
			var temp="";
			for(var i=0;i<ids.length;i++){
				temp+="<a href='/hrm/company/HrmDepartmentDsp.jsp?id="+ids[i]+"' target='_new'>"+names[i]+"</a> ";
			}
			$GetEle(tdname).innerHTML = temp;
			$GetEle(inputename).value= id;
		} else {
			$GetEle(tdname).innerHTML = "";
			$GetEle(inputename).value="";
		}
	}
}
function onShowSubcompany() {
	var id = null;
		id = window
				.showModalDialog(
						"/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
								+ $GetEle("subcompany").value, "",
						"dialogWidth:550px;dialogHeight:550px;center:1;addressbar=no;status=0;resizable=0;");
	
	var issame = false;
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != 0) {
			if (wuiUtil.getJsonValueByIndex(id, 0) == $GetEle("subcompany").value) {
				issame = true;
			}
			$GetEle("subcompanySpan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 1);
			$GetEle("subcompany").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("subcompanySpan").innerHTML = "";
			$GetEle("subcompany").value = "";
		}
	}
}

</script>


<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</body>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</html>