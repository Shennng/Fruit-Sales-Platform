package com.fruitsalesplatform.dao;

import com.fruitsalesplatform.entity.User;

import java.util.List;

public interface TestDao {
    public List<User> findUserByName(User user);
}
