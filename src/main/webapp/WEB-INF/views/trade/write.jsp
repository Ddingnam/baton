<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>상품 등록 | 마켓</title>
<link rel="icon" href="data:;base64,iVBORw0KGgo=">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
    :root {
        --primary: #FF6F0F;
        --primary-dark: #e55e00;
        --primary-light: #FFF3EC;
        --surface: #ffffff;
        --bg: #F7F8FA;
        --border: #E8EAED;
        --text-main: #1A1A1A;
        --text-sub: #72787F;
        --text-muted: #B0B8C1;
        --radius: 12px;
        --radius-sm: 8px;
        --shadow: 0 1px 3px rgba(0,0,0,0.08), 0 4px 16px rgba(0,0,0,0.05);
    }
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: 'Noto Sans KR', sans-serif; background: var(--bg); color: var(--text-main); min-height: 100vh; }

    /* Header */
    .app-header {
        position: sticky; top: 0; z-index: 100;
        background: var(--surface); border-bottom: 1px solid var(--border);
        display: flex; align-items: center; gap: 12px;
        padding: 0 20px; height: 56px;
    }
    .back-btn {
        width: 36px; height: 36px; border-radius: 50%;
        border: none; background: none; cursor: pointer;
        display: flex; align-items: center; justify-content: center;
        color: var(--text-main); transition: background .15s;
    }
    .back-btn:hover { background: var(--bg); }
    .app-header h1 { font-size: 17px; font-weight: 700; flex: 1; }
    .header-submit-btn {
        padding: 8px 18px; border-radius: 8px;
        background: var(--primary); color: white;
        border: none; font-size: 14px; font-weight: 600;
        cursor: pointer; font-family: inherit;
        transition: background .15s;
    }
    .header-submit-btn:hover { background: var(--primary-dark); }

    /* Layout */
    .page-wrap { max-width: 680px; margin: 0 auto; padding: 24px 20px 100px; }

    /* Card */
    .card {
        background: var(--surface); border-radius: var(--radius);
        box-shadow: var(--shadow); padding: 24px; margin-bottom: 16px;
    }
    .card-title {
        font-size: 12px; font-weight: 700; color: var(--text-sub);
        letter-spacing: .08em; text-transform: uppercase; margin-bottom: 16px;
    }

    /* Image Upload */
    .image-section { display: flex; gap: 10px; flex-wrap: wrap; align-items: flex-start; }
    .img-add-btn {
        width: 82px; height: 82px; border-radius: var(--radius-sm);
        border: 2px dashed var(--border); background: var(--bg);
        display: flex; flex-direction: column; align-items: center;
        justify-content: center; cursor: pointer; gap: 5px; flex-shrink: 0;
        transition: border-color .2s, background .2s;
    }
    .img-add-btn:hover { border-color: var(--primary); background: var(--primary-light); }
    .img-add-btn .cam-icon { font-size: 22px; }
    .img-count { font-size: 11px; font-weight: 700; color: var(--primary); }
    .preview-list { display: flex; gap: 10px; flex-wrap: wrap; }
    .preview-item {
        position: relative; width: 82px; height: 82px;
        border-radius: var(--radius-sm); overflow: hidden;
        border: 2px solid var(--border); flex-shrink: 0;
    }
    .preview-item.is-thumb { border-color: var(--primary); }
    .preview-item img { width: 100%; height: 100%; object-fit: cover; }
    .thumb-badge {
        position: absolute; bottom: 0; left: 0; right: 0;
        background: var(--primary); color: white;
        font-size: 10px; font-weight: 700; text-align: center; padding: 2px 0;
    }
    .remove-img-btn {
        position: absolute; top: 4px; right: 4px;
        width: 20px; height: 20px; border-radius: 50%;
        background: rgba(0,0,0,0.5); color: white;
        border: none; font-size: 12px; cursor: pointer;
        display: flex; align-items: center; justify-content: center;
    }

    /* Fields */
    .field { margin-bottom: 20px; }
    .field:last-child { margin-bottom: 0; }
    .field > label {
        display: block; font-size: 13px; font-weight: 600;
        color: var(--text-sub); margin-bottom: 8px;
    }
    .field > label .req { color: var(--primary); }
    input[type="text"], input[type="number"], select, textarea {
        width: 100%; padding: 12px 14px;
        border: 1.5px solid var(--border); border-radius: var(--radius-sm);
        font-size: 15px; font-family: inherit; color: var(--text-main);
        background: var(--surface); outline: none;
        transition: border-color .2s, box-shadow .2s;
    }
    input[type="text"]:focus, input[type="number"]:focus, select:focus, textarea:focus {
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(255,111,15,0.12);
    }
    input::placeholder, textarea::placeholder { color: var(--text-muted); }
    textarea { resize: vertical; min-height: 140px; line-height: 1.7; }
    .price-wrap { position: relative; }
    .price-wrap .won-sign {
        position: absolute; left: 14px; top: 50%; transform: translateY(-50%);
        font-size: 15px; font-weight: 600; color: var(--text-sub);
    }
    .price-wrap input { padding-left: 28px; }
    .field-footer { display: flex; justify-content: flex-end; margin-top: 6px; }
    .char-count { font-size: 12px; color: var(--text-muted); }
    .char-count.warn { color: var(--primary); font-weight: 600; }

    /* Status Pills */
    .pill-group { display: flex; gap: 8px; flex-wrap: wrap; }
    .pill-group input[type="radio"] { display: none; }
    .pill-group label {
        padding: 8px 16px; border: 1.5px solid var(--border);
        border-radius: 100px; cursor: pointer; font-size: 13px; font-weight: 500;
        color: var(--text-sub); background: var(--surface);
        transition: all .15s; user-select: none;
    }
    .pill-group label:hover { border-color: var(--primary); color: var(--primary); }
    .pill-group input[type="radio"]:checked + label {
        background: var(--primary-light); color: var(--primary);
        border-color: var(--primary); font-weight: 700;
    }

    /* Trade Type */
    .trade-type-group { display: flex; gap: 8px; }
    .trade-type-group input[type="radio"] { display: none; }
    .trade-type-group label {
        flex: 1; padding: 14px 10px; border: 1.5px solid var(--border);
        border-radius: var(--radius-sm); cursor: pointer; text-align: center;
        font-size: 14px; font-weight: 500; color: var(--text-sub);
        transition: all .15s; user-select: none;
    }
    .trade-type-group label .t-icon { display: block; font-size: 22px; margin-bottom: 5px; }
    .trade-type-group input[type="radio"]:checked + label {
        background: var(--primary-light); color: var(--primary);
        border-color: var(--primary); font-weight: 700;
    }

    /* Tags */
    .tag-wrap {
        border: 1.5px solid var(--border); border-radius: var(--radius-sm);
        padding: 8px 10px; display: flex; flex-wrap: wrap; gap: 6px;
        cursor: text; transition: border-color .2s, box-shadow .2s; min-height: 48px;
    }
    .tag-wrap:focus-within { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(255,111,15,0.12); }
    .tag-chip {
        display: inline-flex; align-items: center; gap: 4px;
        background: var(--primary-light); color: var(--primary);
        padding: 4px 10px; border-radius: 100px;
        font-size: 13px; font-weight: 600;
        animation: chipIn .12s ease;
    }
    @keyframes chipIn { from { transform: scale(0.75); opacity: 0; } to { transform: scale(1); opacity: 1; } }
    .tag-chip .del-btn { background: none; border: none; cursor: pointer; color: var(--primary); font-size: 15px; line-height: 1; padding: 0 0 0 2px; opacity: 0.7; }
    .tag-chip .del-btn:hover { opacity: 1; }
    #tagInput { border: none !important; box-shadow: none !important; outline: none; padding: 4px 4px; font-size: 14px; flex: 1; min-width: 100px; background: transparent; width: auto; }
    .tag-hint { font-size: 12px; color: var(--text-muted); margin-top: 7px; }

    /* Bottom Bar */
    .bottom-bar {
        position: fixed; bottom: 0; left: 0; right: 0;
        background: var(--surface); border-top: 1px solid var(--border);
        padding: 12px 20px;
    }
    .submit-btn {
        display: block; width: 100%; max-width: 640px; margin: 0 auto;
        padding: 16px; background: var(--primary); color: white;
        border: none; border-radius: var(--radius-sm);
        font-size: 16px; font-weight: 700; cursor: pointer; font-family: inherit;
        transition: background .15s, transform .1s;
    }
    .submit-btn:hover { background: var(--primary-dark); }
    .submit-btn:active { transform: scale(0.99); }
</style>
</head>
<body>

<header class="app-header">
    <button class="back-btn" onclick="history.back()" aria-label="뒤로가기">
        <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path d="M15 18l-6-6 6-6"/></svg>
    </button>
    <h1>내 물건 팔기</h1>
    <button class="header-submit-btn" onclick="submitForm()">등록</button>
</header>

<div class="page-wrap">
    <form id="tradeForm" name="tradeForm" method="post" enctype="multipart/form-data">

        <!-- 이미지 -->
        <div class="card">
            <p class="card-title">상품 이미지</p>
            <div class="image-section">
                <div class="img-add-btn" onclick="document.getElementById('selectFile').click()">
                    <span class="cam-icon">📷</span>
                    <span class="img-count" id="imgCount">0/5</span>
                </div>
                <div class="preview-list" id="previewList"></div>
            </div>
            <input type="file" name="selectFile" id="selectFile" accept="image/*" multiple style="display:none">
            <p style="font-size:12px;color:var(--text-muted);margin-top:10px;">첫 번째 사진이 대표 이미지로 사용됩니다.</p>
        </div>

        <!-- 기본 정보 -->
        <div class="card">
            <p class="card-title">기본 정보</p>

            <div class="field">
                <label>제목 <span class="req">*</span></label>
                <input type="text" name="title" id="titleInput" maxlength="50" placeholder="어떤 물건을 파시나요?">
                <div class="field-footer"><span class="char-count" id="titleCount">0/50</span></div>
            </div>

            <div class="field">
                <label>카테고리 <span class="req">*</span></label>
                <select name="categoryIdx">
                    <option value="">카테고리를 선택하세요</option>
                    <option value="1">📱 전자기기</option>
                    <option value="2">👗 의류</option>
                    <option value="3">💄 뷰티</option>
                    <option value="4">⭐ 스타굿즈</option>
                    <option value="5">🏠 가구/인테리어</option>
                    <option value="6">📚 도서</option>
                    <option value="7">🎮 게임</option>
                    <option value="8">기타</option>
                </select>
            </div>

            <div class="field">
                <label>물품 상태 <span class="req">*</span></label>
                <div class="pill-group">
                    <input type="radio" name="productStatus" id="s1" value="새상품" checked>
                    <label for="s1">새상품</label>
                    <input type="radio" name="productStatus" id="s2" value="사용감없음">
                    <label for="s2">사용감 없음</label>
                    <input type="radio" name="productStatus" id="s3" value="사용감적음">
                    <label for="s3">사용감 적음</label>
                    <input type="radio" name="productStatus" id="s4" value="사용감많음">
                    <label for="s4">사용감 많음</label>
                    <input type="radio" name="productStatus" id="s5" value="고장/파손">
                    <label for="s5">고장/파손</label>
                </div>
            </div>

            <div class="field">
                <label>판매 가격 <span class="req">*</span></label>
                <div class="price-wrap">
                    <span class="won-sign">₩</span>
                    <input type="number" name="price" id="priceInput" placeholder="0" min="0">
                </div>
            </div>
        </div>

        <!-- 상품 설명 -->
        <div class="card">
            <p class="card-title">상품 설명</p>
            <div class="field">
                <textarea name="content" id="contentInput" rows="7" maxlength="2000"
                    placeholder="브랜드, 모델명, 구매 시기, 사용 기간, 하자 여부 등 자세히 작성할수록 빨리 팔려요 😊"></textarea>
                <div class="field-footer"><span class="char-count" id="contentCount">0/2000</span></div>
            </div>
        </div>
        
        <!-- 태그 -->
        <div class="card">
            <p class="card-title">태그</p>
            <div class="field">
                <div class="tag-wrap" id="tagWrap" onclick="document.getElementById('tagInput').focus()">
                    <input type="text" id="tagInput" maxlength="20" placeholder="# 태그 입력 후 Enter">
                </div>
                <p class="tag-hint">최대 5개 · 관련 키워드를 추가하면 검색에 노출되기 쉬워요</p>
                <input type="hidden" name="tags" id="finalTags">
            </div>
        </div>

        <!-- 거래 방식 -->
        <div class="card">
            <p class="card-title">거래 방식</p>
            <div class="field">
                <div class="trade-type-group">
                    <input type="radio" name="tradeType" id="t1" value="직거래" checked>
                    <label for="t1"><span class="t-icon">🤝</span>직거래</label>
                    <input type="radio" name="tradeType" id="t2" value="택배">
                    <label for="t2"><span class="t-icon">📦</span>택배</label>
                    <input type="radio" name="tradeType" id="t3" value="둘다가능">
                    <label for="t3"><span class="t-icon">✅</span>둘 다 가능</label>
                </div>
            </div>
            <div class="field" id="tradePlaceField">
                <label>거래 희망 장소</label>
                <input type="text" name="tradePlace" placeholder="예: 강남역 1번 출구">
            </div>
        </div>

    </form>
</div>

<div class="bottom-bar">
    <button class="submit-btn" onclick="submitForm()">게시글 등록하기</button>
</div>

<script>
let uploadedFiles = [];
const selectFile = document.getElementById('selectFile');
const previewList = document.getElementById('previewList');
const imgCount = document.getElementById('imgCount');

selectFile.addEventListener('change', function () {
    const newFiles = Array.from(this.files);
    const remaining = 5 - uploadedFiles.length;
    if (newFiles.length > remaining) alert('최대 5장까지 가능합니다. ' + remaining + '장만 추가됩니다.');
    newFiles.slice(0, remaining).forEach(function(file) {
        if (!file.type.startsWith('image/')) return;
        const reader = new FileReader();
        reader.onload = function(e) { uploadedFiles.push({ file: file, url: e.target.result }); renderPreviews(); };
        reader.readAsDataURL(file);
    });
    this.value = '';
});

function renderPreviews() {
    previewList.innerHTML = '';
    uploadedFiles.forEach(function(item, i) {
        const div = document.createElement('div');
        div.className = 'preview-item' + (i === 0 ? ' is-thumb' : '');
        const thumbBadge = (i === 0) ? '<div class="thumb-badge">대표</div>' : '';
        div.innerHTML = '<img src="' + item.url + '" alt="미리보기">'
            + thumbBadge
            + '<button type="button" class="remove-img-btn" onclick="removeImg(' + i + ')">✕</button>';
        previewList.appendChild(div);
    });
    imgCount.textContent = uploadedFiles.length + '/5';
}

function removeImg(i) { uploadedFiles.splice(i, 1); renderPreviews(); }

/* ── 글자 수 카운터 ── */
function bindCounter(inputId, countId, max) {
    const el = document.getElementById(inputId);
    const counter = document.getElementById(countId);
    el.addEventListener('input', function() {
        const len = el.value.length;
        counter.textContent = len + '/' + max;
        counter.className = 'char-count' + (len > max * 0.9 ? ' warn' : '');
    });
}
bindCounter('titleInput', 'titleCount', 50);
bindCounter('contentInput', 'contentCount', 2000);

document.querySelectorAll('input[name="tradeType"]').forEach(r => {
    r.addEventListener('change', function () {
        document.getElementById('tradePlaceField').style.display = this.value === '택배' ? 'none' : 'block';
    });
});

const tags = [];
const tagInput = document.getElementById('tagInput');
const tagWrap = document.getElementById('tagWrap');
const finalTags = document.getElementById('finalTags');

tagInput.addEventListener('keydown', function (e) {
    if (e.key === 'Enter') {
        e.preventDefault();
        const val = this.value.trim().replace(/^#/, '');
        if (!val) return;
        if (tags.length >= 5) { alert('태그는 최대 5개입니다.'); return; }
        if (!tags.includes(val)) { tags.push(val); renderTags(); }
        this.value = '';
    }
    if (e.key === 'Backspace' && this.value === '' && tags.length) { tags.pop(); renderTags(); }
});

function renderTags() {
    tagWrap.querySelectorAll('.tag-chip').forEach(function(el) { el.remove(); });
    tags.forEach(function(tag, i) {
        const span = document.createElement('span');
        span.className = 'tag-chip';
        span.innerHTML = '#' + tag + '<button type="button" class="del-btn" onclick="removeTag(' + i + ')">×</button>';
        tagWrap.insertBefore(span, tagInput);
    });
    finalTags.value = tags.join(',');
}

function removeTag(i) { tags.splice(i, 1); renderTags(); }


function submitForm() {
    const f = document.tradeForm;
    if (!f.title.value.trim()) { alert('제목을 입력해주세요.'); f.title.focus(); return; }
    if (!f.categoryIdx.value) { alert('카테고리를 선택해주세요.'); f.categoryIdx.focus(); return; }
    if (!f.price.value || f.price.value < 0) { alert('판매 가격을 입력해주세요.'); f.price.focus(); return; }
    f.action = '/trade/write';
    f.submit();
}
</script>
</body>
</html>
