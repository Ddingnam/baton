package com.sp.app.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sp.app.mapper.PaymentMapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class EscrowServiceImpl implements EscrowService {

    private final PaymentMapper paymentMapper;
    private final NotificationService notificationService;

    public EscrowServiceImpl(PaymentMapper paymentMapper, NotificationService notificationService) {
        this.paymentMapper = paymentMapper;
        this.notificationService = notificationService;
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
        long sellerIdx = Long.parseLong(paramMap.get("sellerIdx").toString());
        long productIdx = Long.parseLong(paramMap.get("productIdx").toString());
        
        int currentPoint = paymentMapper.getCurrentPoint(buyerIdx);
        paramMap.put("totalPoint", currentPoint);

        paymentMapper.insertPointHistoryForEscrow(paramMap);
        
        notificationService.sendNotification(sellerIdx, "안전결제", "게시물에 안전결제가 접수되었습니다. 운송장을 입력해주세요.", "/trade/article?productIdx=" + productIdx);
    }
    
    @Override
    public void updateShippingInfo(Map<String, Object> paramMap) throws Exception {
        try {
            paymentMapper.updateShippingInfo(paramMap);
            
            long productIdx = Long.parseLong(paramMap.get("productIdx").toString());
            Map<String, Object> tradeInfo = paymentMapper.getTradeTransactionByProduct(productIdx);
            long buyerIdx = Long.parseLong(tradeInfo.get("BUYERIDX").toString());
            
            notificationService.sendNotification(buyerIdx, "배송시작", "판매자가 상품 발송을 완료했습니다. 운송장 번호를 확인해주세요.", "/trade/article?productIdx=" + productIdx);
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
            
            notificationService.sendNotification(sellerIdx, "구매확정", "구매자가 상품 구매를 확정하여 포인트 정산이 완료되었습니다.", "/trade/article?productIdx=" + productIdx);
        } catch (Exception e) {
            throw e;
        }
    }
    
    @Override
    public int checkTradeExist(long productIdx) throws Exception {
        return paymentMapper.checkTradeExist(productIdx);
    }
    
    @Override
    public Map<String, Object> getTradeTransaction(long productIdx) throws Exception {
        return paymentMapper.getTradeTransactionByProduct(productIdx);
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
        
        if(userIdx == buyerIdx) {
            notificationService.sendNotification(sellerIdx, "결제취소", "구매자가 안전결제를 취소했습니다.", "/trade/article?productIdx=" + productIdx);
        } else {
            notificationService.sendNotification(buyerIdx, "주문취소", "판매자가 거래를 취소하여 포인트가 환불되었습니다.", "/trade/article?productIdx=" + productIdx);
        }
    }

    @Override
    public String getUserAddress(long userIdx) throws Exception {
        return paymentMapper.getUserAddress(userIdx);
    }
    
    @Transactional(rollbackFor = Exception.class)
    @Override
    public void autoConfirmPurchases() throws Exception {
        List<Map<String, Object>> list = paymentMapper.getExpiredShippingTransactions();
        for (Map<String, Object> map : list) {
            long productIdx = Long.parseLong(map.get("PRODUCTIDX").toString());
            long buyerIdx = Long.parseLong(map.get("BUYERIDX").toString());
            confirmPurchase(productIdx, buyerIdx);
        }
    }
}