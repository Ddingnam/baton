const MIN_WAGE = 10300;
const DAY_LABEL = { MON: '월', TUE: '화', WED: '수', THU: '목', FRI: '금', SAT: '토', SUN: '일' };
const uploadedFiles = [];

function searchAddress() {
  new daum.Postcode({
    oncomplete: function (data) {
      document.getElementById('location').value = data.roadAddress || data.jibunAddress;
      document.getElementById('locationDetail').focus();
      updateProgress();
      updatePreview();
    }
  }).open();
}

function selectPayType(btn) {
  document.querySelectorAll('#payTypeGroup .chip').forEach(b => b.classList.remove('active'));
  btn.classList.add('active');
  document.getElementById('payTypeHidden').value = btn.dataset.val;
  const badge = document.getElementById('prevPayBadge');
  badge.className = 'pay-badge ' + btn.dataset.key;
  badge.textContent = btn.dataset.val;
  onPayInput();
  updatePreview();
}

function selectWorkType(btn) {
  document.querySelectorAll('#workTypeGroup .chip').forEach(b => b.classList.remove('active'));
  btn.classList.add('active');
  document.getElementById('workPeriodHidden').value = btn.dataset.val;
}

function toggleDay(btn) {
  btn.classList.toggle('active');
  syncDays();
  updatePreview();
  updateProgress();
}

function selectWeekdays() {
  document.querySelectorAll('.day-chip').forEach(b => {
    b.classList.toggle('active', !['SAT', 'SUN'].includes(b.dataset.val));
  });
  syncDays();
  updatePreview();
}

function selectWeekend() {
  document.querySelectorAll('.day-chip').forEach(b => {
    b.classList.toggle('active', ['SAT', 'SUN'].includes(b.dataset.val));
  });
  syncDays();
  updatePreview();
}

function selectAllDays() {
  document.querySelectorAll('.day-chip').forEach(b => b.classList.add('active'));
  syncDays();
  updatePreview();
}

function syncDays() {
  document.getElementById('workDaysHidden').value =
    [...document.querySelectorAll('.day-chip.active')].map(b => b.dataset.val).join(',');
}

function daysText() {
  const vals = [...document.querySelectorAll('.day-chip.active')].map(b => b.dataset.val);
  if (!vals.length) return '요일 미설정';
  if (vals.length === 7) return '매일';
  if (JSON.stringify(vals) === JSON.stringify(['MON', 'TUE', 'WED', 'THU', 'FRI'])) return '월~금';
  if (JSON.stringify(vals) === JSON.stringify(['SAT', 'SUN'])) return '토, 일';
  return vals.map(v => DAY_LABEL[v]).join(', ');
}

function toggleTimeInput(cb) {
  const st = document.getElementById('startTime');
  const et = document.getElementById('endTime');
  st.disabled = et.disabled = cb.checked;
  if (cb.checked) {
    st.value = '';
    et.value = '';
  }
  updatePreview();
}

function onPayInput() {
  const payType = document.getElementById('payTypeHidden').value;
  const val = parseInt(document.getElementById('pay').value, 10);
  const warn = document.getElementById('payWarn');
  warn.style.display = payType === '시급' && val > 0 && val < MIN_WAGE ? 'block' : 'none';
  updatePreview();
  updateProgress();
}

function handleImageUpload(input) {
  const grid = document.getElementById('imagePreviewGrid');
  [...input.files].slice(0, 5 - uploadedFiles.length).forEach(file => {
    if (!file.type.startsWith('image/')) return;
    uploadedFiles.push(file);
    const reader = new FileReader();
    reader.onload = e => {
      const item = document.createElement('div');
      item.className = 'preview-img-item';
      item.innerHTML = `<img src="${e.target.result}"><button type="button" class="preview-remove" onclick="removeImage(this)">✕</button>`;
      grid.appendChild(item);
      if (uploadedFiles.length === 1) {
        document.getElementById('prevThumb').innerHTML =
          `<img src="${e.target.result}" style="width:100%;height:100%;object-fit:cover;">`;
      }
    };
    reader.readAsDataURL(file);
  });
  input.value = '';
}

function removeImage(btn) {
  const item = btn.closest('.preview-img-item');
  const grid = document.getElementById('imagePreviewGrid');
  const idx = [...grid.children].indexOf(item);
  uploadedFiles.splice(idx, 1);
  item.remove();
  if (uploadedFiles.length === 0) {
    document.getElementById('prevThumb').innerHTML = '📋';
  }
}

function updateCharCount(inputId, countId) {
  document.getElementById(countId).textContent = document.getElementById(inputId).value.length;
}

function updatePreview() {
  document.getElementById('prevTitle').textContent =
    document.getElementById('title').value || '공고 제목이 여기 표시됩니다';
  document.getElementById('prevEmployer').textContent =
    document.getElementById('employer').value || '업체명';

  const deadlineVal = document.getElementById('deadline').value;
  const dDayBadge = document.getElementById('prevDday');

  if (deadlineVal) {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const dDate = new Date(deadlineVal);
    dDate.setHours(0, 0, 0, 0);
    const diffTime = dDate - today;
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

    if (diffDays < 0) {
      dDayBadge.textContent = '마감';
      dDayBadge.classList.add('expired');
    } else if (diffDays === 0) {
      dDayBadge.textContent = 'D-Day';
      dDayBadge.classList.remove('expired');
    } else {
      dDayBadge.textContent = 'D-' + diffDays;
      dDayBadge.classList.remove('expired');
    }
  } else {
    dDayBadge.textContent = 'D-?';
    dDayBadge.classList.remove('expired');
  }

  const pay = document.getElementById('pay').value;
  document.getElementById('prevPayAmt').textContent =
    pay ? Number(pay).toLocaleString() + '원' : '0원';

  const st = document.getElementById('startTime').value;
  const et = document.getElementById('endTime').value;
  const negotiable = document.getElementById('timeNegotiable').checked;
  const time = negotiable ? '시간협의' : st && et ? st + '~' + et : '시간 미설정';
  const loc = document.getElementById('location').value || '지역 미설정';

  document.getElementById('prevMeta').innerHTML =
    `<span><i class="ri-calendar-line"></i>${daysText()}</span><br>` +
    `<span><i class="ri-time-line"></i>${time}</span><br>` +
    `<span><i class="ri-map-pin-line"></i>${loc}</span>`;

  updateProgress();
}

function updateProgress() {
  const checks = [
    !!document.getElementById('title').value.trim(),
    !!document.getElementById('pay').value,
    !!document.getElementById('workDaysHidden').value,
    !!document.getElementById('location').value.trim()
  ];
  checks.forEach((done, i) => {
    const pi = document.getElementById('pi' + (i + 1));
    const pb = document.getElementById('pb' + (i + 1));
    if (pi) pi.classList.toggle('done', done);
    if (pb) pb.style.width = done ? '100%' : '0%';
  });
}

function submitForm() {
  const title = document.getElementById('title').value.trim();
  const pay = document.getElementById('pay').value;
  const loc = document.getElementById('location').value.trim();
  const days = document.getElementById('workDaysHidden').value;
  if (!title || !pay || !days || !loc) {
    alert('필수 항목을 모두 입력해주세요.');
    return;
  }
  document.getElementById('writeForm').submit();
}

document.addEventListener('DOMContentLoaded', () => {
  const workDaysHidden = document.getElementById('workDaysHidden');

  if (workDaysHidden && workDaysHidden.value) {
    const savedDays = workDaysHidden.value.split(',');
    savedDays.forEach(day => {
      const btn = document.querySelector(`.day-chip[data-val="${day.trim()}"]`);
      if (btn) btn.classList.add('active');
    });
  }

  updatePreview();
});