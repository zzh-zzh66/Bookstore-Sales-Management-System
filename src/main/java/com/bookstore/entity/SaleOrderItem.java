package com.bookstore.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.math.BigDecimal;

@Data
@TableName("sale_order_item")
public class SaleOrderItem {
    @TableId(type = IdType.AUTO)
    private Long itemId;
    private Long orderId;
    private Long bookId;
    private String bookName;
    private String isbn;
    private Integer quantity;
    private BigDecimal unitPrice;
    private BigDecimal originalPrice;
    private BigDecimal discountRate;
    private BigDecimal subtotal;
}
