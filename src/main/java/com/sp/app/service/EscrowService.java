package com.sp.app.service; // 본인의 프로젝트 패키지 경로에 맞게 수정해 주세요.

import java.util.Map;

public interface EscrowService {
    
    /**
     * 안전결제(에스크로) 결제 및 포인트 차감 처리
     * @param paramMap (buyerIdx, sellerIdx, productIdx, totalUsedPoint 등)
     * @throws Exception 트랜잭션 롤백을 위한 예외 처리
     */
    void processEscrowPayment(Map<String, Object> paramMap) throws Exception;
    
}