package com.example.billingserv.config;

import com.example.billingserv.model.BaseException;
import com.google.gson.Gson;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

@ControllerAdvice
public class Handler extends ResponseEntityExceptionHandler {

    @ExceptionHandler(Exception.class)
    public ResponseEntity<BaseException> classNotFoundException(Exception e){
        String json = e.getLocalizedMessage();
        json = json.substring(7, json.length()-1);
        Gson gson = new Gson();
        BaseException exception = gson.fromJson(json, BaseException.class);
        return ResponseEntity.badRequest().body(exception);
    }
}


