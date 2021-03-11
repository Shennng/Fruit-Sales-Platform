package com.fruitsalesplatform.service.impl;

import com.fruitsalesplatform.dao.ContractDao;
import com.fruitsalesplatform.entity.Contract;
import com.fruitsalesplatform.entity.ContractVo;
import com.fruitsalesplatform.entity.MiddleTab;
import com.fruitsalesplatform.service.ContractService;
import com.mysql.cj.util.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.Serializable;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
public class ContractServiceImpl implements ContractService {
    @Autowired
    private ContractDao contractDao;

    @Override
    public Contract get(Serializable contractId) {
        return contractDao.get(contractId);
    }

    @Override
    public List<ContractVo> findContractList(Map map) {
        return contractDao.findContractList(map);
    }

    @Override
    public void insert(Contract contract,String [] commoditiesIdArrays,String [] numberArrays) {
        if (!StringUtils.isNullOrEmpty(contract.getCreateTime())) {  // 编辑合同时不会传入createTime参数
            contractDao.insert(contract);    // 没有，就插入
        }
        // 存入中间表信息
        for (int i=0;i<commoditiesIdArrays.length;i++) {
            if("".equals(numberArrays[i])||"0".equals(numberArrays[i])) {
                continue;  // 没有设置货物的斤称/数量，则跳过，该合同遂不包含该货物
            }
            MiddleTab middleTab = new MiddleTab();
            middleTab.setContractId(contract.getContractId());
            middleTab.setFruitId(commoditiesIdArrays[i]);
            middleTab.setMiddleId(UUID.randomUUID().toString());
            middleTab.setNumber(Integer.parseInt(numberArrays[i]));
            contractDao.insertMiddleTab(middleTab);
        }
    }

    @Override
    public void update(Contract contract) {
        contractDao.update(contract);
    }

    @Override
    public void deleteById(Serializable contractId) {
        // 同时删除合同及与其关联的中间表
        contractDao.deleteById(contractId);
        contractDao.deleteMiddleTab(contractId);
    }

    @Override
    public int count(Map map) {
        return contractDao.count(map);
    }

    @Override
    public void insertMiddleTab(MiddleTab middleTab) {
        contractDao.insertMiddleTab(middleTab);
    }

    @Override
    public int deleteMiddleTab(Serializable contractId) {
        return contractDao.deleteMiddleTab(contractId);
    }

    @Override
    public String getMaxBarCode() {
        return contractDao.getMaxBarCode();
    }
}
