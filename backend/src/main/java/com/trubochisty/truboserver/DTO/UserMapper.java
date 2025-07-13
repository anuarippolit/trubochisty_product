package com.trubochisty.truboserver.DTO;

import com.trubochisty.truboserver.model.Culvert;
import com.trubochisty.truboserver.model.User;

import java.util.stream.Collectors;

import static com.trubochisty.truboserver.DTO.CulvertMapper.mapToCulvertSummaryDTO;

public class UserMapper {
    public static UserSummaryDTO mapToUserSummaryDTO(User user) {
        return UserSummaryDTO.builder()
                .id(user.getId())
                .username(user.getUsername())
                .phoneNumber(user.getPhoneNumber())
                .email(user.getEmail())
                .role(user.getRole())
                .build();
    }

    public static UserDetailDTO mapToUserDetailDTO(User user) {
        return UserDetailDTO.builder()
                .id(user.getId())
                .username(user.getUsername())
                .phoneNumber(user.getPhoneNumber())
                .email(user.getEmail())
                .role(user.getRole())
                .culverts(
                        user.getCulverts().stream()
                                .map(CulvertMapper::mapToCulvertSummaryDTO) // <--- здесь передаётся по одному
                                .collect(Collectors.toList())
                )
                .build();
    }

}
