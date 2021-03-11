<%--
  Created by IntelliJ IDEA.
  User: WS
  Date: 2021/3/5
  Time: 21:15
  To change this template use File | Settings | File Templates.
--%>
<%@ page pageEncoding="UTF-8" import="java.util.*" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>零售商管理</title>
    <style>
        *{margin:0; padding:0;}
        #menuContent a{text-decoration:none;color:#ffffff}
        .c{
            border-style: solid; width: 200px; height: 130px;
            margin: 4 23 0 23; border-radius:5px; display:block;
            background:#fff;
            margin:10% auto;
        }
        .mask,.addMask{
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

        function changeStatus() {
            var status = document.getElementById("indexStatus").value;
            document.getElementById("status").value=status;
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
        function toLocationPage() {
            var pageNumber = document.getElementById("pageNumber").value;
            var currentPageObject = document.getElementById("currentPage");
            var currentPage = currentPageObject.value;
            if (pageNumber==null||pageNumber==="") {
                alert("请输入要跳转的页码！");
            } else {
                pageNumber = parseInt(pageNumber);
                var sumPage = parseInt(document.getElementById("sumPageNumber").value);
                if (pageNumber<1 || pageNumber>sumPage) {
                    alert("请输入正确的页码！");
                } else if (pageNumber === parseInt(currentPage.value)) {
                    alert("您输入的是当前页码！");
                } else {
                    currentPageObject.value = pageNumber;
                    var pageSize = parseInt(document.getElementById("pageSize").value);
                    var startPageObject = document.getElementById("startPage");
                    if (pageNumber>currentPage) {
                        startPageObject.value = parseInt(startPageObject.value)+pageSize*(pageNumber-currentPage);
                    } else {
                        startPageObject.value = parseInt(startPageObject.value)-pageSize*(currentPage-pageNumber);
                    }
                    document.getElementById("listForm").submit();
                }
            }
        }
        function editRetailer(retailerId) {
            var message = "{\'id\':\'"+retailerId+"\'}";
            $.ajax({
                type:'post',
                url:'${pageContext.request.contextPath}/retailer/editPage.action',
                contentType:'application/json;charset=utf-8',
                dataType: 'json',
                data:message,
                success:function (data) {
                    jQuery("#editName").val(data["name"]);
                    jQuery("#editAddress").val(data["address"]);
                    jQuery("#editTelephone").val(data["telephone"]);
                    jQuery("#retailerId").val(data["retailerId"]);
                    jQuery("#editStatus").val(data["status"]);
                    jQuery("#eStatus").val(data["status"]);
                    jQuery(".mask").css("display","block");  // 设置mask这个div的display样式为block，之前为none，即为弹窗！
                    jQuery("#eStartPage").val(jQuery("#startPage").val());
                    jQuery("#eCurrentPage").val(jQuery("#currentPage").val());
                    jQuery("#ePageSize").val(jQuery("#pageSize").val());
                }
            });
        }

        function changeEditStatus() {
            var status = document.getElementById("eStatus").value;
            document.getElementById("editStatus").value = status;
        }
        
        function cancelEdit() {
            jQuery(".mask").css("display","none");
        }

        function deleteRetailer(retailerId,name) {
            if (window.confirm("你确定要删除用户" + name + "吗？")) {
                //  向form中引入数据
                jQuery("#dRetailerId").val(retailerId);
                jQuery("#dStartPage").val(jQuery("#startPage").val());
                jQuery("#dCurrentPage").val(jQuery("#currentPage").val());
                jQuery("#dPageSize").val(jQuery("#pageSize").val());
                jQuery("#deleteForm").submit();  // 提交表单
            }
        }

        function showAddMask(flag) {
            if (flag=='true') {
                jQuery(".addMask").css("display",'block');
            } else {
                jQuery(".addMask").css("display","none");
            }
        }

        function checkAddRetailer() {
            var name = jQuery("#addName").val();
            var telephone = jQuery("#addTelephone").val();
            var address = jQuery("#addAddress").val();
            var myreg = /^1[3456789]\d{9}$/;  //正则表达式

            if (name==null||name==="") {
                alert("零售商必须拥有姓名！");
                return false;
            }
            if (telephone==null||telephone==="") {
                alert("手机号麻烦告诉一下！");
                return false;
            }
            if (!myreg.test(telephone)) {
                alert("手机号格式错误！");
                return false;
            }
            if (address==null||address==="") {
                alert("零售商的地址是必须填写滴！");
                return false;
            }
            return true;
        }
    </script>
</head>
<body onload="init()">
    <%@include file="../menu.jsp"%><br/>
    <div class="addMask">
        <div class="c">
            <div style="background-color:#173e65;height:20px;color:#fff;font-size:12px;padding-left:7px;">
                添加信息<font style="float:right;padding-right: 10px;" onclick="showAddMask('false')">x</font>
            </div>
            <form id="addForm" action="${pageContext.request.contextPath}/retailer/addOne.action" method="post" onsubmit="return checkAddRetailer()">
                姓名：<input type="text" id="addName" name="name" style="width:120px"/> <br/>
                手机：<input type="text" id="addTelephone" name="telephone" style="width:120px"/><br/>
                地址：<input type="text" id="addAddress" name="address" style="width:120px"/><br/>
                <input type="hidden" name="status" value="1"/> <!-- 默认启用新添加的零售商 -->
                <input type="submit" value="添加" style="background-color:#173e65;color:#ffffff;width:70px;"/>
            </form>
        </div>
    </div>
    <div class="mask">
        <div class="c">
            <div style="background-color: #173e65; height: 20px; color: #FFFFFF; font-size: 12px; padding-left: 7px;">
                修 改 信 息 <font style="float: right; padding-right: 10px;" onclick="cancelEdit()">x</font>
            </div>
            <form id="editForm" action="${pageContext.request.contextPath}/retailer/editOne.action" method="post">
                姓名：<input type="text"  id="editName" name="name" style="width: 120px;"/><br/>
                手机：<input type="text"  id="editTelephone" name="telephone" style="width: 120px;"/><br/>
                地址：<input type="text"  id="editAddress" name="address" style="width: 120px;"/><br/>
                状态：<select id="eStatus" onchange="changeEditStatus()">
                        <option value="1">启用</option>
                        <option value="0">停用</option>
                    </select><br/>
                <input type="hidden" name="retailerId" id="retailerId"/>
                <input type="hidden" name="status" id="editStatus"/>
                <input type="hidden" name="startPage" id="eStartPage"/>
                <input type="hidden" name="currentPage" id="eCurrentPage"/>
                <input type="hidden" name="pageSize" id="ePageSize"/>
                <input type="submit" value="提交" style="background-color: #173e65; color:#ffffff; width: 70px;"/>
            </form>
        </div>
    </div>
    <form id="listForm" action="${pageContext.request.contextPath}/retailer/list.action" method="post">
        姓名：<input type="text" name="name" value="${retailer.name}" style="width: 120px;"/>
        手机：<input type="text" name="telephone" value="${retailer.telephone}" style="width: 120px;"/>
        地址：<input type="text" name="address" value="${retailer.address}" style="width: 120px;"/><br/><br/>
        <!-- 可以看到，这个hidden的status参数默认-1，也就是默认查询所有状态的零售商 -->
        <c:if test="${retailer.status==null||retailer.status==-1}">
            状态：<select id="indexStatus" onchange="changeStatus()">
            <option value="-1" selected="selected">全部</option>
            <option value="1">已启用</option>
            <option value="0">已停用</option>
            </select>
            <input type="hidden" name="status" id="status" value="-1"/>
        </c:if>
        <c:if test="${retailer.status==0}">
            状态：<select id="indexStatus" onchange="changeStatus()">
            <option value="-1" >全部</option>
            <option value="1">已启用</option>
            <option value="0" selected="selected">已停用</option>
            </select>
            <input type="hidden" name="status" id="status" value="0"/>
        </c:if>
        <c:if test="${retailer.status==1}">
            状态：<select id="indexStatus" onchange="changeStatus()">
            <option value="-1" >全部</option>
            <option value="1" selected="selected">已启用</option>
            <option value="0" >已停用</option>
            </select>
            <input type="hidden" name="status" id="status" value="1"/>
        </c:if>
        <input type="hidden" name="status" id="status" value="-1"/>
        创建日期：<input type="text" name="createTime" value="${retailer.createTime}" id="createTime" placeholder="yyyy-MM-dd HH:mm:ss"/>
        <input type="submit" value="搜索" style="background-color: #173e65; color:#FFFFFF; width: 70px;"/><br/>
        <!-- 显示错误信息 -->
        <c:if test="${errorMsg!=null}">
            <font color="red">${errorMsg}</font><br/>
        </c:if>
        <input type="hidden" name="startPage" id="startPage" value="${startPage}"/>
        <input type="hidden" name="currentPage" id="currentPage" value="${currentPage}"/>
        <input type="hidden" name="countNumber" id="countNumber" value="${countNumber}"/>
        <input type="hidden" name="pageSize" id="pageSize" value="${pageSize}"/>
        <input type="hidden" name="sumPageNumber" id="sumPageNumber" value="${sumPageNumber}"/>
    </form>
    <hr style="margin-top: 10px;"/>
    <button onclick="showAddMask('true')" style="background-color:#173e65;color:#ffffff;width:70px;">添加</button>
    <c:if test="${list!=null&&list.size()>0}">
            <table style="margin-top: 10px; width: 700px; text-align: center;" border="1">
                <tr>
                    <td>序号</td><td>姓名</td><td>手机号</td><td>地址</td>
                    <td>状态</td><td>创建日期</td><td>操作</td>
                </tr>
                <c:forEach items="${list}" var="item" varStatus="status">
                    <tr>
                        <td>${status.index+startPage+1}</td><td>${item.name}</td>
                        <td>${item.telephone}</td><td>${item.address}</td>
                        <td>
                            <c:if test="${item.status==1}">
                                <font color="blue">启用</font>
                            </c:if>
                            <c:if test="${item.status==0}">
                                <font color="red">停用</font>
                            </c:if>
                        </td>
                        <td>${item.createTime}</td>
                        <td>
                            <a onclick="editRetailer('${item.retailerId}')">编辑</a> |
                            <a onclick="deleteRetailer('${item.retailerId}','${item.name}')">删除</a>
                            <form id="deleteForm" action="${pageContext.request.contextPath}/retailer/deleteOne.action" method="post">
                                <input type="hidden" name="retailerId" id="dRetailerId"/>
                                <input type="hidden" name="startPage" id="dStartPage"/>
                                <input type="hidden" name="currentPage" id="dCurrentPage"/>
                                <input type="hidden" name="pageSize" id="dPageSize"/>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </c:if>
    <c:if test="${list==null||list.size()<1}">
            <b>搜索结果为空！</b>
        </c:if>
    <div style="margin-top: 10px;">
        <a onclick="toPrePage()"><font color="blue">&lt;上一页&gt;</font></a> | <a onclick="toNextPage()"><font color="blue">&lt;下一页&gt;</font></a>
        <input type="text" id="pageNumber" style="width: 50px;"/><button onclick="toLocationPage()">前往</button>
        <div id="pageInfo"></div>
    </div>
    <script src="${pageContext.request.contextPath }/laydate/laydate.js"></script>
    <script type="text/javascript">
        //日期时间选择器
        laydate.render({
            elem: '#createTime',
            type: 'datetime'
        });
    </script>
</body>
</html>
