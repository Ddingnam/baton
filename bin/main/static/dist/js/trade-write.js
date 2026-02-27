const toggleImage = (function() {
    let uploadedFiles = [];
    const previewList = document.getElementById('previewList');
    const imgCount = document.getElementById('imgCount');

    function init() {
        const fileInput = document.getElementById('selectFile');
        if(!fileInput) return;

        fileInput.addEventListener('change', function() {
            const newFiles = Array.from(this.files);
            const remaining = 5 - uploadedFiles.length;
            newFiles.slice(0, remaining).forEach(file => {
                if (!file.type.startsWith('image/')) return;
                const reader = new FileReader();
                reader.onload = e => {
                    uploadedFiles.push({ file: file, url: e.target.result, isExisting: false });
                    render();
                };
                reader.readAsDataURL(file);
            });
            this.value = '';
        });
    }

    function addExisting(url, imgOrder) {
        uploadedFiles.push({ url: url, imgOrder: imgOrder, isExisting: true });
        render();
    }

    function remove(idx) {
        const target = uploadedFiles[idx];
        if(target.isExisting) {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'deleteImgOrders';
            input.value = target.imgOrder;
            document.getElementById('tradeForm').appendChild(input);
        }
        uploadedFiles.splice(idx, 1);
        render();
    }

    function render() {
        if(!previewList) return;
        previewList.innerHTML = '';
		
		const dataTransfer = new DataTransfer();
		
        uploadedFiles.forEach((item, i) => {
            const div = document.createElement('div');
            div.className = 'preview-item';
            let html = `<img src="${item.url}">`;
            if (i === 0) html += '<div class="thumb-badge">대표</div>';
            html += `<button type="button" class="remove-img-btn" onclick="toggleImage.remove(${i})">✕</button>`;
            div.innerHTML = html;
            previewList.appendChild(div);
			
			if(!item.isExisting && item.file) {
				dataTransfer.items.add(item.file);
			}
        });
		
		document.getElementById('selectFile').files = dataTransfer.files;
		
        imgCount.textContent = uploadedFiles.length + '/5';
    }

    return { init, remove, addExisting };
})();

const toggleTag = (function() {
    let tags = [];
    const tagInput = document.getElementById('tagInput');
    const tagWrap = document.getElementById('tagWrap');

    function init() {
        if(!tagInput) return;
        tagInput.addEventListener('keydown', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                add(this.value);
                this.value = '';
            }
            if (e.key === 'Backspace' && !this.value && tags.length) {
                tags.pop();
                render();
            }
        });
    }

    function add(val) {
        val = val.trim().replace(/^#/, '');
        if (val && tags.length < 5 && !tags.includes(val)) {
            tags.push(val);
            render();
        }
    }

    function remove(idx) {
        tags.splice(idx, 1);
        render();
    }

    function render() {
        if(!tagWrap) return;
        tagWrap.querySelectorAll('.tag-chip').forEach(el => el.remove());
        tags.forEach((tag, i) => {
            const span = document.createElement('span');
            span.className = 'tag-chip';
            span.innerHTML = `#${tag}<button type="button" onclick="toggleTag.remove(${i})" style="border:none;background:none;color:inherit;cursor:pointer">×</button>`;
            tagWrap.insertBefore(span, tagInput);
        });
        document.getElementById('finalTags').value = tags.join(',');
    }

    return { init, remove, add };
})();

const TradeLogic = (function() {
    function toggleLocation(show) {
        const locationField = document.getElementById('locationField');
        const locationInput = document.getElementById('locationInput');
        if(!locationField) return;

        if (show) {
            locationField.style.display = 'block';
        } else {
            locationField.style.display = 'none';
            if(locationInput) locationInput.value = '';
        }
    }
    return { toggleLocation };
})();

window.onload = function() {
    toggleImage.init();
    toggleTag.init();
    
	const urlParams = new URLSearchParams(window.location.search);
	    const productIdx = urlParams.get('productIdx');
	    const isUpdate = window.location.pathname.includes('update');

	    if (isUpdate && productIdx) {
	        fetch(`${contextPath}/trade/updateData?productIdx=${productIdx}`)
	            .then(response => response.json())
	            .then(data => {
	                if(data.imageList) {
	                    data.imageList.forEach(img => {
	                        toggleImage.addExisting(img.imgUrl, img.imgOrder);
	                    });
	                }
	                if(data.tagList) {
	                    data.tagList.forEach(tagName => toggleTag.add(tagName));
	                }
	                TradeLogic.toggleLocation(data.trade.tradeType !== '택배');
	            })
	            .catch(error => console.error('데이터 로드 실패:', error));
	    }
};

function submitForm() {
    const f = document.tradeForm;
    if (!f.title.value.trim()) return alert('제목을 입력하세요.');
    if (!f.price.value) return alert('가격을 입력하세요.');
    
    const mode = f.mode ? f.mode.value : 'write';
    f.action = (mode === 'update') ? '/trade/update' : '/trade/write';
    f.submit();
}