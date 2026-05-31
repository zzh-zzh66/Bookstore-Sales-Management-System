package com.bookstore.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.bookstore.entity.BookCategory;
import com.bookstore.service.BookCategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/category")
public class CategoryController {

    @Autowired
    private BookCategoryService categoryService;

    @GetMapping("/list")
    public String list(Model model) {
        Page<BookCategory> page = new Page<>(1, 100);
        QueryWrapper<BookCategory> wrapper = new QueryWrapper<>();
        wrapper.orderByAsc("sort_order");
        Page<BookCategory> result = categoryService.page(page, wrapper);
        model.addAttribute("categories", result.getRecords());
        return "book/category-list";
    }

    @PostMapping("/add")
    public String add(BookCategory category, HttpSession session) {
        String role = (String) session.getAttribute("role");
        if (!"ADMIN".equals(role)) {
            return "redirect:/category/list";
        }
        categoryService.save(category);
        return "redirect:/category/list";
    }

    @PostMapping("/edit")
    public String edit(BookCategory category, HttpSession session) {
        String role = (String) session.getAttribute("role");
        if (!"ADMIN".equals(role)) {
            return "redirect:/category/list";
        }
        categoryService.updateById(category);
        return "redirect:/category/list";
    }

    @PostMapping("/delete/{id}")
    public String delete(@PathVariable Long id, HttpSession session) {
        String role = (String) session.getAttribute("role");
        if (!"ADMIN".equals(role)) {
            return "redirect:/category/list";
        }
        categoryService.removeById(id);
        return "redirect:/category/list";
    }
}
