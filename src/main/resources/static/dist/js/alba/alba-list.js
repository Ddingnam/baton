const API_BASE_URL = "https://grpc-proxy-server-mkvo6j4wsq-du.a.run.app/v1/regcodes";
const CAT_MAP = {
    "서빙": "서빙",
    "주방보조": "주방보조",
    "매장관리": "매장관리",
    "음료제조": "음료제조",
    "기타": "기타"
};

const CAT_INFO = {
    "서빙": { emoji: "🍽️", cls: "cat-serving" },
    "주방보조": { emoji: "👨‍🍳", cls: "cat-kitchen" },
    "매장관리": { emoji: "🏪", cls: "cat-store" },
    "음료제조": { emoji: "☕", cls: "cat-beverage" },
    "기타": { emoji: "💼", cls: "cat-other" }
};

const RANGE_LABELS = ["내 동네", "가까운 동네", "먼 동네"];

let currentPage = 1;
let PAGE_SIZE = 20;

function getRelativeTime(dateStr) {
    if (!dateStr) return "";

    const now = new Date();
    const date = new Date(dateStr);
    const diff = Math.floor((now - date) / 60000);

    if (diff < 1) return "방금전";
    if (diff < 60) return `${diff}분전`;
    if (diff < 1440) return `${Math.floor(diff / 60)}시간전`;
    return `${Math.floor(diff / 1440)}일전`;
}

function isFresh(dateStr) {
    if (!dateStr) return false;
    const diff = Math.floor((new Date() - new Date(dateStr)) / 60000);
    return diff < 60;
}

function normalizeSido(sido) {
    if (!sido) return "";

    return sido
        .replace("특별시", "")
        .replace("광역시", "")
        .replace("특별자치시", "")
        .replace("특별자치도", "")
        .replace("자치시", "")
        .replace("도", "")
        .trim();
}

function updateCounts(count) {
    const sidebarCount = document.getElementById("sidebarResultCount");
    const resultCount = document.getElementById("resultCount");

    if (sidebarCount) sidebarCount.textContent = count;
    if (resultCount) resultCount.textContent = count;
}

function mapJobs(data) {
    return data.map(job => ({
        postingIdx: job.postingIdx,
        title: job.title,
        employer: job.employer || "업체명",
        payType: job.payType,
        pay: job.pay || 0,
        location: job.location,
        createdDate: job.createdDate,
        workPeriod: job.workPeriod,
        category: job.category,
        startTime: job.startTime,
        endTime: job.endTime,
        recruitStatus: job.recruitStatus,
        isScrapped: myScrapIds.includes(Number(job.postingIdx)) ? 1 : 0
    }));
}

function applyFilters() {
    const keywordEl = document.getElementById("searchInput");
    const keyword = keywordEl ? keywordEl.value.trim().toLowerCase() : "";

    const periodEl = document.querySelector('.filter-section[data-filter-type="period"] .chip.active');
    const period = periodEl ? periodEl.textContent.trim() : "전체";
    const catEl = document.querySelector('.filter-section[data-filter-type="category"] .chip.active');
    const cat = catEl ? catEl.textContent.trim() : "전체";
    const minPayInput = document.getElementById("minPayInput");
    const minPay = minPayInput ? (parseInt(minPayInput.value, 10) || 0) : 0;

    const topPeriodEl = document.getElementById("periodSelect");
    const topPeriod = topPeriodEl ? topPeriodEl.value : "ALL";
    const sortEl = document.getElementById("sortSelect");
    const sort = sortEl ? sortEl.value : "latest";
    const sizeEl = document.getElementById("sizeSelect");

    if (sizeEl) PAGE_SIZE = parseInt(sizeEl.value, 10) || 20;

    let jobs = [...serverData];

    if (keyword) {
        jobs = jobs.filter(j =>
            (j.title || "").toLowerCase().includes(keyword) ||
            (j.employer || "").toLowerCase().includes(keyword) ||
            (j.location || "").toLowerCase().includes(keyword)
        );
    }

    if (topPeriod !== "ALL") {
        const now = new Date();
        jobs = jobs.filter(j => {
            if (!j.createdDate) return false;
            const date = new Date(j.createdDate);
            const diffDays = (now - date) / (1000 * 60 * 60 * 24);

            if (topPeriod === "TODAY") return diffDays < 1;
            if (topPeriod === "WITHIN_THREE_DAYS") return diffDays <= 3;
            if (topPeriod === "WITHIN_SEVEN_DAYS") return diffDays <= 7;
            return true;
        });
    }

    if (period !== "전체") {
        jobs = jobs.filter(j =>
            (period === "1개월 이상" && j.workPeriod === "MORE_THAN_A_MONTH") ||
            (period === "단기" && j.workPeriod === "LESS_THAN_A_MONTH")
        );
    }

    if (cat !== "전체") {
        const mappedCat = CAT_MAP[cat] || cat;
        jobs = jobs.filter(j => j.category === mappedCat);
    }

    if (minPay > 0) {
        jobs = jobs.filter(j => j.payType !== "시급" || j.pay >= minPay);
    }

    if (sort === "pay_high") {
        jobs.sort((a, b) => b.pay - a.pay);
    } else {
        jobs.sort((a, b) => Number(b.postingIdx) - Number(a.postingIdx));
    }

    filteredJobs = jobs;
    currentPage = 1;
    updateCounts(jobs.length);
    renderCurrentPage();
    renderPagination();
}

function renderCurrentPage() {
    const start = (currentPage - 1) * PAGE_SIZE;
    renderList(filteredJobs.slice(start, start + PAGE_SIZE));
}

function renderList(jobs) {
    const container = document.getElementById("listView");
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
        const relTime = getRelativeTime(job.createdDate);
        const fresh = isFresh(job.createdDate);
        const workTime = (job.startTime && job.endTime)
            ? `${job.startTime}~${job.endTime}`
            : "시간협의";
        const scrapCls = myScrapIds.includes(Number(job.postingIdx)) ? "active" : "";
        const catInfo = CAT_INFO[job.category] || { emoji: "💼", cls: "cat-other" };

        const isShort = job.workPeriod === "LESS_THAN_A_MONTH";
        const isLong = job.workPeriod === "MORE_THAN_A_MONTH";
        const periodTag = isShort
            ? `<span class="job-tag period-short">⚡ 단기</span>`
            : isLong
                ? `<span class="job-tag period-long">📅 장기</span>`
                : "";

        const isRecruiting = job.recruitStatus === "RECRUITING";

        return `
        <div class="job-list-item alba-card ${!isRecruiting ? "job-disabled" : ""}"
             onclick="${isRecruiting ? `location.href='${CONTEXT_PATH}/alba/article/${job.postingIdx}'` : ""}">

            <div class="job-cat-bar ${catInfo.cls}"></div>
            <div class="job-cat-icon">${catInfo.emoji}</div>

            <div class="job-item-body card-body">
                <div class="job-article-col">
                    <div class="job-employer">${job.employer}</div>
                    <div class="job-title">${job.title}</div>
                    <div class="job-tags">
                        <span class="job-tag loc"><i class="ri-map-pin-line"></i>${job.location || "지역미정"}</span>
                        ${periodTag}
                        <span class="job-tag"><i class="ri-time-line"></i>${workTime}</span>
                    </div>
                </div>

                <div class="job-salary-col">
                    <span class="pay-badge">${job.payType}</span>
                    <span class="pay-amount">${Number(job.pay).toLocaleString()}원</span>
                </div>

                <div class="job-meta-info">
                    <span class="job-date-text ${fresh ? "fresh" : ""}">${relTime}</span>
                    <span class="${isRecruiting ? "theme-badge" : "theme-badge-done"}">
                        ${isRecruiting ? "모집중" : "모집완료"}
                    </span>
                </div>
            </div>

            <button class="scrap-btn ${scrapCls}"
                    onclick="toggleScrap(event, ${job.postingIdx}, this)">
                <i class="ri-star-fill"></i>
            </button>

        </div>`;
    }).join("");
}

function renderPagination() {
    const total = Math.ceil(filteredJobs.length / PAGE_SIZE);
    const pagination = document.getElementById("pagination");
    if (!pagination) return;
    if (total <= 1) {
        pagination.innerHTML = "";
        return;
    }

    let html = `<button class="page-btn" onclick="goPage(${currentPage - 1})" ${currentPage === 1 ? "disabled" : ""}>
                  <i class="ri-arrow-left-s-line"></i>
                </button>`;

    const start = Math.max(1, currentPage - 4);
    const end = Math.min(total, start + 9);

    for (let i = start; i <= end; i++) {
        html += `<button class="page-btn ${i === currentPage ? "active" : ""}" onclick="goPage(${i})">${i}</button>`;
    }

    html += `<button class="page-btn" onclick="goPage(${currentPage + 1})" ${currentPage === total ? "disabled" : ""}>
               <i class="ri-arrow-right-s-line"></i>
             </button>`;

    pagination.innerHTML = html;
}

function goPage(page) {
    const total = Math.ceil(filteredJobs.length / PAGE_SIZE);
    if (page < 1 || page > total) return;
    currentPage = page;
    renderCurrentPage();
    renderPagination();
    window.scrollTo({ top: 0, behavior: "smooth" });
}

function loadGugunData(sidoName) {
    const gugunList = document.getElementById("col-gugun");
    const dongList = document.getElementById("col-dong");
    if (!gugunList || !dongList) return;

    gugunList.innerHTML = "";
    dongList.innerHTML = "";

    fetch(`${API_BASE_URL}?regcode_pattern=*00000000`)
        .then(res => res.json())
        .then(data => {
            const sidoObj = data.regcodes.find(r => r.name.startsWith(sidoName));
            if (!sidoObj) return null;
            const pattern = `${sidoObj.code.substring(0, 2)}*00000`;
            return fetch(`${API_BASE_URL}?regcode_pattern=${pattern}&is_ignore_zero=true`);
        })
        .then(res => res ? res.json() : null)
        .then(data => {
            if (!data) return;
            data.regcodes.forEach(item => {
                const nameParts = item.name.split(" ");
                const gugunName = nameParts.slice(1).join(" ");
                const li = document.createElement("li");
                li.textContent = gugunName;
                li.dataset.code = item.code;
                gugunList.appendChild(li);
            });
        })
        .catch(err => console.error(err));
}

function loadDongData() {
    const dongList = document.getElementById("col-dong");
    if (!dongList) return;

    const gugunCode = window.selectedGugunCode;
    if (!gugunCode) return;

    const pattern = `${gugunCode.substring(0, 4)}*&is_ignore_zero=true`;

    fetch(`${API_BASE_URL}?regcode_pattern=${pattern}`)
        .then(res => res.json())
        .then(data => {
            dongList.innerHTML = "";
            const filtered = data.regcodes.filter(item => item.code !== gugunCode);

            if (!filtered.length) {
                dongList.innerHTML = "<li>검색 결과 없음</li>";
                return;
            }

            filtered.forEach(item => {
                const nameParts = item.name.split(" ");
                const dongName = nameParts[nameParts.length - 1];
                const li = document.createElement("li");
                li.textContent = dongName;
                dongList.appendChild(li);
            });
        })
        .catch(err => {
            console.error(err);
            dongList.innerHTML = "<li>로드 실패</li>";
        });
}

function resetFilters() {
    document.querySelectorAll(".col-list li").forEach(li => li.classList.remove("active"));

    const dongList = document.getElementById("col-dong");
    const gugunList = document.getElementById("col-gugun");
    const counter = document.getElementById("filterCount");
    const areaSearch = document.querySelector(".filter-search-box input");
    const slider = document.getElementById("rangeSlider");

    if (dongList) dongList.innerHTML = "";
    if (gugunList) gugunList.innerHTML = "<li>먼저 시/도를 선택해주세요</li>";
    if (counter) counter.textContent = "0";
    if (areaSearch) areaSearch.value = "";
    if (slider) slider.value = 0;

    applyRangeFilter(0);
}

function setupColumnSelection(colId) {
    const list = document.getElementById(colId);
    if (!list) return;

    list.addEventListener("click", function (e) {
        if (e.target.tagName !== "LI") return;

        list.querySelectorAll("li").forEach(item => item.classList.remove("active"));
        e.target.classList.add("active");

        if (colId === "col-sido") {
            loadGugunData(e.target.textContent);
        } else if (colId === "col-gugun") {
            window.selectedGugunCode = e.target.dataset.code;
            loadDongData();
            applyAreaFilter();
        } else if (colId === "col-dong") {
            applyAreaFilter();
        }
    });
}

function applyViewMode(mode) {
    const viewBtns = document.querySelectorAll(".view-btn");
    const listContainer = document.getElementById("listView");
    if (!listContainer) return;

    viewBtns.forEach(btn => {
        if (btn.title.includes(mode === "grid" ? "그리드" : "리스트")) {
            btn.classList.add("active");
        } else {
            btn.classList.remove("active");
        }
    });

    if (mode === "grid") {
        listContainer.classList.remove("list-layout");
        listContainer.classList.add("grid-layout");
    } else {
        listContainer.classList.remove("grid-layout");
        listContainer.classList.add("list-layout");
    }
}

function fetchAreaJobs(sido, gugun, dong) {
    const params = new URLSearchParams({
        sido: normalizeSido(sido || ""),
        gugun: gugun || "",
        dong: dong || ""
    });

    return fetch(`${CONTEXT_PATH}/alba/filter?${params.toString()}`)
        .then(res => res.json())
        .then(data => mapJobs(data));
}

function syncRegionSelection(sido, gugun, dong) {
    const sidoEl = [...document.querySelectorAll("#col-sido li")]
        .find(li => li.textContent.includes(normalizeSido(sido)));
    if (sidoEl) {
        document.querySelectorAll("#col-sido li").forEach(li => li.classList.remove("active"));
        sidoEl.classList.add("active");
    }

    const gugunEl = [...document.querySelectorAll("#col-gugun li")]
        .find(li => li.textContent.includes(gugun));
    if (gugunEl) {
        document.querySelectorAll("#col-gugun li").forEach(li => li.classList.remove("active"));
        gugunEl.classList.add("active");
    }

    const dongEl = [...document.querySelectorAll("#col-dong li")]
        .find(li => li.textContent.includes(dong));
    if (dongEl) {
        document.querySelectorAll("#col-dong li").forEach(li => li.classList.remove("active"));
        dongEl.classList.add("active");
    }
}

function getRangeFilter(step) {
    if (!myRegion || !myRegion.sido) return null;

    if (step === 0) {
        return {
            sido: myRegion.sido,
            gugun: myRegion.gugun,
            dong: myRegion.dong
        };
    }

    if (step === 1) {
        return {
            sido: myRegion.sido,
            gugun: myRegion.gugun,
            dong: ""
        };
    }

    return {
        sido: myRegion.sido,
        gugun: "",
        dong: ""
    };
}

function applyAreaFilter() {
    const sido = document.querySelector("#col-sido li.active")?.textContent || "";
    const gugun = document.querySelector("#col-gugun li.active")?.textContent || "";
    const dong = document.querySelector("#col-dong li.active")?.textContent || "";

    fetchAreaJobs(sido, gugun, dong)
        .then(jobs => {
            filteredJobs = jobs;
            currentPage = 1;
            updateCounts(filteredJobs.length);
            renderCurrentPage();
            renderPagination();
        })
        .catch(err => console.error(err));
}

async function applyAreaFilterAuto(sido, gugun, dong) {
    filteredJobs = await fetchAreaJobs(sido, gugun, dong);
    currentPage = 1;
    updateCounts(filteredJobs.length);
    renderCurrentPage();
    renderPagination();

    const sidoEl = [...document.querySelectorAll("#col-sido li")]
        .find(li => li.textContent.includes(normalizeSido(sido)));
    if (!sidoEl) return;

    sidoEl.click();
    await waitForElement("#col-gugun li");

    syncRegionSelection(sido, gugun, dong);

    const gugunEl = [...document.querySelectorAll("#col-gugun li")]
        .find(li => li.textContent.includes(gugun));
    if (!gugunEl) return;

    gugunEl.click();
    await waitForElement("#col-dong li");

    syncRegionSelection(sido, gugun, dong);
}

function waitForElement(selector) {
    return new Promise(resolve => {
        const interval = setInterval(() => {
            if (document.querySelector(selector)) {
                clearInterval(interval);
                resolve();
            }
        }, 50);
    });
}

function toggleScrap(event, postingIdx, btn) {
    event.preventDefault();
    event.stopPropagation();

    if (btn.disabled) return;
    btn.disabled = true;

    const isAdding = !btn.classList.contains("active");

    fetch(`${CONTEXT_PATH}/alba/scrap`, {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: `postingIdx=${postingIdx}&isScrap=${isAdding}`
    })
        .then(res => res.json())
        .then(data => {
            if (data.status === "login_required") {
                alert("로그인이 필요합니다.");
                location.href = `${CONTEXT_PATH}/member/login`;
                return;
            }

            if (data.status === "duplicate") {
                btn.classList.add("active");
                if (!myScrapIds.includes(Number(postingIdx))) {
                    myScrapIds.push(Number(postingIdx));
                }
                return;
            }

            if (data.status === "success") {
                if (isAdding) {
                    btn.classList.add("active");
                    if (!myScrapIds.includes(Number(postingIdx))) {
                        myScrapIds.push(Number(postingIdx));
                    }
                } else {
                    btn.classList.remove("active");
                    myScrapIds = myScrapIds.filter(id => id !== Number(postingIdx));
                }
            }
        })
        .catch(err => console.error(err))
        .finally(() => {
            btn.disabled = false;
        });
}

function applyRangeFilter(step) {
    const filter = getRangeFilter(step);
    const label = document.getElementById("rangeValueLabel");
    if (label) label.textContent = RANGE_LABELS[step];

    document.querySelectorAll(".range-step").forEach(el => {
        el.classList.toggle("active", Number(el.dataset.step) === step);
    });

    const slider = document.getElementById("rangeSlider");
    if (slider) {
        const pct = (step / (slider.max - slider.min)) * 100;
        slider.style.background =
            `linear-gradient(to right, var(--primary) ${pct}%, var(--border-color) ${pct}%)`;
    }

    if (!filter) {
        applyFilters();
        return;
    }

    fetchAreaJobs(filter.sido, filter.gugun, filter.dong)
        .then(jobs => {
            filteredJobs = jobs;
            currentPage = 1;
            updateCounts(filteredJobs.length);
            renderCurrentPage();
            renderPagination();
            syncRegionSelection(filter.sido, filter.gugun, filter.dong);
        })
        .catch(err => console.error(err));
}

document.addEventListener("DOMContentLoaded", function () {
    if (myRegion && myRegion.sido) {
        applyAreaFilterAuto(myRegion.sido, myRegion.gugun, myRegion.dong)
            .then(() => {
                if (filteredJobs.length === 0) {
                    applyFilters();
                }
            })
            .catch(() => applyFilters());
    } else {
        setTimeout(applyFilters, 100);
    }

    document.querySelectorAll('.filter-section .filter-chips, .filter-section[data-filter-type="category"]').forEach(group => {
        group.querySelectorAll(".chip").forEach(chip => {
            chip.addEventListener("click", function () {
                group.querySelectorAll(".chip").forEach(c => c.classList.remove("active"));
                this.classList.add("active");
                applyFilters();
            });
        });
    });

    const tabs = document.querySelectorAll(".filter-tab");
    const areaPanel = document.getElementById("filterAreaPanel");
    const filterWrap = document.querySelector(".advanced-filter-wrap");

    tabs.forEach(tab => {
        tab.addEventListener("click", function (e) {
            e.preventDefault();
            const value = this.querySelector("input")?.value;

            if (value === "area") {
                if (areaPanel.classList.contains("active")) {
                    areaPanel.classList.remove("active");
                    this.classList.remove("active");
                } else {
                    tabs.forEach(t => t.classList.remove("active"));
                    this.classList.add("active");
                    areaPanel.classList.add("active");
                }
            } else {
                tabs.forEach(t => t.classList.remove("active"));
                this.classList.add("active");
                areaPanel.classList.remove("active");
            }
        });
    });

    document.addEventListener("click", function (e) {
        if (filterWrap && !filterWrap.contains(e.target)) {
            tabs.forEach(t => t.classList.remove("active"));
            if (areaPanel) areaPanel.classList.remove("active");
        }
    });

    setupColumnSelection("col-sido");
    setupColumnSelection("col-gugun");
    setupColumnSelection("col-dong");

    const viewBtns = document.querySelectorAll(".view-btn");
    const listContainer = document.getElementById("listView");
    if (viewBtns.length > 0 && listContainer) {
        const savedView = localStorage.getItem("albaViewMode") || "list";
        applyViewMode(savedView);

        viewBtns.forEach(btn => {
            btn.addEventListener("click", e => {
                const mode = e.currentTarget.title.includes("그리드") ? "grid" : "list";
                applyViewMode(mode);
                localStorage.setItem("albaViewMode", mode);
            });
        });
    }

    const slider = document.getElementById("rangeSlider");
    if (slider) {
        slider.style.background =
            "linear-gradient(to right, var(--primary) 0%, var(--border-color) 0%)";

        slider.addEventListener("input", function () {
            applyRangeFilter(Number(this.value));
        });
    }

    document.querySelectorAll(".range-step").forEach(el => {
        el.addEventListener("click", function () {
            const step = Number(this.dataset.step);
            if (slider) slider.value = step;
            applyRangeFilter(step);
        });
    });
});
