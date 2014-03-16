<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="CptShare" class="weaver.cpt.capital.CptShare" scope="page" />
<jsp:useBean id="bb" class="weaver.general.BaseBean" scope="page"/>
<%
char flag = 2;
String ProcPara = "";
String id = Util.null2String(request.getParameter("id"));
String method = Util.null2String(request.getParameter("method"));
String assortid = Util.null2String(request.getParameter("assortid")); 
String relatedshareid = Util.null2String(request.getParameter("relatedshareid")); 
String sharetype = Util.null2String(request.getParameter("sharetype")); 
String rolelevel = Util.null2String(request.getParameter("rolelevel")); 
String seclevel = Util.null2String(request.getParameter("seclevel"));
String sharelevel = Util.null2String(request.getParameter("sharelevel"));

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

String userid = "0" ;
String departmentid = "0" ;
String roleid = "0" ;
String foralluser = "0" ;
String subcompanyid="0";

if(sharetype.equals("1")) userid = relatedshareid ;
if(sharetype.equals("2")) departmentid = relatedshareid ;
if(sharetype.equals("3")) roleid = relatedshareid ;
if(sharetype.equals("4")) foralluser = "1" ;
if(sharetype.equals("5")) subcompanyid=relatedshareid;
bb.writeLog("subcompanyid:"+subcompanyid);
String name = "";

if(method.equals("delete"))
{

	RecordSet.executeSql("delete from CptAssortmentShare where id="+id);
    CptShare.SetAssortShare(assortid);
/**************************
	name = SystemEnv.getHtmlLabelName(535,user.getLanguage())+SystemEnv.getHtmlLabelName(119,user.getLanguage())+":"+assortname;

	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
    SysMaintenanceLog.setOperateItem("51");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setRelatedName(name);
	SysMaintenanceLog.setOperateType("3");
	SysMaintenanceLog.setOperateDesc("CptCapitalShareInfo_Delete,"+id);
	SysMaintenanceLog.setSysLogInfo();

*/

    String forward=Util.null2String(request.getParameter("forward"));
    if(forward.equals("view")){
       response.sendRedirect("/cpt/maintenance/CptAssortmentView.jsp?paraid="+assortid);
       return;
    }else{
	   response.sendRedirect("/cpt/maintenance/CptAssortmentAddShare.jsp?assortmentid="+assortid);
	   return;
	}
	
}


if(method.equals("add"))
{
	
	if(sharetype.equals("5")){
		String sql1="select id from HrmDepartment where subcompanyid1='"+subcompanyid+"'";
		bb.writeLog(sql1);
		rs2.execute(sql1);
		while(rs2.next()){
			departmentid=Util.null2String(rs2.getString("id"));
			ProcPara = assortid;
			ProcPara += flag+"2";
			ProcPara += flag+seclevel;
			ProcPara += flag+rolelevel;
			ProcPara += flag+sharelevel;
			ProcPara += flag+userid;
			ProcPara += flag+departmentid;
			ProcPara += flag+roleid;
			ProcPara += flag+foralluser;
			//��CptAssortmentShare�����һ����¼����Ĺ�����Ϣ
			bb.writeLog(ProcPara);
			RecordSet.executeProc("CptAssortmentShare_Insert",ProcPara);
		}
	}else{
			ProcPara = assortid;
			ProcPara += flag+sharetype;
			ProcPara += flag+seclevel;
			ProcPara += flag+rolelevel;
			ProcPara += flag+sharelevel;
			ProcPara += flag+userid;
			ProcPara += flag+departmentid;
			ProcPara += flag+roleid;
			ProcPara += flag+foralluser;
			//��CptAssortmentShare�����һ����¼����Ĺ�����Ϣ
	
			RecordSet.executeProc("CptAssortmentShare_Insert",ProcPara);
	}
	
	
	
	//��CptAssortmentShare�����һ����¼����Ĺ�����Ϣ
	
	RecordSet.executeProc("CptAssortmentShare_Insert",ProcPara);
	
	
		
/************************	
	RecordSet.next();
	String tempid = RecordSet.getString("id");
	name = SystemEnv.getHtmlLabelName(535,user.getLanguage())+SystemEnv.getHtmlLabelName(119,user.getLanguage())+":"+assortname;
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(Util.getIntValue(tempid));
	SysMaintenanceLog.setOperateItem("51");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setRelatedName(name);
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc("CptCapitalShareInfo_Insert,"+tempid);
	SysMaintenanceLog.setSysLogInfo();
	CptShare.setCptShareByCpt(assortid);
*/
	response.sendRedirect("/cpt/maintenance/CptAssortmentAddShare.jsp?assortmentid="+assortid+"&remindsubmit=1");
	return;
}
/*�Ȳ������޸�
if(method.equals("edit"))
{
	ProcPara = id;
	ProcPara += assortid;
	ProcPara += flag+sharetype;
	ProcPara += flag+seclevel;
	ProcPara += flag+rolelevel;
	ProcPara += flag+sharelevel;
	ProcPara += flag+userid;
	ProcPara += flag+departmentid;
	ProcPara += flag+roleid;
	ProcPara += flag+foralluser;

	RecordSet.executeProc("CptCapitalShareInfo_Update",ProcPara);
CptShare.setCptShareByCpt(assortid);
	response.sendRedirect("/cpt/capital/CptCapital.jsp?id="+assortid);
	return;
}
*/

if(method.equals("submit"))
{
    CptShare.SetAssortShare(assortid);
    response.sendRedirect("/cpt/maintenance/CptAssortmentView.jsp?paraid="+assortid);
	return;
}
%>
