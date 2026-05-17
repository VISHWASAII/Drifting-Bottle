package com.curious.drifiting_bottle.utils;

import com.curious.drifiting_bottle.repository.AuthenticationRepo;
import com.curious.drifiting_bottle.model.User;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

@Component
public class Settings {

    private final AuthenticationRepo authenticationRepo;

    public Settings(AuthenticationRepo authenticationRepo) {
        this.authenticationRepo = authenticationRepo;
    }

    public Long getRandomReceiver(
            Long senderId
    ) {

        List<Long> users =
                authenticationRepo.findAll()
                        .stream()
                        .map(User::getId)
                        .toList();

        List<Long> receivers =
                new ArrayList<>(users);

        receivers.remove(senderId);

        Random random = new Random();

        return receivers.get(
                random.nextInt(receivers.size())
        );
    }
}
