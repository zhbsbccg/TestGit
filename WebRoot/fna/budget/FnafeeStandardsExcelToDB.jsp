<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.security.AclManager " %>
<%@ page import="weaver.docs.category.* " %>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.net.URLDecoder.*"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%><!--added by xwj for td2023 on 2005-05-20-->
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryManager" class="weaver.docs.category.SecCategoryManager" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryDocTypeComInfo" class="weaver.docs.category.SecCategoryDocTypeComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="MouldManager" class="weaver.docs.mouldfile.MouldManager" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput.js"></script>
<SCRIPT language="javascript" src="/js/weaver.js"></script>

</head>
<% 
String imagefilename = "/images/hdMaintenance.gif";
String titlename = "费用标准导入";
String needfav ="1";
String needhelp ="";  

%>   
<BODY> 
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSave(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
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


<FORM id=cms name=cms action="FnafeeStandardsExcelToDBOperation.jsp" method=post enctype="multipart/form-data">

<TABLE class="viewForm">
<COLGROUP>
<COL width="40%">
<COL width="60%">
<TBODY>
<TR class=Title>
    <TH  colSpan="2"><%=titlename%></TH>
</TR>
<TR class=Spacing style="height: 1px">
    <TD class=Line1  colSpan="2"></TD>
</TR>

<tr>
<td>
<%=SystemEnv.getHtmlLabelName(16699,user.getLanguage())%>
</td>
<td>
<input class=InputStyle  type=file size=40 name="filename" id="filename">
</td>
</tr>
<TR style="height: 1px"><TD class=Line colSpan="2"></TD></TR>
<tr>
<td id="msg" align="left" colspan="2"><font  size="2" color="#FF0000">
<%

String msg=Util.null2String(request.getParameter("msg"));
String msg1=Util.null2String(request.getParameter("msg1"));
String msg2=Util.null2String(request.getParameter("msg2"));
String msg3=Util.null2String(request.getParameter("msg3"));
String msg4=Util.null2String(request.getParameter("msg4"));
String msg5=Util.null2String(request.getParameter("msg5"));
String msg6=Util.null2String(request.getParameter("msg6"));
String msg7=Util.null2String(request.getParameter("msg7"));
int    dotindex=0;
int    cellindex=0;
int    msgsize;
int    msgsize567;
int    msgEmailsize;

if (Util.null2String(request.getParameter("msgsize"))==""){
	   msgsize=0;
	}else{
	msgsize=Integer.valueOf(Util.null2String(request.getParameter("msgsize"))).intValue();
	}
if (Util.null2String(request.getParameter("msgsize567"))==""){
	msgsize567=0;
}else{
	msgsize567=Integer.valueOf(Util.null2String(request.getParameter("msgsize567"))).intValue();
}
if (Util.null2String(request.getParameter("msgEmailsize"))==""){
	msgEmailsize=0;
	}else{
		msgEmailsize=Integer.valueOf(Util.null2String(request.getParameter("msgEmailsize"))).intValue();
	}

if (msg.equals("success")){
msg=titlename+"成功!";
}else if(msg.equals("bad")){
msg=SystemEnv.getHtmlLabelName(20040,user.getLanguage());
}else{
	
	for (int i=0;i<msgsize;i++){
		dotindex=msg1.indexOf(",");
		cellindex=msg2.indexOf(",");
		out.println(SystemEnv.getHtmlLabelName(18620,user.getLanguage())+"&nbsp;"+msg1.substring(0,dotindex)+"&nbsp;"+SystemEnv.getHtmlLabelName(18621,user.getLanguage())+"&nbsp;"+msg2.substring(0,cellindex)+"&nbsp;"+SystemEnv.getHtmlLabelName(18622,user.getLanguage()));

		 msg1=msg1.substring(dotindex+1,msg1.length());
	     msg2=msg2.substring(cellindex+1,msg2.length());
	}
	
	for (int i=0;i<msgsize567;i++){
		dotindex=msg5.indexOf(",");
		cellindex=msg6.indexOf(",");
		int msgInfoIdIndex = msg7.indexOf(",");
		int msgInfoId = Util.getIntValue(msg7.substring(0,msgInfoIdIndex), 0);
		out.println(SystemEnv.getHtmlLabelName(18620,user.getLanguage())+"&nbsp;"+msg5.substring(0,dotindex)+"&nbsp;"+
			SystemEnv.getHtmlLabelName(18621,user.getLanguage())+"&nbsp;"+msg6.substring(0,cellindex)+"&nbsp;"+
			SystemEnv.getHtmlLabelName(msgInfoId,user.getLanguage()));

		 msg5=msg5.substring(dotindex+1,msg5.length());
	     msg6=msg6.substring(cellindex+1,msg6.length());
	     msg7=msg7.substring(msgInfoIdIndex+1,msg7.length());
	}
	
	for (int j=0;j<msgEmailsize;j++){
		dotindex=msg3.indexOf(",");
		cellindex=msg4.indexOf(",");
		out.println("&nbsp;"+SystemEnv.getHtmlLabelName(18620,user.getLanguage())+"&nbsp;"+msg3.substring(0,dotindex)+"&nbsp;"+SystemEnv.getHtmlLabelName(18621,user.getLanguage())+"&nbsp;"+msg4.substring(0,cellindex)+"&nbsp;"+SystemEnv.getHtmlLabelName(19777,user.getLanguage()));

		 msg3=msg3.substring(dotindex+1,msg3.length());
	     msg4=msg4.substring(cellindex+1,msg4.length());
	}

}

out.println(msg);
%></font>
</td>
</tr>

<TR>
    <TD height="15" colspan="2"></TD>
</TR>
</TBODY>
</table>


<TABLE class="viewForm">
<COLGROUP>
<COL width="50%">
<COL width="50%">
<TBODY>



<TR class=Title>
    <TH  colSpan="2"><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TH>
</TR>
<TR class=Spacing  style="height: 1px">
    <TD class=Line1  colSpan="2"></TD>
</TR>


<%if(user.getLanguage()==8){%>
<TR>
  <TD  colspan="2">
                    <p><strong>Import Step:</strong></p>

                    <ul>
					  <li><strong>Step One,</strong><a href=feetemplet.xls>Download excel document mould</a> first.</li>
					  <li><strong>Step Two,</strong>After downloaded,input the content.The content should be inputed has more description.Confirm the format of your excel file has the same to the mould,and hasn't been updated.</li>
					  <li><strong>Step Three,</strong>Click the 'submit' of right menu,turn to import of customer.</li>
					  <li><strong>Step Four,</strong>If upwards steps and excel file are true,the page will give the note of right,else it will give the wrong of the excel file.</li>
                    </ul> 
					
  </TD>
</TR>
<TR style="height: 1px"><TD class=Line colSpan="2"></TD></TR>

<TR style="height: 15px">
    <TD height="15" colspan="2"></TD>
</TR>
<%}else if(user.getLanguage()==9){%> 
<TR>  
   <TD colspan="2"> 
                     <p><strong>導入步驟：</strong></p> 

                     <ul> 
						<li>第一步，先<a href=feetemplet.xls>下載Excel文檔模版</a>。 </li> 
						<li>第二步，下載後，填寫內容，注意，要填寫的內容在下邊的說明中有詳細的說明，請一定要確定你的Excel文檔的格式是模板中的格式，而沒有被修改掉。 </li> 
						<li>第三步，點擊右鍵的提交，進入费用标准的導入。 </li> 
						<li>第四步，如果以上步驟和Excel文件正確的話，則會被正確的導入，也會出現提示。如果有問題，則會提示Excel文件的錯誤之處。 </li> 
                     </ul> 

   </TD> 
</TR> 
<TR style="height: 1px"><TD class=Line colSpan="2"></TD></TR> 


<TR style="height: 15px"> 
     <TD height="15" colspan="2"></TD> 
</TR> 
<%}else{%>
<TR>
  <TD  colspan="2">
                    <p><strong>导入步骤：</strong></p>

                    <ul>
					  <li>第一步，先<a href=feetemplet.xls>下载Excel文档模版</a>。</li>
					  <li>第二步，下载后，填写内容，注意，要填写的内容在下边的说明中有详细的说明，请一定要确定你的Excel文档的格式是模板中的格式，而没有被修改掉。</li>
					  <li>第三步，点击右键的提交，进入费用标准的导入。</li>
					  <li>第四步，如果以上步骤和Excel文件正确的话，则会被正确的导入，也会出现提示。如果有问题，则会提示Excel文件的错误之处。</li>
                    </ul> 
					
  </TD>
</TR>
<TR style="height: 1px"><TD class=Line colSpan="2"></TD></TR>
<TR style="height: 15px">
    <TD height="15" colspan="2"></TD>
</TR>

<%}%>

<TR style="height: 15px">
    <TD height="15" colspan="2"></TD>
</TR>
</TBODY>
</table>
<a href="FnafeeStandardsEdit.jsp">创建费用标准</a>
<div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>

</FORM>

		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="2"></td>
</tr>

<tr>
<td height="10" colspan="2">
<TABLE width="100%">
  <tr>
    <td valign="top">                                                                                    
        <%
		  BaseBean bb = new BaseBean();
		  String _roleId = Util.null2String(bb.getPropValue("roleId4FnaBudget", "roleId")).trim(); 
		  
        String tableString = "";
        
        String backfields = " bb.*,ff.* ";//id, seclevel, citylevel, feetype, feestandard
        String fromSql = " from fnafeestandards bb "+
						 " left join FnaBudgetFee ff on bb.feetype=ff.id";
        String sqlWhere = " where 1=1 "+
        		" and exists (select 1 ct from FnaBudgetFee aa where aa.id = bb.feetype and exists (select 1 from hrmrolemembers a, fnabudgetfeetype_role b where a.roleid = b.roleid and b.roleid in ("+_roleId+") and aa.subcompanyid1 = b.subcompanyid and a.resourceid = "+user.getUID()+") ) ";
        String orderby = " bb.id ";
        
        String sqlprimarykey = "bb.id";
          
        //out.println("select "+backfields+fromSql+sqlWhere);
        tableString =" <table instanceid=\"workflowRequestListTable\" tabletype=\"checkbox\" pagesize=\"50\" >"+
                     "	   <sql backfields=\""+Util.toHtmlForSplitPage(backfields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+Util.toHtmlForSplitPage(orderby)+"\"  sqlprimarykey=\""+Util.toHtmlForSplitPage(sqlprimarykey)+"\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
                     "			<head>";
        tableString+="				<col width=\"16%\"  text=\"标识\" "+
        			   " column=\"id\" orderkey=\"id\" href=\"FnafeeStandardsEdit.jsp\" linkkey=\"id\"  />";
        tableString+="				<col width=\"16%\"  text=\"人员安全级别\" "+
        			   " column=\"seclevel\" orderkey=\"seclevel\" />";
        tableString+="				<col width=\"16%\"  text=\"城市级别\" "+
        	           " column=\"citylevel\" orderkey=\"citylevel\" />";
        tableString+="				<col width=\"16%\"  text=\"费用明细id\" "+
					   " column=\"feetype\" orderkey=\"feetype\" />";
		tableString+="				<col width=\"16%\"  text=\"费用明细名称\" "+
					   " column=\"name\" orderkey=\"feetype\" />";
		tableString+="				<col width=\"16%\"  text=\"费用标准\" "+
					   " column=\"feestandard\" orderkey=\"feestandard\" />";
        tableString+="			</head>"+   			
                     "</table>";
        %>
        
        <wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" />
    </td>
  </tr>
</TABLE>
</td>
</tr>

</table>

</body>


<script language="javascript">
function onSave(obj){
	if (cms.filename.value==""){
		alert("<%=SystemEnv.getHtmlLabelName(18618,user.getLanguage())%>");
	}else{
		var showTableDiv  =$G('_xTable');
		var message_table_Div = document.createElement("div"); 
		message_table_Div.id="message_table_Div";
		message_table_Div.className="xTable_message";
		showTableDiv.appendChild(message_table_Div);
		var message_table_Div  = document.getElementById("message_table_Div");
		message_table_Div.style.display="inline";
		message_table_Div.innerHTML="<%=SystemEnv.getHtmlLabelName(18623,user.getLanguage())%>....";
		var pTop= document.body.offsetHeight/2-60;
		var pLeft= document.body.offsetWidth/2-100;
		message_table_Div.style.position="absolute";
		message_table_Div.style.posTop=pTop;
		message_table_Div.style.posLeft=pLeft;
	
		cms.submit();
		obj.disabled = true;
	}
}
</script>
