package com.curious.drifiting_bottle.repository;

import com.curious.drifiting_bottle.model.Registration;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface AuthenticationRepo extends JpaRepository<Registration, Long> {
    Optional<Registration> findByUsername(String username);

    Boolean existsByUsername(String username);
}
