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
	if (diff < 1) return '방금전';
	if (diff < 60) return diff + '분전';
	if (diff < 1440) return Math.floor(diff / 60) + '시간전';
	return Math.floor(diff / 1440) + '일전';
}

function applyFilters() {
	const keywordEl = document.getElementById('searchInput');
	const keyword = keywordEl ? keywordEl.value.trim().toLowerCase() : '';

	const periodEl = document.querySelector('.filter-section[data-filter-type="period"] .chip.active');
	const period = periodEl ? periodEl.textContent.trim() : '전체';

	const catEl = document.querySelector('.filter-section[data-filter-type="category"] .chip.active');
	const cat = catEl ? catEl.textContent.trim() : '전체';

	const minPayInput = document.getElementById('minPayInput');
	const minPay = minPayInput ? (parseInt(minPayInput.value) || 0) : 0;

	const sortEl = document.getElementById('sortSelect');
	const sort = sortEl ? sortEl.value : 'latest';

	let jobs = [...serverData];

	if (keyword) {
		jobs = jobs.filter(j =>
			(j.title || '').toLowerCase().includes(keyword) ||
			(j.employer || '').toLowerCase().includes(keyword) ||
			(j.location || '').toLowerCase().includes(keyword)
		);
	}

	if (period !== '전체') {
		jobs = jobs.filter(j =>
			(period === '1개월 이상' && j.workPeriod === 'MORE_THAN_A_MONTH') ||
			(period === '단기' && j.workPeriod === 'LESS_THAN_A_MONTH')
		);
	}

	if (cat !== '전체') {
	    const mappedCat = CAT_MAP[cat] || cat; 
	    jobs = jobs.filter(j => j.category === mappedCat);
	}

	if (minPay > 0) {
		jobs = jobs.filter(j => j.payType !== 'hour' || j.pay >= minPay);
	}

	if (sort === 'pay_high') {
		jobs.sort((a, b) => b.pay - a.pay);
	} else {
		jobs.sort((a, b) => b.postingIdx - a.postingIdx);
	}

	filteredJobs = jobs;
	currentPage = 1;

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
		container.innerHTML = `<div class="no-result"><strong>검색 결과가 없어요</strong></div>`;
		return;
	}

	container.innerHTML = jobs.map(job => {
		const relTime = getRelativeTime(job.createdDate);
		const workTime = (job.startTime && job.endTime) ? `${job.startTime}~${job.endTime}` : '-';

		return `
      <div class="job-list-item" onclick="location.href='${CONTEXT_PATH}/alba/article/${job.postingIdx}'">
        <div class="job-area-col">
          <span class="job-area-text">${job.location || '지역미정'}</span>
        </div>
        <div class="job-article-col">
          <div class="job-employer">${job.employer}</div>
          <div class="job-title">${job.title}</div>
        </div>
        <div class="job-salary-col">
          <span class="pay-badge">${job.payType}</span>
          <div class="pay-amount">${Number(job.pay).toLocaleString()}원</div>
        </div>
        <div class="job-time-col">${workTime}</div>
        <div class="job-date-col">${relTime}</div>
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
	const end = Math.min(total, start + 9);

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

const areaData = {
	"서울": ["서울 전체", "강남구", "강동구", "강북구", "강서구", "관악구", "광진구", "구로구", "금천구", "노원구", "도봉구", "동대문구", "동작구", "마포구", "서대문구", "서초구", "성동구", "성북구", "송파구", "양천구", "영등포구", "용산구", "은평구", "종로구", "중구", "중랑구"],
	"경기": ["경기 전체", "가평군", "고양시", "과천시", "광명시", "광주시", "구리시", "군포시", "김포시", "남양주시", "동두천시", "부천시", "성남시", "수원시", "시흥시", "안산시", "안성시", "안양시", "양주시", "양평군", "여주시", "연천군", "오산시", "용인시", "의왕시", "의정부시", "이천시", "파주시", "평택시", "포천시", "하남시", "화성시"],
	"인천": ["인천 전체", "강화군", "계양구", "남동구", "동구", "미추홀구", "부평구", "서구", "연수구", "옹진군", "중구"],
	"강원": ["강원 전체", "강릉시", "고성군", "동해시", "삼척시", "속초시", "양구군", "양양군", "영월군", "원주시", "인제군", "정선군", "철원군", "춘천시", "태백시", "평창군", "홍천군", "화천군", "횡성군"]
};

function loadGugunData(sidoName) {
	const gugunList = document.getElementById('col-gugun');
	const dongList = document.getElementById('col-dong');

	gugunList.innerHTML = '';
	dongList.innerHTML = '';

	const guguns = areaData[sidoName] || [`${sidoName} 전체`];

	guguns.forEach(gugun => {
		const li = document.createElement('li');
		li.textContent = gugun;
		gugunList.appendChild(li);
	});

	gugunList.scrollTop = 0;
}

function loadDongData(gugunName) {
    const dongList = document.getElementById('col-dong');
    if (!dongList) return;

    // "전체"를 클릭한 경우
    if (gugunName.includes('전체')) {
        dongList.innerHTML = '<li class="all-selected">해당 지역 전체가 선택되었습니다.</li>';
        dongList.classList.add('empty'); // 필요에 따라 스타일 조절
        return; 
    }

    dongList.innerHTML = '<li>불러오는 중...</li>';
    dongList.classList.remove('empty');

    const sido = document.querySelector('#col-sido li.active')?.textContent || '';

    // fetch 호출... (기존 코드 유지)
    fetch(`${CONTEXT_PATH}/alba/dong?sido=${sido}&gugun=${gugunName}`)
        .then(res => res.json())
        .then(list => {
            dongList.innerHTML = '';
            if (!list || list.length === 0) {
                dongList.innerHTML = '<li>검색 결과 없음</li>';
                return;
            }
            list.forEach(dong => {
                const li = document.createElement('li');
                li.textContent = dong;
                dongList.appendChild(li);
            });
        })
        .catch(err => {
            console.error(err);
            dongList.innerHTML = '<li>데이터 로드 실패</li>';
        });
}

function resetFilters() {
	document.querySelectorAll('.col-list li').forEach(li => li.classList.remove('active'));
	document.getElementById('col-dong').innerHTML = '';
	document.getElementById('col-gugun').innerHTML = '<li>먼저 시/도를 선택해주세요</li>';
	document.getElementById('filterCount').textContent = '0';
	document.querySelector('.filter-search-box input').value = '';
}

function setupColumnSelection(colId) {
	const list = document.getElementById(colId);
	if (!list) return;

	list.addEventListener('click', function(e) {
		if (e.target.tagName === 'LI') {

			const items = list.querySelectorAll('li');
			items.forEach(item => item.classList.remove('active'));
			e.target.classList.add('active');

			const selectedText = e.target.textContent;

			if (colId === 'col-sido') {
				loadGugunData(selectedText);
			}
			else if (colId === 'col-gugun') {
				loadDongData(selectedText);
				applyAreaFilter();
			}
			else if (colId === 'col-dong') {
				applyAreaFilter();
			}
		}
	});
}

document.addEventListener('DOMContentLoaded', function() {

	setTimeout(applyFilters, 100);

	document.querySelectorAll('.filter-section .filter-chips, .filter-section[data-filter-type="category"]').forEach(group => {
		group.querySelectorAll('.chip').forEach(chip => {
			chip.addEventListener('click', function() {
				group.querySelectorAll('.chip').forEach(c => c.classList.remove('active'));
				this.classList.add('active');
				applyFilters();
			});
		});
	});


	const tabs = document.querySelectorAll('.filter-tab');
	const areaPanel = document.getElementById('filterAreaPanel');
	const filterWrap = document.querySelector('.advanced-filter-wrap');

	tabs.forEach(tab => {

		tab.addEventListener('click', function(e) {

			e.preventDefault();

			const value = this.querySelector('input')?.value;

			// 지역 탭
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
	const sido = document.querySelector('#col-sido li.active')?.textContent || '';
	const gugun = document.querySelector('#col-gugun li.active')?.textContent || '';
	const dong = document.querySelector('#col-dong li.active')?.textContent || '';

	fetch(`${CONTEXT_PATH}/alba/filter?sido=${sido}&gugun=${gugun}&dong=${dong}`)
		.then(res => res.json())
		.then(data => {
			filteredJobs = data.map(job => ({
				postingIdx: job.postingIdx,
				title: job.title,
				employer: job.employer || '업체명',
				payType: job.payType,
				pay: job.pay || 0,
				location: job.location,
				createdDate: job.createdDate,
				workPeriod: job.workPeriod,
				category: job.category,
				startTime: job.startTime,
				endTime: job.endTime
			}));

			currentPage = 1;
			const rc = document.getElementById('resultCount');
			if (rc) rc.textContent = filteredJobs.length;

			renderCurrentPage();
			renderPagination();
		})
		.catch(err => console.error(err));
}

function applyAreaFilterAuto(sido, gugun, dong) {
	
	sido = normalizeSido(sido);
	console.log("변환 후 sido:", sido);
    fetch(`${CONTEXT_PATH}/alba/filter?sido=${sido}&gugun=${gugun}&dong=${dong}`)
        .then(res => res.json())
        .then(data => {
            filteredJobs = data.map(job => ({
                postingIdx: job.postingIdx,
                title: job.title,
                employer: job.employer || '업체명',
                payType: job.payType,
                pay: job.pay || 0,
                location: job.location,
                createdDate: job.createdDate,
                workPeriod: job.workPeriod,
                category: job.category,
                startTime: job.startTime,
                endTime: job.endTime
            }));

            currentPage = 1;
            const rc = document.getElementById('resultCount');
            if (rc) rc.textContent = filteredJobs.length;

            renderCurrentPage();
            renderPagination();
        })
        .catch(err => console.error(err));

    // 2. 필터 모달창 UI (시/도, 구/군, 동) 선택 상태 동기화
    const sidoList = document.querySelectorAll('#col-sido li');
	sidoList.forEach(li => {
		li.classList.remove('active');
	    if (sido.includes(li.textContent) || li.textContent.includes(sido)) {
	        li.click(); // 👈 li.classList.add('active') 대신 .click()으로 써야 구/군 목록이 나옵니다!
	    }
    });

    // 구/군이 렌더링될 시간을 살짝 준 뒤 세팅
    setTimeout(() => {
        const gugunList = document.querySelectorAll('#col-gugun li');
        let matchedGugun = '';
        gugunList.forEach(li => {
            li.classList.remove('active');
            if (gugun.includes(li.textContent) || li.textContent.includes(gugun)) {
                li.classList.add('active');
                matchedGugun = li.textContent;
                loadDongData(matchedGugun); // 동 데이터 로드 (비동기)
            }
        });

        // 동/읍/면이 비동기로 렌더링될 시간을 준 뒤 세팅
        setTimeout(() => {
            const dongList = document.querySelectorAll('#col-dong li');
            dongList.forEach(li => {
                li.classList.remove('active');
                if (dong.includes(li.textContent) || li.textContent.includes(dong)) {
                    li.classList.add('active');
                }
            });
        }, 300); 
    }, 100);
}

function normalizeSido(sido) {
    if (!sido) return '';
    return sido
        .replace('특별시', '')
        .replace('광역시', '')
        .replace('특별자치시', '')
        .replace('도', '');
}

