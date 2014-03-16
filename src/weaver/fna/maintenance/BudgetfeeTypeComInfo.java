package weaver.fna.maintenance;

import java.util.*;
import weaver.conn.*;
import weaver.general.*;
import weaver.common.util.xtree.TreeNode;



/**
 * Title:        ecology
 * Description:
 * Copyright:    Copyright (c) 2002
 * Company:      weaver
 * @author wanglun
 * @version 2.0
 */

public class BudgetfeeTypeComInfo extends BaseBean {
  public static final String TYPE_1LEVEL="L1";
  public static final String TYPE_2LEVEL="L2";
  public static final String TYPE_3LEVEL="L3";
  public static final String TYPE_ROOT="L0";
  private ArrayList ids = null;
  private ArrayList names = null;
  private ArrayList feeperiods = null;
  private ArrayList feelevels = null;
  private ArrayList supsubjects = null;
  private ArrayList feetypes = null;

  private StaticObj staticobj = null;

  private int current_index = -1;
  private int array_size = 0;
  private HashMap archivemap = new HashMap();

  public BudgetfeeTypeComInfo() throws Exception{
    staticobj = StaticObj.getInstance();
    getBudgetfeeTypeInfo() ;
    array_size = ids.size();
  }

  private void getBudgetfeeTypeInfo() throws Exception{
    if(staticobj.getObject("BudgetfeeTypeInfo") == null)
      setBudgetfeeTypeInfo();
    ids = (ArrayList)(staticobj.getRecordFromObj("BudgetfeeTypeInfo", "ids"));
    names = (ArrayList)(staticobj.getRecordFromObj("BudgetfeeTypeInfo", "names"));
    feeperiods = (ArrayList)(staticobj.getRecordFromObj("BudgetfeeTypeInfo", "feeperiods"));
    feelevels = (ArrayList)(staticobj.getRecordFromObj("BudgetfeeTypeInfo", "feelevels"));
    supsubjects = (ArrayList)(staticobj.getRecordFromObj("BudgetfeeTypeInfo", "supsubjects"));
    feetypes = (ArrayList)(staticobj.getRecordFromObj("BudgetfeeTypeInfo", "feetypes"));
  }

  private void setBudgetfeeTypeInfo() throws Exception{
    if(ids != null)
      ids.clear();
    else
      ids = new ArrayList();
    if(names != null)
      names.clear();
    else
      names = new ArrayList();
    if(feeperiods != null)
      feeperiods.clear();
    else
      feeperiods = new ArrayList();
    if(feelevels != null)
      feelevels.clear();
    else
      feelevels = new ArrayList();
    if(supsubjects != null)
      supsubjects.clear();
    else
      supsubjects = new ArrayList();
    if(feetypes != null)
    	feetypes.clear();
      else
    	  feetypes = new ArrayList();
    RecordSet rs = new RecordSet() ;
    try{
      rs.executeProc("FnaBudgetfeeType_Select","") ;
      while(rs.next()){
        ids.add(Util.null2String(rs.getString("id")));
        names.add(Util.null2String(rs.getString("name")));
        feeperiods.add(Util.null2String(rs.getString("feeperiod")));
        feelevels.add(Util.null2String(rs.getString("feelevel")));
        supsubjects.add(Util.null2String(rs.getString("supsubject")));
        feetypes.add(Util.null2String(rs.getString("feetype")));
      }
    }
    catch(Exception e) {
      writeLog(e) ;
      throw e ;
    }

    staticobj.putRecordToObj("BudgetfeeTypeInfo", "ids", ids);
    staticobj.putRecordToObj("BudgetfeeTypeInfo", "names", names);
    staticobj.putRecordToObj("BudgetfeeTypeInfo", "feeperiods", feeperiods);
    staticobj.putRecordToObj("BudgetfeeTypeInfo", "feelevels", feelevels);
    staticobj.putRecordToObj("BudgetfeeTypeInfo", "supsubjects", supsubjects);
    staticobj.putRecordToObj("BudgetfeeTypeInfo", "feetypes", feetypes);
  }

  public int getCurrencyNum()
  {
  	return 	array_size;
  }

  public boolean next(){

    if((current_index+1) < array_size){
      current_index++;
      return true;
    }
    else{
      current_index = -1;
      return false;
    }
  }

    /**
     * 跳到第一行纪录
     */
  public void setTofirstRow(){
       current_index = -1;
  }

  public String getBudgetfeeTypeid(){
    return (String)(ids.get(current_index));
  }

  public String getBudgetfeeTypename(){
    return ((String)(names.get(current_index))).trim() ;
  }

  public String getBudgetfeeTypename(String key)
  {
    int index=ids.indexOf(key);
    if(index!=-1)
      return ((String)names.get(index)).trim() ;
    else
      return "";
  }
  
  public String getBudgetfeeTypeperiod(){
    return ((String)(feeperiods.get(current_index))).trim() ;
  }
  
  public String getBudgetfeeTypeperiod(String key)
  {
    int index=ids.indexOf(key);
    if(index!=-1)
      return ((String)feeperiods.get(index)).trim() ;
    else
      return "";
  }

  public String getBudgetfeeTypeLevel(){
    return ((String)(feelevels.get(current_index))).trim() ;
  }

  public String getBudgetfeeTypeLevel(String key)
  {
    int index=ids.indexOf(key);
    if(index!=-1)
      return ((String)feelevels.get(index)).trim() ;
    else
      return "";
  }

  public String getBudgetfeeTypeSupSubject(){
    return ((String)(supsubjects.get(current_index))).trim() ;
  }

  public String getBudgetfeeTypeSupSubject(String key)
  {
    int index=ids.indexOf(key);
    if(index!=-1)
      return ((String)supsubjects.get(index)).trim() ;
    else
      return "";
  }
  
  public String getBudgetfeeTypeFeeType(){
	    return ((String)(feetypes.get(current_index))).trim() ;
	  }

	  public String getBudgetfeeTypeFeeType(String key)
	  {
	    int index=ids.indexOf(key);
	    if(index!=-1)
	      return ((String)feetypes.get(index)).trim() ;
	    else
	      return "";
	  }
  

  public void removeBudgetfeeTypeCache(){
    staticobj.removeObject("BudgetfeeTypeInfo");
  }

  /**
   * 获取指定节点下的科目信息树状结构
   * @param subjectTreeList  存放结果集
   * @param type 节点类型,glob:总部；coun:国家；prov:省
   * @param pid  节点id
   * @param expandto 展开级数
   * @return  返回cityTreeList
   * @throws Exception
   */
    public TreeNode getSubjectTreeList(TreeNode subjectTreeList, String type, String pid,int expandto) throws Exception {
        return getSubjectTreeList(subjectTreeList,type,pid,expandto,0);
    }   

    public TreeNode getSubjectTreeList(TreeNode subjectTreeList, String type, String pid,int expandto,int filterlevel) throws Exception {
    	return getSubjectTreeList(subjectTreeList,type,pid,expandto,filterlevel,0);
    }
	  
    public TreeNode getSubjectTreeList(TreeNode subjectTreeList, String type, String pid,int expandto,int filterlevel,int filterfeetype) throws Exception {
    	return getSubjectTreeList(subjectTreeList, type, pid,expandto,filterlevel,filterfeetype,"0");
    }

	public TreeNode getSubjectTreeList(TreeNode subjectTreeList, String type, String pid,int expandto,int filterlevel,int filterfeetype,String displayarchive) throws Exception {
		return getSubjectTreeList(subjectTreeList, type, pid, expandto, filterlevel, filterfeetype, displayarchive, null);
	}
    
	public TreeNode getSubjectTreeList(TreeNode subjectTreeList, String type, String pid,int expandto,int filterlevel,int filterfeetype,String displayarchive, String _FnaCtrlBudgetfeeType_bm_val) throws Exception {
		//String displayarchive = "1";//隐藏封存科目
		RecordSet rs = new RecordSet();
		RecordSet rs_1 = new RecordSet();
		//封存的三科目
		String sql = "select * from fnabudgetfeetype where archive = 1";
		rs.executeSql(sql);
		while(rs.next()){
			String feeid = rs.getString("id");
			archivemap.put(feeid, feeid);
		}
		//没有3级科目的，不显示2级科目
		//select a.id,a.name,a.archive,count(b.id) feecount from fnabudgetfeetype a left join fnabudgetfeetype b on b.supsubject = a.id and (b.archive = 0 or b.archive is null) 
		//where a.feelevel = 2 
		//group by a.id,a.name,a.archive
		if (type.equals(TYPE_ROOT)) {
            BudgetfeeTypeComInfo level1 = new BudgetfeeTypeComInfo();
            level1.setTofirstRow();
            while (level1.next()) {
                String level=level1.getBudgetfeeTypeLevel();
                if(!level.equals("1"))
                continue;
                String id = level1.getBudgetfeeTypeid();
                String name = level1.getBudgetfeeTypename();
                if(displayarchive.equals("1")){
                	if(archivemap.containsKey(id)){
                		continue;
                	}
                }
                //过滤非所属分部的科目被浏览
                if(_FnaCtrlBudgetfeeType_bm_val!=null){
	                String sql_1 = "select count(*) cnt \n" +
	            			" from FnaBudgetfeeType a \n" +
	            			" join fnabudgetfeetype_cmp b on a.id = b.budgettypeid  \n" +
	            			" join HrmDepartment dep on b.subcompanyid1 = dep.subcompanyid1  \n" +
	            			" where a.feelevel = 1 \n" +
	            			" and dep.id = "+Util.getIntValue(_FnaCtrlBudgetfeeType_bm_val, -1)+" " +
	            			" and a.id = "+id;
	                rs_1.executeSql(sql_1);
	                if(rs_1.next() && rs_1.getInt("cnt") > 0){
	                	//
	                }else{
	                	continue;
	                }
                }
                TreeNode level1Node = new TreeNode();
                level1Node.setTitle(name);
                level1Node.setNodeId(TYPE_1LEVEL + "_" + id);
                level1Node.setIcon("/images/treeimages/subject1.gif");
                
                if(filterlevel==1){
                    level1Node.setRadio("Y");
                    level1Node.setValue(id);
                    subjectTreeList.addTreeNode(level1Node);
                    continue;
                }
                
                if (hasChild(id,displayarchive)) {
                    if (expandto == 1)
                    	level1Node.setNodeXmlSrc("/fna/maintenance/SubjectSingleXML.jsp?type=" + TYPE_1LEVEL + "&id=" + id + "&nodeid=" + level1Node.getNodeId() + "&level=" + filterlevel + "&feetype=" + filterfeetype+"&displayarchive="+displayarchive);
                    if (expandto > 1) {//expand to  level 2
                        BudgetfeeTypeComInfo level2 = new BudgetfeeTypeComInfo();
                        level2.setTofirstRow();
                        while (level2.next()) {
                            if (!level2.getBudgetfeeTypeSupSubject().equals(id)) continue;
                            String level2id = level2.getBudgetfeeTypeid();
                            String level2name = level2.getBudgetfeeTypename();
                            if(displayarchive.equals("1")){
                            	if(archivemap.containsKey(level2id)){
                            		continue;
                            	}
                            }
                            TreeNode level2Node = new TreeNode();
                            level2Node.setTitle(level2name);
                            level2Node.setNodeId(TYPE_2LEVEL + "_" + level2id);
                            level2Node.setIcon("/images/treeimages/subject2.gif");
                            
                            if(filterlevel==2){
                                level2Node.setRadio("Y");
                                level2Node.setValue(level2id);
                                level1Node.addTreeNode(level2Node);
                                continue;
                            }
                            
                            if (hasChild( level2id,displayarchive)) {
                                if (expandto == 2)
                                	level2Node.setNodeXmlSrc("/fna/maintenance/SubjectSingleXML.jsp?type=" +TYPE_2LEVEL + "&id=" + level2id + "&nodeid=" + level2Node.getNodeId() + "&level=" + filterlevel + "&feetype=" + filterfeetype+"&displayarchive="+displayarchive);
                                if (expandto > 2) {//expand to level 3
                                    this.setTofirstRow();
                                    while (this.next()) {
                                        if (!this.getBudgetfeeTypeSupSubject().equals(level2id)) continue;
                                        String level3id = this.getBudgetfeeTypeid();
                                        String level3name = this.getBudgetfeeTypename();
                                        if(displayarchive.equals("1")){
                                        	if(archivemap.containsKey(level3id)){
                                        		continue;
                                        	}
                                        }
                                        
                                        String level3feetype = this.getBudgetfeeTypeFeeType();
                                        if(filterfeetype>0&&Util.getIntValue(level3feetype)!=filterfeetype) continue;
                                        
                                        TreeNode level3Node = new TreeNode();
                                        level3Node.setTitle(level3name);
                                        level3Node.setNodeId(TYPE_3LEVEL + "_" + level3id);
                                        level3Node.setIcon("/images/treeimages/subject3.gif");
                                        level3Node.setRadio("Y");
                                        level3Node.setValue(level3id);
                                        level3Node.setOncheck("check(" + level3Node.getNodeId() + ")");
                                        level2Node.addTreeNode(level3Node);
                                    }
                                }
                            }
                            level1Node.addTreeNode(level2Node);

                        }
                    }
                }
                subjectTreeList.addTreeNode(level1Node);

            }

        } else if (type.equals(TYPE_1LEVEL)) {
            BudgetfeeTypeComInfo level2 = new BudgetfeeTypeComInfo();
            level2.setTofirstRow();
            while (level2.next()) {
                if (!level2.getBudgetfeeTypeSupSubject().equals(pid)) continue;
                String level2id = level2.getBudgetfeeTypeid();
                String level2name = level2.getBudgetfeeTypename();
                if(displayarchive.equals("1")){
                	if(archivemap.containsKey(level2id)){
                		continue;
                	}
                }
                TreeNode level2Node = new TreeNode();
                level2Node.setTitle(level2name);
                level2Node.setNodeId(TYPE_2LEVEL + "_" + level2id);
                level2Node.setIcon("/images/treeimages/subject2.gif");
                
                if(filterlevel==2){
                    level2Node.setRadio("Y");
                    level2Node.setValue(level2id);
                    subjectTreeList.addTreeNode(level2Node);
                    continue;
                }
                
                if (hasChild( level2id,displayarchive))
                	level2Node.setNodeXmlSrc("/fna/maintenance/SubjectSingleXML.jsp?type=" + TYPE_2LEVEL + "&id=" + level2id + "&nodeid=" + level2Node.getNodeId() + "&level=" + filterlevel + "&feetype=" + filterfeetype+"&displayarchive="+displayarchive);
                subjectTreeList.addTreeNode(level2Node);
            }
        } else if (type.equals(TYPE_2LEVEL)) {
            this.setTofirstRow();
            while (this.next()) {
                if (!this.getBudgetfeeTypeSupSubject().equals(pid)) continue;
                String level3id = this.getBudgetfeeTypeid();
                String level3name = this.getBudgetfeeTypename();
                if(displayarchive.equals("1")){
                	if(archivemap.containsKey(level3id)){
                		continue;
                	}
                }
                
                String level3feetype = this.getBudgetfeeTypeFeeType();
                if(filterfeetype>0&&Util.getIntValue(level3feetype)!=filterfeetype) continue;
                
                TreeNode level3Node = new TreeNode();
                level3Node.setTitle(level3name);
                level3Node.setNodeId(TYPE_3LEVEL + "_" + level3id);
                level3Node.setIcon("/images/treeimages/subject3.gif");
                level3Node.setRadio("Y");
                level3Node.setValue(level3id);
                level3Node.setOncheck("check(" + level3Node.getNodeId() + ")");
                subjectTreeList.addTreeNode(level3Node);
            }
        }

        return subjectTreeList;
    }


    /**
     * 指定节点下是否有子节点
     * @param type  科目级别
     * @param id   节点id
     * @return  boolean
     * @throws Exception
     */
	private boolean hasChild(String id,String displayarchive) throws Exception {
            BudgetfeeTypeComInfo subjects = new BudgetfeeTypeComInfo();
            subjects.setTofirstRow();
            while (subjects.next()) {
            	if(displayarchive.equals("1")){
	            	if(archivemap.containsKey(subjects.getBudgetfeeTypeid())){
	            		continue;
	            	}	
            	}
                if (subjects.getBudgetfeeTypeSupSubject().equals(id)) {
                    return true;
                }
            }      
        return false;
    }
}