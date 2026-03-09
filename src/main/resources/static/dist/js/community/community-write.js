let tagList = [];
let quill = null;

document.addEventListener('DOMContentLoaded', () => {
	initQuill();
	initTagInput();
	initCategoryPills();
	
	const datePickerBox = document.querySelector('.date-picker-box');
		if (datePickerBox) {
	        datePickerBox.addEventListener('click', () => {
	            document.getElementById('pollEndDate').showPicker();
	        });
	    }
		
	const submitBtn = document.querySelector('.btn-submit');
	const submitFullBtn = document.querySelector('.btn-submit-full');
	if (submitBtn) submitBtn.addEventListener('click', sendOk);
	if (submitFullBtn) submitFullBtn.addEventListener('click', sendOk);

	const chkPoll = document.getElementById('chkPollToggle');
	const pollForm = document.getElementById('pollForm');

	if (chkPoll && pollForm) {
		chkPoll.addEventListener('change', (e) => {
			if (e.target.checked) {
				setTimeout(() => pollForm.classList.add('active'), 10);
			} else {
				pollForm.classList.remove('active');
			}
		});
		
		if (chkPoll.checked) {
            pollForm.classList.add('active');
        }
	}

	const dateInput = document.getElementById('pollEndDate');
	const dateDisplay = document.getElementById('dateDisplay');
	if (dateInput) {
		const today = new Date().toISOString().split('T')[0];
		dateInput.setAttribute('min', today);

        if(dateInput.value) {
            dateDisplay.innerText = dateInput.value + ' 마감';
            dateDisplay.style.color = 'var(--primary)';
            dateDisplay.style.fontWeight = 'bold';
        }

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

function initQuill() {
	const contextPath = document.querySelector('meta[name="contextPath"]').getAttribute('content');

	quill = new Quill('#quillEditor', {
		theme: 'snow',
		placeholder: '오늘 있었던 일을 이웃들과 나눠보세요 :)',
		modules: {
			toolbar: {
				container: [
					[{ 'header': [1, 2, 3, false] }],
					['bold', 'italic', 'underline', 'strike'],
					[{ 'color': [] }, { 'background': [] }],
					[{ 'list': 'ordered' }, { 'list': 'bullet' }],
					[{ 'align': [] }],
					['link', 'image'],
					['clean']
				],
				handlers: {
					image: imageUploadHandler
				}
			}
		}
	});

	// 수정 모드일 때 기존 content 로드
	const hiddenContent = document.getElementById('content');
	if (hiddenContent && hiddenContent.value) {
		quill.root.innerHTML = hiddenContent.value;
	}

	function imageUploadHandler() {
		const input = document.createElement('input');
		input.setAttribute('type', 'file');
		input.setAttribute('accept', 'image/*');
		input.click();

		input.onchange = async () => {
			const file = input.files[0];
			if (!file) return;

			const formData = new FormData();
			formData.append('imageFile', file);

			try {
				const resp = await fetch(contextPath + '/editor/upload', {
					method: 'POST',
					body: formData
				});
				const data = await resp.json();
				if (data.state === 'true') {
					const range = quill.getSelection();
					quill.insertEmbed(range ? range.index : 0, 'image', data.imageUrl);
				} else {
					showToast('이미지 업로드에 실패했습니다.');
				}
			} catch (e) {
				showToast('이미지 업로드 중 오류가 발생했습니다.');
			}
		};
	}
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
    // Quill 내용을 hidden input에 넣기
    if (quill) {
        const htmlContent = quill.root.innerHTML;
        document.getElementById('content').value = htmlContent === '<p><br></p>' ? '' : htmlContent;
    }

    const f = document.communityForm;
    const subject = f.subject.value.trim();
    const content = document.getElementById('content').value;
    
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
        const quillText = quill ? quill.getText().trim() : '';
        if (!quillText) {
            showToast('내용을 입력해주세요');
            return;
        }
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
        
    } else {
        const pollArea = document.getElementById('pollForm');
        if(pollArea) {
            const inputs = pollArea.querySelectorAll('input');
            inputs.forEach(input => input.disabled = true);
        }
    }

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