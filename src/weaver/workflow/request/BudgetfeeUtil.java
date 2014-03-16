package weaver.workflow.request;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import weaver.conn.RecordSet;
import weaver.general.Util;
import weaver.hrm.company.DepartmentComInfo;


public class BudgetfeeUtil {
	private Log log=LogFactory.getLog(BudgetfeeUtil.class);
	private RecordSet rs=new RecordSet();
	
	
	/**
	 * ���ݲ��ż���ݣ���ѯMap<��ĿMap<�·ݣ�����>>
	 * @param departmentid
	 * @param year
	 * @return
	 */
	public Map getDateGrid(String departmentid,String year){
		Map<String,Map<String,Double>> rowMap=new HashMap<String,Map<String,Double>>();//������
		//����Ԥ���
		String sql="select t2.id,fbd.budgetperiodslist,fbd.budgetaccount from FnaBudgetInfoDetail fbd "+
					"left join FnaBudgetInfo fbi on fbd.budgetinfoid=fbi.id "+
					"left join fnabudgetfeetype t1 on t1.id=fbd.budgettypeid "+
					"left join fnabudgetfeetype t2 on t1.supsubject=t2.id "+
					"where fbi.organizationtype=2 and fbi.budgetorganizationid='"+departmentid+"' "+
					"and fbi.status=1 "+
					"and fbd.budgetperiods in (select id from FnaYearsPeriods where fnayear='"+year+"')";
		rs.execute(sql);
		while(rs.next()){
			String typeid=Util.null2String(rs.getString("id"));
			String budgetperiodslist=Util.null2String(rs.getString("budgetperiodslist"));
			double budgetaccount=rs.getDouble("budgetaccount");
			//��ȡ������
			Map<String,Double> colMap=rowMap.get(typeid);
			if(colMap==null){
				colMap=new HashMap<String,Double>();
			}
			//�����·��ܽ��
			double count=intNull2Zero(colMap.get(budgetperiodslist+"ys"));
			colMap.put(budgetperiodslist+"ys",getDouble(count+budgetaccount));
			//1sj 1ys
			
			//����12��Ԥ���ܽ��
			double total=intNull2Zero(colMap.get("zys"));
			colMap.put("zys", getDouble(total+budgetaccount));
			//������
			rowMap.put(typeid, colMap);
		}
		//����ʵ�ʷ���
		String sql2="select t2.supsubject,fei.organizationid,fei.occurdate,fei.amount from FnaExpenseInfo fei "+
					"left join fnabudgetfeetype t2 on fei.subject=t2.id "+
					"where organizationtype=2 and (status=0 or status=1) "+
					"and SUBSTRING(fei.occurdate,0,5)='"+year+"' and organizationid='"+departmentid+"'";
		rs.execute(sql2);
		while(rs.next()){
			String typeid=Util.null2String(rs.getString("supsubject"));
			String budgetperiodslist=getDate(Util.null2String(rs.getString("occurdate")));
			double budgetaccount=rs.getDouble("amount");
			//��ȡ������
			Map<String,Double> colMap=rowMap.get(typeid);
			if(colMap==null){
				colMap=new HashMap<String,Double>();
			}
			//�����·��ܽ��
			double count=intNull2Zero(colMap.get(budgetperiodslist+"sj"));
			colMap.put(budgetperiodslist+"sj", getDouble(count+budgetaccount));
			//1sj 1ys
			
			//����12��Ԥ���ܽ��
			double total=intNull2Zero(colMap.get("zsj"));
			colMap.put("zsj", getDouble(total+budgetaccount));
			//������
			rowMap.put(typeid, colMap);
			
		}
		
		
		return rowMap;
	}
	/**
	 * ������� ����С�����4λ
	 * @param num1
	 * @param num2
	 * @return
	 */
	public double getDivide(double num1,double num2){
		if(num2==0){
			return 0;
		}else{
			return getDouble(num1/num2);
		}
	}
	/**
	 * 
	 * �������뵽С�����4λ
	 * @param num
	 * @return
	 */
	public double getDouble(double num){
		return Math.round(num*10000.0)/10000.0;
	}
	/**
	 * ��ȡ����е�����Ϣ��
	 * @param date
	 * @return Ϊ1,2,3,4���·ݣ�ȥ0
	 */
	public String getDate(String date){
		String[] temp=date.split("-");
		int mon=Integer.parseInt(temp[1]);
		return mon+"";
	}
	/**
	 * double ������Nullת��Ϊ0
	 * @param abc
	 * @return
	 */
	public double intNull2Zero(Double abc){
		if(abc==null){
			return 0;
		}else{
			return abc;
		}
		
	}
	/**
	 * ��ȡ�ಿ��id�������ַ���ƴ��
	 * @param ids ����ids
	 * @return
	 * @throws Exception 
	 */
	public String getDepartmentAllName(String ids) throws Exception{
		DepartmentComInfo dci=new DepartmentComInfo();
		String nameStr="";
		for(String temp: ids.split(",")){
			
			nameStr+="<a href='/hrm/company/HrmDepartmentDsp.jsp?id="+temp+
					"' target='_new'>"+dci.getDepartmentname(temp)+"</a> ";
		}
		
		return nameStr;
	}
	/**
	 * ���ݲ���id��ȡ2�� ��Ŀ fnabudgetfeetype_cmp ��Ŀ�ֲ�Ȩ�ޱ�
	 * @param id ����id
	 * @return Map<��Ŀid,��Ŀ��>
	 */
	public Map<String,String> getFnafeeTypes(String id){
		Map<String,String> map=new HashMap<String,String>();
		String sql="select ft.id,ft.name from fnabudgetfeetype ft "+
					"left join fnabudgetfeetype_cmp fc on ft.supsubject=fc.budgettypeid "+
					"left join HrmDepartment hd on fc.subcompanyid1=hd.subcompanyid1 "+
					"where ft.feelevel=2 and hd.id='"+id+"' and fc.subcompanyid1 <> 0";
		rs.execute(sql);
		while(rs.next()){
			map.put(Util.null2String(rs.getString("id")), Util.null2String(rs.getString("name")));
		}
		return map;
	}
}
