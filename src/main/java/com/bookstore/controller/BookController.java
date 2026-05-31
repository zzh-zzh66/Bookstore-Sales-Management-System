package com.bookstore.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.bookstore.entity.Book;
import com.bookstore.entity.BookCategory;
import com.bookstore.entity.Inventory;
import com.bookstore.service.BookCategoryService;
import com.bookstore.service.BookService;
import com.bookstore.service.InventoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.math.BigDecimal;

@Controller
@RequestMapping("/book")
public class BookController {

    @Autowired
    private BookService bookService;

    @Autowired
    private BookCategoryService categoryService;

    @Autowired
    private InventoryService inventoryService;

    @GetMapping("/list")
    public String list(@RequestParam(defaultValue = "1") Integer pageNum,
                      @RequestParam(defaultValue = "10") Integer pageSize,
                      @RequestParam(required = false) String name,
                      @RequestParam(required = false) Long categoryId,
                      @RequestParam(required = false) String author,
                      @RequestParam(required = false) String publisher,
                      Model model) {
        Page<Book> page = new Page<>(pageNum, pageSize);
        QueryWrapper<Book> wrapper = new QueryWrapper<>();
        if (name != null && !name.isEmpty()) {
            wrapper.like("name", name);
        }
        if (categoryId != null) {
            wrapper.eq("category_id", categoryId);
        }
        if (author != null && !author.isEmpty()) {
            wrapper.like("author", author);
        }
        if (publisher != null && !publisher.isEmpty()) {
            wrapper.like("publisher", publisher);
        }
        wrapper.orderByDesc("created_at");

        Page<Book> result = bookService.page(page, wrapper);
        model.addAttribute("page", result);
        model.addAttribute("name", name);
        model.addAttribute("categoryId", categoryId);
        model.addAttribute("author", author);
        model.addAttribute("publisher", publisher);
        model.addAttribute("categories", categoryService.list());
        return "book/list";
    }

    @GetMapping("/add")
    public String addPage(HttpSession session, Model model) {
        String role = (String) session.getAttribute("role");
        if (!"ADMIN".equals(role)) {
            return "redirect:/book/list";
        }
        model.addAttribute("categories", categoryService.list());
        return "book/form";
    }

    @PostMapping("/add")
    public String add(Book book, Integer initialStock, HttpSession session) {
        String role = (String) session.getAttribute("role");
        if (!"ADMIN".equals(role)) {
            return "redirect:/book/list";
        }
        bookService.save(book);
        if (initialStock != null && initialStock > 0) {
            Inventory inventory = new Inventory();
            inventory.setBookId(book.getBookId());
            inventory.setQuantity(initialStock);
            inventory.setReservedQty(0);
            inventory.setSoldQty(0);
            inventoryService.save(inventory);
        }
        return "redirect:/book/list";
    }

    @GetMapping("/edit/{id}")
    public String editPage(@PathVariable Long id, Model model, HttpSession session) {
        String role = (String) session.getAttribute("role");
        if (!"ADMIN".equals(role)) {
            return "redirect:/book/list";
        }
        model.addAttribute("book", bookService.getById(id));
        model.addAttribute("categories", categoryService.list());
        return "book/form";
    }

    @PostMapping("/edit/{id}")
    public String edit(@PathVariable Long id, Book book, HttpSession session) {
        String role = (String) session.getAttribute("role");
        if (!"ADMIN".equals(role)) {
            return "redirect:/book/list";
        }
        book.setBookId(id);
        bookService.updateById(book);
        return "redirect:/book/list";
    }

    @PostMapping("/delete/{id}")
    public String delete(@PathVariable Long id, HttpSession session) {
        String role = (String) session.getAttribute("role");
        if (!"ADMIN".equals(role)) {
            return "redirect:/book/list";
        }
        bookService.removeById(id);
        return "redirect:/book/list";
    }
}
