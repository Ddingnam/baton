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

function cmSwitchView(mode) {
    const area = document.getElementById('cmContentArea');
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

function submitSearch() {
    const f = document.searchForm;
    f.page.value = "1";
    f.submit();
}

function filterByCategory(category) {
    const f = document.searchForm;
    f.category.value = category;
    f.page.value = "1";
    f.submit();
}

function filterBySort(sortValue) {
    const f = document.searchForm;
    f.sort.value = sortValue;
    f.page.value = "1";
    f.submit();
}