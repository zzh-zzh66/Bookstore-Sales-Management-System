<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>收银台 - 书店销售管理系统</title>
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
                    <a href="/lms/sale/pos" class="list-group-item list-group-item-action active">收银台</a>
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
                <h3>收银台</h3>

                <div class="row mt-4">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5>选择图书</h5>
                            </div>
                            <div class="card-body">
                                <form action="/lms/sale/create" method="post" id="saleForm">
                                    <div class="mb-3">
                                        <label class="form-label">选择图书</label>
                                        <select name="bookId" class="form-select" required>
                                            <option value="">请选择图书</option>
                                            <c:forEach items="${books}" var="book">
                                                <option value="${book.bookId}" data-price="${book.promotionPrice != null ? book.promotionPrice : book.price}">
                                                    ${book.name} - ¥${book.promotionPrice != null ? book.promotionPrice : book.price}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">数量</label>
                                        <input type="number" name="quantity" class="form-control" value="1" min="1" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">会员手机号（可选）</label>
                                        <input type="text" name="memberId" class="form-control" placeholder="输入会员手机号">
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">支付方式</label>
                                        <select name="paymentMethod" class="form-select">
                                            <option value="cash">现金</option>
                                            <option value="card">银行卡</option>
                                            <option value="wechat">微信支付</option>
                                            <option value="alipay">支付宝</option>
                                        </select>
                                    </div>
                                    <button type="submit" class="btn btn-success btn-lg w-100">确认收款</button>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5>操作说明</h5>
                            </div>
                            <div class="card-body">
                                <ol>
                                    <li>选择要销售的图书</li>
                                    <li>输入销售数量</li>
                                    <li>如有会员，可输入会员手机号享受折扣</li>
                                    <li>选择支付方式</li>
                                    <li>点击确认收款完成交易</li>
                                </ol>
                                <hr>
                                <h6>会员折扣说明：</h6>
                                <ul>
                                    <li>普通会员：无折扣</li>
                                    <li>银卡会员：95折</li>
                                    <li>金卡会员：90折</li>
                                    <li>钻石会员：85折</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
