<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.file.Prop" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="weaver.rtx.RTXConfig" %>
<%@ page import="weaver.file.Prop,weaver.general.GCONST" %>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RequestCheckUser" class="weaver.workflow.request.RequestCheckUser" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="flowDoc" class="weaver.workflow.request.RequestDoc" scope="page"/>
<jsp:useBean id="RequestDetailImport" class="weaver.workflow.request.RequestDetailImport" scope="page" /> 

<jsp:useBean id="WFForwardManager" class="weaver.workflow.request.WFForwardManager" scope="page" />

<jsp:useBean id="WorkflowManage" class="weaver.workflow.workflow.WorkflowManage" scope="page" />

<%
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
%> 
<%
//��ù������Ļ�����Ϣ
String workflowid = Util.null2String(request.getParameter("workflowid"));
String workflowname = WorkflowComInfo.getWorkflowname(workflowid);
String workflowtype = WorkflowComInfo.getWorkflowtype(workflowid);   //����������
String importwf= WorkflowComInfo.getIsImportwf(workflowid);//�ɵ�������
String nodeid= "" ;
String formid= "" ;
String isbill="0";
int helpdocid = 0;
int messageType=0;
int defaultName=0;
String docCategory="";
String isannexupload="";
String annexdocCategory="";
String needAffirmance="";   //�Ƿ���Ҫ�ύȷ��
String  fromFlowDoc=Util.null2String(request.getParameter("fromFlowDoc"));  //�Ƿ�����̴����ĵ�����
String isworkflowdoc = "0";//�Ƿ��ǹ���,1������
//��session�洢��SESSION�У����������ã��ﵽ��ͬ�����̿���ʹ��ͬһ����򣬲�ͬ������
session.setAttribute("workflowidbybrowser",workflowid);

//��õ�ǰ�û���id�����ͺ����ơ��������Ϊ1����ʾΪ�ڲ��û���������Դ����2Ϊ�ⲿ�û���CRM��
int userid = user.getUID();
String logintype = user.getLogintype();
String username = "";
if(logintype.equals("1"))
	username = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),user.getLanguage());

int fromtest = Util.getIntValue(request.getParameter("fromtest"), 0);
int isvalid = -1;
//��ѯ�ù������ı�id���Ƿ��ǵ��ݣ�0��1�ǣ��������ĵ�id
RecordSet.executeProc("workflow_Workflowbase_SByID",workflowid);
if(RecordSet.next()){
	formid = Util.null2String(RecordSet.getString("formid"));
	isbill = ""+Util.getIntValue(RecordSet.getString("isbill"),0);
	helpdocid = Util.getIntValue(RecordSet.getString("helpdocid"),0);
  //modify by xhheng @20050318 for TD1689, ˳�㽫messageType��docCategory�Ļ�ȡͳһ����
  messageType=RecordSet.getInt("messageType");
  defaultName=RecordSet.getInt("defaultName");
  docCategory=RecordSet.getString("docCategory");
  isannexupload=Util.null2String(RecordSet.getString("isannexUpload"));
  annexdocCategory=Util.null2String(RecordSet.getString("annexdoccategory"));
    needAffirmance=Util.null2o(RecordSet.getString("needAffirmance"));
    isvalid = Util.getIntValue(RecordSet.getString("isvalid"), 0);
}


//��ѯ�ù������ĵ�ǰ�ڵ�id �����Ĺ������Ĵ����ڵ� ��
RecordSet.executeProc("workflow_CreateNode_Select",workflowid);
if(RecordSet.next())  nodeid = Util.null2String(RecordSet.getString(1)) ;


//����û��Ƿ��д���Ȩ��
RequestCheckUser.setUserid(userid);
RequestCheckUser.setWorkflowid(Util.getIntValue(workflowid,0));
RequestCheckUser.setLogintype(logintype);
RequestCheckUser.checkUser();
int  hasright=RequestCheckUser.getHasright();
//modify by mackjoe at 2005-09-14 ���Ӵ����½�����Ȩ��
int isagent=Util.getIntValue(request.getParameter("isagent"),0);
int beagenter=Util.getIntValue(request.getParameter("beagenter"),0);
if(isagent==1){
    hasright=1;
}
session.setAttribute(workflowid+"isagent"+user.getUID(),""+isagent);
session.setAttribute(workflowid+"beagenter"+user.getUID(),""+beagenter);
if((isvalid==2 && fromtest!=1) || isvalid==0){
	hasright = 0;
}
//end by mackjoe
if(hasright==0){
	response.sendRedirect("/notice/noright.jsp");
    return;
}
//�ж��Ƿ������̴����ĵ��������ڸýڵ����������ֶ�
boolean docFlag=flowDoc.haveDocFiled(workflowid,nodeid);
String  docFlagss=docFlag?"1":"0";
session.setAttribute("requestAdd"+user.getUID(),docFlagss);

//�ж������ֶ��Ƿ���ʾѡ��ť
ArrayList newTextList = flowDoc.getDocFiled(workflowid);
if(newTextList != null && newTextList.size() > 0){
  String newTextNodes = ""+newTextList.get(5);
  String flowDocField = ""+newTextList.get(1);
  session.setAttribute("requestFlowDocField"+user.getUID(),flowDocField);
  session.setAttribute("requestAddNewNodes"+user.getUID(),newTextNodes);
}

if (!fromFlowDoc.equals("1"))
{
if (docFlag)
{
isworkflowdoc = "1";
//response.sendRedirect("WorkflowAddRequestDocBody.jsp?workflowid="+workflowid+"&isagent="+isagent);
//return;
}
}
//�Բ�ͬ��ģ����˵,���Զ����Լ���ص����ݣ���Ϊ����Ĭ��ֵ�����罫 docid ��ֵ����Ϊ�������Ĭ���ĵ�
//Ĭ�ϵ�ֵ���Ը�������м��ö��Ÿ�

String prjid = Util.null2String(request.getParameter("prjid"));
String docid = Util.null2String(request.getParameter("docid"));
String crmid = Util.null2String(request.getParameter("crmid"));
String hrmid = Util.null2String(request.getParameter("hrmid"));
String reqid = Util.null2String(request.getParameter("reqid"));
if(hrmid.equals("") && logintype.equals("1")) hrmid = "" + userid ;
if(crmid.equals("") && logintype.equals("2")) crmid = "" + userid ;

//������������ɺ󽫷��ص�ҳ��
String topage = Util.null2String(request.getParameter("topage"));
if(isbill.equals("1")){
	session.setAttribute("topage_ForAllBill",topage);
}



//��õ�ǰ�����ں�ʱ��
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
                     Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
                     Util.add0(today.get(Calendar.SECOND), 2) ;

//�����ύ��ʱ����Ҫ��������ֶ���������������ö��Ÿ񿪣�requestnameΪ�½������е�һ�е�����˵������ÿһ�����󶼱����е�
String needcheck="requestname";



//TopTitle.jsp ҳ�����
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(648,user.getLanguage())+":"
	+SystemEnv.getHtmlLabelName(125,user.getLanguage())+" - "+Util.toScreen(workflowname,user.getLanguage())+" - " +SystemEnv.getHtmlLabelName(125,user.getLanguage());

//if(helpdocid !=0 ) {titlename=titlename + "";}
String needfav ="1";
String needhelp ="";

//add by xhheng @20050206 for TD 1544��requestid��Ϊ-1
String requestid="-1";
//add by mackjoe at 2005-12-20 ����ģ��Ӧ��
String ismode="";
int modeid=0;
int isform=0;
int showdes=0;
String isSignMustInputOfThisJsp="0";
String isFormSignatureOfThisJsp=null;
String FreeWorkflowname="";
int formSignatureWidthOfThisJsp=RevisionConstants.Form_Signature_Width_Default;
int formSignatureHeightOfThisJsp=RevisionConstants.Form_Signature_Height_Default;
RecordSet.executeSql("select ismode,showdes,isFormSignature,formSignatureWidth,formSignatureHeight,freewfsetcurnameen,freewfsetcurnametw,freewfsetcurnamecn,issignmustinput from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);

if(RecordSet.next()){
    ismode=Util.null2String(RecordSet.getString("ismode"));
    showdes=Util.getIntValue(Util.null2String(RecordSet.getString("showdes")),0);
	isFormSignatureOfThisJsp = Util.null2String(RecordSet.getString("isFormSignature"));
	formSignatureWidthOfThisJsp= Util.getIntValue(RecordSet.getString("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
	formSignatureHeightOfThisJsp= Util.getIntValue(RecordSet.getString("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);
    if(user.getLanguage() == 8){
        FreeWorkflowname=Util.null2String(RecordSet.getString("freewfsetcurnameen"));
    }
    else if(user.getLanguage() == 9){
        FreeWorkflowname=Util.null2String(RecordSet.getString("freewfsetcurnametw"));
    }
    else {
        FreeWorkflowname=Util.null2String(RecordSet.getString("freewfsetcurnamecn"));
    }
    isSignMustInputOfThisJsp = ""+Util.getIntValue(RecordSet.getString("issignmustinput"), 0);
}
if(ismode.equals("1") && showdes!=1){
    RecordSet.executeSql("select id from workflow_nodemode where isprint='0' and workflowid="+workflowid+" and nodeid="+nodeid);
    if(RecordSet.next()){
        modeid=RecordSet.getInt("id");
    }else{
        RecordSet.executeSql("select id from workflow_formmode where isprint='0' and formid="+formid+" and isbill="+isbill);
        if(RecordSet.next()){
            modeid=RecordSet.getInt("id");
            isform=1;
        }
    }
}else if("2".equals(ismode)){
	RecordSet.executeSql("select id from workflow_nodehtmllayout where type=0 and workflowid="+workflowid+" and nodeid="+nodeid);
    if(RecordSet.next()){
        modeid=RecordSet.getInt("id");
    }
}
session.setAttribute(userid+"_"+logintype+"username",username);
session.setAttribute(userid+"_"+workflowid+"workflowname",workflowname);
session.setAttribute(userid+"_"+workflowid+"isannexupload",isannexupload);
session.setAttribute(userid+"_"+workflowid+"annexdocCategory",annexdocCategory);     
session.setAttribute(userid+"_"+requestid+"nodeid",""+nodeid);
boolean IsFreeWorkflow=WFForwardManager.getIsFreeWorkflow(Util.getIntValue(requestid),Util.getIntValue(nodeid),0);
boolean isImportDetail=RequestDetailImport.getAllowesImport(Util.getIntValue(requestid),Util.getIntValue(workflowid),Util.getIntValue(nodeid),0,user);


String createpage = "";//TD11055 DS ������Ҫ���ã������Ƶ�����
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<LINK href="/css/rp.css" rel="STYLESHEET" type="text/css">
</head>
<BODY >
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
User user2=new User();
if(isagent == 1){
	user2.setUid(beagenter);
}else{
	user2.setUid(user.getUID());
}
WorkflowManage.setUser(user2);
WorkflowManage.setWorkflowid(workflowid);
boolean isSbmit = WorkflowManage.isSubmit();
if(!isSbmit){
%>
<script type="text/javascript">
function document.onreadystatechange(){
	if (document.readyState=="complete") {
		alert("<%=SystemEnv.getHtmlLabelName(27566,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22938,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(594,user.getLanguage())%>��");
		window.close();
	}
}
</script>
<%} %>
<%//TD9145
Prop prop = Prop.getInstance();
String ifchangstatus = Util.null2String(prop.getPropValue(GCONST.getConfigFile() , "ecology.changestatus"));
String sqlselectName = "select * from workflow_nodecustomrcmenu where wfid="+workflowid+" and nodeid="+nodeid;
RecordSet.executeSql(sqlselectName);
String submitName = "";
String subnobackName = "";//�ύ���跴��
String subbackName = "";//�ύ�跴��
String hasnoback = "";//ʹ���ύ���跴����ť
String hasback = "";//ʹ���ύ�跴����ť
String saveName = "";
String newWFName = "";//�½����̰�ť
String newSMSName = "";//�½����Ű�ť
String haswfrm = "";//�Ƿ�ʹ���½����̰�ť
String hassmsrm = "";//�Ƿ�ʹ���½����Ű�ť
int t_workflowid = 0;//�½����̵�ID
String strBar = "[";//�˵�
if(RecordSet.next()){
	if(user.getLanguage() == 7){
		submitName = Util.null2String(RecordSet.getString("submitName7"));
		saveName = Util.null2String(RecordSet.getString("saveName7"));
		newWFName = Util.null2String(RecordSet.getString("newWFName7"));
		newSMSName = Util.null2String(RecordSet.getString("newSMSName7"));
		subnobackName = Util.null2String(RecordSet.getString("subnobackName7"));
		subbackName = Util.null2String(RecordSet.getString("subbackName7"));
	}else if(user.getLanguage() == 9){
		submitName = Util.null2String(RecordSet.getString("submitName9"));
		saveName = Util.null2String(RecordSet.getString("saveName9"));
		newWFName = Util.null2String(RecordSet.getString("newWFName9"));
		newSMSName = Util.null2String(RecordSet.getString("newSMSName9"));
		subnobackName = Util.null2String(RecordSet.getString("subnobackName9"));
		subbackName = Util.null2String(RecordSet.getString("subbackName9"));
	}
	else{
		submitName = Util.null2String(RecordSet.getString("submitName8"));
		saveName = Util.null2String(RecordSet.getString("saveName8"));
		newWFName = Util.null2String(RecordSet.getString("newWFName8"));
		newSMSName = Util.null2String(RecordSet.getString("newSMSName8"));
		subnobackName = Util.null2String(RecordSet.getString("subnobackName8"));
		subbackName = Util.null2String(RecordSet.getString("subbackName8"));
	}
	haswfrm = Util.null2String(RecordSet.getString("haswfrm"));
	hassmsrm = Util.null2String(RecordSet.getString("hassmsrm"));
	hasnoback = Util.null2String(RecordSet.getString("hasnoback"));
	hasback = Util.null2String(RecordSet.getString("hasback"));
	t_workflowid = Util.getIntValue(RecordSet.getString("workflowid"), 0);
}
if("".equals(submitName)){
	submitName = SystemEnv.getHtmlLabelName(615,user.getLanguage());
}
if("".equals(saveName)){
	saveName = SystemEnv.getHtmlLabelName(86,user.getLanguage());
}
if("".equals(FreeWorkflowname.trim())){
	FreeWorkflowname = SystemEnv.getHtmlLabelName(21781,user.getLanguage());
}    
if("".equals(subbackName)){
	if("1".equals(hasnoback) || "1".equals(hasback)){
		subbackName = SystemEnv.getHtmlLabelName(615,user.getLanguage())+"��"+SystemEnv.getHtmlLabelName(21761,user.getLanguage())+"��";
	}else{
		subbackName = SystemEnv.getHtmlLabelName(615,user.getLanguage());
	}
}
if("".equals(subnobackName)){
	subnobackName = SystemEnv.getHtmlLabelName(615,user.getLanguage())+"��"+SystemEnv.getHtmlLabelName(21762,user.getLanguage())+"��";
}
if("".equals(ifchangstatus)){
	if(!needAffirmance.equals("1")){
		//RCMenu += "{"+submitName+",javascript:doSubmitBack(this),_self}";
		//RCMenuHeight += RCMenuHeightStep;
        strBar += "{text: '"+submitName+"',iconCls:'btn_submit',handler: function(){bodyiframe.doSubmitBack(this);}},";
	}else{
		//RCMenu += "{"+submitName+",javascript:doAffirmanceBack(this),_self}";
		//RCMenuHeight += RCMenuHeightStep;
        strBar += "{text: '"+submitName+"',iconCls:'btn_submit',handler: function(){bodyiframe.doAffirmanceBack(this);}},";
	}
}else{//����������һ����ť
	if(!needAffirmance.equals("1")){
		if(!"1".equals(hasnoback)){
			//RCMenu += "{"+subbackName+",javascript:doSubmitBack(this),_self}";
			//RCMenuHeight += RCMenuHeightStep;
            strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){bodyiframe.doSubmitBack(this);}},"; 
		}else{
			if("1".equals(hasback)){
				//RCMenu += "{"+subbackName+",javascript:doSubmitBack(this),_self}";
				//RCMenuHeight += RCMenuHeightStep;
                strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){bodyiframe.doSubmitBack(this);}},";
			}
			//RCMenu += "{"+subnobackName+",javascript:doSubmitNoBack(this),_self}";
			//RCMenuHeight += RCMenuHeightStep;
            strBar += "{text: '"+subnobackName+"',iconCls:'btn_subnobackName',handler: function(){bodyiframe.doSubmitNoBack(this);}},";
		}
	}else{
		if(!"1".equals(hasnoback)){
			//RCMenu += "{"+subbackName+",javascript:doAffirmanceBack(this),_self}";
			//RCMenuHeight += RCMenuHeightStep;
            strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){bodyiframe.doAffirmanceBack(this);}},"; 
		}else{
			if("1".equals(hasback)){
				//RCMenu += "{"+subbackName+",javascript:doAffirmanceBack(this),_self}";
				//RCMenuHeight += RCMenuHeightStep;
                strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){bodyiframe.doAffirmanceBack(this);}},"; 
			}
			//RCMenu += "{"+subnobackName+",javascript:doAffirmanceNoBack(this),_self}";
			//RCMenuHeight += RCMenuHeightStep;
			strBar += "{text: '"+subnobackName+"',iconCls:'btn_subnobackName',handler: function(){bodyiframe.doAffirmanceNoBack(this);}},";
		}
	}
}
if(IsFreeWorkflow){
    //RCMenu += "{"+FreeWorkflowname+",javascript:doFreeWorkflow(),_self}" ;
    //RCMenuHeight += RCMenuHeightStep ;
    strBar += "{text: '"+FreeWorkflowname+"',iconCls:'btn_edit',handler: function(){bodyiframe.doFreeWorkflow(this);}},";
}
if(isImportDetail){
    strBar += "{text: '"+SystemEnv.getHtmlLabelName(26255,user.getLanguage())+"',iconCls:'btn_edit',handler: function(){bodyiframe.doImportDetail();}},";
}

if("1".equals(importwf)){
    strBar += "{text: '"+SystemEnv.getHtmlLabelName(24270,user.getLanguage())+"',iconCls:'btn_edit',handler: function(){bodyiframe.doImportWorkflow(this);}},";
}
//RCMenu += "{"+saveName+",javascript:doSave_nNew(),_self}" ;
//RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+saveName+"',iconCls:'btn_wfSave',handler: function(){bodyiframe.doSave_nNew();}},";

String  dbwfid= Prop.getPropValue(GCONST.getConfigFile(), "dbwfid");
String  bfwfid= Prop.getPropValue(GCONST.getConfigFile(), "bfwfid");
String dbwfids[]=Util.TokenizerString2(dbwfid,",");
String bfwfids[]=Util.TokenizerString2(bfwfid,",");
for(String temp:dbwfids){
	if((workflowid+"").equals(temp)){
		strBar += "{text: '"+"��ϸ����"+"',iconCls:'btn_wfSave',handler: function(){bodyiframe.doSave_nNew1();}},";
	}
}
for(String temp:bfwfids){
	if((workflowid+"").equals(temp)){
		strBar += "{text: '"+"��ϸ����"+"',iconCls:'btn_wfSave',handler: function(){bodyiframe.doSave_nNew1();}},";
	}
}
/*
if((workflowid+"").equals(dbwfid)||(workflowid+"").equals(bfwfid)){
strBar += "{text: '"+"��ϸ����"+"',iconCls:'btn_wfSave',handler: function(){bodyiframe.doSave_nNew1();}},";
}
*/
if("1".equals(haswfrm)){
	if("".equals(newWFName)){
		newWFName = SystemEnv.getHtmlLabelName(1239,user.getLanguage());
	}
	RequestCheckUser.resetParameter();
	RequestCheckUser.setUserid(userid);
	RequestCheckUser.setWorkflowid(t_workflowid);
	RequestCheckUser.setLogintype(logintype);
	RequestCheckUser.checkUser();
	int  t_hasright=RequestCheckUser.getHasright();
	if(t_hasright == 1){
		//RCMenu += "{"+newWFName+",javascript:onNewRequest("+t_workflowid+",0),_top} " ;
		//RCMenuHeight += RCMenuHeightStep ;
        strBar += "{text: '"+newWFName+"',iconCls:'btn_newWFName',handler: function(){bodyiframe.onNewRequest("+t_workflowid+",0);}},";
	}
}
RTXConfig rtxconfig = new RTXConfig();
String temV = rtxconfig.getPorp(rtxconfig.CUR_SMS_SERVER_IS_VALID);
boolean valid = false;
if (temV != null && temV.equalsIgnoreCase("true")) {
	valid = true;
} else {
	valid = false;
}
if(valid == true && "1".equals(hassmsrm) && HrmUserVarify.checkUserRight("CreateSMS:View", user)){
	if("".equals(newSMSName)){
		newSMSName = SystemEnv.getHtmlLabelName(16444,user.getLanguage());
	}
	//RCMenu += "{"+newSMSName+",javascript:onNewSms("+workflowid+", "+nodeid+"),_top} " ;
	//RCMenuHeight += RCMenuHeightStep ;
	strBar += "{text: '"+newSMSName+"',iconCls:'btn_newSMSName',handler: function(){bodyiframe.onNewSms("+workflowid+", "+nodeid+");}},";
}

if(strBar.lastIndexOf(",")>-1) strBar = strBar.substring(0,strBar.lastIndexOf(","));
strBar+="]";
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%@ include file="/workflow/request/RequestShowHelpDoc.jsp" %>
		<input type=hidden name=_isagent id="_isagent" value="<%=isagent%>">
        <input type=hidden name=_beagenter id="_beagenter" value="<%=beagenter%>">
		<input type=hidden name=isworkflowdoc id="isworkflowdoc" value="<%=isworkflowdoc%>">
		<input type=hidden name=picInnerFrameurl id="picInnerFrameurl" value="WorkflowRequestPictureInner.jsp?fromFlowDoc=<%=fromFlowDoc%>&modeid=<%=modeid%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&formid=<%=formid%>">
		<input type=hidden name=statInnerFrameurl id="statInnerFrameurl" value="WorkflowRequestPicture.jsp?hasExt=true&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&formid=<%=formid%>">

		<%@ include file="/workflow/request/NewRequestFrame.jsp" %>
</body>
</html>
<script language="JavaScript">
function oc_CurrentMenuOnMouseOut(icount) {
	jQuery($GetEle("oc_divMenuDivision" + icount)).css("visibility", "hidden");
}
function oc_CurrentMenuOnClick(icount) {
	jQuery($GetEle("oc_divMenuDivision" + icount)).css("visibility", "");
}
</script>

<script language="JavaScript">
	var bodyiframeurl = location.href.substring(location.href.indexOf("AddRequest.jsp?")+15);
	var piciframe = "WorkflowRequestPictureInner.jsp?fromFlowDoc=<%=fromFlowDoc%>&modeid=<%=modeid%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&formid=<%=formid%>";
	function setbodyiframe(){
		document.getElementById("bodyiframe").src="AddRequestIframe.jsp?"+bodyiframeurl+"&isfromtab=<%=isfromtab%>&fromFlowDoc=<%=fromFlowDoc%>&prjid=<%=prjid%>&docid=<%=docid%>&crmid=<%=crmid%>&hrmid=<%=hrmid%>&reqid=<%=reqid%>&topage="+escape("<%=topage%>");
		initNewRequestFrame();
		eventPush(document.getElementById('bodyiframe'),'load',loadcomplete);
		//document.getElementById("piciframe").src=piciframe;
	}
	//window.attachEvent("onload", setbodyiframe);
	if (window.addEventListener){
	    window.addEventListener("load", setbodyiframe, false);
	}else if (window.attachEvent){
	    window.attachEvent("onload", setbodyiframe);
	}else{
	    window.onload=setbodyiframe;
	}
	
	var wftitle="<%=titlename%>";
	var isfromtab=<%=isfromtab%>;	
	var bar=eval("<%=strBar%>");
	
</script>