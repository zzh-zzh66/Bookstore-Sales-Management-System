-- ============================================
-- 书店销售管理系统 LMS - 测试数据
-- 数据版本: 1.0
-- 生成日期: 2026-05-31
-- 说明: 包含图书、会员、用户、库存、系统配置等初始数据
-- ============================================

USE `bookstore_lms`;

-- ============================================
-- 会员等级数据 (member_level)
-- 已有数据基础上补充更完善的等级体系
-- 使用 INSERT IGNORE 避免与 lms_schema.sql 初始数据冲突
-- ============================================

INSERT IGNORE INTO `member_level` (`level_name`, `level_code`, `min_consumption`, `max_consumption`, `discount_rate`, `point_rate`, `description`, `privileges`, `sort_order`, `status`) VALUES
('普通会员', 'NORMAL', 0.00, 999.99, 1.00, 1.00, '注册即送，无门槛要求', '{"birthday_discount": 0.95, "free_shipping": false}', 1, 1),
('银卡会员', 'SILVER', 1000.00, 4999.99, 0.95, 1.20, '累计消费满1000元升级', '{"birthday_discount": 0.90, "free_shipping": true, "monthly_coupon": 1}', 2, 1),
('金卡会员', 'GOLD', 5000.00, 19999.99, 0.90, 1.50, '累计消费满5000元升级', '{"birthday_discount": 0.85, "free_shipping": true, "monthly_coupon": 2, "priority_service": true}', 3, 1),
('钻石会员', 'DIAMOND', 20000.00, NULL, 0.85, 2.00, '累计消费满20000元升级', '{"birthday_discount": 0.80, "free_shipping": true, "monthly_coupon": 5, "priority_service": true, "exclusive_books": true}', 4, 1);

-- ============================================
-- 会员数据 (member)
-- 使用 INSERT IGNORE 避免与 lms_schema.sql 初始数据冲突
-- ============================================

INSERT IGNORE INTO `member` (`member_no`, `name`, `phone`, `id_card`, `email`, `gender`, `birthday`, `level_id`, `total_consumption`, `total_points`, `available_points`, `status`, `source`, `registered_at`) VALUES
('M20260001', '张伟', '13812340001', '310101199001011234', 'zhangwei@email.com', 1, '1990-01-01', 4, 25880.50, 42000, 18500, 1, '门店注册', '2024-03-15 10:30:00'),
('M20260002', '李娜', '13812340002', '310101199203051234', 'lina@email.com', 2, '1992-03-05', 3, 12850.00, 18500, 8200, 1, '线上注册', '2024-06-20 14:22:00'),
('M20260003', '王强', '13812340003', '310101198805101234', 'wangqiang@email.com', 1, '1988-05-10', 3, 8990.00, 12800, 4500, 1, '门店注册', '2024-09-08 09:15:00'),
('M20260004', '刘芳', '13812340004', '310101199506151234', 'liufang@email.com', 2, '1995-06-15', 2, 3200.00, 3800, 2100, 1, '门店注册', '2025-01-10 16:45:00'),
('M20260005', '陈明', '13812340005', '310101199110201234', 'chenming@email.com', 1, '1991-10-20', 2, 2150.00, 2580, 1200, 1, '线上注册', '2025-02-14 11:30:00'),
('M20260006', '赵敏', '13812340006', '310101199308251234', 'zhaomin@email.com', 2, '1993-08-25', 1, 680.00, 680, 420, 1, '门店注册', '2025-04-05 10:00:00'),
('M20260007', '孙浩', '13812340007', '310101198712031234', 'sunhao@email.com', 1, '1987-12-03', 4, 45600.00, 89000, 32000, 1, '门店注册', '2023-11-20 08:30:00'),
('M20260008', '周婷', '13812340008', '310101199602281234', 'zhouting@email.com', 2, '1996-02-28', 1, 350.00, 350, 280, 1, '线上注册', '2025-05-12 20:15:00'),
('M20260009', '吴磊', '13812340009', '310101199404101234', 'wulei@email.com', 1, '1994-04-10', 2, 4580.00, 5500, 3000, 1, '门店注册', '2024-11-25 14:00:00'),
('M20260010', '郑洁', '13812340010', '310101199712221234', 'zhengjie@email.com', 2, '1997-12-22', 1, 920.00, 920, 650, 1, '门店注册', '2025-03-08 15:30:00');

-- ============================================
-- 系统用户数据 (system_user)
-- 密码均为 BCrypt 加密占位符，实际密码需重置
-- 使用 INSERT IGNORE 避免与 lms_schema.sql 初始数据冲突
-- ============================================

INSERT IGNORE INTO `system_user` (`username`, `password`, `real_name`, `phone`, `email`, `role`, `department`, `status`, `last_login_time`, `last_login_ip`, `login_count`, `password_changed_at`) VALUES
('admin', '$2a$10$N.zmds9h7f9Qv/2h8p5k5u1jXzX8k5k5k5k5k5k5k5k5k5k5k5k5k', '系统管理员', '13912340001', 'admin@bookstore.com', 'ADMIN', '管理层', 1, '2026-05-30 08:30:00', '192.168.1.100', 156, '2026-01-15 10:00:00'),
('seller01', '$2a$10$N.zmds9h7f9Qv/2h8p5k5u2kXzX8k5k5k5k5k5k5k5k5k5k5k5k5k', '销售员01', '13912340002', 'seller01@bookstore.com', 'SALES', '销售部', 1, '2026-05-30 18:15:00', '192.168.1.101', 892, '2026-02-20 09:30:00'),
('seller02', '$2a$10$N.zmds9h7f9Qv/2h8p5k5u3kXzX8k5k5k5k5k5k5k5k5k5k5k5k5k', '销售员02', '13912340003', 'seller02@bookstore.com', 'SALES', '销售部', 1, '2026-05-30 17:45:00', '192.168.1.102', 756, '2026-03-10 14:20:00'),
('seller03', '$2a$10$N.zmds9h7f9Qv/2h8p5k5u4kXzX8k5k5k5k5k5k5k5k5k5k5k5k5k', '销售员03', '13912340004', 'seller03@bookstore.com', 'SALES', '销售部', 1, '2026-05-29 16:30:00', '192.168.1.103', 423, '2026-04-05 11:15:00'),
('inventory01', '$2a$10$N.zmds9h7f9Qv/2h8p5k5u5kXzX8k5k5k5k5k5k5k5k5k5k5k5k5k', '库管员01', '13912340005', 'inventory01@bookstore.com', 'SALES', '仓储部', 1, '2026-05-30 08:00:00', '192.168.1.104', 312, '2026-03-25 16:40:00'),
('manager01', '$2a$10$N.zmds9h7f9Qv/2h8p5k5u6kXzX8k5k5k5k5k5k5k5k5k5k5k5k5k', '店长01', '13912340006', 'manager01@bookstore.com', 'ADMIN', '管理层', 1, '2026-05-30 19:00:00', '192.168.1.105', 534, '2026-02-08 10:30:00'),
('seller04', '$2a$10$N.zmds9h7f9Qv/2h8p5k5u7kXzX8k5k5k5k5k5k5k5k5k5k5k5k5k', '销售员04', '13912340007', 'seller04@bookstore.com', 'SALES', '销售部', 0, NULL, NULL, 0, NULL),
('seller05', '$2a$10$N.zmds9h7f9Qv/2h8p5k5u8kXzX8k5k5k5k5k5k5k5k5k5k5k5k5k', '销售员05', '13912340008', 'seller05@bookstore.com', 'SALES', '销售部', 1, '2026-05-28 12:00:00', '192.168.1.107', 189, '2026-05-01 09:00:00');

-- ============================================
-- 图书数据 (book)
-- 使用统一的封面图片路径
-- cover_url: e:\Bookstore-Sales-Management-System\image\海底两万里.jpg
-- ============================================

INSERT IGNORE INTO `book` (`isbn`, `name`, `author`, `publisher`, `category_id`, `price`, `promotion_price`, `description`, `cover_url`, `pages`, `publish_date`, `status`) VALUES
-- 文学分类 (category_id=1)
('978-7-5322-5001-5', '海底两万里', '儒勒·凡尔纳', '上海译文出版社', 1, 45.00, 38.00, '法国作家儒勒·凡尔纳的代表作之一，描述了鹦鹉螺号潜艇的奇妙旅程。', 'e:\\Bookstore-Sales-Management-System\\image\\海底两万里.jpg', 320, '2019-05-01', 1),
('978-7-5322-5002-6', '骆驼祥子', '老舍', '人民文学出版社', 1, 28.00, NULL, '老舍先生的代表作，描写了北京城拉车夫的辛酸故事。', 'e:\\Bookstore-Sales-Management-System\\image\\海底两万里.jpg', 256, '2020-01-15', 1),
('978-7-5322-5003-7', '红楼梦', '曹雪芹', '人民文学出版社', 1, 89.00, 78.00, '中国古典四大名著之一，被誉为中国封建社会的百科全书。', 'e:\\Bookstore-Sales-Management-System\\image\\海底两万里.jpg', 1200, '2019-08-20', 1),
('978-7-5322-5004-8', '围城', '钱钟书', '人民文学出版社', 1, 36.00, NULL, '钱钟书先生的长篇小说，被誉为中国现代文学的经典之作。', 'e:\\Bookstore-Sales-Management-System\\image\\海底两万里.jpg', 320, '2021-03-10', 1),

-- 科幻分类 (category_id=3)
('978-7-5322-6001-3', '三体', '刘慈欣', '重庆出版社', 3, 68.00, 58.00, '中国科幻文学里程碑之作，讲述了地球文明与三体文明的首次接触。', 'e:\\Bookstore-Sales-Management-System\\image\\海底两万里.jpg', 420, '2020-07-01', 1),
('978-7-5322-6002-4', '三体II：黑暗森林', '刘慈欣', '重庆出版社', 3, 72.00, 62.00, '三体系列的第二部，黑暗森林法则的震撼揭示。', 'e:\\Bookstore-Sales-Management-System\\image\\海底两万里.jpg', 450, '2020-08-15', 1),
('978-7-5322-6003-5', '三体III：死神永生', '刘慈欣', '重庆出版社', 3, 78.00, 68.00, '三体系列的终极篇章，跨越亿万年的宇宙史诗。', 'e:\\Bookstore-Sales-Management-System\\image\\海底两万里.jpg', 520, '2020-09-01', 1),
('978-7-5322-6004-6', '基地', '艾萨克·阿西莫夫', '江苏文艺出版社', 3, 58.00, NULL, '科幻大师阿西莫夫的银河帝国系列开山之作。', 'e:\\Bookstore-Sales-Management-System\\image\\海底两万里.jpg', 380, '2021-02-28', 1),

-- 武侠分类 (category_id=4)
('978-7-5322-7001-4', '射雕英雄传', '金庸', '广州出版社', 4, 98.00, 88.00, '金庸武侠小说经典，讲述郭靖和黄蓉的江湖故事。', 'e:\\Bookstore-Sales-Management-System\\image\\海底两万里.jpg', 960, '2019-11-01', 1),
('978-7-5322-7002-5', '神雕侠侣', '金庸', '广州出版社', 4, 108.00, 95.00, '金庸武侠小说经典，杨过与小龙女的爱情传奇。', 'e:\\Bookstore-Sales-Management-System\\image\\海底两万里.jpg', 1050, '2020-02-14', 1),
('978-7-5322-7003-6', '倚天屠龙记', '金庸', '广州出版社', 4, 102.00, 92.00, '金庸武侠小说经典，张无忌的江湖历险。', 'e:\\Bookstore-Sales-Management-System\\image\\海底两万里.jpg', 980, '2020-04-20', 1),

-- 编程语言分类 (category_id=6)
('978-7-5322-8001-2', 'Python编程：从入门到实践', '埃里克·马瑟斯', '人民邮电出版社', 6, 89.00, 76.00, 'Python入门经典教材，涵盖基础知识和实战项目。', 'e:\\Bookstore-Sales-Management-System\\image\\海底两万里.jpg', 480, '2021-06-01', 1),
('978-7-5322-8002-3', 'JavaScript高级程序设计', '马特·弗里德', '人民邮电出版社', 6, 128.00, 108.00, 'JavaScript权威指南，Web开发者必读。', 'e:\\Bookstore-Sales-Management-System\\image\\海底两万里.jpg', 880, '2021-08-15', 1),
('978-7-5322-8003-4', '算法导论', '托马斯·科尔曼', '机械工业出版社', 6, 158.00, 138.00, '算法领域的经典教材，系统讲解算法设计与分析。', 'e:\\Bookstore-Sales-Management-System\\image\\海底两万里.jpg', 780, '2020-12-01', 1),
('978-7-5322-8004-5', '深入理解计算机系统', 'Randal E. Bryant', '机械工业出版社', 6, 139.00, 119.00, '从程序员角度理解计算机系统的经典著作。', 'e:\\Bookstore-Sales-Management-System\\image\\海底两万里.jpg', 620, '2021-04-10', 1),
('978-7-5322-8005-6', 'Effective Java', '约书亚·布洛克', '电子工业出版社', 6, 98.00, 85.00, 'Java程序员必读的进阶指南。', 'e:\\Bookstore-Sales-Management-System\\image\\海底两万里.jpg', 390, '2021-09-20', 1),

-- 数据库分类 (category_id=7)
('978-7-5322-9001-1', 'MySQL必知必会', 'Ben Forta', '人民邮电出版社', 7, 29.00, 25.00, 'MySQL入门经典，简明扼要讲解SQL基础。', 'e:\\Bookstore-Sales-Management-System\\image\\海底两万里.jpg', 220, '2021-03-01', 1),
('978-7-5322-9002-2', 'Redis设计与实现', '黄健宏', '人民邮电出版社', 7, 79.00, 68.00, '系统讲解Redis内部实现机制。', 'e:\\Bookstore-Sales-Management-System\\image\\海底两万里.jpg', 340, '2021-05-15', 1),
('978-7-5322-9003-3', '高性能MySQL', 'Baron Schwartz', '电子工业出版社', 7, 148.00, 128.00, 'MySQL性能优化的权威指南。', 'e:\\Bookstore-Sales-Management-System\\image\\海底两万里.jpg', 820, '2021-07-01', 1),

-- 计算机综合分类 (category_id=5)
('978-7-5322-5005-9', '计算机网络：自顶向下方法', 'James Kurose', '机械工业出版社', 5, 89.00, 78.00, '经典的计算机网络教材，采用自顶向下的教学思路。', 'e:\\Bookstore-Sales-Management-System\\image\\海底两万里.jpg', 560, '2021-01-01', 1),
('978-7-5322-5006-0', '操作系统概念', 'Abraham Silberschatz', '机械工业出版社', 5, 98.00, 85.00, '操作系统领域的经典教材。', 'e:\\Bookstore-Sales-Management-System\\image\\海底两万里.jpg', 720, '2020-11-15', 1);

-- ============================================
-- 库存数据 (inventory)
-- 与图书一一对应
-- 使用 INSERT IGNORE 避免与 lms_schema.sql 初始数据冲突
-- ============================================

INSERT IGNORE INTO `inventory` (`book_id`, `quantity`, `reserved_qty`, `sold_qty`) VALUES
-- 文学类
(1, 35, 0, 28),   -- 海底两万里
(2, 50, 2, 45),   -- 骆驼祥子
(3, 15, 1, 62),   -- 红楼梦
(4, 40, 0, 22),   -- 围城
-- 科幻类
(5, 80, 5, 156),  -- 三体
(6, 65, 3, 98),   -- 三体II
(7, 55, 2, 72),   -- 三体III
(8, 30, 0, 35),   -- 基地
-- 武侠类
(9, 25, 2, 88),   -- 射雕英雄传
(10, 20, 1, 65),  -- 神雕侠侣
(11, 22, 0, 52),  -- 倚天屠龙记
-- 编程语言类
(12, 120, 8, 245), -- Python编程
(13, 85, 4, 168), -- JavaScript高级程序设计
(14, 45, 2, 89),  -- 算法导论
(15, 60, 3, 112), -- 深入理解计算机系统
(16, 70, 0, 95),  -- Effective Java
-- 数据库类
(17, 150, 6, 320), -- MySQL必知必会
(18, 55, 2, 78),  -- Redis设计与实现
(19, 35, 1, 45),  -- 高性能MySQL
-- 计算机综合类
(20, 42, 1, 58),  -- 计算机网络
(21, 38, 0, 42);   -- 操作系统概念

-- ============================================
-- 系统配置数据 (system_config)
-- 使用 INSERT IGNORE 避免与 lms_schema.sql 初始数据冲突
-- ============================================

INSERT IGNORE INTO `system_config` (`config_key`, `config_value`, `config_type`, `config_group`, `description`, `is_editable`, `sort_order`, `status`) VALUES
-- 积分规则配置
('POINTS_PER_YUAN', '1', 'INT', 'points', '每消费1元获得的积分数量', 1, 1, 1),
('POINTS_REDEEM_RATE', '100', 'INT', 'points', '积分兑换比例：100积分抵扣1元', 1, 2, 1),
('POINTS_MIN_REDEEM', '500', 'INT', 'points', '积分兑换最低门槛', 1, 3, 1),
('POINTS_MAX_REDEEM_RATE', '0.3', 'DECIMAL', 'points', '积分抵扣最高比例（应付金额的30%）', 1, 4, 1),

-- 促销规则配置
('PROMOTION_MAX_DISCOUNT', '0.80', 'DECIMAL', 'promotion', '促销允许的最低折扣率（8折）', 1, 1, 1),
('PROMOTION_REQUIRES_REASON', 'true', 'BOOLEAN', 'promotion', '促销是否需要填写原因', 1, 2, 1),

-- 订单规则配置
('ORDER_AUTO_CANCEL_HOURS', '24', 'INT', 'order', '未支付订单自动取消时间（小时）', 1, 1, 1),
('ORDER_INVOICE_PREFIX', 'INV', 'STRING', 'order', '发票编号前缀', 1, 2, 1),
('ORDER_POINTS_BONUS_RATE', '0.10', 'DECIMAL', 'order', '获得积分的消费比例（10%）', 1, 3, 1),

-- 库存规则配置
('INVENTORY_LOW_STOCK_THRESHOLD', '10', 'INT', 'inventory', '库存预警阈值', 1, 1, 1),
('INVENTORY_RESERVE_MINUTES', '30', 'INT', 'inventory', '预留订单保留时间（分钟）', 1, 2, 1),

-- 系统参数
('SYSTEM_STORE_NAME', '博库书店', 'STRING', 'system', '门店名称', 1, 1, 1),
('SYSTEM_STORE_ADDRESS', '上海市静安区南京路步行街168号', 'STRING', 'system', '门店地址', 1, 2, 1),
('SYSTEM_STORE_PHONE', '021-12345678', 'STRING', 'system', '门店联系电话', 1, 3, 1),
('SYSTEM_BUSINESS_HOURS', '09:00-21:00', 'STRING', 'system', '营业时间', 1, 4, 1),

-- 会员规则配置
('MEMBER_REGISTER_POINTS', '100', 'INT', 'member', '新会员注册赠送积分', 1, 1, 1),
('MEMBER_BIRTHDAY_MONTHS', '1', 'INT', 'member', '会员生日优惠月份数', 1, 2, 1),
('MEMBER_LEVEL_CHECK_ON_ORDER', 'true', 'BOOLEAN', 'member', '订单完成后是否检查会员等级升级', 1, 3, 1);

-- ============================================
-- 销售订单数据 (sale_order)
-- 使用 INSERT IGNORE 避免与 lms_schema.sql 初始数据冲突
-- ============================================

INSERT IGNORE INTO `sale_order` (`order_no`, `member_id`, `user_id`, `total_amount`, `discount_amount`, `payable_amount`, `paid_amount`, `points_discount`, `points_earned`, `sale_date`, `sale_time`, `payment_method`, `order_status`, `remark`, `invoice_no`) VALUES
('SO20260530001', 1, 2, 286.00, 14.30, 271.70, 271.70, 0.00, 27, '2026-05-30', '2026-05-30 10:15:00', 'wechat', 1, NULL, 'INV20260530001'),
('SO20260530002', 2, 2, 156.00, 7.80, 148.20, 148.20, 10.00, 14, '2026-05-30', '2026-05-30 11:30:00', 'alipay', 1, NULL, 'INV20260530002'),
('SO20260530003', NULL, 3, 89.00, 0.00, 89.00, 89.00, 0.00, 8, '2026-05-30', '2026-05-30 14:20:00', 'cash', 1, '散客购买', NULL),
('SO20260530004', 3, 3, 342.00, 34.20, 307.80, 307.80, 20.00, 28, '2026-05-30', '2026-05-30 15:45:00', 'card', 1, NULL, 'INV20260530004'),
('SO20260530005', 5, 4, 128.00, 6.40, 121.60, 121.60, 0.00, 12, '2026-05-30', '2026-05-30 16:30:00', 'wechat', 1, NULL, 'INV20260530005'),
('SO20260529001', 1, 2, 76.00, 0.00, 76.00, 76.00, 0.00, 7, '2026-05-29', '2026-05-29 09:30:00', 'alipay', 1, NULL, 'INV20260529001'),
('SO20260529002', 7, 3, 588.00, 58.80, 529.20, 529.20, 50.00, 48, '2026-05-29', '2026-05-29 14:00:00', 'card', 1, '钻石会员专享优惠', 'INV20260529002'),
('SO20260529003', NULL, 4, 45.00, 0.00, 45.00, 45.00, 0.00, 4, '2026-05-29', '2026-05-29 17:20:00', 'cash', 1, NULL, NULL),
('SO20260528001', 4, 2, 236.00, 11.80, 224.20, 224.20, 15.00, 20, '2026-05-28', '2026-05-28 10:00:00', 'wechat', 1, NULL, 'INV20260528001'),
('SO20260528002', 9, 3, 178.00, 8.90, 169.10, 169.10, 0.00, 16, '2026-05-28', '2026-05-28 13:15:00', 'alipay', 1, NULL, 'INV20260528002'),
('SO20260527001', 2, 2, 89.00, 4.45, 84.55, 84.55, 5.00, 8, '2026-05-27', '2026-05-27 11:00:00', 'card', 1, NULL, 'INV20260527001'),
('SO20260526001', NULL, 4, 156.00, 0.00, 156.00, 156.00, 0.00, 15, '2026-05-26', '2026-05-26 15:30:00', 'cash', 1, '企业客户批量采购', 'INV20260526001'),
('SO20260525001', 6, 3, 38.00, 0.00, 38.00, 38.00, 0.00, 3, '2026-05-25', '2026-05-25 09:45:00', 'wechat', 1, NULL, NULL),
('SO20260525002', 1, 2, 258.00, 12.90, 245.10, 245.10, 20.00, 22, '2026-05-25', '2026-05-25 14:20:00', 'alipay', 1, NULL, 'INV20260525002'),
('SO20260524001', 8, 4, 68.00, 0.00, 68.00, 68.00, 0.00, 6, '2026-05-24', '2026-05-24 16:00:00', 'card', 1, NULL, 'INV20260524001');

-- ============================================
-- 销售订单明细数据 (sale_order_item)
-- ============================================

-- 订单1：SO20260530001 (会员1购买)
INSERT INTO `sale_order_item` (`order_id`, `book_id`, `book_name`, `isbn`, `quantity`, `unit_price`, `original_price`, `discount_rate`, `discount_amount`, `subtotal`, `points_earned`) VALUES
(1, 5, '三体', '978-7-5322-6001-3', 2, 58.00, 68.00, 0.85, 20.00, 116.00, 11),
(1, 6, '三体II：黑暗森林', '978-7-5322-6002-4', 2, 62.00, 72.00, 0.86, 20.00, 124.00, 12),
(1, 1, '海底两万里', '978-7-5322-5001-5', 1, 38.00, 45.00, 0.84, 7.00, 38.00, 3);

-- 订单2：SO20260530002 (会员2购买)
INSERT INTO `sale_order_item` (`order_id`, `book_id`, `book_name`, `isbn`, `quantity`, `unit_price`, `original_price`, `discount_rate`, `discount_amount`, `subtotal`, `points_earned`) VALUES
(2, 12, 'Python编程：从入门到实践', '978-7-5322-8001-2', 1, 76.00, 89.00, 0.85, 13.00, 76.00, 7),
(2, 17, 'MySQL必知必会', '978-7-5322-9001-1', 2, 25.00, 29.00, 0.86, 8.00, 50.00, 5);

-- 订单3：SO20260530003 (散客购买)
INSERT INTO `sale_order_item` (`order_id`, `book_id`, `book_name`, `isbn`, `quantity`, `unit_price`, `original_price`, `discount_rate`, `discount_amount`, `subtotal`, `points_earned`) VALUES
(3, 17, 'MySQL必知必会', '978-7-5322-9001-1', 1, 29.00, 29.00, 1.00, 0.00, 29.00, 2),
(3, 18, 'Redis设计与实现', '978-7-5322-9002-2', 1, 68.00, 79.00, 0.86, 11.00, 68.00, 6);

-- 订单4：SO20260530004 (会员3购买)
INSERT INTO `sale_order_item` (`order_id`, `book_id`, `book_name`, `isbn`, `quantity`, `unit_price`, `original_price`, `discount_rate`, `discount_amount`, `subtotal`, `points_earned`) VALUES
(4, 9, '射雕英雄传', '978-7-5322-7001-4', 2, 88.00, 98.00, 0.90, 20.00, 176.00, 16),
(4, 10, '神雕侠侣', '978-7-5322-7002-5', 1, 95.00, 108.00, 0.88, 13.00, 95.00, 9),
(4, 11, '倚天屠龙记', '978-7-5322-7003-6', 1, 92.00, 102.00, 0.90, 10.00, 92.00, 8);

-- 订单5：SO20260530005 (会员5购买)
INSERT INTO `sale_order_item` (`order_id`, `book_id`, `book_name`, `isbn`, `quantity`, `unit_price`, `original_price`, `discount_rate`, `discount_amount`, `subtotal`, `points_earned`) VALUES
(5, 13, 'JavaScript高级程序设计', '978-7-5322-8002-3', 1, 108.00, 128.00, 0.84, 20.00, 108.00, 10);

-- 订单6：SO20260529001 (会员1购买)
INSERT INTO `sale_order_item` (`order_id`, `book_id`, `book_name`, `isbn`, `quantity`, `unit_price`, `original_price`, `discount_rate`, `discount_amount`, `subtotal`, `points_earned`) VALUES
(6, 1, '海底两万里', '978-7-5322-5001-5', 2, 38.00, 45.00, 0.84, 14.00, 76.00, 7);

-- 订单7：SO20260529002 (会员7购买)
INSERT INTO `sale_order_item` (`order_id`, `book_id`, `book_name`, `isbn`, `quantity`, `unit_price`, `original_price`, `discount_rate`, `discount_amount`, `subtotal`, `points_earned`) VALUES
(7, 3, '红楼梦', '978-7-5322-5003-7', 3, 78.00, 89.00, 0.88, 33.00, 234.00, 23),
(7, 4, '围城', '978-7-5322-5004-8', 2, 36.00, 36.00, 1.00, 0.00, 72.00, 7),
(7, 2, '骆驼祥子', '978-7-5322-5002-6', 3, 28.00, 28.00, 1.00, 0.00, 84.00, 8);

-- 订单8：SO20260529003 (散客购买)
INSERT INTO `sale_order_item` (`order_id`, `book_id`, `book_name`, `isbn`, `quantity`, `unit_price`, `original_price`, `discount_rate`, `discount_amount`, `subtotal`, `points_earned`) VALUES
(8, 1, '海底两万里', '978-7-5322-5001-5', 1, 45.00, 45.00, 1.00, 0.00, 45.00, 4);

-- 订单9：SO20260528001 (会员4购买)
INSERT INTO `sale_order_item` (`order_id`, `book_id`, `book_name`, `isbn`, `quantity`, `unit_price`, `original_price`, `discount_rate`, `discount_amount`, `subtotal`, `points_earned`) VALUES
(9, 14, '算法导论', '978-7-5322-8003-4', 1, 118.00, 138.00, 0.86, 20.00, 118.00, 11),
(9, 15, '深入理解计算机系统', '978-7-5322-8004-5', 1, 99.00, 119.00, 0.83, 20.00, 99.00, 9);

-- 订单10：SO20260528002 (会员9购买)
INSERT INTO `sale_order_item` (`order_id`, `book_id`, `book_name`, `isbn`, `quantity`, `unit_price`, `original_price`, `discount_rate`, `discount_amount`, `subtotal`, `points_earned`) VALUES
(10, 20, '计算机网络：自顶向下方法', '978-7-5322-5005-9', 2, 78.00, 89.00, 0.88, 22.00, 156.00, 14);

-- 订单11：SO20260527001 (会员2购买)
INSERT INTO `sale_order_item` (`order_id`, `book_id`, `book_name`, `isbn`, `quantity`, `unit_price`, `original_price`, `discount_rate`, `discount_amount`, `subtotal`, `points_earned`) VALUES
(11, 17, 'MySQL必知必会', '978-7-5322-9001-1', 3, 25.00, 29.00, 0.86, 12.00, 75.00, 7);

-- 订单12：SO20260526001 (散客购买)
INSERT INTO `sale_order_item` (`order_id`, `book_id`, `book_name`, `isbn`, `quantity`, `unit_price`, `original_price`, `discount_rate`, `discount_amount`, `subtotal`, `points_earned`) VALUES
(12, 13, 'JavaScript高级程序设计', '978-7-5322-8002-3', 1, 108.00, 128.00, 0.84, 20.00, 108.00, 10),
(12, 12, 'Python编程：从入门到实践', '978-7-5322-8001-2', 1, 76.00, 89.00, 0.85, 13.00, 76.00, 7);

-- 订单13：SO20260525001 (会员6购买)
INSERT INTO `sale_order_item` (`order_id`, `book_id`, `book_name`, `isbn`, `quantity`, `unit_price`, `original_price`, `discount_rate`, `discount_amount`, `subtotal`, `points_earned`) VALUES
(13, 1, '海底两万里', '978-7-5322-5001-5', 1, 38.00, 45.00, 0.84, 7.00, 38.00, 3);

-- 订单14：SO20260525002 (会员1购买)
INSERT INTO `sale_order_item` (`order_id`, `book_id`, `book_name`, `isbn`, `quantity`, `unit_price`, `original_price`, `discount_rate`, `discount_amount`, `subtotal`, `points_earned`) VALUES
(14, 5, '三体', '978-7-5322-6001-3', 2, 58.00, 68.00, 0.85, 20.00, 116.00, 11),
(14, 8, '基地', '978-7-5322-6004-6', 2, 58.00, 58.00, 1.00, 0.00, 116.00, 11);

-- 订单15：SO20260524001 (会员8购买)
INSERT INTO `sale_order_item` (`order_id`, `book_id`, `book_name`, `isbn`, `quantity`, `unit_price`, `original_price`, `discount_rate`, `discount_amount`, `subtotal`, `points_earned`) VALUES
(15, 5, '三体', '978-7-5322-6001-3', 1, 68.00, 68.00, 1.00, 0.00, 68.00, 6);

-- ============================================
-- 促销日志数据 (promotion_log)
-- 使用 INSERT IGNORE 避免与 lms_schema.sql 初始数据冲突
-- ============================================

INSERT IGNORE INTO `promotion_log` (`book_id`, `user_id`, `old_price`, `new_price`, `change_type`, `reason`, `start_time`, `end_time`) VALUES
(1, 6, 45.00, 38.00, 'PROMOTION', '店内促销活动：世界名著专区8折优惠', '2026-05-01 00:00:00', '2026-05-31 23:59:59'),
(3, 6, 89.00, 78.00, 'PROMOTION', '限时特惠：四大名著全套促销', '2026-05-10 00:00:00', '2026-06-10 23:59:59'),
(5, 6, 68.00, 58.00, 'PROMOTION', '科幻小说周：科幻专区85折', '2026-05-15 00:00:00', '2026-05-31 23:59:59'),
(6, 6, 72.00, 62.00, 'PROMOTION', '科幻小说周：科幻专区85折', '2026-05-15 00:00:00', '2026-05-31 23:59:59'),
(7, 6, 78.00, 68.00, 'PROMOTION', '科幻小说周：科幻专区85折', '2026-05-15 00:00:00', '2026-05-31 23:59:59'),
(9, 6, 98.00, 88.00, 'DISCOUNT', '武侠小说促销：金庸作品集优惠', '2026-05-20 00:00:00', '2026-06-20 23:59:59'),
(10, 6, 108.00, 95.00, 'DISCOUNT', '武侠小说促销：金庸作品集优惠', '2026-05-20 00:00:00', '2026-06-20 23:59:59'),
(11, 6, 102.00, 92.00, 'DISCOUNT', '武侠小说促销：金庸作品集优惠', '2026-05-20 00:00:00', '2026-06-20 23:59:59'),
(12, 6, 89.00, 76.00, 'PROMOTION', '编程类图书促销：IT技术书籍专区', '2026-05-25 00:00:00', '2026-05-31 23:59:59'),
(13, 6, 128.00, 108.00, 'PROMOTION', '编程类图书促销：IT技术书籍专区', '2026-05-25 00:00:00', '2026-05-31 23:59:59'),
(17, 6, 29.00, 25.00, 'PROMOTION', '数据库入门书籍优惠', '2026-05-28 00:00:00', '2026-05-31 23:59:59');
