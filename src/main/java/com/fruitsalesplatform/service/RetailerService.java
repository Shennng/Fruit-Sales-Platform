package com.fruitsalesplatform.service;

import com.fruitsalesplatform.entity.Retailer;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

public interface RetailerService {
    public Retailer get(Serializable id); //只查询一个数据，常用于修改
    public List<Retailer> find(Map map);  //根据条件查询多个结果
    public void insert(Retailer retailer);  //插入，用实体作为参数
    public void update(Retailer retailer);  //修改，用实体作为参数
    public void deleteById(Serializable id);  //按照id删除，删除一条，支持整型和字符串类型id
    public void delete(Serializable[] ids);  //批量删除
    public int count(Map map);  //根据条件统计结果集数量
}
