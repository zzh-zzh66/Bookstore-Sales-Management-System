package com.bookstore.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("member_level")
public class MemberLevel {
    @TableId(type = IdType.AUTO)
    private Long levelId;
    private String levelName;
    private String levelCode;
    private BigDecimal minConsumption;
    private BigDecimal maxConsumption;
    private BigDecimal discountRate;
    private BigDecimal pointRate;
    private String description;
    private String privileges;
    private Integer sortOrder;
    private Integer status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
