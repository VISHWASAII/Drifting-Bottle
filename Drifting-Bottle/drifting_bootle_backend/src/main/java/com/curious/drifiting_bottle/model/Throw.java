package com.curious.drifiting_bottle.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "throw")
@Data
public class Throw {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Long senderId;

    private Long receiverId;

    private String message;

    private boolean flag;
}
