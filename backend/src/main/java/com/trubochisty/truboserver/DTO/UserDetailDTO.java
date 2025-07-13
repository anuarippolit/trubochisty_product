package com.trubochisty.truboserver.DTO;

import com.trubochisty.truboserver.model.Role;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

// UserDTO.java
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserDetailDTO {
    private String id;
    private String username;
    private String phoneNumber;
    private String email;
    private Role role;
    private List<CulvertSummaryDTO> culverts;
}

