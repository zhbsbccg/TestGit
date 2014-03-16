<%@ page language="java" contentType="text/html; charset=GBK" %>
<script language="javascript"> 
//申请日期=7165
//原部门=7171原科目=7172原预算使用情况=7173目标部门=7174目标科目=7175目标预算使用情况=7176调剂金额=7177
//无可用原预算使用情况=7232目标预算使用情况=7233
jQuery(document).ready(function(){
    jQuery("#nodesnum0").bind("propertychange",function(){
			bindfee(1);
    });
    	bindfee(2);
})
 
//预算科目绑定 7172=原科目  7175=目标科目
function bindfee(value){
    var indexnum0 = 0;
    if(document.getElementById("indexnum0")){
			indexnum0 = document.getElementById("indexnum0").value * 1.0 - 1;
    }
    if(indexnum0>=0){
    	if(value==1){//当前添加的行
    		//原科目
			var ykm = "#field7172_"+indexnum0;		//7172=原科目
		    jQuery(ykm).bind("propertychange",function(){
		    	var subject = jQuery(ykm).val();    
		    	var applydate = jQuery("#field7165").val();    //申请日期=7165
		    	var deptid = jQuery("#field7171_"+indexnum0).val();      //原部门=7171
			      if(subject==""){
			      	jQuery("#field7173_"+indexnum0+"span").html("");  //原预算使用情况=7173
			      }else{
					    if(applydate=="" || deptid==""){
					    	if(applydate==""){
					    		alert("请先选择申请日期!");
					    	}
					    	return;
					    }else{
					    	getfnainfo(applydate,deptid,subject,indexnum0,7173,7232);
			        	}
			      }
		    })
    		//原部门
		    jQuery("#field7171_"+indexnum0).bind("propertychange",function(){
		    	var subject = jQuery("#field7172_"+indexnum0).val(); 
		    	var applydate = jQuery("#field7165").val();              //申请日期=7165
		    	var deptid = jQuery("#field7171_"+indexnum0).val();      //原部门=7171
			      if(deptid==""){
			      	jQuery("#field7173_"+indexnum0+"span").html("");  //原预算使用情况=7173
			      }else{
					    if(applydate=="" || subject==""){
					    	if(applydate==""){
					    		alert("请先选择申请日期!");
					    	}
					    	return;
					    }else{
					    	getfnainfo(applydate,deptid,subject,indexnum0,7173,7232);
			        	}
			      }
		    })
		    //目标科目
			var mbkm = "#field7175_"+indexnum0;		//7175=目标科目
		    jQuery(mbkm).bind("propertychange",function(){
		    	var subject = jQuery(mbkm).val();    
		    	var applydate = jQuery("#field7165").val();    //申请日期=7165
		    	var deptid = jQuery("#field7174_"+indexnum0).val();      //目标部门=7174 
		      if(subject==""){
		      	jQuery("#field7176_"+indexnum0+"span").html(""); //目标预算使用情况=7176
		      }else{
				    if(applydate=="" || deptid==""){
				    	if(applydate==""){
				    		alert("请先选择申请日期!");
				    	}
				    	return;
				    }else{
				    	getfnainfo(applydate,deptid,subject,indexnum0,7176,7233);
		        	}
		      }
		    })
    		//目标部门
		    jQuery("#field7174_"+indexnum0).bind("propertychange",function(){
		    	var subject = jQuery("#field7175_"+indexnum0).val(); 
		    	var applydate = jQuery("#field7165").val();              //申请日期=7165
		    	var deptid = jQuery("#field7174_"+indexnum0).val();       
			      if(deptid==""){
			      	jQuery("#field7176_"+indexnum0+"span").html("");  //目标预算使用情况=7176
			      }else{
					    if(applydate=="" || subject==""){
					    	if(applydate==""){
					    		alert("请先选择申请日期!");
					    	}
					    	return;
					    }else{
					    	getfnainfo(applydate,deptid,subject,indexnum0,7176,7233);
			        	}
			      }
		    })
		    
			}else if(value==2){//初始化
				for(var i=0;i<=indexnum0;i++){
					var yskm = "#field7172_"+i;		//7172=原科目
					jQuery(yskm).attr("indexno",i);
				    jQuery(yskm).bind("propertychange",function(){
				    	var indexno = this.indexno;
				    	var subject = jQuery("#field7172_"+indexno).val();    
				    	var applydate = jQuery("#field7165").val();    //申请日期=7165
				    	var deptid = jQuery("#field7171_"+indexno).val();      //原部门=7171
					      if(subject==""){
					      	jQuery("#field7173_"+indexno+"span").html(""); 
					      }else{
							    if(applydate=="" || deptid==""){
							    	if(applydate==""){
							    		alert("请先选择申请日期!");
							    	}
							    	return;
							    }else{
							    	getfnainfo(applydate,deptid,subject,indexno,7173,7232);
					        }
					      }
				    })
					var deptfieldid1 = "#field7171_"+i;		//原部门=7171
					jQuery(deptfieldid1).attr("indexno",i);
				    jQuery(deptfieldid1).bind("propertychange",function(){
				    	var indexno = this.indexno;
				    	var subject = jQuery("#field7172_"+indexno).val();    
				    	var applydate = jQuery("#field7165").val();    //申请日期=7165
				    	var deptid = jQuery("#field7171_"+indexno).val();      //原部门=7171
					      if(subject==""){
					      	jQuery("#field7173_"+indexno+"span").html(""); 
					      }else{
							    if(applydate=="" || deptid==""){
							    	if(applydate==""){
							    		alert("请先选择申请日期!");
							    	}
							    	return;
							    }else{
							    	getfnainfo(applydate,deptid,subject,indexno,7173,7232);
					        }
					      }
				    })
				    //原预算使用情况
			    	var subject = jQuery(yskm).val();    
			    	var applydate = jQuery("#field7165").val();    //申请日期=7165
			    	var deptid1 = jQuery("#field7171_"+i).val();      //原部门=7171
					getfnainfo(applydate,deptid1,subject,i,7173,7232);

						
					var mbkm = "#field7175_"+i;		//7175=目标科目
					jQuery(mbkm).attr("indexno",i);
				    jQuery(mbkm).bind("propertychange",function(){
				    	var indexno = this.indexno;
				    	var subject = jQuery("#field7175_"+indexno).val();    
				    	var applydate = jQuery("#field7165").val();    //申请日期=7165
				    	var deptid = jQuery("#field7174_"+indexno).val();      //目标部门=7174
					      if(subject==""){
					      	jQuery("#field7176_"+indexno+"span").html(""); 
					      }else{
							    if(applydate=="" || deptid==""){
							    	if(applydate==""){
							    		alert("请先选择申请日期!");
							    	}
							    	return;
							    }else{
							    	getfnainfo(applydate,deptid,subject,indexno,7176,7233);
					        }
					      }
				    })
					var deptfieldid2 = "#field7174_"+i;		//目标部门=7174
					jQuery(deptfieldid2).attr("indexno",i);
				    jQuery(deptfieldid2).bind("propertychange",function(){
				    	var indexno = this.indexno;
				    	var subject = jQuery("#field7174_"+indexno).val();    
				    	var applydate = jQuery("#field7165").val();    //申请日期=7165
				    	var deptid = jQuery("#field7174_"+indexno).val();      //目标部门=7174
					      if(subject==""){
					      	jQuery("#field7176_"+indexno+"span").html(""); 
					      }else{
							    if(applydate=="" || deptid==""){
							    	if(applydate==""){
							    		alert("请先选择申请日期!");
							    	}
							    	return;
							    }else{
							    	getfnainfo(applydate,deptid,subject,indexno,7176,7233);
					        }
					      }
				    })
				    //目标预算使用情况 
			    	var subject2 = jQuery(mbkm).val();    
			    	var deptid2 = jQuery("#field7174_"+i).val();      //目标部门=7174
					  getfnainfo(applydate,deptid2,subject2,i,7176,7233);
				}
			}
    }
}
 
//得到部门预算使用情况 申请日期=7165  
function getfnainfo(applydate,deptid,subject,num0,fieldid,fieldid2){
	jQuery.ajax({
		url : "/workflow/request/FnaAjaxData.jsp",
		type : "post",
		async : false,
		processData : false,
		data : "applydate="+applydate+"&deptid="+deptid+"&subject="+subject,
		dataType : "html",
		success: function do4Success(msg){
        var values = msg.trim().split("|");
    		msg="可用预算:"+values[0]+"<br><font color=red>已用预算："+values[1]+"</font><br><font color=green>审批中费用："+values[2]+"</font>";
    		var msg2="<font color=red>已用预算："+values[1]+"</font><br><font color=green>审批中费用："+values[2]+"</font>";
    		jQuery("#field"+fieldid+"_"+num0+"span").html(msg); 
    		jQuery("#field"+fieldid2+"_"+num0+"span").html(msg2); 
		}
	});	
}
</script>