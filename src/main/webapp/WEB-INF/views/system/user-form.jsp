<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${user != null ? '编辑' : '添加'}用户</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h3>${user != null ? '编辑' : '添加'}用户</h3>
        <form action="/lms/user/${user != null ? 'edit/'.concat(user.userId) : 'add'}" method="post" class="row g-3">
            <div class="col-md-6">
                <label class="form-label">用户名</label>
                <input type="text" name="username" class="form-control" value="${user.username}" required>
            </div>
            <div class="col-md-6">
                <label class="form-label">真实姓名</label>
                <input type="text" name="realName" class="form-control" value="${user.realName}">
            </div>
            <div class="col-md-6">
                <label class="form-label">手机号</label>
                <input type="text" name="phone" class="form-control" value="${user.phone}">
            </div>
            <div class="col-md-6">
                <label class="form-label">邮箱</label>
                <input type="email" name="email" class="form-control" value="${user.email}">
            </div>
            <div class="col-md-6">
                <label class="form-label">角色</label>
                <select name="role" class="form-select">
                    <option value="ADMIN" ${user.role == 'ADMIN' ? 'selected' : ''}>管理员</option>
                    <option value="SALES" ${user.role == 'SALES' ? 'selected' : ''}>销售员</option>
                </select>
            </div>
            <div class="col-md-6">
                <label class="form-label">部门</label>
                <input type="text" name="department" class="form-control" value="${user.department}">
            </div>
            <div class="col-md-6">
                <label class="form-label">状态</label>
                <select name="status" class="form-select">
                    <option value="1" ${user.status == 1 ? 'selected' : ''}>启用</option>
                    <option value="0" ${user.status == 0 ? 'selected' : ''}>禁用</option>
                </select>
            </div>
            <div class="col-12">
                <button type="submit" class="btn btn-primary">保存</button>
                <a href="/lms/user/list" class="btn btn-secondary">取消</a>
            </div>
        </form>
    </div>
</body>
</html>
