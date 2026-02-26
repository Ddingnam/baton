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
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/main.css">
<style>
    .review-container { max-width: 800px; margin: 130px auto; padding: 0 20px; }
    .review-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }

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
    .review-write-btn:hover { background: #1b64da; transform: translateY(-2px); }

    .review-card {
        background: var(--baton-white); padding: 25px 30px; border-radius: 32px;
        box-shadow: var(--shadow-soft); margin-bottom: 20px; transition: 0.3s; border: 1px solid rgba(0,0,0,0.03);
        cursor: pointer; position: relative;
    }
    .review-card:hover { transform: translateY(-4px); box-shadow: var(--shadow-deep); border-color: rgba(49, 130, 246, 0.15); }
    
    .card-top { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 15px; }
    .profile-area { display: flex; align-items: center; gap: 12px; }
    .profile-img { width: 45px; height: 45px; border-radius: 50%; background: #E5E8EB; object-fit: cover; }
    .profile-info { display: flex; flex-direction: column; gap: 4px; }
    .profile-info .nickname { font-weight: 700; font-size: 16px; color: var(--baton-title); }
    .profile-info .meta { font-size: 13px; color: var(--baton-muted); }
    
    .review-score { color: #FFB800; font-size: 16px; letter-spacing: 2px; margin-bottom: 15px; }
    .review-content-preview { color: var(--baton-desc); line-height: 1.6; font-size: 15px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }

    .options-btn { background: none; border: none; color: var(--baton-muted); font-size: 24px; cursor: pointer; padding: 0 5px; }
    .options-menu {
        position: absolute; right: 30px; top: 60px; background: white; border-radius: 12px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.1); display: none; flex-direction: column; overflow: hidden; z-index: 10;
        border: 1px solid #E5E8EB; width: 150px;
    }
    .options-menu button {
        background: none; border: none; padding: 12px 16px; text-align: left; font-size: 14px;
        cursor: pointer; color: var(--baton-title); font-family: 'Pretendard'; transition: 0.2s;
    }
    .options-menu button:hover { background: #F2F4F6; }
    .options-menu .danger { color: #FF4D4F; }

    .modal-overlay {
        position: fixed; top: 0; left: 0; width: 100%; height: 100%; 
        background: rgba(0,0,0,0.5); z-index: 1000; display: none; align-items: center; justify-content: center;
        backdrop-filter: blur(4px);
    }
    .modal-content {
        background: var(--baton-white); padding: 40px; border-radius: 32px; 
        width: 450px; max-height: 85vh; overflow-y: auto; box-shadow: var(--shadow-deep);
        margin-top: 80px;
    }
    .modal-title { margin-top: 0; margin-bottom: 25px; color: var(--baton-title); font-size: 22px; }

    .tag-checkbox-group { display: flex; flex-direction: column; gap: 10px; margin-bottom: 20px; }
    .tag-checkbox-label {
        display: flex; align-items: center; gap: 10px; padding: 12px 16px; 
        border: 1px solid #E5E8EB; border-radius: 16px; cursor: pointer; transition: 0.2s;
        font-size: 15px; color: var(--baton-desc); font-weight: 500;
    }
    .tag-checkbox-label:hover { background: #F9FAFB; }
    .tag-checkbox-label input:checked + span { color: var(--baton-blue); font-weight: 700; }
    .tag-checkbox-label.checked { border-color: var(--baton-blue); background: #F0F6FF; }

    .detail-greeting { font-size: 18px; font-weight: 700; color: var(--baton-title); margin-bottom: 8px; }
    .detail-sub { font-size: 15px; color: var(--baton-muted); margin-bottom: 25px; padding-bottom: 20px; border-bottom: 1px solid #E5E8EB; }
    .detail-tags-list { list-style: none; padding: 0; margin: 0 0 20px 0; display: flex; flex-direction: column; gap: 10px; }
    .detail-tags-list li { font-size: 15px; color: var(--baton-blue); font-weight: 600; display: flex; align-items: center; gap: 8px; }
    .detail-text { font-size: 16px; color: var(--baton-desc); line-height: 1.7; background: #F9FAFB; padding: 20px; border-radius: 20px; }

    .form-group { margin-bottom: 20px; }
    .form-group label { display: block; font-weight: 600; margin-bottom: 8px; color: var(--baton-desc); font-size: 14px; }
    .form-group select, .form-group textarea {
        width: 100%; padding: 14px; border: 1px solid #E5E8EB; border-radius: 16px; 
        font-family: 'Pretendard'; font-size: 15px; outline: none; box-sizing: border-box; resize: vertical;
    }
    .form-group select:focus, .form-group textarea:focus { border-color: var(--baton-blue); }
    .modal-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 30px; }
    .btn-cancel { background: var(--baton-surface); border: none; padding: 14px 24px; border-radius: 16px; font-weight: 600; color: var(--baton-muted); cursor: pointer; }
    .btn-submit { background: var(--baton-blue); border: none; padding: 14px 24px; border-radius: 16px; font-weight: 600; color: var(--baton-white); cursor: pointer; }
</style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <div class="review-container reveal">
		<div class="review-header">
            <h2 class="section-display-title" style="font-size: 24px; white-space: nowrap;">
                따뜻한 거래 후기 <span style="color: var(--baton-blue); font-size: 22px; font-weight: 800;">${empty reviewCount ? '0' : reviewCount}개</span>
            </h2>
            
            <div class="header-controls">
                <div class="review-tabs">
                    <div class="review-tab ${empty currentType || currentType == 'ALL' ? 'active' : ''}" onclick="location.href='?type=ALL'" style="padding: 10px 16px; font-size: 14px;">전체 후기</div>
                    <div class="review-tab ${currentType == 'BUYER' ? 'active' : ''}" onclick="location.href='?type=BUYER'" style="padding: 10px 16px; font-size: 14px;">구매자 후기</div>
                    <div class="review-tab ${currentType == 'SELLER' ? 'active' : ''}" onclick="location.href='?type=SELLER'" style="padding: 10px 16px; font-size: 14px;">판매자 후기</div>
                    <sec:authorize access="isAuthenticated()">
                        <div class="review-tab ${currentType == 'ME' ? 'active' : ''}" onclick="location.href='?type=ME'" style="padding: 10px 16px; font-size: 14px;">내가 보낸 후기</div>
                    </sec:authorize>
                </div>
                
                <sec:authorize access="isAuthenticated()">
                    <button class="review-write-btn" onclick="openWriteModal()">후기 작성하기</button>
                </sec:authorize>
            </div>     
        </div>

        <c:if test="${empty reviewList}">
            <div class="review-card" style="text-align: center; color: var(--baton-muted); padding: 50px;">
                아직 작성된 거래 후기가 없습니다. 첫 번째 따뜻한 후기를 남겨보세요!
            </div>
        </c:if>

        <c:forEach var="review" items="${reviewList}">
            <div class="review-card" onclick="openDetailModal('${review.writerNickname}', '${review.productTitle}', '${review.score}', '${review.content}', '${review.reviewTags}')">                
                <div class="card-top">                
                    <div class="profile-area">
                        <c:choose>
                            <c:when test="${empty review.profilePhoto}">
                                <div class="profile-img" style="display:flex; align-items:center; justify-content:center; background:#E5E8EB; color:#8B95A1; font-size:24px;">
                                    <i class="ri-user-3-fill"></i>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}${review.profilePhoto}" class="profile-img" alt="프로필">
                            </c:otherwise>
                        </c:choose>
                        
                        <div class="profile-info">
                            <span class="nickname">
                                <span style="color:var(--baton-blue); font-size:13px; margin-right:4px;">[${review.saleReviewType == 'BUYER' ? '구매자' : '판매자'}]</span>
                                ${review.writerNickname}
                            </span>
                            <span class="meta">${review.writerAddr} · ${review.timeAgo}</span>
                        </div>
                    </div>
                    
                    <div style="position: relative;">
                        <button class="options-btn" onclick="toggleOptionsMenu(event, ${review.reviewIdx})"><i class="ri-more-2-fill"></i></button>
                        <div class="options-menu" id="options-${review.reviewIdx}">
                            <button onclick="hideReview(event, ${review.reviewIdx})">이 후기 숨기기</button>
                            <c:if test="${sessionScope.member.userIdx == review.userIdx}">
                                <button class="danger" onclick="deleteReview(event, ${review.reviewIdx})">거래 삭제</button>
                            </c:if>
                            <button onclick="closeMenu(event, ${review.reviewIdx})">닫기</button>
                        </div>
                    </div>
                </div>

                <div class="review-score">
                    <c:forEach begin="1" end="${review.score}">★</c:forEach>
                </div>
                
                <div class="review-content-preview">
                    ${review.content}
                </div>
            </div>
        </c:forEach>
    </div>

    <div id="writeModal" class="modal-overlay">
        <div class="modal-content">
            <h3 class="modal-title">따뜻한 거래 후기 남기기</h3>
            
            <div class="form-group">
                <label>어떤 포지션이셨나요?</label>
                <select id="modalType">
                    <option value="BUYER">구매자로서 후기 남기기</option>
                    <option value="SELLER">판매자로서 후기 남기기</option>
                </select>
            </div>
            
            <div class="form-group">
                <label>거래 평점</label>
                <select id="modalScore">
                    <option value="5">⭐⭐⭐⭐⭐ (5점 - 최고예요!)</option>
                    <option value="4">⭐⭐⭐⭐ (4점 - 좋아요)</option>
                    <option value="3">⭐⭐⭐ (3점 - 보통이에요)</option>
                    <option value="2">⭐⭐ (2점 - 아쉬워요)</option>
                    <option value="1">⭐ (1점 - 별로예요)</option>
                </select>
            </div>
            
            <div class="form-group">
                <label>어떤 점이 좋았나요? (다중 선택 가능)</label>
                <div class="tag-checkbox-group">
                    <label class="tag-checkbox-label"><input type="checkbox" value="거래약속을 잘 지켜요"> <span>+ 거래약속을 잘 지켜요</span></label>
                    <label class="tag-checkbox-label"><input type="checkbox" value="물품 상태가 설명한 것과 같아요"> <span>+ 물품 상태가 설명한 것과 같아요</span></label>
                    <label class="tag-checkbox-label"><input type="checkbox" value="친절하고 매너가 좋아요"> <span>+ 친절하고 매너가 좋아요</span></label>
                    <label class="tag-checkbox-label"><input type="checkbox" value="좋은 물품을 저렴하게 판매해요"> <span>+ 좋은 물품을 저렴하게 판매해요</span></label>
                    <label class="tag-checkbox-label"><input type="checkbox" value="응답이 빨라요"> <span>+ 응답이 빨라요</span></label>
                </div>
            </div>
            
            <div class="form-group">
                <label>상세 후기 (선택)</label>
                <textarea id="modalContent" rows="3" placeholder="추가로 남기고 싶은 말씀이 있다면 적어주세요."></textarea>
            </div>
            
            <div class="modal-actions">
                <button class="btn-cancel" onclick="closeWriteModal()">취소</button>
                <button class="btn-submit" onclick="submitReview()">등록하기</button>
            </div>
        </div>
    </div>

    <div id="detailModal" class="modal-overlay" onclick="closeDetailModal()">
        <div class="modal-content" onclick="event.stopPropagation()">
            <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                <div>
                    <div class="detail-greeting"><span id="detailNickname" style="color:var(--baton-blue);"></span> 님이 보낸 따뜻한 후기가 도착했어요.</div>
                    <div class="detail-sub"><span id="detailNicknameSub"></span> 님과 <span id="detailProduct" style="font-weight:600;"></span> 거래했어요.</div>
                </div>
                <button class="options-btn" onclick="closeDetailModal()" style="font-size: 30px;"><i class="ri-close-line"></i></button>
            </div>
            
            <ul class="detail-tags-list" id="detailTagsList">
                </ul>
            
            <div class="detail-text" id="detailContentText">
                </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/dist/js/main.js"></script>
    <script>
        [cite_start]// CSRF 토큰 설정 [cite: 68]
        const token = $("meta[name='_csrf']").attr("content");
        const header = $("meta[name='_csrf_header']").attr("content");

        if(token && header) {
            $(document).ajaxSend(function(e, xhr, options) {
                xhr.setRequestHeader(header, token);
            });
        }

        $('.tag-checkbox-label input').change(function() {
            if($(this).is(':checked')) {
                $(this).parent().addClass('checked');
            } else {
                $(this).parent().removeClass('checked');
            }
        });

        function openWriteModal() {
            document.getElementById('writeModal').style.display = 'flex';
        }
        function closeWriteModal() {
            document.getElementById('writeModal').style.display = 'none';
            document.getElementById('modalContent').value = '';
            $('.tag-checkbox-label input').prop('checked', false);
            $('.tag-checkbox-label').removeClass('checked');
        }

        function openDetailModal(nickname, productTitle, score, content, tags) {
            $('#detailNickname').text(nickname);
            $('#detailNicknameSub').text(nickname);
            $('#detailProduct').text(productTitle);
  
            $('#detailTagsList').empty();
            if(tags && tags !== 'null' && tags.trim() !== '') {
                const tagArray = tags.split('|'); 
                tagArray.forEach(function(tag) {
                    $('#detailTagsList').append('<li><i class="ri-chat-smile-3-line"></i> ' + tag + '</li>');
                });
            }

            $('#detailContentText').html(content.replace(/\n/g, "<br>"));
            
            document.getElementById('detailModal').style.display = 'flex';
        }
        function closeDetailModal() {
            document.getElementById('detailModal').style.display = 'none';
        }

        function toggleOptionsMenu(event, idx) {
            event.stopPropagation();
            $('.options-menu').hide(); 
            $('#options-' + idx).toggle();
        }
        function closeMenu(event, idx) {
            event.stopPropagation();
            $('#options-' + idx).hide();
        }
  
        $(document).click(function() {
            $('.options-menu').hide();
        });

        function hideReview(event, idx) {
            event.stopPropagation();
            if(confirm("이 후기를 목록에서 숨기시겠습니까?")) {
                alert("기능 연동 대기중입니다. (idx: " + idx + ")");
                $('#options-' + idx).hide();
            }
        }

        function deleteReview(event, idx) {
            event.stopPropagation();
            if(confirm("정말 이 거래 후기를 삭제하시겠습니까? 삭제 후 복구할 수 없습니다.")) {
                alert("기능 연동 대기중입니다. (idx: " + idx + ")");
                $('#options-' + idx).hide();
            }
        }

        function submitReview() {
            const contentVal = document.getElementById('modalContent').value;
      
            let checkedTags = [];
            $('.tag-checkbox-label input:checked').each(function() {
                checkedTags.push($(this).val());
            });

            const productInput = document.getElementById('modalProductIdx');
            const targetProductIdx = productInput ? productInput.value : 1; 

            const requestData = {
                saleReviewType: document.getElementById('modalType').value,
                productIdx: targetProductIdx, 
                score: document.getElementById('modalScore').value,
                content: contentVal,
                reviewTags: checkedTags.join('|') 
            };

            $.ajax({
                url: "${pageContext.request.contextPath}/review/write",
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify(requestData),
                success: function(response) {
                    if(response.status === 'success') {      
                        closeWriteModal();
        
                        $('.review-container').load(location.href + ' .review-container > *', function() {
                        
                        });
                        
                    } else {
                        alert("등록 실패: " + response.message);
                    }
                },
                error: function(xhr, status, error) {
                    console.error(xhr.responseText);
                    alert("서버 통신 중 에러가 발생했습니다.");
                }
            });
        }
    </script>
</body>
</html>