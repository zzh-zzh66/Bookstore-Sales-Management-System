package com.bookstore.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.bookstore.entity.SaleOrder;
import com.bookstore.entity.SaleOrderItem;

public interface SaleOrderService extends IService<SaleOrder> {
    void createOrder(SaleOrder order, java.util.List<SaleOrderItem> items);
}
