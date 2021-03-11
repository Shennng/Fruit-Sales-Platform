package com.fruitsalesplatform.controller;

import com.fruitsalesplatform.entity.User;
import com.fruitsalesplatform.service.TestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("test")
public class TestController {
    @Autowired
    private TestService testService;

    @RequestMapping("/findUser.action")
    private String findUser(User user, Model model) {
        List<User> userList=testService.findUserByName(user);
        model.addAttribute("userList",userList);
        return "/test/test.jsp";
    }
}
