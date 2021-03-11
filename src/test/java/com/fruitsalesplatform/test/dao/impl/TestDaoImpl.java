package com.fruitsalesplatform.test.dao.impl;

import com.fruitsalesplatform.test.dao.TestDao;
import com.fruitsalesplatform.test.entity.User;
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
        if (sqlSession==null) {
            sqlSession=sqlSessionFactory.openSession();
        }
        return sqlSession;
    }

    @Override
    public List<User> findUserByName(User user) {
        sqlSession=getSqlSession();
        return sqlSession.selectList("test.findUserByName","%"+user.getUsername()+"%");
    }
}
