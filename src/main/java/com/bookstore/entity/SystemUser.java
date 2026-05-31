package com.bookstore.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("system_user")
public class SystemUser {
    @TableId(type = IdType.AUTO)
    private Long userId;
    private String username;
    private String password;
    private String realName;
    private String phone;
    private String email;
    private String role;
    private String department;
    private Integer status;
    private LocalDateTime lastLoginTime;
    private String lastLoginIp;
    private Integer loginCount;
    private LocalDateTime passwordChangedAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
