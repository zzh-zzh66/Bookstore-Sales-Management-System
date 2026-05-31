package com.bookstore.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.bookstore.entity.MemberLevel;
import com.bookstore.mapper.MemberLevelMapper;
import com.bookstore.service.MemberLevelService;
import org.springframework.stereotype.Service;

@Service
public class MemberLevelServiceImpl extends ServiceImpl<MemberLevelMapper, MemberLevel> implements MemberLevelService {
}
