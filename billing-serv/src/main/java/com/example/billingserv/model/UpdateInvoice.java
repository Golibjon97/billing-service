package com.example.billingserv.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UpdateInvoice {
    private String note;
    private Integer amount;
    private String paymentTerms;
}
