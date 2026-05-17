package com.curious.drifiting_bottle.controller;

/*
Derangement + Queue Algorithm

Because your rules are:

1. Every sender message goes to exactly one user
2. No user receives 2 messages in same cycle
3. Sender should not receive own message
4. Random distribution needed
5. Simple + fast

This is NOT a load-balancer problem.
* */

import com.curious.drifiting_bottle.model.Throw;
import com.curious.drifiting_bottle.service.ThrowService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/throw")
public class ThrowController {

    private final ThrowService throwService;

    public ThrowController(ThrowService throwService) {
        this.throwService = throwService;
    }

    @PostMapping("/sendMessage")
    public ResponseEntity<Throw> throwMessage(Long senderId, String text){
        Throw sendToReceive = throwService.sendMessage(senderId, text);
        return new ResponseEntity<>(sendToReceive, HttpStatus.ACCEPTED);
    }

    @GetMapping("/Mock-GetAllThrows")
    public ResponseEntity<List<Throw>> getAllThrows(){
        List<Throw> allThrows = throwService.getAllThrows();
        return new ResponseEntity<>(allThrows, HttpStatus.OK);
    }

    @DeleteMapping("/Mock-DeleteAllThrows")
    public ResponseEntity<Void> deleteAllThrows(){
        throwService.deleteAllThrows();
        return new ResponseEntity<>(HttpStatus.OK);
    }
}
