package com.curious.drifiting_bottle.service;

import com.curious.drifiting_bottle.model.Registration;
import com.curious.drifiting_bottle.model.Role;
import com.curious.drifiting_bottle.model.Status;
import com.curious.drifiting_bottle.repository.AuthenticationRepo;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class RegistrationService {

    private final PasswordEncoder passwordEncoder;
    private final AuthenticationRepo authenticationRepo;

    @Transactional
    public Registration registerUser(Registration user){

        if(authenticationRepo.existsByUsername(user.getUsername())){
            throw new IllegalArgumentException("Username is already in use");
        }else{

            Registration newUser = Registration.builder()
                    .username(user.getUsername())
                    .email(user.getEmail())
                    .password(passwordEncoder.encode(user.getPassword()))
                    .confirmPassword(user.getConfirmPassword())
                    .role(Role.ROLE_USER)
                    .status(Status.ONLINE)
                    .build();

            return authenticationRepo.save(newUser);
        }
    }
}
