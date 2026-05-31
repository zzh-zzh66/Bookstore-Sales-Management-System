package com.bookstore.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.bookstore.entity.Book;
import com.bookstore.entity.BookCategory;
import com.bookstore.entity.Member;
import com.bookstore.entity.MemberLevel;
import com.bookstore.service.BookCategoryService;
import com.bookstore.service.BookService;
import com.bookstore.service.MemberLevelService;
import com.bookstore.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.List;

@Controller
@RequestMapping("/member")
public class MemberController {

    @Autowired
    private MemberService memberService;

    @Autowired
    private MemberLevelService levelService;

    @GetMapping("/list")
    public String list(@RequestParam(defaultValue = "1") Integer pageNum,
                      @RequestParam(defaultValue = "10") Integer pageSize,
                      @RequestParam(required = false) String name,
                      @RequestParam(required = false) String phone,
                      Model model) {
        Page<Member> page = new Page<>(pageNum, pageSize);
        QueryWrapper<Member> wrapper = new QueryWrapper<>();
        if (name != null && !name.isEmpty()) {
            wrapper.like("name", name);
        }
        if (phone != null && !phone.isEmpty()) {
            wrapper.eq("phone", phone);
        }
        wrapper.orderByDesc("created_at");
        Page<Member> result = memberService.page(page, wrapper);

        List<MemberLevel> levels = levelService.list();
        result.getRecords().forEach(member -> {
            levels.stream().filter(l -> l.getLevelId().equals(member.getLevelId()))
                .findFirst().ifPresent(level -> member.setLevelId(level.getLevelId()));
        });

        model.addAttribute("page", result);
        model.addAttribute("name", name);
        model.addAttribute("phone", phone);
        model.addAttribute("levels", levels);
        return "member/list";
    }

    @GetMapping("/add")
    public String addPage(Model model) {
        model.addAttribute("levels", levelService.list());
        return "member/form";
    }

    @PostMapping("/add")
    public String add(Member member) {
        String memberNo = "M" + System.currentTimeMillis();
        member.setMemberNo(memberNo);
        member.setTotalConsumption(BigDecimal.ZERO);
        member.setTotalPoints(0);
        member.setAvailablePoints(0);
        member.setStatus("1");
        memberService.save(member);
        return "redirect:/member/list";
    }

    @GetMapping("/edit/{id}")
    public String editPage(@PathVariable Long id, Model model) {
        model.addAttribute("member", memberService.getById(id));
        model.addAttribute("levels", levelService.list());
        return "member/form";
    }

    @PostMapping("/edit/{id}")
    public String edit(@PathVariable Long id, Member member) {
        member.setMemberId(id);
        memberService.updateById(member);
        return "redirect:/member/list";
    }
}
