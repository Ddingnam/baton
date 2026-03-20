function requestPointRefund() {
    if(!confirm("정말 가장 최근에 충전한 포인트를 환불(결제 취소) 하시겠습니까?\n환불은 원래 결제하신 수단으로 영업일 기준 1~3일 내에 처리됩니다.")) return;
    
    let csrfToken = document.querySelector('meta[name="_csrf"]').getAttribute('content');
    let csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');
    let headers = {'Content-Type': 'application/json'};
    if(csrfHeader && csrfToken) headers[csrfHeader] = csrfToken;

    fetch(`${CONTEXT_PATH}/api/payment/refund`, {
        method: 'POST',
        headers: headers
    })
    .then(res => res.json())
    .then(data => {
        if(data.state === 'true') {
            alert(data.msg);
            location.reload();
        } else {
            alert("환불 불가: " + data.msg);
        }
    });
}

function showPointHistoryView(element) {
    document.getElementById('mainSummaryContent').style.display = 'none';
    document.getElementById('tradeHistoryContent').style.display = 'none';
    document.getElementById('pointHistoryContent').style.display = 'block';

    document.querySelectorAll('.sb-link').forEach(link => link.classList.remove('active'));
    if(element) element.classList.add('active');

    fetch(`${CONTEXT_PATH}/api/payment/history`)
    .then(res => res.json())
    .then(data => {
        let html = '';
        if(data.length === 0) {
            html = '<div style="text-align:center; padding:60px 0; color:#999;"><i class="ri-coins-line" style="font-size:40px; color:#ddd; margin-bottom:15px; display:block;"></i>이용 내역이 없습니다.</div>';
        } else {
            data.forEach(item => {
                let typeText = '', amountColor = '#333', amountPrefix = '', icon = '';
                
                if(item.historyType === 'CHARGE') { typeText = '포인트 충전'; amountColor = '#00B98D'; amountPrefix = '+ '; icon = '<i class="ri-add-circle-fill" style="color:#00B98D; font-size:24px; margin-right:15px;"></i>'; }
                else if(item.historyType === 'USE_ESCROW') { typeText = '안전결제 사용'; amountColor = '#F86D7D'; amountPrefix = '- '; icon = '<i class="ri-shopping-bag-3-fill" style="color:#F86D7D; font-size:24px; margin-right:15px;"></i>'; }
                else if(item.historyType === 'REFUND_ESCROW') { typeText = '안전결제 취소'; amountColor = '#00B98D'; amountPrefix = '+ '; icon = '<i class="ri-refund-2-fill" style="color:#00B98D; font-size:24px; margin-right:15px;"></i>'; }
                else if(item.historyType === 'REFUND') { typeText = '결제 취소 환불'; amountColor = '#F86D7D'; amountPrefix = '- '; icon = '<i class="ri-bank-card-fill" style="color:#F86D7D; font-size:24px; margin-right:15px;"></i>'; }
                else if(item.historyType === 'SELL_ESCROW') { typeText = '판매 정산금 적립'; amountColor = '#3182F6'; amountPrefix = '+ '; icon = '<i class="ri-hand-coin-fill" style="color:#3182F6; font-size:24px; margin-right:15px;"></i>'; }
                else { 
                    typeText = '기타 내역 (' + (item.historyType || '알수없음') + ')'; 
                    amountColor = '#555'; 
                    amountPrefix = (item.amount > 0 ? '+ ' : (item.amount < 0 ? '- ' : '')); 
                    icon = '<i class="ri-question-fill" style="color:#aaa; font-size:24px; margin-right:15px;"></i>'; 
                }
                
                let displayAmount = Math.abs(item.amount).toLocaleString();
                
                html += `
                    <div style="display:flex; justify-content:space-between; align-items:center; padding:20px 0; border-bottom:1px solid #f0f0f0;">
                        <div style="display:flex; align-items:center;">
                            ${icon}
                            <div>
                                <div style="font-size:15px; font-weight:700; color:#333; margin-bottom:4px;">${typeText}</div>
                                <div style="font-size:12px; color:#888;">${item.createdAt || '시간 정보 없음'}</div>
                            </div>
                        </div>
                        <div style="text-align:right;">
                            <div style="font-size:16px; font-weight:800; color:${amountColor};">${amountPrefix}${displayAmount} P</div>
                            <div style="font-size:13px; color:#888; margin-top:4px;">잔액 ${item.totalPoint.toLocaleString()} P</div>
                        </div>
                    </div>
                `;
            });
        }
        document.getElementById('pointHistoryListContainer').innerHTML = html;
    });
}

function showTradeHistoryView(element) {
    document.getElementById('mainSummaryContent').style.display = 'none';
    document.getElementById('pointHistoryContent').style.display = 'none';
    document.getElementById('tradeHistoryContent').style.display = 'block';

    document.querySelectorAll('.sb-link').forEach(link => link.classList.remove('active'));
    if(element) element.classList.add('active');

    fetch(`${CONTEXT_PATH}/mypage/api/tradeHistory`)
    .then(res => res.json())
    .then(data => {
        let html = '';
        if(data.length === 0) {
            html = '<div style="text-align:center; padding:60px 0; color:#999;"><i class="ri-shopping-bag-3-line" style="font-size:40px; color:#ddd; margin-bottom:15px; display:block;"></i>거래 내역이 없습니다.</div>';
        } else {
            data.forEach(item => {
                let typeText = item.HISTORYTYPE === 'BUY' ? '구매' : '판매';
                let amountColor = item.HISTORYTYPE === 'BUY' ? '#F86D7D' : '#3182F6';
                let statusText = item.STATUS;
                let reviewBtn = '';
                
                if (item.HISTORYTYPE === 'BUY' && (statusText === '판매완료' || statusText === 'CONFIRMED' || statusText === 'COMPLETED' || statusText === '결제완료')) {
                    reviewBtn = `<button type="button" onclick="location.href='${CONTEXT_PATH}/review/write?productIdx=${item.PRODUCTIDX}'" style="background:#fff; color:#333; border:1px solid #ddd; padding:6px 12px; border-radius:6px; font-size:12px; font-weight:700; cursor:pointer; margin-left:10px; transition:0.2s;">거래 후기 남기기</button>`;
                }

                html += `
                    <div style="display:flex; justify-content:space-between; align-items:center; padding:20px 0; border-bottom:1px solid #f0f0f0;">
                        <div style="display:flex; align-items:center; cursor:pointer;" onclick="location.href='${CONTEXT_PATH}/trade/article?productIdx=${item.PRODUCTIDX}'">
                            <div style="width:48px; height:48px; background:#f5f5f5; border-radius:8px; display:flex; align-items:center; justify-content:center; margin-right:15px;">
                                <i class="ri-shopping-bag-line" style="font-size:24px; color:#aaa;"></i>
                            </div>
                            <div>
                                <div style="font-size:12px; color:${amountColor}; font-weight:700; margin-bottom:4px;">${typeText} &middot; ${statusText}</div>
                                <div style="font-size:15px; font-weight:700; color:#333; margin-bottom:4px;">${item.TITLE}</div>
                                <div style="font-size:12px; color:#888;">${item.ACTIONDATE}</div>
                            </div>
                        </div>
                        <div style="text-align:right; display:flex; align-items:center;">
                            <div style="font-size:16px; font-weight:800; color:#333;">${item.PRICE.toLocaleString()} 원</div>
                            ${reviewBtn}
                        </div>
                    </div>
                `;
            });
        }
        document.getElementById('tradeHistoryListContainer').innerHTML = html;
    });
}