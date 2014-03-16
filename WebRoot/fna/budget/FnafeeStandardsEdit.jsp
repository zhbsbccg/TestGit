<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<html>
  <head>
  <LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
  </head>
  
  <body>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = "修改:费用标准";
String needfav ="1";
String needhelp ="";

String id=Util.null2String(request.getParameter("id"));
String seclevel="";
String citylevel="";
String feetype="";
String feestandard="";
if(!id.equals("")){
	String sql="select * from fnafeestandards where id='"+id+"'";
	rs.execute(sql);
	if(rs.next()){
		seclevel=Util.null2String(rs.getString("seclevel"));
		citylevel=Util.null2String(rs.getString("citylevel"));
		feetype=Util.null2String(rs.getString("feetype"));
		feestandard=Util.null2String(rs.getString("feestandard"));
	}
	
}
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
 %>
 <%@ include file="/systeminfo/RightClickMenu.jsp" %>
<TABLE class=Shadow>
		<tr>
		<td width="10"></td>
			<td valign="top">
			
			<form method="post" action="FnafeeStandardsOperation.jsp" name="frmmain">
			<table width=100% class=ViewForm>
		<COLGROUP>
		<COL width="20%"></col>
		<COL width="80%"></col>
		</COLGROUP>
		<TR>
			<TD>标识</TD>
			<TD class=Field><%=id %></TD>
			<input type="hidden" value="<%=id %>" name="id">
        </TR>
        <TR style="height:2px"><TD class=line colspan="2"></TD></TR>
        <TR>
			<TD>人员安全级别</TD>
			<TD class=Field><INPUT class=inputstyle maxLength=30 size=20 name="seclevel" value="<%=seclevel %>" onkeypress="ItemCount_KeyPress()" onchange='checkinput("seclevel","seclevelimage")'><SPAN id=seclevelimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
        </TR>
         <TR style="height:2px"><TD class=line colspan="2"></TD></TR>
         <TR>
			<TD>城市级别</TD>
			<TD class=Field>
			
			<!--<INPUT class=inputstyle maxLength=30 size=20 name="citylevel" value="<%=citylevel %>" onkeypress="ItemCount_KeyPress()" onchange='checkinput("citylevel","citylevelimage")'>  -->
			<select name="citylevel" id="citylevel" onchange='checkinput("citylevel","citylevelimage")'>
				<option value=""></option>
				<option value="1">一级</option>
				<option value="2">二级</option>
				<option value="3">三级</option>
			</select>
			<SPAN id=citylevelimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN>
			
			</TD>
        </TR>
         <TR style="height:2px"><TD class=line colspan="2"></TD></TR>
         <TR>
			<TD>费用明细</TD>
			<TD class=Field>
			<select id="feetype" name="feetype" onchange='checkinput("feetype","feetypeimage")' > 
				<option value=""></option>
				<%
					String sql="select id,name from FnaBudgetFee where subcompanyid1='"+user.getUserSubCompany1()+"'";
					rs.execute(sql);
					while(rs.next()){
						%>
						<option value="<%=Util.null2String(rs.getString("id")) %>"><%=Util.null2String(rs.getString("name")) %></option>
						
						<%
					}
				 %>
			</select>
			<SPAN id=feetypeimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN>
			<!-- <INPUT class=inputstyle maxLength=30 size=20 name="feetype" value="<%=feetype %>" onkeypress="ItemCount_KeyPress()" onchange='checkinput("feetype","feetypeimage")'><SPAN id=feetypeimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN> -->
			
			</TD>
        </TR>
         <TR style="height:2px"><TD class=line colspan="2"></TD></TR>
        <TR>
			<TD>费用标准</TD>
			<TD class=Field><INPUT class=inputstyle maxLength=30 size=20 name="feestandard" value="<%=feestandard %>" onKeyPress="ItemDecimal_KeyPress(this.name, 15, 2)" onchange='checkinput("feestandard","feestandardimage")'><SPAN id=feestandardimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN>
			</TD>
        </TR>
        <TR style="height:2px"> <TD class=line colspan="2"></TD></TR>
</table>
			</form>
			
			
			
			</td>
		</tr>
		</TABLE>
<script language="javascript">
jQuery(function(){
	//费用标准给值
	var fybz="<%=feetype%>";
	var csjb="<%=citylevel%>";
	jQuery("#feetype").val(fybz);
	jQuery("#citylevel").val(csjb);
	//非空判断
	checkinput("feestandard","feestandardimage");
	checkinput("feetype","feetypeimage");
	checkinput("citylevel","citylevelimage");
	checkinput("seclevel","seclevelimage");
});
function doSave(){
	if(check_form(document.frmmain,"seclevel,citylevel,feetype,feestandard")){
		document.frmmain.submit();
	}
}


</script>