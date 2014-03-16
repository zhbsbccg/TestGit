<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>

<%

String assortid = Util.fromScreen(request.getParameter("assortmentid"),user.getLanguage());
String assortname = Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(assortid),user.getLanguage());
String remindsubmit = Util.fromScreen(request.getParameter("remindsubmit"),user.getLanguage());

boolean canedit = true;
/*
RecordSet.executeProc("CptCapital_SelectByID",assortid);
if(RecordSet.getCounts()<=0)
{
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
	return;
}
RecordSet.first();
String resourceid = Util.null2String(RecordSet.getString("resourceid"));
String startdate = Util.null2String(RecordSet.getString("startdate"));
String enddate = Util.null2String(RecordSet.getString("enddate"));

RecordSet.executeProc("CptCapitalShareInfo_SbyRelated",assortid);

*/



%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(119,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(535,user.getLanguage())+":<a href='/cpt/maintenance/CptAssortmentView.jsp?paraid="+assortid+"'>"+assortname+"</a>";
String needfav ="1";
String needhelp ="";

%>
<BODY <%if(!remindsubmit.equals("")) {%> onload="remindsubmit()" <%}else{%> onload="depisnull()" <%}%> >

<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<% 
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;


RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:dosubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;


RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:back(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM id=weaver name=weaver action="/cpt/maintenance/AssortShareOperation.jsp" >
<input type="hidden" name="method" value="add">
<input type="hidden" name="assortid" value="<%=assortid%>">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:0px">
	<td height="0" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

			 <TABLE class=ViewForm>
					<COLGROUP>
					<COL width="20%">
					<COL width="80%">
					<TBODY>
					<TR class=Title>
						<TH colSpan=2></TH>
					  </TR>
					<TR class=Spacing style="height:2px">
					  <TD class=Line1 colSpan=2></TD></TR>
					<TR>
					  <TD >
			<SELECT name=sharetype onchange="onChangeSharetype()" class=InputStyle>
			  <option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>
			  <option value="2" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
			  <option value="3"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>
			  <option value="4"><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%>
			  <option value="5"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
			</SELECT>
					  </TD>
					  <TD class=field>
			<BUTTON class=Browser type="button" style="display:none" onClick="onShowResource('showrelatedsharename','relatedshareid')" name=showresource></BUTTON> 
			<BUTTON class=Browser  type="button" style="display:" onClick="onShowDepartment('showrelatedsharename','relatedshareid')" name=showdepartment></BUTTON> 
			 <button class=browser style="display:none" onClick="onShowSubcompany('showrelatedsharename','relatedshareid')" name=showsubcompany></button>
			<BUTTON class=Browser type="button"  style="display:none" onclick="onShowRole('showrelatedsharename','relatedshareid')" name=showrole></BUTTON>
			 <INPUT type=hidden name=relatedshareid value="<%=user.getUserDepartment()%>">
			 <span id=showrelatedsharename name=showrelatedsharename ><%=Util.toScreen(DepartmentComInfo.getDepartmentname(""+user.getUserDepartment()),user.getLanguage())%></span>
			<span id=showrolelevel name=showrolelevel style="visibility:hidden">
			&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
			<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>:
			<SELECT name=rolelevel class=InputStyle>
			  <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
			  <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
			  <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
			</SELECT>
			</span>
			&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
			<span id=showseclevel name=showseclevel>
			<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:
			<INPUT class=InputStyle maxLength=3 size=5 
						name=seclevel onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("seclevel");checkinput("seclevel","seclevelimage")' value="10">
			</span>
			<SPAN id=seclevelimage></SPAN>

					  </TD>		
					</TR>
					<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
					<TR>
					  <TD >
						<%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>
					  </TD>
					  <TD class=field>
						<SELECT name=sharelevel class=InputStyle>
						  <option value="1"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
						  
						  <option value="2"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
						
						</SELECT>
					  </TD>		
					</TR>
					<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
					</TBODY>
				  </TABLE>
			</form>

			<BR>
			 <table class=ViewForm>
					  <colgroup> <col width="30%"> <col width="60%"> <col width="10%"> <tbody> 
					  <tr class=Title> 
						<th ><%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%></th>
						<td align=right colspan=2 >&nbsp;
						</td>
					  </tr>
					  <tr class=Spacing style="height:2px"> 
						<td class=Line1 colspan=3></td>
					  </tr>
				   <%
				   RecordSet.executeSql("select * from CptAssortmentShare where assortmentid="+assortid);
				   while(RecordSet.next()){
				if(RecordSet.getInt("sharetype")==1)	{
			%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
					  <td class=Field> <a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("userid")%>" target="_blank"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("userid")),user.getLanguage())%></a>/
						<% if(RecordSet.getInt("sharelevel")==1){%>
						<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
						<%}%>
						<% if(RecordSet.getInt("sharelevel")==2){%>
						<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
						<%}%> </td>
					  <td class=Field> 
						<%if(RecordSet.getInt("sharelevel")==1){%>
						<a href="/cpt/maintenance/AssortShareOperation.jsp?method=delete&id=<%=RecordSet.getString("id")%>&assortid=<%=assortid%>&assortname=<%=assortname%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
						<%} else if((RecordSet.getInt("sharelevel")==2)&&canedit){%>
						<a href="/cpt/maintenance/AssortShareOperation.jsp?method=delete&id=<%=RecordSet.getString("id")%>&assortid=<%=assortid%>&assortname=<%=assortname%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
						<%}%>
					  </td>
					</tr>
					<TR style="height:1px"><TD class=Line colSpan=3></TD></TR>
					<%}else if(RecordSet.getInt("sharetype")==2)	{%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
					  <td class=Field> <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=RecordSet.getString("departmentid")%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSet.getString("departmentid")),user.getLanguage())%></a>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/
						<% if(RecordSet.getInt("sharelevel")==1){%>
						<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%> 
						<%}%>
						<% if(RecordSet.getInt("sharelevel")==2){%>
						<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
						<%}%> </td>
					 <td class=Field> 
						<%if(RecordSet.getInt("sharelevel")==1){%>
						<a href="/cpt/maintenance/AssortShareOperation.jsp?method=delete&id=<%=RecordSet.getString("id")%>&assortid=<%=assortid%>&assortname=<%=assortname%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
						<%} else if((RecordSet.getInt("sharelevel")==2)&&canedit){%>
						<a href="/cpt/maintenance/AssortShareOperation.jsp?method=delete&id=<%=RecordSet.getString("id")%>&assortid=<%=assortid%>&assortname=<%=assortname%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
						<%}%>
					  </td>
					</tr>
					<TR style="height:1px"><TD class=Line colSpan=3></TD></TR>
					<%}else if(RecordSet.getInt("sharetype")==3)	{%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></td>
					  <td class=Field> <%=Util.toScreen(RolesComInfo.getRolesRemark(RecordSet.getString("roleid")),user.getLanguage())%>/
						<% if(RecordSet.getInt("rolelevel")==0) {%>
						<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%> 
						<%} if(RecordSet.getInt("rolelevel")==1) {%>
						<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%> 
						<%} if(RecordSet.getInt("rolelevel")==2) {%>
						<%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%><%}%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/
						<% if(RecordSet.getInt("sharelevel")==1){%>
						<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%> 
						<%}%>
						<% if(RecordSet.getInt("sharelevel")==2){%>
						<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%> 
						<%}%></td>
					  <td class=Field> 
						<%if(RecordSet.getInt("sharelevel")==1){%>
						<a href="/cpt/maintenance/AssortShareOperation.jsp?method=delete&id=<%=RecordSet.getString("id")%>&assortid=<%=assortid%>&assortname=<%=assortname%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
						<%} else if((RecordSet.getInt("sharelevel")==2)&&canedit){%>
						<a href="/cpt/maintenance/AssortShareOperation.jsp?method=delete&id=<%=RecordSet.getString("id")%>&assortid=<%=assortid%>&assortname=<%=assortname%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
						<%}%>
					  </td>
					</tr>
					<TR style="height:1px"><TD class=Line colSpan=3></TD></TR>
					<%}else if(RecordSet.getInt("sharetype")==4)	{%>
					<tr> 
					  <td><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></td>
					  <td class=Field> <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/
						<% if(RecordSet.getInt("sharelevel")==1){%>
						<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%> 
						<%}%>
						<% if(RecordSet.getInt("sharelevel")==2){%>
						<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
						<%}%> </td>
					  <td class=Field> 
						<%if(RecordSet.getInt("sharelevel")==1){%>
						<a href="/cpt/maintenance/AssortShareOperation.jsp?method=delete&id=<%=RecordSet.getString("id")%>&assortid=<%=assortid%>&assortname=<%=assortname%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
						<%} else if((RecordSet.getInt("sharelevel")==2)&&canedit){%>
						<a href="/cpt/maintenance/AssortShareOperation.jsp?method=delete&id=<%=RecordSet.getString("id")%>&assortid=<%=assortid%>&assortname=<%=assortname%>" onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
						<%}%>
					  </td>
					</tr>
					<TR style="height:1px"><TD class=Line colSpan=3></TD></TR>
					<%}%>
					<%}%>
					  </tbody> 
					</table>
		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr style="height:0px">
	<td height="0" colspan="3"></td>
</tr>
</table>

<script language=javascript>
  function onChangeSharetype(){
	thisvalue = jQuery("select[name=sharetype]").val();
	jQuery("input[name=relatedshareid]").val("");
	jQuery("#showseclevel").show();

	jQuery("#showrelatedsharename").html("<IMG src='/images/BacoError.gif' align=absMiddle>");

	if(thisvalue==1){
 		jQuery("button[name=showresource]").show();
		jQuery("#showseclevel").hide();
		//TD30060 ����ȫ����Ϊ��ʱ��ѡ��������Դ�����谲ȫ����Ĭ��ֵ10�������޷��ύ����
		jQuery("#seclevelimage").html("");
		if(jQuery("input[name=seclevel]").val()==""){
			jQuery("input[name=seclevel]").val(10);
		}
		//End TD30060
	}
	else{
		jQuery("button[name=showresource]").hide();
	}
	if(thisvalue==2){
 		jQuery("button[name=showdepartment]").show();
	}
	else{
		jQuery("button[name=showdepartment]").hide();
	}
	if(thisvalue==5){
 		jQuery("button[name=showsubcompany]").show();
	}
	else{
		jQuery("button[name=showsubcompany]").hide();
	}
	if(thisvalue==3){
 		jQuery("button[name=showrole]").show();
		jQuery("button[name=showrolelevel]").show();
	}
	else{
		jQuery("button[name=showrole]").hide();
		jQuery("button[name=showrolelevel]").hide();
    }
	if(thisvalue==4){
		jQuery("#showrelatedsharename").html("");
		jQuery("input[name=relatedshareid]").val("-1");

	}
	//TD30060 �л�ʱ�����Ӷ԰�ȫ����Ϊ�յ���ʾ��������Դû�а�ȫ����
	if(jQuery("input[name=seclevel]").val()=="" && thisvalue!=1){
		jQuery("#seclevelimage").html("<IMG src='/images/BacoError.gif' align=absMiddle>");
	}
	//End TD30060
}

 function dosubmit(){
	document.weaver.method.value="submit";
	document.weaver.submit();
 }

 function remindsubmit(){
 	//add TD30059 �û�û���������ţ�Ϊ�գ�����ѡ��Ҫ��ʾ������
 	if (jQuery("input[name=relatedshareid]").val()=="0"||jQuery("input[name=relatedshareid]").val()==""){
	 	var dep = "<%=Util.toScreen(DepartmentComInfo.getDepartmentname(""+user.getUserDepartment()),user.getLanguage())%>";
	 	jQuery("#showrelatedsharename").html("<IMG src='/images/BacoError.gif' align=absMiddle>");
		} 	
 	//End TD30059
	alert("��ǰ���滹δ�����ã����ύ��")
 }
 //add TD30059 �û�û���������ţ�Ϊ�գ�����ѡ��Ҫ��ʾ������
 function depisnull(){
 	if (jQuery("input[name=relatedshareid]").val()=="0"||jQuery("input[name=relatedshareid]").val()==""){
	 	var dep = "<%=Util.toScreen(DepartmentComInfo.getDepartmentname(""+user.getUserDepartment()),user.getLanguage())%>";
	 	jQuery("#showrelatedsharename").html("<IMG src='/images/BacoError.gif' align=absMiddle>");
	 } 	
 }
 //End TD30059
</script>
<!--
<SCRIPT language=VBS>
sub onShowDepartment(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&document.all(inputename).value)
	if NOT isempty(id) then
	        if id(0)<> "" and id(0)<> "0" then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		document.all(inputename).value=""
		end if
	end if
end sub

sub onShowResource(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		document.all(inputename).value=""
		end if
	end if
end sub

sub onShowRole(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		document.all(inputename).value=""
		end if
	end if
end sub

</SCRIPT>-->
<script language="javascript">
   function onShowSubcompany(tdname,inputname) {
	var id = null;
	
	
		id = window
				.showModalDialog(
						"/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
								+ $GetEle(inputname).value, "",
						"dialogWidth:550px;dialogHeight:550px;center:1;addressbar=no;status=0;resizable=0;");
	
	var issame = false;
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != 0) {
			if (wuiUtil.getJsonValueByIndex(id, 0) == $GetEle(inputname).value) {
				issame = true;
			}
			$GetEle(tdname).innerHTML = wuiUtil
					.getJsonValueByIndex(id, 1);
			$GetEle(inputname).value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle(tdname).innerHTML = "";
			$GetEle(inputname).value = "";
		}
	}
}

function onShowDepartment(tdname,inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+jQuery("input[name="+inputename+"]").val());
	if (data!=null){
	    if (data.id != "" && data.id != "0"){
			jQuery("#"+tdname).html(data.name);
			jQuery("input[name="+inputename+"]").val(data.id);
		}else{
			jQuery("#"+tdname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			jQuery("input[name="+inputename+"]").val("");
		}
	}
}

function onShowResource(tdname,inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (data!=null){
	    if (data.id != "" && data.id != "0"){
			jQuery("#"+tdname).html(data.name);
			jQuery("input[name="+inputename+"]").val(data.id);
		}else{
			jQuery("#"+tdname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			jQuery("input[name="+inputename+"]").val("");
		}
	}
}

function onShowRole(tdname,inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
	if (data!=null){
	    if (data.id != "" && data.id != "0"){
			jQuery("#"+tdname).html(data.name);
			jQuery("input[name="+inputename+"]").val(data.id);
		}else{
			jQuery("#"+tdname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			jQuery("input[name="+inputename+"]").val("");
		}
	}
}

 function onSubmit()
{
	//add TD30059 ��Ϊ����ѡ��ʱ���û�û����������Ϊ0������Ϊ�գ���ֹsubmit�ύ
	if(document.all("relatedshareid").value=="0"&&document.all("sharetype").value=="2"){
		document.all("relatedshareid").value="";
	}
	//End TD30059 
	if (check_form(weaver,"itemtype,relatedshareid,sharetype,rolelevel,seclevel,sharelevel"))
	weaver.submit();
}

 function back()
{
	window.history.back(-1);
}
</script>
</BODY>
</HTML>
