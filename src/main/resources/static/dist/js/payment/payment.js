var IMP = window.IMP;
IMP.init("imp25654160"); 

function showCustomAlert(title, msg, type, callback) {
    $('#chargeStep1, #chargeStep2').hide();
    $('#chargeStepAlert').show();

    $('#chargeModalOverlay').css('display', 'flex');

    $('#alertTitle').text(title);
    $('#alertMessage').text(msg);

    if (type === 'success') {
        $('#alertIconBox').html('<i class="ri-checkbox-circle-fill" style="color: #00B98D;"></i>');
    } else if (type === 'error') {
        $('#alertIconBox').html('<i class="ri-error-warning-fill" style="color: #F86D7D;"></i>');
    } else {
        $('#alertIconBox').html('<i class="ri-information-fill" style="color: #3182F6;"></i>');
    }

    $('#alertConfirmBtn').off('click').on('click', function() {
        closeChargeModal();
        if (typeof callback === 'function') callback();
    });
}

function openChargeModal() {
    let input = $('#customChargeInput');

    input.val(''); 
    
    $('#chargeStep1').show();
    $('#chargeStepAlert, #chargeStep2').hide();

    $('#chargeModalOverlay').css('display', 'flex');
}

function closeChargeModal() {
    $('#chargeModalOverlay').hide();
}

function changeAmount(step) {
    let input = $('#customChargeInput');
    let current = parseInt(input.val()) || 0;
    let newVal = current + step;
    if (newVal < 1000 && step < 0) newVal = 0; 
    input.val(newVal);
}

function openConfirmStep() {
    let amt = parseInt($('#customChargeInput').val());
  
    if (!amt || amt < 1000) {
        showCustomAlert('금액 입력 오류', '최소 결제 금액은 1,000원입니다.', 'warning', function() {
            openChargeModal(); 
        });
        return;
    }
    
    let savedPoint = Math.floor(amt * 0.98); 
    $('#confirmAmountText').text(amt.toLocaleString());
    $('#saveAmountText').text(savedPoint.toLocaleString());

    $('#chargeStep1').hide();

    $('#chargeStep2').show();
}


function executeBatonPayment() {
    let amount = parseInt($('#customChargeInput').val());
    closeChargeModal(); 

    let contextPath = $('#ctxPath').val();
    let email = $('#userEmail').val() || "test@test.com";
    let name = $('#userName').val() || "테스터";
    let tel = $('#userTel').val() || "010-0000-0000";

    var merchantUid = "ORD_" + new Date().getTime();

    IMP.request_pay({
        pg: "kakaopay",
        payMethod: "card",
        merchantUid: merchantUid,
        name: "바톤터치 포인트 충전",
        amount: amount,
        buyerEmail: email, 
        buyerName: name, 
        buyerTel: tel 
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
                    userIdx: 0 
                })
            }).done(function (data) {
                let savedPoint = Math.floor(rsp.paid_amount * 0.98); 
                
                showCustomAlert('결제 완료', '결제가 성공적으로 완료되었습니다!\n수수료 2%를 제외한 ' + savedPoint.toLocaleString() + 'P가 적립되었습니다.', 'success', function() {
                    let pointElement = $('.pb-point strong');
                    if (pointElement.length > 0) {
                        let currentPoint = parseInt(pointElement.text().replace(/[^0-9]/g, '')) || 0;
                        pointElement.html((currentPoint + savedPoint).toLocaleString() + '<span class="theme-text">P</span>');
                    } else {
                        if (window.location.pathname.includes('/payment')) window.location.href = contextPath + "/mypage";
                    }
                });
                
            }).fail(function(xhr) {
                showCustomAlert('적립 실패', '결제는 진행되었으나 시스템 오류로 적립에 실패했습니다.\n고객센터에 문의해 주세요.', 'error');
            });
            
        } else {
            showCustomAlert('결제 취소/실패', '결제가 정상적으로 진행되지 않았습니다.\n(' + rsp.error_msg + ')', 'warning');
        }
    });
}