package com.bookstore.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.bookstore.entity.Book;
import com.bookstore.entity.PromotionLog;
import com.bookstore.service.BookService;
import com.bookstore.service.PromotionLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.math.BigDecimal;

@Controller
@RequestMapping("/promotion")
public class PromotionController {

    @Autowired
    private BookService bookService;

    @Autowired
    private PromotionLogService promotionLogService;

    @GetMapping("/list")
    public String list(@RequestParam(defaultValue = "1") Integer pageNum,
                      @RequestParam(defaultValue = "10") Integer pageSize,
                      Model model) {
        Page<Book> page = new Page<>(pageNum, pageSize);
        QueryWrapper<Book> wrapper = new QueryWrapper<>();
        wrapper.isNotNull("promotion_price");
        wrapper.orderByDesc("updated_at");
        Page<Book> result = bookService.page(page, wrapper);
        model.addAttribute("page", result);
        return "sale/promotion-list";
    }

    @GetMapping("/set/{id}")
    public String setPage(@PathVariable Long id, Model model, HttpSession session) {
        if (!"ADMIN".equals(session.getAttribute("role"))) {
            return "redirect:/promotion/list";
        }
        model.addAttribute("book", bookService.getById(id));
        return "sale/promotion-form";
    }

    @PostMapping("/set/{id}")
    public String set(@PathVariable Long id,
                     BigDecimal promotionPrice,
                     HttpSession session) {
        if (!"ADMIN".equals(session.getAttribute("role"))) {
            return "redirect:/promotion/list";
        }
        Book book = bookService.getById(id);
        Long userId = (Long) session.getAttribute("userId");

        PromotionLog log = new PromotionLog();
        log.setBookId(id);
        log.setOriginalPrice(book.getPrice());
        log.setPromotionPrice(promotionPrice);
        log.setUserId(userId);
        promotionLogService.save(log);

        book.setPromotionPrice(promotionPrice);
        bookService.updateById(book);

        return "redirect:/promotion/list";
    }
}
