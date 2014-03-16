<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<%@page import="weaver.general.*" %>
<%@page import="weaver.docs.docs.*" %>
<%@page import="java.util.*" %>
<%@page import="java.text.*" %>
<%@page import="weaver.hrm.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page"/>  
<%@ page import="weaver.general.Util,
                 weaver.file.ExcelSheet,
                 weaver.file.ExcelRow" %>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo"/>
<jsp:useBean id="budgetUtil" class="weaver.workflow.request.BudgetfeeUtil"/>
<jsp:useBean id="SubcompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" />
<%
	
//进行来源数据接受
    String year=session.getAttribute("yszxfx_year")+"";
	String departmentid=session.getAttribute("yszxfx_depid")+"";
/* 	out.println(year);
	out.println(departmentid); */
	if("null".equals(year)||"null".equals(departmentid)){
		out.println("导出错误请重试");
		return;
	}
	if(session.getAttribute("yszxfx_year")==null){
		out.println("导出错误请重试");
		return;
	}
	Map map=(Map)session.getAttribute("yszxfx_list");
	
	out.println("数据导出中");
	//初始化excel数据
	ExcelFile.init() ;
    ExcelFile.setFilename("预算执行分析报表") ;
    //部门数据遍历
    for(String temp:departmentid.split(",")){
    	ExcelSheet es = new ExcelSheet();
    	//加入标题行
    	ExcelRow er = es.newExcelRow();
    	er.addStringValue("");
    	for(int i=1;i<=12;i++){
    		er.addStringValue(year+"年"+i+"月",null,2);
		}
    	er = es.newExcelRow();
    	er.addStringValue("二级科目");
    	for(int i=1;i<=12;i++){
    		er.addStringValue("实际发生");
    		er.addStringValue("预算额");
		}
    	er.addStringValue("全年预算");
    	er.addStringValue("12月累计实际");
    	er.addStringValue("12月累计预算");
    	er.addStringValue("同比使用比例%");
    	er.addStringValue("全年使用比例%");
    	//进行值插入
    	//载入当前部门的所属2及科目
       	Map<String,String> mapType=budgetUtil.getFnafeeTypes(temp);
       	Map<String,Map<String,Double>> rowMap=(Map<String,Map<String,Double>>)map.get(temp);
       	for(String type:mapType.keySet()){
       			er = es.newExcelRow();
       			//获取列数据
				Map<String,Double> colMap=rowMap.get(type);
				if(colMap==null){
					colMap=new HashMap<String,Double>();
				}
				er.addStringValue(mapType.get(type));
				for(int i=1;i<=12;i++){
					er.addValue(budgetUtil.intNull2Zero(colMap.get(i+"sj"))+"");
					er.addValue(budgetUtil.intNull2Zero(colMap.get(i+"ys"))+"");
				} 
				double zys=budgetUtil.intNull2Zero(colMap.get("zys"));
				double zsj=budgetUtil.intNull2Zero(colMap.get("zsj"));
				er.addValue(zys);
				er.addValue(zsj);
   				er.addValue(zys);
   				er.addValue(budgetUtil.getDivide(zsj, zys)*100.0);
   				er.addValue(budgetUtil.getDivide(zsj, zys)*100.0);
				
			//行数据插入结束
       	}
    	//内容载入结束，进行sheet命名
    	String sheetName=SubcompanyComInfo.getSubCompanyname(DepartmentComInfo.getSubcompanyid1(temp))+"-"+
    			DepartmentComInfo.getDepartmentname(temp);
    	ExcelFile.addSheet(sheetName, es) ;
    //部门遍历结束
    }
 	
    
	
%>

<script language="javascript">
	//window.open("/weaver/weaver.file.ExcelOut");
   window.location="/weaver/weaver.file.ExcelOut";
</script>