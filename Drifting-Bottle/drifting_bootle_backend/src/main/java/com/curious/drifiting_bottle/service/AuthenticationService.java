package com.curious.drifiting_bottle.service;

import com.curious.drifiting_bottle.model.User;
import com.curious.drifiting_bottle.repository.AuthenticationRepo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AuthenticationService {

    private final AuthenticationRepo authenticationRepo;
    private static final Logger logger = LoggerFactory.getLogger(AuthenticationService.class);

    public AuthenticationService(AuthenticationRepo authenticationRepo) {
        this.authenticationRepo = authenticationRepo;
    }

    public void deleteAllUsers(){
        logger.info("Successfully Users Deleted from database....");
        authenticationRepo.deleteAll();
    }

    public List<User> insertUsers(List<User> users){
        authenticationRepo.saveAll(users);
        logger.info("Users stored Successfully....");
        return users;
    }

    public User authenticateUser(User user) {

        List<User> listOfUsers = authenticationRepo.findAll();

        logger.info("Authenticating user....");

        return listOfUsers.stream()
                .filter(users ->
                        users.getName().equals(user.getName()) &&
                                users.getPassword().equals(user.getPassword())
                )
                .findFirst()
                .orElse(null);
    }
}
