<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>会员列表 - 书店销售管理系统</title>
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
                    <a href="/lms/report/daily" class="list-group-item list-group-item-action">统计报表</a>
                    <c:if test="${sessionScope.role == 'ADMIN'}">
                        <a href="/lms/user/list" class="list-group-item list-group-item-action">用户管理</a>
                        <a href="/lms/config/list" class="list-group-item list-group-item-action">系统设置</a>
                    </c:if>
                </div>
            </div>
            <div class="col-md-10">
                <h3>会员列表</h3>

                <div class="mb-3">
                    <a href="/lms/member/add" class="btn btn-success">申请会员</a>
                    <a href="/lms/level/list" class="btn btn-info">会员等级管理</a>
                </div>

                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>会员编号</th>
                            <th>姓名</th>
                            <th>手机号</th>
                            <th>等级</th>
                            <th>累计消费</th>
                            <th>可用积分</th>
                            <th>状态</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${page.records}" var="member">
                            <tr>
                                <td>${member.memberNo}</td>
                                <td>${member.name}</td>
                                <td>${member.phone}</td>
                                <td>${member.levelId}</td>
                                <td>¥${member.totalConsumption}</td>
                                <td>${member.availablePoints}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${member.status == '1'}">正常</c:when>
                                        <c:when test="${member.status == '0'}">冻结</c:when>
                                        <c:when test="${member.status == '2'}">已销户</c:when>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="/lms/member/edit/${member.memberId}" class="btn btn-sm btn-primary">编辑</a>
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
