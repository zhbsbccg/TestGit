<%@page import="weaver.cpt.maintenance.CapitalAssortmentComInfo"%>
<%@page import="weaver.cpt.capital.CapitalComInfo"%>
<%@page import="weaver.cpt.maintenance.CapitalGroupComInfo"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.general.GCONST"%>
<%@page import="weaver.file.Prop"%>
<%@page import="java.util.*"%>
<%@page import="org.json.JSONArray"%>
<%@ page language="java" contentType="text/html; charset=GBK" %>

<%
JSONArray jsonArray=new JSONArray();

String workflowid=Util.null2String( request.getParameter("wfid"));
String formid=Util.null2String( request.getParameter("formid"));
String resourceid=Util.null2String( request.getParameter("resourceid"));

RecordSet rs=new RecordSet();
RecordSet rs1=new RecordSet();
CapitalAssortmentComInfo capitalAssortmentComInfo=new CapitalAssortmentComInfo();
CapitalComInfo capitalComInfo=new CapitalComInfo();

String  dbwfid= Prop.getPropValue(GCONST.getConfigFile(), "dbwfid");
String  bfwfid= Prop.getPropValue(GCONST.getConfigFile(), "bfwfid");
String[]  dbwfids=Util.TokenizerString2(dbwfid,",");
String[]  bfwfids=Util.TokenizerString2(bfwfid,",");
for(String temp:dbwfids){
	if((workflowid+"").equals(temp)){
	String sql="select id,tablename from workflow_bill where id="+formid;
	String tablename="";
	rs.executeSql(sql);
	if(rs.next()){
	tablename=rs.getString("tablename");

	}
	sql="select * from cptcapitalstate";
	rs.executeSql(sql);
	HashMap statemap=new HashMap();
	while(rs.next()){
	
		statemap.put(rs.getString("id"),rs.getString("name"));
	}
	
	
		
		/**
		if((workflowid+"").equals(dbwfid)){
			resourceid=rs.getString( Prop.getPropValue(GCONST.getConfigFile(), "dcr"));
		}else{
			resourceid=rs.getString( Prop.getPropValue(GCONST.getConfigFile(), "bfr"));
		}**/
		
	
	
	String  mark= Prop.getPropValue(GCONST.getConfigFile(), "mark");
	String  zichanzu= Prop.getPropValue(GCONST.getConfigFile(), "zichanzu");
	String  cptid= Prop.getPropValue(GCONST.getConfigFile(), "cptid");
	String  zichanguige= Prop.getPropValue(GCONST.getConfigFile(), "zichanguige");
	String  jiage= Prop.getPropValue(GCONST.getConfigFile(), "jiage");
	String  zhuangtai= Prop.getPropValue(GCONST.getConfigFile(), "zhuangtai");
	String  gouzhishijian= Prop.getPropValue(GCONST.getConfigFile(), "gouzhishijian");
	if(!resourceid.equals("")){
		//sql="delete from "+tablename+"_dt1 where mainid="+mainid;
		//rs.executeSql(sql);
		sql="select * from cptcapital where isdata=2 and sptcount=1 and resourceid="+resourceid+" and id not in(select "+cptid+ " from "+tablename+"_dt1 p join  "+tablename+" q on p.mainid=q.id join workflow_requestbase o on o.requestid= q.requestId where o.workflowid="+workflowid+" and o.currentnodetype!=3 )";
		//System.out.println(sql);
		//new weaver.general.BaseBean().writeLog("zhbsql:"+sql);
		rs.executeSql(sql);
		while(rs.next()){
			/**
			sql="insert into "+tablename+"_dt1 "+
			"(mainid,"+mark+","+zichanzu+","+cptid+","+zichanguige+","+jiage+","+zhuangtai+","+gouzhishijian+")	values("+
			mainid+",'"+rs.getString("mark")+"',"+rs.getString("capitalgroupid")+","+rs.getString("id")+",'"+rs.getString("capitalspec")+"','"+rs.getString("startprice")+"','"+statemap.get(rs.getString("stateid"))+"','"+rs.getString("selectdate")+"')";
			rs1.executeSql(sql);
			System.out.println(sql);**/
			
			JSONObject jsonObject=new JSONObject();
			jsonObject.put("mark",Util.null2String( rs.getString("mark")));
			jsonObject.put("capitalgroupid",Util.null2String( rs.getString("capitalgroupid")));
			jsonObject.put("capitalgroupname",capitalAssortmentComInfo.getAssortmentName ( Util.null2String( rs.getString("capitalgroupid"))));
			jsonObject.put("cptid",Util.null2String( rs.getString("id")));
			jsonObject.put("cptname",capitalComInfo.getCapitalname( Util.null2String( rs.getString("id"))));
			jsonObject.put("capitalspec",Util.null2String( rs.getString("capitalspec")));
			jsonObject.put("startprice",Util.null2String( rs.getString("startprice")));
			jsonObject.put("stateid",Util.null2String(""+ statemap.get(rs.getString("stateid"))));
			jsonObject.put("selectdate",Util.null2String( rs.getString("selectdate")));
			
			jsonArray.put(jsonObject);
		
		}
		
	}
	
}
}
for(String temp:bfwfids){
	if((workflowid+"").equals(temp)){
	String sql="select id,tablename from workflow_bill where id="+formid;
	String tablename="";
	rs.executeSql(sql);
	if(rs.next()){
	tablename=rs.getString("tablename");

	}
	sql="select * from cptcapitalstate";
	rs.executeSql(sql);
	HashMap statemap=new HashMap();
	while(rs.next()){
	
		statemap.put(rs.getString("id"),rs.getString("name"));
	}
	
	
		
		/**
		if((workflowid+"").equals(dbwfid)){
			resourceid=rs.getString( Prop.getPropValue(GCONST.getConfigFile(), "dcr"));
		}else{
			resourceid=rs.getString( Prop.getPropValue(GCONST.getConfigFile(), "bfr"));
		}**/
		
	
	
	String  mark= Prop.getPropValue(GCONST.getConfigFile(), "mark");
	String  zichanzu= Prop.getPropValue(GCONST.getConfigFile(), "zichanzu");
	String  cptid= Prop.getPropValue(GCONST.getConfigFile(), "cptid");
	String  zichanguige= Prop.getPropValue(GCONST.getConfigFile(), "zichanguige");
	String  jiage= Prop.getPropValue(GCONST.getConfigFile(), "jiage");
	String  zhuangtai= Prop.getPropValue(GCONST.getConfigFile(), "zhuangtai");
	String  gouzhishijian= Prop.getPropValue(GCONST.getConfigFile(), "gouzhishijian");
	if(!resourceid.equals("")){
		//sql="delete from "+tablename+"_dt1 where mainid="+mainid;
		//rs.executeSql(sql);
		sql="select * from cptcapital where isdata=2 and sptcount=1 and resourceid="+resourceid+" and id not in(select "+cptid+ " from "+tablename+"_dt1 p join  "+tablename+" q on p.mainid=q.id join workflow_requestbase o on o.requestid= q.requestId where o.workflowid="+workflowid+" and o.currentnodetype!=3 )";
		System.out.println(sql);
		rs.executeSql(sql);
		while(rs.next()){
			/**
			sql="insert into "+tablename+"_dt1 "+
			"(mainid,"+mark+","+zichanzu+","+cptid+","+zichanguige+","+jiage+","+zhuangtai+","+gouzhishijian+")	values("+
			mainid+",'"+rs.getString("mark")+"',"+rs.getString("capitalgroupid")+","+rs.getString("id")+",'"+rs.getString("capitalspec")+"','"+rs.getString("startprice")+"','"+statemap.get(rs.getString("stateid"))+"','"+rs.getString("selectdate")+"')";
			rs1.executeSql(sql);
			System.out.println(sql);**/
			
			JSONObject jsonObject=new JSONObject();
			jsonObject.put("mark",Util.null2String( rs.getString("mark")));
			jsonObject.put("capitalgroupid",Util.null2String( rs.getString("capitalgroupid")));
			jsonObject.put("capitalgroupname",capitalAssortmentComInfo.getAssortmentName ( Util.null2String( rs.getString("capitalgroupid"))));
			jsonObject.put("cptid",Util.null2String( rs.getString("id")));
			jsonObject.put("cptname",capitalComInfo.getCapitalname( Util.null2String( rs.getString("id"))));
			jsonObject.put("capitalspec",Util.null2String( rs.getString("capitalspec")));
			jsonObject.put("startprice",Util.null2String( rs.getString("startprice")));
			jsonObject.put("stateid",Util.null2String(""+ statemap.get(rs.getString("stateid"))));
			jsonObject.put("selectdate",Util.null2String( rs.getString("selectdate")));
			
			jsonArray.put(jsonObject);
		
		}
		
	}
	
}
}


//System.out.println("jsonArr:"+jsonArray.toString());
out.println(jsonArray.toString());
%>