package com.fruitsalesplatform.dao.impl;

import com.fruitsalesplatform.dao.UserDao;
import com.fruitsalesplatform.entity.User;
import org.springframework.stereotype.Repository;

@Repository
public class UserDaoImpl extends BaseDaoImpl<User> implements UserDao {
    public UserDaoImpl() {
        super.setNs("com.fruitsalesplatform.mapper.UserMapper");
    }
}
