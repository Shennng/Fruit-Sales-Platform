package com.fruitsalesplatform.interceptor;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class LoginInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String uri=request.getRequestURI();
        if (!(uri.contains("Login")||uri.contains("login")||uri.contains("register")||uri.contains("Register"))){
            // 非登录/注册请求
            if (request.getSession().getAttribute("user")!=null){
                return true;  // 当前请求为已登陆状态下的普通请求，放行
            }else if (uri.contains("css")||uri.contains("js")||uri.contains("images")) {
                return true; //不管登陆不登陆，访问静态资源直接放行
            }else {
                // 没有登陆，但访问的是需要登陆才能访问的页面
                System.out.println("重定向了链接！");
                response.sendRedirect(request.getContextPath()+"/user/toLogin.action");
            }
        } else {
            // 登录请求
            return true;
        }
        return false;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {

    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {

    }
}
