let fileList = [];
let tagList = [];
let pollOptions = ['', ''];
let currentLocation = null;

document.addEventListener('DOMContentLoaded', () => {
    initFileZone();
    initTagInput();
    initCharCount();
    initCategoryPills();
    initToolbarButtons();
    renderPollOptions();
});

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
            counter.style.color = '#F04452';
        } else {
            counter.style.color = '#8B95A1';
        }
    });
}

function initFileZone() {
    const dropZone = document.getElementById('dropZone');
    const fileInput = document.getElementById('fileInput');

    dropZone.addEventListener('click', (e) => {
        if (e.target.closest('.media-item') || e.target.closest('.media-del-btn')) return;
        fileInput.click();
    });

    fileInput.addEventListener('change', (e) => {
        addFiles(e.target.files);
        fileInput.value = '';
    });

    dropZone.addEventListener('dragover', (e) => e.preventDefault());
    dropZone.addEventListener('drop', (e) => {
        e.preventDefault();
        addFiles(e.dataTransfer.files);
    });
}

function addFiles(files) {
    if (fileList.length + files.length > 10) {
        showToast('사진은 최대 10장까지 첨부할 수 있어요.');
        return;
    }

    const container = document.getElementById('previewList');
    const addBtn = document.querySelector('.media-add-btn');

    Array.from(files).forEach(file => {
        if (!file.type.match('image.*')) return;

        const reader = new FileReader();
        reader.onload = (e) => {
            fileList.push({ file: file, id: Date.now() + Math.random() });
            
            const div = document.createElement('div');
            div.className = 'media-item';
            div.innerHTML = `
                <img src="${e.target.result}">
                <button type="button" class="media-del-btn">&times;</button>
            `;
            
            div.querySelector('.media-del-btn').onclick = (evt) => {
                evt.stopPropagation();
                const idx = Array.from(container.children).indexOf(div) - 1;
                fileList.splice(idx, 1);
                div.remove();
                updateFileCount();
            };

            container.insertBefore(div, addBtn);
            updateFileCount();
        };
        reader.readAsDataURL(file);
    });
}

function updateFileCount() {
    document.getElementById('fileCount').textContent = fileList.length;
}

function initTagInput() {
    const input = document.getElementById('tagInput');
    
    input.addEventListener('keydown', (e) => {
        if (e.key === 'Enter' || e.key === ' ') {
            e.preventDefault();
            const val = input.value.trim().replace('#', '');
            if (val) addTag(val);
            input.value = '';
        }
        if (e.key === 'Backspace' && !input.value && tagList.length > 0) {
            removeTag(tagList.length - 1);
        }
    });
}

function addTag(text) {
    if (tagList.includes(text)) return;
    if (tagList.length >= 5) {
        showToast('태그는 5개까지 등록 가능해요');
        return;
    }
    tagList.push(text);
    renderTags();
}

function removeTag(idx) {
    tagList.splice(idx, 1);
    renderTags();
}

function renderTags() {
    const container = document.getElementById('tagContainer');
    container.innerHTML = '';
    tagList.forEach((tag, i) => {
        const span = document.createElement('span');
        span.className = 'tag-badge';
        span.innerHTML = `#${tag} <i class="ri-close-line" style="margin-left:4px; font-size:12px;"></i>`;
        span.onclick = () => removeTag(i);
        container.appendChild(span);
    });
}

function initToolbarButtons() {
}

function sendPost() {
    const category = document.querySelector('input[name="category"]:checked').value;
    const subject = document.getElementById('subject').value.trim();
    const content = document.getElementById('content').value.trim();

    if (!subject) {
        showToast('제목을 입력해주세요.');
        document.getElementById('subject').focus();
        return;
    }
    if (!content) {
        showToast('내용을 입력해주세요.');
        document.getElementById('content').focus();
        return;
    }

    const dto = {
        category: category,
        subject: subject,
        content: content,
        tags: tagList,
        placeName: currentLocation?.name || null,
        address: currentLocation?.address || null,
        memberIdx: 1, 
        writerNickname: '작성자',
        
        pollTitle: document.getElementById('pollSection').style.display !== 'none' ? document.getElementById('pollTitle').value : null,
        pollOptions: document.getElementById('pollSection').style.display !== 'none' ? pollOptions.filter(o => o.trim()) : null,
        pollEndDate: document.getElementById('pollSection').style.display !== 'none' ? document.getElementById('pollEndDate').value : null,
        pollMulti: document.getElementById('pollMulti').checked,
        pollAnonymous: document.getElementById('pollAnonymous').checked
    };

    if (dto.pollTitle && (!dto.pollOptions || dto.pollOptions.length < 2)) {
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
    .then(res => {
        if (!res.ok) throw new Error('서버 오류');
        showToast('게시글이 등록됐어요!');
        setTimeout(() => { location.href = ctx + '/community/list'; }, 800);
    })
    .catch(() => {
        showToast('등록에 실패했어요. 잠시 후 다시 시도해주세요.');
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
    div.innerText = msg;
    container.appendChild(div);
    setTimeout(() => div.remove(), 3000);
}