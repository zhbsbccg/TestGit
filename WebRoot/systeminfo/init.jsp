<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="ln.LN"%>
<%@ page import="weaver.hrm.settings.RemindSettings" %>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<%@ page import="weaver.workflow.workflow.TestWorkflowCheck" %>
<%@ page import="weaver.systeminfo.template.UserTemplate"%>
<%@ page import="weaver.systeminfo.setting.*" %>

<%
// ���Ӳ����жϻ���
int isIncludeToptitle = 0;
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>

<%
//
User user = HrmUserVarify.getUser (request , response) ;

//����1
TestWorkflowCheck twc=new TestWorkflowCheck();
if(twc.checkURI(session,request.getRequestURI(),request.getQueryString())){
    response.sendRedirect("/login/Logout.jsp");
    return;
}
if(user == null)  return ;
String isIE = (String)session.getAttribute("browser_isie");
if (isIE == null || "".equals(isIE)) {
	isIE = "true";
	session.setAttribute("browser_isie", "true");
}

Log logger= LogFactory.getLog(this.getClass());



//************************************************
//��ʱ��������resin����ʱ��������½С����(TD 2227)
//hubo,050707

//************************************************

String pagepath = request.getServletPath();
if(pagepath.indexOf("HrmResourceOperation.jsp")<0&&pagepath.indexOf("RemindLogin.jsp")<0&&pagepath.indexOf("HrmResourcePassword.jsp")<0){
	String changepwd = (String)request.getSession().getAttribute("changepwd");
	if("n".equals(changepwd)){
		request.getSession().removeAttribute("changepwd");
		response.sendRedirect("/login/Login.jsp");
		return;
	}else if("y".equals(changepwd)){
		request.getSession().removeAttribute("changepwd");
	}
}



//licence��Ϣ
String companyNametools="";
LN Licenseinit_1 = new LN();
Licenseinit_1.CkHrmnum();
companyNametools = Licenseinit_1.getCompanyname();

//�汾��Ϣ
StaticObj staticobj = null;
staticobj = StaticObj.getInstance();
String software = (String)staticobj.getObject("software") ;
if(software == null) software="ALL";
String portal = (String)staticobj.getObject("portal") ;
if(portal == null) portal="n";
boolean isPortalOK = false;
if(portal.equals("y")) isPortalOK = true;
String multilanguage = (String)staticobj.getObject("multilanguage") ;
if(multilanguage == null) multilanguage="n";
boolean isMultilanguageOK = false;
if(multilanguage.equals("y")) isMultilanguageOK = true;

%>

<%
  String fromlogin=(String)session.getAttribute("fromlogin");
  session.removeAttribute("fromlogin");
  if(fromlogin==null) fromlogin="no";

  RemindSettings settings0=(RemindSettings)application.getAttribute("hrmsettings");
  String firmcode0=settings0.getFirmcode();
  String usercode0=settings0.getUsercode();

  int needusb0=user.getNeedusb();
  String usbtype0 = settings0.getUsbType();
  String serial0=user.getSerial();

//����ÿ���û�ֻ����һ������Ĵ���
String frommain = Util.null2String(request.getParameter("frommain")) ;

Map logmessages=(Map)application.getAttribute("logmessages");
String a_logmessage="";
if(logmessages!=null)
	a_logmessage=Util.null2String((String)logmessages.get(""+user.getUID()));

String s_logmessage=Util.null2String((String)session.getAttribute("logmessage"));


//TD2125 by mackjoe ����������ĵ�½��������
if(s_logmessage==null)  s_logmessage="";

String relogin0=Util.null2String(settings0.getRelogin());


String layoutStyle = (String)request.getSession(true).getAttribute("layoutStyle");
if(layoutStyle==null) layoutStyle ="";

String rtxFromLogintmp = (String)session.getAttribute("RtxFromLogin");


if(!relogin0.equals("1")&&!fromlogin.equals("yes")&&!frommain.equals("yes")&&!s_logmessage.equals(a_logmessage) && !"true".equals(rtxFromLogintmp)){
	if(layoutStyle.equals("") || !layoutStyle.equals("1")){	//�����С���ڵ�¼�����ж��Ƿ�Ϊ��ǰ��������

%>


<script language=javascript>;
alert("<%=SystemEnv.getHtmlLabelName(23274,user.getLanguage())%>");
window.top.location="/login/Login.jsp";
</script>
<%return;}}%>

<!-- ֻ��jquery  wui -->
<script type="text/javascript" src="/wui/common/jquery/jquery.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/jQuery.modalDialog.js"></script>

<!-- �Ƴ� -->

<script language=javascript>
var ieVersion = 6;//ie�汾

function check_conn() {
	return confirm('<%=SystemEnv.getHtmlLabelName(21403,user.getLanguage())%>\r\n\r\n<%=SystemEnv.getHtmlLabelName(21791,user.getLanguage())%>');
}

function check_form(thiswins,items)
{
	/* added by cyril on 2008-08-14 for td:8521 */
	var isconn = false;
	try {
		var xmlhttp;
	    if (window.XMLHttpRequest) {
	    	xmlhttp = new XMLHttpRequest();
	    }  
	    else if (window.ActiveXObject) {
	    	xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");  
	    }
	    var URL = "/systeminfo/CheckConn.jsp?userid=<%=user.getUID()%>&time="+new Date();
	    xmlhttp.open("GET",URL, false);
	    xmlhttp.send(null);
	    var result = xmlhttp.status;
	    if(result==200) {
		    isconn = true;
	    	var response_flag = xmlhttp.responseText;
	    	if(response_flag!='0') {
	    		var flag_msg = '';
	    		if(response_flag=='1') {
	    			var diag = new Dialog();
					diag.Width = 300;
					diag.Height = 180;
					diag.ShowCloseButton=false;
					diag.Title = "<%=SystemEnv.getHtmlLabelName(26263,user.getLanguage())%>";
					//diag.InvokeElementId="pageOverlay"
					diag.URL = "/wui/theme/ecology7/page/loginSmall.jsp?username=<%=user.getLoginid()%>";
					diag.show();
			        return false;
	    		}
	    		else if(response_flag=='2') {
	    			flag_msg = '<%=SystemEnv.getHtmlLabelName(21403,user.getLanguage())%>';
	    		}
	    		//�����ʻ����⴦�� by alan for TD10156
	    		if(response_flag=='3') {
	    			flag_msg = '<%=SystemEnv.getHtmlLabelName(23670,user.getLanguage())%>';
	   
	    			return false;
	    		}
	    		flag_msg += '\r\n\r\n<%=SystemEnv.getHtmlLabelName(21791,user.getLanguage())%>';
	        	//alert(xmlhttp.responseText);
	        	return confirm(flag_msg);
	        }
	    }
	    xmlhttp = null;

	  	//�������ı��� oracle�¼��HTML���ܳ���4000���ַ�
	    <%if(new weaver.conn.RecordSet().getDBType().equals("oracle")){%>
	    try {
		    var lenck = true;
		    var tempfieldvlaue = document.getElementById("htmlfieldids").value;
		    while(true) {
			    var tempfield = tempfieldvlaue.substring(0, tempfieldvlaue.indexOf(","));
			    tempfieldvlaue = tempfieldvlaue.substring(tempfieldvlaue.indexOf(",")+1);
			    var fieldid = tempfield.substring(0, tempfield.indexOf(";"));
			    var fieldname = tempfield.substring(tempfield.indexOf(";")+1);
			    if(fieldname=='') break;
			    if(!checkLengthOnly(fieldid,'4000',fieldname,'<%=SystemEnv.getHtmlLabelName(524,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')) {
				    lenck = false;
				    break;
			    }
		    }
		    if(lenck==false) return false;
	    }
	    catch(e) {}
	    <%}%>
	}
	catch(e) {
		return check_conn();
	}
	if(!isconn)
		return check_conn();
    /* end by cyril on 2008-08-14 for td:8521 */
	
	thiswin = thiswins
	items = ","+items + ",";
	
	var tempfieldvlaue1 = "";
	try{
		tempfieldvlaue1 = document.getElementById("htmlfieldids").value;
	}catch (e) {
	}

	for(i=1;i<=thiswin.length;i++){
		tmpname = thiswin.elements[i-1].name;
		tmpvalue = thiswin.elements[i-1].value;
	    if(tmpvalue==null){
	        continue;
	    }

		if(tmpname!="" && items.indexOf(","+tmpname+",")!=-1){
			if(tempfieldvlaue1.indexOf(tmpname+";") == -1){
				while(tmpvalue.indexOf(" ") >= 0){
					tmpvalue = tmpvalue.replace(" ", "");
				}
				while(tmpvalue.indexOf("\r\n") >= 0){
					tmpvalue = tmpvalue.replace("\r\n", "");
				}

				if(tmpvalue == ""){
					if(thiswin.elements[i-1].getAttribute("temptitle")!=null){
						alert("\""+thiswin.elements[i-1].getAttribute("temptitle")+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
						return false;
					}else{
						alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>��");
						return false;
					}
				}
			} else {
				var divttt=document.createElement("div");
				divttt.innerHTML = tmpvalue;
				var tmpvaluettt = jQuery.trim(jQuery(divttt).text());
				if(tmpvaluettt == ""){
					if(thiswin.elements[i-1].getAttribute("temptitle")!=null){
						alert("\""+thiswin.elements[i-1].getAttribute("temptitle")+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
						return false;
					}else{
						alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>��");
						return false;
					}
				}
			}
		}
	}
	return true;
}

function isdel(){
	var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
   if(!confirm(str)){
       return false;
   }
       return true;
 } 

function issubmit(){
	var str = "<%=SystemEnv.getHtmlLabelName(22161,user.getLanguage())%>";
   if(!confirm(str)){
       return false;
   }
       return true;
   } 

/*��������ʹ�ã���Ҫ����Ϊ�������ݷŵ�iframe���棬ͨ��response���ص�ʱ��Ҫ���صĵ��丸����*/
function wfforward(wfurl){
	parent.location.href = wfurl;
}

function myescapecode(str)
{
	return encodeURIComponent(str);
}
</script>

<script language="javascript" type="text/javascript" src="/FCKEditor/swfobject.js"></script>
<!-- IE��ר��vbs����ʱ�� -->
<script language="vbs" src="/js/string2VbArray.vbs"></script>

<!-- js ���ϵ� init.js -->
<script language="javascript" type="text/javascript" src="/js/init.js"></script>

<script language="javascript"  src="/js/wbusb.js"></script>
<!-- ɾ�� -->
<html><head>
<meta http-equiv=Content-Type content="text/html; charset=GBK">
<script language=JavaScript> 
  var companyname = "<%=companyNametools%>";
  var str1 = "<%=SystemEnv.getHtmlLabelName(23714,user.getLanguage())%>";

  if(companyname.length >0 ){
  	window.status = str1+companyname;
  }
</script>
<!-- ɾ�� -->
</head></html>

<!--USB ��֤ -->
<%
  if(!fromlogin.equals("yes")&&needusb0==1&&"1".equals(usbtype0)){
%>
<script language=javascript>
ubsfirmcode0 = <%=firmcode0%>;
usbusercode0 = <%=usercode0%>;
usbserial0 = "<%=serial0%>";
usblanguage = "<%=user.getLanguage()%>";
doCheckusb();
</script>
<%}%>

<!--WUI -->
<%@ include file="/wui/common/page/initWui.jsp" %>

<!--For wui-->
<%

String curTheme = "ecology7";
//��ǰƤ��
String curskin = "";
String cutoverWay = "";
String transitionTime = "";
String transitionWay = "";

HrmUserSettingComInfo instance = new HrmUserSettingComInfo();

String huscifId = String.valueOf(instance.getId(String.valueOf(user.getUID())));

curTheme = getCurrWuiConfig(session, user, "theme");
curskin = getCurrWuiConfig(session, user, "skin");

cutoverWay = instance.getCutoverWay(huscifId);
transitionTime = instance.getTransitionTime(huscifId);
transitionWay = instance.getTransitionWays(huscifId);
%>
<%
String ely6flg = "";
if ("ecology6".equals(curTheme.toLowerCase())) {
	curTheme = "ecology7";
	ely6flg = "ecology6";
}
session.setAttribute("SESSION_TEMP_CURRENT_THEME", curTheme);
%>
<!--For wui-->
<link type='text/css' rel='stylesheet'  href='/wui/theme/<%=curTheme %>/skins/<%=curskin %>/wui.css'/>

<!-- �������ã�win7��vistaϵͳʹ���ź�����,����ϵͳʹ������ Start -->
<link type='text/css' rel='stylesheet'  href='/wui/common/css/w7OVFont.css' id="FONT2SYSTEMF">
<script language="javascript"> 
if (jQuery.client.version< 6) {
	document.getElementById('FONT2SYSTEMF').href = "/wui/common/css/notW7AVFont.css";
}
</script> 
<!-- �������ã�win7��vistaϵͳʹ���ź�����,����ϵͳʹ������ End -->

<!-- ҳ���л�Ч��Start -->
<%
if (transitionTime != null && !transitionTime.equals("") && !transitionTime.equals("0")) {
%>
    <meta http-equiv="<%=cutoverWay %>" content="revealTrans(duration=<%=transitionTime %>,transition=<%=transitionWay %>)">
<%
}
%>
<!-- ҳ���л�Ч��End -->


<script language="javascript">

//------------------------------
// the folder of current skins 
//------------------------------
//��ǰʹ�õ�����
var GLOBAL_CURRENT_THEME = "<%=curTheme %>";
//��ǰ����ʹ�õ�Ƥ��
var GLOBAL_SKINS_FOLDER = "<%=curskin %>";
</script>

<!--For wuiForm-->
<script type="text/javascript" src="/wui/common/jquery/plugin/wuiform/jquery.wuiform.js"></script>
<script language="javascript">
jQuery(document).ready(function(){
	wuiform.init();
});
</script>