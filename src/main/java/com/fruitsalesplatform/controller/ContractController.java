package com.fruitsalesplatform.controller;

import com.alibaba.fastjson.JSONObject;
import com.fruitsalesplatform.entity.*;
import com.fruitsalesplatform.service.AccessoryService;
import com.fruitsalesplatform.service.CommoditiesService;
import com.fruitsalesplatform.service.ContractService;
import com.fruitsalesplatform.service.RetailerService;
import com.mysql.cj.util.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping("contract")
public class ContractController extends BaseController {
    @Resource
    private ContractService contractService;
    @Resource
    private RetailerService retailerService;
    @Resource
    private CommoditiesService commoditiesService;
    @Resource
    private AccessoryService accessoryService;

//    Log log = LogFactory.getLog(this.getClass());

    @RequestMapping("list.action")
    public String list(Model model, ContractVo contractVo,String startTime,String endTime) {
        Map<String,Object> map = this.contractToMap(contractVo);
//        log.info("获得的Type属性值："+contractVo.getType());
        if (startTime!=null&&!startTime.equals("")) {
            map.put("startTime",startTime);
        }
        if (endTime!=null&&!endTime.equals("")) {
            map.put("endTime",endTime);
        }
        List<ContractVo> contractVoList = contractService.findContractList(map);
        // 数据回显
        model.addAttribute("barcode",contractVo.getBarCode());
        model.addAttribute("type",contractVo.getType());
        model.addAttribute("retailerName",contractVo.getRetailerName());
        model.addAttribute("startTime",startTime);
        model.addAttribute("endTime",endTime);

        model.addAttribute("list",contractVoList);
        model.addAttribute("currentPage",contractVo.getCurrentPage());
        model.addAttribute("startPage",contractVo.getStartPage());
        int countNumber = contractService.count(map);
        model.addAttribute("countNumber",countNumber);
        int pageSize = contractVo.getPageSize();
        model.addAttribute("pageSize",pageSize);
        int sumPageNumber = countNumber % pageSize == 0 ? (countNumber/pageSize):(countNumber/pageSize+1);
        model.addAttribute("sumPageNumber",sumPageNumber);  // 总页数
        return "/contract/contractHome.jsp";
    }

    private Map<String, Object> contractToMap(ContractVo contractVo) {
        Map<String,Object> map = new HashMap<>();
        map.put("barCode",contractVo.getBarCode()==null?null:(contractVo.getBarCode().equals("")?null:contractVo.getBarCode()));
        map.put("type",contractVo.getType()==-1?null:contractVo.getType());
        map.put("retailerName",checkStringIsEmpty(contractVo.getRetailerName()));
        map.put("startPage",contractVo.getStartPage());
        map.put("pageSize",contractVo.getPageSize());
        return map;
    }

    @RequestMapping("toAddPage.action")
    public String toAddPage() {
        return "/contract/addContract.jsp";  //转向合同添加页面
    }

    @RequestMapping("getAllRetailer.action")
    public @ResponseBody
    List<Retailer> getAllRetailer(@RequestBody(required = false) String json){
        Map<String,Object> map = new HashMap<>();
        map.put("status",1);  // 选择所有被启用的零售商
        if (!StringUtils.isNullOrEmpty(json)) {
            String  name = JSONObject.parseObject(json).getString("name");
            map.put("name","%"+name+"%");
        }
        return retailerService.find(map);
    }

    @RequestMapping("getAllCommodities.action")
    public @ResponseBody List<Commodities> getAllCommodities(@RequestBody(required = false) String json) {
        Map<String,Object> map = new HashMap<>();
        if (!StringUtils.isNullOrEmpty(json)) {
            String name = JSONObject.parseObject(json).getString("name");
            map.put("name","%"+name+"%");
        }
        return commoditiesService.find(map);
    }

    @RequestMapping("getCommoditiesAndAccessory.action")
    public @ResponseBody List<Map<String,Object>> getCommoditiesAndAccessory(String[] arrays) {
        List<Map<String ,Object>> cList = new ArrayList<Map<String,Object>>();
        Map<String ,Object> cMap = null;
        for(String fruitId: arrays) {
            cMap = new HashMap<>();  //cMap是个指针，指向新建的Map对象
            cMap.put("commodities",commoditiesService.get(fruitId));  // 获取货物信息
            Map<String ,Object> findMap = new HashMap<>();
            findMap.put("fruitId",fruitId);
            cMap.put("accessory",accessoryService.find(findMap));  // 获取附属品列表
            cList.add(cMap);
        }
        return cList;
    }

    @RequestMapping("add.action")
    public String add(Model model, Contract contract, String retailerId, String[] commoditiesIdArrays, String[] numberArrays) {
        contract.setRetailer(retailerService.get(retailerId));
        // 生成合同编号(编号代表订单创建日期和当日订单次序和数量)
        String barCode = getCode();
        contract.setBarCode(barCode);
        // 设置contractId(只是为了标识数据库中的一项，无意义)和创建日期
        contract.setContractId(UUID.randomUUID().toString());
        contract.setCreateTime(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
        // 保存合同基本信息(存入数据库)
        contractService.insert(contract,commoditiesIdArrays,numberArrays);
        // 初始化页面搜索信息封装对象
        model.addAttribute("resultMessage","添加成功！合同编号为"+barCode);
        return "/contract/addContract.jsp";  // 返回添加页面
    }

    private String getCode() {
        //取当日年月日信息做编号头
        String codeHead = new SimpleDateFormat("yyyyMMdd").format(new Date());
        String barCode="";
        //从数据库中取出最大的编号信息，在其基础上加1
        String MaxBarcode = contractService.getMaxBarCode();
        if(!StringUtils.isNullOrEmpty(MaxBarcode)){
            //如果最大编号日期是今天，则取其自增数字部分
            if(MaxBarcode.substring(0,8).equals(codeHead)){
                MaxBarcode = MaxBarcode.substring(8);//拿到除了年月日之外的数字
            }else{
                MaxBarcode = "0";//如果最大编号日期不是今日，那么该单是今日第一单
            }
        }else{
            MaxBarcode = "0";//如果没有最大编号，那么该单是系统第一单
        }
        int MaxNumber = Integer.parseInt(MaxBarcode);
        //在今日最大编号基础上加1
        int newNumber = MaxNumber+1;
        if(newNumber<=9){//日期与自增数字拼接为编号
            barCode = codeHead+"000"+newNumber;//一位数
        }else if(newNumber>=10&&newNumber<=99){
            barCode = codeHead+"00"+newNumber;//两位数
        }else if(newNumber>=100&&newNumber<=999){
            barCode = codeHead+"0"+newNumber;//三位数
        }else{
            barCode = codeHead+newNumber;//三位以上的数
        }
        return barCode;
    }

    @RequestMapping("getContractDetail.action")
    public String getContractDetail(Model model,String contractId) {
        Contract contract = contractService.get(contractId);
        model.addAttribute("contract",contract);
        return "/contract/contractDetail.jsp";  // 跳转至详情页
    }

    @RequestMapping("delete.action")
    public String delete(Model model,ContractVo contractVo) {
        contractService.deleteById(contractVo.getContractId());  // 不同于dao层代码
        ContractVo queryContractVo = new ContractVo();
        queryContractVo.setType(-1);
        queryContractVo.setStartPage(contractVo.getStartPage());
        queryContractVo.setCurrentPage(contractVo.getCurrentPage());
        queryContractVo.setPageSize(contractVo.getPageSize());
        return list(model,queryContractVo,null,null);
    }

    @RequestMapping("toEditPage.action")
    public String toEditPage(Model model,String contractId) {
        Contract contract = contractService.get(contractId);
        model.addAttribute("contract",contract);
        return "/contract/editContract.jsp";  //跳转至编辑页面
    }

    @RequestMapping("edit.action")
    public String edit(Model model, Contract contract, String[] commoditiesIdArrays, String[] numberArrays) {
//        log.info("编辑的合同Id："+contract.getContractId());
        if (commoditiesIdArrays!=null&&commoditiesIdArrays.length>0) {  // 货物有变动才进行中间表的修改
            // 删除中间表
            contractService.deleteMiddleTab(contract.getContractId());  // 没有回滚
            //插入中间表
            contractService.insert(contract,commoditiesIdArrays,numberArrays);
        }
        // 更新合同类型和零售商Id
        contractService.update(contract);
        model.addAttribute("resultMessage","编辑成功~");
        return "/contract/editContract.jsp";
    }
}
