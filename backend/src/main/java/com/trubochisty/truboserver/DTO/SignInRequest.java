package com.trubochisty.truboserver.DTO;

import lombok.Data;

@Data
public class SignInRequest {
    private String username;
    private String password;
}
