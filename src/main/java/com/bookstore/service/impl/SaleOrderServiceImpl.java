package com.bookstore.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.bookstore.entity.Inventory;
import com.bookstore.entity.SaleOrder;
import com.bookstore.entity.SaleOrderItem;
import com.bookstore.mapper.InventoryMapper;
import com.bookstore.mapper.SaleOrderItemMapper;
import com.bookstore.mapper.SaleOrderMapper;
import com.bookstore.service.InventoryService;
import com.bookstore.service.SaleOrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class SaleOrderServiceImpl extends ServiceImpl<SaleOrderMapper, SaleOrder> implements SaleOrderService {

    @Autowired
    private InventoryMapper inventoryMapper;

    @Autowired
    private SaleOrderItemMapper saleOrderItemMapper;

    @Autowired
    private InventoryService inventoryService;

    @Override
    @Transactional
    public void createOrder(SaleOrder order, java.util.List<SaleOrderItem> items) {
        this.save(order);
        for (SaleOrderItem item : items) {
            item.setOrderId(order.getOrderId());
            saleOrderItemMapper.insert(item);
            Inventory inventory = inventoryMapper.selectById(item.getBookId());
            if (inventory != null) {
                inventory.setQuantity(inventory.getQuantity() - item.getQuantity());
                inventory.setSoldQty(inventory.getSoldQty() + item.getQuantity());
                inventoryMapper.updateById(inventory);
            }
        }
    }
}
