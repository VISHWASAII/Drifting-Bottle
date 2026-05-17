package com.curious.drifiting_bottle.controller;

import com.curious.drifiting_bottle.model.Throw;
import com.curious.drifiting_bottle.service.BottleService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/bottle")
public class BottleController {

    private final BottleService bottleService;

    public BottleController(BottleService bottleService) {
        this.bottleService = bottleService;
    }

    @GetMapping("/receiver/{receiverId}")
    public ResponseEntity<String>
    getMessage(
            @PathVariable Long receiverId
    ) {

        Throw message = bottleService.getThrowMessage(receiverId);

        return ResponseEntity.ok(message.getMessage());
    }
}
