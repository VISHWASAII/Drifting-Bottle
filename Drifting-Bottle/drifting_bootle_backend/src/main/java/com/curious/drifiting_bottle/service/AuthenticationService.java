package com.curious.drifiting_bottle.service;

import com.curious.drifiting_bottle.dto.LoginDTO;
import com.curious.drifiting_bottle.model.Registration;
import com.curious.drifiting_bottle.model.TokenPair;
import com.curious.drifiting_bottle.repository.AuthenticationRepo;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;


import java.util.Collection;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AuthenticationService implements UserDetailsService {

    private final AuthenticationRepo authenticationRepo;
    private final JwtService jwtService;

    @Lazy
    @Autowired
    private  AuthenticationManager authenticationManager;

    private static final Logger logger = LoggerFactory.getLogger(AuthenticationService.class);


    public TokenPair login(LoginDTO user){

        System.out.println("LOGIN START");

        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        user.getUsername(),
                        user.getPassword()
                )
        );

        System.out.println("AUTH SUCCESS");

        SecurityContextHolder.getContext().setAuthentication(authentication);

        TokenPair tokenPair = jwtService.generateTokenPair(authentication);

        System.out.println("TOKEN GENERATED");

        return tokenPair;
    }


    public Boolean existsByName(String name) {
        return null;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        Registration user = authenticationRepo.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));
        return user;
    }

    private Collection<? extends GrantedAuthority> getAuthority(Registration user) {
        GrantedAuthority autority = new SimpleGrantedAuthority(user.getRole().name());
        return List.of(autority);
    }
}
