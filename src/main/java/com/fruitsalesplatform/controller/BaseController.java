package com.fruitsalesplatform.controller;

import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

// 所有controller都继承这个抽象类，公用的处理逻辑放在此处，减少代码冗余
public abstract class BaseController {
    @InitBinder
    // 用于日期转换，若页面日期格式转换错误，将报400错误
    public void initBinder(WebDataBinder binder) {
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        dateFormat.setLenient(true);
        binder.registerCustomEditor(Date.class,new CustomDateEditor(dateFormat,true));
    }

    public String checkStringIsEmpty(String param) {
        return param==null?null:("".equals(param)?null:"%"+param+"%");
    }
}
