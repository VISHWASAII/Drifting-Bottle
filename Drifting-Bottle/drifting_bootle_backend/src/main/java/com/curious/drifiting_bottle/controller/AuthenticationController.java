package com.curious.drifiting_bottle.controller;

import com.curious.drifiting_bottle.dto.LoginDTO;
import com.curious.drifiting_bottle.model.Registration;
import com.curious.drifiting_bottle.model.TokenPair;
import com.curious.drifiting_bottle.service.AuthenticationService;
import com.curious.drifiting_bottle.service.RegistrationService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/auth")
public class AuthenticationController {

    private final AuthenticationService authenticationService;
    private final RegistrationService registrationService;

    @PostMapping("/registration")
    public ResponseEntity<Registration> registerUser(@Valid @RequestBody Registration user){
        Registration newUser = registrationService.registerUser(user);
        return new ResponseEntity<>(newUser, HttpStatus.CREATED);
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@Valid @RequestBody LoginDTO user){
        TokenPair tokenPair = authenticationService.login(user);
        return ResponseEntity.ok(tokenPair);
    }
}
