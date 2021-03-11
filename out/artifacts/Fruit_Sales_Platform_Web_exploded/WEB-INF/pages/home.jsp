<%--
  Created by IntelliJ IDEA.
  User: WS
  Date: 2021/3/4
  Time: 23:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page pageEncoding="UTF-8" language="java" import="com.fruitsalesplatform.entity.User,java.util.*" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>主页</title>
    <style>*{margin: 0; padding: 0;}#menuContent a{text-decoration: none; color: #FFFFFF}</style>
</head>
<body>
<%--    欢迎您，${user.name} <br/>--%>
<%--    欢迎您，<%=(String) ((User)session.getAttribute("user")).getName()%>--%>
<%--    欢迎您，${sessionScope.user.name}<br/>--%>
    <%@include file="menu.jsp"%><br/><br/><br/>
    <center>
        <img src="${pageContext.request.contextPath}/pic/bigTiger.gif"/>
    </center>
</body>
</html>
