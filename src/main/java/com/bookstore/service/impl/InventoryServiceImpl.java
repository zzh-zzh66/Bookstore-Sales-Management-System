package com.bookstore.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.bookstore.entity.Inventory;
import com.bookstore.mapper.InventoryMapper;
import com.bookstore.service.InventoryService;
import org.springframework.stereotype.Service;

@Service
public class InventoryServiceImpl extends ServiceImpl<InventoryMapper, Inventory> implements InventoryService {
}
