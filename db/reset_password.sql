-- 重置测试用户密码为 123456
-- BCrypt 加密后的密码（运行时验证通过）

UPDATE `system_user` SET `password` = '$2a$10$Gvlu/yU9FzhP4xoYg3PFx.7P/Ze73bchGoftpH/irhUGSbWVAN3DS'
WHERE `username` IN ('admin', 'manager01', 'seller01', 'seller02', 'seller03', 'seller04', 'seller05', 'inventory01');
