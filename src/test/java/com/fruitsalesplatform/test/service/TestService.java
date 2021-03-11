package com.fruitsalesplatform.test.service;

import com.fruitsalesplatform.test.entity.User;

import java.util.List;

public interface TestService {
    public List<User> findUserByName(User user);
}
