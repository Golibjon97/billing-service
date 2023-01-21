package com.example.billingserv.controller;

import com.example.billingserv.model.UpdateInvoice;
import com.example.billingserv.model.objects.Details;
import com.example.billingserv.service.BillingService;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/v2")
@AllArgsConstructor
public class BillingController {

    private BillingService billingService;

    /**
     * 1)Заявка на формирование инвойса
     */
    @PostMapping(value = "/invoice/create")
    public ResponseEntity saveInvoice(@RequestBody Details details) {
        System.out.println(details.getPayer().getName());
        return ResponseEntity.ok(billingService.saveInvoice(details));
    }


    /**
     * 3)Запрос сведений об инвойсе по серийному номеру инвойса
     */
    @GetMapping("/invoice/{serial}")
    public ResponseEntity receiveResponse(@PathVariable("serial") String serial) {
        return ResponseEntity.ok(billingService.getInvoiceInfo(serial));
    }

    /**
     * 4)Запрос сведений о непринятых платежах
     */
    @GetMapping("/events/failed")
    public ResponseEntity failedEvents(@RequestParam String date){
        return ResponseEntity.ok(billingService.failedEvents(date));
    }

    /**
     * 5)Аннулирование инвойса
     */
    @DeleteMapping("/invoice/reject")
    public Object rejectInvoice(@RequestParam String id){
        return billingService.rejectInvoice(id);
    }

    /**
     * 6)Восстановление инвойса
     */
    @PutMapping("/invoice/open")    // invoice?id=124124214114
    public Object openInvoice(@RequestParam String id){
        return billingService.openInvoice(id);
    }

    /**
     * Изменение цену инвойса
     */
    @PutMapping("/invoice/{serial}")    // invoice/12312314421
    public Object updateInvoice(@PathVariable("serial") String serial, @RequestBody UpdateInvoice updateInvoice){
        return billingService.updateInvoice(updateInvoice, serial);
    }

    @GetMapping("/test")
    public String test(){
        return "Working";
    }


}
