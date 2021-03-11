<%--
  Created by IntelliJ IDEA.
  User: WS
  Date: 2021/3/11
  Time: 14:37
  To change this template use File | Settings | File Templates.
--%>
<%@ page pageEncoding="UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>合同编辑</title>
    <style type="text/css">
        *{margin:0; padding:0;}
        .btn{background-color:#173e65;color:#ffffff;width:70px;}
        .btn-div{text-align: center;}
        .info{border: 1px solid #CCC}
        .c{
            border-style: solid;width: 200px;height: fit-content;
            margin: 4 23 0 23;border-radius:5px;display:block;
            background:#fff;
            margin:10% auto;
            text-align: center;
        }
        .c2{
            border-style: solid;width: 400px;height: 320px;
            margin: 4 23 0 23;border-radius:5px;display:block;
            background:#fff;
            margin:10% auto;
            text-align: center;
        }
        .retailerMask,.commoditiesMask{
            width:100%;
            height:100%;
            position: absolute;
            background:rgba(0,0,0,.3);
            display: none;
        }
    </style>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.4.4.min.js"></script>
    <script type="text/javascript">
        function searchRetailer() {
            var retailerName = jQuery("#retailerName").val();
            if (retailerName==null || retailerName==="") {
                addRetailer(null);
            } else {
                addRetailer(retailerName);
            }
        }

        function cancelEdit() {
            jQuery(".retailerMask").css("display","none");
            jQuery(".commoditiesMask").css("display","none");
        }

        function checkEditContract() {
            // 检查是否选择了零售商，是否选择了有效的货物
            if (jQuery("#retailer_info").css("display")!=="none") {
                return true;
            }
            var array = document.getElementsByName("eNumberArrays");
            for (var i=0;i<array.length;i++) {
                if(array[i].value>0) {
                    return true;
                }
            }
            <%--if (jQuery("#type").val()!==${contract.type}) {--%>
            <%--    return true;--%>
            <%--}--%>
            alert("数据不合法，请重新编辑提交！");
            return false;
        }

        function changeType() {
            var type = jQuery("#indexType").val();
            jQuery("#eType").val(type);
        }
        function selectRetailer(retailerId,name,telephone,address) {
            jQuery("#eRetailerId").val(retailerId);
            jQuery("#retailer_name").html("<font color='#54A857'>"+"姓名："+name+"</font>");
            jQuery("#retailer_telephone").html("<font color='#54A857'>"+"联系电话："+telephone+"</font>");
            jQuery("#retailer_address").html("<font color='#54A857'>"+"送货地址："+address+"</font>");
            jQuery(".retailerMask").css("display","none");
            jQuery("#retailer_info").css("display","block");
        }
        function addRetailer(name) {
            // 异步请求零售商列表
            jQuery("#retailerList").html("");  // 清空div：retailerList
            var message="";
            if (name!=null) {
                message = "{'name':'"+name+"'}";
            }
            $.ajax({
                type:'post',
                url:'${pageContext.request.contextPath}/contract/getAllRetailer.action',
                contentType:'application/json;charset=utf-8',
                data:message,
                success: function (data) {
                    if (data.length<1){
                        alert("没有找到数据。");
                    } else {
                        for (var i=0;i<data.length;i++) {
                            var oldHtml = jQuery("#retailerList").html();
                            var info = "<p onclick=\"selectRetailer('"+data[i].retailerId+"','"+data[i].name+"','"+
                                data[i].telephone+"','"+data[i].address+"')\">"+data[i].name+"</p>";
                            jQuery("#retailerList").html(oldHtml+info);
                        }
                    }
                    jQuery(".retailerMask").css("display","block");
                },
                error: function (data) {
                    alert("通信异常！");
                }
            });
        }

        function searchCommodities() {
            addFruits(jQuery("#commoditiesName").val());
        }

        function checkAll(obj) {
            var isCheck = obj.checked;
            var checkList = document.getElementsByName("arrays");  // 获取所有check选项
            for (var i=0;i<checkList.length;i++) {
                checkList[i].checked = isCheck;
            }
        }

        function addFruits(name) {
            jQuery("#commoditiesList").html("");  // 清空div：commoditiesList
            var message = "";
            if (name!=null) {
                message = "{'name':'"+name+"'}";
            }
            $.ajax({
                type:'post',
                url:'${pageContext.request.contextPath}/contract/getAllCommodities.action',
                contentType:'application/json;charset=utf-8',
                data:message,
                success: function (data) {
                    if (data.length<1){
                        alert("没有找到数据。");
                    } else {
                        var tableHead = "<tr>"+"<td><input type='checkbox' onclick='checkAll(this)'></td>"+
                            "<td>名称</td><td>价格</td><td>产地</td>"+"</tr>";
                        jQuery("#commoditiesList").html(tableHead);
                        for (var i = 0; i < data.length; i++) {
                            var oldHtml = jQuery("#commoditiesList").html();
                            var info = "<tr>"+"<td><input type='checkbox' name='arrays' value='"+data[i].fruitId+"'></td>"+
                                "<td>"+data[i].name+"</td><td>"+data[i].price+"</td><td>"+data[i].locality+"</td>"+"</tr>";
                            jQuery("#commoditiesList").html(oldHtml + info);
                        }
                        // 添加table头和尾
                        jQuery("#commoditiesList").html("<table style='width: 375px; text-align: center;' border=1>"+
                            jQuery("#commoditiesList").html()+"</table>");
                    }
                    jQuery(".commoditiesMask").css("display","block");
                },
                error: function (data) {
                    alert("通信异常！");
                }
            });
        }

        function selectCommodities() {
            jQuery("#commodities_info").html("");  // 将原来信息清空
            var myArray = new Array();
            var len = 0;
            var arrays = document.getElementsByName("arrays");  // 获取所有check选项
            for (var i=0;i<arrays.length;i++) {
                if (arrays[i].checked) {
                    myArray[len++]=arrays[i].value;  // 将已选择项的fruitId写入myArray数组
                }
            }
            if (myArray.length<1) {
                jQuery(".commoditiesMask").css("display","none");
                return ;
            }
            $.ajax({
                type:'post',
                url:'${pageContext.request.contextPath}/contract/getCommoditiesAndAccessory.action',
                data:{'arrays':myArray},  // 数据为id数组
                traditional: true,
                success: function (data) {
                    if (data.length<1){
                        alert("没有找到数据。");
                    } else {
                        var tableHead = "<tr>"+"<td><font color='#E8BA36'>名称</font></td><td><font color='#E8BA36'>价格</font></td>"+
                            "<td><font color='#E8BA36'>产地</font></td><td><font color='#E8BA36'>附属品</font></td><td><font color='#E8BA36'>数量</font></td>"+"</tr>";
                        jQuery("#commodities_info").html(tableHead);
                        for (var i = 0; i < data.length; i++) {
                            var commodities = data[i].commodities; // 获取货物
                            var accessory = data[i].accessory;  // 获取该货物的附属品
                            var accessoryStr = "";  // 附属品列表为一个拼接字符串
                            for(var j=0;j<accessory.length;j++){
                                accessoryStr+=accessory[j].name+":"+accessory[j].price+"元";
                                if (j!=accessory.length-1) {
                                    accessoryStr+="<br/>";  // 不是最后一个就换行
                                }
                            }
                            accessoryStr=accessoryStr==""?"无":accessoryStr;
                            var oldHtml = jQuery("#commodities_info").html();
                            var info = "<tr>"+
                                "<td>"+commodities.name+"</td><td>"+commodities.price+"元/斤</td><td>"+commodities.locality+"</td><td>"+
                                accessoryStr+"</td><td><input type='number' min='0' style='width: 50px;' name='numberArrays' />斤</td>"+
                                "</tr><input type='hidden' name='commoditiesIdArrays' value='"+commodities.fruitId+"'/>";
                            jQuery("#commodities_info").html(oldHtml + info);
                        }
                        // 添加table头和尾
                        jQuery("#commodities_info").html("<table style='width: 510px; text-align: center;' border=1>"+
                            jQuery("#commodities_info").html()+"</table>");
                    }
                    jQuery(".commoditiesMask").css("display","none");  // 关闭弹窗
                    jQuery("#commodities_info").css("display","block");  // 显示所选择的货物、附属品信息
                },
                error: function (data) {
                    alert("通信异常！");
                }
            });
        }
    </script>
</head>
<body>
<div class="retailerMask">
    <div class="c">
        <div style="background-color: #173e65; height: 20px; color: #FFFFFF; font-size: 12px; padding-left: 7px;">
            零 售 商 信 息<font style="float: right; padding-right: 10px;" onclick="cancelEdit()">x</font>
        </div>
        <input id="retailerName" style="width: 20%;"/>
        <button class="btn" onclick="searchRetailer()">查询</button>
        <div id="retailerList" style="height: 180px; border: 5px solid #CCCCCC; overflow-y: scroll; margin: 10px;">
            <!-- 该区域放置查询到的用户信息 -->
        </div>
    </div>
</div>
<div class="commoditiesMask">
    <div class="c2">
        <div style="background-color: #173e65; height: 20px; color:#FFFFFF; font-size: 12px; padding-left: 7px;">
            水 果 列 表<font style="float: right; padding-right: 10px;" onclick="cancelEdit()">x</font>
        </div>
        <input id="commoditiesName" style="width: 20%;"/>
        <button class="btn" onclick="searchCommodities()">查询</button>
        <div id="commoditiesList" style="border: 2px solid #CCCCCC; height: 180px; overflow-y: scroll; margin: 10px;">
            <!-- 该区域展示查询到的所有水果货物信息 -->
        </div>
        <button class="btn" onclick="selectCommodities()">确定</button>
    </div>
</div>
<form action="${pageContext.request.contextPath}/contract/edit.action" method="post" onsubmit="checkEditContract()">
    <h2 style="text-align: center;">购销合同</h2>
    <div style="float: right; font-size: 10px;">
        创建日期：${contract.createTime}
    </div>
    合同编码：<b style="color: blue;">${contract.barCode}</b><br/>
    类型：
    <c:if test="${contract.type==1}">
        <select onchange="changeType()" id="indexType">
            <option value="1" selected="selected">省外</option>
            <option value="0">省内</option>
        </select>
        <input type="hidden" id="eType" name="type" value="1"/>
    </c:if>
    <c:if test="${contract.type==0}">
        <select onchange="changeType()" id="indexType">
            <option value="1">省外</option>
            <option value="0" selected="selected">省内</option>
        </select>
        <input type="hidden" id="eType" name="type" value="0"/>
    </c:if>
    <div class="info">
        -- 零售商信息 --<br/>
        <button type="button" class="btn btn-div" onclick="addRetailer(null)" style="float: right">重新选择</button><br/>
        <div id="retailer_info">
            <p id="retailer_name">姓名：${contract.retailer.name}</p>
            <p id="retailer_telephone">联系电话：${contract.retailer.telephone}</p>
            <p id="retailer_address">送货地址：${contract.retailer.address}</p>
            <input name="retailer.retailerId" id="eRetailerId" value="${contract.retailer.retailerId}" type="hidden"/>
        </div>
    </div><hr/>
    <div class="info">
        -- 货物信息 --<br/>
        <button type="button" class="btn btn-div" onclick="addFruits(null)" style="float: right">重新选择</button><br/>
        <div id="commodities_info">
            <!-- 展示拼接的货物信息HTML -->
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
    </div>
    <input name="contractId" value="${contract.contractId}" type="hidden"/>
    <input type="submit" value="提交" class="btn"/>
</form>
<c:if test="${resultMessage!=null}">
    <br/><font color="red">${resultMessage}</font>
    <br/><font color="green">关闭弹窗后，请刷新页面获取最新数据！</font>
</c:if>
</body>
</html>
