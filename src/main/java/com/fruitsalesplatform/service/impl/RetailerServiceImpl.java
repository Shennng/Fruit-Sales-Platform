package com.fruitsalesplatform.service.impl;

import com.fruitsalesplatform.dao.RetailerDao;
import com.fruitsalesplatform.entity.Retailer;
import com.fruitsalesplatform.service.RetailerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

@Service
public class RetailerServiceImpl implements RetailerService {
    @Autowired
    private RetailerDao retailerDao;

    @Override
    public Retailer get(Serializable id) {
        return retailerDao.get(id);
    }

    @Override
    public List<Retailer> find(Map map) {
        return retailerDao.find(map);
    }

    @Override
    public void insert(Retailer retailer) {
        retailerDao.insert(retailer);
    }

    @Override
    public void update(Retailer retailer) {
        retailerDao.update(retailer);
    }

    @Override
    public void deleteById(Serializable id) {
        retailerDao.deleteById(id);
    }

    @Override
    public void delete(Serializable[] ids) {
        retailerDao.delete(ids);
    }

    @Override
    public int count(Map map) {
        return retailerDao.count(map);
    }
}
