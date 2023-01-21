package com.example.billingserv.config;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import org.springdoc.core.GroupedOpenApi;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.Arrays;
import java.util.Collections;

@Configuration
public class SwaggerConfiguration {

    @Bean
    public GroupedOpenApi adminApi() {
        return GroupedOpenApi.builder().group("default").pathsToMatch("/**").build();
    }

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("Billing Service")
                        .description("This page contains marketplace APIs")
                        .contact(new Contact().name("").email(""))
                        .version("1.0")
                        .license(new License().name("License of API").url("https://www.fido-biznes.uz/#/"))
                        .termsOfService("Terms of service"));
    }
}
