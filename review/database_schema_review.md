# 数据库Schema审查报告

> 本文档供后端开发专家参考，旨在避免命名冲突和结构对应问题
>
> 数据库版本：MySQL 8.0+
> 审查时间：2026-05-31

---

## 1. 命名规范总览

### 1.1 表名规范 ✅

| 表名 | 说明 | 规范符合 |
|------|------|----------|
| `book_category` | 图书分类表 | ✅ snake_case |
| `book` | 图书信息表 | ✅ snake_case |
| `member_level` | 会员等级表 | ✅ snake_case |
| `member` | 会员表 | ✅ snake_case |
| **`user`** | 系统用户表 | ⚠️ **USER是SQL保留字** |
| `inventory` | 库存表 | ✅ snake_case |
| `sale_order` | 销售订单表 | ✅ snake_case |
| `sale_order_item` | 销售订单明细表 | ✅ snake_case |
| `system_config` | 系统参数配置表 | ✅ snake_case |
| `promotion_log` | 促销价格变更日志表 | ✅ snake_case |

### 1.2 字段命名规范 ✅

- 主键统一使用 `{table_singular}_id` 格式，如 `book_id`、`member_id`
- 外键统一使用 `{referenced_table_singular}_id` 格式
- 时间字段统一使用 `created_at`、`updated_at`、`{action}_at` 格式
- 状态字段统一使用 `status`
- 金额字段统一使用 `*_amount` 格式

---

## 2. ⚠️ 重点关注问题

### 2.1 `user` 表名冲突风险

**问题**：`user` 是 MySQL 保留字（`CREATE USER` 等语句），可能导致以下问题：
- ORM框架（如MyBatis、Hibernate）映射困难
- SQL编写时需要加反引号包裹
- 某些数据库工具可能报错

**建议方案**：
```sql
-- 方案A：重命名为 sys_user 或 system_user
-- 方案B：保持 user 但后端代码中始终使用反引号 `user`
```

### 2.2 `inventory` 表缺少创建时间

**问题**：`inventory` 表只有 `updated_at`，缺少 `created_at`

```sql
-- 当前结构
`updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP

-- 建议添加
`created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
```

### 2.3 `sale_order` 的 `user_id` 外键约束

**问题**：订单表通过 `user_id` 关联销售人员，约束为 `ON DELETE RESTRICT`

```sql
CONSTRAINT `fk_order_user` FOREIGN KEY (`user_id`)
    REFERENCES `user` (`user_id`) ON DELETE RESTRICT
```

**影响**：删除用户时，如果该用户有历史订单，将无法删除（会报外键冲突）

**建议**：
- 如果业务允许用户离职后仍保留订单记录，保持 RESTRICT 即可
- 如果需要软删除用户，建议增加 `user` 表的 `status` 字段，用状态控制而非物理删除

---

## 3. 表结构详细分析

### 3.1 核心业务表映射关系

```
┌─────────────────┐     ┌─────────────────┐
│  book_category  │────<│      book       │
│   (分类表)        │     │    (图书表)      │
└─────────────────┘     └────────┬────────┘
                                 │
                    ┌────────────┼────────────┐
                    ▼            ▼            ▼
             ┌──────────┐ ┌──────────┐ ┌──────────┐
             │ member   │ │sale_order│ │inventory │
             │ (会员表)  │ │(订单主表) │ │ (库存表)  │
             └────┬─────┘ └────┬─────┘ └──────────┘
                  │            │
                  │            ▼
                  │     ┌──────────────┐
                  └────>│sale_order_item│
                        │  (订单明细表)   │
                        └──────────────┘
```

### 3.2 各表关键字段对照

#### `book` (图书表)

| 字段名 | 类型 | 说明 | 后端对应 |
|--------|------|------|----------|
| `book_id` | BIGINT | 主键 | Long id |
| `isbn` | VARCHAR(20) | ISBN，唯一 | String isbn |
| `name` | VARCHAR(100) | 图书名称 | String name |
| `author` | VARCHAR(100) | 作者 | String author |
| `publisher` | VARCHAR(100) | 出版社 | String publisher |
| `category_id` | BIGINT | 分类ID，外键 | Long categoryId |
| `price` | DECIMAL(10,2) | 原价 | BigDecimal price |
| `promotion_price` | DECIMAL(10,2) | 促销价 | BigDecimal promotionPrice |
| `status` | TINYINT | 状态 | Integer status |

#### `member` (会员表)

| 字段名 | 类型 | 说明 | 后端对应 |
|--------|------|------|----------|
| `member_id` | BIGINT | 主键 | Long id |
| `member_no` | VARCHAR(20) | 会员编号，唯一 | String memberNo |
| `phone` | VARCHAR(20) | 手机号，唯一 | String phone |
| `level_id` | BIGINT | 等级ID，外键 | Long levelId |
| `total_consumption` | DECIMAL(12,2) | 累计消费 | BigDecimal totalConsumption |
| `total_points` | INT | 累计积分 | Integer totalPoints |
| `available_points` | INT | 可用积分 | Integer availablePoints |
| `status` | TINYINT | 状态：1正常/0冻结/2销户 | Integer status |

#### `sale_order` (订单主表)

| 字段名 | 类型 | 说明 | 后端对应 |
|--------|------|------|----------|
| `order_id` | BIGINT | 主键 | Long id |
| `order_no` | VARCHAR(32) | 订单编号，唯一 | String orderNo |
| `member_id` | BIGINT | 会员ID，可为空 | Long memberId |
| `user_id` | BIGINT | 操作员ID | Long userId |
| `total_amount` | DECIMAL(12,2) | 标价总额 | BigDecimal totalAmount |
| `discount_amount` | DECIMAL(12,2) | 优惠金额 | BigDecimal discountAmount |
| `payable_amount` | DECIMAL(12,2) | 应付金额 | BigDecimal payableAmount |
| `paid_amount` | DECIMAL(12,2) | 实付金额 | BigDecimal paidAmount |
| `points_discount` | DECIMAL(12,2) | 积分抵扣 | BigDecimal pointsDiscount |
| `points_earned` | INT | 获得积分 | Integer pointsEarned |
| `payment_method` | VARCHAR(20) | 支付方式 | String paymentMethod |

#### `sale_order_item` (订单明细表)

| 字段名 | 类型 | 说明 | 后端对应 |
|--------|------|------|----------|
| `item_id` | BIGINT | 主键 | Long id |
| `order_id` | BIGINT | 订单ID，外键 | Long orderId |
| `book_id` | BIGINT | 图书ID，外键 | Long bookId |
| `book_name` | VARCHAR(100) | 图书名称(冗余) | String bookName |
| `isbn` | VARCHAR(20) | ISBN(冗余) | String isbn |
| `quantity` | INT | 销售数量 | Integer quantity |
| `unit_price` | DECIMAL(10,2) | 成交单价 | BigDecimal unitPrice |
| `original_price` | DECIMAL(10,2) | 原价 | BigDecimal originalPrice |
| `discount_rate` | DECIMAL(4,2) | 折扣率 | BigDecimal discountRate |
| `subtotal` | DECIMAL(12,2) | 小计金额 | BigDecimal subtotal |

> **注意**：`book_name` 和 `isbn` 在订单明细中冗余存储，作为订单快照，订单创建后不再受图书表变更影响

#### `inventory` (库存表)

| 字段名 | 类型 | 说明 | 后端对应 |
|--------|------|------|----------|
| `inventory_id` | BIGINT | 主键 | Long id |
| `book_id` | BIGINT | 图书ID，唯一 | Long bookId |
| `quantity` | INT | 当前库存 | Integer quantity |
| `reserved_qty` | INT | 预留数量 | Integer reservedQty |
| `sold_qty` | INT | 累计已售 | Integer soldQty |

#### `member_level` (会员等级表)

| 字段名 | 类型 | 说明 | 后端对应 |
|--------|------|------|----------|
| `level_id` | BIGINT | 主键 | Long id |
| `level_name` | VARCHAR(30) | 等级名称 | String levelName |
| `level_code` | VARCHAR(20) | 等级代码，唯一 | String levelCode |
| `min_consumption` | DECIMAL(12,2) | 最低消费门槛 | BigDecimal minConsumption |
| `max_consumption` | DECIMAL(12,2) | 最高消费门槛 | BigDecimal maxConsumption |
| `discount_rate` | DECIMAL(4,2) | 折扣率 | BigDecimal discountRate |
| `point_rate` | DECIMAL(4,2) | 积分倍率 | BigDecimal pointRate |
| `privileges` | TEXT | 特权JSON | String privileges (JSON) |

---

## 4. 枚举值参考

### 4.1 book.status

| 值 | 含义 |
|----|------|
| 1 | 在售 |
| 0 | 下架 |
| 2 | 缺货 |

### 4.2 member.status

| 值 | 含义 |
|----|------|
| 1 | 正常 |
| 0 | 冻结 |
| 2 | 已销户 |

### 4.3 user.role

| 值 | 含义 |
|----|------|
| ADMIN | 管理员 |
| SALES | 销售人员 |

### 4.4 sale_order.payment_method

| 值 | 含义 |
|----|------|
| cash | 现金 |
| card | 银行卡 |
| wechat | 微信支付 |
| alipay | 支付宝 |

### 4.5 sale_order.order_status

| 值 | 含义 |
|----|------|
| 1 | 已完成 |
| 2 | 已取消 |
| 3 | 退款 |

### 4.6 book_category.status

| 值 | 含义 |
|----|------|
| 1 | 启用 |
| 0 | 禁用 |

### 4.7 member_level.status

| 值 | 含义 |
|----|------|
| 1 | 启用 |
| 0 | 禁用 |

---

## 5. 索引设计汇总

| 表名 | 索引名 | 索引字段 | 类型 |
|------|--------|----------|------|
| book_category | idx_category_parent | parent_id | 普通 |
| book_category | idx_category_status | status | 普通 |
| book_category | idx_category_path | path | 普通 |
| book | uk_book_isbn | isbn | 唯一 |
| book | idx_book_name | name | 普通 |
| book | idx_book_author | author | 普通 |
| book | idx_book_publisher | publisher | 普通 |
| book | idx_book_category | category_id | 普通 |
| book | idx_book_status | status | 普通 |
| book | idx_book_created | created_at | 普通 |
| book | ft_book_search | name,author,publisher | 全文 |
| member_level | uk_level_code | level_code | 唯一 |
| member_level | idx_level_status | status | 普通 |
| member_level | idx_level_consumption | min_consumption | 普通 |
| member | uk_member_no | member_no | 唯一 |
| member | uk_member_phone | phone | 唯一 |
| member | uk_member_idcard | id_card | 唯一 |
| member | idx_member_name | name | 普通 |
| member | idx_member_level | level_id | 普通 |
| member | idx_member_status | status | 普通 |
| member | idx_member_consumption | total_consumption | 普通 |
| user | uk_user_username | username | 唯一 |
| user | uk_user_phone | phone | 唯一 |
| user | idx_user_role | role | 普通 |
| user | idx_user_status | status | 普通 |
| inventory | uk_inventory_book | book_id | 唯一 |
| inventory | idx_inventory_low | quantity | 普通 |
| sale_order | uk_order_no | order_no | 唯一 |
| sale_order | idx_order_member | member_id | 普通 |
| sale_order | idx_order_user | user_id | 普通 |
| sale_order | idx_order_date | sale_date | 普通 |
| sale_order | idx_order_status | order_status | 普通 |
| sale_order | idx_order_time | sale_time | 普通 |
| sale_order | idx_order_invoice | invoice_no | 普通 |
| sale_order_item | idx_item_order | order_id | 普通 |
| sale_order_item | idx_item_book | book_id | 普通 |
| system_config | uk_config_key | config_key | 唯一 |
| system_config | idx_config_group | config_group | 普通 |
| system_config | idx_config_status | status | 普通 |
| promotion_log | idx_promotion_book | book_id | 普通 |
| promotion_log | idx_promotion_time | created_at | 普通 |
| promotion_log | idx_promotion_period | start_time, end_time | 普通 |

---

## 6. 建议后端开发关注点

### 6.1 事务处理
- 订单创建涉及 `sale_order`、`sale_order_item`、`inventory`、`member` 多表更新，需要使用事务
- 建议使用 `@Transactional` 注解，确保原子性

### 6.2 库存扣减
- `inventory.quantity` 扣减需要考虑并发问题
- 建议使用乐观锁（版本号）或悲观锁（`SELECT FOR UPDATE`）

### 6.3 会员等级计算
- 会员消费后需要判断是否升级/降级
- 建议在订单完成后触发等级重新计算

### 6.4 JSON字段处理
- `member_level.privileges` 存储为TEXT的JSON，后端需要序列化/反序列化
- 建议使用Jackson的 `@JsonField` 或类似注解

### 6.5 金额计算
- 所有金额字段使用 `BigDecimal`，避免浮点精度问题
- 计算时注意使用 `setScale(2, RoundingMode.HALF_UP)`

### 6.6 日期时间处理
- 数据库使用 `DATETIME` 存储时间，后端建议统一使用 `LocalDateTime`
- 注意时区转换问题

---

## 7. 遗留问题

- [ ] `user` 表名是否为保留字需要确认，建议与后端框架团队确认
- [ ] `inventory` 表缺少 `created_at` 字段，建议补充
- [ ] `sale_order.user_id` 的 RESTRICT 删除策略需要业务确认

---

## 8. 修改历史

| 日期 | 版本 | 修改内容 | 修改人 |
|------|------|----------|--------|
| 2026-05-31 | 1.0 | 初始审查报告 | AI Assistant |

---

## 9. 修复状态跟踪 (2026-05-31 更新)

### 9.1 已修复问题

| 问题 | 修复方案 | 修复日期 |
|------|----------|----------|
| `user` 表名与MySQL保留字冲突 | 已重命名为 `system_user`，并更新所有相关外键引用和INSERT语句 | 2026-05-31 |
| `inventory` 表缺少 `created_at` 字段 | 已添加 `created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'` | 2026-05-31 |

### 9.2 当前表名规范（修复后）

| 旧表名 | 新表名 | 说明 |
|--------|--------|------|
| `user` | `system_user` | 系统用户表 |

### 9.3 外键引用更新（修复后）

| 表名 | 外键字段 | 引用目标 | 状态 |
|------|----------|----------|------|
| `sale_order` | `user_id` | `system_user.user_id` | ✅ 已更新 |
| `promotion_log` | `user_id` | `system_user.user_id` | ✅ 已更新 |
| `book_category` | `parent_id` | `book_category.category_id` | ✅ 无需修改 |
| `book` | `category_id` | `book_category.category_id` | ✅ 无需修改 |
| `member` | `level_id` | `member_level.level_id` | ✅ 无需修改 |
| `inventory` | `book_id` | `book.book_id` | ✅ 无需修改 |
| `sale_order` | `member_id` | `member.member_id` | ✅ 无需修改 |
| `sale_order_item` | `order_id` | `sale_order.order_id` | ✅ 无需修改 |
| `sale_order_item` | `book_id` | `book.book_id` | ✅ 无需修改 |
| `promotion_log` | `book_id` | `book.book_id` | ✅ 无需修改 |

### 9.4 inventory表结构（修复后）

```sql
CREATE TABLE `inventory` (
    `inventory_id`  BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '库存记录ID',
    `book_id`       BIGINT          NOT NULL                    COMMENT '图书ID',
    `quantity`      INT             NOT NULL    DEFAULT 0       COMMENT '当前库存数量',
    `reserved_qty`  INT             NOT NULL    DEFAULT 0       COMMENT '预留数量（已下单未出库）',
    `sold_qty`      INT             NOT NULL    DEFAULT 0       COMMENT '累计已售数量',
    `created_at`    DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',  -- ✅ 新增
    `updated_at`    DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

    PRIMARY KEY (`inventory_id`),
    UNIQUE KEY `uk_inventory_book` (`book_id`),
    INDEX `idx_inventory_low` (`quantity`),

    CONSTRAINT `fk_inventory_book` FOREIGN KEY (`book_id`)
        REFERENCES `book` (`book_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='库存表';
```

### 9.5 system_user表结构（修复后）

```sql
CREATE TABLE `system_user` (  -- ✅ 表名已修改
    `user_id`       BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '用户ID',
    `username`      VARCHAR(50)     NOT NULL                    COMMENT '用户名（登录账号）',
    `password`      VARCHAR(255)    NOT NULL                    COMMENT '密码（BCrypt加密）',
    `real_name`     VARCHAR(50)     DEFAULT NULL                COMMENT '真实姓名',
    `phone`         VARCHAR(20)     DEFAULT NULL                COMMENT '手机号',
    `email`         VARCHAR(100)    DEFAULT NULL                COMMENT '邮箱',
    `role`          VARCHAR(20)     NOT NULL                    COMMENT '角色：ADMIN/SALES',
    `department`    VARCHAR(50)     DEFAULT NULL                COMMENT '所属部门',
    `status`        TINYINT         NOT NULL    DEFAULT 1       COMMENT '状态：1=启用，0=禁用',
    `last_login_time` DATETIME      DEFAULT NULL                COMMENT '最后登录时间',
    `last_login_ip`   VARCHAR(50)   DEFAULT NULL                COMMENT '最后登录IP',
    `login_count`   INT             NOT NULL    DEFAULT 0       COMMENT '登录次数',
    `password_changed_at` DATETIME  DEFAULT NULL                COMMENT '密码最后修改时间',
    `created_at`    DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`    DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

    PRIMARY KEY (`user_id`),
    UNIQUE KEY `uk_user_username` (`username`),
    UNIQUE KEY `uk_user_phone` (`phone`),
    INDEX `idx_user_role` (`role`),
    INDEX `idx_user_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统用户表';
```

### 9.6 后端开发注意事项（更新）

⚠️ **重要变更提醒**：

1. **实体类命名变更**：`User` 实体类应更名为 `SystemUser` 或 `SysUser`，避免与框架的 `User` 类冲突
2. **Mapper/DAO层**：所有涉及 `user` 表的查询需要更新表名为 `system_user`
3. **外键关联**：订单表 `sale_order.user_id` 和促销日志表 `promotion_log.user_id` 关联的是 `system_user.user_id`

---

## 10. 遗留问题（修复后状态）

- [x] `user` 表名重命名为 `system_user` ✅ 已修复
- [x] `inventory` 表添加 `created_at` 字段 ✅ 已修复
- [ ] `sale_order.user_id` 的 RESTRICT 删除策略需要业务确认（建议保持现状，使用软删除）
