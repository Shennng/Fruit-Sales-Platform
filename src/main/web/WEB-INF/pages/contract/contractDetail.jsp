<%--
  Created by IntelliJ IDEA.
  User: WS
  Date: 2021/3/11
  Time: 11:08
  To change this template use File | Settings | File Templates.
--%>
<%@ page pageEncoding="UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>合同详情</title>
    <script type="text/javascript">
        function printPage(){
            document.getElementById('p').style.display='none';  // 隐藏按钮
            window.print();  //打印网页
            document.getElementById('p').style.display='block'; // 显示按钮
        }
    </script>
</head>
<body>
    <h2 style="text-align: center;">购销合同</h2>
    <button id="p" onclick="printPage()">打印</button>
    <div style="float: right; font-size: 10px;">
        创建日期：${contract.createTime}
    </div>
    合同编码：<b style="color: blue;">${contract.barCode}</b><br/>
    类型：<c:if test="${contract.type==0}">省内</c:if>
    <c:if test="${contract.type==1}">省外</c:if><br/><hr/>
    <div class="info">
        -- 零售商信息 --<br/>
        姓名：${contract.retailer.name}<br/>
        联系电话：${contract.retailer.telephone}<br/>
        送货地址：${contract.retailer.address}<br/>
    </div><hr/>
    <div class="info">
        -- 货物信息 --<br/>
        <c:if test="${contract.commoditiesList!=null}">
            <table style="width: 510px; text-align:center;" border="1">
                <tr>
                    <td>名称</td><td>价格</td><td>产地</td>
                    <td>附属品</td><td>数量</td>
                </tr>
                <c:forEach items="${contract.commoditiesList}" var="item">
<%--                    commoditiesVo--%>
                    <tr>
                        <td>${item.name}</td><td>${item.price}元/斤</td><td>${item.locality}</td>
                        <td>
                                <c:if test="${item.accessoryList!=null}">
                                    <c:if test="${item.accessoryList[0]==null}">无</c:if>
                                    <c:forEach items="${item.accessoryList}" var="accessoryItem">
                                        ${accessoryItem.name}：${accessoryItem.price}元<br/>
                                    </c:forEach>
                                </c:if>
                        </td>
                        <td>${item.number}斤</td>
                    </tr>
                </c:forEach>
            </table>
        </c:if>
    </div>
</body>
</html>
