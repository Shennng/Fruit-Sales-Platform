package com.fruitsalesplatform.test.service.impl;

import com.fruitsalesplatform.test.dao.TestDao;
import com.fruitsalesplatform.test.entity.User;
import com.fruitsalesplatform.test.service.TestService;
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
