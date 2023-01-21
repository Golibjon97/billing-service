package com.example.billingserv.service;

import com.example.billingserv.model.UpdateInvoice;
import com.example.billingserv.model.objects.Details;
import org.springframework.http.*;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;
import java.sql.SQLOutput;
import java.util.Base64;

@Service
public class BillingService{

//    private static final String CONS = "http://192.168.90.22:8181/";                // Test   api.billing.birdarcha.uz
//    private static final String AUTHSTR = "dQRx1cN9avrLuzwsYCIacKQqWjtL1u12:";      // Test

    private static final String CONS = "https://api.staging.billing.birdarcha.uz/"; // localhost
    private static final String AUTHSTR = "zfMUxwpz0jhgZN2fHepY6WnwSZK2NM44:";      // localhost

    private static final String BASE64CREDS = Base64.getEncoder().encodeToString(AUTHSTR.getBytes()); // encoding the login and password

    public Object saveInvoice(Details details){
        String url= CONS + "v2/invoice/create";

        // create headers
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.add("Authorization", "Basic " + BASE64CREDS);   // adding the authorization to headers

        RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new MappingJackson2HttpMessageConverter());
        //restTemplate.getMessageConverters().add(0, new StringHttpMessageConverter(StandardCharsets.UTF_8));
        HttpEntity request = new HttpEntity(details,headers);

        ResponseEntity<Object> response = restTemplate.exchange(url, HttpMethod.POST, request, Object.class);
        return response.getBody();
    }

    public Object getInvoiceInfo(String serial){         //  Запрос сведений об инвойсе по серийному номеру инвойса (GET)

        String url= CONS + "v2/invoice/";

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.add("Authorization", "Basic " + BASE64CREDS);

        HttpEntity request = new HttpEntity(headers);
        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<Object> response = restTemplate.exchange(url + serial, HttpMethod.GET, request, Object.class);
        return response.getBody();
    }

    public Object failedEvents(String date){
        String url= CONS + "v2/events/failed?date=" + date;

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.add("Authorization", "Basic " + BASE64CREDS);

        HttpEntity request = new HttpEntity(headers);
        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<Object> response = restTemplate.exchange(url , HttpMethod.GET, request, Object.class);
        System.out.println(url+date);
        return response.getBody();
    }

    public Object rejectInvoice(String id){
        String url= CONS + "v2/invoice/reject?id=" + id;

        // create headers
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.add("Authorization", "Basic " + BASE64CREDS);   // adding the authorization to headers

        HttpEntity request = new HttpEntity(headers);
        RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new MappingJackson2HttpMessageConverter());

        ResponseEntity<Object> response = restTemplate.exchange(url, HttpMethod.DELETE, request, Object.class);
        System.out.println("response = " + response);
        return response.getBody();
    }

    public Object openInvoice(String id){
        String url= CONS + "v2/invoice/open?id=" + id;

        // create headers
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.add("Authorization", "Basic " + BASE64CREDS);   // adding the authorization to headers

        HttpEntity request = new HttpEntity(headers);
        RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new MappingJackson2HttpMessageConverter());

        ResponseEntity<Object> response = restTemplate.exchange(url, HttpMethod.PUT, request, Object.class);
        System.out.println("response = " + response);
        return response.getBody();
    }

    public Object updateInvoice(UpdateInvoice updateInvoice, String serial){

        String url= CONS + "v2/invoice/";

        // create headers
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.add("Authorization", "Basic " + BASE64CREDS);   // adding the authorization to headers

        HttpEntity request = new HttpEntity(updateInvoice,headers);

        RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new MappingJackson2HttpMessageConverter());
        ResponseEntity<Object> response = restTemplate.exchange(url + serial, HttpMethod.PUT, request, Object.class);
        return response.getBody();
    }

}

