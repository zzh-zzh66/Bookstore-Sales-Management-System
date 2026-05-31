package com.bookstore.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.bookstore.entity.SystemConfig;
import com.bookstore.service.SystemConfigService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/config")
public class ConfigController {

    @Autowired
    private SystemConfigService configService;

    @GetMapping("/list")
    public String list(@RequestParam(defaultValue = "1") Integer pageNum,
                      @RequestParam(defaultValue = "20") Integer pageSize,
                      Model model, HttpSession session) {
        if (!"ADMIN".equals(session.getAttribute("role"))) {
            return "redirect:/index";
        }
        Page<SystemConfig> page = new Page<>(pageNum, pageSize);
        Page<SystemConfig> result = configService.page(page);
        model.addAttribute("page", result);
        return "system/config-list";
    }

    @PostMapping("/edit")
    public String edit(SystemConfig config, HttpSession session) {
        if (!"ADMIN".equals(session.getAttribute("role"))) {
            return "redirect:/index";
        }
        configService.updateById(config);
        return "redirect:/config/list";
    }
}
