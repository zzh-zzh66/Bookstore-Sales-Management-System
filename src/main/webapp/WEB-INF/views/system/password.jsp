<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>修改密码</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h3>修改密码</h3>
        <form action="/lms/password/change" method="post" class="row g-3">
            <div class="col-md-6">
                <label class="form-label">原密码</label>
                <input type="password" name="oldPassword" class="form-control" required>
            </div>
            <div class="col-md-6">
                <label class="form-label">新密码</label>
                <input type="password" name="newPassword" class="form-control" required>
            </div>
            <div class="col-md-6">
                <label class="form-label">确认新密码</label>
                <input type="password" name="confirmPassword" class="form-control" required>
            </div>
            <div class="col-12">
                <button type="submit" class="btn btn-primary">修改</button>
                <a href="/lms/index" class="btn btn-secondary">取消</a>
            </div>
        </form>
    </div>
</body>
</html>
