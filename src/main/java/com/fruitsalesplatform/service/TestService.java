package com.fruitsalesplatform.service;

import com.fruitsalesplatform.entity.User;

import java.util.List;

public interface TestService {
    public List<User> findUserByName(User user);
}
