book_category          -- 第1个创建（无依赖）
    ↓
book                   -- 依赖 book_category
    ↓
member_level           -- 独立表
    ↓
member                 -- 依赖 member_level
    ↓
user                   -- 独立表
    ↓
inventory              -- 依赖 book
    ↓
sale_order             -- 依赖 member, user
    ↓
sale_order_item        -- 依赖 sale_order, book
    ↓
system_config          -- 独立表
    ↓
promotion_log          -- 依赖 book, user

# 命令行执行
mysql -u root -p < lms_schema.sql

# 或登录后执行
USE `bookstore_lms`;
SOURCE e:/LibraryManagementSystem/LMS/db/lms_schema.sql;

- 密码提醒 ：初始用户的密码是 BCrypt 加密后的占位值：

- admin → 加密占位符（实际密码需重置）
- seller01/seller02 → 加密占位符
- 执行顺序 ：脚本已按正确的依赖顺序创建表，无需手动调整
- 外键检查 ：脚本开头 SET FOREIGN_KEY_CHECKS = 0 ，结尾恢复 SET FOREIGN_KEY_CHECKS = 1
- 字符集 ：全部使用 utf8mb4 ，支持 emoji 和特殊字符存储