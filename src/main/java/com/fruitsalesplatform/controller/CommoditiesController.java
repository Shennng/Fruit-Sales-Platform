package com.fruitsalesplatform.controller;

import com.alibaba.fastjson.JSONObject;
import com.fruitsalesplatform.entity.Commodities;
import com.fruitsalesplatform.service.AccessoryService;
import com.fruitsalesplatform.service.CommoditiesService;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping("commodities")
public class CommoditiesController extends BaseController {
    @Resource
    private CommoditiesService commoditiesService;
    @Resource
    private AccessoryService accessoryService;
    Log log = LogFactory.getLog(this.getClass());

    @RequestMapping("list.action")
    public String list(Model model, Commodities commodities,
                       @RequestParam(defaultValue = "0.0") double startPrice, @RequestParam(defaultValue = "0.0") double endPrice,
                       String startTime, String endTime) {
        Map<String,Object> map = this.commoditiesToMap(commodities);
        if (startPrice>0.0){
            map.put("startPrice",startPrice);
        }
        if (endPrice>0.0){
            map.put("endPrice",endPrice);
        }
        if (startTime!=null&&!startTime.equals("")){
            map.put("startTime",startTime);
        }
        if (endTime!=null&&!endTime.equals("")) {
            map.put("endTime",endTime);
        }
        List<Commodities> commoditiesList = commoditiesService.find(map);
        // 搜索条件回显
        model.addAttribute("commodities",commodities);
        model.addAttribute("startPrice",startPrice);
        model.addAttribute("endPrice",endPrice);
        model.addAttribute("startTime",startTime);
        model.addAttribute("endTime",endTime);

        model.addAttribute("list",commoditiesList.size()<1?null:commoditiesList);
        model.addAttribute("currentPage",commodities.getCurrentPage());  // 当前页码
        model.addAttribute("startPage",commodities.getStartPage());  // 当前数据起始位置，默认为0
        int countNumber = commoditiesService.count(map);  // 计数
        model.addAttribute("countNumber",countNumber);  // 数据总条数
        int pageSize = commodities.getPageSize();
        model.addAttribute("pageSize",pageSize);  // 每页数据，默认10
        int sumPageNumber = countNumber % pageSize == 0 ? (countNumber/pageSize):(countNumber/pageSize+1);
        model.addAttribute("sumPageNumber",sumPageNumber);  // 总页数
        return "/commodities/commoditiesHome.jsp";
    }

    @RequestMapping("editCommodities.action")
    public @ResponseBody
    Commodities editCommodities(@RequestBody String json) {
        String id = JSONObject.parseObject(json).getString("id");
        return commoditiesService.get(id);
    }

    @RequestMapping("edit.action")
    public String edit(Model model,Commodities commodities) {
        commoditiesService.update(commodities);
        Commodities queryCommodities = new Commodities();
        queryCommodities.setStartPage(commodities.getStartPage());
        queryCommodities.setPageSize(commodities.getPageSize());
        queryCommodities.setCurrentPage(commodities.getCurrentPage());
        return list(model,queryCommodities,0.0d,0.0d,null,null);
    }

    @RequestMapping("add.action")
    public String add(Model model,Commodities commodities) {
        commodities.setFruitId(UUID.randomUUID().toString());
        commodities.setCreateTime(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
        commoditiesService.insert(commodities);
        return list(model,new Commodities(),0.0d,0.0d,null,null);
    }

    @RequestMapping("delete.action")
    public String delete(Model model,Commodities commodities) {
        String fruitId = commodities.getFruitId();
        commoditiesService.deleteById(fruitId);  // 删除该货物
        int result = accessoryService.deleteByFruitId(fruitId);  // 删除该货物下的附属品
        log.info("删除 fruitId="+fruitId+ "的关联数据 [ 附属品 ] 数目为:"+result);
        Commodities queryCommodities = new Commodities();
        queryCommodities.setStartPage(commodities.getStartPage());
        queryCommodities.setPageSize(commodities.getPageSize());
        queryCommodities.setCurrentPage(commodities.getCurrentPage());
        return list(model,queryCommodities,0.0d,0.0d,null,null);
    }

    public Map<String,Object> commoditiesToMap(Commodities commodities) {
        Map<String,Object> map = new HashMap<>();
        map.put("name",super.checkStringIsEmpty(commodities.getName()));
        map.put("locality",super.checkStringIsEmpty(commodities.getLocality()));
        map.put("createTime",super.checkStringIsEmpty(commodities.getCreateTime()));
        map.put("startPage",commodities.getStartPage());
        map.put("pageSize",commodities.getPageSize());
        return map;
    }
}
