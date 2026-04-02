let tagList = [];
let quill = null;
let globalUploadFiles = [];

function batonConfirm(message, onConfirm, onCancel) {
	var overlay = document.createElement('div');
	overlay.className = 'baton-modal-overlay';
	overlay.innerHTML =
		'<div class="baton-modal-box">' +
			'<p class="baton-modal-msg">' + message + '</p>' +
			'<div class="baton-modal-btns">' +
				'<button id="batonConfirmCancel" class="baton-btn-cancel">취소</button>' +
				'<button id="batonConfirmOk" class="baton-btn-ok">확인</button>' +
			'</div>' +
		'</div>';
	document.body.appendChild(overlay);
	requestAnimationFrame(function() { overlay.classList.add('show'); });
	var close = function() {
		overlay.classList.remove('show');
		setTimeout(function() { if (overlay.parentNode) document.body.removeChild(overlay); }, 220);
	};
	overlay.querySelector('#batonConfirmOk').onclick = function() { close(); if (onConfirm) onConfirm(); };
	overlay.querySelector('#batonConfirmCancel').onclick = function() { close(); if (onCancel) onCancel(); };
	overlay.onclick = function(e) { if (e.target === overlay) { close(); if (onCancel) onCancel(); } };
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
	if (submitBtn) submitBtn.addEventListener('click', sendOk);

	const chkPoll = document.getElementById('chkPollToggle');
	const pollForm = document.getElementById('pollForm');
	if (chkPoll && pollForm) {
		const pollVotedLocked = document.getElementById('pollVotedLocked');
		if (pollVotedLocked && pollVotedLocked.value === 'true') {
			chkPoll.disabled = true;
			chkPoll.closest('label')?.style && (chkPoll.closest('label').style.opacity = '0.5');
			chkPoll.closest('label')?.style && (chkPoll.closest('label').style.cursor = 'not-allowed');
			
			pollForm.querySelectorAll('input, button, textarea').forEach(el => el.disabled = true);
			pollForm.style.opacity = '0.55';
			pollForm.style.pointerEvents = 'none';

			const notice = document.getElementById('pollVotedNotice');
			if (notice) notice.style.display = 'flex';

			const switchLabel = chkPoll.closest('label') || chkPoll.parentElement;
			const pollHeader = document.querySelector('.poll-toggle-header');
			if (pollHeader) {
				pollHeader.style.cursor = 'default';
				pollHeader.addEventListener('click', (e) => {
					e.preventDefault();
					e.stopPropagation();
					showBatonToast('이미 투표한 이웃이 있어 수정이 불가능해요 🔒', 'ri-lock-line');
				});
			}
		} else {
			chkPoll.addEventListener('change', (e) => {
				if (e.target.checked) {
					setTimeout(() => pollForm.classList.add('active'), 10);
				} else {
					pollForm.classList.remove('active');
				}
			});
			if (chkPoll.checked) pollForm.classList.add('active');
		}
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
    window.Quill = Quill;
    
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
				handlers: { image: imageHandler, link: linkHandler }
			},
			imageResize: {
				displaySize: true
			}
		}
	});
}

function linkHandler() {
	const existing = document.getElementById('quillLinkModal');
	if (existing) existing.remove();

	const selection = quill.getSelection();
	const selectedText = selection && selection.length > 0 ? quill.getText(selection.index, selection.length) : '';

	const modal = document.createElement('div');
	modal.id = 'quillLinkModal';
	modal.className = 'baton-modal-overlay';
	modal.innerHTML =
		'<div class="baton-modal-box baton-modal-form">' +
			'<p class="baton-modal-title">링크 삽입</p>' +
			'<input id="quillLinkText" type="text" class="baton-modal-input" placeholder="링크 텍스트" value="' + selectedText + '">' +
			'<input id="quillLinkUrl" type="text" class="baton-modal-input" placeholder="https://example.com">' +
			'<div class="baton-modal-btns">' +
				'<button id="quillLinkCancel" class="baton-btn-cancel">취소</button>' +
				'<button id="quillLinkOk" class="baton-btn-ok">삽입</button>' +
			'</div>' +
		'</div>';
	document.body.appendChild(modal);
	requestAnimationFrame(function() { modal.classList.add('show'); });

	var urlInput = modal.querySelector('#quillLinkUrl');
	urlInput.focus();

	var close = function() {
		modal.classList.remove('show');
		setTimeout(function() { if (modal.parentNode) modal.remove(); }, 220);
	};

	modal.querySelector('#quillLinkCancel').onclick = close;
	modal.onclick = (e) => { if (e.target === modal) close(); };

	modal.querySelector('#quillLinkOk').onclick = () => {
		const text = modal.querySelector('#quillLinkText').value.trim();
		const url = urlInput.value.trim();
		if (!url) { close(); return; }

		const fullUrl = /^https?:\/\//i.test(url) ? url : 'https://' + url;

		if (selection && selection.length > 0) {
			quill.format('link', fullUrl);
		} else {
			const insertText = text || fullUrl;
			const index = selection ? selection.index : quill.getLength();
			quill.insertText(index, insertText, 'link', fullUrl);
			quill.setSelection(index + insertText.length);
		}
		close();
	};

	urlInput.addEventListener('keydown', (e) => {
		if (e.key === 'Enter') modal.querySelector('#quillLinkOk').click();
		if (e.key === 'Escape') close();
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
	const modal = document.getElementById('tempListModal');
	modal.style.display = 'flex';
	requestAnimationFrame(() => modal.classList.add('show'));
	loadTempList();
}

function closeTempListModal() {
	const modal = document.getElementById('tempListModal');
	modal.classList.remove('show');
	setTimeout(() => { modal.style.display = 'none'; }, 220);
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

			listEl.innerHTML = '';

			data.forEach((item, idx) => {
				const date = item.regDate ? new Date(item.regDate) : null;
				const dateStr = date
					? `${date.getFullYear()}.${String(date.getMonth()+1).padStart(2,'0')}.${String(date.getDate()).padStart(2,'0')} ${String(date.getHours()).padStart(2,'0')}:${String(date.getMinutes()).padStart(2,'0')}`
					: '';
				const cat = catMap[String(item.category)] || '';

				const tempDiv = document.createElement('div');
				tempDiv.innerHTML = item.content || '';
				const preview = (tempDiv.textContent || tempDiv.innerText || '').trim().substring(0, 50);

				const li = document.createElement('li');
				li.className = 'temp-list-item temp-list-animated';
				li.style.animationDelay = `${idx * 60}ms`;
				li.innerHTML = `
					<div class="temp-list-item-info">
						<div class="temp-list-title-row">
							${cat ? `<span class="temp-cat-badge">${cat}</span>` : ''}
							<span class="temp-list-title">${escapeHtml(item.subject || '(제목 없음)')}</span>
						</div>
						${preview ? `<p class="temp-list-preview">${escapeHtml(preview)}</p>` : ''}
						<span class="temp-list-date">${dateStr}</span>
					</div>
					<div class="temp-list-item-btns">
						<button type="button" class="btn-temp-load" onclick="loadTempItem(${item.id})">가져오기</button>
						<button type="button" class="btn-temp-delete" onclick="deleteTempItem(${item.id}, this)" title="삭제">
							<i class="ri-delete-bin-2-line"></i>
						</button>
					</div>`;
				listEl.appendChild(li);
			});
		})
		.catch(() => {
			listEl.innerHTML = '<li style="text-align:center; padding:32px; color:#f44;">목록을 불러올 수 없습니다.</li>';
		});
}

function loadTempItem(id) {
	const contextPath = document.querySelector('meta[name="contextPath"]').getAttribute('content');

	batonConfirm('임시저장된 글을 불러올까요?<br><span style="font-size:13px;color:var(--text-3);font-weight:400;">현재 작성 중인 내용은 사라져요.</span>', () => {
		closeTempListModal();
		location.href = `${contextPath}/community/temp/load?id=${id}`;
	});
}

function deleteTempItem(id, btn) {
	deleteTempItemById(id, () => {
		const li = btn.closest('.temp-list-item');
		if (li) {
			li.style.transition = 'opacity 0.25s ease, transform 0.25s ease';
			li.style.opacity = '0';
			li.style.transform = 'translateX(12px)';
			setTimeout(() => { li.remove(); loadTempList(); }, 260);
		}
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

function showBatonToast(message, icon) {
	var container = document.getElementById('toastContainer');
	if (!container) return;
	var toast = document.createElement('div');
	toast.className = 'toast';
	toast.innerHTML = (icon ? '<i class="' + icon + '"></i> ' : '') + message;
	container.appendChild(toast);
	setTimeout(function() { if (toast.parentNode) toast.remove(); }, 3000);
}

var _attachNewFiles = [];
var _attachRemovedSaves = [];
var MAX_ATTACH = 5;
var MAX_SIZE   = 10 * 1024 * 1024;

window.handleAttachFiles = function(fileList) {
    var files = Array.from(fileList);
    var currentCount = _attachNewFiles.filter(function(f) { return f !== null; }).length
        + document.querySelectorAll('.attach-file-item[data-filename]').length;

    var added = 0;
    for (var i = 0; i < files.length; i++) {
        var file = files[i];
        if (currentCount + added >= MAX_ATTACH) {
            showBatonToast('첨부파일은 최대 ' + MAX_ATTACH + '개까지 가능해요.');
            break;
        }
        if (file.size > MAX_SIZE) {
            showBatonToast('"' + file.name + '" 파일이 10MB를 초과해요.');
            continue;
        }
        _attachNewFiles.push(file);
        _renderNewAttachItem(file, _attachNewFiles.length - 1);
        added++;
    }
    _updateAttachCount();
    _syncAttachInput();
};

function _renderNewAttachItem(file, idx) {
    var list = document.getElementById('attachFileList');
    if (!list) return;

    var wrapper = document.getElementById('attachListWrapper');
    if (wrapper) wrapper.style.display = 'block';

    var li = document.createElement('li');
    li.className = 'attach-file-item';
    li.dataset.newIdx = idx;
    li.innerHTML =
        '<i class="ri-file-line"></i>' +
        '<span class="attach-file-name">' + escapeHtml(file.name) + '</span>' +
        '<span class="attach-file-size">(' + (file.size / 1024).toFixed(1) + 'KB)</span>' +
        '<button type="button" class="btn-remove-attach" onclick="removeNewAttach(' + idx + ', this)"><i class="ri-close-line"></i></button>';
    list.appendChild(li);
}

window.removeNewAttach = function(idx, btn) {
    _attachNewFiles[idx] = null;
    var li = btn.closest('.attach-file-item');
    if (li) li.remove();
    _updateAttachCount();
    _syncAttachInput();
};

window.removeExistingAttach = function(saveFilename, btn) {
    _attachRemovedSaves.push(saveFilename);
    var li = btn.closest('.attach-file-item');
    if (li) li.remove();
    _updateAttachCount();
};

function _updateAttachCount() {
    var newCount  = _attachNewFiles.filter(function(f) { return f !== null; }).length;
    var oldCount  = document.querySelectorAll('.attach-file-item[data-filename]').length;
    var total     = newCount + oldCount;
    var label     = document.getElementById('attachCountLabel');
    var wrapper   = document.getElementById('attachListWrapper');
    if (label) {
        if (total > 0) {
            label.style.display = 'inline';
            label.innerText = '파일 ' + total + '개';
        } else {
            label.style.display = 'none';
        }
    }
    if (wrapper) wrapper.style.display = total > 0 ? 'block' : 'none';
}

function _syncAttachInput() {
    var input = document.getElementById('attachFileInput');
    if (!input) return;
    try {
        var dt = new DataTransfer();
        _attachNewFiles.forEach(function(f) { if (f !== null) dt.items.add(f); });
        input.files = dt.files;
    } catch(e) { console.warn('DataTransfer not supported', e); }
}

var _origSendOk = window.sendOk;
window.sendOk = function() {
    var f = document.communityForm;
    f.querySelectorAll('input[name="removedFiles"]').forEach(function(el) { el.remove(); });
    _attachRemovedSaves.forEach(function(name) {
        var inp = document.createElement('input');
        inp.type = 'hidden'; inp.name = 'removedFiles'; inp.value = name;
        f.appendChild(inp);
    });
    
    // 원본 sendOk 호출을 추가하여 정상적으로 등록 폼이 submit 되도록 수정
    if (typeof _origSendOk === 'function') {
        _origSendOk();
    }
}