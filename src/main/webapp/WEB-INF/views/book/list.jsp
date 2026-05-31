<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>图书列表 - 书店销售管理系统</title>
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
                    <a href="/lms/sale/pos" class="list-group-item list-group-item-action">收银台</a>
                    <a href="/lms/sale/list" class="list-group-item list-group-item-action">销售记录</a>
                    <a href="/lms/member/list" class="list-group-item list-group-item-action">会员管理</a>
                    <a href="/lms/report/daily" class="list-group-item list-group-item-action">统计报表</a>
                    <c:if test="${sessionScope.role == 'ADMIN'}">
                        <a href="/lms/user/list" class="list-group-item list-group-item-action">用户管理</a>
                        <a href="/lms/config/list" class="list-group-item list-group-item-action">系统设置</a>
                    </c:if>
                </div>
            </div>
            <div class="col-md-10">
                <h3>图书列表</h3>

                <form method="get" action="/lms/book/list" class="row g-3 mb-3">
                    <div class="col-md-3">
                        <input type="text" name="name" class="form-control" placeholder="书名" value="${name}">
                    </div>
                    <div class="col-md-3">
                        <select name="categoryId" class="form-select">
                            <option value="">所有分类</option>
                            <c:forEach items="${categories}" var="cat">
                                <option value="${cat.categoryId}" ${cat.categoryId == categoryId ? 'selected' : ''}>${cat.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <input type="text" name="author" class="form-control" placeholder="作者" value="${author}">
                    </div>
                    <div class="col-md-2">
                        <input type="text" name="publisher" class="form-control" placeholder="出版社" value="${publisher}">
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary">查询</button>
                    </div>
                </form>

                <div class="mb-3">
                    <c:if test="${sessionScope.role == 'ADMIN'}">
                        <a href="/lms/book/add" class="btn btn-success">添加图书</a>
                    </c:if>
                </div>

                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>书名</th>
                            <th>作者</th>
                            <th>出版社</th>
                            <th>分类</th>
                            <th>原价</th>
                            <th>促销价</th>
                            <th>库存</th>
                            <th>状态</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${page.records}" var="book">
                            <tr>
                                <td>${book.bookId}</td>
                                <td>${book.name}</td>
                                <td>${book.author}</td>
                                <td>${book.publisher}</td>
                                <td>${book.categoryId}</td>
                                <td>¥${book.price}</td>
                                <td>${book.promotionPrice != null ? '¥'.concat(book.promotionPrice) : '-'}</td>
                                <td>-</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${book.status == 1}">在售</c:when>
                                        <c:when test="${book.status == 0}">下架</c:when>
                                        <c:when test="${book.status == 2}">缺货</c:when>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${sessionScope.role == 'ADMIN'}">
                                        <a href="/lms/book/edit/${book.bookId}" class="btn btn-sm btn-primary">编辑</a>
                                        <a href="/lms/book/delete/${book.bookId}" class="btn btn-sm btn-danger" onclick="return confirm('确定删除?')">删除</a>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <nav>
                    <ul class="pagination">
                        <li class="page-item ${page.current == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="?pageNum=${page.current - 1}&name=${name}&categoryId=${categoryId}&author=${author}&publisher=${publisher}">上一页</a>
                        </li>
                        <li class="page-item disabled">
                            <span class="page-link">第 ${page.current} / ${page.pages} 页</span>
                        </li>
                        <li class="page-item ${page.current >= page.pages ? 'disabled' : ''}">
                            <a class="page-link" href="?pageNum=${page.current + 1}&name=${name}&categoryId=${categoryId}&author=${author}&publisher=${publisher}">下一页</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>
</body>
</html>
