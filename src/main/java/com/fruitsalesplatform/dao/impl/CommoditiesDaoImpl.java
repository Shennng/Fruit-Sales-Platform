package com.fruitsalesplatform.dao.impl;

import com.fruitsalesplatform.dao.CommoditiesDao;
import com.fruitsalesplatform.entity.Commodities;
import org.springframework.stereotype.Repository;

import java.util.Map;
@Repository
public class CommoditiesDaoImpl extends BaseDaoImpl<Commodities> implements CommoditiesDao {
    public CommoditiesDaoImpl() {
        super.setNs("com.fruitsalesplatform.mapper.CommoditiesMapper");
    }


    @Override
    public int count(Map map) {
        return this.getSqlSession().selectOne(this.getNs()+".count",map);
    }
}
