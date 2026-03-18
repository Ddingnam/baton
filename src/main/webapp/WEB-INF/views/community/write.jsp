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
				<input type="hidden" name="regionType" id="writeRegionType" value="${regionType > 0 ? regionType : 1}">
				<c:if test="${mode=='update'}">
					<input type="hidden" name="id" value="${dto.id}">
					<input type="hidden" name="page" value="${page}">
				</c:if>
				<input type="file" id="hiddenFileInput" name="uploadFiles" multiple style="display:none;">
				<input type="file" id="attachFileInput" name="attachFiles" multiple style="display:none;">
				<input type="hidden" id="address"   name="address"   value="${dto.address}">
				<input type="hidden" id="latitude"  name="latitude"  value="${dto.latitude}">
				<input type="hidden" id="longitude" name="longitude" value="${dto.longitude}">
				<input type="hidden" id="placeName" name="placeName" value="${dto.placeName}">

				<div class="editor-header">
					<div class="editor-header-left">
						<button type="button" class="back-btn" onclick="history.back()">
							<i class="ri-arrow-left-line"></i>
						</button>
						<h1 class="page-title">${mode=='update' ? '글 수정' : '글쓰기'}</h1>
						<c:if test="${mode != 'update' && not empty userRegionInfo}">
							<c:choose>
								<c:when test="${regionType == 2 && not empty userRegionInfo.subRegion}">
									<span class="write-region-badge">
										<i class="ri-map-pin-2-fill"></i>${userRegionInfo.subRegion.dong}
									</span>
								</c:when>
								<c:when test="${not empty userRegionInfo.mainRegion}">
									<span class="write-region-badge">
										<i class="ri-map-pin-2-fill"></i>${userRegionInfo.mainRegion.dong}
									</span>
								</c:when>
							</c:choose>
						</c:if>
					</div>
					<div class="editor-header-right">
						<button type="button" class="btn-icon-only" onclick="openTempListModal()" title="임시저장 목록">
							<i class="ri-draft-line"></i>
							<span id="tempCountBadge" class="temp-badge" style="display:none;"></span>
						</button>
						<button type="button" class="btn-ghost-save" onclick="saveTemp()" title="임시저장">
							임시저장
						</button>
						<button type="button" class="btn-submit" onclick="sendOk();">${mode=='update' ? '수정' : '등록'}</button>
					</div>
				</div>

				<div class="editor-body">

					<div class="category-section">
						<span class="category-label">카테고리</span>
						<div class="category-pills">
							<label class="cat-pill"><input type="radio" name="category" value="1" ${mode=='write' || dto.category == 1 ? 'checked' : ''}><span>일상</span></label>
							<label class="cat-pill"><input type="radio" name="category" value="2" ${dto.category == 2 ? 'checked' : ''}><span>동네질문</span></label>
							<label class="cat-pill"><input type="radio" name="category" value="3" ${dto.category == 3 ? 'checked' : ''}><span>동네맛집</span></label>
							<label class="cat-pill"><input type="radio" name="category" value="4" ${dto.category == 4 ? 'checked' : ''}><span>같이해요</span></label>
							<label class="cat-pill"><input type="radio" name="category" value="5" ${dto.category == 5 ? 'checked' : ''}><span>분실/실종</span></label>
							<label class="cat-pill"><input type="radio" name="category" value="6" ${dto.category == 6 ? 'checked' : ''}><span>동네사건사고</span></label>
							<label class="cat-pill"><input type="radio" name="category" value="7" ${dto.category == 7 ? 'checked' : ''}><span>생활정보</span></label>
							<label class="cat-pill"><input type="radio" name="category" value="8" ${dto.category == 8 ? 'checked' : ''}><span>취미생활</span></label>
						</div>
					</div>

					<div class="content-group">
						<input type="text" id="subject" name="subject" class="input-title"
							placeholder="제목을 입력해주세요" autocomplete="off" value="${dto.subject}">
						<div class="divider"></div>
						<div id="quillEditor" style="min-height:300px; font-size:16px;"></div>
						<input type="hidden" id="content" name="content" value="">
					</div>

					<div class="location-card" id="locationCard"
						style="display:${not empty dto.placeName ? 'flex' : 'none'};">
						<div class="loc-icon"><i class="ri-map-pin-fill"></i></div>
						<div class="loc-info">
							<strong id="displayPlaceName">${not empty dto.placeName ? dto.placeName : '장소명'}</strong>
							<span id="displayAddress">${not empty dto.address ? dto.address : '주소 정보'}</span>
						</div>
						<button type="button" class="btn-del-loc" onclick="removeLocation()">
							<i class="ri-close-line"></i>
						</button>
					</div>

					<div id="attachListWrapper" style="display:${not empty dto.attachFileInfos ? 'block' : 'none'}">
					<ul class="attach-file-list" id="attachFileList">
						<c:if test="${mode=='update' && not empty dto.attachFileInfos}">
							<c:forEach var="af" items="${dto.attachFileInfos}">
								<li class="attach-file-item" data-filename="${af.saveFilename}">
									<i class="ri-file-line"></i>
									<span class="attach-file-name">${af.originalFilename}</span>
									<button type="button" class="btn-remove-attach"
										onclick="removeExistingAttach('${af.saveFilename}', this)">
										<i class="ri-close-line"></i>
									</button>
									<input type="hidden" name="existingFiles" value="${af.saveFilename}">
								</li>
							</c:forEach>
						</c:if>
					</ul>
					</div>

					<input type="hidden" id="pollVotedLocked" value="${pollVotedLocked == true ? 'true' : 'false'}">
					<div class="poll-wrapper">
						<div class="poll-toggle-header">
							<div class="toggle-label">
								<i class="ri-bar-chart-horizontal-fill"></i>
								<span>투표 만들기</span>
							</div>
							<label class="switch">
								<input type="checkbox" id="chkPollToggle" ${not empty dto.pollTitle ? 'checked' : ''}>
								<span class="slider round"></span>
							</label>
						</div>
						<div id="pollVotedNotice" class="poll-disabled-notice" style="display:none; margin: 0 24px 0;">
							<i class="ri-lock-2-line"></i>
							<span>이미 투표한 이웃이 있어 투표 항목을 수정할 수 없어요.</span>
						</div>
						<div id="pollForm" class="poll-card">
							<div class="poll-input-group">
								<input type="text" name="pollTitle" id="pollTitle" class="input-poll-title"
									placeholder="무엇을 투표해볼까요?" autocomplete="off" value="${dto.pollTitle}">
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
										<i class="ri-calendar-event-line"></i>
										<input type="date" name="pollEndDate" id="pollEndDate"
											class="input-date-hidden" value="${dto.pollEndDate}">
										<span id="dateDisplay">종료일 선택</span>
									</div>
								</div>
								<div class="setting-toggles">
									<label class="mini-check" title="복수 선택 허용">
										<input type="checkbox" name="pollMultiple" id="pollMultiple" ${dto.pollMultiple ? 'checked' : ''}>
										<span class="check-btn">복수선택</span>
									</label>
								</div>
							</div>
						</div>
					</div>
					<div class="tag-group">
						<div class="tag-input-wrapper">
							<span class="hash-symbol">#</span>
							<input type="text" id="tagInput" class="input-tag"
								placeholder="태그 입력 (스페이스바 및 엔터)" autocomplete="off">
						</div>
						<div id="tagContainer" class="tag-list"></div>
					</div>

				</div>
				
				<div class="editor-footer">
					<div class="toolbar">
						<button type="button" class="tool-btn" id="btnLocation" title="위치 추가">
							<i class="ri-map-pin-line"></i><span>위치</span>
						</button>
						<button type="button" class="tool-btn" id="btnAttach" title="파일 첨부"
							onclick="document.getElementById('attachFileInput').click()">
							<i class="ri-attachment-2"></i><span>파일</span>
						</button>
					</div>
					<div class="footer-right">
						<span class="attach-count-label" id="attachCountLabel" style="display:none;"></span>
						<button type="button" class="btn-submit-full" onclick="sendOk();">
							${mode=='update' ? '수정하기' : '등록하기'}
						</button>
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

	<div id="tempListModal" class="place-modal-overlay" style="display:none;"
		onclick="onTempModalOverlayClick(event)">
		<div class="place-modal-content" id="tempModalContent"
			style="max-width:600px; width:95%; max-height:90vh; display:flex; flex-direction:column;">
			<div class="place-modal-header" style="flex-shrink:0;">
				<h3>임시저장 목록</h3>
				<button type="button" class="btn-close-modal" onclick="closeTempListModal()">
					<i class="ri-close-line"></i>
				</button>
			</div>
			<div id="tempListView" style="display:flex; flex-direction:column; flex:1; overflow:hidden;">
				<ul id="tempListContent" class="place-result-list"
					style="flex:1; overflow-y:auto; padding:8px 0; margin:0;">
					<li style="text-align:center; padding:32px; color:#aaa;">
						<i class="ri-loader-4-line ri-spin"></i> 불러오는 중...
					</li>
				</ul>
			</div>
		</div>
	</div>

	<div id="placeSearchModal" class="place-modal-overlay" style="display:none;">
		<div class="place-modal-content">
			<div class="place-modal-header">
				<h3>장소 검색</h3>
				<button type="button" class="btn-close-modal" onclick="closePlaceSearch()">
					<i class="ri-close-line"></i>
				</button>
			</div>
			<div class="place-search-box">
				<input type="text" id="keyword" placeholder="장소명을 입력하세요 (예: 강남역)"
					onkeydown="if(event.keyCode==13) searchPlaces()">
				<button type="button" onclick="searchPlaces()"><i class="ri-search-line"></i></button>
			</div>
			<ul id="placesList" class="place-result-list"></ul>
		</div>
	</div>

	<div class="toast-container" id="toastContainer"></div>

	<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

	<script src="https://cdn.quilljs.com/1.3.7/quill.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/quill-image-resize-module@3.0.0/image-resize.min.js"></script>
	<script src="${pageContext.request.contextPath}/dist/js/community/community-write.js"></script>
	<script>
    let placesService = null;
    document.addEventListener('DOMContentLoaded', () => {
        kakao.maps.load(() => {
            if (window.kakao && window.kakao.maps && window.kakao.maps.services)
                placesService = new kakao.maps.services.Places();
        });

        const btnLocation = document.getElementById('btnLocation');
        if (btnLocation) btnLocation.addEventListener('click', openPlaceModal);

        const attachInput = document.getElementById('attachFileInput');
        if (attachInput) {
            attachInput.addEventListener('change', function() {
                if (typeof handleAttachFiles === 'function') handleAttachFiles(this.files);
                this.value = '';
            });
        }

        <c:if test="${mode=='update' && not empty dto.tags}">
            <c:forEach var="tag" items="${dto.tags}">tagList.push("${tag}");</c:forEach>
            renderTags();
        </c:if>

        <c:if test="${mode=='update' && not empty dto.content}">
        (function() {
            const d = document.createElement('div');
            d.innerHTML = `<c:out value="${dto.content}" escapeXml="false"/>`;
            if (quill) quill.root.innerHTML = d.innerHTML;
        })();
        </c:if>
    });

    function openPlaceModal() {
        const card = document.getElementById('locationCard');
        if (card.style.display !== 'none') {
            batonConfirm("설정된 위치를 변경하시겠습니까?", () => {
                removeLocation();
                const modal = document.getElementById('placeSearchModal');
                modal.style.display = 'flex';
                requestAnimationFrame(() => modal.classList.add('show'));
                setTimeout(() => document.getElementById('keyword').focus(), 100);
            });
            return;
        }
        const modal = document.getElementById('placeSearchModal');
        modal.style.display = 'flex';
        requestAnimationFrame(() => modal.classList.add('show'));
        setTimeout(() => document.getElementById('keyword').focus(), 100);
    }

    function closePlaceSearch() {
        const modal = document.getElementById('placeSearchModal');
        modal.classList.remove('show');
        setTimeout(() => {
            modal.style.display = 'none';
            document.getElementById('keyword').value = '';
            document.getElementById('placesList').innerHTML = '';
        }, 220);
    }
    function searchPlaces() {
        var kwd = document.getElementById('keyword').value.trim();
        if (!kwd) { showBatonToast('검색어를 입력해주세요!'); return; }
        if (!placesService) { showBatonToast('지도 서비스를 사용할 수 없습니다.'); return; }
        placesService.keywordSearch(kwd, function(data, status) {
            if (status === kakao.maps.services.Status.OK) {
                var list = document.getElementById('placesList');
                list.innerHTML = '';
                data.forEach(function(place) {
                    var el = document.createElement('li');
                    el.className = 'place-item';
                    var addrHtml = place.road_address_name
                        ? '<span class="road-addr">' + place.road_address_name + '</span>'
                          + '<span class="jibun-addr">(지번) ' + place.address_name + '</span>'
                        : '<span>' + place.address_name + '</span>';
                    el.innerHTML = '<div class="info"><h5>' + place.place_name + '</h5>' + addrHtml + '</div>';
                    el.onclick = (function(p) {
                        return function() {
                            setLocation(p.place_name, p.address_name, p.y, p.x);
                            closePlaceSearch();
                        };
                    })(place);
                    list.appendChild(el);
                });
            } else {
                showBatonToast('검색 결과가 없습니다.');
            }
        });
    }
	</script>
</body>
</html>
