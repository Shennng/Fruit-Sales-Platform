package com.fruitsalesplatform.controller;

import com.alibaba.fastjson.JSONObject;
import com.fruitsalesplatform.entity.Retailer;
import com.fruitsalesplatform.service.RetailerService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping("retailer")
public class RetailerController extends BaseController {
    @Resource
    private RetailerService retailerService;

    @RequestMapping("list.action")
    public String list(Model model, Retailer retailer,String startTime,String endTime) {
        Map<String,Object> map=this.retailerToMap(retailer);
        if (startTime!=null&&!startTime.equals("")){
            map.put("startTime",startTime);
        }
        if (endTime!=null&&endTime.equals("")) {
            map.put("endTime",endTime);
        }
        List<Retailer> retailerList = retailerService.find(map);
        // 搜索条件回显
        model.addAttribute("retailer",retailer);
        model.addAttribute("startTime",startTime);
        model.addAttribute("endTime",endTime);

        model.addAttribute("list",retailerList);
        model.addAttribute("currentPage",retailer.getCurrentPage());  // 当前页码
        model.addAttribute("startPage",retailer.getStartPage());  // 当前数据起始位置，默认为0
        int countNumber = retailerService.count(map);  // 计数
        model.addAttribute("countNumber",countNumber);  // 数据总条数
        int pageSize = retailer.getPageSize();
        model.addAttribute("pageSize",pageSize);  // 每页数据，默认10
        int sumPageNumber = countNumber % pageSize == 0 ? (countNumber/pageSize):(countNumber/pageSize+1);
        model.addAttribute("sumPageNumber",sumPageNumber);  // 总页数
        return "/retailer/retailerHome.jsp";
    }

    @RequestMapping("editPage.action")
    public @ResponseBody Retailer editPage(@RequestBody String json) throws IOException {
        String id = JSONObject.parseObject(json).getString("id");
        return retailerService.get(id);
    }

    @RequestMapping("editOne.action")
    public String editOne(Model model, Retailer retailer) {
        retailerService.update(retailer);
        Retailer queryRetailer = new Retailer();
        queryRetailer.setStartPage(retailer.getStartPage());
        queryRetailer.setCurrentPage(retailer.getCurrentPage());
        queryRetailer.setPageSize(retailer.getPageSize());
        queryRetailer.setStatus(-1);
        return list(model,queryRetailer,null,null);
    }

    @RequestMapping("deleteOne.action")
    public String deleteOne(Model model,Retailer retailer) {
        retailerService.deleteById(retailer.getRetailerId());
        Retailer queryRetailer = new Retailer();
        queryRetailer.setStartPage(retailer.getStartPage());
        queryRetailer.setCurrentPage(retailer.getCurrentPage());
        queryRetailer.setPageSize(retailer.getPageSize());
        queryRetailer.setStatus(-1);
        return list(model,queryRetailer,null,null);
    }

    @RequestMapping("addOne.action")
    public String addOne(Model model,Retailer retailer) {
        retailer.setRetailerId(UUID.randomUUID().toString());
        retailer.setCreateTime(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));  // 当前时间
        retailerService.insert(retailer);
        Retailer queryRetailer = new Retailer();
        queryRetailer.setStatus(-1);
        return list(model,queryRetailer,null,null);
    }

    private Map<String,Object> retailerToMap(Retailer retailer) {
        Map<String,Object> map=new HashMap<>();
        map.put("name",checkStringIsEmpty(retailer.getName()));
        map.put("telephone",checkStringIsEmpty(retailer.getTelephone()));
        map.put("address",checkStringIsEmpty(retailer.getAddress()));
        map.put("status",retailer.getStatus()==-1?null:retailer.getStatus());
        map.put("createTime","".equals(retailer.getCreateTime())?null:retailer.getCreateTime());
        map.put("startPage",retailer.getStartPage());
        map.put("pageSize",retailer.getPageSize());
        return map;
    }
}
