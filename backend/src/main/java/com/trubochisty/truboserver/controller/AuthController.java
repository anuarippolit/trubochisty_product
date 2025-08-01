package com.trubochisty.truboserver.controller;

import com.trubochisty.truboserver.DTO.*;
import com.trubochisty.truboserver.model.*;
import com.trubochisty.truboserver.service.UserService;
import com.trubochisty.truboserver.service.AuthenticationService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.apache.tomcat.util.net.openssl.ciphers.Authentication;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {
    private final AuthenticationService authenticationService;
    private final UserService userService;

    @PostMapping("/sign-in")
    public JwtAuthenticationResponse signIn(@Valid @RequestBody SignInRequest request) {
        return authenticationService.signIn(request);
    }

    @PostMapping("/validate")
    public ResponseEntity<HashMap<String, Boolean>> validate(@RequestParam("token") String token) {
        boolean isValid = authenticationService.validateToken(token);

        HashMap<String, Boolean> response = new HashMap<>();
        response.put("valid", isValid);

        if (!isValid) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

        return ResponseEntity.ok(response);
    }

    @PostMapping("/sign-up")
    public ResponseEntity<JwtAuthenticationResponse> signUp(
            @RequestBody SignUpRequest request,
            @AuthenticationPrincipal UserDetails requester
    ) {
        JwtAuthenticationResponse response = authenticationService.signUp(request, requester);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @GetMapping("/me")
    public ResponseEntity<UserSummaryDTO> getCurrentUser() {
        User user = userService.getCurrentUser();
        UserSummaryDTO dto = UserMapper.mapToUserSummaryDTO(user);
        return ResponseEntity.ok(dto);
    }




    /*@PostMapping("/refresh")
    public JwtAuthenticationResponse refreshToken(@RequestParam("refreshToken") String refreshToken) {
        return authenticationService.refreshToken(refreshToken);
    }*/

    /*@GetMapping("/me")
    public ResponseEntity<UserInfoResponse> getCurrentUser(Authentication authentication) {
        return ResponseEntity.ok(authenticationService.getUserInfo(authentication));
    }*/

    //хз понадобится или нет, смотря будет ли хранилище
    /*@PostMapping("/logout")
    public ResponseEntity<Void> logout(@RequestParam("token") String token) {
        authenticationService.logout(token);
        return ResponseEntity.noContent().build();
    }*/



}
