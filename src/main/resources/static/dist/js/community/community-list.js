document.addEventListener("DOMContentLoaded", () => {
    const savedMode = localStorage.getItem('cmViewMode') || 'grid';
    cmSwitchView(savedMode);

    const fab = document.getElementById('cmFab');
    if (fab) {
        window.addEventListener('scroll', () => {
            fab.style.display = window.scrollY > 300 ? 'flex' : 'none';
        });
    }
});

function getCurrentRegionType() {
    const el = document.getElementById('currentRegionType');
    return el ? el.value : '1';
}

function changeRegionTab(regionType) {
    const f = document.searchForm;
    if (f) {
        f.regionType.value = regionType;
        f.category.value = '';
        f.sort.value = 'latest';
        f.page.value = '1';
        f.kwd.value = '';
        f.submit();
    } else {
        const cp = document.querySelector('meta[name="contextPath"]')
                   ? document.querySelector('meta[name="contextPath"]').content : '';
        location.href = cp + '/community/list?regionType=' + regionType;
    }
}

function goToWrite() {
    const rt = getCurrentRegionType();
    // contextPath 는 list.jsp 인라인 <script>에서 전역 변수로 선언되어 있음
    location.href = contextPath + '/community/write?regionType=' + rt;
}

function filterByCategory(category) {
    const f = document.searchForm;
    f.category.value = category;
    f.page.value = '1';
    if (f.regionType) f.regionType.value = getCurrentRegionType();
    f.submit();
}

function filterBySort(sortValue) {
    const f = document.searchForm;
    f.sort.value = sortValue;
    f.page.value = '1';
    if (f.regionType) f.regionType.value = getCurrentRegionType();
    f.submit();
}

function submitSearch() {
    const f = document.searchForm;
    f.page.value = '1';
    if (f.regionType) f.regionType.value = getCurrentRegionType();
    f.submit();
}

function cmSwitchView(mode) {
    const area    = document.getElementById('cmContentArea');
    const gridBtn = document.getElementById('grid-view-btn');
    const listBtn = document.getElementById('list-view-btn');

    if (!area || !gridBtn || !listBtn) return;

    localStorage.setItem('cmViewMode', mode);

    if (mode === 'grid') {
        area.classList.remove('list-mode');
        area.classList.add('grid-mode');
        gridBtn.classList.add('active');
        listBtn.classList.remove('active');
    } else {
        area.classList.remove('grid-mode');
        area.classList.add('list-mode');
        listBtn.classList.add('active');
        gridBtn.classList.remove('active');
    }
}