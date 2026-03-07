let fileList = [];
let tagList = [];

document.addEventListener('DOMContentLoaded', () => {
	initFileZone();
	initTagInput();
	initCharCount();
	initCategoryPills();

	const submitBtn = document.querySelector('.btn-submit');
	const submitFullBtn = document.querySelector('.btn-submit-full');
	if (submitBtn) submitBtn.addEventListener('click', sendPost);
	if (submitFullBtn) submitFullBtn.addEventListener('click', sendPost);

	const chkPoll = document.getElementById('chkPollToggle');
	const pollForm = document.getElementById('pollForm');

	if (chkPoll && pollForm) {
		chkPoll.addEventListener('change', (e) => {
			if (e.target.checked) {
				pollForm.classList.add('active');
			} else {
				pollForm.classList.remove('active');
			}
		});
	}

	const dateInput = document.getElementById('pollEndDate');
	const dateDisplay = document.getElementById('dateDisplay');
	if (dateInput) {
		const today = new Date().toISOString().split('T')[0];
		dateInput.setAttribute('min', today);

		dateInput.addEventListener('change', function() {
			if (this.value) {
				dateDisplay.innerText = this.value + ' 마감';
				dateDisplay.style.color = 'var(--primary)';
				dateDisplay.style.fontWeight = 'bold';
			} else {
				dateDisplay.innerText = '종료일 선택';
				dateDisplay.style.color = '';
			}
		});
	}
});

function initCategoryPills() {
	document.querySelectorAll('.cat-pill input').forEach(radio => {
		radio.addEventListener('change', () => {
			const placeholderMap = {
				'일상': '오늘 있었던 일을 이웃들과 나눠보세요!',
				'동네질문': '동네에 대해 궁금한 것을 물어보세요!',
				'동네맛집': '맛있었던 곳을 자랑해보세요!',
				'동네소식': '우리 동네 소식을 알려주세요!',
				'분실/실종': '분실물이나 실종 반려동물을 알려주세요!',
			};
			const textarea = document.querySelector('.textarea-main');
			if (textarea && placeholderMap[radio.value]) {
				textarea.placeholder = placeholderMap[radio.value];
			}
		});
	});
}

function initCharCount() {
	const textarea = document.querySelector('.textarea-main');
	const counter = document.getElementById('charCount');
	if (!textarea || !counter) return;

	textarea.addEventListener('input', () => {
		const length = textarea.value.length;
		counter.textContent = length;
		if (length > 2000) {
			textarea.value = textarea.value.substring(0, 2000);
			counter.textContent = 2000;
		}
	});
}

function initFileZone() {
	const dropZone = document.getElementById('dropZone');
	const fileInput = document.getElementById('fileInput');
	const addBtn = document.querySelector('.media-add-btn');

	if (addBtn) addBtn.addEventListener('click', () => fileInput.click());
	if (fileInput) fileInput.addEventListener('change', e => handleFiles(e.target.files));

	if (dropZone) {
		dropZone.addEventListener('dragover', e => {
			e.preventDefault();
			dropZone.style.background = '#f0f2f5';
		});
		dropZone.addEventListener('dragleave', e => {
			e.preventDefault();
			dropZone.style.background = '';
		});
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

	fileList.forEach((item, index) => {
		const div = document.createElement('div');
		div.className = 'media-item';
		div.innerHTML = `<img src="${item.url}"><button type="button" class="media-del-btn" data-index="${index}"><i class="ri-close-line"></i></button>`;
		list.appendChild(div);
	});

	list.querySelectorAll('.media-del-btn').forEach(btn => {
		btn.addEventListener('click', (e) => {
			const index = parseInt(e.currentTarget.dataset.index);
			removeFile(index);
		});
	});

	document.getElementById('fileCount').innerText = fileList.length;
}

function removeFile(index) {
	fileList.splice(index, 1);
	renderFileList();
}

function initTagInput() {
	const input = document.getElementById('tagInput');
	if (!input) return;

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
	tagList.forEach((tag, index) => {
		const span = document.createElement('span');
		span.className = 'tag-badge';
		span.innerText = '#' + tag;
		span.addEventListener('click', () => removeTag(index));
		container.appendChild(span);
	});
}

function removeTag(index) {
	tagList.splice(index, 1);
	renderTags();
}

window.setLocation = function(name, address, lat, lng) {
	document.getElementById('placeName').value = name;
	document.getElementById('address').value = address;
	document.getElementById('latitude').value = lat;
	document.getElementById('longitude').value = lng;

	document.getElementById('displayPlaceName').innerText = name;
	document.getElementById('displayAddress').innerText = address;

	const card = document.getElementById('locationCard');
	const btn = document.getElementById('btnLocation');

	card.style.display = 'flex';
	if (btn) btn.classList.add('active');
	card.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
};

window.removeLocation = function() {
	document.getElementById('placeName').value = '';
	document.getElementById('address').value = '';
	document.getElementById('latitude').value = '';
	document.getElementById('longitude').value = '';

	document.getElementById('locationCard').style.display = 'none';
	const btn = document.getElementById('btnLocation');
	if (btn) btn.classList.remove('active');
}

document.querySelector('.btn-del-loc')?.addEventListener('click', window.removeLocation);

function addPollOption() {
	const container = document.getElementById('pollOptionContainer');
	const count = container.querySelectorAll('.poll-option-item').length + 1;

	if (count > 10) {
		showToast('투표 항목은 최대 10개까지 가능해요.');
		return;
	}

	const div = document.createElement('div');
	div.className = 'poll-option-item';
	div.innerHTML = `
	        <input type="text" name="pollOptions" placeholder="항목 ${count}" class="input-option" autocomplete="off">
	        <button type="button" class="btn-del-option" onclick="this.parentElement.remove()">
	            <i class="ri-close-line"></i>
	        </button>
	 `;

	div.style.opacity = '0';
	div.style.transform = 'translateY(10px)';
	container.appendChild(div);

	requestAnimationFrame(() => {
		div.style.transition = 'all 0.3s ease';
		div.style.opacity = '1';
		div.style.transform = 'translateY(0)';
	});
}

function sendOk() {
    const f = document.communityForm;
    const subject = f.subject.value.trim();
    const content = f.content.value.trim();
    
    const categoryElement = document.querySelector('input[name="category"]:checked');
    if (!categoryElement) {
        showToast('카테고리를 선택해주세요');
        return;
    }

    if (!subject) {
        showToast('제목을 입력해주세요');
        f.subject.focus();
        return;
    }
    if (!content) {
        showToast('내용을 입력해주세요');
        f.content.focus();
        return;
    }

    const usePoll = document.getElementById('chkPollToggle');
    if (usePoll && usePoll.checked) {
        const pollTitle = document.getElementById('pollTitle').value.trim();
        if (!pollTitle) {
            showToast('투표 제목을 입력해주세요.');
            return;
        }

        const pollInputs = document.querySelectorAll('input[name="pollOptions"]');
        let validOptionCount = 0;
        pollInputs.forEach(input => {
            if(input.value.trim() !== "") validOptionCount++;
        });

        if (validOptionCount < 2) {
            showToast('투표 항목은 최소 2개 이상 입력해야 합니다.');
            return;
        }
        
        const pollEndDate = document.getElementById('pollEndDate').value;
        if(!pollEndDate) {
            showToast('투표 종료일을 선택해주세요.');
            return;
        }
    } else {
        const pollArea = document.getElementById('pollForm');
        if(pollArea) {
            const inputs = pollArea.querySelectorAll('input');
            inputs.forEach(input => input.disabled = true);
        }
    }

	const dataTransfer = new DataTransfer();
	fileList.forEach(obj => dataTransfer.items.add(obj.file));
	    
	const fileInput = document.querySelector('input[name="uploadFiles"]');
	fileInput.files = dataTransfer.files;

    const oldTags = f.querySelectorAll('input[name="tags"]');
    oldTags.forEach(t => t.remove());
    
    tagList.forEach(tag => {
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'tags'; 
        input.value = tag;
        f.appendChild(input);
    });

    
    const contextPath = document.querySelector('meta[name="contextPath"]').getAttribute('content');
    const mode = f.mode.value;

    f.action = contextPath + "/community/" + mode;
    f.submit();
}

function showToast(message) {
	const container = document.getElementById('toastContainer');
	const div = document.createElement('div');
	div.className = 'toast';
	div.innerHTML = `<i class="ri-notification-badge-fill"></i> ${message}`;
	container.appendChild(div);
	setTimeout(() => div.remove(), 3000);
}