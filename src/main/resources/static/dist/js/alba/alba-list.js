const CAT_MAP = {
  '서빙': '서빙',
  '주방보조': '주방보조',
  '매장관리': '매장관리',
  '음료제조': '음료제조',
  '기타': '기타'
};

let currentPage = 1;
const PAGE_SIZE = 10;
let filteredJobs = [];

function getRelativeTime(dateStr) {
  if (!dateStr) return '';
  const now = new Date();
  const d = new Date(dateStr);
  const diff = Math.floor((now - d) / 60000);
  if (diff < 1)    return '방금전';
  if (diff < 60)   return diff + '분전';
  if (diff < 1440) return Math.floor(diff / 60) + '시간전';
  return Math.floor(diff / 1440) + '일전';
}

function applyFilters() {
  const keywordEl = document.getElementById('searchInput');
  const keyword   = keywordEl ? keywordEl.value.trim().toLowerCase() : '';

  const periodEl = document.querySelector('.filter-section[data-filter-type="period"] .chip.active');
  const period   = periodEl ? periodEl.textContent.trim() : '전체';

  const catEl = document.querySelector('.filter-section[data-filter-type="category"] .chip.active');
  const cat   = catEl ? catEl.textContent.trim() : '전체';

  const minPayInput = document.getElementById('minPayInput');
  const minPay = minPayInput ? (parseInt(minPayInput.value) || 0) : 0;

  const sortEl = document.getElementById('sortSelect');
  const sort   = sortEl ? sortEl.value : 'latest';

  let jobs = [...serverData];

  if (keyword) {
    jobs = jobs.filter(j =>
      (j.title    || '').toLowerCase().includes(keyword) ||
      (j.employer || '').toLowerCase().includes(keyword) ||
      (j.area     || '').toLowerCase() .includes(keyword)
    );
  }

  if (period !== '전체') {
    jobs = jobs.filter(j =>
      j.period === period ||
      (period === '1개월 이상' && j.period === 'MORE_THAN_A_MONTH') ||
      (period === '단기'       && j.period === 'LESS_THAN_A_MONTH')
    );
  }

  if (cat !== '전체') {
    jobs = jobs.filter(j => j.cat === cat || j.cat === CAT_MAP[cat]);
  }

  if (minPay > 0) {
    jobs = jobs.filter(j => j.payTypeKey !== 'hour' || j.payNum >= minPay);
  }

  if (sort === 'pay_high') {
    jobs.sort((a, b) => b.payNum - a.payNum);
  }

  filteredJobs = jobs;
  currentPage  = 1;

  const rc = document.getElementById('resultCount');
  if (rc) rc.textContent = jobs.length;

  renderCurrentPage();
  renderPagination();
}

function renderCurrentPage() {
  const start = (currentPage - 1) * PAGE_SIZE;
  renderList(filteredJobs.slice(start, start + PAGE_SIZE));
}

function renderList(jobs) {
  const container = document.getElementById('listView');
  if (!container) return;

  if (!jobs.length) {
    container.innerHTML = `
      <div class="no-result">
        <span class="no-result-icon">🔍</span>
        <strong>검색 결과가 없어요</strong>
        <span>조건을 바꿔보거나 검색어를 다시 입력해보세요.</span>
      </div>`;
    return;
  }

  container.innerHTML = jobs.map((job, idx) => {
    const relTime     = getRelativeTime(job.date);
    const isRecent    = relTime.includes('분전') || relTime.includes('시간전') || relTime === '방금전';
    const periodLabel = job.period === 'MORE_THAN_A_MONTH' ? '장기'
                      : job.period === 'LESS_THAN_A_MONTH' ? '단기' : '';

    return `
      <div class="job-list-item" style="animation-delay:${idx * 0.04}s"
           onclick="location.href='${CONTEXT_PATH}/alba/article/${job.id}'">
        <div class="job-area-col">
          <span class="job-area-text">${job.area}</span>
          ${periodLabel ? `<span class="job-period-badge">${periodLabel}</span>` : ''}
        </div>
        <div class="job-article-col">
          <div class="job-employer">${job.employer}</div>
          <div class="job-title">${job.title}</div>
        </div>
        <div class="job-salary-col">
          <span class="pay-badge ${job.payTypeKey}">${job.payType}</span>
          <div class="pay-amount">${job.payFmt}원</div>
        </div>
        <div class="job-time-col">${job.time || '-'}</div>
        <div class="job-date-col ${isRecent ? 'recent' : ''}">${relTime}</div>
      </div>`;
  }).join('');
}

function renderPagination() {
  const total = Math.ceil(filteredJobs.length / PAGE_SIZE);
  const pg    = document.getElementById('pagination');
  if (!pg) return;
  if (total <= 1) { pg.innerHTML = ''; return; }

  let html = `<button class="page-btn" onclick="goPage(${currentPage - 1})" ${currentPage === 1 ? 'disabled' : ''}>
                <i class="ri-arrow-left-s-line"></i>
              </button>`;

  const start = Math.max(1, currentPage - 4);
  const end   = Math.min(total, start + 9);
  for (let i = start; i <= end; i++) {
    html += `<button class="page-btn ${i === currentPage ? 'active' : ''}" onclick="goPage(${i})">${i}</button>`;
  }

  html += `<button class="page-btn" onclick="goPage(${currentPage + 1})" ${currentPage === total ? 'disabled' : ''}>
             <i class="ri-arrow-right-s-line"></i>
           </button>`;

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

document.querySelectorAll('.filter-section .filter-chips, .filter-section[data-filter-type="category"]').forEach(group => {
  group.querySelectorAll('.chip').forEach(chip => {
    chip.addEventListener('click', function () {
      group.querySelectorAll('.chip').forEach(c => c.classList.remove('active'));
      this.classList.add('active');
      applyFilters();
    });
  });
});

document.addEventListener('DOMContentLoaded', () => {
  setTimeout(applyFilters, 100);
});
