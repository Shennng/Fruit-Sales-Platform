<%--
  Created by IntelliJ IDEA.
  User: WS
  Date: 2021/3/5
  Time: 17:00
  To change this template use File | Settings | File Templates.
--%>
<%@ page pageEncoding="UTF-8" import="java.util.*" language="java" %>
<div id="menuContent" style="background-color: #54A857; color:#FFFFFF; height: 120px;">
    <br/><h1 style="margin-left: 20px;">白王™水果网络销售平台</h1><br/>
    <div style="margin-left: 20px;">
        <a style="color: rebeccapurple;" href="${pageContext.request.contextPath}/commodities/list.action" >货物管理</a> |
        <a style="
        color: #333333;" href="${pageContext.request.contextPath}/retailer/list.action?status=-1">零售商管理</a> |
        <a style="color:#333333;" href="${pageContext.request.contextPath}/contract/list.action?type=-1">购销合同</a> |
        <a>用户设置</a>
    </div>
</div>
<div style="background-color: #E8BA36;">
    <span style="margin-left: 20px;">欢迎您，${sessionScope.user.name}</span>
</div>
