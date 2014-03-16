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
	
//������Դ���ݽ���
    String year=session.getAttribute("yszxfx_year")+"";
	String departmentid=session.getAttribute("yszxfx_depid")+"";
/* 	out.println(year);
	out.println(departmentid); */
	if("null".equals(year)||"null".equals(departmentid)){
		out.println("��������������");
		return;
	}
	if(session.getAttribute("yszxfx_year")==null){
		out.println("��������������");
		return;
	}
	Map map=(Map)session.getAttribute("yszxfx_list");
	
	out.println("���ݵ�����");
	//��ʼ��excel����
	ExcelFile.init() ;
    ExcelFile.setFilename("Ԥ��ִ�з�������") ;
    //�������ݱ���
    for(String temp:departmentid.split(",")){
    	ExcelSheet es = new ExcelSheet();
    	//���������
    	ExcelRow er = es.newExcelRow();
    	er.addStringValue("");
    	for(int i=1;i<=12;i++){
    		er.addStringValue(year+"��"+i+"��",null,2);
		}
    	er = es.newExcelRow();
    	er.addStringValue("������Ŀ");
    	for(int i=1;i<=12;i++){
    		er.addStringValue("ʵ�ʷ���");
    		er.addStringValue("Ԥ���");
		}
    	er.addStringValue("ȫ��Ԥ��");
    	er.addStringValue("12���ۼ�ʵ��");
    	er.addStringValue("12���ۼ�Ԥ��");
    	er.addStringValue("ͬ��ʹ�ñ���%");
    	er.addStringValue("ȫ��ʹ�ñ���%");
    	//����ֵ����
    	//���뵱ǰ���ŵ�����2����Ŀ
       	Map<String,String> mapType=budgetUtil.getFnafeeTypes(temp);
       	Map<String,Map<String,Double>> rowMap=(Map<String,Map<String,Double>>)map.get(temp);
       	for(String type:mapType.keySet()){
       			er = es.newExcelRow();
       			//��ȡ������
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
				
			//�����ݲ������
       	}
    	//�����������������sheet����
    	String sheetName=SubcompanyComInfo.getSubCompanyname(DepartmentComInfo.getSubcompanyid1(temp))+"-"+
    			DepartmentComInfo.getDepartmentname(temp);
    	ExcelFile.addSheet(sheetName, es) ;
    //���ű�������
    }
 	
    
	
%>

<script language="javascript">
	//window.open("/weaver/weaver.file.ExcelOut");
   window.location="/weaver/weaver.file.ExcelOut";
</script>