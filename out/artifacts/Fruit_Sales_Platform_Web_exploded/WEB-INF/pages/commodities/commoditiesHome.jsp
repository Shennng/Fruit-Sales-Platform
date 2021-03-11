<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html >
  <head>
    <title>货物管理</title>
    <style>
        *{margin:0; padding:0;}
        #menuContent a{text-decoration:none;color:#ffffff}
        .c{
          border-style: solid;width: 200px;height: 130px;
          margin: 4 23 0 23;border-radius:5px;display:block;
          background:#fff;
          margin:10% auto;
        }
        .mask,.addMask {
        	width:100%;
        	height:100%;
        	position: absolute;
        	background:rgba(0,0,0,.3);
        	display: none;
        }
    </style>
        
    <script type="text/javascript" 
  		src="${pageContext.request.contextPath }/js/jquery-1.4.4.min.js"></script>  
    <script type="text/javascript">
		function init() {
			var countNumber = document.getElementById("countNumber").value;
			var sumPageNumber = document.getElementById("sumPageNumber").value;
			var currentPage = document.getElementById("currentPage").value;
			var info = "一共<font color='blue'>"+countNumber+"</font>条数据，"+
					"共<font color='blue'>"+sumPageNumber+"</font>页，"+
					"当前第<font color='blue'>"+currentPage+"</font>页";
			document.getElementById("pageInfo").innerHTML=info;
		}

	   function toPrePage() {
		   var currentPageObject = document.getElementById("currentPage");
		   var currentPage = parseInt(currentPageObject.value);
		   if (currentPage===1) {
			   alert("数据已到顶！");
		   } else {
			   currentPageObject.value = currentPage-1;
			   var pageSize = parseInt(document.getElementById("pageSize").value);
			   var startPageObject = document.getElementById("startPage");
			   startPageObject.value = parseInt(startPageObject.value)-pageSize;
			   document.getElementById("listForm").submit();
		   }
	   }

	   function toNextPage() {
		   var currentPageObject = document.getElementById("currentPage");
		   var currentPage = parseInt(currentPageObject.value);
		   var sumPageNumber = document.getElementById("sumPageNumber").value;
		   if (currentPage>=sumPageNumber) {
			   alert("我是有底线的！\n【数据已到底！】");
		   } else {
			   currentPageObject.value = currentPage+1;
			   var pageSize = parseInt(document.getElementById("pageSize").value);
			   var startPageObject = document.getElementById("startPage");
			   startPageObject.value = parseInt(startPageObject.value)+pageSize;
			   document.getElementById("listForm").submit();
		   }
	   }
       
       function toLocationPage(){
           var pageNumber = document.getElementById("pageNumber").value;
           var currentPageObject = document.getElementById("currentPage");
           var currentPage = currentPageObject.value;
           if(pageNumber==null||pageNumber===""){
               alert("请输入要跳转的页数！");
           }else{
        	   pageNumber = parseInt(pageNumber);
               var sumPage = parseInt(document.getElementById("sumPageNumber").value);
			   if (pageNumber<1 || pageNumber>sumPage) {
				   alert("请输入正确的页码！");
			   } else if (pageNumber === parseInt(currentPage.value)) {
				   alert("您输入的是当前页码！");
			   } else {
	               currentPageObject.value = pageNumber;
	               var pageSize = parseInt(document.getElementById("pageSize").value);
                   var startPageObject =document.getElementById("startPage");
				   if (pageNumber>currentPage) {
					   startPageObject.value = parseInt(startPageObject.value)+pageSize*(pageNumber-currentPage);
				   } else {
					   startPageObject.value = parseInt(startPageObject.value)-pageSize*(currentPage-pageNumber);
				   }
	               document.getElementById("listForm").submit();
	           }
           }
       }
       
       function editCommodities(id){
             var message="{'id':'"+id+"'}";
       		 $.ajax({
                type:'post',  
                url:'${pageContext.request.contextPath}/commodities/editCommodities.action',
                contentType:'application/json;charset=utf-8',
				dataType:'json',
                data:message,//数据格式是json串  
                success:function(data){//返回json结果 
                    jQuery("#editName").val(data["name"]);
                    jQuery("#editPrice").val(data["price"]);
                    jQuery("#editLocality").val(data["locality"]);
                    jQuery("#fruitId").val(data["fruitId"]);
                    //显示弹出框
                    jQuery(".mask").css("display","block");
                    //引入分页信息至该form表单
                    jQuery("#eStartPage").val(jQuery("#startPage").val());
                    jQuery("#eCurrentPage").val(jQuery("#currentPage").val());
                    jQuery("#ePageSize").val(jQuery("#pageSize").val());
                }   
            });  
       }

       function cancelEdit(){
    	   jQuery(".mask").css("display","none");
       }

       function deleteCommodities(id,name){
    	   if(window.confirm("你确定要删除货物["+name+"]吗？")){
    		   jQuery("#dFruitId").val(id);//向form中引入id
        	   //引入分页信息至该form表单
               jQuery("#dStartPage").val(jQuery("#startPage").val());
               jQuery("#dCurrentPage").val(jQuery("#currentPage").val());
               jQuery("#dPageSize").val(jQuery("#pageSize").val());
               jQuery("#deleteForm").submit();//提交表单
            }
       }

	   function showAddMask(flag){
		    if(flag==="true"){
		 	   jQuery(".addMask").css("display","block");
		    }else{
		 	   jQuery(".addMask").css("display","none");
		    }
	   }

	   function checkAddCommodities(){
		   var name = jQuery("#addName").val();
		   var price = jQuery("#addPrice").val();
		   var locality = jQuery("#addLocality").val();

           if(name==null||name===""){
               alert("货品名称不能为空！");
               return false;
           }
           if(price==null||price===""){
               alert("价格不能为空！");
               return false;
           }
           if(locality==null||locality===""){
               alert("产地不能为空！");
               return false;
           }
           return true;
	   }

	   function openwin(id) { 
		   var url="${pageContext.request.contextPath}/accessory/list.action?fruitId="+id;
	       window.open (url,"附属品","height=400,width=700,scrollbars=yes"); 
	   }
    </script>
  </head>
  <body onload="init()">
      <%@ include file="../menu.jsp" %><br/>
   <div class="addMask">
	   <div class="c">
	     <div style="background-color:#173e65;height:20px;color:#fff;font-size:12px;padding-left:7px;">
	     	添 加 信 息<font style="float:right;padding-right: 10px;" onclick="showAddMask('false')">x</font>
	     </div>
	     <form id="addForm" action="${pageContext.request.contextPath}/commodities/add.action" method="post" onsubmit="checkAddCommodities()">
		        名称：<input type="text" id="addName" name="name" style="width:120px"/> <br/>
		        价格：<input type="text" id="addPrice" name="price" style="width:120px"/><br/>
		        产地：<input type="text" id="addLocality" name="locality" style="width:120px"/><br/>
		     <input type="submit" value="添加" style="background-color:#173e65;color:#ffffff;width:70px;"/>
	     </form>
	    </div>
   </div>
   <div class="mask">
	   <div class="c">
	     <div style="background-color:#173e65;height:20px;color:#fff;font-size:12px;padding-left:7px;">
	     	修 改 信 息<font style="float:right;padding-right: 10px;" onclick="cancelEdit()">x</font>
	     </div>
	     <form id="editForm" action="${pageContext.request.contextPath}/commodities/edit.action" method="post">
		        名称：<input type="text" id="editName" name="name" style="width:120px"/> <br/>
		        价格：<input type="text" id="editPrice" name="price" style="width:120px"/><br/>
		        产地：<input type="text" id="editLocality" name="locality" style="width:120px"/><br/>
		     <input type="hidden" name="fruitId" id="fruitId"/>
		     <input type="hidden" name="startPage" id="eStartPage"/>
			 <input type="hidden" name="currentPage" id="eCurrentPage"/>
			 <input type="hidden" name="pageSize" id="ePageSize"/>
		     <input type="submit" value="提交" style="background-color:#173e65;color:#ffffff;width:70px;"/>
	     </form>
	    </div>
  </div>
  <form id="listForm" action="${pageContext.request.contextPath}/commodities/list.action" method="post">
        名称：<input type="text" name="name" style="width:120px" value="${commodities.name}"/> 
        产地：<input type="text" name="locality" style="width:120px" value="${commodities.locality}"/>
        价格：<input id="price1" name="startPrice" type="number" min="0.0" step="0.1" style="width:60px" value="${startPrice}"/> 
        - <input id="price2" name="endPrice" type="number" min="0.0" step="0.1" style="width:60px" value="${endPrice}"/><br/><br/>
        创建日期：<input type="datetime-local" name="startTime" value="${startTime}"/> - <input type="datetime-local" name="endTime" value="${endTime}"/>
     <!-- 显示错误信息 -->
	 <c:if test="${errorMsg!=null}">
	     <font color="red">${errorMsg}</font><br/>
	 </c:if>
	 <input type="hidden" name="startPage" id="startPage" value="${startPage}"/>
	 <input type="hidden" name="currentPage" id="currentPage" value="${currentPage}"/>
	 <input type="hidden" name="pageSize" id="pageSize" value="${pageSize}"/>
	 <input type="hidden" name="sumPageNumber" id="sumPageNumber" value="${sumPageNumber}"/>
	 <input type="hidden" name="countNumber" id="countNumber" value="${countNumber}"/>
	  <input type="submit" value="搜索" style="background-color:#173e65;color:#ffffff;width:70px;"/><br/>
  </form>
  <hr style="margin-top: 10px;"/> 
  <button onclick="showAddMask('true')" style="background-color:#173e65;color:#ffffff;width:70px;">添加</button>
  <c:if test="${list!=null&&list.size()>0}">
	  <table style="margin-top: 10px;width:700px;text-align:center;" border=1>  
	    <tr>  
	      <td>序号</td><td>名称</td><td>价格</td><td>产地</td>
	      <td>创建日期</td><td>操作</td>
	   </tr>  
      <c:forEach items="${list}" var="item" varStatus="status">  
	     <tr>  
	       <td>${status.index+startPage+1}</td><td>${item.name }</td>
	       <td>${item.price}</td><td>${item.locality }</td>  
	       <td>${item.createTime}</td>
	       <td>
	       		<a onclick="editCommodities('${item.fruitId}')">编辑</a> |
	       		<a onclick="deleteCommodities('${item.fruitId}','${item.name }')">删除</a> |
	       		<a onclick="openwin('${item.fruitId}')">附属品</a>
	       		<form id="deleteForm" action="${pageContext.request.contextPath}/commodities/delete.action" method="post">
				   <input type="hidden" name="fruitId" id="dFruitId"/>
				   <input type="hidden" name="startPage" id="dStartPage"/>
				   <input type="hidden" name="currentPage" id="dCurrentPage"/>
				   <input type="hidden" name="pageSize" id="dPageSize"/>
	       		</form>
	       </td>
	     </tr>  
	    </c:forEach>  
	    </table> 
   </c:if>
   <c:if test="${list==null||list.size<1}">
       <b>搜索结果为空！</b>
   </c:if>
   <div style="margin-top: 10px;">
	   <a onclick="toPrePage()"><font color="blue">&lt;上一页&gt;</font></a> | <a onclick="toNextPage()"><font color="blue">&lt;下一页&gt;</font></a>
       <input type="text" id="pageNumber" style="width:50px">
       <button onclick="toLocationPage()">前往</button>
       <div id="pageInfo"></div>
   </div>
  </body>
</html>
