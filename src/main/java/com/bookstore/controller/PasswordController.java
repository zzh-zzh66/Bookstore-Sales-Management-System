package com.bookstore.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/password")
public class PasswordController {

    @GetMapping("/change")
    public String changePage() {
        return "system/password";
    }

    @PostMapping("/change")
    public String change(@RequestParam String oldPassword,
                        @RequestParam String newPassword,
                        @RequestParam String confirmPassword,
                        HttpSession session,
                        Model model) {
        com.bookstore.entity.SystemUser user = (com.bookstore.entity.SystemUser) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        if (!newPassword.equals(confirmPassword)) {
            model.addAttribute("error", "两次输入的新密码不一致");
            return "system/password";
        }

        model.addAttribute("success", "密码修改成功");
        return "redirect:/index";
    }
}
