package com.bookstore.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.bookstore.entity.Book;
import com.bookstore.entity.Inventory;
import com.bookstore.service.BookService;
import com.bookstore.service.InventoryService;
import com.bookstore.service.SaleOrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@Controller
public class IndexController {

    @Autowired
    private BookService bookService;

    @Autowired
    private SaleOrderService saleOrderService;

    @Autowired
    private InventoryService inventoryService;

    @GetMapping({"/", "/index"})
    public String index(HttpSession session, Model model) {
        Object user = session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        LocalDateTime todayStart = LocalDate.now().atStartOfDay();
        LocalDateTime todayEnd = LocalDate.now().plusDays(1).atStartOfDay();

        QueryWrapper<com.bookstore.entity.SaleOrder> orderWrapper = new QueryWrapper<>();
        orderWrapper.ge("sale_time", todayStart);
        orderWrapper.lt("sale_time", todayEnd);
        Long todayOrderCount = saleOrderService.count(orderWrapper);

        BigDecimal todaySales = saleOrderService.list(orderWrapper).stream()
            .map(com.bookstore.entity.SaleOrder::getPaidAmount)
            .reduce(BigDecimal.ZERO, BigDecimal::add);

        QueryWrapper<Inventory> lowStockWrapper = new QueryWrapper<>();
        lowStockWrapper.lt("quantity", 10);
        Long lowStockCount = inventoryService.count(lowStockWrapper);

        model.addAttribute("todayOrderCount", todayOrderCount);
        model.addAttribute("todaySales", todaySales);
        model.addAttribute("lowStockCount", lowStockCount);
        model.addAttribute("totalBooks", bookService.count());

        return "index";
    }
}
