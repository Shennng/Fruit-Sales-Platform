package com.fruitsalesplatform.dao;

import com.fruitsalesplatform.entity.Contract;
import com.fruitsalesplatform.entity.ContractVo;
import com.fruitsalesplatform.entity.MiddleTab;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

public interface ContractDao extends BaseDao<Contract> {
    public int count(Map map);
    public List<ContractVo> findContractList(Map map);
    public void insertMiddleTab(MiddleTab middleTab);
    public int deleteMiddleTab(Serializable contractId);
    public String getMaxBarCode();
}
