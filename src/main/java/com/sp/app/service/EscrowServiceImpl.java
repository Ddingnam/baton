//import org.springframework.stereotype.Service;
//import org.springframework.transaction.annotation.Transactional;
//
//import com.sp.app.mapper.PaymentMapper;
//
//import java.util.Map;
//
//@Service
//public class EscrowServiceImpl implements EscrowService {
//
//    private final PaymentMapper paymentMapper;
//
//    public EscrowServiceImpl(PaymentMapper paymentMapper) {
//        this.paymentMapper = paymentMapper;
//    }
//
//    @Transactional(rollbackFor = Exception.class)
//    @Override
//    public void processEscrowPayment(Map<String, Object> paramMap) throws Exception {
//
//        int result = paymentMapper.deductPointForEscrow(paramMap);
//        if (result == 0) {
//            throw new RuntimeException("포인트 잔액이 부족하여 결제를 진행할 수 없습니다.");
//        }
//
//        paymentMapper.insertTradeTransaction(paramMap);
//
//        long buyerIdx = Long.parseLong(paramMap.get("buyerIdx").toString());
//        int currentPoint = paymentMapper.getCurrentPoint(buyerIdx);
//        paramMap.put("totalPoint", currentPoint);
//
//        paymentMapper.insertPointHistoryForEscrow(paramMap);
//    }
//}