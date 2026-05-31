<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户管理 - 书店销售管理系统</title>
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
                    <a href="/lms/member/list" class="list-group-item list-group-item-action">会员管理</a>
                    <a href="/lms/report/daily" class="list-group-item list-group-item-action">统计报表</a>
                    <a href="/lms/user/list" class="list-group-item list-group-item-action active">用户管理</a>
                    <a href="/lms/config/list" class="list-group-item list-group-item-action">系统设置</a>
                </div>
            </div>
            <div class="col-md-10">
                <h3>用户管理</h3>

                <div class="mb-3">
                    <a href="/lms/user/add" class="btn btn-success">添加用户</a>
                </div>

                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>用户名</th>
                            <th>真实姓名</th>
                            <th>角色</th>
                            <th>部门</th>
                            <th>手机号</th>
                            <th>状态</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${page.records}" var="user">
                            <tr>
                                <td>${user.userId}</td>
                                <td>${user.username}</td>
                                <td>${user.realName}</td>
                                <td>${user.role}</td>
                                <td>${user.department}</td>
                                <td>${user.phone}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${user.status == 1}">启用</c:when>
                                        <c:when test="${user.status == 0}">禁用</c:when>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="/lms/user/edit/${user.userId}" class="btn btn-sm btn-primary">编辑</a>
                                    <a href="/lms/user/delete/${user.userId}" class="btn btn-sm btn-danger" onclick="return confirm('确定删除?')">删除</a>
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
