<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${book != null ? '编辑' : '添加'}图书</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h3>${book != null ? '编辑' : '添加'}图书</h3>
        <form action="/lms/book/${book != null ? 'edit/'.concat(book.bookId) : 'add'}" method="post" class="row g-3">
            <div class="col-md-6">
                <label class="form-label">ISBN</label>
                <input type="text" name="isbn" class="form-control" value="${book.isbn}" required>
            </div>
            <div class="col-md-6">
                <label class="form-label">书名</label>
                <input type="text" name="name" class="form-control" value="${book.name}" required>
            </div>
            <div class="col-md-6">
                <label class="form-label">作者</label>
                <input type="text" name="author" class="form-control" value="${book.author}">
            </div>
            <div class="col-md-6">
                <label class="form-label">出版社</label>
                <input type="text" name="publisher" class="form-control" value="${book.publisher}">
            </div>
            <div class="col-md-6">
                <label class="form-label">分类</label>
                <select name="categoryId" class="form-select">
                    <option value="">请选择</option>
                    <c:forEach items="${categories}" var="cat">
                        <option value="${cat.categoryId}" ${book.categoryId == cat.categoryId ? 'selected' : ''}>${cat.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-6">
                <label class="form-label">价格</label>
                <input type="number" step="0.01" name="price" class="form-control" value="${book.price}" required>
            </div>
            <div class="col-md-6">
                <label class="form-label">促销价</label>
                <input type="number" step="0.01" name="promotionPrice" class="form-control" value="${book.promotionPrice}">
            </div>
            <div class="col-md-6">
                <label class="form-label">状态</label>
                <select name="status" class="form-select">
                    <option value="1" ${book.status == 1 ? 'selected' : ''}>在售</option>
                    <option value="0" ${book.status == 0 ? 'selected' : ''}>下架</option>
                    <option value="2" ${book.status == 2 ? 'selected' : ''}>缺货</option>
                </select>
            </div>
            <c:if test="${book == null}">
                <div class="col-md-6">
                    <label class="form-label">初始库存</label>
                    <input type="number" name="initialStock" class="form-control" value="0">
                </div>
            </c:if>
            <div class="col-12">
                <button type="submit" class="btn btn-primary">保存</button>
                <a href="/lms/book/list" class="btn btn-secondary">取消</a>
            </div>
        </form>
    </div>
</body>
</html>
