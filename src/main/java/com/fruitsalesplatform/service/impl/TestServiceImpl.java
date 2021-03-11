package com.fruitsalesplatform.service.impl;

import com.fruitsalesplatform.dao.TestDao;
import com.fruitsalesplatform.entity.User;
import com.fruitsalesplatform.service.TestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TestServiceImpl implements TestService {
    @Autowired
    private TestDao testDao;
    @Override
    public List<User> findUserByName(User user) {
        return testDao.findUserByName(user);
    }
}
