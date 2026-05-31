<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>首页 - 书店销售管理系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container-fluid">
            <a class="navbar-brand" href="/lms/index">书店销售管理系统</a>
            <div class="d-flex">
                <span class="navbar-text text-white me-3">
                    欢迎, ${sessionScope.username}
                </span>
                <a href="/lms/logout" class="btn btn-light btn-sm">退出</a>
            </div>
        </div>
    </nav>

    <div class="container-fluid mt-4">
        <div class="row">
            <div class="col-md-2">
                <div class="list-group">
                    <a href="/lms/index" class="list-group-item list-group-item-action active">首页</a>
                    <a href="/lms/book/list" class="list-group-item list-group-item-action">图书管理</a>
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
                <h3>数据概览</h3>
                <div class="row mt-4">
                    <div class="col-md-3">
                        <div class="card bg-primary text-white">
                            <div class="card-body">
                                <h5 class="card-title">今日订单</h5>
                                <h2>${todayOrderCount}</h2>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card bg-success text-white">
                            <div class="card-body">
                                <h5 class="card-title">今日销售额</h5>
                                <h2>¥${todaySales}</h2>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card bg-warning text-white">
                            <div class="card-body">
                                <h5 class="card-title">库存预警</h5>
                                <h2>${lowStockCount}</h2>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card bg-info text-white">
                            <div class="card-body">
                                <h5 class="card-title">图书总数</h5>
                                <h2>${totalBooks}</h2>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
