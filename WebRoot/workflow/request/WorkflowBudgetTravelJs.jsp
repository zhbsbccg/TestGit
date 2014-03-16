<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.general.BaseBean"%>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<script language="javascript">
var _bm_fieldId = 7134;//部门 主表
var _bxrq_fieldId = 7135;//报销日期 主表
var _bxr_fieldId = 7131;//报销人 主表
var _sxry_fieldId = 7132;//随行人员 主表
var _jbr_fieldId = 7133;//经办人 主表
var _ndcbjlzd_fieldId = 7142;//已超标记录 主表
var _ndyssfcb_fieldId = 7141;//年度预算是否超标 主表
var _ndkyys_fieldId = 7157;//年度可用预算 主表
var _kyys=7224;//年度可用预算（单选）主表 zhb
var _sfxd=7229;//判断经办人与报销人是否相等


var _bmndys_fieldId = 7137;//部门年度预算使用情况 明细表

var _yskm_fieldId = 7145;//预算科目 明细表
var _mxrq_fieldId = 7143;//明细日期 明细表
var _fybm_fieldId = 7146;//费用发生部门 明细表
var _bmydys_fieldId = 7147;//部门月度预算 明细表
var _mdcs_fieldId = 7163;//目的城市 明细表
var _fymx_fieldId = 7152;//费用明细 明细表
var _fybz_fieldId = 7154;//费用标准 明细表

var _je0_fieldId = 7150;//金额 明细表
var _je_fieldId = 7151;//实报金额 明细表
var _mxndcbjl_fieldId = 7158;//年度超标记录 明细表
var _mxndcbjlcs_fieldId = 7159;//年度超标记录次数 明细表
var _mxndcbjlje_fieldId = 7160;//年度超标记录金额 明细表

var _ydys=7225;//月度可用预算（单选）明细表 zhb
var _ndys=7226;//年度可用预算（单选）明细表 zhb


/*

var _bm_fieldId = 5821;//部门 主表
var _bxrq_fieldId = 5822;//报销日期 主表
var _bxr_fieldId = 5818;//报销人 主表
var _sxry_fieldId = 5819;//随行人员 主表
var _jbr_fieldId = 5820;//经办人 主表
var _ndcbjlzd_fieldId = 5836;//已超标记录 主表
var _ndyssfcb_fieldId = 5840;//年度预算是否超标 主表
var _bmndys_fieldId = 5823;//部门年度预算使用情况 主表

var _ndkyys_fieldId = 5839;//年度可用预算 明细表
var _yskm_fieldId = 5827;//预算科目 明细表
var _mxrq_fieldId = 5824;//明细日期 明细表
var _fybm_fieldId = 5825;//费用发生部门 明细表
var _bmydys_fieldId = 5829;//部门月度预算 明细表
var _mdcs_fieldId = 5826;//目的城市 明细表
var _fymx_fieldId = 5828;//费用明细 明细表
var _fybz_fieldId = 5838;//费用标准 明细表
var _je0_fieldId = 5837;//金额 明细表
var _je_fieldId = 5830;//实报金额 明细表
var _mxndcbjl_fieldId = 5841;//年度超标记录 明细表
var _mxndcbjlcs_fieldId = 5842;//年度超标记录次数 明细表
var _mxndcbjlje_fieldId = 5843;//年度超标记录金额 明细表

*/

jQuery(document).ready(function(){
	bmdc();

	//部门年度预算使用情况  
	var deptid = jQuery("#field"+_bm_fieldId).val();
	var applydate = jQuery("#field"+_bxrq_fieldId).val();
	getDeptYearFna(deptid,applydate);
  	//部门
    jQuery("#field"+_bm_fieldId).bind("propertychange",function(){
		var deptidTemp = jQuery("#field"+_bm_fieldId).val();
		var applydateTemp = jQuery("#field"+_bxrq_fieldId).val();
		getDeptYearFna(deptidTemp,applydateTemp);
		getYcbjlCsAjax();
		GetNdyssfcbAjax();
    })
  	//报销日期
    jQuery("#field"+_bxrq_fieldId).bind("propertychange",function(){
		var deptidTemp = jQuery("#field"+_bm_fieldId).val();
		var applydateTemp = jQuery("#field"+_bxrq_fieldId).val();
		getDeptYearFna(deptidTemp,applydateTemp);
		getYcbjlCsAjax();
		GetNdyssfcbAjax();
    });    
    
  	//报销人
	jQuery("#field"+_bxr_fieldId).bind("propertychange",function(){
		//增加部门带出
		bmdc();
		bindfee2();
		
    });
  	//随行人员
	jQuery("#field"+_sxry_fieldId).bind("propertychange",function(){
		bindfee2();
    });
  	//经办人
	jQuery("#field"+_jbr_fieldId).bind("propertychange",function(){
		bindfee2();
    });
  	//注释20140107
    // setFMVal(_fybm_fieldId+"_0",jQuery("#field"+_bm_fieldId).val(),jQuery("#field"+_bm_fieldId+"span").html());
	//明细
     jQuery("#nodesnum0").bind("propertychange",function(){
		/* var rowindex=document.getElementById("indexnum0").value * 1.0 - 1;
		setFMVal(_fybm_fieldId+"_"+rowindex,jQuery("#field"+_bm_fieldId).val(),jQuery("#field"+_bm_fieldId+"span").html());
		jQuery("#field"+_fybm_fieldId+"_"+rowindex).bind("propertychange input",bmdcmx).trigger("propertychange"); */
		bindfee(1);
		
    }); 
	bindfee(2);
    
	getYcbjlCsAjax();
	GetNdyssfcbAjax();
});
//判断经办人与报销人是否相等
function sfdybxr(){
	var bxr=jQuery("#field"+_bxr_fieldId);
	var jbr=jQuery("#field"+_jbr_fieldId);
	if(bxr.val()!=""&&jbr.val()!=""){
		//alert(bxr.val()==jbr.val());
		if(bxr.val()==jbr.val()){
			jQuery("#field"+_sfxd).val("0");	
		}else{
			jQuery("#field"+_sfxd).val("1");
		}
	}
}
//明细带出部门
function bmdcmx(){
	var num=jQuery(this).attr("name").split("_")[1];
	
	var bm=jQuery("#field"+_fybm_fieldId+"_"+num);
	var rq=jQuery("#field"+_mxrq_fieldId+"_"+num);
	if(bm.val()!="" && rq.val()!=""){
		jQuery.ajax({
			url:"GetData361.jsp",
			async:false,
			type:"post",
			data:{"operation":"bmdcmx","bm":bm.val(),"rq":rq.val()},
			success:function(data){
				//alert(data);
				eval("var obj="+data);
				var name="<a href='/hrm/company/HrmDepartmentDsp.jsp?id="+obj.id+"' >"+obj.name+"</a>";
				if(obj.id!=bm.val()){
					setFMVal(_fybm_fieldId+"_"+num,obj.id,name);
				}
				//setFMVal(_bm_fieldId,obj.id,name);
			}
		});
	}
	
}
//自动带出有预算的部门
function bmdc(){
	var ry=jQuery("#field"+_bxr_fieldId);
	var rq=jQuery("#field"+_bxrq_fieldId);
	if(ry.val()!="" && rq.val()!=""){
		jQuery.ajax({
			url:"GetData361.jsp",
			async:false,
			type:"post",
			data:{"operation":"bmdc","ry":ry.val(),"rq":rq.val()},
			success:function(data){
				//alert(data);
				eval("var obj="+data);
				var name="<a href='/hrm/company/HrmDepartmentDsp.jsp?id="+obj.id+"' >"+obj.name+"</a>";
				setFMVal(_bm_fieldId,obj.id,name);
			}
		});
	}
	
}
function bindfee2(){
	var _xm_array = jQuery("input[name^='field"+_mxrq_fieldId+"_']");
	
	var i=0;
	for(var i0=0;i0<_xm_array.length;i0++){
		i = parseInt(jQuery(_xm_array[i0]).attr("name").replace("field"+_mxrq_fieldId+"_",""));
	
    	var indexno = i;
       	var feeid = jQuery("#field"+_fymx_fieldId+"_"+indexno).val();
       	showFeeStandard(indexno, feeid);
	}
}

//获取 主表 年度预算是否超标
function GetNdyssfcbAjax(){
	var deptid = jQuery("#field"+_bm_fieldId).val();
	var applydate = jQuery("#field"+_bxrq_fieldId).val();
	jQuery.ajax({
		url : "/workflow/request/GetNdyssfcbAjax.jsp",
		type : "post",
		async : false,
		processData : false,
		data : "deptid="+deptid+"&applydate="+applydate,
		dataType : "html",
		success: function do4Success(msg){
			var isDisplayNone = false;
			if(jQuery("#field"+_ndyssfcb_fieldId).length>0 && jQuery("#field"+_ndyssfcb_fieldId).css("display")=="none"){
				isDisplayNone = true;
			}
			if(jQuery("#disfield"+_ndyssfcb_fieldId).length>0 && jQuery("#disfield"+_ndyssfcb_fieldId).css("display")=="none"){
				isDisplayNone = true;
			}
			if(msg=="true"){
				jQuery("#disfield"+_ndyssfcb_fieldId).val("0");
				jQuery("#field"+_ndyssfcb_fieldId).val("0");
			}else if(msg=="false"){
				jQuery("#disfield"+_ndyssfcb_fieldId).val("1");
				jQuery("#field"+_ndyssfcb_fieldId).val("1");
			}
			var _selText = "";
			if(isDisplayNone){
				_selText = jQuery("#disfield"+_ndyssfcb_fieldId).find("option:selected").text();
				if(_selText==""){
					_selText = jQuery("#field"+_ndyssfcb_fieldId).find("option:selected").text();
				}
				var _obj1 = jQuery("#field"+_ndyssfcb_fieldId+"span").prev();
				if(_obj1.attr("tagname")=="SPAN"){
					_obj1.hide();
				}
				jQuery("#field"+_ndyssfcb_fieldId+"span").html(_selText);
			}
		}
	});
}

//获取 主表 已超标记录 次数
function getYcbjlCsAjax(){
	var deptid = jQuery("#field"+_bm_fieldId).val();
	var applydate = jQuery("#field"+_bxrq_fieldId).val();
	jQuery.ajax({
		url : "/workflow/request/GetYcbjlCsAjax.jsp",
		type : "post",
		async : false,
		processData : false,
		data : "deptid="+deptid+"&applydate="+applydate,
		dataType : "html",
		success: function do4Success(msg){
			jQuery("#field"+_ndcbjlzd_fieldId+"span").html(msg); 
		}
	});
}

//预算科目绑定  
function bindfee(value){
    var indexnum0 = 0;
    if(document.getElementById("indexnum0")){
			indexnum0 = document.getElementById("indexnum0").value * 1.0 - 1;
    }
    if(indexnum0>=0){
    	if(value==1){//当前添加的行
			//初始化 费用明细
			initSelects(indexnum0);

			var mxrq = "#field"+_mxrq_fieldId+"_"+indexnum0;
			var ykm = "#field"+_yskm_fieldId+"_"+indexnum0;
    		var fybm = "#field"+_fybm_fieldId+"_"+indexnum0;
    		var mdcs = "#field"+_mdcs_fieldId+"_"+indexnum0;
			
    		//日期
			jQuery(mxrq).bind("propertychange",function(){
		    	var subject = jQuery(ykm).val();    
		    	var applydate = jQuery("#field"+_mxrq_fieldId+"_"+indexnum0).val();
		    	var deptid = jQuery("#field"+_fybm_fieldId+"_"+indexnum0).val();
			      if(subject==""){
			      	jQuery("#field"+_bmydys_fieldId+"_"+indexnum0+"span").html("");
			      }else{
					    if(applydate=="" || deptid==""){
					    	if(applydate==""){
					    		alert("请先选择申请日期!");
					    	}
					    	return;
					    }else{
					    	getfnainfo(applydate,deptid,subject,indexnum0,_bmydys_fieldId);
					    	getDeptSubjectYearFna(deptid,applydate,subject,indexnum0);
			        	}
			      }
		    });
    	
    		//科目
		    jQuery(ykm).bind("propertychange",function(){
			    getFeeSelects(indexnum0);
		    	var subject = jQuery(ykm).val();    
		    	var applydate = jQuery("#field"+_mxrq_fieldId+"_"+indexnum0).val();
		    	var deptid = jQuery("#field"+_fybm_fieldId+"_"+indexnum0).val();
			      if(subject==""){
			      	jQuery("#field"+_bmydys_fieldId+"_"+indexnum0+"span").html("");
			      }else{
					    if(applydate=="" || deptid==""){
					    	if(applydate==""){
					    		alert("请先选择申请日期!");
					    	}
					    	return;
					    }else{
					    	getfnainfo(applydate,deptid,subject,indexnum0,_bmydys_fieldId);
					    	getDeptSubjectYearFna(deptid,applydate,subject,indexnum0);
			        	}
			      }
		    });
    		
    		//原部门
		    jQuery(fybm).bind("propertychange",function(){
		    	var subject = jQuery("#field"+_yskm_fieldId+"_"+indexnum0).val(); 
		    	var applydate = jQuery("#field"+_mxrq_fieldId+"_"+indexnum0).val();
		    	var deptid = jQuery("#field"+_fybm_fieldId+"_"+indexnum0).val();
			      if(deptid==""){
			      	jQuery("#field"+_bmydys_fieldId+"_"+indexnum0+"span").html("");
			      }else{
					    if(applydate=="" || subject==""){
					    	if(applydate==""){
					    		alert("请先选择申请日期!");
					    	}
					    	return;
					    }else{
					    	getfnainfo(applydate,deptid,subject,indexnum0,_bmydys_fieldId);
					    	getDeptSubjectYearFna(deptid,applydate,subject,indexnum0);
			        	}
			      }
		    });
		    
		    jQuery(mdcs).bind("propertychange",function(){
	        	var feeid = jQuery("#field"+_fymx_fieldId+"_"+indexnum0).val();
	        	showFeeStandard(indexnum0, feeid);
		    });

 
		    
		}else if(value==2){//初始化
			
			
			for(var i=0;i<=indexnum0;i++){
				var mxrq = "#field"+_mxrq_fieldId+"_"+i;
				var yskm = "#field"+_yskm_fieldId+"_"+i;
				var deptfieldid1 = "#field"+_fybm_fieldId+"_"+i;
			    var mdcs = "#field"+_mdcs_fieldId+"_"+i;
				
				jQuery(mxrq).attr("indexno",i);
				jQuery(mxrq).bind("propertychange",function(){
			    	var indexno = this.indexno;
			    	var subject = jQuery("#field"+_yskm_fieldId+"_"+indexno).val();    
			    	var applydate = jQuery("#field"+_mxrq_fieldId+"_"+indexno).val(); 
			    	var deptid = jQuery("#field"+_fybm_fieldId+"_"+indexno).val();
				      if(subject==""){
				      	jQuery("#field"+_bmydys_fieldId+"_"+indexno+"span").html(""); 
				      }else{
						    if(applydate=="" || deptid==""){
						    	if(applydate==""){
						    		alert("请先选择申请日期!");
						    	}
						    	return;
						    }else{
						    	getfnainfo(applydate,deptid,subject,indexno,_bmydys_fieldId);
						    	getDeptSubjectYearFna(deptid,applydate,subject,indexno);
				        }
				      }
			    });
				
				jQuery(yskm).attr("indexno",i);
			    jQuery(yskm).bind("propertychange",function(){
			    	var indexno = this.indexno;
			    	getFeeSelects(indexno);
			    	var subject = jQuery("#field"+_yskm_fieldId+"_"+indexno).val();    
			    	var applydate = jQuery("#field"+_mxrq_fieldId+"_"+indexno).val(); 
			    	var deptid = jQuery("#field"+_fybm_fieldId+"_"+indexno).val();
				      if(subject==""){
				      	jQuery("#field"+_bmydys_fieldId+"_"+indexno+"span").html(""); 
				      }else{
						    if(applydate=="" || deptid==""){
						    	if(applydate==""){
						    		alert("请先选择申请日期!");
						    	}
						    	return;
						    }else{
						    	getfnainfo(applydate,deptid,subject,indexno,_bmydys_fieldId);
						    	getDeptSubjectYearFna(deptid,applydate,subject,indexno);
				        }
				      }
			    });
			    
				jQuery(deptfieldid1).attr("indexno",i);
			    jQuery(deptfieldid1).bind("propertychange",function(){
			    	var indexno = this.indexno;
			    	var subject = jQuery("#field"+_yskm_fieldId+"_"+indexno).val();    
			    	var applydate = jQuery("#field"+_mxrq_fieldId+"_"+indexno).val();
			    	var deptid = jQuery("#field"+_fybm_fieldId+"_"+indexno).val();
				      if(subject==""){
				      	jQuery("#field"+_bmydys_fieldId+"_"+indexno+"span").html(""); 
				      }else{
						    if(applydate=="" || deptid==""){
						    	if(applydate==""){
						    		alert("请先选择申请日期!");
						    	}
						    	return;
						    }else{
						    	getfnainfo(applydate,deptid,subject,indexno,_bmydys_fieldId);
						    	getDeptSubjectYearFna(deptid,applydate,subject,indexno);
				        }
				      }
			    });
	    
				jQuery(mdcs).attr("indexno",i);
			    jQuery(mdcs).bind("propertychange",function(){
			    	var indexno = this.indexno;
		        	var feeid = jQuery("#field"+_fymx_fieldId+"_"+indexno).val();
		        	showFeeStandard(indexno, feeid);
			    });
			    
			    //原预算使用情况
		    	var subject = jQuery("#field"+_yskm_fieldId+"_"+i).val();    
		    	var applydate = jQuery("#field"+_mxrq_fieldId+"_"+i).val();
		    	var deptid1 = jQuery("#field"+_fybm_fieldId+"_"+i).val();
				getfnainfo(applydate,deptid1,subject,i,_bmydys_fieldId);
		    	getDeptSubjectYearFna(deptid1,applydate,subject,i);
					
 		   		//初始化 费用明细
 				getFeeSelects(i);
			}
		}
    }
}

function initSelects(indexid){
	jQuery("#field"+_fymx_fieldId+"_"+indexid).unbind("propertychange");
	jQuery("#field"+_fybz_fieldId+"_"+indexid+"span").html("");
	
	jQuery("#field"+_fymx_fieldId+"_"+indexid+"span").html("");
	var _obj = jQuery("#field"+_fymx_fieldId+"_"+indexid);
	if(_obj!=null&&_obj.length==1&&_obj.attr("type")=="hidden"){
		var viewtype = jQuery("#field"+_fymx_fieldId+"_"+indexid).attr("viewtype"); 
		jQuery("#field"+_fymx_fieldId+"_"+indexid).replaceWith("<select name='field"+_fymx_fieldId+"_"+indexid+"' disabled='disabled' class='Inputstyle styled' id='field"+_fymx_fieldId+"_"
			+indexid+"' viewtype='"+viewtype+"'></select>");
	}else{
		var viewtype = jQuery("#field"+_fymx_fieldId+"_"+indexid).attr("viewtype"); 
		jQuery("#field"+_fymx_fieldId+"_"+indexid).replaceWith("<select name='field"+_fymx_fieldId+"_"+indexid+"' class='Inputstyle styled' id='field"+_fymx_fieldId+"_"
			+indexid+"' viewtype='"+viewtype+"'></select>"); 
		jQuery("#field"+_fymx_fieldId+"_"+indexid).attr("onblur","checkinput2('field"+_fymx_fieldId+"_"+indexid+"','field"+_fymx_fieldId+"_"+indexid+"span',this.getAttribute('viewtype'));"); 
	}

	jQuery("#field"+_fymx_fieldId+"_"+indexid).attr("indexno", indexid);
    jQuery("#field"+_fymx_fieldId+"_"+indexid).bind("propertychange",function(){
    	var indexno = this.indexno;
    	var feeid = jQuery("#field"+_fymx_fieldId+"_"+indexno).val();
    	showFeeStandard(indexno, feeid);
    });
}

//得到费用明细下拉框
function getFeeSelects(indexid){
		var feesubject = jQuery("#field"+_yskm_fieldId+"_"+indexid).val();
		var feeid = jQuery("#field"+_fymx_fieldId+"_"+indexid).val();
		var ifview = false;
		if(jQuery("#field"+_fymx_fieldId+"_"+indexid).length){
			ifview = false;
			feeid = jQuery("#field"+_fymx_fieldId+"_"+indexid).val();
		}else{
			ifview = true;
			feeid = jQuery("#field"+_fymx_fieldId+"_"+indexid+"span").html().trim();
		}
		if(ifview){
			jQuery.ajax({
				url : "/workflow/request/GetFeeNameById.jsp",
				type : "post",
				async : false,
				processData : false,
				data : "feeid="+feeid,
				dataType : "html",
				success: function do4Success(msg){ 
					jQuery("#field"+_fymx_fieldId+"_"+indexid+"span").html(msg.trim()+"<input id='field"+_fymx_fieldId+"_"+indexid+"' value='"+feeid+"' type='hidden' />");
					showFeeStandard(indexid, feeid);
				}
			});	
		}else{
			initSelects(indexid);
			jQuery.ajax({
				url : "/workflow/request/GetFeeBySubject.jsp",
				type : "post",
				async : false,
				processData : false,
				data : "feesubject="+feesubject+"&feeid="+feeid,
				dataType : "html",
				success: function do4Success(msg){ 
					if(msg.trim()!=""){
						jQuery(msg.trim()).appendTo("#field"+_fymx_fieldId+"_"+indexid);
						feeid = jQuery("#field"+_fymx_fieldId+"_"+indexid).val();
						showFeeStandard(indexid, feeid);
					}
				}
			});	
		}
}
 
//得到部门月度预算使用情况  
function getfnainfo(applydate,deptid,subject,num0,fieldid){
	jQuery.ajax({
		url : "/workflow/request/FnaAjaxData.jsp",
		type : "post",
		async : false,
		processData : false,
		data : "applydate="+applydate+"&deptid="+deptid+"&subject="+subject,
		dataType : "html",
		success: function do4Success(msg){
        var values = msg.trim().split("|");
    		//var msg="可用预算:"+values[0]+"<br><font color=red>已用预算："+values[1]+"</font><br><font color=green>审批中费用："+values[2]+"</font>";
			var kyys = values[0];
			if(kyys!=""&&!isNaN(kyys)){
				kyys = round(parseFloat(kyys), 2);
			}
    		var yyys = values[1];
    		if(yyys!=""&&!isNaN(yyys)){
    			yyys = round(parseFloat(yyys), 2);
    		}
    		var spzfy = values[2];
    		var tmpSpzfy = 0.0;
    		if(spzfy!=""&&!isNaN(spzfy)){
    			spzfy = round(parseFloat(spzfy), 2);
    			tmpSpzfy = spzfy;
    		}
    		var nykyys = 0.0;
    		if(kyys==""||isNaN(kyys)){
    			nykyys = "";
    		}else{
    			nykyys = kyys - tmpSpzfy;
    			if(nykyys < 0){
    				nykyys = 0.0;
    			}
    		}
    		var kyysShow = kyys;
    		if(kyys==""||isNaN(kyys)){
    		}else if(kyys < 0){
	    		kyysShow = 0.0;
    		}
    		var msgZhb="<font color=green>审批中："+spzfy+"</font>";
    		//var msg="可用："+kyys;
    		var msg="可用："+kyys+"<br><font color=green>审批中："+spzfy+"</font>";//+"<br><font color='#000'>年度可用预算:"+nykyys+"</font>";
    		jQuery("#field"+fieldid+"_"+num0+"span").html(msg); 
    		//进行审批中
    		jQuery("#field"+_ydys+"_"+num0+"span").html(msgZhb); 
        	var feeid = jQuery("#field"+_fymx_fieldId+"_"+num0).val();
        	showFeeStandard(num0, feeid);
		}
	});	
}

//得到部门年度预算使用情况 
function getDeptYearFna(deptid,applydate){
	jQuery.ajax({
		url : "/workflow/request/FnaYearAjaxData.jsp",
		type : "post",
		async : false,
		processData : false,
		data : "deptid="+deptid+"&applydate="+applydate,
		dataType : "html",
		success: function do4Success(msg){
			var values = msg.trim().split("|");
    		var kyysShow = values[0];
    		if(values[0]==""||isNaN(values[0])){
    		}else if(round(values[0],2) < 0){
	    		kyysShow = 0.0;
    		}
    		
			msg="可用预算："+kyysShow+"<br><font color=red>已用预算："+values[1]+"</font><br><font color=green>审批中费用："+values[2]+"</font>";
			//msg="可用预算："+kyysShow;
			var msgZhb="<font color=red>已用预算："+values[1]+"</font><br><font color=green>审批中费用："+values[2]+"</font>";
			jQuery("#field"+_bmndys_fieldId+"span").html(msg); 
			jQuery("#field"+_kyys+"span").html(msgZhb); 
		}
	});	
}

//得到部门、科目的年度预算使用情况 
function getDeptSubjectYearFna(deptid,applydate,subject,_index){
	jQuery.ajax({
		url : "/workflow/request/FnaSubjectYearAjaxData.jsp",
		type : "post",
		async : false,
		processData : false,
		data : "deptid="+deptid+"&applydate="+applydate+"&subject="+subject,
		dataType : "html",
		success: function do4Success(msg){
			var values = msg.trim().split("|");
    		var kyysShow = values[0];
    		if(values[0]==""||isNaN(values[0])){
    		}else if(round(values[0],2) < 0){
	    		kyysShow = 0.0;
    		}
    		
			msg="可用："+kyysShow+"<br><font color=red>已用："+values[1]+"</font><br><font color=green>审批中："+values[2]+"</font>";
			//field5839_0span
			//zhb加
			//msg="可用："+kyysShow;
			var msgZhb="<font color=red>已用："+values[1]+"</font><br><font color=green>审批中："+values[2]+"</font>";
			jQuery("#field"+_ndkyys_fieldId+"_"+_index+"span").html(msg); 
			jQuery("#field"+_ndys+"_"+_index+"span").html(msgZhb); 
		}
	});
	getDeptSubjectYearFna2(deptid,applydate,subject,_index);
}

//得到部门、科目的年度预算使用情况 年度超标记录明细信息
function getDeptSubjectYearFna2(deptid,applydate,subject,_index){
	jQuery.ajax({
		url : "/workflow/request/FnaSubjectYearAjaxData2.jsp",
		type : "post",
		async : false,
		processData : false,
		data : "deptid="+deptid+"&applydate="+applydate+"&subject="+subject,
		dataType : "html",
		success: function do4Success(msg){
			var values = msg.trim().split("|");
			jQuery("#field"+_mxndcbjl_fieldId+"_"+_index+"span").html("次数："+values[1]+"<br>金额："+values[2]);//年度超标记录 明细表
			jQuery("#field"+_mxndcbjlcs_fieldId+"_"+_index+"span").html(values[1]);//年度超标记录次数 明细表
			jQuery("#field"+_mxndcbjlje_fieldId+"_"+_index+"span").html(values[2]);//年度超标记录金额 明细表
		}
	});	
}


//得到目的地城市可用费用标准校验结果 
function feeifover(hrmid,cityid,feetypeid,amount){
	var returnval = false;
	jQuery.ajax({
		url : "/workflow/request/FeeIfOverAjax.jsp",
		type : "post",
		async : false,
		processData : false,
		data : "hrmid="+hrmid+"&cityid="+cityid+"&feetypeid="+feetypeid+"&amount="+amount,
		dataType : "html",
		success: function do4Success(msg){
     		var tempval = msg.trim();
     		if(tempval == "true"){
     			returnval = true;
     		}
		}
	});	
	return returnval;
}

//得到目的地城市可用费用标准校验结果 多明细
function feeifoverDtl(hrmid,cityid,feetypeid,amount){
	var returnval = false;
	jQuery.ajax({
		url : "/workflow/request/FeeIfOverAjaxDtl.jsp",
		type : "post",
		async : false,
		processData : false,
		data : "hrmid="+hrmid+"&cityid="+cityid+"&feetypeid="+feetypeid+"&amount="+amount,
		dataType : "html",
		success: function do4Success(msg){
       		var tempval = msg.trim();
       		if(tempval!=""){
       			var _rs = confirm(tempval);
       			if(_rs){
       				returnval = false;
       			}else{
       				returnval = true;
       			}
       		}
		}
	});	
	return returnval;
}

//显示费用标准
function showFeeStandard(indexid, feeid){
	var hrmid = "";
	hrmid += ","+jQuery("#field"+_bxr_fieldId).val();
	hrmid += ","+jQuery("#field"+_sxry_fieldId).val();
	hrmid += ","+jQuery("#field"+_jbr_fieldId).val();

	try{
		var i = indexid;
		var cityid = "0";
		var amount = "0.0";
		var deptid = "0";
		if(jQuery("#field"+_fybm_fieldId+"_"+i).length){
			deptid = jQuery("#field"+_fybm_fieldId+"_"+i).val();
		}
		if(jQuery("#field"+_mdcs_fieldId+"_"+i).length){
		     cityid = jQuery("#field"+_mdcs_fieldId+"_"+i).val();
		}
	    
	    var _applyamountVal = "";
	    var _amountVal = "";
    	var _objApplyAmount = jQuery("input[name='field"+_je0_fieldId+"_"+i+"']");//明细金额
	    if(_objApplyAmount!=null && _objApplyAmount.length>=1){
	    	_applyamountVal = _objApplyAmount.val();
	    }
    	var _objAmount = jQuery("input[name='field"+_je_fieldId+"_"+i+"']");//明细实报金额
	    if(_objAmount!=null && _objAmount.length>=1){
	    	_amountVal = _objAmount.val();
	    }
	    var applyamount = "";//进行校验的金额 dt1_applyamount
	    if(_applyamountVal!=""){
	    	applyamount = _applyamountVal;
	    }
	    if(_amountVal!=""){
	    	applyamount = _amountVal;
	    }
	    
	    amount = applyamount;

		var _data = "hrmid="+hrmid+"&cityid="+cityid+"&feetypeid="+feeid+"&amount="+amount;
		jQuery.ajax({
			url : "/workflow/request/FeeStandardAjax.jsp",
			type : "post",
			async : false,
			processData : false,
			data : _data,
			dataType : "html",
			success: function do4Success(msg){
				jQuery("#field"+_fybz_fieldId+"_"+indexid+"span").html(msg.trim());
			}
		});	
		
	}catch(e){}
	
}

//初始化提交校验使用示例：
jQuery(document).ready(function(){
	
	checkCustomize = function (){
		//检测经办人与报销人是否相等
			sfdybxr();
		//检验金额与实报金额
		var isr=true;
		jQuery(":input[id^=field"+_je0_fieldId+"]").each(function(){
			var num=jQuery(this).attr("name").split("_")[1];
			if(jQuery(this).val()!=""&&jQuery(this).val()<0){
				alert("金额不能小于0，请重新填写！");
				isr=false;
				return false;
			}
			var zhbJe0=jQuery("#field"+_je_fieldId+"_"+num);
			if(zhbJe0.val()!=""&&zhbJe0.val()<0){
				alert("实报金额不能小于0，请重新填写！");
				isr=false;
				return false;
			}
			
		});
		if(!isr){
			return isr;
		}
		//预算控制验证 如果超过预算 a设置有预算控制 不能提交 b没有控制 提示信息以后让提交
		var hrmid = "";
		hrmid += ","+jQuery("#field"+_bxr_fieldId).val();
		hrmid += ","+jQuery("#field"+_sxry_fieldId).val();
		hrmid += ","+jQuery("#field"+_jbr_fieldId).val();
			
		var forArrayField = "field"+_je_fieldId;
		var forArray = jQuery("input[name^='"+forArrayField+"_']");
		var i=0;
		var deptidArrayStr = "";
		var cityidArrayStr = "";
		var feetypeidArrayStr = "";
		var amountArrayStr = "";
		for(var i0=0;i0<forArray.length;i0++){
			i = parseInt(jQuery(forArray[i0]).attr("name").replace(forArrayField+"_",""));
			try{
				var cityid = "0";
				var feetypeid = "0";
				var amount = "0.0";
				var deptid = "0";
				if(jQuery("#field"+_fybm_fieldId+"_"+i).length){
					deptid = jQuery("#field"+_fybm_fieldId+"_"+i).val();
				}
				if(!ifControl(deptid)){
					continue;
				}
				if(jQuery("#field"+_mdcs_fieldId+"_"+i).length){
				     cityid = jQuery("#field"+_mdcs_fieldId+"_"+i).val();
				}
				if(cityid==null || cityid==""){
					cityid = "0";
				}
				if(jQuery("#field"+_fymx_fieldId+"_"+i).length){
				     feetypeid = jQuery("#field"+_fymx_fieldId+"_"+i).val();
				}
			    
			    var _applyamountVal = "";
			    var _amountVal = "";
		    	var _objApplyAmount = jQuery("input[name='field"+_je0_fieldId+"_"+i+"']");//明细金额
			    if(_objApplyAmount!=null && _objApplyAmount.length>=1){
			    	_applyamountVal = _objApplyAmount.val();
			    }
		    	var _objAmount = jQuery("input[name='field"+_je_fieldId+"_"+i+"']");//明细实报金额
			    if(_objAmount!=null && _objAmount.length>=1){
			    	_amountVal = _objAmount.val();
			    }
			    var applyamount = "";//进行校验的金额 dt1_applyamount
			    if(_applyamountVal!=""){
			    	applyamount = _applyamountVal;
			    }
			    if(_amountVal!=""){
			    	applyamount = _amountVal;
			    }
			    
			    amount = applyamount;
				
				if(deptidArrayStr!=""){
					deptidArrayStr+="|";
					cityidArrayStr+="|";
					feetypeidArrayStr+="|";
					amountArrayStr+="|";
				}
				deptidArrayStr+=deptid;
				cityidArrayStr+=cityid;
				feetypeidArrayStr+=feetypeid;
				amountArrayStr+=amount;
			}catch(e){}
		}
		
		var returnval = false;
		
		//开始目的地城市可用费用标准校验
		if(deptidArrayStr!=""){
			if(feeifoverDtl(hrmid, cityidArrayStr, feetypeidArrayStr, amountArrayStr)){
				return false;
			}
		}
		
		//开始可用预算校验
		returnval = false;
		var fnainfo = fnaifoverDtl();

		if(fnainfo=="0"){
			returnval= true;		
		}else if(fnainfo!=null&&fnainfo.indexOf("1dtlErrorInfo：")==0){
			if(fnainfo.length>"1dtlErrorInfo：".length){
				fnainfo = fnainfo.substr("1dtlErrorInfo：".length);
			}else{
				fnainfo = "";
			}
			var _rs = confirm("实际报销金额大于预算金额!"+"\r\n"+fnainfo);
			if(_rs){
				returnval= true;
			}else{
				returnval= false;
			}
		}else if(fnainfo=="2"){
			alert("预算会计年度状态未生效，流程不能提交审批!");
			returnval= false;
		}else{
			alert("异常，请联系管理员!");	
			returnval=false;
		}
		
		if(!returnval){
			return false;
		}else{
			return true;
		}
	}

});


//预算是否超出
function fnaifoverDtl(){
	var returnval = "3";
	var temprequestid = "0";
	if(jQuery("#requestid").length){
		temprequestid = jQuery("#requestid").val();
	}
	var poststr = "";
	var forArrayField = "field"+_je_fieldId;
	var forArray = jQuery("input[name^='"+forArrayField+"_']");
	var i=0;
	var _haveControlDep = false;
	for(var i0=0;i0<forArray.length;i0++){
		try{
			i = parseInt(jQuery(forArray[i0]).attr("name").replace(forArrayField+"_",""));
			if(jQuery("#field"+_yskm_fieldId+"_"+i).length){
			    var orgid = jQuery("#field"+_fybm_fieldId+"_"+i).val();//报销单位
				if(orgid==""){return false;}
				if(!ifControl(orgid)){
					continue;
				}
				_haveControlDep = true;
			    var budgetfeetype = jQuery("#field"+_yskm_fieldId+"_"+i).val();//科目
				if(budgetfeetype==""){return false;}
			    var orgtype = "1";//报销类型
				if(orgtype==""){return false;}
			    var applydate = jQuery("#field"+_mxrq_fieldId+"_"+i).val();//报销日期
				if(applydate==""){return false;}
			    
			    var _applyamountVal = "";
			    var _amountVal = "";
		    	var _objApplyAmount = jQuery("input[name='field"+_je0_fieldId+"_"+i+"']");//明细金额
			    if(_objApplyAmount!=null && _objApplyAmount.length>=1){
			    	_applyamountVal = _objApplyAmount.val();
			    }
		    	var _objAmount = jQuery("input[name='field"+_je_fieldId+"_"+i+"']");//明细实报金额
			    if(_objAmount!=null && _objAmount.length>=1){
			    	_amountVal = _objAmount.val();
			    }
			    var applyamount = "";//进行校验的金额 dt1_applyamount
			    if(_applyamountVal!=""){
			    	applyamount = _applyamountVal;
			    }
			    if(_amountVal!=""){
			    	applyamount = _amountVal;
			    }
			    
			    poststr += "|"+budgetfeetype+","+ orgtype+","+ orgid+","+ applydate+","+applyamount
		    }
		}catch(e){}
	}	
	if(poststr!=""){
		poststr =poststr.substr(1);
	}else{
		if(_haveControlDep){
			return false;
		}else{
			return "0";
		}
	}
	jQuery.ajax({
		url : "/fna/budget/FnaBudgetIfOverAjaxDtl.jsp",
		type : "post",
		async : false,
		processData : false,
		data : "poststr="+poststr+"&requestid="+temprequestid,
		dataType : "html",
		success: function do4Success(msg){
			//0 ok  1 报销金额大于预算金额! 2预算会计年度状态为“关闭”/未生效，流程不能提交审批! 3 error 不能提交
			var tempreturnval = msg.trim();
			if(tempreturnval=="0"){
				returnval = "0";
			}
			//if(tempreturnval=="1"){
			if(tempreturnval!=null&&tempreturnval.indexOf("1dtlErrorInfo：")==0){
				returnval = tempreturnval;
			}
			if(tempreturnval=="2"){
				//alert("预算会计年度状态为关闭，流程不能提交审批!");
				returnval = "2";
			}				
		}
	});	
	return returnval;
}

// 该部门是否进行预算控制
function ifControl(deptid){
	var returnval = false;
	jQuery.ajax({
		url : "/workflow/request/DeptIfControlAjax.jsp",
		type : "post",
		async : false,
		processData : false,
		data : "deptid="+deptid,
		dataType : "html",
		success: function do4Success(msg){
       		var tempval = msg.trim();
       		if(tempval == "true"){
       			returnval = true;
       		}
		}
	});	
	return returnval;
}
function round(v,e){
	var t=1; 
	for(;e>0;t*=10,e--); 
	for(;e<0;t/=10,e++); 
	return Math.round(v*t)/t; 
}
function formatNumber(num,pattern){   
  var strarr = num?num.toString().split('.'):['0'];   
  var fmtarr = pattern?pattern.split('.'):[''];   
  var retstr='';   
  
  // 整数部分   
  var str = strarr[0];   
  var fmt = fmtarr[0];   
  var i = str.length-1;     
  var comma = false;   
  for(var f=fmt.length-1;f>=0;f--){   
    switch(fmt.substr(f,1)){   
      case '#':   
        if(i>=0 ) retstr = str.substr(i--,1) + retstr;   
        break;   
      case '0':   
        if(i>=0) retstr = str.substr(i--,1) + retstr;   
        else retstr = '0' + retstr;   
        break;   
      case ',':   
        comma = true;   
        retstr=','+retstr;   
        break;   
    }   
  }   
  if(i>=0){   
    if(comma){   
      var l = str.length;   
      for(;i>=0;i--){   
        retstr = str.substr(i,1) + retstr;   
        if(i>0 && ((l-i)%3)==0) retstr = ',' + retstr;    
      }   
    }   
    else retstr = str.substr(0,i+1) + retstr;   
  }   
  
  retstr = retstr+'.';   
  // 处理小数部分   
  str=strarr.length>1?strarr[1]:'';   
  fmt=fmtarr.length>1?fmtarr[1]:'';   
  i=0;   
  for(var f=0;f<fmt.length;f++){   
    switch(fmt.substr(f,1)){   
      case '#':   
        if(i<str.length) retstr+=str.substr(i++,1);   
        break;   
      case '0':   
        if(i<str.length) retstr+= str.substr(i++,1);   
        else retstr+='0';   
        break;   
    }   
  }   
  return retstr.replace(/^,+/,'').replace(/\.$/,'');   
}

   //字段赋值
function setFMVal(id,v,h)
		{
			var ismandStr = "<img src='/images/BacoError.gif' align='absmiddle'>";
			var x= jQuery('#field'+id);
					if(x.length > 0){
						x.attr({'value':v});
						if(x.attr('type') == 'hidden' || document.getElementById('field'+id).style.display == 'none'){
							jQuery('#field'+id+'span').html('');
							if(arguments.length>2){
								jQuery('#field'+id+'span').html(h);
							}else{
								jQuery('#field'+id+'span').html(v);
							}
							
						}else{
							var viewtype = x.attr('viewtype');
							if(viewtype == 1 && (!v || v == '')){
								jQuery('#field'+id+'span').html(ismandStr);
							}else{
								jQuery('#field'+id+'span').html('');
							}
						}
					}	
		}
</script>
<style type="text/css">
.detailfield{
	height : 70px;
}
</style>