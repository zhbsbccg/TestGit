
<%@ page import="weaver.general.*,weaver.file.*"%>
<%@ page import="weaver.conn.*"%>
<%@ page import="weaver.file.Prop"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@ page import="java.math.*" %>
<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/systeminfo/init.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo"
	class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo"
	class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo"
	class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="HrmSearchComInfo"
	class="weaver.hrm.search.HrmSearchComInfo" scope="session" />
<META HTTP-EQUIV="pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache, must-revalidate">
<META HTTP-EQUIV="expires" CONTENT="Wed, 26 Feb 1997 08:21:57 GMT">
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>
<jsp:useBean id="CapitalTypeComInfo" class="weaver.cpt.maintenance.CapitalTypeComInfo" scope="page"/>
<script type="text/javascript" src="../../js/jquery/jquery-1.4.2.min.js">

</script>

<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>


<%

//if(!HrmUserVarify.checkUserRight("add_customer:add", user)){
 //   response.sendRedirect("/notice/noright.jsp");
  //  return;
//}
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+"��ѯ"+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
	
RCMenu += "{"+"ɾ��"+",javascript:ondelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<%
String capitalgroupid = Util.null2String(request.getParameter("capitalgroupid"));/*�ʲ�����*/
String capitaltypeid = Util.null2String(request.getParameter("capitaltypeid"));/*�ʲ�����*/
String manufacturerv = Util.null2String(request.getParameter("manufacturerv"));/*�ʲ�����*/
String rktype = Util.null2String(request.getParameter("rktype"));/*�ʲ�����*/
String statusv = Util.null2String(request.getParameter("statusv"));/*�ʲ�����*/
String namev = Util.null2String(request.getParameter("namev"));/*�ʲ�����*/
String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));/*�ֲ�*/
String department=Util.null2String(request.getParameter("department"));/*����*/
String manager=Util.null2String(request.getParameter("operater"));//ʹ����
String danwei = Util.null2String(request.getParameter("danwei") );
String fromdate =Util.null2String(request.getParameter("fromdate")) ;
String todate =Util.null2String(request.getParameter("todate"))  ;

String zhixingrenid=Util.null2String(request.getParameter("zhixingrenid"));
String fromdate1 =Util.null2String(request.getParameter("fromdate1"))  ;
String todate1 =Util.null2String(request.getParameter("todate1"))  ;
String operatortime =Util.null2String(request.getParameter("operatortime"))  ;

	String idss=request.getParameter("arrayid");
	if(idss!=null&&!idss.equals("")){
    String ids[]=request.getParameter("arrayid").split(",");
	System.out.println(request.getParameter("arrayid").length());
	String sqformid= Prop.getPropValue(GCONST.getConfigFile(), "sqformid");
	String lyformid= Prop.getPropValue(GCONST.getConfigFile(), "lyformid");
	for(int i=0;i<ids.length;i++){
 		String cptid=(String)ids[i];
 		String sql="";
 		 sql="delete from  formtable_main_"+lyformid+"_dt1 where wpmc="+cptid;//�����Զ���
		rs.executeSql(sql);
		sql="delete from  formtable_main_"+sqformid+"_dt1 where t2="+cptid;//�����д���ʲ�id
		rs.executeSql(sql);
 		
 		 sql="delete from bill_CptFetchDetail where cptid="+cptid;//���õ���
  		rs.executeSql(sql);
  	
  		sql="delete from cptsharedetail where cptid="+cptid;
		rs.executeSql(sql);
		sql="delete from cptcapitalshareinfo where   relateditemid="+cptid;//ɾ��
		rs.executeSql(sql);
		sql="delete from cptcapital where   id="+cptid;//ɾ��
		rs.executeSql(sql);
	}
	}

 %>


<form name="weaver" >
<input type="hidden" name="arrayid">
<table class=ViewForm width="100%" >
 
 
  <tbody>
    <tr>
    

					  <td width="10%">�ʲ�����</td>
					  <td   width="20%" class=Field>
						
					   <input type=text name=namev value="<%=namev%>">
					 </td>


					 
					  <td width="10%">�ʲ�����</td>
					  <td width="20%" class=Field>
						
					   <input type=text name=manufacturerv value="<%=manufacturerv%>">
					 </td>
					 
					  <td width="10%">�ʲ���</td>
					   <td class=Field> <button type=button  class=Browser onClick="onShowCapitalgroupid()"></button> 
					  <span id=capitalgroupidspan ><%=Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(capitalgroupid),user.getLanguage())%>
					 </span> 
					 <input type=hidden name=capitalgroupid value="<%=capitalgroupid%>">
					 </td>
   
</tr>
<tr>
<!-- �ֲ� -->
<td><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%></td>
<td class=Field>
 <button type=button  class=Browser id=SelectSubCompany onClick="onShowSubcompany()"></BUTTON>
            <SPAN id=subcompanyidspan><%=SubCompanyComInfo.getSubCompanyname(String.valueOf(subcompanyid))%></SPAN>
		    <INPUT class=inputstyle id=subcompanyid type=hidden name=subcompanyid value="<%=subcompanyid%>">
</td>
<!-- ���� -->
<td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
<td class=Field>
<%
String departmentStr="";


if(!department.equals("")){
String[] deparments=department.split(",");
System.out.print("zhb:========"+deparments.length);

	for(int i=0;i<deparments.length;i++){
		departmentStr =departmentStr+DepartmentComInfo.getDepartmentname(deparments[i])+" ";
	}
	
	
}

	

 %>
<button class=Browser type="button" onClick="onShowDepartment()"></button>
                 <span  id=departmentspan><%=departmentStr%></span>
                 <input class=inputstyle id=department type=hidden name=department value="<%=department%>">
 </td>
<!--  ���� -->
<td>ʹ����</td>
<td class=Field>
<button class=browser onClick="onShowResource2()"></button>
						<span id=resourcespan><%=ResourceComInfo.getResourcename(manager)%></span>
						<input name=operater type=hidden value="<%=manager%>">
</td>
</tr>
</tbody>
</table>
<TABLE class= BroswerStyle  width="2500"  cellspacing=1>

 <TR>
    <Td  colSpan=18>
    <Strong>�ʲ�����</Strong>
     </Td>
</TR><TR class= DataHeader>



<td>
<%					int pagenum = Util.getIntValue(request.getParameter("pagenum"), 1);
					int perpage = 50;
		            String backfields = "  t1.id, t1.mark,t1.name,t1.capitalspec,t1.startprice,t1.departmentid,t1.resourceid,t1.capitalnum,t2.subcompanyid1";
		            String fromSql  = "  CptCapital t1 "+
									"	left join HrmDepartment t2 on t1.departmentid=t2.id ";
		            String sqlWhere = " where isdata=2  ";
		            String orderby = "t1.id" ;
		          
			        if(!"".equals(capitaltypeid)){	           
			        	  sqlWhere+=" and t1.capitaltypeid in ("+capitaltypeid+")";  
			         }
			      
			        if(!"".equals(namev)){	           
			        	  sqlWhere+=" and t1.name like '%"+namev+"%'";  
			         }
			        if(!"".equals(manufacturerv)){	           
			        	  sqlWhere+=" and t1.mark like '%"+manufacturerv+"%'";  
			         }
			        
					if(!"".equals(manager)){	           
			        	  sqlWhere+=" and t1.resourceid ='"+manager+"'";  
			         }
			       
			        if(!"".equals(capitalgroupid)){	           
			        	  sqlWhere+=" and t1.capitalgroupid ='"+capitalgroupid+"'";  
			         }
			         if(!"".equals(subcompanyid)){
			         	sqlWhere+=" and t2.subcompanyid1='"+subcompanyid+"'";
			         }
			         if(!"".equals(department)){
			         	sqlWhere+=" and t1.departmentid in ("+department+")";
			         }
			   		
		           String tableString = " <table instanceid=\"cptcapitalDetailTable\" tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+

		                                    "		<sql backfields=\""+Util.toHtmlForSplitPage(backfields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+Util.toHtmlForSplitPage(orderby)+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"desc\" sqlisdistinct=\"true\"/>"+
		                                    "		<head>"+
		                                 
		                           
		                                    " <col width=\"10%\"   text=\""+"�ʲ����"+"\" column=\"mark\" />"+
		                                    " <col width=\"10%\"   text=\""+"�ʲ�����"+"\" column=\"name\" />"+
		                                 
		                                    " <col width=\"10%\"   text=\""+"����ͺ�"+"\" column=\"capitalspec\" />"+
		                                    " <col width=\"5%\"   text=\""+"����"+"\" column=\"capitalnum\" />"+
		                                  
		                                    " <col width=\"5%\"   text=\""+"����"+"\" column=\"startprice\" />"+
		                              
		                                
		                        		    " <col width=\"10%\"   text=\""+"ʹ����"+"\" column=\"resourceid\"  transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\"  />"+ 
		                                    " <col width=\"10%\"   text=\""+"ʹ�ò���"+"\" column=\"departmentid\" transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentname\" />"+
		                                   " <col width=\"10%\"   text=\""+"ʹ�÷ֲ�"+"\" column=\"subcompanyid1\" transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubCompanyname\" />"+
		                                   
		       
		                                     "		</head>"+
		                                     "</table>";
		                                    // new BaseBean().writeLog(backfields+""+fromSql+""+sqlWhere);
		                                  //  System.out.print("zhb:========"+backfields+""+fromSql+""+sqlWhere);
		         %>
		         <wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" />


</td>

</TR>


<TR class=Line>
<TD colSpan=3></TD>
</TR>

<TR class=DataDark>
</TABLE>
<script>
function onShowResource2() {
	var id = window.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
					, ""
					, "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			$GetEle("resourcespan").innerHTML = "<A href='/hrm/resource/HrmResource.jsp?id=" + wuiUtil.getJsonValueByIndex(id, 0) + "'>" + wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			$GetEle("operater").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("resourcespan").innerHTML = "";
			$GetEle("operater").value = "";
		}
	}
}
function onShowDepartment(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+jQuery("#department").val());    
    if (data!=null){
		if (data.id != "" ){
			ids = data.id.split(",");
			names =data.name.split(",");
			sHtml = "";
			for( var i=0;i<ids.length;i++){
				if(ids[i]!=""){
					sHtml = sHtml+names[i]+"&nbsp;&nbsp;";
				}
			}
			jQuery("#departmentspan").html(sHtml);
			jQuery("input[name=department]").val(data.id.substr(1));
		}else{
			jQuery("#departmentspan").html("");
			jQuery("input[name=department]").val("");
		}
	}
}
function onShowSubcompany() {
	var id = null;
	
	
		id = window
				.showModalDialog(
						"/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
								+ $GetEle("subcompanyid").value, "",
						"dialogWidth:550px;dialogHeight:550px;center:1;addressbar=no;status=0;resizable=0;");
	
	var issame = false;
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != 0) {
			if (wuiUtil.getJsonValueByIndex(id, 0) == $GetEle("subcompanyid").value) {
				issame = true;
			}
			$GetEle("subcompanyidspan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 1);
			$GetEle("subcompanyid").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("subcompanyidspan").innerHTML = "";
			$GetEle("subcompanyid").value = "";
		}
	}
}

function onShowResource(spanname, inputname) {
	var url="";
   	var  tmpids = document.getElementById(inputname).value;
    if(tmpids!="-1"){ 
     url="/hrm/resource/MutiResourceBrowser.jsp?resourceids="+tmpids;
    }else{
     url="/hrm/resource/MutiResourceBrowser.jsp";
    }
    var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
    try {
        jsid = new VBArray(id).toArray();
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0" && jsid[1]!="") {
            document.getElementById(spanname).innerHTML = jsid[1].substring(1);
            document.getElementById(inputname).value = jsid[0].substring(1);
        } else {
            document.getElementById(spanname).innerHTML = "";
            document.getElementById(inputname).value = "";
        }
    }
}
function onShowCapitalgroupid() {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp",
					"", "dialogWidth:550px;dialogHeight:550px;center:1;addressbar=no;status=0;resizable=0;");
	if (id != undefined || id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			$GetEle("capitalgroupidspan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 1);
			$GetEle("capitalgroupid").value = wuiUtil
					.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("capitalgroupidspan").innerHTML = "";
			$GetEle("capitalgroupid").value = "";
		}
	}
}
function onShowCapitaltypeid() {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalTypeBrowser.jsp",
					"", "dialogWidth:550px;dialogHeight:550px;center:1;addressbar=no;status=0;resizable=0;");
	if (id != undefined || id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != 0) {
			$GetEle("capitaltypeidspan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 1);
			$GetEle("capitaltypeid").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("capitaltypeidspan").innerHTML = "";
			$GetEle("capitaltypeid").value = "";
		}
	}
}
function ondelete(){
	document.getElementById("arrayid").value=_xtable_CheckedCheckboxId();
	if(document.getElementById("arrayid").value.length==0){
	      alert('��ѡ��Ҫɾ�����ʲ�');
            return;
	}
weaver.submit();

}
function onSave(){

weaver.submit();

}


</script>
<script language=vbs>
Sub onShowWorkFlow(inputname, spanname)
	Call onShowWorkFlowBase(inputname, spanname, false)
End Sub

Sub onShowWorkFlowNeeded(inputname, spanname)
	Call onShowWorkFlowBase(inputname, spanname, true)
End Sub

Sub onShowWorkFlowBase(inputname, spanname, needed)
	retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp")
	If (Not IsEmpty(retValue)) Then
		If retValue(0) <> "" Then
			document.all(spanname).innerHtml = retValue(1)
			document.all(inputname).value = retValue(0)
		Else 
			document.all(inputname).value = ""
			If needed Then
				document.all(spanname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
			Else
				document.all(spanname).innerHtml = ""
			End If
		End If
	End If
End Sub


</script>
</BODY>
</HTML>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>