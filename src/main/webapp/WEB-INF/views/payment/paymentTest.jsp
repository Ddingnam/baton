<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>바톤터치 - 결제 테스트</title>
<link rel="icon" href="data:;base64,iVBORw0KGgo=">

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.iamport.kr/v1/iamport.js"></script>

</head>
<body>

    <h2>포트원 결제 테스트 화면</h2>
    <hr>
    
    <button onclick="requestPay()" style="padding: 10px 20px; font-size: 16px; cursor: pointer;">100원 결제하기</button>

    <script>
        var IMP = window.IMP; 
      
        IMP.init("imp25654160"); 

        function requestPay() {
          
            var merchantUid = "ORD_" + new Date().getTime(); 

            IMP.request_pay({
                pg: "kakaopay",           		// 테스트용 PG사
                payMethod: "card",          	// 결제수단 (신용카드)
                merchantUid: merchantUid,   	// 우리 시스템 고유 주문번호
                name: "바톤터치 테스트 상품",      	// 결제창에 보여질 상품명
                amount: 100,                  	// 결제 금액 (100원 이상이어야 함)
                buyerEmail: "test@test.com", 	// 구매자 이메일
                buyerName: "tester",         	// 구매자 이름
                buyerTel: "010-1234-5678"    	// 구매자 전화번호
           
            }, function (rsp) { 
                if (rsp.success) {
                    console.log("결제 성공 응답 데이터:", rsp);

                    $.ajax({
                        url: "/api/payment/verify/" + rsp.imp_uid,
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify({
                            merchantUid: rsp.merchant_uid,
                            chargeAmount: rsp.paid_amount,
                            payMethod: rsp.pay_method,
                            userIdx: 1 
                        })
                    }).done(function (data) {
                        alert("결제 완료 및 DB 저장 성공!");
                        // location.href = "/mypage/point"; // 성공 후 이동할 페이지
                    }).fail(function(xhr, status, error) {
                        alert("결제는 되었으나 DB 저장에 실패했습니다.");
                        console.error(error);
                    });
                    
                } else {
                    alert("결제에 실패하였습니다. 에러 내용: " + rsp.error_msg);
                }
            });
            
            
        }
    </script>

</body>
</html>