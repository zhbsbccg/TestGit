<%@ page language="java" contentType="text/html; charset=GBK" %>
<script language="javascript"> 
//��������=7165
//ԭ����=7171ԭ��Ŀ=7172ԭԤ��ʹ�����=7173Ŀ�겿��=7174Ŀ���Ŀ=7175Ŀ��Ԥ��ʹ�����=7176�������=7177
//�޿���ԭԤ��ʹ�����=7232Ŀ��Ԥ��ʹ�����=7233
jQuery(document).ready(function(){
    jQuery("#nodesnum0").bind("propertychange",function(){
			bindfee(1);
    });
    	bindfee(2);
})
 
//Ԥ���Ŀ�� 7172=ԭ��Ŀ  7175=Ŀ���Ŀ
function bindfee(value){
    var indexnum0 = 0;
    if(document.getElementById("indexnum0")){
			indexnum0 = document.getElementById("indexnum0").value * 1.0 - 1;
    }
    if(indexnum0>=0){
    	if(value==1){//��ǰ��ӵ���
    		//ԭ��Ŀ
			var ykm = "#field7172_"+indexnum0;		//7172=ԭ��Ŀ
		    jQuery(ykm).bind("propertychange",function(){
		    	var subject = jQuery(ykm).val();    
		    	var applydate = jQuery("#field7165").val();    //��������=7165
		    	var deptid = jQuery("#field7171_"+indexnum0).val();      //ԭ����=7171
			      if(subject==""){
			      	jQuery("#field7173_"+indexnum0+"span").html("");  //ԭԤ��ʹ�����=7173
			      }else{
					    if(applydate=="" || deptid==""){
					    	if(applydate==""){
					    		alert("����ѡ����������!");
					    	}
					    	return;
					    }else{
					    	getfnainfo(applydate,deptid,subject,indexnum0,7173,7232);
			        	}
			      }
		    })
    		//ԭ����
		    jQuery("#field7171_"+indexnum0).bind("propertychange",function(){
		    	var subject = jQuery("#field7172_"+indexnum0).val(); 
		    	var applydate = jQuery("#field7165").val();              //��������=7165
		    	var deptid = jQuery("#field7171_"+indexnum0).val();      //ԭ����=7171
			      if(deptid==""){
			      	jQuery("#field7173_"+indexnum0+"span").html("");  //ԭԤ��ʹ�����=7173
			      }else{
					    if(applydate=="" || subject==""){
					    	if(applydate==""){
					    		alert("����ѡ����������!");
					    	}
					    	return;
					    }else{
					    	getfnainfo(applydate,deptid,subject,indexnum0,7173,7232);
			        	}
			      }
		    })
		    //Ŀ���Ŀ
			var mbkm = "#field7175_"+indexnum0;		//7175=Ŀ���Ŀ
		    jQuery(mbkm).bind("propertychange",function(){
		    	var subject = jQuery(mbkm).val();    
		    	var applydate = jQuery("#field7165").val();    //��������=7165
		    	var deptid = jQuery("#field7174_"+indexnum0).val();      //Ŀ�겿��=7174 
		      if(subject==""){
		      	jQuery("#field7176_"+indexnum0+"span").html(""); //Ŀ��Ԥ��ʹ�����=7176
		      }else{
				    if(applydate=="" || deptid==""){
				    	if(applydate==""){
				    		alert("����ѡ����������!");
				    	}
				    	return;
				    }else{
				    	getfnainfo(applydate,deptid,subject,indexnum0,7176,7233);
		        	}
		      }
		    })
    		//Ŀ�겿��
		    jQuery("#field7174_"+indexnum0).bind("propertychange",function(){
		    	var subject = jQuery("#field7175_"+indexnum0).val(); 
		    	var applydate = jQuery("#field7165").val();              //��������=7165
		    	var deptid = jQuery("#field7174_"+indexnum0).val();       
			      if(deptid==""){
			      	jQuery("#field7176_"+indexnum0+"span").html("");  //Ŀ��Ԥ��ʹ�����=7176
			      }else{
					    if(applydate=="" || subject==""){
					    	if(applydate==""){
					    		alert("����ѡ����������!");
					    	}
					    	return;
					    }else{
					    	getfnainfo(applydate,deptid,subject,indexnum0,7176,7233);
			        	}
			      }
		    })
		    
			}else if(value==2){//��ʼ��
				for(var i=0;i<=indexnum0;i++){
					var yskm = "#field7172_"+i;		//7172=ԭ��Ŀ
					jQuery(yskm).attr("indexno",i);
				    jQuery(yskm).bind("propertychange",function(){
				    	var indexno = this.indexno;
				    	var subject = jQuery("#field7172_"+indexno).val();    
				    	var applydate = jQuery("#field7165").val();    //��������=7165
				    	var deptid = jQuery("#field7171_"+indexno).val();      //ԭ����=7171
					      if(subject==""){
					      	jQuery("#field7173_"+indexno+"span").html(""); 
					      }else{
							    if(applydate=="" || deptid==""){
							    	if(applydate==""){
							    		alert("����ѡ����������!");
							    	}
							    	return;
							    }else{
							    	getfnainfo(applydate,deptid,subject,indexno,7173,7232);
					        }
					      }
				    })
					var deptfieldid1 = "#field7171_"+i;		//ԭ����=7171
					jQuery(deptfieldid1).attr("indexno",i);
				    jQuery(deptfieldid1).bind("propertychange",function(){
				    	var indexno = this.indexno;
				    	var subject = jQuery("#field7172_"+indexno).val();    
				    	var applydate = jQuery("#field7165").val();    //��������=7165
				    	var deptid = jQuery("#field7171_"+indexno).val();      //ԭ����=7171
					      if(subject==""){
					      	jQuery("#field7173_"+indexno+"span").html(""); 
					      }else{
							    if(applydate=="" || deptid==""){
							    	if(applydate==""){
							    		alert("����ѡ����������!");
							    	}
							    	return;
							    }else{
							    	getfnainfo(applydate,deptid,subject,indexno,7173,7232);
					        }
					      }
				    })
				    //ԭԤ��ʹ�����
			    	var subject = jQuery(yskm).val();    
			    	var applydate = jQuery("#field7165").val();    //��������=7165
			    	var deptid1 = jQuery("#field7171_"+i).val();      //ԭ����=7171
					getfnainfo(applydate,deptid1,subject,i,7173,7232);

						
					var mbkm = "#field7175_"+i;		//7175=Ŀ���Ŀ
					jQuery(mbkm).attr("indexno",i);
				    jQuery(mbkm).bind("propertychange",function(){
				    	var indexno = this.indexno;
				    	var subject = jQuery("#field7175_"+indexno).val();    
				    	var applydate = jQuery("#field7165").val();    //��������=7165
				    	var deptid = jQuery("#field7174_"+indexno).val();      //Ŀ�겿��=7174
					      if(subject==""){
					      	jQuery("#field7176_"+indexno+"span").html(""); 
					      }else{
							    if(applydate=="" || deptid==""){
							    	if(applydate==""){
							    		alert("����ѡ����������!");
							    	}
							    	return;
							    }else{
							    	getfnainfo(applydate,deptid,subject,indexno,7176,7233);
					        }
					      }
				    })
					var deptfieldid2 = "#field7174_"+i;		//Ŀ�겿��=7174
					jQuery(deptfieldid2).attr("indexno",i);
				    jQuery(deptfieldid2).bind("propertychange",function(){
				    	var indexno = this.indexno;
				    	var subject = jQuery("#field7174_"+indexno).val();    
				    	var applydate = jQuery("#field7165").val();    //��������=7165
				    	var deptid = jQuery("#field7174_"+indexno).val();      //Ŀ�겿��=7174
					      if(subject==""){
					      	jQuery("#field7176_"+indexno+"span").html(""); 
					      }else{
							    if(applydate=="" || deptid==""){
							    	if(applydate==""){
							    		alert("����ѡ����������!");
							    	}
							    	return;
							    }else{
							    	getfnainfo(applydate,deptid,subject,indexno,7176,7233);
					        }
					      }
				    })
				    //Ŀ��Ԥ��ʹ����� 
			    	var subject2 = jQuery(mbkm).val();    
			    	var deptid2 = jQuery("#field7174_"+i).val();      //Ŀ�겿��=7174
					  getfnainfo(applydate,deptid2,subject2,i,7176,7233);
				}
			}
    }
}
 
//�õ�����Ԥ��ʹ����� ��������=7165  
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
    		msg="����Ԥ��:"+values[0]+"<br><font color=red>����Ԥ�㣺"+values[1]+"</font><br><font color=green>�����з��ã�"+values[2]+"</font>";
    		var msg2="<font color=red>����Ԥ�㣺"+values[1]+"</font><br><font color=green>�����з��ã�"+values[2]+"</font>";
    		jQuery("#field"+fieldid+"_"+num0+"span").html(msg); 
    		jQuery("#field"+fieldid2+"_"+num0+"span").html(msg2); 
		}
	});	
}
</script>