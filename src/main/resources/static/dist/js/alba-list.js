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
let currentView = 'table'; 
let currentPage = 1;
const PAGE_SIZE = 10;
let filteredJobs = [];

function switchView(v) {
  currentView = v;
  const tableView = document.getElementById('tableView');
  const cardView = document.getElementById('cardView');
  if(tableView) tableView.classList.toggle('hidden', v !== 'table');
  if(cardView) {
    cardView.classList.toggle('hidden', v !== 'card');
    cardView.classList.toggle('visible', v === 'card');
  }
  document.getElementById('btnTable').classList.toggle('active', v === 'table');
  document.getElementById('btnCard').classList.toggle('active', v === 'card');
  renderCurrentPage();
}

function applyFilters() {
  const keyword  = document.getElementById('searchInput').value.trim().toLowerCase();
  document.getElementById('searchClear').style.display = keyword ? 'block' : 'none';

  const periodEl = document.querySelector('.filter-section:nth-child(1) .chip.active');
  const period   = periodEl ? periodEl.textContent.trim() : '전체';
  const catEl    = document.querySelector('.filter-section:nth-child(2) .chip.active');
  const cat      = catEl ? catEl.textContent.trim() : '전체';
  const activeDays = [...document.querySelectorAll('.day-chip.active')].map(c => c.dataset.day);
  const minPayEl = document.querySelector('.filter-section:nth-child(4) .chip.active');
  const minPay   = minPayEl ? (MIN_PAY_MAP[minPayEl.textContent.trim()] ?? 0) : 0;
  const sort     = document.getElementById('sortSelect').value;

  let jobs = [...DUMMY_JOBS];
  if (keyword) jobs = jobs.filter(j =>
    (j.title || "").toLowerCase().includes(keyword) ||
    (j.employer || "").toLowerCase().includes(keyword) ||
    (j.tags || []).some(t => t.label.toLowerCase().includes(keyword))
  );
  if (period === '1개월 이상') jobs = jobs.filter(j => j.period === 'MORE_THAN_A_MONTH');
  if (period === '단기')       jobs = jobs.filter(j => j.period === 'LESS_THAN_A_MONTH');
  if (cat !== '전체' && CAT_MAP[cat]) jobs = jobs.filter(j => j.cat === CAT_MAP[cat]);
  if (activeDays.length > 0) jobs = jobs.filter(j => activeDays.every(d => (j.dayVals || []).includes(d)));
  if (minPay > 0) jobs = jobs.filter(j => j.payTypeKey !== 'hour' || j.payNum >= minPay);

  if (sort === 'pay_high') jobs.sort((a,b) => b.payNum - a.payNum);
  else                     jobs.sort((a,b) => (a.dateOrder || 0) - (b.dateOrder || 0));

  filteredJobs = jobs;
  currentPage = 1;
  document.getElementById('resultCount').textContent = jobs.length;
  renderCurrentPage();
  renderPagination();
}

function renderCurrentPage() {
  const start = (currentPage - 1) * PAGE_SIZE;
  const pageJobs = filteredJobs.slice(start, start + PAGE_SIZE);
  if (currentView === 'table') renderTable(pageJobs);
  else                         renderCards(pageJobs);
}

function renderTable(jobs) {
  const tbody = document.getElementById('tableBody');
  if (!tbody) return;
  if (!jobs.length) {
    tbody.innerHTML = `<tr><td colspan="5"><div class="no-result">
      <div class="no-result-icon">🔍</div>
      <strong>검색 결과가 없어요</strong>
      조건을 바꿔보거나 검색어를 다시 입력해보세요.
    </div></td></tr>`;
    return;
  }
  tbody.innerHTML = jobs.map((job, idx) => {
    const tagsHtml = (job.tags || []).map(t => `<span class="job-tag ${t.cls}">${t.label}</span>`).join('');
    const isLiked  = liked.has(job.id);
    const dateHtml = job.isNew
      ? `<strong class="new">${job.date}</strong>`
      : `<span>${job.date}</span>`;
    const timeHtml = (job.time === '협의' || job.time === '시간협의')
      ? `<span class="time-consult">시간협의</span>`
      : job.time;
      
    return `
      <tr style="animation-delay:${idx * 0.035}s" onclick="location.href='${CONTEXT_PATH}/baton/posting/article?postingIdx=${job.id}'">
        <td class="td-title">
          <div class="company-nm">${job.employer}</div>
          <a class="job-title-text" href="${CONTEXT_PATH}/baton/posting/article?postingIdx=${job.id}" onclick="event.stopPropagation()">${job.title}</a>
          <div class="tag-row">${tagsHtml}</div>
        </td>
        <td class="td-area">${job.area}</td>
        <td class="td-time">${timeHtml}<br><small style="color:#adb5bd;font-size:13px;margin-top:2px;display:inline-block;">${job.days}</small></td>
        <td class="td-pay">
          <span class="pay-type-badge ${job.payTypeKey}">${job.payType}</span>
          <span class="pay-num">${job.payFmt}원</span>
        </td>
        <td class="td-date">
          <div class="date-cell-wrap">
            <div class="date-col-left">
              ${dateHtml}
            </div>
            <div class="action-icons vertical" onclick="event.stopPropagation()">
              <button class="icon-btn scrap ${isLiked ? 'liked' : ''}" type="button" onclick="toggleLike(event,this,${job.id})">
                <i class="${isLiked ? 'ri-star-fill' : 'ri-star-line'}"></i>
              </button>
            </div>
          </div>
        </td>
      </tr>`;
  }).join('');
}

function renderCards(jobs) {
  const list = document.getElementById('cardView');
  if (!list) return;
  if (!jobs.length) {
    list.innerHTML = `<div class="no-result" style="grid-column: 1 / -1;">
      <div class="no-result-icon">🔍</div>
      <strong>검색 결과가 없어요</strong>
      조건을 바꿔보거나 검색어를 다시 입력해보세요.
    </div>`;
    return;
  }
  list.innerHTML = jobs.map((job, idx) => {
    const tagsHtml = (job.tags || []).map(t => `<span class="job-tag ${t.cls}">${t.label}</span>`).join('');
    const isLiked  = liked.has(job.id);
    
    return `
      <div class="job-card" onclick="location.href='${CONTEXT_PATH}/baton/posting/article?postingIdx=${job.id}'" style="animation-delay:${idx * 0.04}s">
        <div class="card-header">
          <div class="card-header-left">
            <div class="job-thumb">
              <img src="${job.img}" alt="${job.title}" onerror="this.parentNode.innerHTML='💼'">
            </div>
            <div>
              <div class="job-employer">${job.employer}</div>
              <div class="job-date">${job.date}</div>
            </div>
          </div>
          <div class="action-icons" onclick="event.stopPropagation()">
            <button class="icon-btn scrap ${isLiked ? 'liked' : ''}" type="button" onclick="toggleLike(event,this,${job.id})">
              <i class="${isLiked ? 'ri-star-fill' : 'ri-star-line'}"></i>
            </button>
          </div>
        </div>
        <div class="job-title-text">${job.title}</div>
        <div class="job-pay-row">
          <span class="pay-type-badge ${job.payTypeKey}">${job.payType}</span>${job.payFmt}원
        </div>
        <div class="job-schedule"><i class="ri-time-line" style="color:var(--baton-muted)"></i>&nbsp;${job.area} · ${job.days} · ${job.time}</div>
        <div class="card-footer">
          <div class="tag-row">${tagsHtml}</div>
        </div>
      </div>`;
  }).join('');
}

function renderPagination() {
  const total = Math.ceil(filteredJobs.length / PAGE_SIZE);
  const pg = document.getElementById('pagination');
  if (!pg) return;
  if (total <= 1) { pg.innerHTML = ''; return; }

  let html = `<button class="page-btn" onclick="goPage(${currentPage-1})" ${currentPage===1?'disabled':''}><i class="ri-arrow-left-s-line"></i></button>`;
  const start = Math.max(1, currentPage-4), end = Math.min(total, start+9);
  for (let i = start; i <= end; i++) {
    html += `<button class="page-btn ${i===currentPage?'active':''}" onclick="goPage(${i})">${i}</button>`;
  }
  html += `<button class="page-btn" onclick="goPage(${currentPage+1})" ${currentPage===total?'disabled':''}><i class="ri-arrow-right-s-line"></i></button>`;
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
  e.preventDefault(); e.stopPropagation();
  const icon = btn.querySelector('i');
  if (liked.has(id)) {
    liked.delete(id); 
    btn.classList.remove('liked'); 
    icon.className = 'ri-star-line';
  } else {
    liked.add(id); 
    btn.classList.add('liked'); 
    icon.className = 'ri-star-fill';
    btn.style.transform = 'scale(1.1)';
    setTimeout(() => btn.style.transform = '', 150);
  }
}

function clearSearch() {
  document.getElementById('searchInput').value = '';
  document.getElementById('searchClear').style.display = 'none';
  applyFilters();
}

function setSearch(el) {
  document.getElementById('searchInput').value = el.textContent.trim();
  document.getElementById('searchClear').style.display = 'block';
  applyFilters();
  document.getElementById('searchInput').focus();
}

document.querySelectorAll('.filter-section .filter-chips').forEach(group => {
  group.querySelectorAll('.chip').forEach(chip => {
    chip.addEventListener('click', function() {
      group.querySelectorAll('.chip').forEach(c => c.classList.remove('active'));
      this.classList.add('active');
      applyFilters();
    });
  });
});

document.addEventListener('DOMContentLoaded', () => {
    setTimeout(() => {
        applyFilters();
    }, 100);
});