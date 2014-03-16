<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,java.net.*,weaver.workflow.workflow.WfFunctionManageUtil" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.workflow.request.RequestAnnexUpload" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="WfForceOver" class="weaver.workflow.workflow.WfForceOver" scope="page"/>
<jsp:useBean id="WfForceDrawBack" class="weaver.workflow.workflow.WfForceDrawBack" scope="page"/>
<jsp:useBean id="WfFunctionManageUtil" class="weaver.workflow.workflow.WfFunctionManageUtil" scope="page"/>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page"/>
<jsp:useBean id="TestWorkflowCheck" class="weaver.workflow.workflow.TestWorkflowCheck" scope="page"/>
<%
    String fromflow = Util.null2String(request.getParameter("fromflow"));
    String flag = Util.null2String(request.getParameter("flag"));
    String remark = Util.null2String(request.getParameter("remark"));
    String batch = Util.null2String(request.getParameter("batch"));
    String requestids[] = request.getParameterValues("requestids");
    int requestid = Util.getIntValue(request.getParameter("requestid"), 0);
    String signdocids = Util.null2String(request.getParameter("signdocids"));
    String signworkflowids = Util.null2String(request.getParameter("signworkflowids"));
    int requestLogId = Util.getIntValue(request.getParameter("workflowRequestLogId"),0);
    String requestfrom = Util.null2String(request.getParameter("requestfrom"));
    String annexdocids = "";
	int requestidvalue = Util.getIntValue(request.getParameter("requestidvalue"));
	if(requestidvalue > 0){
		requestid = requestidvalue;
	}
    /*�����¼��������Ҫ�ش���ȥ�Ĳ�ѯ����ֵ Start*/
    String paraStr = "fromself=1";
    String workflowid_tmp = Util.null2String(request.getParameter("workflowid"));
    String nodetype_tmp = Util.null2String(request.getParameter("nodetype"));
    String fromdate_tmp = Util.null2String(request.getParameter("fromdate"));
    String todate_tmp = Util.null2String(request.getParameter("todate"));
    String creatertype_tmp = Util.null2String(request.getParameter("creatertype"));
    String createrid_tmp = Util.null2String(request.getParameter("createrid"));
    String requestlevel_tmp = Util.null2String(request.getParameter("requestlevel"));
    String requestname_tmp = Util.null2String(request.getParameter("requestname"));
    String requestid_tmp1 = Util.null2String(request.getParameter("requestid"));
    paraStr += "&workflowid="+URLEncoder.encode(workflowid_tmp)+"&nodetype="+URLEncoder.encode(nodetype_tmp);
    paraStr += "&fromdate="+URLEncoder.encode(fromdate_tmp)+"&todate="+URLEncoder.encode(todate_tmp);
    paraStr += "&creatertype="+URLEncoder.encode(creatertype_tmp)+"&createrid="+URLEncoder.encode(createrid_tmp);
    paraStr += "&requestlevel="+URLEncoder.encode(requestlevel_tmp)+"&requestname="+URLEncoder.encode(requestname_tmp);
    paraStr += "&requestid="+URLEncoder.encode(requestid_tmp1);
	/*�����¼��������Ҫ�ش���ȥ�Ĳ�ѯ����ֵ End*/
	
    if (fromflow.equals("1")) {
        FileUpload fu = new FileUpload(request);
        remark = Util.null2String(fu.getParameter("remark"));
        int workflowid = Util.getIntValue(fu.getParameter("workflowid"), -1);
        int nodeid = Util.getIntValue(fu.getParameter("nodeid"), -1);
        int formid = Util.getIntValue(fu.getParameter("formid"),-1);
        requestid = Util.getIntValue(fu.getParameter("requestid"), 0);
        requestLogId = Util.getIntValue(fu.getParameter("workflowRequestLogId"),0);
        //��ȡǩ���������ĵ����������
        signdocids = Util.null2String(fu.getParameter("signdocids"));
        signworkflowids = Util.null2String(fu.getParameter("signworkflowids"));
        String ismode = "";
        RecordSet.executeSql("select ismode from workflow_flownode where workflowid=" + workflowid + " and nodeid=" + nodeid);
        if (RecordSet.next()) {
            ismode = Util.null2String(RecordSet.getString("ismode"));
        }
        if (!ismode.equals("1")) {
            RequestAnnexUpload rau = new RequestAnnexUpload();
            rau.setRequest(fu);
            rau.setUser(user);
            annexdocids = rau.AnnexUpload();
        } else {
            String hasSign = "0";//ģ�����Ƿ�������ǩ��
            RecordSet.executeSql("select * from workflow_modeview where formid=" + formid + " and nodeid=" + nodeid + " and fieldid=-4");
            if (RecordSet.next()) hasSign = "1";
            if ("1".equals(hasSign)) {//ģ����������ǩ��
                annexdocids = Util.null2String(fu.getParameter("qianzi"));
            } else {//ģ����û������ǩ�֣�����ͨ��ʽ�ϴ�ǩ������ĸ���
                RequestAnnexUpload rau = new RequestAnnexUpload();
                rau.setRequest(fu);
                rau.setUser(user);
                annexdocids = rau.AnnexUpload();
            }
        }
    }
    int userid = user.getUID();
    int logintype = Util.getIntValue(user.getLogintype());
    int usertype = (user.getLogintype().equals("1")) ? 0 : 1;
    ArrayList requestidsArr = new ArrayList();
    int workflowid = -1;
    int nodeid = -1;
    int nodeid_rb = -1;
    RecordSet.executeProc("workflow_Requestbase_SByID", requestid + "");
    if (RecordSet.next()) {
        workflowid = Util.getIntValue(RecordSet.getString("workflowid"), 0);
        nodeid = Util.getIntValue(RecordSet.getString("currentnodeid"), 0);
    }
    WfForceOver.setRemark(remark);
    WfForceOver.setAnnexdocids(annexdocids);
    WfForceOver.setSigndocids(signdocids);
    WfForceOver.setSignworkflowids(signworkflowids);
    WfForceOver.setRequestLogId(requestLogId);
/*---------------------------�� �� �� �� �� ҳ �� �� �� �� �� �� ��----------------------*/

//ǿ�ƹ鵵
    if ("ov".equals(flag)) {
//�ύʱ�����������һ��Ȩ���ж�
        //if (!WfForceOver.isOver(requestid) && (WfForceOver.isNodeOperator(requestid, userid) || WFUrgerManager.getMonitorViewRight(requestid, userid))) {
        if (WfFunctionManageUtil.haveOtherOperationRight(requestid)&&!WfForceOver.isOver(requestid) && (WfForceOver.isNodeOperator(requestid, userid) || WFUrgerManager.getMonitorViewRight(requestid, userid))) {
            requestidsArr.add("" + requestid);
            WfForceOver.doForceOver(requestidsArr, request, response);
            int currentNodeId=0;
            rs.executeSql(
				"select nodeid from workflow_flownode where workflowid = "
					+ workflowid + " and nodetype = 3");
			if (rs.next()) {
				currentNodeId = rs.getInt("nodeid");
			}
            if("1".equals((String) session.getAttribute("istest"))) out.print(TestWorkflowCheck.gotoNextNode(session,"ov",user, "0", workflowid,requestid,currentNodeId));
            else out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid=" + requestid + "&fromoperation=1&updatePoppupFlag=1');</script>");
            return;
        } else {
            //response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid=" + requestid + "&fromoperation=1&updatePoppupFlag=1&infoKey=ovfail");
            out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid=" + requestid + "&fromoperation=1&updatePoppupFlag=1&infoKey=ovfail');</script>");
            return;
        }
    }

//ǿ���ջ�
    if ("rb".equals(flag)) {
//�ύʱ�����������һ��Ȩ���ж�
        if (WfFunctionManageUtil.haveOtherOperationRight(requestid)&&WfForceDrawBack.isHavePurview(requestid, userid, logintype, -1, -1)) {
            requestidsArr.add("" + requestid);
            WfForceDrawBack.doForceDrawBack(requestidsArr, request, response, -1, -1);
            //response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid=" + requestid + "&fromoperation=1&updatePoppupFlag=1");
            out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid=" + requestid + "&fromoperation=1&updatePoppupFlag=1');</script>");
            return;
        } else {
        	out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid=" + requestid + "&fromoperation=1&updatePoppupFlag=1&infoKey=rbfail');</script>");
            return;        	
        }
    }
  //������ͣ
    if ("stop".equals(flag)) 
    {
    	WfFunctionManageUtil.setStopOperation(requestid,user);
        if(requestfrom.equals("mo"))
        {
        	response.sendRedirect("/system/systemmonitor/workflow/WorkflowMonitor.jsp?"+paraStr);
    		return;
        }
        else
        {
        	//out.print("<script>alert('"+SystemEnv.getHtmlLabelName(26154,user.getLanguage())+"');setTimeout('top.window.close()',1);</script>");
        	out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid=" + requestid + "&fromoperation=1&updatePoppupFlag=1');</script>");
        	return;
        }
    }
    //���̳���
    if ("cancel".equals(flag)) 
    {
    	WfFunctionManageUtil.setCancelOperation(requestid,user);
        if(requestfrom.equals("mo"))
        {
        	response.sendRedirect("/system/systemmonitor/workflow/WorkflowMonitor.jsp?"+paraStr);
    		return;
        }
        else
        {
        	//out.print("<script>alert('"+SystemEnv.getHtmlLabelName(26155,user.getLanguage())+"');setTimeout('top.window.close()',1);</script>");
        	out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid=" + requestid + "&fromoperation=1&updatePoppupFlag=1');</script>");
        	return;
        }
    }
    //��������
    if ("restart".equals(flag)) 
    {
    	WfFunctionManageUtil.setRestartOperation(requestid,user);
        if(requestfrom.equals("mo"))
        {
        	response.sendRedirect("/system/systemmonitor/workflow/WorkflowMonitor.jsp?"+paraStr);
    		return;
        }
        else
        {
        	out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid=" + requestid + "&fromoperation=1&updatePoppupFlag=1');</script>");
        	return;
        }
    }

/*----------------------------------�� �� ҳ �� �� �� �� �� �� ��-------------------------------*/

//ǿ�ƹ鵵
    if ("ovm".equals(flag)) {
        if ("1".equals(batch)) {//����
//�����ύʱ�����������һ��Ȩ���ж�
            if (requestids != null) {
                for (int i = 0; i < requestids.length; i++) {
                	requestid = Util.getIntValue((String)requestids[i],0);
                    if (WfFunctionManageUtil.haveOtherOperationRight(requestid)&&!WfForceOver.isOver(requestid)) {
                        requestidsArr.add(requestids[i]);
                    }
                }
                WfForceOver.doForceOver(requestidsArr, request, response);
            }
            response.sendRedirect("/system/systemmonitor/workflow/WorkflowMonitor.jsp?"+paraStr);
            return;
        } else {
//�������ύʱ�����������һ��Ȩ���ж�
            if (WfFunctionManageUtil.haveOtherOperationRight(requestid)&&!WfForceOver.isOver(requestid)) {
                requestidsArr.add("" + requestid);
                WfForceOver.doForceOver(requestidsArr, request, response);
                response.sendRedirect("/system/systemmonitor/workflow/WorkflowMonitor.jsp?"+paraStr);
                return;
            } else {
                response.sendRedirect("/system/systemmonitor/workflow/WorkflowMonitor.jsp?infoKey=ovfail&"+paraStr);
                return;
            }
        }
    }
    //ǿ�ƹ鵵������/system/systemmonitor/workflow/WorkflowMonitor.jsp������ǿ�ƹ鵵
    if ("ovmwfm".equals(flag)) {
    	String multiRequestIds = Util.null2String(request.getParameter("multiRequestIds"));
    	requestids = Util.TokenizerString2(multiRequestIds, ",");
		if (requestids != null) {
		    for (int i = 0; i < requestids.length; i++) {
		    	int requestid_tmp = Util.getIntValue(requestids[i]);
		    	if(!WfFunctionManageUtil.haveOtherOperationRight(requestid_tmp))
		    	{
		    		continue;
		    	}
		    	boolean isForceOver=false;
		    	int workflowid_rs = 0;
		        rs.executeSql("select b.isForceOver, b.workflowid from workflow_monitor_bound b where b.monitorhrmid="+userid+" and EXISTS(select 1 from workflow_requestbase r where r.currentnodetype!='3' and r.workflowid=b.workflowid and r.requestid="+requestid_tmp+")");
		        while (rs.next()) {
		        	if(!isForceOver)
		        	{
			            isForceOver = Util.getIntValue(rs.getString("isForceOver"))==1?true:false;
			            workflowid_rs = Util.getIntValue(rs.getString("workflowid"));
		            }
		        }
		        WfFunctionManageUtil wfFunctionManageUtil=new WfFunctionManageUtil();
		        HashMap map = wfFunctionManageUtil.wfFunctionManageAsMonitor(workflowid_rs);
		        String ov = (String)map.get("ov");
		        if (isForceOver && "1".equals(ov) && !WfForceOver.isOver(requestid_tmp)) {
		            requestidsArr.add(requestids[i]);
		        }
		        //���в�������ǿ�ƹ鵵����zhb
		        
		        if(!"".equals(requestids[i])){
		        	String cw_sql="update fnaexpenseinfo set status=1 where requestid='"+requestids[i]+"'";
		        	rs.execute(cw_sql);
		        }
		        
		        
		    }
		    WfForceOver.doForceOver(requestidsArr, request, response);
		}
		response.sendRedirect("/system/systemmonitor/workflow/WorkflowMonitor.jsp?"+paraStr);
		return;
    }

//ǿ���ջ�
    if ("rbm".equals(flag)) {
        int tempuser = -1;
        int tempusertype = 0;

        if ("1".equals(batch)) {//����
//�����ύʱ�����������һ��Ȩ���ж�
            if (requestids != null) {
                for (int i = 0; i < requestids.length; i++) {
                    requestidsArr = new ArrayList();
                    //����־��ȥ�����һ��������
                    RecordSet.executeSql("select max(logid), operator,operatortype from workflow_requestlog where requestid=" + requestids[i] + " and (logtype='2' or logtype='0' or logtype='3') and exists(select 1 from workflow_currentoperator where requestid=workflow_requestlog.requestid and userid=workflow_requestlog.operator and usertype=workflow_requestlog.operatortype and isremark='2' and preisremark='0' and operatedate is not null and operatedate>' ') group by operator,operatortype order by max(logid) desc");
                    if (RecordSet.next()) {
                        tempuser = Util.getIntValue(RecordSet.getString("operator"));
                        tempusertype = Util.getIntValue(RecordSet.getString("operatortype"), 0);
                    }else{
                        RecordSet.executeSql("select userid,usertype from workflow_currentoperator where requestid = " + requestids[i] + " and isremark = '2' and preisremark='0' and operatedate is not null and operatedate>' ' order by operatedate desc ,operatetime desc");
                        if (RecordSet.next()) {
                            tempuser = RecordSet.getInt("userid");
                            tempusertype = RecordSet.getInt("usertype");
                        }
                    }
                    if (WfFunctionManageUtil.haveOtherOperationRight(Integer.parseInt(requestids[i]))&&WfForceDrawBack.isHavePurview(Integer.parseInt(requestids[i]), userid, logintype, tempuser, tempusertype)) {
                        requestidsArr.add(requestids[i]);
                        WfForceDrawBack.doForceDrawBack(requestidsArr, request, response, tempuser, tempusertype);
                    }
                }
            }
            response.sendRedirect("/system/systemmonitor/workflow/WorkflowMonitor.jsp?"+paraStr);
            return;
        } else {
//�������ύʱ�����������һ��Ȩ���ж�
			//����־��ȥ�����һ��������
            RecordSet.executeSql("select max(logid), operator,operatortype from workflow_requestlog where requestid=" + requestid + " and (logtype='2' or logtype='0' or logtype='3') and exists(select 1 from workflow_currentoperator where requestid=workflow_requestlog.requestid and userid=workflow_requestlog.operator and usertype=workflow_requestlog.operatortype and isremark='2' and preisremark='0' and operatedate is not null and operatedate>' ') group by operator,operatortype order by max(logid) desc");
            if (RecordSet.next()) {
                tempuser = Util.getIntValue(RecordSet.getString("operator"));
                tempusertype = Util.getIntValue(RecordSet.getString("operatortype"), 0);
            }else{
                RecordSet.executeSql("select userid,usertype from workflow_currentoperator where requestid = " + requestid + " and isremark = '2' and preisremark='0' and operatedate is not null and operatedate>' ' order by operatedate desc ,operatetime desc");
                if (RecordSet.next()) {
                    tempuser = RecordSet.getInt("userid");
                    tempusertype = RecordSet.getInt("usertype");
                }
            }
            if (WfFunctionManageUtil.haveOtherOperationRight(requestid)&&WfForceDrawBack.isHavePurview(requestid, userid, logintype, tempuser, tempusertype)) {
                requestidsArr.add("" + requestid);
                WfForceDrawBack.doForceDrawBack(requestidsArr, request, response, tempuser, tempusertype);
                response.sendRedirect("/system/systemmonitor/workflow/WorkflowMonitor.jsp?"+paraStr);
                return;
            } else {
                response.sendRedirect("/system/systemmonitor/workflow/WorkflowMonitor.jsp?infoKey=rbfail&"+paraStr);
                return;
            }
        }

    }
    //������ͣ
    if ("mostop".equals(flag)) 
    {
    	String multiRequestIds = Util.null2String(request.getParameter("multiRequestIds"));
    	requestids = Util.TokenizerString2(multiRequestIds, ",");
    	if (requestids != null) {
            for (int i = 0; i < requestids.length; i++) 
            {
            	requestid = Util.getIntValue((String)requestids[i],-1);
            	if(requestid<1)
            	{
            		continue;
            	}
            	WfFunctionManageUtil.setStopOperation(requestid,user);
            }
        }
    	
        response.sendRedirect("/system/systemmonitor/workflow/WorkflowMonitor.jsp?"+paraStr);
        return;
    }
    //���̳���
    if ("mocancel".equals(flag)) 
    {
    	String multiRequestIds = Util.null2String(request.getParameter("multiRequestIds"));
    	requestids = Util.TokenizerString2(multiRequestIds, ",");
    	if (requestids != null) {
            for (int i = 0; i < requestids.length; i++) 
            {
            	requestid = Util.getIntValue((String)requestids[i],-1);
            	if(requestid<1)
            	{
            		continue;
            	}
            	WfFunctionManageUtil.setCancelOperation(requestid,user);
            }
    	}
        response.sendRedirect("/system/systemmonitor/workflow/WorkflowMonitor.jsp?"+paraStr);
        return;
    }
    //��������
    if ("morestart".equals(flag)) 
    {
    	String multiRequestIds = Util.null2String(request.getParameter("multiRequestIds"));
    	requestids = Util.TokenizerString2(multiRequestIds, ",");
    	if (requestids != null) {
            for (int i = 0; i < requestids.length; i++) 
            {
            	requestid = Util.getIntValue((String)requestids[i],-1);
            	if(requestid<1)
            	{
            		continue;
            	}
            	WfFunctionManageUtil.setRestartOperation(requestid,user);
            }
    	}
        response.sendRedirect("/system/systemmonitor/workflow/WorkflowMonitor.jsp?"+paraStr);
        return;
    }
%>