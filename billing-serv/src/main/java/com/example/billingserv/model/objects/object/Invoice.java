package com.example.billingserv.model.objects.object;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class Invoice {
    private String requestId;
    private int serviceId;
    private int departmentId;
    private String note;
    private int amount;
    private String[] discounts;
}
