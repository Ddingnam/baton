package com.sp.app.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PaymentViewController {

    @GetMapping("/payment/test")
    public String showPaymentTestPage() {
   
        return "paymentTest"; 
    }
}
