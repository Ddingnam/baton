let tagList = [];
let quill = null;
let globalUploadFiles = [];

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
		if (chkPoll.checked) pollForm.classList.add('active');
	}

	const dateInput = document.getElementById('pollEndDate');
	const dateDisplay = document.getElementById('dateDisplay');
	if (dateInput) {
		const today = new Date().toISOString().split('T')[0];
		dateInput.setAttribute('min', today);
		if (dateInput.value) {
			dateDisplay.innerText = dateInput.value + ' 마감';
			dateDisplay.style.color = 'var(--primary)';
			dateDisplay.style.fontWeight = 'bold';
		}
		dateInput.addEventListener('change', function () {
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
	const placeholderMap = {
		'1': '오늘 있었던 일을 이웃들과 나눠보세요!',
		'2': '동네에 대해 궁금한 것을 물어보세요!',
		'3': '맛있었던 곳을 자랑해보세요!',
		'4': '우리 동네 소식을 알려주세요!',
		'5': '분실물이나 실종 반려동물을 알려주세요!',
	};
	document.querySelectorAll('.cat-pill input').forEach(radio => {
		radio.addEventListener('change', () => {
			const textarea = document.querySelector('.textarea-main');
			if (textarea && placeholderMap[radio.value]) {
				textarea.placeholder = placeholderMap[radio.value];
			}
		});
	});
}

function initQuill() {
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
				handlers: { image: imageHandler }
			}
		}
	});
}

function imageHandler() {
	const input = document.createElement('input');
	input.setAttribute('type', 'file');
	input.setAttribute('accept', 'image/*');
	input.click();

	input.onchange = () => {
		const file = input.files[0];
		if (!file) return;

		if (/^image\//.test(file.type)) {
			const ext = file.name.substring(file.name.lastIndexOf('.')) || ('.' + file.type.split('/')[1]);
			const uniqueId = 'img_' + Date.now() + '_' + Math.floor(Math.random() * 1000) + ext;
			file.tempId = uniqueId;
			globalUploadFiles.push(file);

			const reader = new FileReader();
			reader.onload = (e) => {
				const range = quill.getSelection();
				quill.insertEmbed(range.index, 'image', e.target.result);
				setTimeout(() => {
					const img = quill.root.querySelector(`img[src="${e.target.result}"]`);
					if (img) img.setAttribute('data-temp-id', uniqueId);
				}, 10);
			};
			reader.readAsDataURL(file);
		} else {
			showToast('이미지 파일만 선택 가능합니다.');
		}
	};
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

window.setLocation = function (name, address, lat, lng) {
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

	card.style.cursor = 'pointer';
	card.onclick = function () {
		if (confirm('카카오맵에서 이동 경로를 확인하시겠습니까?')) {
			window.open(`https://map.kakao.com/link/map/${encodeURIComponent(name)},${lat},${lng}`, '_blank');
		}
	};

	document.querySelector('.btn-del-loc')?.addEventListener('click', removeLocation);
};

window.removeLocation = function () {
	document.getElementById('placeName').value = '';
	document.getElementById('address').value = '';
	document.getElementById('latitude').value = '';
	document.getElementById('longitude').value = '';
	document.getElementById('locationCard').style.display = 'none';
	const btn = document.getElementById('btnLocation');
	if (btn) btn.classList.remove('active');
};

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
		</button>`;
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

	const activeImages = quill.root.querySelectorAll('img[data-temp-id]');
	const activeIds = Array.from(activeImages).map(img => img.getAttribute('data-temp-id'));
	const dataTransfer = new DataTransfer();
	globalUploadFiles.forEach(file => {
		if (activeIds.includes(file.tempId)) {
			const renamedFile = new File([file], file.tempId, { type: file.type });
			dataTransfer.items.add(renamedFile);
			const img = quill.root.querySelector(`img[data-temp-id="${file.tempId}"]`);
			if (img) img.setAttribute('src', file.tempId);
		}
	});
	document.getElementById('hiddenFileInput').files = dataTransfer.files;

	const htmlContent = quill.root.innerHTML;
	document.getElementById('content').value = htmlContent === '<p><br></p>' ? '' : htmlContent;

	const subject = f.subject.value.trim();
	const content = document.getElementById('content').value;
	const categoryElement = document.querySelector('input[name="category"]:checked');

	if (!categoryElement) { showToast('카테고리를 선택해주세요'); return; }
	if (!subject) { showToast('제목을 입력해주세요'); f.subject.focus(); return; }
	if (!content) { showToast('내용을 입력해주세요'); return; }

	const usePoll = document.getElementById('chkPollToggle');
	if (usePoll && usePoll.checked) {
		const pollTitle = document.getElementById('pollTitle').value.trim();
		if (!pollTitle) { showToast('투표 제목을 입력해주세요.'); return; }
		const pollInputs = document.querySelectorAll('input[name="pollOptions"]');
		let validOptionCount = 0;
		pollInputs.forEach(input => { if (input.value.trim() !== '') validOptionCount++; });
		if (validOptionCount < 2) { showToast('투표 항목은 최소 2개 이상 입력해야 합니다.'); return; }
	} else {
		const pollArea = document.getElementById('pollForm');
		if (pollArea) pollArea.querySelectorAll('input').forEach(input => input.disabled = true);
	}

	f.querySelectorAll('input[name="tags"]').forEach(t => t.remove());
	tagList.forEach(tag => {
		const input = document.createElement('input');
		input.type = 'hidden';
		input.name = 'tags';
		input.value = tag;
		f.appendChild(input);
	});

	const contextPath = document.querySelector('meta[name="contextPath"]').getAttribute('content');
	f.action = contextPath + '/community/' + f.mode.value;
	f.submit();
}

function saveTemp() {
	const f = document.communityForm;
	const subject = f.subject.value.trim();
	if (!subject) {
		alert('제목을 입력해야 임시 저장이 가능해요.');
		f.subject.focus();
		return;
	}

	let tempInput = f.querySelector('input[name="isTemporary"]');
	if (!tempInput) {
		tempInput = document.createElement('input');
		tempInput.type = 'hidden';
		tempInput.name = 'isTemporary';
		f.appendChild(tempInput);
	}
	tempInput.value = '1';

	const modeInput = f.querySelector('input[name="mode"]');
	if (modeInput) modeInput.value = 'write';

	const htmlContent = quill.root.innerHTML;
	document.getElementById('content').value = htmlContent === '<p><br></p>' ? '' : htmlContent;

	f.querySelectorAll('input[name="tags"]').forEach(t => t.remove());
	tagList.forEach(tag => {
		const input = document.createElement('input');
		input.type = 'hidden';
		input.name = 'tags';
		input.value = tag;
		f.appendChild(input);
	});

	const contextPath = document.querySelector('meta[name="contextPath"]').getAttribute('content');
	f.action = contextPath + '/community/write';
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