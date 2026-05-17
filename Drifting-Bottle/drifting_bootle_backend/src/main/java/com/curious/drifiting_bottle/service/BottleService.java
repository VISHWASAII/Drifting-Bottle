package com.curious.drifiting_bottle.service;

import com.curious.drifiting_bottle.model.Throw;
import com.curious.drifiting_bottle.repository.ThrowRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BottleService {

    private final ThrowRepository throwRepository;

    public BottleService(ThrowRepository throwRepository) {
        this.throwRepository = throwRepository;
    }

    public Throw getThrowMessage(Long receiverId){
        return throwRepository.findByReceiverId(receiverId).orElse(null);
    }
}
