<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>日报统计 - 书店销售管理系统</title>
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
                <h3>统计报表</h3>

                <div class="btn-group mb-3">
                    <a href="/lms/report/daily" class="btn btn-primary">日报</a>
                    <a href="/lms/report/monthly" class="btn btn-outline-primary">月报</a>
                    <a href="/lms/report/bestseller" class="btn btn-outline-primary">畅销书</a>
                </div>

                <div class="card mb-3">
                    <div class="card-body">
                        <form method="get" action="/lms/report/daily" class="row g-3">
                            <div class="col-md-4">
                                <input type="date" name="date" class="form-control" value="${date}">
                            </div>
                            <div class="col-md-4">
                                <button type="submit" class="btn btn-primary">查询</button>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-4">
                        <div class="card bg-primary text-white">
                            <div class="card-body">
                                <h5>订单数</h5>
                                <h2>${orderCount}</h2>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card bg-success text-white">
                            <div class="card-body">
                                <h5>销售总额</h5>
                                <h2>¥${totalAmount}</h2>
                            </div>
                        </div>
                    </div>
                </div>

                <h4>销售明细</h4>
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>订单号</th>
                            <th>时间</th>
                            <th>会员</th>
                            <th>实付金额</th>
                            <th>支付方式</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${orders}" var="order">
                            <tr>
                                <td>${order.orderNo}</td>
                                <td>${order.saleTime}</td>
                                <td>${order.memberId != null ? order.memberId : '散客'}</td>
                                <td>¥${order.paidAmount}</td>
                                <td>${order.paymentMethod}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
