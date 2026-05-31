package com.bookstore.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.bookstore.entity.*;
import com.bookstore.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

@Controller
@RequestMapping("/sale")
public class SaleController {

    @Autowired
    private BookService bookService;

    @Autowired
    private SaleOrderService saleOrderService;

    @Autowired
    private InventoryService inventoryService;

    @Autowired
    private MemberService memberService;

    @Autowired
    private MemberLevelService levelService;

    @GetMapping("/pos")
    public String pos(Model model) {
        model.addAttribute("books", bookService.list());
        return "sale/pos";
    }

    @PostMapping("/create")
    public String create(@RequestParam Long bookId,
                        @RequestParam Integer quantity,
                        @RequestParam(required = false) Long memberId,
                        @RequestParam String paymentMethod,
                        HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        Inventory inventory = inventoryService.getById(bookId);
        if (inventory == null || inventory.getQuantity() < quantity) {
            return "redirect:/sale/pos?error=stock";
        }
        Book book = bookService.getById(bookId);
        BigDecimal unitPrice = book.getPromotionPrice() != null ? book.getPromotionPrice() : book.getPrice();

        Member member = null;
        if (memberId != null) {
            member = memberService.getById(memberId);
            if (member != null) {
                MemberLevel level = levelService.getById(member.getLevelId());
                if (level != null) {
                    unitPrice = unitPrice.multiply(level.getDiscountRate());
                }
            }
        }

        BigDecimal subtotal = unitPrice.multiply(BigDecimal.valueOf(quantity));
        int points = subtotal.intValue();

        SaleOrder order = new SaleOrder();
        order.setOrderNo("ORD" + System.currentTimeMillis());
        order.setMemberId(memberId);
        order.setUserId(userId);
        order.setTotalAmount(book.getPrice().multiply(BigDecimal.valueOf(quantity)));
        order.setDiscountAmount(order.getTotalAmount().subtract(subtotal));
        order.setPayableAmount(subtotal);
        order.setPaidAmount(subtotal);
        order.setPointsDiscount(BigDecimal.ZERO);
        order.setPointsEarned(points);
        order.setPaymentMethod(paymentMethod);
        order.setSaleTime(LocalDateTime.now());

        SaleOrderItem item = new SaleOrderItem();
        item.setBookId(bookId);
        item.setBookName(book.getName());
        item.setIsbn(book.getIsbn());
        item.setQuantity(quantity);
        item.setUnitPrice(unitPrice);
        item.setOriginalPrice(book.getPrice());
        item.setDiscountRate(member != null && levelService.getById(member.getLevelId()) != null ?
            levelService.getById(member.getLevelId()).getDiscountRate() : BigDecimal.ONE);
        item.setSubtotal(subtotal);

        saleOrderService.createOrder(order, Collections.singletonList(item));

        if (member != null) {
            member.setTotalConsumption(member.getTotalConsumption().add(subtotal));
            member.setTotalPoints(member.getTotalPoints() + points);
            member.setAvailablePoints(member.getAvailablePoints() + points);
            memberService.updateById(member);
        }

        return "redirect:/sale/pos?success=true";
    }

    @GetMapping("/list")
    public String list(@RequestParam(defaultValue = "1") Integer pageNum,
                      @RequestParam(defaultValue = "10") Integer pageSize,
                      @RequestParam(required = false) String startDate,
                      @RequestParam(required = false) String endDate,
                      Model model) {
        Page<SaleOrder> page = new Page<>(pageNum, pageSize);
        QueryWrapper<SaleOrder> wrapper = new QueryWrapper<>();
        if (startDate != null && !startDate.isEmpty()) {
            wrapper.ge("sale_time", startDate);
        }
        if (endDate != null && !endDate.isEmpty()) {
            wrapper.le("sale_time", endDate);
        }
        wrapper.orderByDesc("sale_time");
        Page<SaleOrder> result = saleOrderService.page(page, wrapper);
        model.addAttribute("page", result);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        return "sale/list";
    }
}
