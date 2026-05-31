<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>畅销书排行 - 书店销售管理系统</title>
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
                    <a href="/lms/report/daily" class="list-group-item list-group-item-action active">统计报表</a>
                </div>
            </div>
            <div class="col-md-10">
                <h3>畅销书排行</h3>

                <div class="btn-group mb-3">
                    <a href="/lms/report/daily" class="btn btn-outline-primary">日报</a>
                    <a href="/lms/report/monthly" class="btn btn-outline-primary">月报</a>
                    <a href="/lms/report/bestseller" class="btn btn-primary">畅销书</a>
                </div>

                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>排名</th>
                            <th>图书名称</th>
                            <th>销售数量</th>
                            <th>销售金额</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${stats}" var="stat" varStatus="loop">
                            <tr>
                                <td><strong>${loop.index + 1}</strong></td>
                                <td>${stat.book_name}</td>
                                <td>${stat.total_qty}</td>
                                <td>¥${stat.total_amount}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
