<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@page import="weaver.general.*" %>
<%@page import="weaver.docs.docs.*" %>
<%@page import="weaver.hrm.*" %>
<%@page import="java.util.*" %>
<%@page import="java.text.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="resourceCI" class="weaver.hrm.resource.ResourceComInfo" scope="page"/> 
<jsp:useBean id="locationCI" class="weaver.hrm.location.LocationComInfo" scope="page"/> 
<jsp:useBean id="departmentCI" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<%
/*
�½��ƻ����� 302
*/
	
	
	String operation = Util.null2String(request.getParameter("operation"));
	String json=new String();
	User user=HrmUserVarify.getUser(request,response);

	BaseBean bb = new BaseBean();
	//��ϸ��������
	if(operation.equals("bmdcmx")){
		String bm=Util.null2String(request.getParameter("bm"));
		String rq=Util.null2String(request.getParameter("rq"));
		String departmentid=bm;
		String periods="";//��Ч���
		//������
		String nfSql="select id from FnaYearsPeriods where status=1 and startdate<='"+rq+"' and enddate>='"+rq+"'";
		rs.execute(nfSql);
		if(rs.next()){
			periods=Util.null2String(rs.getString("id"));
		}
		if(!periods.equals("")){
			while(true){
				double count=0;
				String sql="select SUM(budgetaccount) from FnaBudgetInfoDetail "+
						"where budgetperiods='"+periods+"' and budgetinfoid in ("+
						"select id from FnaBudgetInfo where status=1 and organizationtype=2  and budgetorganizationid='"+departmentid+"'"+
						")";
				//bb.writeLog("zhb:"+sql);
				rs.execute(sql);
				if(rs.next()){
					count=rs.getDouble(1);
				}
				//�����Ԥ��
				if(count>0){
					break;
				}else{
					String temp=departmentCI.getDepartmentsupdepid(departmentid);
					if(temp.equals("0")){
						break;
					}else{
						departmentid=temp;
					}
				}
			}
		}
		
		//���н������
		String name=departmentCI.getDepartmentname(departmentid);
		JSONObject jo=new JSONObject();
		jo.put("id",departmentid);
		jo.put("name",name);
		json=jo.toString();
	}
	//��ѯϵͳ����Ա��Ȩ�޿��������ϼ�����
	if(operation.equals("bmdc")){
		String ry=Util.null2String(request.getParameter("ry"));
		String rq=Util.null2String(request.getParameter("rq"));
		String departmentid=resourceCI.getDepartmentID(ry);
		String periods="";//��Ч���
		//������
		String nfSql="select id from FnaYearsPeriods where status=1 and startdate<='"+rq+"' and enddate>='"+rq+"'";
		rs.execute(nfSql);
		if(rs.next()){
			periods=Util.null2String(rs.getString("id"));
		}
		
		if(!periods.equals("")){
			while(true){
				double count=0;
				String sql="select SUM(budgetaccount) from FnaBudgetInfoDetail "+
						"where budgetperiods='"+periods+"' and budgetinfoid in ("+
						"select id from FnaBudgetInfo where status=1 and organizationtype=2  and budgetorganizationid='"+departmentid+"'"+
						")";
				//bb.writeLog("zhb:"+sql);
				rs.execute(sql);
				if(rs.next()){
					count=rs.getDouble(1);
				}
				//�����Ԥ��
				if(count>0){
					break;
				}else{
					String temp=departmentCI.getDepartmentsupdepid(departmentid);
					if(temp.equals("0")){
						break;
					}else{
						departmentid=temp;
					}
				}
			}
		}
		
		//���н������
		String name=departmentCI.getDepartmentname(departmentid);
		JSONObject jo=new JSONObject();
		jo.put("id",departmentid);
		jo.put("name",name);
		json=jo.toString();
	}
	out.print(json);
 %>

