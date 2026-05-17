package com.curious.drifiting_bottle.service;

import com.curious.drifiting_bottle.model.Throw;
import com.curious.drifiting_bottle.repository.ThrowRepository;
import com.curious.drifiting_bottle.utils.Settings;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ThrowService {

    private final Settings settings;
    private final ThrowRepository throwRepository;

    public ThrowService(Settings settings, ThrowRepository throwRepository) {
        this.settings = settings;
        this.throwRepository = throwRepository;
    }

    public Throw sendMessage(Long senderId, String text){
        Long receiverId =settings.getRandomReceiver(senderId);
        Throw throwMessage = new Throw();

        throwMessage.setSenderId(senderId);
        throwMessage.setReceiverId(receiverId);
        throwMessage.setMessage(text);

        return throwRepository.save(throwMessage);
    }

    public List<Throw> getAllThrows(){
        return throwRepository.findAll();
    }

    public void deleteAllThrows(){
        throwRepository.deleteAll();
    }
}
