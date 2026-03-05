<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>BATON | 거래 후기</title>
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/main/main.css">
<style>
    .review-container { max-width: 800px; margin: 130px auto; padding: 0 20px; }
    .review-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; flex-wrap: wrap; gap: 15px; }
    
    .header-controls { display: flex; align-items: center; gap: 15px; }
    .review-tabs { display: flex; gap: 10px; }
    .review-tab { 
        padding: 10px 20px; border-radius: 20px; font-weight: 600; cursor: pointer; 
        background: var(--baton-white); color: var(--baton-muted); box-shadow: var(--shadow-soft); transition: 0.3s; font-size: 15px;
    }
    .review-tab.active { background: var(--baton-title); color: var(--baton-white); box-shadow: var(--shadow-deep); }
    
    .review-write-btn {
        background: var(--baton-blue); color: var(--baton-white); border: none; 
        padding: 10px 20px; border-radius: 20px; font-weight: 600; cursor: pointer; 
        box-shadow: var(--baton-blue-glow); transition: 0.3s; font-size: 15px;
    }

    .review-card {
        background: var(--baton-white); padding: 25px 30px; border-radius: 32px;
        box-shadow: var(--shadow-soft); margin-bottom: 20px; border: 1px solid rgba(0,0,0,0.03);
        position: relative; cursor: pointer; transition: 0.3s;
    }
    .review-card:hover { transform: translateY(-4px); box-shadow: var(--shadow-deep); }
    
    .card-top { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 15px; }
    .profile-area { display: flex; align-items: center; gap: 12px; }
    .profile-img-box { width: 45px; height: 45px; border-radius: 50%; background: #E5E8EB; display: flex; align-items: center; justify-content: center; color: #8B95A1; font-size: 20px; }
    .profile-img { width: 45px; height: 45px; border-radius: 50%; object-fit: cover; }
    .profile-info { display: flex; flex-direction: column; gap: 4px; }
    .profile-info .nickname { font-weight: 700; font-size: 16px; color: var(--baton-title); }
    .profile-info .meta { font-size: 13px; color: var(--baton-muted); }
    
    .options-btn { background: none; border: none; color: var(--baton-muted); font-size: 24px; cursor: pointer; }
    .options-menu {
        position: absolute; right: 20px; top: 30px; background: white; border-radius: 12px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.1); display: none; flex-direction: column; z-index: 10;
        border: 1px solid #E5E8EB; width: 150px;
    }
    .options-menu button { background: none; border: none; padding: 12px 16px; text-align: left; font-size: 14px; cursor: pointer; }
    .options-menu .danger { color: #FF4D4F; }

    .review-score { color: #FFB800; font-size: 16px; letter-spacing: 2px; margin-bottom: 12px; }
    .review-content { color: var(--baton-desc); line-height: 1.6; font-size: 15px; margin-bottom: 15px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }

    .modal-overlay {
        position: fixed; top: 0; left: 0; width: 100%; height: 100%; 
        background: rgba(0,0,0,0.5); z-index: 999; display: none; align-items: center; justify-content: center;
        backdrop-filter: blur(4px);
    }
    .modal-content {
        background: var(--baton-white); padding: 40px; border-radius: 32px; 
        width: 450px; max-height: 85vh; overflow-y: auto; box-shadow: var(--shadow-deep);
        margin-top: 80px; position: relative;
    }
    .close-modal-btn { position: absolute; right: 25px; top: 25px; background: none; border: none; font-size: 24px; cursor: pointer; color: var(--baton-muted); }

    .form-group { margin-bottom: 20px; }
    .form-group label { display: block; font-weight: 600; margin-bottom: 8px; color: var(--baton-desc); font-size: 14px; }
    .modal-select, .modal-textarea {
        width: 100%; padding: 14px; border: 1px solid #E5E8EB; border-radius: 16px; 
        font-family: 'Pretendard'; font-size: 15px; outline: none; box-sizing: border-box;
    }
    .modal-textarea { height: 100px; resize: none; }

    .tag-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
    .tag-checkbox-label {
        display: flex; align-items: center; gap: 8px; padding: 10px;
        background: #F9FAFB; border-radius: 12px; cursor: pointer; font-size: 14px;
    }
    .btn-submit { background: var(--baton-blue); border: none; padding: 16px; border-radius: 16px; font-weight: 700; color: white; cursor: pointer; width: 100%; margin-top: 10px; font-size: 16px; }
</style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <div class="review-container reveal">
        <div class="review-header">
            <h2 class="section-display-title">따뜻한 거래 후기 <span style="color: var(--baton-blue);">${empty reviewCount ? '0' : reviewCount}개</span></h2>
            <div class="header-controls">
                <div class="review-tabs">
                    <div class="review-tab ${empty param.type or param.type == 'ALL' ? 'active' : ''}" onclick="location.href='?type=ALL'">전체</div>
                    <div class="review-tab ${param.type == 'BUYER' ? 'active' : ''}" onclick="location.href='?type=BUYER'">구매자</div>
                    <div class="review-tab ${param.type == 'SELLER' ? 'active' : ''}" onclick="location.href='?type=SELLER'">판매자</div>
                    <sec:authorize access="isAuthenticated()">
                        <div class="review-tab ${param.type == 'ME' ? 'active' : ''}" onclick="location.href='?type=ME'">내 후기</div>
                    </sec:authorize>
                </div>
                <sec:authorize access="isAuthenticated()">
                    <button class="review-write-btn" onclick="openWriteModal()">후기 작성하기</button>
                </sec:authorize>
            </div>     
        </div>

        <div id="review-list-area">
            <c:forEach var="review" items="${reviewList}">
                <div class="review-card" id="review-card-${review.reviewIdx}" onclick="openDetailModal('${review.writerNickname}', '${review.productTitle}', '${review.score}', '${review.content}', '${review.reviewTags}')">
                    <div class="card-top">
                        <div class="profile-area">
                            <c:choose>
                                <c:when test="${empty review.profilePhoto}">
                                    <div class="profile-img-box"><i class="ri-user-3-fill"></i></div>
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/uploads/profile/${review.profilePhoto}" class="profile-img">
                                </c:otherwise>
                            </c:choose>
                            <div class="profile-info">
                                <span class="nickname">
                                    <span style="color:var(--baton-blue); font-size:12px; margin-right:4px;">[${review.saleReviewType == 'BUYER' ? '구매자' : '판매자'}]</span>
                                    ${review.writerNickname}
                                </span>
                                <span class="meta">${review.writerAddr} · ${review.timeAgo}</span>
                            </div>
                        </div>
                        
                        <c:if test="${not empty sessionUserIdx and review.userIdx == sessionUserIdx}">
                            <div style="position: relative;">
                                <button class="options-btn" onclick="toggleMenu(event, ${review.reviewIdx})"><i class="ri-more-2-fill"></i></button>
                                <div class="options-menu" id="opt-menu-${review.reviewIdx}">
                                    <button onclick="hideReview(event, ${review.reviewIdx})">후기 숨기기</button>
                                    <button class="danger" onclick="deleteReview(event, ${review.reviewIdx})">삭제</button>
                                </div>
                            </div>
                        </c:if>
                    </div>

                    <div class="review-score">
                        <c:forEach begin="1" end="${review.score}">★</c:forEach>
                    </div>
                    <div class="review-content">${review.content}</div>
                </div>
            </c:forEach>
        </div>
    </div>

    <div class="modal-overlay" id="writeModal">
        <div class="modal-content">
            <button class="close-modal-btn" onclick="closeWriteModal()"><i class="ri-close-line"></i></button>
            <h3 style="margin-top:0; margin-bottom:25px; font-weight:800;">따뜻한 거래 후기 남기기</h3>
            
            <div class="form-group">
                <label>거래 유형</label>
                <select id="modalType" class="modal-select">
                    <option value="BUYER">구매자 후기</option>
                    <option value="SELLER">판매자 후기</option>
                </select>
            </div>
            <div class="form-group">
                <label>별점</label>
                <select id="modalScore" class="modal-select">
                    <option value="5">★★★★★ (최고예요!)</option>
                    <option value="4">★★★★☆ (좋아요!)</option>
                    <option value="3">★★★☆☆ (보통이에요)</option>
                    <option value="2">★★☆☆☆ (그저 그래요)</option>
                    <option value="1">★☆☆☆☆ (아쉬워요!)</option>
                </select>
            </div>
            <div class="form-group">
                <label>좋았던 점 (중복 선택 가능)</label>
                <div class="tag-grid">
                    <label class="tag-checkbox-label"><input type="checkbox" value="친절해요"> 친절해요</label>
                    <label class="tag-checkbox-label"><input type="checkbox" value="응답이 빨라요"> 응답이 빨라요</label>
                    <label class="tag-checkbox-label"><input type="checkbox" value="시간을 잘 지켜요"> 시간을 잘 지켜요</label>
                    <label class="tag-checkbox-label"><input type="checkbox" value="물건 상태가 좋아요"> 물건 상태가 좋아요</label>
                </div>
            </div>
            <div class="form-group">
                <label>상세 내용</label>
                <textarea id="modalContent" class="modal-textarea" placeholder="거래 경험을 공유해주세요."></textarea>
            </div>
            <button class="btn-submit" onclick="submitReview()">등록하기</button>
        </div>
    </div>

    <div id="detailModal" class="modal-overlay" onclick="closeDetailModal()">
        <div class="modal-content" onclick="event.stopPropagation()">
            <button class="close-modal-btn" onclick="closeDetailModal()"><i class="ri-close-line"></i></button>
            <div style="margin-bottom: 20px;">
                <div style="font-size: 18px; font-weight: 700; color: var(--baton-title);"><span id="detailNickname" style="color:var(--baton-blue);"></span> 님이 보낸 따뜻한 후기가 도착했어요.</div>
                <div style="font-size: 15px; color: var(--baton-muted); margin-top:5px; padding-bottom: 15px; border-bottom: 1px solid #E5E8EB;"><span id="detailNicknameSub"></span> 님과 <span id="detailProduct" style="font-weight:600;"></span> 거래했어요.</div>
            </div>
            <ul style="list-style: none; padding: 0; margin: 0 0 20px 0; display: flex; flex-direction: column; gap: 10px;" id="detailTagsList"></ul>
            <div style="font-size: 16px; color: var(--baton-desc); line-height: 1.7; background: #F9FAFB; padding: 20px; border-radius: 20px;" id="detailContentText"></div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script>
        $(function() {
            const header = $("meta[name='_csrf_header']").attr("content");
            const token = $("meta[name='_csrf']").attr("content");
            $.ajaxSetup({ beforeSend: function(xhr) { if(header && token) xhr.setRequestHeader(header, token); } });

            $(document).on('click', function(e) {
                if (!$(e.target).closest('.options-btn').length) { $('.options-menu').hide(); }
            });
        });

        function openDetailModal(nickname, productTitle, score, content, tags) {
            $('#detailNickname').text(nickname);
            $('#detailNicknameSub').text(nickname);
            $('#detailProduct').text(productTitle);
            
            $('#detailTagsList').empty();
            if(tags && tags !== 'null' && tags.trim() !== '') {
                const tagArray = tags.split('|');
                tagArray.forEach(function(tag) {
                	$('#detailTagsList').append('<li style="justify-content: center;"><i class="ri-chat-smile-3-line"></i> ' + tag + '</li>');                });
            }

            if (content && content.trim() !== '' && content !== 'null') {
                $('#detailContentText').html(content.replace(/\n/g, "<br>")).show();
                $('#detailTagsList').css('align-items', 'flex-start');
            } else {
                $('#detailContentText').hide();
                $('#detailTagsList').css('align-items', 'flex-start');
            }
            
            document.getElementById('detailModal').style.display = 'flex';
        }
        
        function closeDetailModal() { $('#detailModal').hide(); }

        function openWriteModal() { $('#writeModal').css('display', 'flex'); }
        function closeWriteModal() { $('#writeModal').hide(); }
       
        function toggleMenu(event, idx) { 
            event.stopPropagation(); 
            $('.options-menu').not('#opt-menu-'+idx).hide(); 
            $('#opt-menu-'+idx).toggle(); 
        }

        function submitReview() {
            let checkedTags = [];
            $('.tag-checkbox-label input:checked').each(function() { checkedTags.push($(this).val()); });

            const requestData = {
                saleReviewType: $('#modalType').val(),
                productIdx: 1, 
                score: parseInt($('#modalScore').val()),
                content: $('#modalContent').val(),
                reviewTags: checkedTags.join('|')
            };

            $.ajax({
                url: "${pageContext.request.contextPath}/review/write",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify(requestData),
                success: function(response) {
                    if(response.status === 'success') location.reload();
                    else alert("실패: " + response.message);
                },
                error: function() { alert("통신 에러가 발생했습니다."); }
            });
        }

        function hideReview(event, idx) {
            event.stopPropagation();
            if(!confirm("이 후기를 영구적으로 숨기시겠습니까?")) return;
            $.ajax({
                url: "${pageContext.request.contextPath}/review/hide",
                type: "POST",
                data: { reviewIdx: idx },
                success: function(res) {
                    if(res.status === 'success') location.reload();
                }
            });
        }

        function deleteReview(event, idx) {
            event.stopPropagation();
            if(!confirm("정말로 이 후기를 삭제하시겠습니까?")) return;
            $.ajax({
                url: "${pageContext.request.contextPath}/review/delete",
                type: "POST",
                data: { reviewIdx: idx },
                success: function(res) {
                    if(res.status === 'success') location.reload();
                }
            });
        }
    </script>
</body>
</html>