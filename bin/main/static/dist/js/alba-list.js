if (typeof DUMMY_JOBS === 'undefined') {
    var DUMMY_JOBS = []; 
}

const CAT_MAP = {
  '서빙':'SERVING','주방보조':'KITCHEN_ASSISTANCE','매장관리':'SHOP_MANAGEMENT',
  '음료제조':'BEVERAGE_MAKING','청소':'CLEANING','편의점':'CONVENIENCE_STORE',
  '돌봄':'CHILD_CARE','과외/레슨':'TUTORING','배달':'ETC','기타':'ETC'
};
const MIN_PAY_MAP = { '무관':0,'1만원+':10000,'1.2만원+':12000,'1.5만원+':15000,'2만원+':20000 };

let liked = new Set();
let currentPage = 1;
const PAGE_SIZE = 12; // 4단 그리드에 맞춰 12개로 설정
let filteredJobs = [];

function applyFilters() {
    const keyword = document.getElementById('searchInput').value.trim().toLowerCase();
    
    // 카테고리 필터값 (상단 툴바 버튼)
    const catEl = document.querySelector('#categoryFilters .filter-btn.active');
    const cat = catEl ? catEl.dataset.cat : '전체';
    
    // 기간 및 급여 필터값 (Select Box)
    const period = document.getElementById('periodSelect').value;
    const paySelectVal = document.getElementById('paySelect').value;
    const minPay = MIN_PAY_MAP[paySelectVal] ?? 0;
    const sort = document.getElementById('sortSelect').value;

    let jobs = [...DUMMY_JOBS];

    if (keyword) {
        jobs = jobs.filter(j => 
            (j.title || "").toLowerCase().includes(keyword) ||
            (j.employer || "").toLowerCase().includes(keyword)
        );
    }
    if (period === '1개월 이상') jobs = jobs.filter(j => j.period === 'MORE_THAN_A_MONTH');
    if (period === '단기') jobs = jobs.filter(j => j.period === 'LESS_THAN_A_MONTH');
    
    if (cat !== '전체' && cat) jobs = jobs.filter(j => j.cat === cat || CAT_MAP[j.cat] === cat);
    if (minPay > 0) jobs = jobs.filter(j => j.payTypeKey !== 'hour' || j.payNum >= minPay);

    if (sort === 'pay_high') jobs.sort((a,b) => b.payNum - a.payNum);
    else jobs.sort((a,b) => (a.dateOrder || 0) - (b.dateOrder || 0));

    filteredJobs = jobs;
    currentPage = 1;
    document.getElementById('resultCount').textContent = jobs.length;
    
    renderCurrentPage();
    renderPagination();
}

function clearFilters() {
    document.getElementById('searchInput').value = '';
    document.getElementById('periodSelect').value = '전체';
    document.getElementById('paySelect').value = '무관';
    document.getElementById('sortSelect').value = 'latest';
    
    document.querySelectorAll('#categoryFilters .filter-btn').forEach(btn => btn.classList.remove('active'));
    document.querySelector('#categoryFilters .filter-btn[data-cat="전체"]').classList.add('active');
    
    applyFilters();
}

function renderCurrentPage() {
    const start = (currentPage - 1) * PAGE_SIZE;
    const pageJobs = filteredJobs.slice(start, start + PAGE_SIZE);
    renderGridCards(pageJobs);
}

// 중고거래 카드 컴포넌트와 동일한 형태로 렌더링
function renderGridCards(jobs) {
    const list = document.getElementById('albaGrid');
    if (!list) return;

    if (!jobs.length) {
        list.innerHTML = `
            <div class="tl-empty-state">
                <i class="ri-search-line empty-icon"></i>
                <p>검색 결과가 없어요</p>
                <small>조건을 바꿔보거나 검색어를 다시 입력해보세요.</small>
            </div>`;
        return;
    }

    list.innerHTML = jobs.map((job, idx) => {
        const isLiked = liked.has(job.id);
        const imgHtml = job.img 
            ? `<img src="${job.img}" alt="${job.title}">` 
            : `<i class="ri-store-2-line placeholder-icon"></i>`;

        return `
        <div class="trade-card" onclick="location.href='${CONTEXT_PATH}/baton/posting/article?postingIdx=${job.id}'" style="animation-delay:${idx * 0.05}s">
            <div class="card-image-box">
                ${imgHtml}
                <div class="badge-group">
                    <span class="badge badge-pay">${job.payType}</span>
                </div>
                <button type="button" class="wish-btn ${isLiked ? 'active' : ''}" onclick="toggleLike(event, this, ${job.id})">
                    <i class="${isLiked ? 'ri-heart-3-fill' : 'ri-heart-3-line'}"></i>
                </button>
            </div>
            <div class="card-info">
                <h3 class="card-title">${job.title}</h3>
                <div class="card-price">${job.payFmt}원</div>
                <div class="card-details">
                    <div class="detail-item"><i class="ri-building-line"></i> ${job.employer}</div>
                    <div class="detail-item"><i class="ri-map-pin-2-line"></i> ${job.area}</div>
                    <div class="detail-item"><i class="ri-time-line"></i> ${job.days} · ${job.time}</div>
                </div>
                <div class="card-footer">
                    <div class="host-info">
                        <div class="host-avatar"><i class="ri-user-smile-line"></i></div>
                        <span class="host-name">동네사장님</span>
                    </div>
                    <div class="interaction-info">
                        <span><i class="ri-calendar-line"></i> ${job.date}</span>
                    </div>
                </div>
            </div>
        </div>`;
    }).join('');
}

function renderPagination() {
    const total = Math.ceil(filteredJobs.length / PAGE_SIZE);
    const pg = document.getElementById('pagination');
    if (!pg) return;
    if (total <= 1) { pg.innerHTML = ''; return; }

    let html = `<button class="tl-page-btn" onclick="goPage(${currentPage-1})" ${currentPage===1?'disabled':''}>&#8249;</button>`;
    const start = Math.max(1, currentPage-4), end = Math.min(total, start+9);
    for (let i = start; i <= end; i++) {
        html += `<button class="tl-page-btn ${i===currentPage?'active':''}" onclick="goPage(${i})">${i}</button>`;
    }
    html += `<button class="tl-page-btn" onclick="goPage(${currentPage+1})" ${currentPage===total?'disabled':''}>&#8250;</button>`;
    pg.innerHTML = html;
}

function goPage(p) {
    const total = Math.ceil(filteredJobs.length / PAGE_SIZE);
    if (p < 1 || p > total) return;
    currentPage = p;
    renderCurrentPage();
    renderPagination();
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

function toggleLike(e, btn, id) {
    e.preventDefault(); 
    e.stopPropagation();
    const icon = btn.querySelector('i');
    if (liked.has(id)) {
        liked.delete(id); 
        btn.classList.remove('active'); 
        icon.className = 'ri-heart-3-line';
    } else {
        liked.add(id); 
        btn.classList.add('active'); 
        icon.className = 'ri-heart-3-fill';
        btn.style.transform = 'scale(1.2)';
        setTimeout(() => btn.style.transform = 'scale(1)', 200);
    }
}

// 상단 카테고리 필터 클릭 이벤트 등록
document.querySelectorAll('#categoryFilters .filter-btn').forEach(btn => {
    btn.addEventListener('click', function() {
        document.querySelectorAll('#categoryFilters .filter-btn').forEach(c => c.classList.remove('active'));
        this.classList.add('active');
        applyFilters();
    });
});

document.addEventListener('DOMContentLoaded', () => {
    applyFilters();
});