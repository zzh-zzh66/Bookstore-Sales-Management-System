package com.bookstore.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.bookstore.entity.SystemUser;
import com.bookstore.service.SystemUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;

@Controller
public class AuthController {

    @Autowired
    private SystemUserService systemUserService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String username,
                        @RequestParam String password,
                        HttpSession session,
                        Model model) {
        System.out.println("[LOGIN] 尝试登录: username=" + username + ", password=" + password);

        QueryWrapper<SystemUser> wrapper = new QueryWrapper<>();
        wrapper.eq("username", username);
        SystemUser user = systemUserService.getOne(wrapper);

        if (user == null) {
            System.out.println("[LOGIN] 失败: 用户名不存在");
            model.addAttribute("error", "用户名不存在");
            return "login";
        }

        System.out.println("[LOGIN] 找到用户: id=" + user.getUserId()
            + ", username=" + user.getUsername()
            + ", status=" + user.getStatus()
            + ", role=" + user.getRole());
        System.out.println("[LOGIN] 数据库密码hash: " + user.getPassword());

        if (user.getStatus() == 0) {
            System.out.println("[LOGIN] 失败: 账号已禁用");
            model.addAttribute("error", "账号已被禁用");
            return "login";
        }

        boolean matchResult = passwordEncoder.matches(password, user.getPassword());
        System.out.println("[LOGIN] BCrypt比对结果: " + matchResult);

        if (!matchResult) {
            System.out.println("[LOGIN] 失败: 密码不匹配");
            model.addAttribute("error", "密码错误");
            return "login";
        }

        System.out.println("[LOGIN] 成功, 写入session, 跳转/index");
        session.setAttribute("user", user);
        session.setAttribute("username", user.getUsername());
        session.setAttribute("role", user.getRole());
        session.setAttribute("userId", user.getUserId());

        return "redirect:/index";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}
