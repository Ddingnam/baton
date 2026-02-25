const toggleImage = (function() {
    let uploadedFiles = [];
    const previewList = document.getElementById('previewList');
    const imgCount = document.getElementById('imgCount');

    function init() {
        document.getElementById('selectFile').addEventListener('change', function() {
            const newFiles = Array.from(this.files);
            const remaining = 5 - uploadedFiles.length;
            newFiles.slice(0, remaining).forEach(file => {
                if (!file.type.startsWith('image/')) return;
                const reader = new FileReader();
                reader.onload = e => {
                    uploadedFiles.push({ file: file, url: e.target.result });
                    render();
                };
                reader.readAsDataURL(file);
            });
            this.value = '';
        });
    }

    function remove(idx) {
        uploadedFiles.splice(idx, 1);
        render();
    }

    function render() {
        previewList.innerHTML = '';
        for(let i=0; i<uploadedFiles.length; i++) {
            const item = uploadedFiles[i];
            const div = document.createElement('div');
            div.className = 'preview-item';
            
            let html = '<img src="' + item.url + '">';
            if (i === 0) html += '<div class="thumb-badge">대표</div>';
            html += '<button type="button" class="remove-img-btn" onclick="toggleImage.remove(' + i + ')">✕</button>';
            
            div.innerHTML = html;
            previewList.appendChild(div);
        }
        imgCount.textContent = uploadedFiles.length + '/5';
    }
    return { init, remove };
})();

const toggleTag = (function() {
    const tags = [];
    const tagInput = document.getElementById('tagInput');
    const tagWrap = document.getElementById('tagWrap');

    function init() {
        tagInput.addEventListener('keydown', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                let val = this.value.trim().replace(/^#/, '');
                if (val && tags.length < 5 && !tags.includes(val)) {
                    tags.push(val);
                    render();
                }
                this.value = '';
            }
            if (e.key === 'Backspace' && !this.value && tags.length) {
                tags.pop();
                render();
            }
        });
    }

    function remove(idx) {
        tags.splice(idx, 1);
        render();
    }

    function render() {
        tagWrap.querySelectorAll('.tag-chip').forEach(el => el.remove());
        for(let i=0; i<tags.length; i++) {
            const span = document.createElement('span');
            span.className = 'tag-chip';
            span.innerHTML = '#' + tags[i] + '<button type="button" onclick="toggleTag.remove(' + i + ')" style="border:none;background:none;color:inherit;cursor:pointer">×</button>';
            tagWrap.insertBefore(span, tagInput);
        }
        document.getElementById('finalTags').value = tags.join(',');
    }
    return { init, remove };
})();

const TradeLogic = (function() {
    const locationField = document.getElementById('locationField');
    const locationInput = document.getElementById('locationInput');

    function toggleLocation(show) {
        if (show) {
            locationField.style.display = 'block';
        } else {
            locationField.style.display = 'none';
            locationInput.value = ''; // 택배 선택 시 입력했던 장소 초기화
        }
    }

    return { toggleLocation };
})();

window.onload = function() {
    ImageModule.init();
    TagModule.init();
    TradeLogic.toggleLocation(true); 
    
    document.getElementById('contentInput').oninput = function() {
        document.getElementById('contentCount').textContent = this.value.length + '/2000';
    };
};

function submitForm() {
    const f = document.tradeForm;
    if (!f.title.value.trim()) return alert('제목을 입력하세요.');
    if (!f.price.value) return alert('가격을 입력하세요.');
    f.action = '/trade/write';
    f.submit();
}