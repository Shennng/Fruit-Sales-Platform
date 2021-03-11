package com.fruitsalesplatform.dao.impl;

import com.fruitsalesplatform.dao.AccessoryDao;
import com.fruitsalesplatform.entity.Accessory;
import org.springframework.stereotype.Repository;

import java.io.Serializable;

@Repository
public class AccessoryDaoImpl extends BaseDaoImpl<Accessory> implements AccessoryDao {
    public AccessoryDaoImpl() {
        super.setNs("com.fruitsalesplatform.mapper.AccessoryMapper");
    }

    @Override
    public int deleteByFruitId(Serializable fruitId) {
        // delete方法删除成功返回int变量，显示删除的条目数量
        return this.getSqlSession().delete(this.getNs()+".deleteByFruitId",fruitId);
    }
}
