# 书店销售管理系统 (Bookstore LMS)

基于 Spring Boot + MyBatis-Plus + JSP 的书店销售管理系统

## 技术栈

- **后端框架**: Spring Boot 2.7
- **ORM框架**: MyBatis-Plus 3.5
- **安全框架**: Spring Security
- **视图模板**: JSP + Bootstrap 5
- **数据库**: MySQL 8.0

## 项目结构

```
bookstore-lms/
├── src/main/java/com/bookstore/
│   ├── config/          # 配置类
│   ├── controller/      # 控制器
│   ├── service/         # 服务层
│   ├── mapper/          # 数据访问层
│   ├── entity/          # 实体类
│   ├── dto/             # 数据传输对象
│   ├── common/          # 通用类
│   └── BookstoreApplication.java  # 启动类
│
├── src/main/resources/
│   ├── mapper/          # MyBatis XML映射文件
│   └── application.yml  # 配置文件
│
├── src/main/webapp/
│   └── WEB-INF/views/   # JSP页面
│       ├── login.jsp
│       ├── index.jsp
│       ├── book/
│       ├── sale/
│       ├── member/
│       ├── report/
│       └── system/
│
├── db/
│   ├── lms_schema.sql   # 数据库结构
│   ├── lms_data.sql     # 测试数据
│   └── reset_password.sql # 密码重置脚本
│
└── pom.xml
```

## 环境要求

- JDK 1.8+
- MySQL 8.0+
- Maven 3.8+

## 数据库配置

1. 创建数据库：
```sql
CREATE DATABASE bookstore_lms CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

2. 执行数据库脚本：
```bash
mysql -u root -p bookstore_lms < db/lms_schema.sql
mysql -u root -p bookstore_lms < db/lms_data.sql
mysql -u root -p bookstore_lms < db/reset_password.sql
```

3. 修改配置文件 `src/main/resources/application.yml`：
```yaml
spring:
  datasource:
    password: 你的MySQL密码
```

## 运行项目

1. 进入项目目录：
```bash
cd bookstore-lms
```

2. 使用 Maven 运行：
```bash
mvn spring-boot:run
```

3. 访问系统：
- 访问地址: http://localhost:8080/lms
- 登录页面: http://localhost:8080/lms/login

## 测试账号

| 用户名 | 密码 | 角色 | 说明 |
|--------|------|------|------|
| admin | 123456 | ADMIN | 管理员（拥有所有权限） |
| seller01 | 123456 | SALES | 销售员 |

## 功能模块

### 1. 首页仪表盘
- 今日订单数
- 今日销售额
- 库存预警
- 图书总数

### 2. 图书管理
- 图书列表（支持多条件查询）
- 添加图书（自动初始化库存）
- 编辑图书
- 删除图书
- 分类管理

### 3. 销售管理
- 收银台（销售下单）
- 销售记录查询
- 促销价格管理

### 4. 会员管理
- 会员列表
- 申请会员
- 编辑会员
- 会员等级管理

### 5. 统计报表
- 日报统计
- 月报统计
- 畅销书排行

### 6. 系统管理（仅管理员）
- 用户管理
- 系统参数设置
- 修改密码

## 权限说明

### 管理员 (ADMIN)
拥有所有功能权限：
- 图书管理（增删改查）
- 销售管理
- 会员管理
- 统计报表
- 系统管理

### 销售员 (SALES)
受限功能权限：
- 图书管理（只读）
- 销售管理
- 会员管理
- 统计报表
- 无系统管理权限

## 数据库表说明

| 表名 | 说明 |
|------|------|
| book | 图书信息表 |
| book_category | 图书分类表 |
| inventory | 库存表 |
| sale_order | 销售订单表 |
| sale_order_item | 订单明细表 |
| member | 会员表 |
| member_level | 会员等级表 |
| system_user | 系统用户表 |
| system_config | 系统配置表 |
| promotion_log | 促销日志表 |

## 业务说明

### 销售下单流程
1. 选择图书 → 2. 输入数量 → 3. 会员折扣（如有） → 4. 选择支付方式 → 5. 确认收款 → 6. 生成订单 → 7. 扣减库存 → 8. 更新会员积分

### 会员等级折扣
- 普通会员：无折扣
- 银卡会员：95折
- 金卡会员：90折
- 钻石会员：85折

### 促销价格
- 管理员可设置图书促销价
- 促销价优先于原价
- 会员折扣在促销价基础上计算

## 注意事项

1. **数据库密码**: 请确保修改 `application.yml` 中的数据库密码
2. **初始密码**: 所有测试用户密码为 `123456`
3. **库存管理**: 图书入库时自动初始化库存
4. **事务处理**: 销售下单使用事务保证数据一致性

## 开发说明

### 添加新功能
1. 在 `entity` 包中创建实体类
2. 在 `mapper` 包中创建 Mapper 接口
3. 在 `service` 包中创建 Service 接口和实现
4. 在 `controller` 包中创建 Controller
5. 在 `views` 目录下创建 JSP 页面

### 代码规范
- 类名：大驼峰（BookController）
- 方法名：小驼峰（getBookById）
- 数据库表：snake_case
- 字段：snake_case → camelCase

## 联系方式

如有问题，请检查：
1. 数据库是否正常运行
2. 数据库密码是否正确
3. 端口 8080 是否被占用

登录页 http://localhost:8080/lms/login 
首页 http://localhost:8080/lms/index
