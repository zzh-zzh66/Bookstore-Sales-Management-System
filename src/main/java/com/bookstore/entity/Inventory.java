package com.bookstore.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("inventory")
public class Inventory {
    @TableId(type = IdType.AUTO)
    private Long inventoryId;
    private Long bookId;
    private Integer quantity;
    private Integer reservedQty;
    private Integer soldQty;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
