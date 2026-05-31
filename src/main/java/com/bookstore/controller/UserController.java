package com.bookstore.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.bookstore.entity.SystemUser;
import com.bookstore.service.SystemUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private SystemUserService systemUserService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @GetMapping("/list")
    public String list(@RequestParam(defaultValue = "1") Integer pageNum,
                      @RequestParam(defaultValue = "10") Integer pageSize,
                      Model model, HttpSession session) {
        String role = (String) session.getAttribute("role");
        if (!"ADMIN".equals(role)) {
            return "redirect:/index";
        }
        Page<SystemUser> page = new Page<>(pageNum, pageSize);
        QueryWrapper<SystemUser> wrapper = new QueryWrapper<>();
        wrapper.orderByDesc("created_at");
        Page<SystemUser> result = systemUserService.page(page, wrapper);
        result.getRecords().forEach(u -> u.setPassword(""));
        model.addAttribute("page", result);
        return "system/user-list";
    }

    @GetMapping("/add")
    public String addPage(HttpSession session) {
        if (!"ADMIN".equals(session.getAttribute("role"))) {
            return "redirect:/index";
        }
        return "system/user-form";
    }

    @PostMapping("/add")
    public String add(SystemUser user, HttpSession session) {
        if (!"ADMIN".equals(session.getAttribute("role"))) {
            return "redirect:/index";
        }
        user.setPassword(passwordEncoder.encode("123456"));
        user.setStatus(1);
        systemUserService.save(user);
        return "redirect:/user/list";
    }

    @GetMapping("/edit/{id}")
    public String editPage(@PathVariable Long id, Model model, HttpSession session) {
        if (!"ADMIN".equals(session.getAttribute("role"))) {
            return "redirect:/index";
        }
        SystemUser user = systemUserService.getById(id);
        user.setPassword("");
        model.addAttribute("user", user);
        return "system/user-form";
    }

    @PostMapping("/edit/{id}")
    public String edit(@PathVariable Long id, SystemUser user, HttpSession session) {
        if (!"ADMIN".equals(session.getAttribute("role"))) {
            return "redirect:/index";
        }
        user.setUserId(id);
        systemUserService.updateById(user);
        return "redirect:/user/list";
    }

    @PostMapping("/delete/{id}")
    public String delete(@PathVariable Long id, HttpSession session) {
        if (!"ADMIN".equals(session.getAttribute("role"))) {
            return "redirect:/index";
        }
        systemUserService.removeById(id);
        return "redirect:/user/list";
    }
}
