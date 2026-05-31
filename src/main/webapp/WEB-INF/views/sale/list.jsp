<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>销售记录 - 书店销售管理系统</title>
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
                    <a href="/lms/sale/list" class="list-group-item list-group-item-action active">销售记录</a>
                    <a href="/lms/member/list" class="list-group-item list-group-item-action">会员管理</a>
                    <a href="/lms/report/daily" class="list-group-item list-group-item-action">统计报表</a>
                </div>
            </div>
            <div class="col-md-10">
                <h3>销售记录</h3>

                <form method="get" action="/lms/sale/list" class="row g-3 mb-3">
                    <div class="col-md-4">
                        <input type="date" name="startDate" class="form-control" value="${startDate}">
                    </div>
                    <div class="col-md-4">
                        <input type="date" name="endDate" class="form-control" value="${endDate}">
                    </div>
                    <div class="col-md-4">
                        <button type="submit" class="btn btn-primary">查询</button>
                    </div>
                </form>

                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>订单号</th>
                            <th>销售时间</th>
                            <th>会员ID</th>
                            <th>总金额</th>
                            <th>实付金额</th>
                            <th>支付方式</th>
                            <th>获得积分</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${page.records}" var="order">
                            <tr>
                                <td>${order.orderNo}</td>
                                <td>${order.saleTime}</td>
                                <td>${order.memberId != null ? order.memberId : '-'}</td>
                                <td>¥${order.totalAmount}</td>
                                <td>¥${order.paidAmount}</td>
                                <td>${order.paymentMethod}</td>
                                <td>${order.pointsEarned}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <nav>
                    <ul class="pagination">
                        <li class="page-item ${page.current == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="?pageNum=${page.current - 1}&startDate=${startDate}&endDate=${endDate}">上一页</a>
                        </li>
                        <li class="page-item disabled">
                            <span class="page-link">第 ${page.current} / ${page.pages} 页</span>
                        </li>
                        <li class="page-item ${page.current >= page.pages ? 'disabled' : ''}">
                            <a class="page-link" href="?pageNum=${page.current + 1}&startDate=${startDate}&endDate=${endDate}">下一页</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>
</body>
</html>
