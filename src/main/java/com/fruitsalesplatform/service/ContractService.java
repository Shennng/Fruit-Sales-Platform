package com.fruitsalesplatform.service;

import com.fruitsalesplatform.entity.Contract;
import com.fruitsalesplatform.entity.ContractVo;
import com.fruitsalesplatform.entity.MiddleTab;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

public interface ContractService {
    public Contract get(Serializable contractId); //只查询一个数据，常用于修改
//    public List<Contract> find(Map map);
    public List<ContractVo> findContractList(Map map);  //根据条件查询多个结果
    public void insert(Contract contract,String[] commoditiesIdArrays,String[] numberArrays);  //插入，用实体作为参数
    public void update(Contract contract);  //修改，用实体作为参数
    public void deleteById(Serializable contractId);  //按照id删除，删除一条，支持整型和字符串类型id
//    public void delete(Serializable[] contractIds);  //批量删除
    public int count(Map map);  //根据条件统计结果集数量
    public void insertMiddleTab(MiddleTab middleTab);
    public int deleteMiddleTab(Serializable contractId);
    public String getMaxBarCode();
}
