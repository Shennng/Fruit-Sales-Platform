package com.fruitsalesplatform.dao.impl;

import com.fruitsalesplatform.dao.RetailerDao;
import com.fruitsalesplatform.entity.Retailer;
import org.springframework.stereotype.Repository;

import java.util.Map;

@Repository
public class RetailerDaoImpl extends BaseDaoImpl<Retailer> implements RetailerDao {
    public RetailerDaoImpl() {
        super.setNs("com.fruitsalesplatform.mapper.RetailerMapper");
    }

    @Override
    public int count(Map map) {
        return this.getSqlSession().selectOne(this.getNs()+".count",map);
    }
}
