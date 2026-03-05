let fileList = [];
let tagList = [];
let pollOptions = ['', ''];

document.addEventListener('DOMContentLoaded', () => {
    initFileZone();
    initTagInput();
    initCharCount();
    initCategoryPills();
    initPoll();
    // initLocation();  <-- [삭제] JSP에서 모달 창 제어로 변경됨
    
    // 등록 버튼 이벤트 연결
    const submitBtn = document.querySelector('.btn-submit');
    const submitFullBtn = document.querySelector('.btn-submit-full');
    if(submitBtn) submitBtn.addEventListener('click', sendPost);
    if(submitFullBtn) submitFullBtn.addEventListener('click', sendPost);
});

// ---------------------------------------------------------
// [1] 카테고리 & 글자수 로직
// ---------------------------------------------------------
function initCategoryPills() {
    document.querySelectorAll('.cat-pill input').forEach(radio => {
        radio.addEventListener('change', () => {
            const map = {
                '일상': '오늘 있었던 일을 이웃들과 나눠보세요!',
                '동네질문': '동네에 대해 궁금한 것을 물어보세요!',
                '동네맛집': '맛있었던 곳을 자랑해보세요!',
                '동네소식': '우리 동네 소식을 알려주세요!',
                '분실/실종': '분실물이나 실종 반려동물을 알려주세요!',
            };
            const ta = document.querySelector('.textarea-main');
            if (ta && map[radio.value]) ta.placeholder = map[radio.value];
        });
    });
}

function initCharCount() {
    const ta = document.querySelector('.textarea-main');
    const counter = document.getElementById('charCount');
    if (!ta || !counter) return;

    ta.addEventListener('input', () => {
        const len = ta.value.length;
        counter.textContent = len;
        if (len > 2000) {
            ta.value = ta.value.substring(0, 2000);
            counter.textContent = 2000;
        }
    });
}

// ---------------------------------------------------------
// [2] 파일 업로드 로직
// ---------------------------------------------------------
function initFileZone() {
    const dropZone = document.getElementById('dropZone');
    const fileInput = document.getElementById('fileInput');
    const addBtn = document.querySelector('.media-add-btn');

    if(addBtn) addBtn.addEventListener('click', () => fileInput.click());
    if(fileInput) fileInput.addEventListener('change', e => handleFiles(e.target.files));
    
    if(dropZone) {
        dropZone.addEventListener('dragover', e => { e.preventDefault(); dropZone.style.background = '#f0f2f5'; });
        dropZone.addEventListener('dragleave', e => { e.preventDefault(); dropZone.style.background = ''; });
        dropZone.addEventListener('drop', e => {
            e.preventDefault();
            dropZone.style.background = '';
            handleFiles(e.dataTransfer.files);
        });
    }
}

function handleFiles(files) {
    if (fileList.length + files.length > 10) {
        showToast('사진은 최대 10장까지 첨부할 수 있어요');
        return;
    }
    
    Array.from(files).forEach(file => {
        if (!file.type.startsWith('image/')) return;
        const reader = new FileReader();
        reader.onload = e => {
            fileList.push({ file: file, url: e.target.result });
            renderFileList();
        };
        reader.readAsDataURL(file);
    });
}

function renderFileList() {
    const list = document.getElementById('previewList');
    const items = list.querySelectorAll('.media-item');
    items.forEach(item => item.remove());

    fileList.forEach((item, idx) => {
        const div = document.createElement('div');
        div.className = 'media-item';
        div.innerHTML = `<img src="${item.url}"><button type="button" class="media-del-btn" data-idx="${idx}"><i class="ri-close-line"></i></button>`;
        list.appendChild(div);
    });

    list.querySelectorAll('.media-del-btn').forEach(btn => {
        btn.addEventListener('click', (e) => {
            const idx = parseInt(e.currentTarget.dataset.idx);
            removeFile(idx);
        });
    });

    document.getElementById('fileCount').innerText = fileList.length;
}

function removeFile(idx) {
    fileList.splice(idx, 1);
    renderFileList();
}

// ---------------------------------------------------------
// [3] 태그 입력 로직
// ---------------------------------------------------------
function initTagInput() {
    const input = document.getElementById('tagInput');
    if(!input) return;

    input.addEventListener('keydown', e => {
        if (e.key === 'Enter' || e.key === ' ') {
            e.preventDefault();
            addTag(input.value);
            input.value = '';
        }
    });
}

function addTag(text) {
    text = text.trim().replace(/^#/, '');
    if (!text || tagList.includes(text)) return;
    if (tagList.length >= 5) {
        showToast('태그는 최대 5개까지 가능해요');
        return;
    }
    tagList.push(text);
    renderTags();
}

function renderTags() {
    const container = document.getElementById('tagContainer');
    container.innerHTML = '';
    tagList.forEach((tag, idx) => {
        const span = document.createElement('span');
        span.className = 'tag-badge';
        span.innerText = '#' + tag;
        span.addEventListener('click', () => removeTag(idx));
        container.appendChild(span);
    });
}

function removeTag(idx) {
    tagList.splice(idx, 1);
    renderTags();
}

// ---------------------------------------------------------
// [4] 투표(Poll) 기능
// ---------------------------------------------------------
function initPoll() {
    const btnPoll = document.getElementById('btnPoll');
    const btnAddOption = document.querySelector('.btn-add-option');
    const btnClosePoll = document.querySelector('.btn-close-poll');

    if(btnPoll) btnPoll.addEventListener('click', togglePoll);
    if(btnAddOption) btnAddOption.addEventListener('click', addPollOption);
    if(btnClosePoll) btnClosePoll.addEventListener('click', togglePoll);

    renderPollOptions(); 
}

function togglePoll() {
    const section = document.getElementById('pollSection');
    const btn = document.getElementById('btnPoll');
    
    if (section.style.display === 'none') {
        section.style.display = 'block';
        btn.classList.add('active');
        section.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    } else {
        section.style.display = 'none';
        btn.classList.remove('active');
    }
}

function addPollOption() {
    if (pollOptions.length >= 10) {
        showToast('투표 항목은 최대 10개까지 가능해요');
        return;
    }
    pollOptions.push('');
    renderPollOptions();
}

function renderPollOptions() {
    const container = document.getElementById('pollOptionContainer');
    if(!container) return;
    container.innerHTML = '';

    pollOptions.forEach((val, idx) => {
        const div = document.createElement('div');
        div.className = 'poll-option-item';
        let html = `<input type="text" class="poll-input" value="${val}" placeholder="항목 ${idx + 1}" data-idx="${idx}">`;
        if (pollOptions.length > 2) {
            html += `<button type="button" class="btn-del-option" data-idx="${idx}"><i class="ri-close-line"></i></button>`;
        }
        div.innerHTML = html;
        container.appendChild(div);
    });

    container.querySelectorAll('.poll-input').forEach(input => {
        input.addEventListener('input', (e) => {
            const idx = parseInt(e.target.dataset.idx);
            pollOptions[idx] = e.target.value;
        });
    });

    container.querySelectorAll('.btn-del-option').forEach(btn => {
        btn.addEventListener('click', (e) => {
            const idx = parseInt(e.currentTarget.dataset.idx);
            removePollOption(idx);
        });
    });
}

function removePollOption(idx) {
    if (pollOptions.length <= 2) return;
    pollOptions.splice(idx, 1);
    renderPollOptions();
}

// ---------------------------------------------------------
// [5] 위치(Location) 데이터 처리 (UI 업데이트만 담당)
// ---------------------------------------------------------
// JSP의 검색 모달에서 이 함수를 호출합니다.
window.setLocation = function(name, addr, lat, lng) {
    // Hidden Fields 저장
    document.getElementById('placeName').value = name;
    document.getElementById('address').value = addr;
    document.getElementById('latitude').value = lat;
    document.getElementById('longitude').value = lng;

    // UI 업데이트
    document.getElementById('displayPlaceName').innerText = name;
    document.getElementById('displayAddress').innerText = addr;

    // 카드 보이기
    const card = document.getElementById('locationCard');
    const btn = document.getElementById('btnLocation');
    
    card.style.display = 'flex';
    btn.classList.add('active');
    card.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
};

// 위치 삭제 (UI 및 데이터 초기화)
window.removeLocation = function() {
    document.getElementById('placeName').value = '';
    document.getElementById('address').value = '';
    document.getElementById('latitude').value = '';
    document.getElementById('longitude').value = '';

    document.getElementById('locationCard').style.display = 'none';
    document.getElementById('btnLocation').classList.remove('active');
}

// 삭제 버튼 이벤트 연결
document.querySelector('.btn-del-loc')?.addEventListener('click', window.removeLocation);


// ---------------------------------------------------------
// [6] 게시글 등록 (AJAX)
// ---------------------------------------------------------
function sendPost() {
    const subject = document.getElementById('subject').value.trim();
    const content = document.getElementById('content').value.trim();

    if (!subject || !content) {
        showToast('제목과 내용을 모두 입력해주세요');
        return;
    }

    const dto = {
        category: document.querySelector('input[name="category"]:checked').value,
        subject: subject,
        content: content,
        visibility: document.querySelector('input[name="visibility"]:checked').value,
        tags: tagList,
        placeName: document.getElementById('placeName').value || null,
        address: document.getElementById('address').value || null,
        latitude: document.getElementById('latitude').value ? parseFloat(document.getElementById('latitude').value) : null,
        longitude: document.getElementById('longitude').value ? parseFloat(document.getElementById('longitude').value) : null,
        pollTitle: document.getElementById('pollTitle').value,
        pollOptions: pollOptions.filter(o => o.trim()),
        pollEndDate: document.getElementById('pollEndDate').value,
        pollMulti: document.getElementById('pollMulti').checked,
        pollAnonymous: document.getElementById('pollAnonymous').checked
    };

    if (dto.pollTitle && dto.pollOptions.length < 2) {
        showToast('투표 항목을 2개 이상 입력해주세요');
        return;
    }

    const ctx = document.querySelector('meta[name="contextPath"]')?.content || '';
    const formData = new FormData();
    formData.append('dto', new Blob([JSON.stringify(dto)], { type: 'application/json' }));
    
    fileList.forEach(item => {
        formData.append('uploadFiles', item.file);
    });

    const btns = document.querySelectorAll('.btn-submit, .btn-submit-full');
    btns.forEach(b => {
        b.disabled = true;
        b.innerHTML = '<i class="ri-loader-4-line ri-spin"></i> 등록 중...';
    });

    fetch(ctx + '/api/community', {
        method: 'POST',
        body: formData
    })
    .then(res => res.json())
    .then(data => {
        if (data.status === "true") {
            showToast(data.message);
            setTimeout(() => { location.href = ctx + '/community/list'; }, 800);
        } else {
            throw new Error(data.message || '등록 실패');
        }
    })
    .catch(err => {
        showToast(err.message || '등록에 실패했어요.');
        btns.forEach(b => {
            b.disabled = false;
            b.innerText = '등록';
        });
    });
}

function showToast(msg) {
    const container = document.getElementById('toastContainer');
    const div = document.createElement('div');
    div.className = 'toast';
    div.innerHTML = `<i class="ri-notification-badge-fill"></i> ${msg}`;
    container.appendChild(div);
    setTimeout(() => div.remove(), 3000);
}