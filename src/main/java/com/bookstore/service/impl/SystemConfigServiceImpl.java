package com.bookstore.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.bookstore.entity.SystemConfig;
import com.bookstore.mapper.SystemConfigMapper;
import com.bookstore.service.SystemConfigService;
import org.springframework.stereotype.Service;

@Service
public class SystemConfigServiceImpl extends ServiceImpl<SystemConfigMapper, SystemConfig> implements SystemConfigService {
}
