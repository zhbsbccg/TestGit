<%@ page contentType="text/html; charset=gb2312" language="java" import="java.sql.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String __sql = "select count(*) ct from MailResource a LEFT JOIN MailAccount b ON a.mailAccountId=b.id WHERE resourceid="+user.getUID();
System.out.println(__sql);
rs.executeSql(__sql);
rs.next();
int mailCount = rs.getInt("ct");
if(mailCount < 0){
	mailCount = 0;
}
 %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>太平鸟集团OA系统</title>

<SCRIPT type=text/javascript src="/portal/plugin/homepage/peacebird/jquery/jquery.js"></SCRIPT>
<script type="text/javascript" src="/portal/plugin/homepage/peacebird/jquery/plugin/jquery.cycle.all.js"></script>
<script type="text/javascript" src="/portal/plugin/homepage/peacebird/js/DD_belatedPNG_0.0.8a.js"></script>

<style type="text/css">
@import url("/portal/plugin/homepage/peacebird/css/dhtml-vert.css");
body,td,th {
	font-size: 12px;
}
body {
	background-color: #F7F7F7;
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
	var isout=confirm("您确定要退出系统？");
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
</script>


<script type="text/javascript">

$(document).ready(function() {
	//模拟点击
	$("#zhb").click();
    $(function() {
        
        var iconImg="/portal/plugin/homepage/peacebird/images/mainImages/graypoint.png"
        var iconImg_over="/portal/plugin/homepage/peacebird/images/mainImages/redpoint1.png"
    
        $('#slideshow').cycle({
            fx:      'scrollHorz',
            timeout:  30000,
            prev:    '#crossPrev',
            next:    '#crossNext', 
            pager:   '#nav',
            pagerAnchorBuilder: pagerFactory,
            before:  function(currSlideElement, nextSlideElement, options, forwardFlag) {  
			        	if($.browser.msie){
							if($.browser.version=="6.0") {
								DD_belatedPNG.fix('a,div,img,background,span');
							}
						}
			

                        var curIndex=$(currSlideElement).attr("index");
                        var curSlidnavtitle=$($("#slideDemo .slidnavtitle")[curIndex]);
                        if(curSlidnavtitle!=null){
                            curSlidnavtitle.css("background","url('"+iconImg+"') center center no-repeat");
                           // curSlidnavtitle.css("zindex",9999999);
                        }
    
                        var nextIndex=$(nextSlideElement).attr("index");
    
                        var nextSlidnavtitle=$($("#slideDemo .slidnavtitle")[nextIndex]);
                        if(nextSlidnavtitle!=null){
                            var tesy = "url('"+iconImg_over+"') no-repeat";
                            var tempInt = parseInt(nextIndex)  + 1;
                            nextSlidnavtitle.css("background","url('/portal/plugin/homepage/peacebird/images/mainImages/redpoint" + tempInt + ".png') center center  no-repeat");
                            //nextSlidnavtitle.css("zindex",999);
                        }
                    }                       
        }); 
        function pagerFactory(idx, slide) {
            var s = idx > 20 ? ' style="display:none"' : '';
            //alert((idx==0?iconImg_over:iconImg)
            return ' <span class="m-t-5  slidnavtitle hand"  style="background:url('+(idx==0?iconImg_over:iconImg)+') center center no-repeat;position:relative;height:32px;width:32px;z-index:99999">&nbsp;</span>';
        };
        
        $("#login").bind("mouseover", function() {
            $(this).removeClass("lgsm");
            $(this).addClass("lgsmMouseOver");
        });
        $("#login").bind("mouseout", function() {
            $(this).removeClass("lgsmMouseOver");
            $(this).addClass("lgsm");
        });
        
        $(".crossNav a").hover(function() {
            $(this).css("background-position", "0 -29px");
        }, function() {
            $(this).css("background-position", "0 0px");
        });
        
        //检测微软雅黑字体在客户端是否安装
        //fontDetection("sfclsid", $("input[name='fontName']").val());
        //检测用户当前浏览器及其版本
        ieVersionDetection();
    });
    
    //----------------------------------
    // form表单提交时check
    //----------------------------------
    
});



function ieVersionDetection() {
    if(navigator.userAgent.indexOf("MSIE")>0){ //是否是IE浏览器 
        if(navigator.userAgent.indexOf("MSIE 6.0") > 0){ //6.0
            $("#ieverTips").show();
            return;
        } 
    }
    $("#ieverTips").hide();
}

function fontDetection(objectId, fontName) {
    //加载系统字体
    getSFOfStr(objectId);

    if(!isExistOTF(fontName)) {
        $("#fontTips").show();
    } else {
        $("#fontTips").hide();
    }
}

//---------------------------------------------
// System font detection.  START
//---------------------------------------------
/**
 * detection system font exists.
 * @param fontName font name
 * @return true  :Exist.
 *         false :Does not Exist
 */
function isExistOTF(fontName) {
    if (fontName == undefined 
            || fontName == null 
            || fontName.trim() == '') {
        return false;
    }
    
    if (sysfonts.indexOf(";" + fontName + ";") != -1) {
        return true;
    }
    return false;
};

/**
 * getting to the system font string.
 * @param objectId object's id
 * @return system font string.
 */
function getSFOfStr(objectId) {
    var sysFontsArray = new Array();
    sysFontsArray = getSystemFonts(objectId);
    for(var i=0; i<sysFontsArray.length; i++) {
        sysfonts += sysFontsArray[i];
        sysfonts += ';'
    }
}
//-------------------------------------------
// Save the system font string, 
// used for multiple testing.
//-------------------------------------------
var sysfonts = ';';

/**
 * getting to the system font list
 *
 * @param objectId The id of components of the system font.
 * @return fonts list
 */
function getSystemFonts(objectId) {
    var a = document.all(objectId).fonts.count;
    var fArray = new Array();
    for (var i = 1; i <= document.all(objectId).fonts.count; i++) {
        fArray[i] = document.all(objectId).fonts(i)
    }
    return fArray
}

/**
 * Returns a string, with leading and trailing whitespace
 * omitted.
 * @return  A this string with leading and trailing white
 *          space removed, or this string if it has no leading or
 *          trailing white space.
 */
String.prototype.trim = function(){
    return this.replace(/(^\s*)|(\s*$)/g, "");
}

//---------------------------------------------
// System font detection.  END
//---------------------------------------------
</script>



<STYLE TYPE="text/css">
/*For slide*/
.slideDivContinar { height: 236px; width: 757px; padding:0; margin:0; overflow: hidden }
.slideDiv {height:236px; width: 757px;top:0; left:0;margin:0;padding:0;}
</STYLE>

<!--[if gte IE 5.5]>
<SCRIPT language=JavaScript src="/portal/plugin/homepage/peacebird/js/dhtml.js" 
type=text/JavaScript></SCRIPT>
<![endif]-->
</head>

<body>
<table>
  <tr>
    <td>
      <div id="slideDemo" style="overflow:hidden;width:757px;height:236px;">
          <div id="slideshow" class="slideDivContinar" style="margin-left:0;clear:left;top:0px;">
              <div id="disimg1" class='slideDiv' index='0'  style='cursor: pointer;background:url(/portal/plugin/homepage/peacebird/images/mainImages/lg_bg1.jpg) no-repeat;'></div>
              <div id="disimg2" class='slideDiv' index='1'  style='cursor: pointer;background:url(/portal/plugin/homepage/peacebird/images/mainImages/lg_bg2.jpg) no-repeat;'></div>
              <div id="disimg3" class='slideDiv' index='2'  style='cursor: pointer;background:url(/portal/plugin/homepage/peacebird/images/mainImages/lg_bg3.jpg) no-repeat;'></div>
              <div id="disimg4" class='slideDiv' index='3'  style='cursor: pointer;background:url(/portal/plugin/homepage/peacebird/images/mainImages/lg_bg4.jpg) no-repeat;'></div>
              <div id="disimg5" class='slideDiv' index='4'  style='cursor: pointer;background:url(/portal/plugin/homepage/peacebird/images/mainImages/lg_bg5.jpg) no-repeat;'></div>
          </div>
          <DIV style="position:relative;height:32px;top:-38;width:757px;margin-top:0;overflow:hidden;margin-left:280px;">
              <table border="0" width="757px" align="center" cellpadding="0px" cellspacing="0px">
                  <tr>
                      <td align="center">
                          <DIV style="position:relative" align="center" id="nav"></DIV>
                      </td>
                  </tr>
              </table>
          </DIV>
      </div>
<script type="text/javascript">
function openNewFullWindow(url){
  var redirectUrl = url ;
  var width = screen.width ;
  var height = screen.height ;
  if (height == 768 ) height -= 75 ;
  if (height == 600 ) height -= 60 ;
  var szFeatures = "top=0," ;
  szFeatures +="left=0," ;
  szFeatures +="width="+width+"," ;
  szFeatures +="height="+height+"," ;
  szFeatures +="directories=no," ;
  szFeatures +="status=yes," ;
  szFeatures +="menubar=no," ;
  if (height <= 600 ) szFeatures +="scrollbars=yes," ;
  else szFeatures +="scrollbars=yes," ;
  szFeatures +="resizable=yes" ;
  window.open(redirectUrl,"",szFeatures) ;
}
var _m1_tabid=1;
var _m2_tabid=1;
function openMore(_id){
	if(_id=="m1"){
		if(_m1_tabid==2){/*已办*/
			openNewFullWindow("/workflow/request/RequestHandled.jsp");
		}else if(_m1_tabid==3){/*办结*/
			openNewFullWindow("/workflow/request/RequestComplete.jsp");
		}else{/*待办*/
			openNewFullWindow("/workflow/request/RequestView.jsp");
		}
	}else if(_id=="tz1"){
		openNewFullWindow("/docs/search/DocSearch.jsp?fromHomePage=tz1");
	}else if(_id=="m2"){
		if(_m2_tabid==2){/**/
			openNewFullWindow("/docs/search/DocSearch.jsp?fromHomePage=m2_2");
		}else if(_m2_tabid==3){/**/
			openNewFullWindow("/docs/search/DocSearch.jsp?fromHomePage=m2_3");
		}else{/**/
			openNewFullWindow("/docs/search/DocSearch.jsp?fromHomePage=m2_1");
		}
	}else if(_id=="zlxz"){
		openNewFullWindow("/docs/search/DocSearch.jsp?fromHomePage=zlxz");
	}
}
</script>
      <table width="760" height="100%" border="0" align="left" cellpadding="0" cellspacing="0">
        <tr>
          <td width="380">
          <table width="375" height="216" border="0" cellspacing="0" cellpadding="0">
            <tr style="height:29px; background-image:url(images/ttbg.jpg)">
              <td valign="middle" width="255" height="29" style="color:#222; font-family:微软雅黑">&nbsp;&nbsp;待办事项 TODO</td>
			  <td width="40" align="center" valign="middle"  style="cursor:hand" background="images/toolbarbg22.jpg" id="a1" onMouseOver="setbg('a1','b1','c1')"><a onClick="_m1_tabid=1;" href="/page/element/compatible/WorkflowTabContentData1.jsp?tabId=1&amp;ebaseid=8&amp;eid=41&amp;styleid=1&amp;hpid=1&amp;subCompanyId=1" target="m1" style="color:#333;" >待办</a></td>
              <td width="40" align="center" valign="middle" id="b1" background="images/toolbarbg11.jpg"  style="cursor:hand"  onmouseover="setbg('b1','a1','c1')"><a onClick="_m1_tabid=2;" href="/page/element/compatible/WorkflowTabContentData1.jsp?tabId=2&amp;ebaseid=8&amp;eid=41&amp;styleid=1&amp;hpid=1&amp;subCompanyId=1" target="m1" style="color:#333">已办</a></td>
              <td width="40" align="center" valign="middle"  id="c1"  background="images/toolbarbg11.jpg" style="cursor:hand"  onmouseover="setbg('c1','a1','b1')"><a onClick="_m1_tabid=3;" href="/page/element/compatible/WorkflowTabContentData1.jsp?tabId=3&amp;ebaseid=8&amp;eid=41&amp;styleid=1&amp;hpid=1&amp;subCompanyId=1" target="m1" style="color:#333">办结</a></td>
            </tr>
            <tr>
              <td colspan="4" valign="top" style="height:171px; background-image:url(images/tabBg1.jpg); background-repeat:repeat-x;">
              <iframe src="/page/element/compatible/WorkflowTabContentData1.jsp?tabId=1&amp;ebaseid=8&amp;eid=41&amp;styleid=1&amp;hpid=1&amp;subCompanyId=1" name="m1" width="100%" height="166" scrolling="No" frameborder="0" id="m1" style="background-color:transparent" allowtransparency="true"></iframe>
              <div align="right"><span style="margin-right: 15px;cursor: pointer;" onClick="openMore('m1');">MORE...</span></div>
              </td>
            </tr>
          </table></td>
          <td width="380" align="right" valign="top">
          <table width="380" height="216" border="0" cellspacing="0" cellpadding="0">
            <tr style="height:29px; background-image:url(images/ttbg.jpg); background-repeat:no-repeat">
              <td valign="middle"  height="29" style="color:#222; font-family:微软雅黑">&nbsp;&nbsp;通知公告 NOTICE</td>
            </tr>
            <tr>
              <td  style="height:171px; background-image:url(images/tabBg1.jpg); background-repeat:repeat-x;">
              <iframe id="tz1" src="/page/element/compatible/NewsTabContentData1.jsp?tabId=1&ebaseid=7&eid=67&styleid=1&hpid=1&subCompanyId=1&tabWhere=2|,103|0^,^1^,^None^,^0^topdoc^"  width="100%" height="161" scrolling="No" frameborder="0"  style="background-color:transparent" allowtransparency="true"></iframe>
              <div align="right"><span style="margin-right: 15px;cursor: pointer;" onClick="openMore('tz1');">MORE...</span></div>
              </td>
            </tr>
          </table></td>
        </tr>
        <tr>
          <td width="380" style="height:7px"></td>
          <td width="379" style="height:7px"></td>
        </tr>
        <tr valign="top">
          <td width="380">
          <table  border="0" cellspacing="0" cellpadding="0" width="375" height="240">
            <tr style="height:29px; background-image:url(images/ttbg.jpg)">
              <td valign="middle"  width="255" height="29" style="color:#222; font-family:微软雅黑">&nbsp;&nbsp;个人文档 DOCUMENTS</td>
			  
              <td width="40" align="center" valign="middle" id="bb1" background="images/toolbarbg22.jpg"   style="cursor:hand"  onmouseover="setbg1('bb1','aa1','cc1')"><a onClick="_m2_tabid=1;" href="/page/element/compatible/NewsTabContentData1.jsp?tabId=1&ebaseid=7&eid=66&styleid=1&hpid=1&subCompanyId=1&tabWhere=2|,12,13,86,88,91,93|0^,^1^,^None^,^0^topdoc^" target="m2" style="color:#333"><span id="zhb">制度</span></a></td>
			  <td width="40" align="center" valign="middle"  style="cursor:hand" background="images/toolbarbg11.jpg" id="aa1" onMouseOver="setbg1('aa1','bb1','cc1')"><a onClick="_m2_tabid=2;" href="/page/element/compatible/NewsTabContentData1.jsp?tabId=2&ebaseid=7&eid=66&styleid=1&hpid=1&subCompanyId=1&tabWhere=2|,99,85,87,90,92,94,95,97,98,14,15,84|0^,^1^,^None^,^0^topdoc^" target="m2" style="color:#333;" >文件</a></td>
              <td width="40" align="center" valign="middle"  id="cc1" background="images/toolbarbg11.jpg"   style="cursor:hand"  onmouseover="setbg1('cc1','aa1','bb1')"><a onClick="_m2_tabid=3;" href="/page/element/compatible/NewsTabContentData1.jsp?tabId=3&ebaseid=7&eid=66&styleid=1&hpid=1&subCompanyId=1&tabWhere=2|,6,7,81,82,83|0^,^1^,^None^,^0^topdoc^" target="m2" style="color:#333">知识</a></td>
            </tr>
            <tr>
              <td colspan="4" valign="top" style="height:226px; background-image:url(images/bbg1.jpg)">
              <iframe src="/page/element/compatible/NewsTabContentData1.jsp?tabId=1&amp;ebaseid=7&amp;eid=1256&amp;styleid=1271489882851&amp;hpid=27&amp;subCompanyId=1&amp;tabWhere=2|,12,13,86,88,91,93|0^,^1^,^None^,^0^topdoc^" name="m2" height="202" scrolling="No" frameborder="0" id="m2" style="background-color:transparent" allowtransparency="true" width="100%"></iframe>
              <div align="right"><span style="margin-right: 15px;cursor: pointer;" onClick="openMore('m2');">MORE...</span></div>
              </td>
            </tr>
          </table></td>
          <td width="380" align="left"><table width="380" border="0" cellspacing="0" cellpadding="0" height="240">
            <tr>
              <td><table width="100%" border="0" cellspacing="0" cellpadding="0" height="120">
                <tr style="height:29px; background-image:url(images/ttbg.jpg)">
                  <td valign="middle"  height="29" style="color:#222; font-family:微软雅黑">&nbsp;&nbsp;资料下载 DOWNLOAD</td>
                </tr>
                <tr>
                  <td style="height:226px; background-image:url(images/bbg2.jpg)" valign="top" >
                  <iframe id="zlxz" src="/page/element/compatible/NewsTabContentData1.jsp?tabId=2&ebaseid=7&eid=67&styleid=1&hpid=1&subCompanyId=1&tabWhere=2|,9,96|0^,^1^,^None^,^0^topdoc^"  width="100%" height="202" scrolling="No" frameborder="0"  style="background-color:transparent" allowtransparency="true"></iframe>
                  <div align="right"><span style="margin-right: 15px;cursor: pointer;" onClick="openMore('zlxz');">MORE...</span></div>
                  </td>
                </tr>
              </table></td>
            </tr>
            <!--
            
            <tr>
              <td>
              	<table width="373" height=106 border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="220"><table width="215" border="0" cellspacing="0" cellpadding="0" height="100%">
                    <tr style="height:29px; background-image:url(images/ttbg.jpg)">
                      <td width="245"  height="29" valign="middle" style="color:#222; font-family:微软雅黑">&nbsp;&nbsp;个人计划 PLAN</td>
                    </tr>
                    <tr>
                      <td valign="top" align="center" style="height:92px;  background-image:url(images/bg4.jpg)">
                      	<iframe src="/page/element/compatible/view1.jsp?ebaseid=15&eid=68&styleid=1&hpid=1&subCompanyId=1" 
                      	 width="99%" height="90" scrolling="auto" frameborder="0"  
                      	 style="background-color:transparent" allowtransparency="true"></iframe>
          				<!-- eid=68 -->
                        <!--
                      </td>
                    </tr>
                  </table></td>
                  <td width="153" align="right"><table width="165" border="0" cellspacing="0" cellpadding="0" height="100%">
                    <tr style="height:29px; background-image:url(images/ttbg.jpg)">
                      <td width="247"  height="29" valign="middle" style="color:#222; font-family:微软雅黑">&nbsp;&nbsp;个人邮箱 MAIL</td>
                    </tr>
                    
                    <tr>
                      <td valign="middle" align="center" style="height:92px;  background-image:url(images/bg5.jpg)">
                      <div align="left" style="width: 98%; height: 98%; vertical-align: baseline;">
                      <br />
                      	&nbsp;&nbsp;<img alt="" src="images/mail1.gif"><font style="font-size: 12px;">&nbsp;我的邮件</font>
                      <br />
                      &nbsp;&nbsp;<img alt="" src="images/mail2.png">
                      <font style="font-size: 12px;">未读邮件[<%=mailCount %>]封</font>
                      <br />
                      &nbsp;&nbsp;<img alt="" src="images/mail2.png">
                      <a href="/interface/Entrance.jsp?id=11" target="blank" style="font-size: 12px;">进入我的邮件收取</a>
                      </div>
                      </td>
                    </tr>
                    -->
                    
                  </table></td>
                </tr>
                
                
              </table></td>
            </tr>
            
          </table></td>
        </tr>
    </table>
    
    </td>
  </tr>
</table>
</body>
</html>