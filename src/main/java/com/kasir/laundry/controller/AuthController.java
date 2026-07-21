package com.kasir.laundry.controller;

import com.kasir.laundry.dto.ApiResponse;
import com.kasir.laundry.dto.LoginRequest;
import com.kasir.laundry.dto.LoginResponse;
import com.kasir.laundry.dto.RegisterRequest;
import com.kasir.laundry.dto.UserResponse;
import com.kasir.laundry.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/register")
    public ResponseEntity<ApiResponse<UserResponse>> register(@Valid @RequestBody RegisterRequest request) {
        try {
            UserResponse data = authService.register(request);
            ApiResponse<UserResponse> response = new ApiResponse<>("User registered successfully", data);
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(new ApiResponse<>(e.getMessage(), null));
        }
    }

    @PostMapping("/login")
    public ResponseEntity<ApiResponse<LoginResponse>> login(@Valid @RequestBody LoginRequest request) {
        try {
            LoginResponse data = authService.login(request);
            ApiResponse<LoginResponse> response = new ApiResponse<>("User logged in successfully", data);
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(new ApiResponse<>(e.getMessage(), null));
        }
    }
}
