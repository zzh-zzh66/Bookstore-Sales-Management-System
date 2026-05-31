package com.bookstore.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.bookstore.entity.MemberLevel;
import com.bookstore.service.MemberLevelService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/level")
public class LevelController {

    @Autowired
    private MemberLevelService levelService;

    @GetMapping("/list")
    public String list(Model model) {
        Page<MemberLevel> page = new Page<>(1, 100);
        QueryWrapper<MemberLevel> wrapper = new QueryWrapper<>();
        wrapper.orderByAsc("min_consumption");
        Page<MemberLevel> result = levelService.page(page, wrapper);
        model.addAttribute("levels", result.getRecords());
        return "member/level-list";
    }

    @GetMapping("/add")
    public String addPage(HttpSession session) {
        if (!"ADMIN".equals(session.getAttribute("role"))) {
            return "redirect:/level/list";
        }
        return "member/level-form";
    }

    @PostMapping("/add")
    public String add(MemberLevel level, HttpSession session) {
        if (!"ADMIN".equals(session.getAttribute("role"))) {
            return "redirect:/level/list";
        }
        levelService.save(level);
        return "redirect:/level/list";
    }

    @GetMapping("/edit/{id}")
    public String editPage(@PathVariable Long id, Model model, HttpSession session) {
        if (!"ADMIN".equals(session.getAttribute("role"))) {
            return "redirect:/level/list";
        }
        model.addAttribute("level", levelService.getById(id));
        return "member/level-form";
    }

    @PostMapping("/edit/{id}")
    public String edit(@PathVariable Long id, MemberLevel level, HttpSession session) {
        if (!"ADMIN".equals(session.getAttribute("role"))) {
            return "redirect:/level/list";
        }
        level.setLevelId(id);
        levelService.updateById(level);
        return "redirect:/level/list";
    }
}
