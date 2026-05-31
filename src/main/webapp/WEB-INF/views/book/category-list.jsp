<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>分类管理 - 书店销售管理系统</title>
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
                    <a href="/lms/book/list" class="list-group-item list-group-item-action active">图书管理</a>
                </div>
            </div>
            <div class="col-md-10">
                <h3>图书分类管理</h3>

                <div class="mb-3">
                    <a href="/lms/book/list" class="btn btn-secondary">返回图书列表</a>
                </div>

                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>分类名称</th>
                            <th>父分类</th>
                            <th>层级</th>
                            <th>状态</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${categories}" var="cat">
                            <tr>
                                <td>${cat.categoryId}</td>
                                <td>${cat.name}</td>
                                <td>${cat.parentId != null ? cat.parentId : '无'}</td>
                                <td>${cat.level}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${cat.status == 1}">启用</c:when>
                                        <c:when test="${cat.status == 0}">禁用</c:when>
                                    </c:choose>
                                </td>
                                <td>
                                    <button class="btn btn-sm btn-primary" onclick="editCategory('${cat.categoryId}', '${cat.name}')">编辑</button>
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
