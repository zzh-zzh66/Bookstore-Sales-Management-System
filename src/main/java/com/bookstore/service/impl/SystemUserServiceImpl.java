package com.bookstore.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.bookstore.entity.SystemUser;
import com.bookstore.mapper.SystemUserMapper;
import com.bookstore.service.SystemUserService;
import org.springframework.stereotype.Service;

@Service
public class SystemUserServiceImpl extends ServiceImpl<SystemUserMapper, SystemUser> implements SystemUserService {
}
