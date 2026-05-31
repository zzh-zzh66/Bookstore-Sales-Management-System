package com.bookstore.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.bookstore.entity.SaleOrderItem;
import com.bookstore.mapper.SaleOrderItemMapper;
import com.bookstore.service.SaleOrderItemService;
import org.springframework.stereotype.Service;

@Service
public class SaleOrderItemServiceImpl extends ServiceImpl<SaleOrderItemMapper, SaleOrderItem> implements SaleOrderItemService {
}
