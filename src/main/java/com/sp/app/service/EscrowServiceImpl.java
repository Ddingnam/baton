package com.sp.app.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sp.app.mapper.PaymentMapper;

import java.util.HashMap;
import java.util.Map;

@Service
public class EscrowServiceImpl implements EscrowService {

    private final PaymentMapper paymentMapper;

    public EscrowServiceImpl(PaymentMapper paymentMapper) {
        this.paymentMapper = paymentMapper;
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public void processEscrowPayment(Map<String, Object> paramMap) throws Exception {

    	int count = paymentMapper.checkTradeExist(Long.parseLong(paramMap.get("productIdx").toString()));
        if (count > 0) {
            throw new RuntimeException("이미 안전결제가 완료되거나 진행 중인 상품입니다.");
        }

        int result = paymentMapper.deductPointForEscrow(paramMap);
        if (result == 0) {
            throw new RuntimeException("포인트 잔액이 부족하여 결제를 진행할 수 없습니다.");
        }

        paymentMapper.insertTradeTransaction(paramMap);

        long buyerIdx = Long.parseLong(paramMap.get("buyerIdx").toString());
        int currentPoint = paymentMapper.getCurrentPoint(buyerIdx);
        paramMap.put("totalPoint", currentPoint);

        paymentMapper.insertPointHistoryForEscrow(paramMap);
    }
    
    @Override
    public void updateShippingInfo(Map<String, Object> paramMap) throws Exception {
        try {
            paymentMapper.updateShippingInfo(paramMap);
        } catch (Exception e) {
            throw e;
        }
    }
    
    @Transactional(rollbackFor = Exception.class)
    @Override
    public void confirmPurchase(long productIdx, long buyerIdx) throws Exception {
        try {
            Map<String, Object> tradeInfo = paymentMapper.getTradeTransactionByProduct(productIdx);
            
            if (tradeInfo == null || !"SHIPPING".equals(tradeInfo.get("TRADESTATUS"))) {
                throw new Exception("구매 확정을 할 수 없는 상태입니다.");
            }
            
            long dbBuyerIdx = Long.parseLong(tradeInfo.get("BUYERIDX").toString());
            if (dbBuyerIdx != buyerIdx) {
                throw new Exception("구매자 본인만 확정할 수 있습니다.");
            }

            int result = paymentMapper.confirmTradeStatus(productIdx);
            if (result == 0) {
                throw new Exception("상태 업데이트 실패");
            }

            long sellerIdx = Long.parseLong(tradeInfo.get("SELLERIDX").toString());
            
            int totalUsedPoint = Integer.parseInt(tradeInfo.get("TOTALUSED_POINT").toString());
            int safetyFee = Integer.parseInt(tradeInfo.get("SAFETYFEE").toString());
            
            int settlementAmount = totalUsedPoint - safetyFee;

            Map<String, Object> pointMap = new HashMap<>();
            pointMap.put("sellerIdx", sellerIdx);
            pointMap.put("settlementAmount", settlementAmount);
            paymentMapper.addSellerPoint(pointMap);

            int currentPoint = paymentMapper.getCurrentPoint(sellerIdx);

            Map<String, Object> historyMap = new HashMap<>();
            historyMap.put("tradeIdx", tradeInfo.get("TRADEIDX"));
            historyMap.put("settlementAmount", settlementAmount);
            historyMap.put("sellerIdx", sellerIdx);
            historyMap.put("totalPoint", currentPoint);
            paymentMapper.insertPointHistoryForSeller(historyMap);
            paymentMapper.updateArticleStatusToSoldOut(productIdx);
        } catch (Exception e) {
            throw e;
        }
    }
    
    @Override
    public int checkTradeExist(long productIdx) throws Exception {
        try {
            return paymentMapper.checkTradeExist(productIdx);
        } catch (Exception e) {
            throw e;
        }
    }
    
    @Override
    public Map<String, Object> getTradeTransaction(long productIdx) throws Exception {
        try {
            return paymentMapper.getTradeTransactionByProduct(productIdx);
        } catch (Exception e) {
            throw e;
        }
    }
    
    @Transactional(rollbackFor = Exception.class)
    @Override
    public void cancelTrade(long productIdx, long userIdx) throws Exception {
        Map<String, Object> tradeInfo = paymentMapper.getTradeTransactionByProduct(productIdx);
   
        if (tradeInfo == null || !"PAY_COMPLETED".equals(tradeInfo.get("TRADESTATUS"))) {
            throw new RuntimeException("취소할 수 없는 상태이거나 거래가 존재하지 않습니다.");
        }
        
        long buyerIdx = Long.parseLong(tradeInfo.get("BUYERIDX").toString());
        long sellerIdx = Long.parseLong(tradeInfo.get("SELLERIDX").toString());

        if (userIdx != buyerIdx && userIdx != sellerIdx) {
            throw new RuntimeException("취소 권한이 없습니다.");
        }
    
        int result = paymentMapper.cancelTradeTransaction(productIdx);
        if (result == 0) {
            throw new RuntimeException("거래 취소 처리에 실패했습니다.");
        }

        paymentMapper.updateArticleStatusToOnSale(productIdx);

        int refundAmount = Integer.parseInt(tradeInfo.get("TOTALUSED_POINT").toString());
        
        Map<String, Object> pointMap = new HashMap<>();
        pointMap.put("buyerIdx", buyerIdx);
        pointMap.put("refundAmount", refundAmount);
        paymentMapper.refundBuyerPoint(pointMap);
 
        int currentPoint = paymentMapper.getCurrentPoint(buyerIdx);
        
        Map<String, Object> historyMap = new HashMap<>();
        historyMap.put("tradeIdx", tradeInfo.get("TRADEIDX"));
        historyMap.put("refundAmount", refundAmount);
        historyMap.put("buyerIdx", buyerIdx);
        historyMap.put("totalPoint", currentPoint);
        paymentMapper.insertPointHistoryForRefund(historyMap);
    }
    
    @Override
    public String getUserAddress(long userIdx) throws Exception {
        try {
            return paymentMapper.getUserAddress(userIdx);
        } catch (Exception e) {
            throw e;
        }
    }
}