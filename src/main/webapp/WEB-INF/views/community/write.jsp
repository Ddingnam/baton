<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="contextPath" content="${pageContext.request.contextPath}">
<title>글쓰기 | BATON</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/community-write.css">
<link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<div class="write-layout">
    <div class="write-main">
        <div class="editor-header">
            <div class="editor-header-left">
                <button type="button" class="back-btn" onclick="history.back()">
                    <i class="ri-arrow-left-line"></i>
                </button>
                <h1 class="page-title">글쓰기</h1>
            </div>
            <div class="editor-header-right">
                <button type="button" class="btn-temp-save">임시저장</button>
                <button type="button" class="btn-submit" onclick="sendPost()">등록</button>
            </div>
        </div>

        <div class="editor-body">
            <div class="category-pills">
                <label class="cat-pill">
                    <input type="radio" name="category" value="일상" checked>
                    <span>일상</span>
                </label>
                <label class="cat-pill">
                    <input type="radio" name="category" value="동네질문">
                    <span>동네질문</span>
                </label>
                <label class="cat-pill">
                    <input type="radio" name="category" value="동네맛집">
                    <span>동네맛집</span>
                </label>
                <label class="cat-pill">
                    <input type="radio" name="category" value="동네소식">
                    <span>동네소식</span>
                </label>
                <label class="cat-pill">
                    <input type="radio" name="category" value="분실/실종">
                    <span>분실/실종</span>
                </label>
            </div>

            <div class="content-group">
                <input type="text" id="subject" class="input-title" placeholder="제목을 입력해주세요" autocomplete="off">
                <div class="divider"></div>
                <textarea id="content" class="textarea-main" placeholder="오늘 있었던 일을 이웃들과 나눠보세요 :)"></textarea>
                <div class="char-count"><span id="charCount">0</span>/2000</div>
            </div>

            <div class="media-group" id="dropZone">
                <div class="media-scroll" id="previewList">
                    <div class="media-add-btn" onclick="document.getElementById('fileInput').click()">
                        <i class="ri-camera-fill"></i>
                        <span><span id="fileCount">0</span>/10</span>
                    </div>
                </div>
                <input type="file" id="fileInput" multiple accept="image/*" hidden>
            </div>

            <div class="tag-group">
                <div class="tag-input-wrapper">
                    <span class="hash-symbol">#</span>
                    <input type="text" id="tagInput" class="input-tag" placeholder="태그 입력 (스페이스바 및 엔터)" autocomplete="off">
                </div>
                <div id="tagContainer" class="tag-list"></div>
            </div>

            <div class="poll-section" id="pollSection" style="display: none;">
                <div class="poll-header">
                    <h3>투표 만들기</h3>
                    <button type="button" class="btn-close-poll" onclick="togglePoll()"><i class="ri-close-line"></i></button>
                </div>
                <div class="poll-body">
                    <input type="text" class="poll-title-input" id="pollTitle" placeholder="투표 제목을 입력하세요">
                    <div class="poll-options-list" id="pollOptionContainer"></div>
                    <button type="button" class="btn-add-option" onclick="addPollOption()">+ 항목 추가</button>
                    <div class="poll-settings">
                        <label><input type="checkbox" id="pollMulti"> 복수 선택 허용</label>
                        <label><input type="checkbox" id="pollAnonymous"> 익명 투표</label>
                    </div>
                    <div class="poll-date">
                        <span>종료일</span>
                        <input type="date" id="pollEndDate">
                    </div>
                </div>
            </div>

            <div class="location-card" id="locationCard" style="display: none;">
                <div class="loc-icon"><i class="ri-map-pin-fill"></i></div>
                <div class="loc-info">
                    <strong id="locName">위치 정보 없음</strong>
                    <span id="locAddr">위치를 추가하려면 클릭하세요</span>
                </div>
                <button type="button" class="btn-del-loc" onclick="removeLocation()"><i class="ri-close-line"></i></button>
            </div>
        </div>

        <div class="editor-footer">
            <div class="toolbar">
                <button type="button" class="tool-btn" id="btnLocation" onclick="toggleLocationCard()">
                    <i class="ri-map-pin-line"></i>
                    <span>위치</span>
                </button>
                <button type="button" class="tool-btn" id="btnPoll" onclick="togglePoll()">
                    <i class="ri-bar-chart-horizontal-line"></i>
                    <span>투표</span>
                </button>
            </div>
            
            <button type="button" class="btn-submit-full" onclick="sendPost()">등록하기</button>
        </div>
    </div>
    
    <div class="write-sidebar">
        <div class="sidebar-box">
            <h3>글쓰기 팁</h3>
            <ul class="tip-list">
                <li>청결한 커뮤니티를 위해 바르고 고운 말을 사용해주세요.</li>
                <li>사진을 첨부하면 더 많은 이웃들이 관심을 가질 수 있어요.</li>
                <li>판매/홍보 목적의 글은 <strong>중고거래</strong> 혹은 <strong>알바</strong> 게시판을 이용해주세요.</li>
                <li>불쾌감을 주는 글은 관리자에 의해 숨김 처리될 수 있어요.</li>
            </ul>
        </div>

        <div class="sidebar-box">
            <h3>공개 설정</h3>
            <div class="visibility-options">
                <label class="vis-option">
                    <input type="radio" name="visibility" value="public" checked>
                    <div class="vis-icon"><i class="ri-earth-line"></i></div>
                    <div class="vis-text">
                        <strong>전체 공개</strong>
                        <small>모든 이웃이 볼 수 있어요</small>
                    </div>
                </label>
                <label class="vis-option">
                    <input type="radio" name="visibility" value="neighbor">
                    <div class="vis-icon"><i class="ri-community-line"></i></div>
                    <div class="vis-text">
                        <strong>동네 이웃만</strong>
                        <small>인증된 동네 이웃만 볼 수 있어요</small>
                    </div>
                </label>
            </div>
        </div>
    </div>
</div>

<div class="toast-container" id="toastContainer"></div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
<script src="${pageContext.request.contextPath}/dist/js/community-write.js"></script>

<script>
function toggleLocationCard() {
    const btn = document.getElementById('btnLocation');
    const card = document.getElementById('locationCard');
    const isActive = btn.classList.toggle('active');
    card.style.display = isActive ? '' : 'none';
    if (isActive) card.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
}

function togglePoll() {
    const section = document.getElementById('pollSection');
    const btn     = document.getElementById('btnPoll');
    const isShowing = section.classList.toggle('poll-visible');
    btn.classList.toggle('active', isShowing);
    section.style.display = isShowing ? '' : 'none';
    if (isShowing) {
        section.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
        showToast('🗳️ 투표가 추가됐어요');
    }
}

function addPollOption() {
    if (pollOptions.length >= 10) return;
    pollOptions.push('');
    renderPollOptions();
}

function renderPollOptions() {
    const container = document.getElementById('pollOptionContainer');
    container.innerHTML = '';
    pollOptions.forEach((_, idx) => {
        const div = document.createElement('div');
        div.className = 'poll-option-item';
        div.innerHTML = `
            <input type="text" placeholder="항목 \${idx + 1}" oninput="updatePollOption(\${idx}, this.value)">
            \${pollOptions.length > 2 ? `<button type="button" onclick="removePollOption(\${idx})"><i class="ri-close-line"></i></button>` : ''}
        `;
        container.appendChild(div);
    });
}

function updatePollOption(idx, val) {
    pollOptions[idx] = val;
}

function removePollOption(idx) {
    if (pollOptions.length <= 2) return;
    pollOptions.splice(idx, 1);
    renderPollOptions();
}

function removeLocation() {
    document.getElementById('locationCard').style.display = 'none';
    document.getElementById('btnLocation').classList.remove('active');
    currentLocation = null;
}
</script>
</body>
</html>