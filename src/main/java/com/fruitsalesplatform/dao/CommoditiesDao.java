package com.fruitsalesplatform.dao;

import com.fruitsalesplatform.entity.Commodities;

import java.util.Map;

public interface CommoditiesDao extends BaseDao<Commodities> {
    public int count(Map map);
}
