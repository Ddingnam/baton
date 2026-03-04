let fileList = [];
let tagList = [];

document.addEventListener('DOMContentLoaded', () => {
    initFileEvents();
    initTagEvents();
});

function initFileEvents() {
    const box = document.getElementById('dropZone');
    const input = document.getElementById('fileInput');

    box.addEventListener('click', () => input.click());

    box.addEventListener('dragover', (e) => {
        e.preventDefault();
        box.style.borderColor = '#333';
    });

    box.addEventListener('dragleave', () => {
        box.style.borderColor = '#ddd';
    });

    box.addEventListener('drop', (e) => {
        e.preventDefault();
        box.style.borderColor = '#ddd';
        addFiles(e.dataTransfer.files);
    });

    input.addEventListener('change', (e) => {
        addFiles(e.target.files);
        input.value = '';
    });
}

function addFiles(files) {
    if (fileList.length + files.length > 10) {
        alert("최대 10장까지만 가능합니다.");
        return;
    }

    const previewBox = document.getElementById('previewList');

    Array.from(files).forEach(file => {
        if (!file.type.startsWith("image/")) return;

        fileList.push(file);

        const reader = new FileReader();
        reader.onload = (e) => {
            const div = document.createElement('div');
            div.className = 'img-card';
            div.innerHTML = `
                <img src="${e.target.result}">
                <button type="button" class="btn-del" onclick="deleteFile(this, '${file.name}', ${file.lastModified})">
                    &times;
                </button>
            `;
            previewBox.appendChild(div);
        };
        reader.readAsDataURL(file);
    });
}

function deleteFile(btn, name, modified) {
    fileList = fileList.filter(f => !(f.name === name && f.lastModified === modified));
    btn.parentElement.remove();
}

function initTagEvents() {
    const input = document.getElementById('tagInput');

    input.addEventListener('keydown', (e) => {
        if (e.key === 'Enter' || e.key === ',') {
            e.preventDefault();
            const val = input.value.trim().replace('#', '');
            
            if (val && !tagList.includes(val)) {
                if(tagList.length >= 5) {
                    alert("태그는 5개까지 가능합니다.");
                    input.value = '';
                    return;
                }
                tagList.push(val);
                drawTags();
            }
            input.value = '';
        }
        
        if (e.key === 'Backspace' && input.value === '') {
            tagList.pop();
            drawTags();
        }
    });
}

function drawTags() {
    const container = document.getElementById('tagContainer');
    const input = document.getElementById('tagInput');
    
    container.querySelectorAll('.tag-chip').forEach(el => el.remove());

    tagList.forEach((tag, i) => {
        const span = document.createElement('span');
        span.className = 'tag-chip';
        span.innerText = '#' + tag;
        span.onclick = () => {
            tagList.splice(i, 1);
            drawTags();
        };
        container.insertBefore(span, input);
    });
}

function sendPost() {
    const form = document.getElementById('communityForm');
    const subject = form.subject.value.trim();
    const content = form.content.value.trim();
    const category = form.category.value;

    if (!subject || !content) {
        alert("내용을 입력해주세요.");
        return;
    }

    const dto = {
        subject: subject,
        content: content,
        category: category,
        tags: tagList,
        memberIdx: 1, 
        writerNickname: "작성자"
    };

    if (fileList.length > 0) {
        dto.imageFiles = fileList.map(f => f.name);
    }

    const contextPath = document.querySelector('meta[name="contextPath"]')?.getAttribute('content') || '';

    $.ajax({
        url: contextPath + '/api/community',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(dto),
        success: function() {
            location.href = contextPath + '/community/list';
        },
        error: function() {
            alert("등록 실패");
        }
    });
}