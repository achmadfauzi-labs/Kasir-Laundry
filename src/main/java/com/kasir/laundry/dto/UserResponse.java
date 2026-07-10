package com.kasir.laundry.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserResponse {

    private Long id;
    private String username;
    private String email;
    
    @JsonProperty("full_name")
    private String fullName;
    
    @JsonProperty("phone_number")
    private String phoneNumber;
}
