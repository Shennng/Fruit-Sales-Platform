package com.fruitsalesplatform.test.dao;

import com.fruitsalesplatform.test.entity.User;

import java.util.List;

public interface TestDao {
    public List<User> findUserByName(User user);
}
