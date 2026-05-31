package com.bookstore.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.bookstore.entity.Book;
import com.bookstore.entity.SaleOrder;
import com.bookstore.entity.SaleOrderItem;
import com.bookstore.service.BookService;
import com.bookstore.service.SaleOrderItemService;
import com.bookstore.service.SaleOrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/report")
public class ReportController {

    @Autowired
    private SaleOrderService saleOrderService;

    @Autowired
    private SaleOrderItemService saleOrderItemService;

    @Autowired
    private BookService bookService;

    @GetMapping("/daily")
    public String daily(@RequestParam(required = false) String date, Model model) {
        if (date == null || date.isEmpty()) {
            date = LocalDate.now().format(DateTimeFormatter.ISO_DATE);
        }
        LocalDateTime startTime = LocalDate.parse(date).atStartOfDay();
        LocalDateTime endTime = startTime.plusDays(1);

        QueryWrapper<SaleOrder> wrapper = new QueryWrapper<>();
        wrapper.ge("sale_time", startTime);
        wrapper.lt("sale_time", endTime);
        List<SaleOrder> orders = saleOrderService.list(wrapper);

        BigDecimal totalAmount = orders.stream()
            .map(SaleOrder::getPaidAmount)
            .reduce(BigDecimal.ZERO, BigDecimal::add);

        model.addAttribute("date", date);
        model.addAttribute("orderCount", orders.size());
        model.addAttribute("totalAmount", totalAmount);
        model.addAttribute("orders", orders);
        return "report/daily";
    }

    @GetMapping("/monthly")
    public String monthly(@RequestParam(required = false) String yearMonth, Model model) {
        if (yearMonth == null || yearMonth.isEmpty()) {
            yearMonth = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));
        }
        String[] parts = yearMonth.split("-");
        int year = Integer.parseInt(parts[0]);
        int month = Integer.parseInt(parts[1]);

        LocalDateTime startTime = LocalDate.of(year, month, 1).atStartOfDay();
        LocalDateTime endTime = startTime.plusMonths(1);

        QueryWrapper<SaleOrder> wrapper = new QueryWrapper<>();
        wrapper.ge("sale_time", startTime);
        wrapper.lt("sale_time", endTime);
        List<SaleOrder> orders = saleOrderService.list(wrapper);

        BigDecimal totalAmount = orders.stream()
            .map(SaleOrder::getPaidAmount)
            .reduce(BigDecimal.ZERO, BigDecimal::add);

        model.addAttribute("yearMonth", yearMonth);
        model.addAttribute("orderCount", orders.size());
        model.addAttribute("totalAmount", totalAmount);
        return "report/monthly";
    }

    @GetMapping("/bestseller")
    public String bestseller(@RequestParam(defaultValue = "10") Integer limit, Model model) {
        QueryWrapper<SaleOrderItem> wrapper = new QueryWrapper<>();
        wrapper.select("book_id, book_name, SUM(quantity) as total_qty, SUM(subtotal) as total_amount")
            .groupBy("book_id, book_name")
            .orderByDesc("total_qty")
            .last("LIMIT " + limit);
        List<Map<String, Object>> stats = saleOrderItemService.listMaps(wrapper);

        model.addAttribute("stats", stats);
        model.addAttribute("limit", limit);
        return "report/bestseller";
    }
}
