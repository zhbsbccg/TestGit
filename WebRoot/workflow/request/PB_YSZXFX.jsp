<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%><!--added by xwj for td2023 on 2005-05-20-->
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo"/>
<jsp:useBean id="budgetUtil" class="weaver.workflow.request.BudgetfeeUtil"/>
<jsp:useBean id="SubcompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type="text/css" rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>

</head>
<%//劳动争议情况统计表
//清理session数据
	session.removeAttribute("yszxfx_year");
	session.removeAttribute("yszxfx_depid");
	session.removeAttribute("yszxfx_list");
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
String departmentid=Util.null2String(request.getParameter("departmentid"));
if("".equals(departmentid)){
	departmentid=ResourceComInfo.getDepartmentID(userid);
}
String departmentidSpan=budgetUtil.getDepartmentAllName(departmentid);
String year=Util.null2String(request.getParameter("year"));
if("".equals(year)){
	Date nowYear=new Date();
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy");
	year=sdf.format(nowYear);
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<FORM id=weaver name=frmmain method=post action="PB_YSZXFX.jsp">

<input id="frompage" name="frompage" value="PB_YSZXFX.jsp" type="hidden" />

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
    	    	<button type="button" class=browser onClick="onShowDepartment('departmentidspan','departmentid')"></button>
						<span id=departmentidspan><%=departmentidSpan %></span>
						<input name=departmentid id=departmentid type=hidden  value="<%=departmentid%>">
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
  
  
  <TR style="height:1px;"><TD class=Line colSpan=5></TD></TR>
  </tbody>
</table>

</form>
<a href="PB_YSZXFX_EXPORT.jsp" target="_blank">导出为excel</a>
<TABLE width="100%">
  <tr>
    <td valign="top">   
    <!-- 循环部门 -->    
    <%
    Map excelMap=new HashMap();//excel数据存储用
   
    for(String temp:departmentid.split(",")){%>                                         
       <!-- 报表内容实体 -->
       <table class="ListStyle">
       		<thead>
       			<tr class="HeaderForXtalbe">
       				<th colspan="30"><%=SubcompanyComInfo.getSubCompanyname(DepartmentComInfo.getSubcompanyid1(temp)) %>-<%=DepartmentComInfo.getDepartmentname(temp) %></th>
       			</tr>
       			<tr class="HeaderForXtalbe">
       				<th rowspan="2">二级科目</th>
       				<%for(int i=1;i<=12;i++){%>
       					<th colspan="2"><%=year %>年<%=i %>月</th>
       				<%} %>
       				<th rowspan="2">全年预算</th>
       				<th rowspan="2">12月累计实际</th>
       				<th rowspan="2">12月累计预算</th>
       				<th rowspan="2">同比使用比例%</th>
       				<th rowspan="2">全年使用比例%</th>
       			</tr>
       			<tr class="HeaderForXtalbe">
       				<%for(int i=1;i<=12;i++){%>
       					<th>实际发生</th>
       					<th>预算额</th>
       				<%} %>
       			</tr>
       		</thead>
       		<tbody>
       		<%
       			//载入当前部门的所属2及科目
       			Map<String,String> mapType=budgetUtil.getFnafeeTypes(temp);
       			int line=0;
       			//获取行数据内容
       			Map<String,Map<String,Double>> rowMap=budgetUtil.getDateGrid(temp, year);
       			excelMap.put(temp,rowMap);//存储行数据
       			for(String type:mapType.keySet()){
       				//获取列数据
       				Map<String,Double> colMap=rowMap.get(type);
       				if(colMap==null){
       					colMap=new HashMap<String,Double>();
       				}
       			%>
       			
       				<tr <%if(line%2!=0){out.println("class='DataDark'");}else{out.println("class='DataLight'");} %>>
       					<td><%=mapType.get(type) %></td>
       					<%for(int i=1;i<=12;i++){%>
       					<td><%=budgetUtil.intNull2Zero(colMap.get(i+"sj")) %></td>
       					<td><%=budgetUtil.intNull2Zero(colMap.get(i+"ys")) %></td>
       					<%} %>
       					<%
       						double zys=budgetUtil.intNull2Zero(colMap.get("zys"));
       						double zsj=budgetUtil.intNull2Zero(colMap.get("zsj"));
       					%>
       					<td><%=zys %></td>
       				<td><%=zsj %></td>
       				<td><%=zys %></td>
       				<td><%=budgetUtil.getDivide(zsj, zys)*100.0 %></td>
       				<td><%=budgetUtil.getDivide(zsj, zys)*100.0 %></td>
       				</tr>
       			
       			
       			<%line++;}%>
       		
       		</tbody>
       </table>
       <!-- 一个部门结束 -->
          <% } %>     
    </td>
  </tr>
</TABLE>
<%
//存储excel数据
	session.setAttribute("yszxfx_year", year);
	session.setAttribute("yszxfx_depid", departmentid);
	session.setAttribute("yszxfx_list", excelMap);
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
</script>


<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</body>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</html>