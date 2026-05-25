package com.curious.drifiting_bottle.repository;

import com.curious.drifiting_bottle.model.Throw;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ThrowRepository extends JpaRepository<Throw, Long> {

    List<Throw> findAllByReceiverId(Long receiverId);

    boolean existsByReceiverIdAndFlagTrue(Long receiverId);
}
