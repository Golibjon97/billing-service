package com.example.billingserv.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class BaseException {

    private String timestamp;
    private Integer status;
    private String statusCode;
    private String message;
    private String details;
    private String path;
}
