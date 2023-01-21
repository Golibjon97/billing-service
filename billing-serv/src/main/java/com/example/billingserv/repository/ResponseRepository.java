package com.example.billingserv.repository;

import com.example.billingserv.model.Ws_notification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface ResponseRepository extends JpaRepository<Ws_notification, Integer> {

    @Procedure(procedureName = "ws_transporter.accept_request", outputParameterName = "resp")
    String accept_request(@Param("notification") String notification);

}
