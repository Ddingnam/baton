package com.sp.app.scheduler;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import com.sp.app.service.EscrowService;

@Component
public class EscrowScheduler {
    
    private final EscrowService escrowService;

    public EscrowScheduler(EscrowService escrowService) {
        this.escrowService = escrowService;
    }

    @Scheduled(cron = "0 0 0 * * *")
    public void autoConfirmProcess() throws Exception {
        escrowService.autoConfirmPurchases();
    }
}