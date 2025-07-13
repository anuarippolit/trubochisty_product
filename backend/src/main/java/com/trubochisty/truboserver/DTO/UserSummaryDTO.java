package com.trubochisty.truboserver.DTO;

import com.trubochisty.truboserver.model.Role;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

// UserDTO.java
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserSummaryDTO {
    private String id;
    private String username;
    private String phoneNumber;
    private String email;
    private Role role;
}

