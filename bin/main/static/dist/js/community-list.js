document.addEventListener("DOMContentLoaded", () => {
    renderActiveFilters();
});

function cmApplyFilter() {
    const keyword = document.getElementById('cmSearchInput').value.trim();
    const photoOnly = document.getElementById('cmPhotoOnly').checked;
    const sort = document.querySelector('.sort-select').value;
    
    const urlParams = new URLSearchParams(window.location.search);
    
    if (keyword) urlParams.set('keyword', keyword);
    else urlParams.delete('keyword');
    
    if (photoOnly) urlParams.set('photoOnly', 'true');
    else urlParams.delete('photoOnly');
    
    if (sort) urlParams.set('sort', sort);
    urlParams.set('page', '1');
    
    window.location.href = window.location.pathname + '?' + urlParams.toString();
}

function cmSetCategory(categoryIdx) {
    const urlParams = new URLSearchParams(window.location.search);
    if (categoryIdx) urlParams.set('categoryIdx', categoryIdx);
    else urlParams.delete('categoryIdx');
    urlParams.set('page', '1');
    window.location.href = window.location.pathname + '?' + urlParams.toString();
}

function cmChangeSort(sortValue) {
    const urlParams = new URLSearchParams(window.location.search);
    urlParams.set('sort', sortValue);
    urlParams.set('page', '1');
    window.location.href = window.location.pathname + '?' + urlParams.toString();
}

function cmGoPage(page) {
    const urlParams = new URLSearchParams(window.location.search);
    urlParams.set('page', page);
    window.location.href = window.location.pathname + '?' + urlParams.toString();
}

function cmToggleWish(event, boardIdx) {
    event.preventDefault();
    event.stopPropagation();
    const btn = event.currentTarget;
    btn.classList.toggle('active');
    btn.innerHTML = btn.classList.contains('active') ? '<i class="ri-heart-3-fill"></i>' : '<i class="ri-heart-3-line"></i>';
}

function renderActiveFilters() {
    const urlParams = new URLSearchParams(window.location.search);
    const filterContainer = document.getElementById('cmActiveFilters');
    if (!filterContainer) return;
    filterContainer.innerHTML = '';
    const keyword = urlParams.get('keyword');
    const photoOnly = urlParams.get('photoOnly');
    if (keyword) {
        const chip = document.createElement('div');
        chip.innerHTML = `검색어: ${keyword} <i class="ri-close-line" onclick="removeFilter('keyword')"></i>`;
        filterContainer.appendChild(chip);
    }
    if (photoOnly === 'true') {
        const chip = document.createElement('div');
        chip.innerHTML = `사진 있는 글 <i class="ri-close-line" onclick="removeFilter('photoOnly')"></i>`;
        filterContainer.appendChild(chip);
    }
}

function removeFilter(paramKey) {
    const urlParams = new URLSearchParams(window.location.search);
    urlParams.delete(paramKey);
    urlParams.set('page', '1');
    window.location.href = window.location.pathname + '?' + urlParams.toString();
}