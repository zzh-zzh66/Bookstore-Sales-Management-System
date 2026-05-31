package com.bookstore.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("promotion_log")
public class PromotionLog {
    @TableId(type = IdType.AUTO)
    private Long logId;
    private Long bookId;
    private BigDecimal originalPrice;
    private BigDecimal promotionPrice;
    private Long userId;
    private String reason;
    private LocalDateTime createdAt;
}
