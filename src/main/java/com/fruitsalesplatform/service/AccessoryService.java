package com.fruitsalesplatform.service;

import com.fruitsalesplatform.entity.Accessory;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

public interface AccessoryService {
    public Accessory get(Serializable id); //只查询一个数据，常用于修改
    public List<Accessory> find(Map map);  //根据条件查询多个结果
    public void insert(Accessory accessory);  //插入，用实体作为参数
    public void update(Accessory accessory);  //修改，用实体作为参数
    public void deleteById(Serializable id);  //按照id删除，删除一条，支持整型和字符串类型id
    public void delete(Serializable[] ids);  //批量删除
    public int deleteByFruitId(Serializable fruitId);  // 删除某货物下的所有附属品，返回删除条目数
}
