package com.bookstore.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.bookstore.entity.Member;
import com.bookstore.mapper.MemberMapper;
import com.bookstore.service.MemberService;
import org.springframework.stereotype.Service;

@Service
public class MemberServiceImpl extends ServiceImpl<MemberMapper, Member> implements MemberService {
}
