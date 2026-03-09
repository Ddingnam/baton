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
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/community/community-write.css">
<link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
<link href="https://cdn.quilljs.com/1.3.7/quill.snow.css" rel="stylesheet">
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoMapKey}&libraries=services&autoload=false"></script>
</head>
<body>

	<jsp:include page="/WEB-INF/views/layout/header.jsp" />

	<div class="write-layout">
		<div class="write-main">
			<form name="communityForm" method="post" enctype="multipart/form-data">

				<input type="hidden" name="mode" value="${mode}">
				<c:if test="${mode=='update'}">
					<input type="hidden" name="id" value="${dto.id}">
					<input type="hidden" name="page" value="${page}">
				</c:if>

				<input type="file" id="hiddenFileInput" name="uploadFiles" multiple style="display: none;">

				<input type="hidden" id="address" name="address" value="${dto.address}">
				<input type="hidden" id="latitude" name="latitude" value="${dto.latitude}">
				<input type="hidden" id="longitude" name="longitude" value="${dto.longitude}">
				<input type="hidden" id="placeName" name="placeName" value="${dto.placeName}">

				<div class="editor-header">
				    <div class="editor-header-left">
				        <button type="button" class="back-btn" onclick="history.back()">
				            <i class="ri-arrow-left-line"></i>
				        </button>
				        <h1 class="page-title">글쓰기</h1>
				    </div>
				    
				    <div class="editor-header-right" style="display: flex; gap: 8px;">
				        <button type="button" class="btn-temp-save" onclick="saveTemp();">임시저장</button>
				        <button type="button" class="btn-submit" onclick="sendOk();">${mode=='update'?'수정':'등록'}</button>
				    </div>
				</div>

				<div class="editor-body">
					<div class="category-pills">
						<label class="cat-pill"><input type="radio" name="category" value="1" ${mode=='write' || dto.category == 1 ? 'checked' : ''}><span>일상</span></label>
						<label class="cat-pill"><input type="radio" name="category" value="2" ${dto.category == 2 ? 'checked' : ''}><span>동네질문</span></label>
						<label class="cat-pill"><input type="radio" name="category" value="3" ${dto.category == 3 ? 'checked' : ''}><span>동네맛집</span></label>
						<label class="cat-pill"><input type="radio" name="category" value="4" ${dto.category == 4 ? 'checked' : ''}><span>동네소식</span></label>
						<label class="cat-pill"><input type="radio" name="category" value="5" ${dto.category == 5 ? 'checked' : ''}><span>분실/실종</span></label>
					</div>

					<div class="content-group">
						<input type="text" id="subject" name="subject" class="input-title" placeholder="제목을 입력해주세요" autocomplete="off" value="${dto.subject}">
						<div class="divider"></div>
						<div id="quillEditor" style="min-height: 300px; font-size: 16px;"></div>
						<input type="hidden" id="content" name="content" value="">
					</div>

					<div class="tag-group">
						<div class="tag-input-wrapper">
							<span class="hash-symbol">#</span> <input type="text" id="tagInput" class="input-tag" placeholder="태그 입력 (스페이스바 및 엔터)" autocomplete="off">
						</div>
						<div id="tagContainer" class="tag-list"></div>
					</div>

					<div class="poll-wrapper">
						<div class="poll-toggle-header">
							<div class="toggle-label">
								<i class="ri-bar-chart-horizontal-fill"></i> <span>투표 만들기</span>
							</div>
							<label class="switch"> <input type="checkbox" id="chkPollToggle" ${not empty dto.pollTitle ? 'checked' : ''}>
								<span class="slider round"></span>
							</label>
						</div>

						<div id="pollForm" class="poll-card">
							<div class="poll-input-group">
								<input type="text" name="pollTitle" id="pollTitle" class="input-poll-title" placeholder="무엇을 투표해볼까요?" autocomplete="off" value="${dto.pollTitle}">
							</div>
							<div class="poll-options-list" id="pollOptionContainer">
								<c:choose>
									<c:when test="${mode=='update' && not empty dto.pollOptions}">
										<c:forEach var="opt" items="${dto.pollOptions}" varStatus="status">
											<div class="poll-option-item">
												<input type="text" name="pollOptions" value="${opt}" class="input-option" autocomplete="off">
												<c:if test="${status.index > 1}">
													<button type="button" class="btn-del-option" onclick="this.parentElement.remove()">
														<i class="ri-close-line"></i>
													</button>
												</c:if>
											</div>
										</c:forEach>
									</c:when>
									<c:otherwise>
										<div class="poll-option-item">
											<input type="text" name="pollOptions" placeholder="항목 1" class="input-option" autocomplete="off">
										</div>
										<div class="poll-option-item">
											<input type="text" name="pollOptions" placeholder="항목 2" class="input-option" autocomplete="off">
										</div>
									</c:otherwise>
								</c:choose>
							</div>

							<button type="button" class="btn-add-option-dashed" onclick="addPollOption()">
								<i class="ri-add-line"></i> 항목 추가하기
							</button>

							<div class="poll-settings-bar">
								<div class="setting-group">
									<div class="date-picker-box">
										<i class="ri-calendar-event-line"></i> <input type="date" name="pollEndDate" id="pollEndDate" class="input-date-hidden" value="${dto.pollEndDate}"> <span id="dateDisplay">종료일 선택</span>
									</div>
								</div>

								<div class="setting-toggles">
									<label class="mini-check" title="복수 선택 허용"> <input type="checkbox" name="pollMultiple" id="pollMultiple" ${dto.pollMultiple ? 'checked' : ''}> <span class="check-btn">복수선택</span>
									</label> <label class="mini-check" title="익명 투표"> <input type="checkbox" name="pollAnonymous" id="pollAnonymous" ${dto.pollAnonymous ? 'checked' : ''}> <span class="check-btn">익명</span>
									</label>
								</div>
							</div>
						</div>
					</div>

					<div class="location-card" id="locationCard" style="display: ${not empty dto.placeName ? 'flex' : 'none'};">
						<div class="loc-icon">
							<i class="ri-map-pin-fill"></i>
						</div>
						<div class="loc-info">
							<strong id="displayPlaceName">${not empty dto.placeName ? dto.placeName : '장소명'}</strong>
							<span id="displayAddress">${not empty dto.address ? dto.address : '주소 정보'}</span>
						</div>
						<button type="button" class="btn-del-loc" onclick="removeLocation()">
							<i class="ri-close-line"></i>
						</button>
					</div>
				</div>

				<div class="editor-footer">
					<div class="toolbar">
						<button type="button" class="tool-btn" id="btnLocation">
							<i class="ri-map-pin-line"></i> <span>위치</span>
						</button>
					</div>
					<div class="footer-btns">
						<button type="button" class="btn-temp-save" onclick="saveTemp();">임시저장</button>
						<button type="button" class="btn-submit-full" onclick="sendOk();">${mode=='update'?'수정하기':'등록하기'}</button>
					</div>
				</div>
			</form>
		</div>

		<div class="write-sidebar">
			<div class="sidebar-box">
				<h3>글쓰기 팁</h3>
				<ul class="tip-list">
					<li>청결한 커뮤니티를 위해 바르고 고운 말을 사용해주세요.</li>
					<li>사진을 첨부하면 더 많은 이웃들이 관심을 가질 수 있어요.</li>
					<li>판매/홍보 목적의 글은 <strong>중고거래</strong> 게시판을 이용해주세요.</li>
				</ul>
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
				<input type="text" id="keyword" placeholder="장소명을 입력하세요 (예: 강남역)" onkeydown="if(event.keyCode==13) searchPlaces()">
				<button type="button" onclick="searchPlaces()">
					<i class="ri-search-line"></i>
				</button>
			</div>
			<ul id="placesList" class="place-result-list"></ul>
		</div>
	</div>

	<div class="toast-container" id="toastContainer"></div>

	<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

	<script src="https://cdn.quilljs.com/1.3.7/quill.min.js"></script>
	<script src="${pageContext.request.contextPath}/dist/js/community/community-write.js"></script>
	<script>
    let placesService = null;
    document.addEventListener('DOMContentLoaded', () => {
        kakao.maps.load(() => {
            if (window.kakao && window.kakao.maps && window.kakao.maps.services) {
                placesService = new kakao.maps.services.Places();
            }
		});
        const btnLocation = document.getElementById('btnLocation');
        if(btnLocation) {
            btnLocation.addEventListener('click', openPlaceModal);
        }

        <c:if test="${mode=='update' && not empty dto.tags}">
             <c:forEach var="tag" items="${dto.tags}">
                 tagList.push("${tag}");
             </c:forEach>
             renderTags();
        </c:if>
        
        <c:if test="${mode=='update' && not empty dto.content}">
        (function() {
            const rawContent = document.createElement('div');
            rawContent.innerHTML = `<c:out value="${dto.content}" escapeXml="false"/>`;
            if (quill) {
                quill.root.innerHTML = rawContent.innerHTML;
            }
        })();
        </c:if>
    });

    function openPlaceModal() {
        const card = document.getElementById('locationCard');
        if (card.style.display !== 'none') {
            if(confirm("설정된 위치를 변경하시겠습니까?")) {
                removeLocation();
            } else {
                return;
            }
        }
        document.getElementById('placeSearchModal').style.display = 'flex';
        setTimeout(() => document.getElementById('keyword').focus(), 100);
    }

    function closePlaceSearch() {
        document.getElementById('placeSearchModal').style.display = 'none';
        document.getElementById('keyword').value = '';
        document.getElementById('placesList').innerHTML = '';
    }

    function searchPlaces() {
        const keyword = document.getElementById('keyword').value.trim();
        if (!keyword) {
            alert('검색어를 입력해주세요!');
            return;
        }
        if(!placesService) {
            alert('지도 서비스를 사용할 수 없습니다.');
            return;
        }
        placesService.keywordSearch(keyword, placesSearchCallback);
    }

    function placesSearchCallback(data, status, pagination) {
        if (status === kakao.maps.services.Status.OK) {
            displayPlaces(data);
        } else if (status === kakao.maps.services.Status.ZERO_RESULT) {
            alert('검색 결과가 존재하지 않습니다.');
        } else if (status === kakao.maps.services.Status.ERROR) {
            alert('검색 중 오류가 발생했습니다.');
        }
    }

    function displayPlaces(places) {
        const listElement = document.getElementById('placesList');
        listElement.innerHTML = '';
        for (let i = 0; i < places.length; i++) {
            const item = getListItem(places[i]);
            listElement.appendChild(item);
        }
    }

    function getListItem(place) {
        const element = document.createElement('li');
        element.className = 'place-item';
        let itemHtml = '<div class="info">' +
                      '   <h5>' + place.place_name + '</h5>';
        if (place.road_address_name) {
            itemHtml += '    <span class="road-addr">' + place.road_address_name + '</span>' +
                       '    <span class="jibun-addr">(지번) ' + place.address_name + '</span>';
        } else {
            itemHtml += '    <span>' + place.address_name + '</span>';
        }
        itemHtml += '</div>';

        element.innerHTML = itemHtml;
        element.onclick = function () {
            setLocation(place.place_name, place.address_name, place.y, place.x);
            closePlaceSearch();
        };
        return element;
    }
</script>

</body>
</html>