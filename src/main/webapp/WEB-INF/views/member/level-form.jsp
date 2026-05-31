<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${level != null ? '编辑' : '添加'}会员等级</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h3>${level != null ? '编辑' : '添加'}会员等级</h3>
        <form action="/lms/level/${level != null ? 'edit/'.concat(level.levelId) : 'add'}" method="post" class="row g-3">
            <div class="col-md-6">
                <label class="form-label">等级代码</label>
                <input type="text" name="levelCode" class="form-control" value="${level.levelCode}" required>
            </div>
            <div class="col-md-6">
                <label class="form-label">等级名称</label>
                <input type="text" name="levelName" class="form-control" value="${level.levelName}" required>
            </div>
            <div class="col-md-6">
                <label class="form-label">最低消费门槛</label>
                <input type="number" step="0.01" name="minConsumption" class="form-control" value="${level.minConsumption}" required>
            </div>
            <div class="col-md-6">
                <label class="form-label">最高消费门槛</label>
                <input type="number" step="0.01" name="maxConsumption" class="form-control" value="${level.maxConsumption}">
            </div>
            <div class="col-md-6">
                <label class="form-label">折扣率 (0.00-1.00)</label>
                <input type="number" step="0.01" name="discountRate" class="form-control" value="${level.discountRate}" required>
            </div>
            <div class="col-md-6">
                <label class="form-label">积分倍率</label>
                <input type="number" step="0.1" name="pointRate" class="form-control" value="${level.pointRate}" required>
            </div>
            <div class="col-12">
                <button type="submit" class="btn btn-primary">保存</button>
                <a href="/lms/level/list" class="btn btn-secondary">取消</a>
            </div>
        </form>
    </div>
</body>
</html>
