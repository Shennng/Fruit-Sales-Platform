package com.fruitsalesplatform.service.impl;

import com.fruitsalesplatform.dao.AccessoryDao;
import com.fruitsalesplatform.entity.Accessory;
import com.fruitsalesplatform.service.AccessoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

@Service
public class AccessoryServiceImpl implements AccessoryService {
    @Autowired
    private AccessoryDao accessoryDao;

    @Override
    public Accessory get(Serializable id) {
        return accessoryDao.get(id);
    }

    @Override
    public List<Accessory> find(Map map) {
        return accessoryDao.find(map);
    }

    @Override
    public void insert(Accessory accessory) {
        accessoryDao.insert(accessory);
    }

    @Override
    public void update(Accessory accessory) {
        accessoryDao.update(accessory);
    }

    @Override
    public void deleteById(Serializable id) {
        accessoryDao.deleteById(id);
    }

    @Override
    public void delete(Serializable[] ids) {
        accessoryDao.delete(ids);
    }

    @Override
    public int deleteByFruitId(Serializable fruitId) {
        return accessoryDao.deleteByFruitId(fruitId);
    }
}
