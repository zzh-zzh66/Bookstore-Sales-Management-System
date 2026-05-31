package com.bookstore.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("book")
public class Book {
    @TableId(type = IdType.AUTO)
    private Long bookId;
    private String isbn;
    private String name;
    private String author;
    private String publisher;
    private Long categoryId;
    private BigDecimal price;
    private BigDecimal promotionPrice;
    private String description;
    private String coverUrl;
    private Integer pages;
    private LocalDate publishDate;
    private Integer status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
