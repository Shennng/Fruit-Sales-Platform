<%--
  Created by IntelliJ IDEA.
  User: WS
  Date: 2021/3/9
  Time: 14:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page pageEncoding="UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>购销合同管理</title>
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
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.4.4.min.js"></script>
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

        function addContract() {
            var url="${pageContext.request.contextPath}/contract/toAddPage.action";
            window.open(url,"创建合同","height=700,width=700,scrollbars=yes");
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

        function changeType() {
            var type = jQuery("#indexType").val();
            jQuery("#type").val(type);
        }

        function getContractDetail(contractId) {
            var url="${pageContext.request.contextPath}/contract/getContractDetail.action?contractId="+contractId;
            window.open(url,"合同详情","height=700,width=700,scrollbars=yes");
        }

        function deleteContract(contractId, barCode) {
            if (window.confirm("你确定要删除合同编号为" + barCode + "的合同吗？")) {
                //  向form中引入数据
                jQuery("#dContractId").val(contractId);
                jQuery("#dStartPage").val(jQuery("#startPage").val());
                jQuery("#dCurrentPage").val(jQuery("#currentPage").val());
                jQuery("#dPageSize").val(jQuery("#pageSize").val());
                jQuery("#deleteForm").submit();  // 提交表单
            }
        }

        function editContract(contractId) {
            var url = '${pageContext.request.contextPath}/contract/toEditPage.action?contractId='+contractId;
            window.open(url,'合同编辑',"height=700,width=700,scrollbars=yes");
        }
    </script>
</head>
<body onload="init()">
    <%@include file="../menu.jsp"%><br/>
    <form id="listForm" action="${pageContext.request.contextPath}/contract/list.action" method="post">
        合同号：<input type="text" name="barCode" value="${barcode}" style="width: 120px;"/>
        零售商名称：<input type="text" name="retailerName" value="${retailerName}" style="width: 120px;"/>
        <c:if test="${type==null||type==-1}">
            类型：<select id="indexType" onchange="changeType()">
            <option value="-1" selected="selected">全部</option>
            <option value="1">省外</option>
            <option value="0">省内</option>
            </select>
            <input type="hidden" name="type" id="type" value="-1">
        </c:if>
        <c:if test="${type==0}">
            类型：<select id="indexType" onchange="changeType()">
            <option value="-1">全部</option>
            <option value="1">省外</option>
            <option value="0" selected="selected">省内</option>
            </select>
            <input type="hidden" name="type" id="type" value="0">
        </c:if>
        <c:if test="${type==1}">
            类型：<select id="indexType" onchange="changeType()">
            <option value="-1">全部</option>
            <option value="1" selected="selected">省外</option>
            <option value="0">省内</option>
            </select>
            <input type="hidden" name="type" id="type" value="1">
        </c:if><br/>
        创建日期：<input type="datetime-local" name="startTime" value="${startTime}"/> -
        <input type="datetime-local" name="endTime" value="${endTime}"/>
        <input type="submit" value="so~" style="background-color: #173e65; color:#FFFFFF; width: 70px;"/>
        <c:if test="${errorMsg!=null}">
            <font color="red">${errorMsg}</font>
        </c:if>
        <input type="hidden" name="startPage" id="startPage" value="${startPage}"/>
        <input type="hidden" name="currentPage" id="currentPage" value="${currentPage}"/>
        <input type="hidden" name="pageSize" id="pageSize" value="${pageSize}"/>
        <input type="hidden" name="sumPageNumber" id="sumPageNumber" value="${sumPageNumber}"/>
        <input type="hidden" name="countNumber" id="countNumber" value="${countNumber}"/>
    </form>
    <hr style="margin-top: 10px;"/>
    <button onclick="addContract()" style="background-color: #173e65; color:#FFFFFF; width: 70px;">添加</button>
    <c:if test="${list!=null&&list.size()>0}">
        <table style="margin-top: 10px; width: 700px; text-align: center;" border="1">
            <tr>
                <!-- 对应entity：ContractVo -->
                <td>序号</td><td>合同编号</td><td>零售商</td>
                <td>类型</td><td>创建日期</td><td>操作</td>
            </tr>
            <c:forEach items="${list}" var="item" varStatus="status">
                <tr>
                    <td>${status.index+startPage+1}</td><td><a href="#" onclick="getContractDetail('${item.contractId}')">${item.barCode}</a></td><td>${item.retailerName}</td>
                    <td>
                        <c:if test="${item.type==1}"><font color="blue">省外</font> </c:if>
                        <c:if test="${item.type==0}"><font color="blue">省内</font> </c:if>
                    </td>
                    <td>${item.createTime}</td>
                    <td>
                        <a onclick="editContract('${item.contractId}')">编辑</a> |
                        <a onclick="deleteContract('${item.contractId}','${item.barCode}')">删除</a>
                        <form id="deleteForm" action="${pageContext.request.contextPath}/contract/delete.action" method="post">
                            <input type="hidden" name="contractId" id="dContractId"/>
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
        <input type="text" id="pageNumber" style="width:50px">
        <button onclick="toLocationPage()">前往</button>
        <div id="pageInfo"></div>
    </div>
</body>
</html>
