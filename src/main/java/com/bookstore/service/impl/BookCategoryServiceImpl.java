package com.bookstore.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.bookstore.entity.BookCategory;
import com.bookstore.mapper.BookCategoryMapper;
import com.bookstore.service.BookCategoryService;
import org.springframework.stereotype.Service;

@Service
public class BookCategoryServiceImpl extends ServiceImpl<BookCategoryMapper, BookCategory> implements BookCategoryService {
}
