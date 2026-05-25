package com.curious.drifiting_bottle.service;

import com.curious.drifiting_bottle.model.Throw;
import com.curious.drifiting_bottle.repository.ThrowRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Random;

@Service
public class BottleService {

    private final ThrowRepository throwRepository;

    public BottleService(ThrowRepository throwRepository) {
        this.throwRepository = throwRepository;
    }

    public Throw getThrowMessage(Long receiverId) {
        List<Throw> messages = throwRepository.findAllByReceiverId(receiverId);
        if (messages.isEmpty()) return null;

        int randomIndex = new Random().nextInt(messages.size());
        return messages.get(randomIndex);
    }
}
