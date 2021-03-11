<%--
  Created by IntelliJ IDEA.
  User: WS
  Date: 2021/3/3
  Time: 14:00
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" pageEncoding="UTF-8" import="java.util.*" %>
<%@taglib  uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>test</title>
</head>
<body>
    <form action="${pageContext.request.contextPath}/user/findUser.action" method="post">
        用户姓名：<input type="text" name="name"/><br/>
        <input type="submit" value="查询">
    </form>
    <table width="300px;" border="1">
        <tr>
            <td>序号</td><td>姓名</td>
            <td>账号</td><td>电话</td>
        </tr>
        <c:forEach items="${userList}" var="user" varStatus="status">
            <tr>
                <td>${status.index+1}</td><td>${user.name}</td>
                <td>${user.username}</td><td>${user.telephone}</td>
            </tr>
        </c:forEach>
    </table>
</body>
</html>
