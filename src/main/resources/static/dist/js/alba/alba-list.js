const API_BASE_URL = "https://grpc-proxy-server-mkvo6j4wsq-du.a.run.app/v1/regcodes";
const CAT_MAP = {
	'서빙': '서빙',
	'주방보조': '주방보조',
	'매장관리': '매장관리',
	'음료제조': '음료제조',
	'기타': '기타'
};

const CAT_INFO = {
	'서빙':    { emoji: '🍽️', cls: 'cat-serving' },
	'주방보조': { emoji: '👨‍🍳', cls: 'cat-kitchen' },
	'매장관리': { emoji: '🏪',  cls: 'cat-store'   },
	'음료제조': { emoji: '☕',  cls: 'cat-beverage' },
	'기타':    { emoji: '💼',  cls: 'cat-other'    },
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

function isFresh(dateStr) {
	if (!dateStr) return false;
	const diff = Math.floor((new Date() - new Date(dateStr)) / 60000);
	return diff < 60;
}

function applyFilters() {
	const keywordEl  = document.getElementById('searchInput');
	const keyword    = keywordEl ? keywordEl.value.trim().toLowerCase() : '';
	const periodEl   = document.querySelector('.filter-section[data-filter-type="period"] .chip.active');
	const period     = periodEl ? periodEl.textContent.trim() : '전체';
	const catEl      = document.querySelector('.filter-section[data-filter-type="category"] .chip.active');
	const cat        = catEl ? catEl.textContent.trim() : '전체';
	const minPayInput = document.getElementById('minPayInput');
	const minPay     = minPayInput ? (parseInt(minPayInput.value) || 0) : 0;
	const sortEl     = document.getElementById('sortSelect');
	const sort       = sortEl ? sortEl.value : 'latest';

	let jobs = [...serverData];

	if (keyword) {
		jobs = jobs.filter(j =>
			(j.title    || '').toLowerCase().includes(keyword) ||
			(j.employer || '').toLowerCase().includes(keyword) ||
			(j.location || '').toLowerCase().includes(keyword)
		);
	}

	if (period !== '전체') {
		jobs = jobs.filter(j =>
			(period === '1개월 이상' && j.workPeriod === 'MORE_THAN_A_MONTH') ||
			(period === '단기'       && j.workPeriod === 'LESS_THAN_A_MONTH')
		);
	}

	if (cat !== '전체') {
		const mappedCat = CAT_MAP[cat] || cat;
		jobs = jobs.filter(j => j.category === mappedCat);
	}

	if (minPay > 0) {
		jobs = jobs.filter(j => j.payType !== '시급' || j.pay >= minPay);
	}

	if (sort === 'pay_high') {
		jobs.sort((a, b) => b.pay - a.pay);
	} else {
		jobs.sort((a, b) => b.postingIdx - a.postingIdx);
	}

	filteredJobs = jobs;
	currentPage  = 1;

	const rc2 = document.getElementById('sidebarResultCount');
	if (rc2) rc2.textContent = jobs.length;
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

	if (!jobs || !jobs.length) {
		container.innerHTML = `
			<div class="no-result">
				<i class="ri-search-line"></i>
				<strong>조건에 맞는 공고가 없습니다.</strong>
				<span>다른 필터를 선택하거나 검색어를 변경해보세요.</span>
			</div>`;
		return;
	}

	container.innerHTML = jobs.map(job => {
		const relTime   = getRelativeTime(job.createdDate);
		const fresh     = isFresh(job.createdDate);
		const workTime  = (job.startTime && job.endTime)
			? `${job.startTime}~${job.endTime}` : '시간협의';
		const scrapCls = job.isScrapped == 1 ? 'active' : '';
		const catInfo   = CAT_INFO[job.category] || { emoji: '💼', cls: 'cat-other' };

		const isShort = job.workPeriod === 'LESS_THAN_A_MONTH';
		const isLong  = job.workPeriod === 'MORE_THAN_A_MONTH';

		const periodTag = isShort
			? `<span class="job-tag period-short">⚡ 단기</span>`
			: isLong
			? `<span class="job-tag period-long">📅 장기</span>`
			: '';

		return `
		<div class="job-list-item" onclick="location.href='${CONTEXT_PATH}/alba/article/${job.postingIdx}'">

			<div class="job-cat-bar ${catInfo.cls}"></div>
			<div class="job-cat-icon">${catInfo.emoji}</div>

			<div class="job-item-body">
				<div class="job-article-col">
					<div class="job-employer">${job.employer}</div>
					<div class="job-title">${job.title}</div>
					<div class="job-tags">
						<span class="job-tag loc"><i class="ri-map-pin-line"></i>${job.location || '지역미정'}</span>
						${periodTag}
						<span class="job-tag"><i class="ri-time-line"></i>${workTime}</span>
					</div>
				</div>

				<div class="job-salary-col">
					<span class="pay-badge">${job.payType}</span>
					<span class="pay-amount">${Number(job.pay).toLocaleString()}원</span>
				</div>

				<div class="job-meta-info">
					<span class="job-date-text ${fresh ? 'fresh' : ''}">${relTime}</span>
				</div>
			</div>

			<button class="scrap-btn ${scrapCls}"
			        onclick="toggleScrap(event, ${job.postingIdx}, this)">
				<i class="ri-star-fill"></i>
			</button>
		</div>`;
	}).join('');
}

function renderPagination() {
	const total = Math.ceil(filteredJobs.length / PAGE_SIZE);
	const pg = document.getElementById('pagination');
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

/* ===== 지역 데이터 ===== */
function loadGugunData(sidoName) {
	const gugunList = document.getElementById('col-gugun');
	const dongList  = document.getElementById('col-dong');
	gugunList.innerHTML = '';
	dongList.innerHTML  = '';

	fetch(API_BASE_URL + "?regcode_pattern=*00000000")
		.then(res => res.json())
		.then(data => {
			const sidoObj = data.regcodes.find(r => r.name.startsWith(sidoName));
			if (!sidoObj) return;
			const pattern = sidoObj.code.substring(0, 2) + "*00000";
			return fetch(API_BASE_URL + "?regcode_pattern=" + pattern + "&is_ignore_zero=true");
		})
		.then(res => res.json())
		.then(data => {
			data.regcodes.forEach(item => {
				const nameParts = item.name.split(" ");
				const gugunName = nameParts.slice(1).join(" ");
				const li = document.createElement('li');
				li.textContent = gugunName;
				li.dataset.code = item.code;
				gugunList.appendChild(li);
			});
		})
		.catch(err => console.error(err));
}

function loadDongData(gugunName) {
	const dongList  = document.getElementById('col-dong');
	if (!dongList) return;
	const gugunCode = window.selectedGugunCode;
	if (!gugunCode) return;

	const pattern = gugunCode.substring(0, 4) + "*&is_ignore_zero=true";

	fetch(API_BASE_URL + "?regcode_pattern=" + pattern)
		.then(res => res.json())
		.then(data => {
			dongList.innerHTML = '';
			const filtered = data.regcodes.filter(item => item.code !== gugunCode);
			if (!filtered.length) { dongList.innerHTML = '<li>검색 결과 없음</li>'; return; }
			filtered.forEach(item => {
				const nameParts = item.name.split(" ");
				const dongName  = nameParts[nameParts.length - 1];
				const li = document.createElement('li');
				li.textContent = dongName;
				li.onclick = function() {
					document.querySelectorAll('#col-dong li').forEach(el => el.classList.remove('active'));
					this.classList.add('active');
					applyAreaFilter();
				};
				dongList.appendChild(li);
			});
		})
		.catch(err => { console.error(err); dongList.innerHTML = '<li>로드 실패</li>'; });
}

function resetFilters() {
	document.querySelectorAll('.col-list li').forEach(li => li.classList.remove('active'));
	document.getElementById('col-dong').innerHTML  = '';
	document.getElementById('col-gugun').innerHTML = '<li>먼저 시/도를 선택해주세요</li>';
	document.getElementById('filterCount').textContent = '0';
	document.querySelector('.filter-search-box input').value = '';
}

function setupColumnSelection(colId) {
	const list = document.getElementById(colId);
	if (!list) return;
	list.addEventListener('click', function(e) {
		if (e.target.tagName === 'LI') {
			list.querySelectorAll('li').forEach(item => item.classList.remove('active'));
			e.target.classList.add('active');
			const selectedText = e.target.textContent;
			if      (colId === 'col-sido')  loadGugunData(selectedText);
			else if (colId === 'col-gugun') { window.selectedGugunCode = e.target.dataset.code; loadDongData(selectedText); }
			else if (colId === 'col-dong')  applyAreaFilter();
		}
	});
}

document.addEventListener('DOMContentLoaded', function() {
	if (myRegion && myRegion.sido) {
		applyAreaFilterAuto(myRegion.sido, myRegion.gugun, myRegion.dong)
			.then(() => { if (filteredJobs.length === 0) applyFilters(); });
	} else {
		setTimeout(applyFilters, 100);
	}

	document.querySelectorAll('.filter-section .filter-chips, .filter-section[data-filter-type="category"]').forEach(group => {
		group.querySelectorAll('.chip').forEach(chip => {
			chip.addEventListener('click', function() {
				group.querySelectorAll('.chip').forEach(c => c.classList.remove('active'));
				this.classList.add('active');
				applyFilters();
			});
		});
	});

	const tabs       = document.querySelectorAll('.filter-tab');
	const areaPanel  = document.getElementById('filterAreaPanel');
	const filterWrap = document.querySelector('.advanced-filter-wrap');

	tabs.forEach(tab => {
		tab.addEventListener('click', function(e) {
			e.preventDefault();
			const value = this.querySelector('input')?.value;
			if (value === 'area') {
				if (areaPanel.classList.contains('active')) {
					areaPanel.classList.remove('active');
					this.classList.remove('active');
				} else {
					tabs.forEach(t => t.classList.remove('active'));
					this.classList.add('active');
					areaPanel.classList.add('active');
				}
			} else {
				tabs.forEach(t => t.classList.remove('active'));
				this.classList.add('active');
				areaPanel.classList.remove('active');
			}
		});
	});

	document.addEventListener('click', function(e) {
		if (!filterWrap.contains(e.target)) {
			tabs.forEach(t => t.classList.remove('active'));
			areaPanel.classList.remove('active');
		}
	});

	setupColumnSelection('col-sido');
	setupColumnSelection('col-gugun');
	setupColumnSelection('col-dong');
});

function applyAreaFilter() {
	const sido  = normalizeSido(document.querySelector('#col-sido li.active')?.textContent || '');
	const gugun = document.querySelector('#col-gugun li.active')?.textContent || '';
	const dong  = document.querySelector('#col-dong li.active')?.textContent  || '';

	fetch(`${CONTEXT_PATH}/alba/filter?sido=${sido}&gugun=${gugun}&dong=${dong}`)
		.then(res => res.json())
		.then(data => {
			filteredJobs = data.map(job => ({
				postingIdx:  job.postingIdx,
				title:       job.title,
				employer:    job.employer || '업체명',
				payType:     job.payType,
				pay:         job.pay || 0,
				location:    job.location,
				createdDate: job.createdDate,
				workPeriod:  job.workPeriod,
				category:    job.category,
				startTime:   job.startTime,
				endTime:     job.endTime,
				isScrapped:  job.isScrapped
			}));
			currentPage = 1;
			const rc2 = document.getElementById('sidebarResultCount');
			if (rc2) rc2.textContent = filteredJobs.length;
			const rc = document.getElementById('resultCount');
			if (rc) rc.textContent = filteredJobs.length;
			renderCurrentPage();
			renderPagination();
		})
		.catch(err => console.error(err));
}

async function applyAreaFilterAuto(sido, gugun, dong) {
	sido = normalizeSido(sido);
	const res  = await fetch(`${CONTEXT_PATH}/alba/filter?sido=${sido}&gugun=${gugun}&dong=${dong}`);
	const data = await res.json();
	filteredJobs = data;
	renderCurrentPage();
	renderPagination();

	const sidoEl = [...document.querySelectorAll('#col-sido li')].find(li => li.textContent.includes(sido));
	if (!sidoEl) return;
	sidoEl.click();

	await waitForElement('#col-gugun li');
	const gugunEl = [...document.querySelectorAll('#col-gugun li')].find(li => li.textContent.includes(gugun));
	if (!gugunEl) return;
	gugunEl.click();

	await waitForElement('#col-dong li');
	const dongEl = [...document.querySelectorAll('#col-dong li')].find(li => li.textContent.includes(dong));
	if (dongEl) dongEl.click();
}

function waitForElement(selector) {
	return new Promise(resolve => {
		const interval = setInterval(() => {
			if (document.querySelector(selector)) { clearInterval(interval); resolve(); }
		}, 50);
	});
}

function normalizeSido(sido) {
	if (!sido) return '';
	return sido
		.replace('특별시', '').replace('광역시', '')
		.replace('특별자치시', '').replace('도', '');
}

function toggleScrap(event, postingIdx) {
	event.stopPropagation();
	const btn      = event.currentTarget;
	const isAdding = !btn.classList.contains('active');

	fetch(`${CONTEXT_PATH}/alba/scrap`, {
		method: 'POST',
		headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
		body: `postingIdx=${postingIdx}&isScrap=${isAdding}`
	})
	.then(res => res.json())
	.then(data => {
		if (data.status === "login_required") {
			alert("로그인이 필요한 기능입니다.");
			location.href = CONTEXT_PATH + "/member/login";
		} else if (data.status === "success") {
			btn.classList.toggle('active');
            
			if (isAdding) {
				myScrapIds.push(Number(postingIdx));
			} else {
				myScrapIds = myScrapIds.filter(id => id !== Number(postingIdx));
			}
		}
	})
	.catch(err => console.error(err));
}