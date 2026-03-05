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

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoMapKey}&libraries=services"></script>
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<div class="write-layout">
    <div class="write-main">
        <input type="hidden" id="placeName" value="">
        <input type="hidden" id="address" value="">
        <input type="hidden" id="latitude" value="">
        <input type="hidden" id="longitude" value="">

        <div class="editor-header">
            <div class="editor-header-left">
                <button type="button" class="back-btn" onclick="history.back()">
                    <i class="ri-arrow-left-line"></i>
                </button>
                <h1 class="page-title">글쓰기</h1>
            </div>
            <div class="editor-header-right">
                <button type="button" class="btn-temp-save">임시저장</button>
                <button type="button" class="btn-submit">등록</button>
            </div>
        </div>

        <div class="editor-body">
            <div class="category-pills">
                <label class="cat-pill"><input type="radio" name="category" value="일상" checked><span>일상</span></label>
                <label class="cat-pill"><input type="radio" name="category" value="동네질문"><span>동네질문</span></label>
                <label class="cat-pill"><input type="radio" name="category" value="동네맛집"><span>동네맛집</span></label>
                <label class="cat-pill"><input type="radio" name="category" value="동네소식"><span>동네소식</span></label>
                <label class="cat-pill"><input type="radio" name="category" value="분실/실종"><span>분실/실종</span></label>
            </div>

            <div class="content-group">
                <input type="text" id="subject" class="input-title" placeholder="제목을 입력해주세요" autocomplete="off">
                <div class="divider"></div>
                <textarea id="content" class="textarea-main" placeholder="오늘 있었던 일을 이웃들과 나눠보세요 :)"></textarea>
                <div class="char-count"><span id="charCount">0</span>/2000</div>
            </div>

            <div class="media-group" id="dropZone">
                <div class="media-scroll" id="previewList">
                    <div class="media-add-btn">
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
                    <button type="button" class="btn-close-poll"><i class="ri-close-line"></i></button>
                </div>
                <div class="poll-body">
                    <input type="text" class="poll-title-input" id="pollTitle" placeholder="투표 제목을 입력하세요">
                    <div class="poll-options-list" id="pollOptionContainer"></div>
                    <button type="button" class="btn-add-option">+ 항목 추가</button>
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
                    <strong id="displayPlaceName">장소명</strong>
                    <span id="displayAddress">주소 정보</span>
                </div>
                <button type="button" class="btn-del-loc"><i class="ri-close-line"></i></button>
            </div>
        </div>

        <div class="editor-footer">
            <div class="toolbar">
                <button type="button" class="tool-btn" id="btnLocation">
                    <i class="ri-map-pin-line"></i>
                    <span>위치</span>
                </button>
                <button type="button" class="tool-btn" id="btnPoll">
                    <i class="ri-bar-chart-horizontal-line"></i>
                    <span>투표</span>
                </button>
            </div>
            <button type="button" class="btn-submit-full">등록하기</button>
        </div>
    </div>
    
    <div class="write-sidebar">
        <div class="sidebar-box">
            <h3>글쓰기 팁</h3>
            <ul class="tip-list">
                <li>청결한 커뮤니티를 위해 바르고 고운 말을 사용해주세요.</li>
                <li>사진을 첨부하면 더 많은 이웃들이 관심을 가질 수 있어요.</li>
                <li>판매/홍보 목적의 글은 <strong>중고거래</strong> 혹은 <strong>알바</strong> 게시판을 이용해주세요.</li>
            </ul>
        </div>
        <div class="sidebar-box">
            <h3>공개 설정</h3>
            <div class="visibility-options">
                <label class="vis-option">
                    <input type="radio" name="visibility" value="public" checked>
                    <div class="vis-icon"><i class="ri-earth-line"></i></div>
                    <div class="vis-text"><strong>전체 공개</strong><small>모든 이웃이 볼 수 있어요</small></div>
                </label>
                <label class="vis-option">
                    <input type="radio" name="visibility" value="neighbor">
                    <div class="vis-icon"><i class="ri-community-line"></i></div>
                    <div class="vis-text"><strong>동네 이웃만</strong><small>인증된 동네 이웃만 볼 수 있어요</small></div>
                </label>
            </div>
        </div>
    </div>
</div>

<div id="placeSearchModal" class="place-modal-overlay" style="display: none;">
    <div class="place-modal-content">
        <div class="place-modal-header">
            <h3>장소 검색</h3>
            <button type="button" class="btn-close-modal" onclick="closePlaceSearch()">
                <i class="ri-close-line"></i>
            </button>
        </div>
        <div class="place-search-box">
            <input type="text" id="keyword" placeholder="상호명이나 지역을 입력하세요 (예: 강남역 맛집)" onkeypress="if(event.keyCode==13) searchPlaces();">
            <button type="button" onclick="searchPlaces()">검색</button>
        </div>
        <ul id="placesList" class="place-result-list"></ul>
        <div id="pagination" class="place-pagination"></div>
    </div>
</div>

<div class="toast-container" id="toastContainer"></div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
<script src="${pageContext.request.contextPath}/dist/js/community-write.js"></script>

<script>
// [JSP 내부 스크립트] - 카카오 장소 검색 로직
let ps = null; // 장소 검색 객체

document.addEventListener('DOMContentLoaded', () => {
    // 1. 카카오 장소 검색 객체 생성 (API 로드 확인)
    if (window.kakao && window.kakao.maps && window.kakao.maps.services) {
        ps = new kakao.maps.services.Places();
    } else {
        console.error("Kakao Maps API 로드 실패 (키 확인 필요)");
    }
    
    // 2. 위치 버튼 클릭 시 모달 열기 이벤트 연결
    const btnLocation = document.getElementById('btnLocation');
    btnLocation.addEventListener('click', openPlaceModal);
});

// 모달 열기
function openPlaceModal() {
    const card = document.getElementById('locationCard');
    // 이미 위치가 등록된 경우 삭제 여부 확인
    if (card.style.display !== 'none') {
        if(confirm("설정된 위치를 변경하시겠습니까?")) {
            removeLocation(); // 기존 위치 삭제
        } else {
            return;
        }
    }
    // 모달 표시
    document.getElementById('placeSearchModal').style.display = 'flex';
    setTimeout(() => document.getElementById('keyword').focus(), 100);
}

// 모달 닫기
function closePlaceSearch() {
    document.getElementById('placeSearchModal').style.display = 'none';
    document.getElementById('keyword').value = '';
    document.getElementById('placesList').innerHTML = '';
}

// 장소 검색 실행
function searchPlaces() {
    const keyword = document.getElementById('keyword').value.trim();
    if (!keyword) {
        alert('검색어를 입력해주세요!');
        return;
    }
    if(!ps) {
        alert('지도 서비스를 사용할 수 없습니다.');
        return;
    }
    // 장소 검색 API 호출
    ps.keywordSearch(keyword, placesSearchCB);
}

// 장소 검색 콜백 함수
function placesSearchCB(data, status, pagination) {
    if (status === kakao.maps.services.Status.OK) {
        displayPlaces(data); // 목록 표시
    } else if (status === kakao.maps.services.Status.ZERO_RESULT) {
        alert('검색 결과가 존재하지 않습니다.');
    } else if (status === kakao.maps.services.Status.ERROR) {
        alert('검색 중 오류가 발생했습니다.');
    }
}

// 검색 결과 목록 표출
function displayPlaces(places) {
    const listEl = document.getElementById('placesList');
    listEl.innerHTML = ''; // 초기화

    for (let i = 0; i < places.length; i++) {
        const item = getListItem(places[i]);
        listEl.appendChild(item);
    }
}

// 리스트 아이템 생성 (HTML)
function getListItem(place) {
    const el = document.createElement('li');
    el.className = 'place-item';
    
    let itemStr = '<div class="info">' +
                  '   <h5>' + place.place_name + '</h5>';

    if (place.road_address_name) {
        itemStr += '    <span class="road-addr">' + place.road_address_name + '</span>' +
                   '    <span class="jibun-addr">(지번) ' + place.address_name + '</span>';
    } else {
        itemStr += '    <span>' + place.address_name + '</span>';
    }
    itemStr += '</div>';

    el.innerHTML = itemStr;

    // 아이템 클릭 시 선택 처리
    el.onclick = function () {
        // community-write.js 에 있는 setLocation 호출 (데이터 저장 및 UI 반영)
        // place_name: 장소명, address_name: 주소, y: 위도, x: 경도
        setLocation(place.place_name, place.address_name, place.y, place.x);
        closePlaceSearch(); // 모달 닫기
    };
    return el;
}
</script>

</body>
</html>