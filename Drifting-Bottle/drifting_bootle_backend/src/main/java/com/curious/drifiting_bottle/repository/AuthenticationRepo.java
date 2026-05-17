package com.curious.drifiting_bottle.repository;

import com.curious.drifiting_bottle.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AuthenticationRepo extends JpaRepository<User, Long> {

}
