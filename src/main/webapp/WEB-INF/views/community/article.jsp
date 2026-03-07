<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${dto.subject} | BATON</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/community/community-article.css">
<link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoMapKey}&libraries=services"></script>
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<div class="article-layout">
    <div class="article-container">
        <div class="article-header">
            <div class="category-badge">${dto.category}</div>
            <h1 class="article-subject">${dto.subject}</h1>
            
            <div class="profile-box">
                <div class="profile-img">
                    <img src="${pageContext.request.contextPath}/dist/images/avatar.png" alt="프로필">
                </div>
                <div class="profile-info">
                    <div class="nickname">${dto.writerNickname}</div>
                    <div class="meta">
                        <span>${dto.regDate}</span>
                        <span class="dot">·</span>
                        <span>조회 ${dto.hitCount}</span>
                    </div>
                </div>
                
                <c:if test="${sessionScope.member.userIdx == dto.memberIdx}">
                    <div class="more-btn-wrapper">
                        <button type="button" class="btn-more" onclick="toggleMenu()">
                            <i class="ri-more-fill"></i>
                        </button>
                        <div class="dropdown-menu" id="dropdownMenu">
                            <button type="button" onclick="location.href='${pageContext.request.contextPath}/community/update?id=${dto.id}'">수정</button>
                            <button type="button" class="danger" onclick="deleteArticle('${dto.id}')">삭제</button>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>

        <div class="divider"></div>

        <div class="article-body">
            <c:if test="${not empty dto.pollTitle}">
                <div class="poll-card" id="pollSection" data-poll-id="${dto.id}">
                    <div class="poll-header">
                        <span class="poll-badge">투표</span>
                        <h3 class="poll-title">${dto.pollTitle}</h3>
                        <div class="poll-meta">
                            <span id="pollEndDate" data-date="${dto.pollEndDate}"></span>
                            <span class="dot">·</span>
                            <span>${dto.pollAnonymous ? '익명' : '공개'}</span>
                            <span class="dot">·</span>
                            <span>${dto.pollMultiple ? '복수선택' : '단일선택'}</span>
                        </div>
                    </div>
                    <div class="poll-content" id="pollOptionsBox">
                        <div class="loading-spinner"><i class="ri-loader-4-line ri-spin"></i> 투표 로딩중...</div>
                    </div>
                    <div class="poll-footer">
                        <button type="button" class="btn-vote-submit" id="btnVoteSubmit" style="display:none;">투표하기</button>
                        <span class="total-votes" id="totalVotesDisplay">0명 참여</span>
                    </div>
                </div>
            </c:if>

            <div class="content-text">
                ${dto.content}
            </div>

            <c:if test="${not empty dto.imageFiles}">
                <div class="image-grid">
                    <c:forEach var="img" items="${dto.imageFiles}">
                        <div class="img-wrapper">
                            <img src="${pageContext.request.contextPath}/uploads/community/${img}" alt="첨부 이미지" onclick="window.open(this.src)">
                        </div>
                    </c:forEach>
                </div>
            </c:if>

            <c:if test="${not empty dto.latitude}">
                <div class="map-card">
                    <div class="map-header">
                        <i class="ri-map-pin-fill"></i>
                        <div class="place-info">
                            <strong>${dto.placeName}</strong>
                            <span>${dto.address}</span>
                        </div>
                    </div>
                    <div id="map" class="map-view" data-lat="${dto.latitude}" data-lng="${dto.longitude}"></div>
                </div>
            </c:if>

            <c:if test="${not empty dto.tags}">
                <div class="tag-list">
                    <c:forEach var="tag" items="${dto.tags}">
                        <span class="tag-chip">#${tag}</span>
                    </c:forEach>
                </div>
            </c:if>
        </div>

        <div class="article-actions">
            <button type="button" class="action-btn ${isUserLiked ? 'active' : ''}" id="btnLike" onclick="toggleLike('${dto.id}')">
                <i class="${isUserLiked ? 'ri-heart-3-fill' : 'ri-heart-3-line'}"></i>
                <span id="likeCount">${dto.likeCount}</span>
                <span>좋아요</span>
            </button>
            <button type="button" class="action-btn ${isUserScraped ? 'active' : ''}" id="btnScrap" onclick="toggleScrap('${dto.id}')">
                <i class="${isUserScraped ? 'ri-bookmark-fill' : 'ri-bookmark-line'}"></i>
                <span>스크랩</span>
            </button>
            <button type="button" class="action-btn" onclick="location.href='${pageContext.request.contextPath}/community/list?${query}'">
                <i class="ri-list-check-2"></i> 목록
            </button>
        </div>

        <div class="divider thick"></div>

        <div class="reply-section">
            <h3 class="reply-title">댓글 <span class="highlight" id="replyCount">0</span></h3>
            
            <div class="reply-input-box">
                <textarea id="replyContent" placeholder="이웃에게 따뜻한 댓글을 남겨주세요." class="input-reply"></textarea>
                <div class="input-bottom">
                    <button type="button" class="btn-reply-submit" onclick="sendReply('${dto.id}')">등록</button>
                </div>
            </div>

            <div id="replyList" class="reply-list"></div>
        </div>
    </div>
</div>

<div class="toast-container" id="toastContainer"></div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script> 
    $(function(){
        var mapContainer = document.getElementById('map'); 
        if(mapContainer && mapContainer.getAttribute('data-lat')) {
            var lat = mapContainer.getAttribute('data-lat');
            var lng = mapContainer.getAttribute('data-lng');
            
            var mapOption = { 
                center: new kakao.maps.LatLng(lat, lng), 
                level: 3 
            };
            var map = new kakao.maps.Map(mapContainer, mapOption); 
            var marker = new kakao.maps.Marker({ position: new kakao.maps.LatLng(lat, lng) });
            marker.setMap(map);
        }
    });
    

    const contextPath = "${pageContext.request.contextPath}";
    const communityId = "${dto.id}";
    const currentMemberIdx = "${sessionScope.member.userIdx}";
</script>
<script src="${pageContext.request.contextPath}/dist/js/community/community-article.js"></script>

</body>
</html>