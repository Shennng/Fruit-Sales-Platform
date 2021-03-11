package com.fruitsalesplatform.dao;

import com.fruitsalesplatform.entity.Accessory;

import java.io.Serializable;

public interface AccessoryDao extends BaseDao<Accessory> {
    public int deleteByFruitId(Serializable fruitId); // 返回删除条目数量
}
