<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="bb" class="weaver.general.BaseBean" scope="page"/>
<%
	String id=Util.null2String(request.getParameter("id"));
	String seclevel=Util.null2String(request.getParameter("seclevel"));
	String citylevel=Util.null2String(request.getParameter("citylevel"));
	String feetype=Util.null2String(request.getParameter("feetype"));
	String feestandard=Util.null2String(request.getParameter("feestandard"));
	//检查权限
	String _roleId = Util.null2String(bb.getPropValue("roleId4FnaBudget", "roleId")).trim(); 
	String sql2="select count(*) from FnaBudgetFee aa "+
	"where aa.id = '"+feetype+"' and exists "+
		"(select 1 from hrmrolemembers a, fnabudgetfeetype_role b "+
		"where a.roleid = b.roleid and b.roleid in ("+_roleId+") and aa.subcompanyid1 = b.subcompanyid and a.resourceid ='"+user.getUID()+"')";
	rs.execute(sql2);
	if(rs.next()){
		int count=rs.getInt(1);
		bb.writeLog(sql2);
		if(count<1){
			%><script>
				alert("此类型添加您无权限！");
				window.location.href="FnafeeStandardsExcelToDB.jsp";
			
			</script><%
			return;
			
		}
	}
	//为空则为新增
	if(id.equals("")){
		//先进行重复查询
		String rId="";
		String sql1="select id from fnafeestandards where seclevel='"+seclevel+"' and citylevel='"+citylevel+"' "+
					" and feetype='"+feetype+"'";
		rs.execute(sql1);
		if(rs.next()){
			rId=Util.null2String(rs.getString("id"));
		}
		if(rId.equals("")){
			String sql="insert into fnafeestandards(seclevel,citylevel,feetype,feestandard) "+
					"values('"+seclevel+"','"+citylevel+"','"+feetype+"','"+feestandard+"')";
			rs.execute(sql);	
		}else{
			String sql="update fnafeestandards set feestandard='"+feestandard+"' where id='"+rId+"'";
			rs.execute(sql);
		}
				
	}else{
		//不为空就进行修改
		String sql="update fnafeestandards set feestandard='"+feestandard+"',seclevel='"+seclevel+"',citylevel='"+citylevel+"',"+
					"feetype='"+feetype+"' where id='"+id+"'";
		rs.execute(sql);
	}
	response.sendRedirect("FnafeeStandardsExcelToDB.jsp");
%>