let tagList = [];
let quill = null;
let globalUploadFiles = [];

document.addEventListener('DOMContentLoaded', () => {
	initQuill();
	initTagInput();
	initCategoryPills();
	loadTempCount();

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
		alert('제목을 입력해야 임시저장이 가능해요.');
		f.subject.focus();
		return;
	}

	const htmlContent = quill.root.innerHTML;
	const content = htmlContent === '<p><br></p>' ? '' : htmlContent;

	const activeImages = quill.root.querySelectorAll('img[data-temp-id]');
	const activeIds = Array.from(activeImages).map(img => img.getAttribute('data-temp-id'));

	const formData = new FormData();

	const dto = {
		subject: subject,
		content: content,
		category: document.querySelector('input[name="category"]:checked')?.value || '1',
		placeName: document.getElementById('placeName')?.value || '',
		address: document.getElementById('address')?.value || '',
		latitude: document.getElementById('latitude')?.value || null,
		longitude: document.getElementById('longitude')?.value || null,
		tags: tagList
	};
	formData.append('dto', new Blob([JSON.stringify(dto)], { type: 'application/json' }));

	globalUploadFiles.forEach(file => {
		if (activeIds.includes(file.tempId)) {
			const renamedFile = new File([file], file.tempId, { type: file.type });
			formData.append('uploadFiles', renamedFile);
		}
	});

	const contextPath = document.querySelector('meta[name="contextPath"]').getAttribute('content');

	fetch(`${contextPath}/api/community/temp`, {
		method: 'POST',
		body: formData
	})
	.then(r => r.json())
	.then(data => {
		if (data.status === 'true') {
			showToast('임시저장되었습니다 ✓');
			loadTempCount();
		} else {
			showToast(data.message || '임시저장에 실패했습니다.');
		}
	})
	.catch(() => showToast('오류가 발생했습니다.'));
}

function showToast(message) {
	const container = document.getElementById('toastContainer');
	const div = document.createElement('div');
	div.className = 'toast';
	div.innerHTML = `<i class="ri-notification-badge-fill"></i> ${message}`;
	container.appendChild(div);
	setTimeout(() => div.remove(), 3000);
}

// ===== 임시저장 목록 모달 =====
let tempEditQuillInstance = null;
let tempEditCurrentId = null;

function loadTempCount() {
	const contextPath = document.querySelector('meta[name="contextPath"]').getAttribute('content');
	fetch(`${contextPath}/community/temp/list`)
		.then(r => r.json())
		.then(data => {
			const badge = document.getElementById('tempCountBadge');
			if (badge && data.length > 0) {
				badge.style.display = 'inline';
				badge.innerText = data.length;
			}
		})
		.catch(() => {});
}

function openTempListModal() {
	document.getElementById('tempListModal').style.display = 'flex';
	backToTempList();
}

function closeTempListModal() {
	document.getElementById('tempListModal').style.display = 'none';
}

function onTempModalOverlayClick(e) {
	if (e.target === document.getElementById('tempListModal')) closeTempListModal();
}

function loadTempList() {
	const contextPath = document.querySelector('meta[name="contextPath"]').getAttribute('content');
	const listEl = document.getElementById('tempListContent');
	listEl.innerHTML = '<li style="text-align:center; padding:32px; color:#aaa;"><i class="ri-loader-4-line ri-spin"></i> 불러오는 중...</li>';

	fetch(`${contextPath}/community/temp/list`)
		.then(r => r.json())
		.then(data => {
			const badge = document.getElementById('tempCountBadge');
			if (data && data.length > 0) {
				badge.style.display = 'inline';
				badge.innerText = data.length;
			} else {
				badge.style.display = 'none';
			}

			if (!data || data.length === 0) {
				listEl.innerHTML = `<li style="text-align:center; padding:48px 20px; color:#bbb;">
					<i class="ri-inbox-line" style="font-size:36px; display:block; margin-bottom:10px;"></i>
					임시저장된 글이 없습니다.
				</li>`;
				return;
			}

			const catMap = { '1': '일상', '2': '동네질문', '3': '동네맛집', '4': '동네소식', '5': '분실/실종' };

			listEl.innerHTML = data.map(item => {
				const date = item.regDate ? new Date(item.regDate) : null;
				const dateStr = date
					? `${date.getFullYear()}.${String(date.getMonth()+1).padStart(2,'0')}.${String(date.getDate()).padStart(2,'0')} ${String(date.getHours()).padStart(2,'0')}:${String(date.getMinutes()).padStart(2,'0')}`
					: '';
				const cat = catMap[String(item.category)] || '';

				// HTML 태그 제거해서 텍스트 미리보기 50자
				const tempDiv = document.createElement('div');
				tempDiv.innerHTML = item.content || '';
				const preview = (tempDiv.textContent || tempDiv.innerText || '').trim().substring(0, 50);

				return `
				<li class="place-item" style="display:flex; justify-content:space-between; align-items:flex-start; gap:8px; padding:14px 16px; cursor:pointer;" onclick="openTempEdit(${item.id})">
					<div style="flex:1; min-width:0;">
						<div style="display:flex; align-items:center; gap:6px; margin-bottom:5px;">
							${cat ? `<span style="font-size:11px; background:#f0ecff; color:#8A63FF; border-radius:4px; padding:2px 7px; flex-shrink:0;">${cat}</span>` : ''}
							<span style="font-weight:600; font-size:14px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">${escapeHtml(item.subject || '(제목 없음)')}</span>
						</div>
						${preview ? `<p style="font-size:12px; color:#888; margin:0 0 5px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">${escapeHtml(preview)}</p>` : ''}
						<span style="font-size:11px; color:#bbb;">${dateStr}</span>
					</div>
					<button type="button" onclick="event.stopPropagation(); deleteTempItem(${item.id}, this)"
						style="flex-shrink:0; background:none; border:none; color:#ccc; cursor:pointer; padding:4px 6px; border-radius:6px; font-size:18px; line-height:1;" title="삭제">
						<i class="ri-delete-bin-line"></i>
					</button>
				</li>`;
			}).join('');
		})
		.catch(() => {
			listEl.innerHTML = '<li style="text-align:center; padding:32px; color:#f44;">목록을 불러올 수 없습니다.</li>';
		});
}

function openTempEdit(id) {
	const contextPath = document.querySelector('meta[name="contextPath"]').getAttribute('content');
	fetch(`${contextPath}/community/temp/list`)
		.then(r => r.json())
		.then(data => {
			const item = data.find(d => d.id === id);
			if (!item) return;
			tempEditCurrentId = id;

			document.getElementById('tempEditId').value = id;
			document.getElementById('tempEditSubject').value = item.subject || '';
			document.getElementById('tempModalTitle').innerText = '임시저장 수정';

			// 카테고리 선택
			document.querySelectorAll('input[name="tempCat"]').forEach(r => {
				r.checked = (r.value === String(item.category));
			});

			// 수정용 Quill 초기화 (최초 1회)
			if (!tempEditQuillInstance) {
				tempEditQuillInstance = new Quill('#tempEditQuill', {
					theme: 'snow',
					modules: { toolbar: [['bold','italic','underline'], [{'list':'ordered'},{'list':'bullet'}], ['link'], ['clean']] }
				});
			}
			tempEditQuillInstance.root.innerHTML = item.content || '';

			// 뷰 전환
			document.getElementById('tempListView').style.display = 'none';
			const editView = document.getElementById('tempEditView');
			editView.style.display = 'flex';
		})
		.catch(() => showToast('불러오기에 실패했습니다.'));
}

function backToTempList() {
	document.getElementById('tempListView').style.display = 'flex';
	document.getElementById('tempEditView').style.display = 'none';
	document.getElementById('tempModalTitle').innerText = '임시저장 목록';
	tempEditCurrentId = null;
	loadTempList();
}

function submitTempEdit() {
	if (!tempEditCurrentId) return;
	const contextPath = document.querySelector('meta[name="contextPath"]').getAttribute('content');
	const subject = document.getElementById('tempEditSubject').value.trim();
	const catEl = document.querySelector('input[name="tempCat"]:checked');
	const content = tempEditQuillInstance ? tempEditQuillInstance.root.innerHTML : '';

	if (!subject) { showToast('제목을 입력해주세요.'); return; }
	if (!catEl) { showToast('카테고리를 선택해주세요.'); return; }
	if (!content || content === '<p><br></p>') { showToast('내용을 입력해주세요.'); return; }

	// FormData로 multipart 전송 (파일 없이 DTO만)
	const dto = { id: tempEditCurrentId, subject, category: catEl.value, content, temporary: false };

	fetch(`${contextPath}/api/community/${tempEditCurrentId}`, {
		method: 'POST',
		headers: { 'Content-Type': 'application/json' },
		body: JSON.stringify(dto)
	})
	.then(r => r.json())
	.then(data => {
		if (data.status === 'true') {
			showToast('등록되었습니다!');
			closeTempListModal();
			setTimeout(() => location.href = `${contextPath}/community/list`, 800);
		} else {
			// API 방식이 안되면 폼 방식으로 fallback
			submitTempEditByForm(subject, catEl.value, content);
		}
	})
	.catch(() => submitTempEditByForm(subject, catEl.value, content));
}

function submitTempEditByForm(subject, category, content) {
	const contextPath = document.querySelector('meta[name="contextPath"]').getAttribute('content');
	const form = document.createElement('form');
	form.method = 'POST';
	form.action = `${contextPath}/community/update`;
	const fields = { id: tempEditCurrentId, subject, category, content, page: '1', isTemporary: '0' };
	Object.entries(fields).forEach(([k, v]) => {
		const inp = document.createElement('input');
		inp.type = 'hidden'; inp.name = k; inp.value = v;
		form.appendChild(inp);
	});
	document.body.appendChild(form);
	form.submit();
}

function deleteTempFromEdit() {
	if (!tempEditCurrentId) return;
	deleteTempItemById(tempEditCurrentId, () => backToTempList());
}

function deleteTempItem(id, btn) {
	deleteTempItemById(id, () => {
		const li = btn.closest('li');
		li.style.transition = 'opacity 0.3s';
		li.style.opacity = '0';
		setTimeout(() => { li.remove(); loadTempList(); }, 300);
	});
}

function deleteTempItemById(id, onSuccess) {
	if (!confirm('임시저장된 글을 삭제하시겠습니까?')) return;
	const contextPath = document.querySelector('meta[name="contextPath"]').getAttribute('content');
	fetch(`${contextPath}/community/temp/delete`, {
		method: 'POST',
		headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
		body: `id=${id}`
	})
	.then(r => r.json())
	.then(data => {
		if (data.state === 'true') {
			showToast('삭제되었습니다.');
			if (onSuccess) onSuccess();
		} else {
			showToast('삭제에 실패했습니다.');
		}
	})
	.catch(() => showToast('오류가 발생했습니다.'));
}

function escapeHtml(text) {
	if (!text) return '';
	return text.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}