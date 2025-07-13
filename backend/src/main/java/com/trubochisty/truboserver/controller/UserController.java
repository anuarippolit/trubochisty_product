package com.trubochisty.truboserver.controller;


import com.trubochisty.truboserver.DTO.UserDetailDTO;
import com.trubochisty.truboserver.DTO.UserMapper;
import com.trubochisty.truboserver.DTO.UserSummaryDTO;
import com.trubochisty.truboserver.model.Culvert;
import com.trubochisty.truboserver.model.User;
import com.trubochisty.truboserver.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @GetMapping("/test")
    public String test() {
        return "User API test";
    }

    @GetMapping
    public ResponseEntity<List<UserSummaryDTO>> getAllUsers() {
        return ResponseEntity.ok(userService.getAllUsers().stream().map(UserMapper::mapToUserSummaryDTO).collect(Collectors.toList()));
    }
}
