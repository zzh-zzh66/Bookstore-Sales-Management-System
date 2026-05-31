package com.bookstore.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("book_category")
public class BookCategory {
    @TableId(type = IdType.AUTO)
    private Long categoryId;
    private String name;
    private Long parentId;
    private Integer level;
    private String path;
    private String description;
    private Integer sortOrder;
    private Integer status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
