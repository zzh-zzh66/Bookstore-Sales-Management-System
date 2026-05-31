-- ============================================
-- 书店销售管理系统 LMS - MySQL DDL 脚本
-- 数据库版本: MySQL 8.0+
-- 字符集: utf8mb4
-- 排序规则: utf8mb4_unicode_ci
-- ============================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = 'STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO';

-- ----------------------------
-- 创建数据库
-- ----------------------------
DROP DATABASE IF EXISTS `bookstore_lms`;
CREATE DATABASE `bookstore_lms`
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE `bookstore_lms`;

-- ============================================
-- 表结构: book_category (图书分类表)
-- 支持树形层级结构
-- ============================================
DROP TABLE IF EXISTS `book_category`;
CREATE TABLE `book_category` (
    `category_id`   BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '分类ID',
    `name`          VARCHAR(50)     NOT NULL                    COMMENT '分类名称',
    `parent_id`     BIGINT          DEFAULT NULL                COMMENT '父分类ID，NULL表示顶级分类',
    `level`         TINYINT         NOT NULL    DEFAULT 1       COMMENT '分类层级，1=一级',
    `path`          VARCHAR(100)    DEFAULT NULL                COMMENT '分类路径，如：1/3/5',
    `description`   VARCHAR(255)    DEFAULT NULL                COMMENT '分类描述',
    `sort_order`    INT             NOT NULL    DEFAULT 0       COMMENT '排序序号，值越小越靠前',
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

-- ============================================
-- 表结构: book (图书信息表)
-- ============================================
DROP TABLE IF EXISTS `book`;
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

-- ============================================
-- 表结构: member_level (会员等级表)
-- ============================================
DROP TABLE IF EXISTS `member_level`;
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

-- ============================================
-- 表结构: member (会员表)
-- ============================================
DROP TABLE IF EXISTS `member`;
CREATE TABLE `member` (
    `member_id`     BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '会员ID',
    `member_no`     VARCHAR(20)     NOT NULL                    COMMENT '会员编号',
    `name`          VARCHAR(50)     NOT NULL                    COMMENT '会员姓名',
    `phone`         VARCHAR(20)     NOT NULL                    COMMENT '手机号码',
    `id_card`       VARCHAR(20)     DEFAULT NULL                COMMENT '身份证号',
    `email`         VARCHAR(100)    DEFAULT NULL                COMMENT '电子邮箱',
    `gender`        TINYINT         DEFAULT NULL                COMMENT '性别：1=男，2=女，0=未知',
    `birthday`      DATE            DEFAULT NULL                COMMENT '生日',
    `level_id`      BIGINT          DEFAULT NULL                COMMENT '当前等级ID',
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

-- ============================================
-- 表结构: system_user (系统用户表)
-- 注意: 原user表因与MySQL保留字冲突，已重命名为system_user
-- ============================================
DROP TABLE IF EXISTS `system_user`;
CREATE TABLE `system_user` (
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

-- ============================================
-- 表结构: inventory (库存表)
-- 注意: 此表需要在 book 表之后创建
-- ============================================
DROP TABLE IF EXISTS `inventory`;
CREATE TABLE `inventory` (
    `inventory_id`  BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '库存记录ID',
    `book_id`       BIGINT          NOT NULL                    COMMENT '图书ID',
    `quantity`      INT             NOT NULL    DEFAULT 0       COMMENT '当前库存数量',
    `reserved_qty`  INT             NOT NULL    DEFAULT 0       COMMENT '预留数量（已下单未出库）',
    `sold_qty`      INT             NOT NULL    DEFAULT 0       COMMENT '累计已售数量',
    `created_at`    DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`    DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

    PRIMARY KEY (`inventory_id`),
    UNIQUE KEY `uk_inventory_book` (`book_id`),
    INDEX `idx_inventory_low` (`quantity`),

    CONSTRAINT `fk_inventory_book` FOREIGN KEY (`book_id`)
        REFERENCES `book` (`book_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='库存表';

-- ============================================
-- 表结构: sale_order (销售订单表)
-- ============================================
DROP TABLE IF EXISTS `sale_order`;
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
    `invoice_no`    VARCHAR(50)     DEFAULT NULL                COMMENT '发票编号',
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
        REFERENCES `system_user` (`user_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='销售订单表';

-- ============================================
-- 表结构: sale_order_item (销售订单明细表)
-- ============================================
DROP TABLE IF EXISTS `sale_order_item`;
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

-- ============================================
-- 表结构: system_config (系统参数配置表)
-- ============================================
DROP TABLE IF EXISTS `system_config`;
CREATE TABLE `system_config` (
    `config_id`     BIGINT          NOT NULL    AUTO_INCREMENT  COMMENT '配置ID',
    `config_key`    VARCHAR(100)    NOT NULL                    COMMENT '配置键',
    `config_value`  VARCHAR(500)   DEFAULT NULL                COMMENT '配置值',
    `config_type`   VARCHAR(20)     NOT NULL                    COMMENT '配置类型：STRING/INT/DECIMAL/BOOLEAN/JSON',
    `config_group`  VARCHAR(50)     DEFAULT NULL                COMMENT '配置分组',
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

-- ============================================
-- 表结构: promotion_log (促销价格变更日志表)
-- ============================================
DROP TABLE IF EXISTS `promotion_log`;
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
        REFERENCES `system_user` (`user_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='促销价格变更日志表';

-- ============================================
-- 初始化数据
-- ============================================

-- 插入图书分类（示例数据）
INSERT INTO `book_category` (`name`, `parent_id`, `level`, `path`, `description`, `sort_order`, `status`) VALUES
('文学', NULL, 1, '1', '文学作品类', 1, 1),
('小说', 1, 2, '1/2', '各类小说', 1, 1),
('科幻', 2, 3, '1/2/3', '科幻小说', 1, 1),
('武侠', 2, 3, '1/2/4', '武侠小说', 2, 1),
('计算机', NULL, 1, '5', '计算机技术类', 2, 1),
('编程语言', 5, 2, '5/6', '编程语言书籍', 1, 1),
('数据库', 5, 2, '5/7', '数据库技术书籍', 2, 1);

-- 插入会员等级
INSERT INTO `member_level` (`level_name`, `level_code`, `min_consumption`, `max_consumption`, `discount_rate`, `point_rate`, `description`, `sort_order`, `status`) VALUES
('普通会员', 'NORMAL', 0.00, 99.00, 1.00, 1.00, '累计消费0-99元', 1, 1),
('银卡会员', 'SILVER', 99.00, 499.00, 0.95, 1.20, '累计消费99-499元', 2, 1),
('金卡会员', 'GOLD', 499.00, 1999.00, 0.90, 1.50, '累计消费499-1999元', 3, 1),
('钻石会员', 'DIAMOND', 1999.00, NULL, 0.85, 2.00, '累计消费1999元以上', 4, 1);

-- 插入系统用户（密码为 BCrypt 加密的 "admin123" 和 "seller123"）
-- 实际部署时请修改为强密码
INSERT INTO `system_user` (`username`, `password`, `real_name`, `role`, `status`) VALUES
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '系统管理员', 'ADMIN', 1),
('seller01', '$2a$10$EqKcp1WFKVQIShe7FcbBDOBqVrKgAQB7uMu2o1aFGJPmJQFIEYGve', '张三', 'SALES', 1),
('seller02', '$2a$10$EqKcp1WFKVQIShe7FcbBDOBqVrKgAQB7uMu2o1aFGJPmJQFIEYGve', '李四', 'SALES', 1);

-- 插入系统配置
INSERT INTO `system_config` (`config_key`, `config_value`, `config_type`, `config_group`, `description`, `is_editable`, `sort_order`, `status`) VALUES
('system.name', '书店销售管理系统', 'STRING', 'SYSTEM', '系统名称', 1, 1, 1),
('system.version', '1.0.0', 'STRING', 'SYSTEM', '系统版本号', 0, 2, 1),
('system.store.name', '希望书店', 'STRING', 'SYSTEM', '书店名称', 1, 3, 1),
('member.upgrade.threshold', '0', 'DECIMAL', 'MEMBER', '会员升级消费门槛（元）', 1, 10, 1),
('member.register.gift.points', '50', 'INT', 'MEMBER', '新会员注册赠送积分', 1, 11, 1),
('points.rate', '1', 'DECIMAL', 'POINTS', '积分获取比例（1元=N积分）', 1, 20, 1),
('points.exchange', '100', 'INT', 'POINTS', '积分兑换比例（100积分=1元）', 1, 21, 1),
('points.expire.days', '365', 'INT', 'POINTS', '积分过期天数', 1, 22, 1),
('password.expiry.days', '90', 'INT', 'SECURITY', '密码过期天数', 1, 30, 1),
('password.min.length', '6', 'INT', 'SECURITY', '密码最小长度', 1, 31, 1),
('sale.receipt.prefix', 'XS', 'STRING', 'SALE', '销售小票前缀', 1, 40, 1),
('sale.invoice.enabled', 'true', 'BOOLEAN', 'SALE', '是否启用发票功能', 1, 41, 1),
('promotion.max.discount', '0.70', 'DECIMAL', 'PROMOTION', '促销最大折扣率（不低于7折）', 1, 50, 1),
('promotion.auto.end', 'false', 'BOOLEAN', 'PROMOTION', '促销是否自动结束', 1, 51, 1);

-- 插入图书示例数据
INSERT INTO `book` (`isbn`, `name`, `author`, `publisher`, `category_id`, `price`, `description`, `pages`, `publish_date`, `status`) VALUES
('978-7-111-54901-0', 'Java核心技术卷I', 'Cay S. Horstmann', '机械工业出版社', 6, 119.00, 'Java技术经典参考书', 900, '2016-09-01', 1),
('978-7-115-28565-6', 'Python编程：从入门到实践', 'Eric Matthes', '人民邮电出版社', 6, 89.00, 'Python入门经典', 450, '2016-07-01', 1),
('978-7-122-32256-9', 'MySQL必知必会', 'Ben Forta', '化学工业出版社', 7, 29.80, 'MySQL入门经典', 250, '2019-01-01', 1),
('978-7-115-49038-8', '三体', '刘慈欣', '重庆出版社', 3, 68.00, '科幻巨著', 530, '2019-06-01', 1),
('978-7-5322-5006-9', '天龙八部', '金庸', '广州出版社', 4, 128.00, '武侠小说经典', 1500, '2018-07-01', 1);

-- 为图书插入库存数据
INSERT INTO `inventory` (`book_id`, `quantity`, `reserved_qty`, `sold_qty`) VALUES
(1, 50, 0, 0),
(2, 100, 0, 0),
(3, 80, 0, 0),
(4, 30, 0, 0),
(5, 15, 0, 0);

-- ----------------------------
-- 启用外键约束检查
-- ----------------------------
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- 脚本执行完成
-- ============================================
