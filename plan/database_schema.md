# 书店销售管理系统 - 数据库设计文档

---

## 一、设计概述

### 1.1 设计目标
本文档详细描述书店销售管理系统（Library Management System）的数据库逻辑模型与物理实现。设计遵循 **第三范式（3NF）** 要求，消除数据冗余，保障数据完整性与一致性，并为系统提供良好的可扩展性支撑。

### 1.2 命名规范

| 对象类型 | 命名规范 | 示例 |
|----------|----------|------|
| 数据库 | 小写下划线 | `bookstore_lms` |
| 表名 | 小写下划线，单数名词 | `book`, `sale_order` |
| 字段名 | 小写下划线 | `book_id`, `sale_date` |
| 主键 | `{table}_id` | `book_id`, `order_id` |
| 外键 | `{ref_table}_id` | `category_id`, `book_id` |
| 索引 | `idx_{table}_{column}` | `idx_book_name`, `idx_sale_date` |
| 唯一约束 | `uk_{table}_{column}` | `uk_user_username` |

### 1.3 数据类型选择原则
- **字符型**：定长用 `CHAR`，变长且有明确长度用 `VARCHAR`，大文本用 `TEXT`
- **数值型**：整型优先 `INT`，金额用 `DECIMAL(10,2)`，自增主键用 `BIGINT`
- **日期型**：精确到日期用 `DATE`，精确到时间用 `DATETIME`
- **状态标志**：使用 `TINYINT` 或 `ENUM`

---

## 二、E-R 实体关系图

```
┌─────────────────┐       ┌─────────────────┐       ┌─────────────────┐
│ book_category   │       │      book       │       │    inventory    │
│─────────────────│       │─────────────────│       │─────────────────│
│ PK category_id  │──┐    │ PK book_id      │──┐    │ PK inventory_id │
│    name         │  │    │ FK category_id  │  │    │ FK book_id      │◄─┘
│    description  │  └───►│    isbn         │  │    │    quantity     │
│    parent_id    │       │    name         │  │    │    updated_at   │
│    sort_order   │       │    author       │◄─┘    └─────────────────┘
│    status       │       │    publisher    │
└─────────────────┘       │    price        │       ┌─────────────────┐
                            │    promotion_pri│       │  sale_order     │
                            │    description  │       │─────────────────│
                            │    cover_url    │       │ PK order_id     │
                            │    status       │       │    order_no      │
                            │    created_at   │       │ FK member_id    │
                            │    updated_at   │       │ FK user_id      │
                            └─────────────────┘       │    total_amount │
                                                       │    discount_amt│
                            ┌─────────────────┐       │    sale_date   │
                            │ sale_order_item │       │    status      │
                            │─────────────────│       │    created_at  │
                            │ PK item_id      │       └───────┬─────────┘
                            │ FK order_id     │◄───────────────┘
                            │ FK book_id      │◄───────────────┐
                            │    quantity     │                │
                            │    unit_price   │                │
                            │    discount_rate│                │
                            │    subtotal     │                │
                            └─────────────────┘                │
                                                             │
┌─────────────────┐       ┌─────────────────┐               │
│   member_level  │       │     member      │               │
│─────────────────│       │─────────────────│               │
│ PK level_id     │◄─┐    │ PK member_id   │               │
│    level_name   │  │    │ FK level_id   │◄─┘            │
│    min_consum   │  │    │    name       │               │
│    max_consum   │  │    │    phone      │               │
│    discount_rate│  │    │    id_card    │               │
│    description  │  │    │    email      │               │
│    status       │  │    │    total_cons │               │
│    created_at   │  │    │    status     │               │
└─────────────────┘  │    │    created_at │               │
                     │    └───────────────┘               │
┌─────────────────┐  │                                     │
│       user      │  │                                     │
│─────────────────│  │                                     │
│ PK user_id      │  │                                     │
│    username     │  │                                     │
│    password     │  │                                     │
│    real_name    │  │                                     │
│    phone        │  │                                     │
│    email        │  │                                     │
│    role         │  │                                     │
│    status       │  │                                     │
│    last_login   │  │                                     │
│    created_at   │  │                                     │
│    updated_at   │  │                                     │
└─────────────────┘  │                                     │
                      │                                     │
┌─────────────────┐  │                                     │
│  system_config  │  │                                     │
│─────────────────│  │                                     │
│ PK config_id    │  │                                     │
│    config_key   │  │                                     │
│    config_value │  │                                     │
│    config_type  │  │                                     │
│    description  │  │                                     │
│    is_editable  │  │                                     │
│    created_at   │  │                                     │
│    updated_at   │  │                                     │
└─────────────────┘  │                                     │
                      │                                     │
┌─────────────────┐  │                                     │
│  promotion_log  │  │                                     │
│─────────────────│  │                                     │
│ PK log_id       │  │                                     │
│ FK book_id      │◄─┘                                     │
│ FK user_id      │                                        │
│    old_price    │                                        │
│    new_price    │                                        │
│    reason       │                                        │
│    created_at   │                                        │
└─────────────────┘                                        │
```

---

## 三、数据库表结构

### 3.1 图书分类表（book_category）

**业务说明**：用于管理图书的分类体系，支持多级分类（树形结构），如：文学 > 小说 > 言情小说。

```sql
CREATE TABLE `book_category` (
    `category_id`   BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '分类ID',
    `name`          VARCHAR(50)     NOT NULL                    COMMENT '分类名称',
    `parent_id`     BIGINT          DEFAULT NULL                COMMENT '父分类ID，NULL表示顶级分类',
    `level`         TINYINT         NOT NULL    DEFAULT 1       COMMENT '分类层级，1=一级',
    `path`          VARCHAR(100)    DEFAULT NULL                COMMENT '分类路径，如：1/3/5',
    `description`   VARCHAR(255)    DEFAULT NULL                COMMENT '分类描述',
    `sort_order`    INT             NOT NULL    DEFAULT 0      COMMENT '排序序号，值越小越靠前',
    `status`        TINYINT         NOT NULL    DEFAULT 1       COMMENT '状态：1=启用，0=禁用',
    `created_at`    DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`    DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

    PRIMARY KEY (`category_id`),
    INDEX `idx_category_parent` (`parent_id`),
    INDEX `idx_category_status` (`status`),
    INDEX `idx_category_path` (`path`),

    CONSTRAINT `fk_category_parent` FOREIGN KEY (`parent_id`)
        REFERENCES `book_category` (`category_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='图书分类表';
```

| 字段 | 类型 | 约束 | 默认值 | 说明 |
|------|------|------|--------|------|
| category_id | BIGINT | PK, AUTO_INCREMENT | - | 分类唯一标识 |
| name | VARCHAR(50) | NOT NULL | - | 分类名称 |
| parent_id | BIGINT | FK (self) | NULL | 父分类，NULL=顶级 |
| level | TINYINT | NOT NULL | 1 | 层级深度 |
| path | VARCHAR(100) | INDEX | NULL |  ancestry path |
| description | VARCHAR(255) | - | NULL | 分类描述 |
| sort_order | INT | NOT NULL | 0 | 排序字段 |
| status | TINYINT | NOT NULL | 1 | 1=启用，0=禁用 |
| created_at | DATETIME | NOT NULL | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | DATETIME | NOT NULL | CURRENT_TIMESTAMP | 更新时间 |

**索引说明**：
- `idx_category_parent`：加速父分类查询
- `idx_category_status`：加速状态筛选
- `idx_category_path`：支持 LIKE '1/3/%' 路径查询

---

### 3.2 图书信息表（book）

**业务说明**：存储图书的全面信息，包括ISBN、书名、作者、出版社等核心字段，支持图书状态管理和促销价格管理。

```sql
CREATE TABLE `book` (
    `book_id`       BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '图书ID',
    `isbn`          VARCHAR(20)     DEFAULT NULL                COMMENT 'ISBN国际标准书号',
    `name`          VARCHAR(100)    NOT NULL                    COMMENT '图书名称',
    `author`        VARCHAR(100)    DEFAULT NULL                COMMENT '作者',
    `publisher`     VARCHAR(100)    DEFAULT NULL                COMMENT '出版社',
    `category_id`   BIGINT          DEFAULT NULL                COMMENT '分类ID',
    `price`         DECIMAL(10,2)   NOT NULL    DEFAULT 0.00     COMMENT '原价',
    `promotion_price` DECIMAL(10,2) DEFAULT NULL                COMMENT '促销价，NULL表示无促销',
    `description`   TEXT            DEFAULT NULL                COMMENT '图书简介',
    `cover_url`     VARCHAR(255)    DEFAULT NULL                COMMENT '封面图片URL',
    `pages`         INT             DEFAULT NULL                COMMENT '页数',
    `publish_date`  DATE            DEFAULT NULL                COMMENT '出版日期',
    `status`        TINYINT         NOT NULL    DEFAULT 1       COMMENT '状态：1=在售，0=下架，2=缺货',
    `created_at`    DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`    DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

    PRIMARY KEY (`book_id`),
    UNIQUE KEY `uk_book_isbn` (`isbn`),
    INDEX `idx_book_name` (`name`),
    INDEX `idx_book_author` (`author`),
    INDEX `idx_book_publisher` (`publisher`),
    INDEX `idx_book_category` (`category_id`),
    INDEX `idx_book_status` (`status`),
    INDEX `idx_book_created` (`created_at`),
    FULLTEXT INDEX `ft_book_search` (`name`, `author`, `publisher`),

    CONSTRAINT `fk_book_category` FOREIGN KEY (`category_id`)
        REFERENCES `book_category` (`category_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='图书信息表';
```

| 字段 | 类型 | 约束 | 默认值 | 说明 |
|------|------|------|--------|------|
| book_id | BIGINT | PK, AUTO_INCREMENT | - | 图书唯一标识 |
| isbn | VARCHAR(20) | UNIQUE | NULL | ISBN，唯一标识图书 |
| name | VARCHAR(100) | NOT NULL | - | 图书名称 |
| author | VARCHAR(100) | - | NULL | 作者姓名 |
| publisher | VARCHAR(100) | - | NULL | 出版社名称 |
| category_id | BIGINT | FK | NULL | 关联分类 |
| price | DECIMAL(10,2) | NOT NULL | 0.00 | 原价 |
| promotion_price | DECIMAL(10,2) | - | NULL | 促销价 |
| description | TEXT | - | NULL | 图书简介 |
| cover_url | VARCHAR(255) | - | NULL | 封面图片 |
| pages | INT | - | NULL | 页数 |
| publish_date | DATE | - | NULL | 出版日期 |
| status | TINYINT | NOT NULL | 1 | 1=在售，0=下架，2=缺货 |
| created_at | DATETIME | NOT NULL | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | DATETIME | NOT NULL | CURRENT_TIMESTAMP | 更新时间 |

**索引说明**：
- `uk_book_isbn`：ISBN 唯一约束
- `idx_book_name/author/publisher`：加速多条件查询
- `ft_book_search`：全文索引，支持书名、作者、出版社的模糊搜索

**业务规则**：
- `promotion_price` 必须小于等于 `price`
- 促销价格变更需记录到 `promotion_log` 表

---

### 3.3 库存表（inventory）

**业务说明**：实时记录每本图书的库存数量，与图书表一一对应，通过触发器或应用层保证库存与销售同步。

```sql
CREATE TABLE `inventory` (
    `inventory_id`  BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '库存记录ID',
    `book_id`       BIGINT          NOT NULL                    COMMENT '图书ID',
    `quantity`      INT             NOT NULL    DEFAULT 0       COMMENT '当前库存数量',
    `reserved_qty`  INT             NOT NULL    DEFAULT 0       COMMENT '预留数量（已下单未出库）',
    `sold_qty`      INT             NOT NULL    DEFAULT 0       COMMENT '累计已售数量',
    `updated_at`    DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

    PRIMARY KEY (`inventory_id`),
    UNIQUE KEY `uk_inventory_book` (`book_id`),
    INDEX `idx_inventory_low` (`quantity`),

    CONSTRAINT `fk_inventory_book` FOREIGN KEY (`book_id`)
        REFERENCES `book` (`book_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='库存表';
```

| 字段 | 类型 | 约束 | 默认值 | 说明 |
|------|------|------|--------|------|
| inventory_id | BIGINT | PK, AUTO_INCREMENT | - | 库存记录ID |
| book_id | BIGINT | FK, UNIQUE | - | 图书ID，与book一一对应 |
| quantity | INT | NOT NULL | 0 | 可用库存 |
| reserved_qty | INT | NOT NULL | 0 | 预留库存 |
| sold_qty | INT | NOT NULL | 0 | 累计销量 |
| updated_at | DATETIME | NOT NULL | CURRENT_TIMESTAMP | 更新时间 |

**业务规则**：
- `quantity - reserved_qty >= 0`（可用库存不能为负）
- 销售下单时扣减 `quantity`，增加 `sold_qty`
- 图书入库时增加 `quantity`

---

### 3.4 会员等级表（member_level）

**业务说明**：定义会员等级体系，不同等级对应不同折扣率。等级晋升根据累计消费金额自动判定。

```sql
CREATE TABLE `member_level` (
    `level_id`      BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '等级ID',
    `level_name`    VARCHAR(30)     NOT NULL                    COMMENT '等级名称',
    `level_code`    VARCHAR(20)     NOT NULL                    COMMENT '等级代码',
    `min_consumption` DECIMAL(12,2) NOT NULL   DEFAULT 0.00    COMMENT '最低累计消费门槛',
    `max_consumption` DECIMAL(12,2) DEFAULT NULL                COMMENT '最高累计消费门槛，NULL表示无上限',
    `discount_rate` DECIMAL(4,2)   NOT NULL    DEFAULT 1.00    COMMENT '折扣率，1.00=无折扣，0.90=九折',
    `point_rate`    DECIMAL(4,2)    NOT NULL    DEFAULT 1.00    COMMENT '积分倍率',
    `description`   VARCHAR(255)    DEFAULT NULL                COMMENT '等级说明',
    `privileges`    TEXT            DEFAULT NULL                COMMENT '等级特权JSON',
    `sort_order`    INT             NOT NULL    DEFAULT 0       COMMENT '排序',
    `status`        TINYINT         NOT NULL    DEFAULT 1       COMMENT '状态：1=启用，0=禁用',
    `created_at`    DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`    DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

    PRIMARY KEY (`level_id`),
    UNIQUE KEY `uk_level_code` (`level_code`),
    INDEX `idx_level_status` (`status`),
    INDEX `idx_level_consumption` (`min_consumption`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员等级表';
```

| 字段 | 类型 | 约束 | 默认值 | 说明 |
|------|------|------|--------|------|
| level_id | BIGINT | PK, AUTO_INCREMENT | - | 等级ID |
| level_name | VARCHAR(30) | NOT NULL | - | 等级名称，如"黄金会员" |
| level_code | VARCHAR(20) | UNIQUE, NOT NULL | - | 等级代码，如"SILVER" |
| min_consumption | DECIMAL(12,2) | NOT NULL | 0.00 | 最低消费门槛 |
| max_consumption | DECIMAL(12,2) | - | NULL | 最高消费门槛 |
| discount_rate | DECIMAL(4,2) | NOT NULL | 1.00 | 折扣率 |
| point_rate | DECIMAL(4,2) | NOT NULL | 1.00 | 积分倍率 |
| privileges | TEXT | - | NULL | 特权列表JSON |
| sort_order | INT | NOT NULL | 0 | 排序 |
| status | TINYINT | NOT NULL | 1 | 状态 |
| created_at | DATETIME | NOT NULL | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | DATETIME | NOT NULL | CURRENT_TIMESTAMP | 更新时间 |

---

### 3.5 会员表（member）

**业务说明**：存储会员信息，会员根据累计消费金额自动匹配对应等级。

```sql
CREATE TABLE `member` (
    `member_id`     BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '会员ID',
    `member_no`     VARCHAR(20)     NOT NULL                    COMMENT '会员编号',
    `name`          VARCHAR(50)     NOT NULL                    COMMENT '会员姓名',
    `phone`          VARCHAR(20)     NOT NULL                    COMMENT '手机号码',
    `id_card`       VARCHAR(20)     DEFAULT NULL                COMMENT '身份证号',
    `email`         VARCHAR(100)    DEFAULT NULL                COMMENT '电子邮箱',
    `gender`        TINYINT         DEFAULT NULL                COMMENT '性别：1=男，2=女，0=未知',
    `birthday`      DATE            DEFAULT NULL                COMMENT '生日',
    `level_id`       BIGINT          DEFAULT NULL                COMMENT '当前等级ID',
    `total_consumption` DECIMAL(12,2) NOT NULL  DEFAULT 0.00    COMMENT '累计消费金额',
    `total_points`   INT             NOT NULL    DEFAULT 0       COMMENT '累计积分',
    `available_points` INT           NOT NULL    DEFAULT 0       COMMENT '可用积分',
    `status`        TINYINT         NOT NULL    DEFAULT 1       COMMENT '状态：1=正常，0=冻结，2=已销户',
    `source`        VARCHAR(20)     DEFAULT NULL                COMMENT '会员来源',
    `registered_at` DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
    `created_at`    DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`    DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

    PRIMARY KEY (`member_id`),
    UNIQUE KEY `uk_member_no` (`member_no`),
    UNIQUE KEY `uk_member_phone` (`phone`),
    UNIQUE KEY `uk_member_idcard` (`id_card`),
    INDEX `idx_member_name` (`name`),
    INDEX `idx_member_level` (`level_id`),
    INDEX `idx_member_status` (`status`),
    INDEX `idx_member_consumption` (`total_consumption`),

    CONSTRAINT `fk_member_level` FOREIGN KEY (`level_id`)
        REFERENCES `member_level` (`level_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员表';
```

| 字段 | 类型 | 约束 | 默认值 | 说明 |
|------|------|------|--------|------|
| member_id | BIGINT | PK, AUTO_INCREMENT | - | 会员ID |
| member_no | VARCHAR(20) | UNIQUE, NOT NULL | - | 会员编号 |
| name | VARCHAR(50) | NOT NULL | - | 会员姓名 |
| phone | VARCHAR(20) | UNIQUE, NOT NULL | - | 手机号（登录账号） |
| id_card | VARCHAR(20) | UNIQUE | NULL | 身份证号 |
| email | VARCHAR(100) | - | NULL | 邮箱 |
| gender | TINYINT | - | NULL | 性别 |
| birthday | DATE | - | NULL | 生日 |
| level_id | BIGINT | FK | NULL | 当前等级 |
| total_consumption | DECIMAL(12,2) | NOT NULL | 0.00 | 累计消费 |
| total_points | INT | NOT NULL | 0 | 累计积分 |
| available_points | INT | NOT NULL | 0 | 可用积分 |
| status | TINYINT | NOT NULL | 1 | 1=正常，0=冻结 |
| source | VARCHAR(20) | - | NULL | 注册来源 |
| registered_at | DATETIME | NOT NULL | CURRENT_TIMESTAMP | 注册时间 |
| created_at | DATETIME | NOT NULL | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | DATETIME | NOT NULL | CURRENT_TIMESTAMP | 更新时间 |

**业务规则**：
- 会员消费后根据 `total_consumption` 自动匹配 `level_id`
- 手机号、身份证号唯一约束防止重复

---

### 3.6 销售订单表（sale_order）

**业务说明**：记录每一笔销售订单，包含订单总金额、优惠金额、销售时间等核心信息。

```sql
CREATE TABLE `sale_order` (
    `order_id`      BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '订单ID',
    `order_no`      VARCHAR(32)     NOT NULL                    COMMENT '订单编号',
    `member_id`     BIGINT          DEFAULT NULL                COMMENT '会员ID，非会员为NULL',
    `user_id`       BIGINT          NOT NULL                    COMMENT '操作员ID（销售人员）',
    `total_amount`  DECIMAL(12,2)   NOT NULL    DEFAULT 0.00     COMMENT '订单总金额（标价）',
    `discount_amount` DECIMAL(12,2) NOT NULL  DEFAULT 0.00     COMMENT '优惠金额',
    `payable_amount` DECIMAL(12,2)  NOT NULL    DEFAULT 0.00     COMMENT '应付金额',
    `paid_amount`   DECIMAL(12,2)   NOT NULL    DEFAULT 0.00     COMMENT '实付金额',
    `points_discount` DECIMAL(12,2) NOT NULL   DEFAULT 0.00     COMMENT '积分抵扣金额',
    `points_earned`  INT             NOT NULL    DEFAULT 0       COMMENT '本次获得积分',
    `sale_date`     DATE            NOT NULL                    COMMENT '销售日期',
    `sale_time`     DATETIME        NOT NULL                    COMMENT '销售时间',
    `payment_method` VARCHAR(20)    DEFAULT NULL                COMMENT '支付方式：cash/card/wechat/alipay',
    `order_status`  TINYINT         NOT NULL    DEFAULT 1       COMMENT '订单状态：1=已完成，2=已取消，3=退款',
    `remark`        VARCHAR(500)    DEFAULT NULL                COMMENT '订单备注',
    `invoice_no`    VARCHAR(50)    DEFAULT NULL                COMMENT '发票编号',
    `created_at`    DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',

    PRIMARY KEY (`order_id`),
    UNIQUE KEY `uk_order_no` (`order_no`),
    INDEX `idx_order_member` (`member_id`),
    INDEX `idx_order_user` (`user_id`),
    INDEX `idx_order_date` (`sale_date`),
    INDEX `idx_order_status` (`order_status`),
    INDEX `idx_order_time` (`sale_time`),
    INDEX `idx_order_invoice` (`invoice_no`),

    CONSTRAINT `fk_order_member` FOREIGN KEY (`member_id`)
        REFERENCES `member` (`member_id`) ON DELETE SET NULL,
    CONSTRAINT `fk_order_user` FOREIGN KEY (`user_id`)
        REFERENCES `user` (`user_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='销售订单表';
```

| 字段 | 类型 | 约束 | 默认值 | 说明 |
|------|------|------|--------|------|
| order_id | BIGINT | PK, AUTO_INCREMENT | - | 订单ID |
| order_no | VARCHAR(32) | UNIQUE, NOT NULL | - | 订单编号（日期+序号） |
| member_id | BIGINT | FK | NULL | 会员ID |
| user_id | BIGINT | FK, NOT NULL | - | 操作员ID |
| total_amount | DECIMAL(12,2) | NOT NULL | 0.00 | 标价总和 |
| discount_amount | DECIMAL(12,2) | NOT NULL | 0.00 | 优惠金额 |
| payable_amount | DECIMAL(12,2) | NOT NULL | 0.00 | 应付金额 |
| paid_amount | DECIMAL(12,2) | NOT NULL | 0.00 | 实付金额 |
| points_discount | DECIMAL(12,2) | NOT NULL | 0.00 | 积分抵扣 |
| points_earned | INT | NOT NULL | 0 | 获得积分 |
| sale_date | DATE | NOT NULL | - | 销售日期（统计用） |
| sale_time | DATETIME | NOT NULL | - | 精确销售时间 |
| payment_method | VARCHAR(20) | - | NULL | 支付方式 |
| order_status | TINYINT | NOT NULL | 1 | 1=完成，2=取消，3=退款 |
| remark | VARCHAR(500) | - | NULL | 备注 |
| invoice_no | VARCHAR(50) | - | NULL | 发票号 |
| created_at | DATETIME | NOT NULL | CURRENT_TIMESTAMP | 创建时间 |

**业务规则**：
- `payable_amount = total_amount - discount_amount`
- `paid_amount = payable_amount - points_discount`
- 订单取消需回滚库存

---

### 3.7 销售订单明细表（sale_order_item）

**业务说明**：订单中的每一种图书明细记录，记录销量、单价、折扣等信息。

```sql
CREATE TABLE `sale_order_item` (
    `item_id`       BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '明细ID',
    `order_id`      BIGINT          NOT NULL                    COMMENT '订单ID',
    `book_id`       BIGINT          NOT NULL                    COMMENT '图书ID',
    `book_name`     VARCHAR(100)    NOT NULL                    COMMENT '图书名称（冗余）',
    `isbn`          VARCHAR(20)     DEFAULT NULL                COMMENT 'ISBN（冗余）',
    `quantity`      INT             NOT NULL                    COMMENT '销售数量',
    `unit_price`    DECIMAL(10,2)   NOT NULL                    COMMENT '单价（成交价）',
    `original_price` DECIMAL(10,2) NOT NULL                    COMMENT '原价',
    `discount_rate` DECIMAL(4,2)    NOT NULL    DEFAULT 1.00    COMMENT '单项折扣率',
    `discount_amount` DECIMAL(10,2) NOT NULL  DEFAULT 0.00     COMMENT '单项优惠金额',
    `subtotal`      DECIMAL(12,2)   NOT NULL                    COMMENT '小计金额',
    `points_earned`  INT             NOT NULL    DEFAULT 0       COMMENT '本项获得积分',
    `created_at`    DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',

    PRIMARY KEY (`item_id`),
    INDEX `idx_item_order` (`order_id`),
    INDEX `idx_item_book` (`book_id`),

    CONSTRAINT `fk_item_order` FOREIGN KEY (`order_id`)
        REFERENCES `sale_order` (`order_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_item_book` FOREIGN KEY (`book_id`)
        REFERENCES `book` (`book_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='销售订单明细表';
```

| 字段 | 类型 | 约束 | 默认值 | 说明 |
|------|------|------|--------|------|
| item_id | BIGINT | PK, AUTO_INCREMENT | - | 明细ID |
| order_id | BIGINT | FK, NOT NULL | - | 订单ID |
| book_id | BIGINT | FK, NOT NULL | - | 图书ID |
| book_name | VARCHAR(100) | NOT NULL | - | 图书名称（冗余，订单历史） |
| isbn | VARCHAR(20) | - | NULL | ISBN（冗余） |
| quantity | INT | NOT NULL | - | 销售数量 |
| unit_price | DECIMAL(10,2) | NOT NULL | - | 成交单价 |
| original_price | DECIMAL(10,2) | NOT NULL | - | 下单时原价 |
| discount_rate | DECIMAL(4,2) | NOT NULL | 1.00 | 单项折扣率 |
| discount_amount | DECIMAL(10,2) | NOT NULL | 0.00 | 单项优惠 |
| subtotal | DECIMAL(12,2) | NOT NULL | - | 小计金额 |
| points_earned | INT | NOT NULL | 0 | 本项积分 |
| created_at | DATETIME | NOT NULL | CURRENT_TIMESTAMP | 创建时间 |

**业务规则**：
- `subtotal = unit_price * quantity`
- 订单取消时需回滚库存

---

### 3.8 系统用户表（user）

**业务说明**：系统操作用户表，包含系统管理员和销售员两类角色。

```sql
CREATE TABLE `user` (
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

| 字段 | 类型 | 约束 | 默认值 | 说明 |
|------|------|------|--------|------|
| user_id | BIGINT | PK, AUTO_INCREMENT | - | 用户ID |
| username | VARCHAR(50) | UNIQUE, NOT NULL | - | 登录账号 |
| password | VARCHAR(255) | NOT NULL | - | BCrypt加密存储 |
| real_name | VARCHAR(50) | - | NULL | 真实姓名 |
| phone | VARCHAR(20) | UNIQUE | NULL | 手机号 |
| email | VARCHAR(100) | - | NULL | 邮箱 |
| role | VARCHAR(20) | NOT NULL | - | ADMIN=管理员，SALES=销售 |
| department | VARCHAR(50) | - | NULL | 部门 |
| status | TINYINT | NOT NULL | 1 | 1=启用，0=禁用 |
| last_login_time | DATETIME | - | NULL | 最后登录 |
| last_login_ip | VARCHAR(50) | - | NULL | 最后IP |
| login_count | INT | NOT NULL | 0 | 登录次数 |
| password_changed_at | DATETIME | - | NULL | 密码修改时间 |
| created_at | DATETIME | NOT NULL | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | DATETIME | NOT NULL | CURRENT_TIMESTAMP | 更新时间 |

**业务规则**：
- 初始密码由系统管理员创建后告知
- 90天强制更换密码（可通过 `system_config` 配置）

---

### 3.9 系统参数配置表（system_config）

**业务说明**：存储系统级配置参数，支持运行时修改。

```sql
CREATE TABLE `system_config` (
    `config_id`     BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '配置ID',
    `config_key`    VARCHAR(100)    NOT NULL                    COMMENT '配置键',
    `config_value`  VARCHAR(500)    DEFAULT NULL                COMMENT '配置值',
    `config_type`   VARCHAR(20)     NOT NULL                    COMMENT '配置类型：STRING/INT/DECIMAL/BOOLEAN/JSON',
    `config_group`  VARCHAR(50)    DEFAULT NULL                COMMENT '配置分组',
    `description`   VARCHAR(255)    DEFAULT NULL                COMMENT '配置说明',
    `is_editable`   TINYINT         NOT NULL    DEFAULT 1       COMMENT '是否可编辑：1=是，0=否（系统级）',
    `sort_order`    INT             NOT NULL    DEFAULT 0       COMMENT '排序',
    `status`        TINYINT         NOT NULL    DEFAULT 1       COMMENT '状态：1=启用，0=禁用',
    `created_at`    DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`    DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

    PRIMARY KEY (`config_id`),
    UNIQUE KEY `uk_config_key` (`config_key`),
    INDEX `idx_config_group` (`config_group`),
    INDEX `idx_config_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统参数配置表';
```

| 字段 | 类型 | 约束 | 默认值 | 说明 |
|------|------|------|--------|------|
| config_id | BIGINT | PK, AUTO_INCREMENT | - | 配置ID |
| config_key | VARCHAR(100) | UNIQUE, NOT NULL | - | 配置键 |
| config_value | VARCHAR(500) | - | NULL | 配置值 |
| config_type | VARCHAR(20) | NOT NULL | - | 数据类型 |
| config_group | VARCHAR(50) | - | NULL | 分组 |
| description | VARCHAR(255) | - | NULL | 说明 |
| is_editable | TINYINT | NOT NULL | 1 | 是否可编辑 |
| sort_order | INT | NOT NULL | 0 | 排序 |
| status | TINYINT | NOT NULL | 1 | 状态 |
| created_at | DATETIME | NOT NULL | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | DATETIME | NOT NULL | CURRENT_TIMESTAMP | 更新时间 |

**预设配置项**：

| config_key | config_type | 说明 |
|------------|-------------|------|
| `system.name` | STRING | 系统名称 |
| `system.version` | STRING | 系统版本 |
| `member.upgrade.threshold` | DECIMAL | 会员升级消费门槛 |
| `points.rate` | DECIMAL | 积分兑换比例（1元=N积分） |
| `password.expiry.days` | INT | 密码过期天数 |
| `sale.receipt.prefix` | STRING | 小票编号前缀 |
| `promotion.max.discount` | DECIMAL | 促销最大折扣率 |

---

### 3.10 促销价格变更日志表（promotion_log）

**业务说明**：记录图书促销价格的每次变更，用于价格审计和促销追踪。

```sql
CREATE TABLE `promotion_log` (
    `log_id`        BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '日志ID',
    `book_id`       BIGINT          NOT NULL                    COMMENT '图书ID',
    `user_id`       BIGINT          NOT NULL                    COMMENT '操作人ID',
    `old_price`     DECIMAL(10,2)   DEFAULT NULL                COMMENT '原价格',
    `new_price`     DECIMAL(10,2)   DEFAULT NULL                COMMENT '新价格',
    `change_type`   VARCHAR(20)     NOT NULL                    COMMENT '变更类型：PROMOTION/DISCOUNT/RESTORE',
    `reason`        VARCHAR(255)    DEFAULT NULL                COMMENT '变更原因',
    `start_time`    DATETIME        DEFAULT NULL                COMMENT '促销开始时间',
    `end_time`      DATETIME        DEFAULT NULL                COMMENT '促销结束时间',
    `created_at`    DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',

    PRIMARY KEY (`log_id`),
    INDEX `idx_promotion_book` (`book_id`),
    INDEX `idx_promotion_time` (`created_at`),
    INDEX `idx_promotion_period` (`start_time`, `end_time`),

    CONSTRAINT `fk_promotion_book` FOREIGN KEY (`book_id`)
        REFERENCES `book` (`book_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_promotion_user` FOREIGN KEY (`user_id`)
        REFERENCES `user` (`user_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='促销价格变更日志表';
```

| 字段 | 类型 | 约束 | 默认值 | 说明 |
|------|------|------|--------|------|
| log_id | BIGINT | PK, AUTO_INCREMENT | - | 日志ID |
| book_id | BIGINT | FK, NOT NULL | - | 图书ID |
| user_id | BIGINT | FK, NOT NULL | - | 操作人 |
| old_price | DECIMAL(10,2) | - | NULL | 变更前价格 |
| new_price | DECIMAL(10,2) | - | NULL | 变更后价格 |
| change_type | VARCHAR(20) | NOT NULL | - | PROMOTION/DISCOUNT/RESTORE |
| reason | VARCHAR(255) | - | NULL | 原因 |
| start_time | DATETIME | - | NULL | 促销开始 |
| end_time | DATETIME | - | NULL | 促销结束 |
| created_at | DATETIME | NOT NULL | CURRENT_TIMESTAMP | 操作时间 |

---

## 四、初始化数据

### 4.1 会员等级初始数据

```sql
INSERT INTO `member_level` (`level_name`, `level_code`, `min_consumption`, `max_consumption`, `discount_rate`, `point_rate`, `description`, `sort_order`, `status`) VALUES
('普通会员', 'NORMAL', 0.00, 99.00, 1.00, 1.00, '累计消费0-99元', 1, 1),
('银卡会员', 'SILVER', 99.00, 499.00, 0.95, 1.20, '累计消费99-499元', 2, 1),
('金卡会员', 'GOLD', 499.00, 1999.00, 0.90, 1.50, '累计消费499-1999元', 3, 1),
('钻石会员', 'DIAMOND', 1999.00, NULL, 0.85, 2.00, '累计消费1999元以上', 4, 1);
```

### 4.2 系统用户初始数据

```sql
INSERT INTO `user` (`username`, `password`, `real_name`, `role`, `status`) VALUES
('admin', '$2a$10$...', '系统管理员', 'ADMIN', 1),
('seller01', '$2a$10$...', '张三', 'SALES', 1);
```

> 注：密码字段需使用 BCrypt 加密，生产环境中请设置强密码。

### 4.3 系统配置初始数据

```sql
INSERT INTO `system_config` (`config_key`, `config_value`, `config_type`, `config_group`, `description`, `is_editable`, `sort_order`, `status`) VALUES
('system.name', '书店销售管理系统', 'STRING', 'SYSTEM', '系统名称', 1, 1, 1),
('system.version', '1.0.0', 'STRING', 'SYSTEM', '系统版本号', 0, 2, 1),
('member.upgrade.threshold', '0', 'DECIMAL', 'MEMBER', '会员升级消费门槛（元）', 1, 10, 1),
('points.rate', '1', 'DECIMAL', 'POINTS', '积分兑换比例（1元=N积分）', 1, 20, 1),
('points.exchange', '100', 'INT', 'POINTS', '积分兑换比例（100积分=1元）', 1, 21, 1),
('password.expiry.days', '90', 'INT', 'SECURITY', '密码过期天数', 1, 30, 1),
('sale.receipt.prefix', 'XS', 'STRING', 'SALE', '销售小票前缀', 1, 40, 1),
('promotion.max.discount', '0.70', 'DECIMAL', 'PROMOTION', '促销最大折扣率（不低于7折）', 1, 50, 1);
```

---

## 五、规范化验证

### 5.1 范式检验

| 范式 | 要求 | 满足情况 |
|------|------|----------|
| 1NF | 字段原子性，不可再分 | ✅ 所有字段均为不可分的原子值 |
| 2NF | 非主键字段完全依赖于主键 | ✅ 所有表主键为单字段或联合主键，非主键字段完全依赖 |
| 3NF | 非主键字段之间不存在传递依赖 | ✅ 通过外键关联消除传递依赖 |

### 5.2 数据冗余控制

| 表间冗余 | 说明 | 处理方式 |
|----------|------|----------|
| `sale_order_item.book_name` | 订单历史需保留下单时书名 | 合理冗余，订单快照 |
| `sale_order_item.isbn` | 同上 | 合理冗余，订单快照 |
| `book_category.path` | 冗余层级路径 | 性能优化，支持快速查询子孙分类 |

---

## 六、性能优化策略

### 6.1 索引设计原则

1. **高频查询字段**：为 `sale_date`、`book_name`、`author`、`member_id` 等高频查询字段建立索引
2. **外键字段**：所有外键字段均建立索引，保证关联查询性能
3. **复合索引**：将常一起查询的字段建立复合索引，如 `(sale_date, order_status)`
4. **避免过多索引**：每个表索引数控制在 5-7 个，避免写入性能下降

### 6.2 分区策略（建议）

当数据量增长到百万级别时，建议对以下表进行分区：

| 表名 | 分区方式 | 分区字段 |
|------|----------|----------|
| `sale_order` | RANGE | `sale_date` |
| `sale_order_item` | RANGE | `order_id`（按关联订单日期） |
| `promotion_log` | RANGE | `created_at` |

### 6.3 SQL 编写规范

1. **禁止全表扫描**：WHERE 条件必须包含索引字段
2. **避免 SELECT ***：只查询需要的字段
3. **批量操作**：大量插入时使用批量 INSERT
4. **分页查询**：使用 `LIMIT OFFSET` 避免深分页性能问题

---

## 七、约束完整性矩阵

| 约束类型 | 说明 | 实现方式 |
|----------|------|----------|
| PRIMARY KEY | 主键唯一 | AUTO_INCREMENT + PK |
| UNIQUE | 唯一约束 | UNIQUE KEY |
| NOT NULL | 非空约束 | NOT NULL |
| FOREIGN KEY | 外键约束 | REFERENCES + ON DELETE/UPDATE |
| CHECK | 自定义约束 | 业务层校验（如 `promotion_price <= price`） |
| DEFAULT | 默认值 | DEFAULT 关键字 |

---

## 八、ER 实体关系汇总

| 关系 | 类型 | 说明 |
|------|------|------|
| `book` ↔ `book_category` | N:1 | 每本图书属于一个分类 |
| `book` ↔ `inventory` | 1:1 | 每本图书对应一条库存记录 |
| `sale_order` ↔ `member` | N:1 | 每笔订单属于一个会员 |
| `sale_order` ↔ `user` | N:1 | 每笔订单由一个操作员完成 |
| `sale_order_item` ↔ `sale_order` | N:1 | 每笔订单包含多条明细 |
| `sale_order_item` ↔ `book` | N:1 | 每条明细对应一本图书 |
| `member` ↔ `member_level` | N:1 | 每个会员属于一个等级 |
| `promotion_log` ↔ `book` | N:1 | 每次价格变更对应一本图书 |
| `promotion_log` ↔ `user` | N:1 | 每次价格变更由一个操作员执行 |
| `book_category` ↔ `book_category` | 1:N (self) | 分类的父子层级关系 |

---

## 九、可扩展性设计

### 9.1 字段扩展
- 使用 `VARCHAR(255)` 作为大部分配置字段，保留扩展空间
- TEXT 类型字段支持未来扩展（如 `privileges` JSON）

### 9.2 功能扩展
- `source` 字段预留多渠道会员来源
- `remark` 字段支持订单特殊备注
- `config_group` 支持配置分组管理

### 9.3 分库分表预留
- 订单表 `sale_order` 使用 `order_no` 作为分片键预留
- 避免使用自增主键作为分布式环境下的分片键

---

## 十、附录

### 10.1 字段类型速查表

| 业务含义 | 推荐类型 | 说明 |
|----------|----------|------|
| 主键 ID | BIGINT | 无符号，自增 |
| 金额（精确） | DECIMAL(10,2) / (12,2) | 避免浮点精度问题 |
| 数量 | INT | 库存、销量等 |
| 比率/折扣 | DECIMAL(4,2) | 如 0.90 表示九折 |
| 状态标志 | TINYINT | 节省存储空间 |
| 日期时间 | DATETIME | 需要时间精度 |
| 大文本 | TEXT | 超出 VARCHAR 长度时使用 |

### 10.2 状态值定义

| 表 | 字段 | 值 | 含义 |
|----|------|-----|------|
| book | status | 1 | 在售 |
| book | status | 0 | 下架 |
| book | status | 2 | 缺货 |
| member | status | 1 | 正常 |
| member | status | 0 | 冻结 |
| member | status | 2 | 已销户 |
| user | status | 1 | 启用 |
| user | status | 0 | 禁用 |
| sale_order | order_status | 1 | 已完成 |
| sale_order | order_status | 2 | 已取消 |
| sale_order | order_status | 3 | 已退款 |
| user | role | ADMIN | 系统管理员 |
| user | role | SALES | 销售人员 |