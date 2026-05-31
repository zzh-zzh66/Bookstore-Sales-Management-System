package com.bookstore.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("member")
public class Member {
    @TableId(type = IdType.AUTO)
    private Long memberId;
    private String memberNo;
    private String name;
    private String phone;
    private String idCard;
    private Long levelId;
    private BigDecimal totalConsumption;
    private Integer totalPoints;
    private Integer availablePoints;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
