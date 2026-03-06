package com.sp.app.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import com.sp.app.domain.entity.PollOption;

public interface PollOptionRepository extends JpaRepository<PollOption, Long> {
}