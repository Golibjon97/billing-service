package com.example.billingserv.controller;

import com.example.billingserv.model.RequestException;
import com.example.billingserv.repository.ResponseRepository;
import com.google.gson.Gson;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/v2/invoice")
public class ResponseController {

    private ResponseRepository responseRepository;

    public ResponseController(ResponseRepository responseRepository) {
        this.responseRepository = responseRepository;
    }

    /**
     * 2)Получение уведомлений об оплате
     */
    @PostMapping("/send")
    public RequestException sendNotification(@RequestBody String notification){
        String temp = responseRepository.accept_request(notification);
        Gson gson = new Gson();
        return gson.fromJson(temp, RequestException.class);
    }

}

