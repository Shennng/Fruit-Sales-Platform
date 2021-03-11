package com.fruitsalesplatform.controller;

import com.fruitsalesplatform.entity.User;
import com.fruitsalesplatform.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Controller
@RequestMapping("user")
public class UserController {
    @Resource
    UserService userService;

    @RequestMapping("toLogin.action")
    public String toLogin() {
        return "/login.jsp";
    }

    @RequestMapping("login.action")
    public String login(User user, Model model, HttpServletRequest request) {
        Map<String,String> map = new HashMap<String,String>();
        map.put("username",user.getUsername());
        map.put("password",user.getPassword());
        List<User> userList=userService.find(map);
        if (userList!=null&&userList.size()>0){
//            model.addAttribute("user",userList.get(0));
            request.getSession().setAttribute("user",userList.get(0));
            return "/home.jsp";
        }
        model.addAttribute("errorMsg","登录失败！账号或密码错误！");
        model.addAttribute("noticeMsg","麻烦赶紧登录，谢谢~");
        return "/login.jsp";
    }

    @RequestMapping("toRegister.action")
    public String toRegister() {
        return "/register.jsp";
    }

    @RequestMapping("register.action")
    public String register(User user, Model model, HttpServletRequest request, HttpServletResponse response) throws  Exception {
        // 查找用户名是否已注册
        Map<String,String> map = new HashMap<String, String>();
        map.put("username",user.getUsername());
        List<User> userList = userService.find(map);
        if (userList!=null&&userList.size()>0) {
            model.addAttribute("errorMsg","注册失败，用户名已被占用!");
            return "/register.jsp";
        }
        user.setUserid(UUID.randomUUID().toString());  // 为用户设置UUID主键
        userService.insert(user);
        model.addAttribute("noticeMsg","注册成功！请输入账号、密码登录~");
        return "/login.jsp";  // 注册成功，跳转至登录界面
    }

    @RequestMapping("test.action")
    public String test() {
        return "/test/test.jsp";
    }
}
