<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${member != null ? '编辑' : '申请'}会员</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h3>${member != null ? '编辑' : '申请'}会员</h3>
        <form action="/lms/member/${member != null ? 'edit/'.concat(member.memberId) : 'add'}" method="post" class="row g-3">
            <div class="col-md-6">
                <label class="form-label">姓名</label>
                <input type="text" name="name" class="form-control" value="${member.name}" required>
            </div>
            <div class="col-md-6">
                <label class="form-label">手机号</label>
                <input type="text" name="phone" class="form-control" value="${member.phone}" required>
            </div>
            <div class="col-md-6">
                <label class="form-label">身份证号</label>
                <input type="text" name="idCard" class="form-control" value="${member.idCard}">
            </div>
            <div class="col-md-6">
                <label class="form-label">会员等级</label>
                <select name="levelId" class="form-select">
                    <c:forEach items="${levels}" var="level">
                        <option value="${level.levelId}" ${member.levelId == level.levelId ? 'selected' : ''}>
                            ${level.levelName} (${level.discountRate * 100}折)
                        </option>
                    </c:forEach>
                </select>
            </div>
            <c:if test="${member != null}">
                <div class="col-md-6">
                    <label class="form-label">累计消费</label>
                    <input type="text" class="form-control" value="${member.totalConsumption}" readonly>
                </div>
                <div class="col-md-6">
                    <label class="form-label">可用积分</label>
                    <input type="text" class="form-control" value="${member.availablePoints}" readonly>
                </div>
                <div class="col-md-6">
                    <label class="form-label">状态</label>
                    <select name="status" class="form-select">
                        <option value="1" ${member.status == '1' ? 'selected' : ''}>正常</option>
                        <option value="0" ${member.status == '0' ? 'selected' : ''}>冻结</option>
                        <option value="2" ${member.status == '2' ? 'selected' : ''}>已销户</option>
                    </select>
                </div>
            </c:if>
            <div class="col-12">
                <button type="submit" class="btn btn-primary">保存</button>
                <a href="/lms/member/list" class="btn btn-secondary">取消</a>
            </div>
        </form>
    </div>
</body>
</html>
