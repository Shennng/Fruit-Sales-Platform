package com.fruitsalesplatform.dao.impl;

import com.fruitsalesplatform.dao.TestDao;
import com.fruitsalesplatform.entity.User;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class TestDaoImpl implements TestDao {
    @Autowired // 注入sessionFactory这个Bean
    private SqlSessionFactory sqlSessionFactory;
    private SqlSession sqlSession=null;

    private SqlSession getSqlSession() {
        return sqlSessionFactory.openSession();  // 预防已关闭的session，spring会管理sqlSession的开闭
    }

    @Override
    public List<User> findUserByName(User user) {
        sqlSession=getSqlSession();
        List<User> userList = sqlSession.selectList("test.findUserByName","%"+user.getName()+"%");
        return userList;
    }
}
