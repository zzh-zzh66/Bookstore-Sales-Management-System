<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>会员等级 - 书店销售管理系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container-fluid">
            <a class="navbar-brand" href="/lms/index">书店销售管理系统</a>
            <div class="d-flex">
                <span class="navbar-text text-white me-3">欢迎, ${sessionScope.username}</span>
                <a href="/lms/logout" class="btn btn-light btn-sm">退出</a>
            </div>
        </div>
    </nav>

    <div class="container-fluid mt-4">
        <div class="row">
            <div class="col-md-2">
                <div class="list-group">
                    <a href="/lms/index" class="list-group-item list-group-item-action">首页</a>
                    <a href="/lms/book/list" class="list-group-item list-group-item-action">图书管理</a>
                    <a href="/lms/sale/pos" class="list-group-item list-group-item-action">收银台</a>
                    <a href="/lms/sale/list" class="list-group-item list-group-item-action">销售记录</a>
                    <a href="/lms/member/list" class="list-group-item list-group-item-action active">会员管理</a>
                </div>
            </div>
            <div class="col-md-10">
                <h3>会员等级管理</h3>

                <div class="mb-3">
                    <c:if test="${sessionScope.role == 'ADMIN'}">
                        <a href="/lms/level/add" class="btn btn-success">添加等级</a>
                    </c:if>
                    <a href="/lms/member/list" class="btn btn-secondary">返回会员列表</a>
                </div>

                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>等级代码</th>
                            <th>等级名称</th>
                            <th>消费门槛</th>
                            <th>折扣率</th>
                            <th>积分倍率</th>
                            <th>状态</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${levels}" var="level">
                            <tr>
                                <td>${level.levelCode}</td>
                                <td>${level.levelName}</td>
                                <td>¥${level.minConsumption} - ${level.maxConsumption != null ? '¥'.concat(level.maxConsumption) : '无上限'}</td>
                                <td>${level.discountRate * 100}%</td>
                                <td>${level.pointRate}x</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${level.status == 1}">启用</c:when>
                                        <c:when test="${level.status == 0}">禁用</c:when>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${sessionScope.role == 'ADMIN'}">
                                        <a href="/lms/level/edit/${level.levelId}" class="btn btn-sm btn-primary">编辑</a>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
