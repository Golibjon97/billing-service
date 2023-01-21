package com.example.billingserv.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class Billing {
    private String requestId;
    private int serviceId;
    private int departmentId;
    private String note;
    private int amount;
    private String name;
    private int type;

}
