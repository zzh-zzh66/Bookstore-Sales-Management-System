package com.bookstore.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.bookstore.entity.PromotionLog;
import com.bookstore.mapper.PromotionLogMapper;
import com.bookstore.service.PromotionLogService;
import org.springframework.stereotype.Service;

@Service
public class PromotionLogServiceImpl extends ServiceImpl<PromotionLogMapper, PromotionLog> implements PromotionLogService {
}
