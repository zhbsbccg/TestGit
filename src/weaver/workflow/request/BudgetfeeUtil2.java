package weaver.workflow.request;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import weaver.conn.RecordSet;
import weaver.general.Util;

public class BudgetfeeUtil2 extends BudgetfeeUtil{
	private Log log=LogFactory.getLog(BudgetfeeUtil2.class);
	private RecordSet rs=new RecordSet();
	public Map<String,String> getDepartments(String subcompany){
		Map<String,String> map =new HashMap<String,String>();
		//根据分部查询部门
		String sql="select id,departmentname from HrmDepartment where subcompanyid1='"+subcompany+"'";
		rs.execute(sql);
		while(rs.next()){
			String id=Util.null2String(rs.getString("id"));
			String name=Util.null2String(rs.getString("departmentname"));
			map.put(id, name);
		}
		return map;
		
	}
	/**
	 * 根据分部id查找type
	 * @param id 分部id
	 * @return
	 */
	public Map<String,String> getFnafeeTypes2(String id){
		Map<String,String> map=new HashMap<String,String>();
		String sql="select ft.id,ft.name from fnabudgzetfeetype ft "+
					"left join fnabudgetfeetype_cmp fc on ft.supsubject=fc.budgettypeid "+
					"where ft.feelevel=2 and fc.subcompanyid1='"+id+"' and fc.subcompanyid1 <> 0";
		rs.execute(sql);
		while(rs.next()){
			map.put(Util.null2String(rs.getString("id")), Util.null2String(rs.getString("name")));
		}
		return map;
	}
	/**
	 * 根据分部及年份月份，查询Map<科目Map<部门，数据>>
	 * @param departmentid
	 * @param year
	 * @param month
	 * @return
	 */
	public Map getDateGrid2(String subcompanyid,String year,String month){
		Map<String,Map<String,Double>> rowMap=new HashMap<String,Map<String,Double>>();//行数据
		//计算预算额
		String sql="select t2.id,fbd.budgetorganizationid,fbd.budgetaccount from FnaBudgetInfoDetail fbd "+
					"left join FnaBudgetInfo fbi on fbd.budgetinfoid=fbi.id "+
					"left join fnabudgetfeetype t1 on t1.id=fbd.budgettypeid "+
					"left join fnabudgetfeetype t2 on t1.supsubject=t2.id "+ 
					"left join hrmdepartment hd on fbi.budgetorganizationid=hd.id "+
					"where fbi.organizationtype=2 and hd.subcompanyid1='"+subcompanyid+"' "+
					"and fbi.status=1 "+
					"and fbd.budgetperiods in (select id from FnaYearsPeriods where fnayear='"+year+"')";
		rs.execute(sql);
		while(rs.next()){
			String typeid=Util.null2String(rs.getString("id"));
			String budgetperiodslist=Util.null2String(rs.getString("budgetorganizationid"));
			double budgetaccount=rs.getDouble("budgetaccount");
			//获取列数据
			Map<String,Double> colMap=rowMap.get(typeid);
			if(colMap==null){
				colMap=new HashMap<String,Double>();
			}
			//部门总金额
			double count=intNull2Zero(colMap.get(budgetperiodslist+"ys"));
			colMap.put(budgetperiodslist+"ys",getDouble(count+budgetaccount));
			//1sj 1ys
			
			//计算所有预算总金额
			double total=intNull2Zero(colMap.get("zys"));
			colMap.put("zys", getDouble(total+budgetaccount));
			//插入行
			rowMap.put(typeid, colMap);
		}
		//计算实际发生
		String sql2="select t2.supsubject,fei.organizationid,fei.occurdate,fei.amount from FnaExpenseInfo fei "+
					"left join fnabudgetfeetype t2 on fei.subject=t2.id "+ 
					"left join hrmdepartment hd on hd.id=fei.organizationid"+
					"where organizationtype=2 and (status=0 or status=1) "+
					"and SUBSTRING(fei.occurdate,0,5)='"+year+"' and hd.subcompanyid1='"+subcompanyid+"'";
		rs.execute(sql2);
		while(rs.next()){
			String typeid=Util.null2String(rs.getString("supsubject"));
			String budgetperiodslist=Util.null2String(rs.getString("organizationid"));
			double budgetaccount=rs.getDouble("amount");
			//获取列数据
			Map<String,Double> colMap=rowMap.get(typeid);
			if(colMap==null){
				colMap=new HashMap<String,Double>();
			}
			//计算月份总金额
			double count=intNull2Zero(colMap.get(budgetperiodslist+"sj"));
			colMap.put(budgetperiodslist+"sj", getDouble(count+budgetaccount));
			//1sj 1ys
			
			//计算12月预算总金额
			double total=intNull2Zero(colMap.get("zsj"));
			colMap.put("zsj", getDouble(total+budgetaccount));
			//插入行
			rowMap.put(typeid, colMap);
			
		}
		
		
		return rowMap;
	}
}
