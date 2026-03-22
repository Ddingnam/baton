function showPointHistoryView(element) {
    location.href = CONTEXT_PATH + '/mypage/main';
}

function showTradeHistoryView(element) {
    location.href = CONTEXT_PATH + '/mypage/main';
}

function switchTab(type) {
    document.querySelectorAll('.inner-tab').forEach(btn => btn.classList.remove('active'));
    event.target.classList.add('active');
    
    document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));
    document.getElementById('tab-' + type).classList.add('active');
    
    const url = new URL(window.location);
    url.searchParams.set('type', type);
    window.history.pushState({}, '', url);
}

function deleteReview(reviewIdx) {
    if(!confirm("작성하신 거래 후기를 정말 삭제하시겠습니까?")) return;
    
    const csrfToken = document.querySelector('meta[name="_csrf"]')?.content;
    const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.content;
    const headers = { 'Content-Type': 'application/x-www-form-urlencoded' };
    if (csrfHeader && csrfToken) headers[csrfHeader] = csrfToken;

    fetch(CONTEXT_PATH + '/review/delete', {
        method: 'POST',
        headers: headers,
        body: new URLSearchParams({ reviewIdx: reviewIdx })
    })
    .then(res => res.json())
    .then(data => {
        if(data.status === 'success') {
            alert("삭제되었습니다.");
            location.reload();
        } else {
            alert("삭제에 실패했습니다.");
        }
    });
}