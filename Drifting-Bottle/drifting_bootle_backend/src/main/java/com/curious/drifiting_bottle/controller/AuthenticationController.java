package com.curious.drifiting_bottle.controller;

import com.curious.drifiting_bottle.repository.AuthenticationRepo;
import com.curious.drifiting_bottle.service.AuthenticationService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.curious.drifiting_bottle.model.User;

import java.util.List;

@RestController
@RequestMapping("/api/login")
public class AuthenticationController {

    private final AuthenticationService authenticationService;

    public AuthenticationController(AuthenticationService authenticationService) {
        this.authenticationService = authenticationService;
    }

    @PostMapping("Mock-insertion")
    public ResponseEntity<List<User>>  insertingMockValues(@RequestBody List<User> users){
        List<User> allusers = authenticationService.insertUsers(users);
        return new ResponseEntity<>(allusers, HttpStatus.CREATED);
    }

    @DeleteMapping("/Mock-deletion")
    public ResponseEntity<Void> deleteMockValues() {
        authenticationService.deleteAllUsers();
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/authenticate")
    public ResponseEntity<User> authenticateUser(@RequestBody User user) {

        User authenticatedUser = authenticationService.authenticateUser(user);

        if (authenticatedUser != null) {
            return ResponseEntity.ok(authenticatedUser);
        }

        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
    }
}
