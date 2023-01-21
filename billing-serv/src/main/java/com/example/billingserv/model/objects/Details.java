package com.example.billingserv.model.objects;

import com.example.billingserv.model.objects.object.Invoice;
import com.example.billingserv.model.objects.object.Payer;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class Details {
    private Invoice invoice;
    private Payer payer;

}
