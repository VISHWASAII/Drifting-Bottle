package com.curious.drifiting_bottle.controller;


import com.curious.drifiting_bottle.model.ChatMessage;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

@Controller
@RequiredArgsConstructor
public class ChatController {

    private final SimpMessagingTemplate messagingTemplate;

    @MessageMapping("/private-message")
    @SendTo("/topic/messages")
    public ChatMessage send(ChatMessage message) {

        System.out.println(message);

        return message;
    }
}
