<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>设置促销价格</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h3>设置促销价格</h3>
        <form action="/lms/promotion/set/${book.bookId}" method="post" class="row g-3">
            <div class="col-md-6">
                <label class="form-label">书名</label>
                <input type="text" class="form-control" value="${book.name}" readonly>
            </div>
            <div class="col-md-6">
                <label class="form-label">原价</label>
                <input type="text" class="form-control" value="¥${book.price}" readonly>
            </div>
            <div class="col-md-6">
                <label class="form-label">促销价格</label>
                <input type="number" step="0.01" name="promotionPrice" class="form-control" value="${book.promotionPrice}" required>
            </div>
            <div class="col-12">
                <button type="submit" class="btn btn-primary">保存</button>
                <a href="/lms/promotion/list" class="btn btn-secondary">取消</a>
            </div>
        </form>
    </div>
</body>
</html>
