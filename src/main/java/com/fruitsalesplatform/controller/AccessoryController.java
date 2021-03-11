package com.fruitsalesplatform.controller;

import com.fruitsalesplatform.entity.Accessory;
import com.fruitsalesplatform.service.AccessoryService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping("accessory")
public class AccessoryController extends BaseController {
    @Resource
    private AccessoryService accessoryService;

    @RequestMapping("list.action")
    public String list(Model model, Accessory accessory) {
        Map<String,Object> map = new HashMap<>();
        map.put("fruitId",accessory.getFruitId());
        List<Accessory> accessoryList = accessoryService.find(map);
        model.addAttribute("fruitId",accessory.getFruitId());
        model.addAttribute("list",accessoryList.size()<1?null:accessoryList);
        // 计算附属品价格并封装到Model中
        model.addAttribute("sumPrice",sumPrice(accessoryList));
        return "/accessory/accessoryHome.jsp";
    }

    private double sumPrice(List<Accessory> accessoryList) {
        double sumPrice = 0.0d;
        for (Accessory accessory: accessoryList) {
            sumPrice+=accessory.getPrice();
        }
        return sumPrice;
    }

    @RequestMapping("add.action")
    public String add(Model model,Accessory accessory) {
        accessory.setAccessoryId(UUID.randomUUID().toString());
        accessory.setCreateTime(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
        accessoryService.insert(accessory);
        return list(model,accessory);  // 需要fruitId
    }

    @RequestMapping("delete.action")
    public String delete(Model model,Accessory accessory) {
        accessoryService.deleteById(accessory.getAccessoryId());
        return list(model,accessory);  // 需要传入fruitId
    }

    @RequestMapping("deleteList.action")
    public String deleteList(Model model,String[] arrays,Accessory accessory) {
        accessoryService.delete(arrays);
        return list(model,accessory);  // 需要fruitId
    }
}
