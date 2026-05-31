package com.bookstore.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("sale_order")
public class SaleOrder {
    @TableId(type = IdType.AUTO)
    private Long orderId;
    private String orderNo;
    private Long memberId;
    private Long userId;
    private BigDecimal totalAmount;
    private BigDecimal discountAmount;
    private BigDecimal payableAmount;
    private BigDecimal paidAmount;
    private BigDecimal pointsDiscount;
    private Integer pointsEarned;
    private String paymentMethod;
    private LocalDateTime saleTime;
    private LocalDateTime createdAt;
}
