let tagList = [];
let quill = null;
let globalUploadFiles = [];

// 커스텀 confirm (브라우저 기본 alert/confirm 대체)
function batonConfirm(message, onConfirm, onCancel) {
	const overlay = document.createElement('div');
	overlay.style.cssText = 'position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.45);z-index:999999;display:flex;align-items:center;justify-content:center;';
	overlay.innerHTML = `
		<div style="background:#fff;border-radius:20px;padding:28px 32px;min-width:300px;max-width:400px;box-shadow:0 10px 40px rgba(0,0,0,0.15);text-align:center;">
			<p style="font-size:15px;font-weight:600;color:#191F28;margin:0 0 24px;line-height:1.6;">${message}</p>
			<div style="display:flex;gap:10px;justify-content:center;">
				<button id="batonConfirmCancel" style="flex:1;padding:12px;border:1px solid #E5E8EB;background:#fff;border-radius:12px;font-size:14px;font-weight:600;color:#4E5968;cursor:pointer;">취소</button>
				<button id="batonConfirmOk" style="flex:1;padding:12px;border:none;background:#8A63FF;border-radius:12px;font-size:14px;font-weight:600;color:#fff;cursor:pointer;">확인</button>
			</div>
		</div>`;
	document.body.appendChild(overlay);
	const close = () => document.body.removeChild(overlay);
	overlay.querySelector('#batonConfirmOk').onclick = () => { close(); if (onConfirm) onConfirm(); };
	overlay.querySelector('#batonConfirmCancel').onclick = () => { close(); if (onCancel) onCancel(); };
	overlay.onclick = (e) => { if (e.target === overlay) { close(); if (onCancel) onCancel(); } };
}

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
			showBatonToast('이미지 파일만 선택 가능합니다.');
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
		showBatonToast('태그는 최대 5개까지 가능해요');
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
		batonConfirm('카카오맵에서 이동 경로를 확인하시겠습니까?', () => {
			window.open(`https://map.kakao.com/link/map/${encodeURIComponent(name)},${lat},${lng}`, '_blank');
		});
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
		showBatonToast('투표 항목은 최대 10개까지 가능해요.');
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

	if (!categoryElement) { showBatonToast('카테고리를 선택해주세요'); return; }
	if (!subject) { showBatonToast('제목을 입력해주세요'); f.subject.focus(); return; }
	if (!content) { showBatonToast('내용을 입력해주세요'); return; }

	const usePoll = document.getElementById('chkPollToggle');
	if (usePoll && usePoll.checked) {
		const pollTitle = document.getElementById('pollTitle').value.trim();
		if (!pollTitle) { showBatonToast('투표 제목을 입력해주세요.'); return; }
		const pollInputs = document.querySelectorAll('input[name="pollOptions"]');
		let validOptionCount = 0;
		pollInputs.forEach(input => { if (input.value.trim() !== '') validOptionCount++; });
		if (validOptionCount < 2) { showBatonToast('투표 항목은 최소 2개 이상 입력해야 합니다.'); return; }
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
		showBatonToast('제목을 입력해야 임시저장이 가능해요.');
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
			formData.append('uploadFiles', new File([file], file.tempId, { type: file.type }));
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
			showBatonToast('임시저장되었습니다 ✓');
			loadTempCount();
		} else {
			showBatonToast(data.message || '임시저장에 실패했습니다.');
		}
	})
	.catch(() => showBatonToast('오류가 발생했습니다.'));
}

// ===== 임시저장 목록 모달 =====

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
	loadTempList();
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
				<li class="place-item" style="display:flex; justify-content:space-between; align-items:center; gap:12px; padding:14px 16px;">
					<div style="flex:1; min-width:0;">
						<div style="display:flex; align-items:center; gap:6px; margin-bottom:4px;">
							${cat ? `<span style="font-size:11px; background:#f0ecff; color:#8A63FF; border-radius:4px; padding:2px 7px; flex-shrink:0;">${cat}</span>` : ''}
							<span style="font-weight:600; font-size:14px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">${escapeHtml(item.subject || '(제목 없음)')}</span>
						</div>
						${preview ? `<p style="font-size:12px; color:#aaa; margin:0 0 4px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">${escapeHtml(preview)}</p>` : ''}
						<span style="font-size:11px; color:#ccc;">${dateStr}</span>
					</div>
					<div style="display:flex; align-items:center; gap:4px; flex-shrink:0;">
						<button type="button" onclick="loadTempItem(${item.id})"
							style="background:#f0ecff; color:#8A63FF; border:none; border-radius:8px; padding:6px 14px; font-size:12px; font-weight:700; cursor:pointer; white-space:nowrap;">
							가져오기
						</button>
						<button type="button" onclick="deleteTempItem(${item.id}, this)"
							style="background:none; border:none; padding:6px 8px; font-size:16px; color:#ddd; cursor:pointer; line-height:1;" title="삭제">
							<i class="ri-delete-bin-line"></i>
						</button>
					</div>
				</li>`;
			}).join('');
		})
		.catch(() => {
			listEl.innerHTML = '<li style="text-align:center; padding:32px; color:#f44;">목록을 불러올 수 없습니다.</li>';
		});
}

function loadTempItem(id) {
	const contextPath = document.querySelector('meta[name="contextPath"]').getAttribute('content');
	const subject = document.communityForm?.subject?.value?.trim() || '';
	const content = quill?.root?.innerHTML || '';
	const hasContent = subject || (content && content !== '<p><br></p>');

	const doLoad = () => {
		closeTempListModal();
		location.href = `${contextPath}/community/temp/load?id=${id}`;
	};

	if (hasContent) {
		batonConfirm('현재 작성 중인 내용이 사라져요. 계속 가져올까요?', doLoad);
	} else {
		doLoad();
	}
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
	batonConfirm('임시저장된 글을 삭제하시겠습니까?', () => {
		const contextPath = document.querySelector('meta[name="contextPath"]').getAttribute('content');
		fetch(`${contextPath}/community/temp/delete`, {
			method: 'POST',
			headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
			body: `id=${id}`
		})
		.then(r => r.json())
		.then(data => {
			if (data.state === 'true') {
				showBatonToast('삭제되었습니다.');
				if (onSuccess) onSuccess();
			} else {
				showBatonToast('삭제에 실패했습니다.');
			}
		})
		.catch(() => showBatonToast('오류가 발생했습니다.'));
	});
}

function escapeHtml(text) {
	if (!text) return '';
	return text.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}