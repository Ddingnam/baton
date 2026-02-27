var IMP = window.IMP;
IMP.init("imp25654160"); 

/**
 * 포트원 결제 공통 함수
 * @param contextPath 서버 경로
 * @param email 유저 이메일
 * @param name 유저 이름
 * @param tel 유저 전화번호
 * @param userIdx 유저 PK
 */
function requestBatonPay(contextPath, email, name, tel, userIdx) {
    let amount = 0;

    let amountInput = document.getElementById('chargeAmount');
    
    if (amountInput && amountInput.value) {
        amount = parseInt(amountInput.value);
    } else {
      
        let amountStr = prompt("충전할 금액을 입력하세요 (예: 10000)", "10000");
        if (!amountStr) return; 
        amount = parseInt(amountStr);
    }

    if (!amount || amount < 100) {
        alert("최소 결제 금액은 100원입니다.");
        if(amountInput) amountInput.focus();
        return;
    }

    var merchantUid = "ORD_" + new Date().getTime();

    IMP.request_pay({
        pg: "kakaopay",
        payMethod: "card",
        merchantUid: merchantUid,
        name: "바톤터치 포인트 충전",
        amount: amount,
        buyerEmail: email || "test@test.com", 
        buyerName: name || "테스터", 
        buyerTel: tel || "010-0000-0000" 
		}, function (rsp) { 
	        if (rsp.success) {
	            const headerMeta = document.querySelector("meta[name='_csrf_header']");
	            const tokenMeta = document.querySelector("meta[name='_csrf']");
	            
	            const header = headerMeta ? headerMeta.content : '';
	            const token = tokenMeta ? tokenMeta.content : '';

	            $.ajax({
	                url: contextPath + "/api/payment/verify/" + rsp.imp_uid,
	                type: "POST",
	                contentType: "application/json",
	                beforeSend: function(xhr) {
	                    if(header && token) xhr.setRequestHeader(header, token);
	                },
	                data: JSON.stringify({
                    merchantUid: rsp.merchant_uid,
                    chargeAmount: rsp.paid_amount,
                    payMethod: rsp.pay_method,
                    userIdx: parseInt(userIdx || 0)
                })
				}).done(function (data) {
	                let savedPoint = Math.floor(rsp.paid_amount * 0.98); 
	                alert("결제가 완료되었습니다!\n수수료 2%를 제외한 " + savedPoint + "P가 적립되었습니다.");
	    
	                let pointElement = $('.pb-point strong');
	                
	                if (pointElement.length > 0) {
	         
	                    let currentPointStr = pointElement.text().replace(/[^0-9]/g, '');
	                    let currentPoint = parseInt(currentPointStr) || 0;
	              
	                    let finalPoint = currentPoint + savedPoint;
	           
	                    pointElement.html(finalPoint.toLocaleString() + '<span class="theme-text">P</span>');
	                } else {
	          
	                    if (window.location.pathname.includes('/payment')) {
	                        window.location.href = contextPath + "/mypage";
	                    }
	                }
	                
	            }).fail(function(xhr) {
	                alert("결제는 진행되었으나 시스템 오류로 적립에 실패했습니다.");
	            });
			
        } else {
            alert("결제에 실패하였습니다. 에러: " + rsp.error_msg);
        }
    });
}