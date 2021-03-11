package com.fruitsalesplatform.dao;

import com.fruitsalesplatform.entity.Retailer;

import java.util.Map;

public interface RetailerDao extends BaseDao<Retailer> {
    public int count(Map map);
}
