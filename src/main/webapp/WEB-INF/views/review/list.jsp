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
    .review-tabs { display: flex; gap: 15px; }
    .review-tab { 
        padding: 12px 24px; border-radius: 20px; font-weight: 600; cursor: pointer; 
        background: var(--baton-white); color: var(--baton-muted); box-shadow: var(--shadow-soft); transition: 0.3s;
    }
    .review-tab.active { background: var(--baton-blue); color: var(--baton-white); box-shadow: var(--shadow-deep); }
    
    .review-card {
        background: var(--baton-white); padding: 30px; border-radius: 32px;
        box-shadow: var(--shadow-soft); margin-bottom: 20px; transition: 0.3s; border: 1px solid rgba(0,0,0,0.03);
    }
    .review-card:hover { transform: translateY(-4px); box-shadow: var(--shadow-deep); }
    .review-card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
    .reviewer-info { font-weight: 600; color: var(--baton-title); font-size: 18px; }
    .review-score { color: #FFB800; font-size: 18px; letter-spacing: 2px; }
    .review-content { color: var(--baton-desc); line-height: 1.6; font-size: 16px; margin-bottom: 15px; }
    .review-date { color: var(--baton-muted); font-size: 14px; }
 
    .review-write-btn {
        background: var(--baton-blue); color: var(--baton-white); border: none; 
        padding: 12px 24px; border-radius: 20px; font-weight: 600; cursor: pointer; 
        box-shadow: var(--baton-blue-glow); transition: 0.3s;
    }
    .review-write-btn:hover { background: #1b64da; transform: translateY(-2px); }

    .modal-overlay {
        position: fixed; top: 0; left: 0; width: 100%; height: 100%; 
        background: rgba(0,0,0,0.5); z-index: 1000; display: none; align-items: center; justify-content: center;
    }
    .modal-content {
        background: var(--baton-white); padding: 40px; border-radius: 32px; 
        width: 400px; box-shadow: var(--shadow-deep);
    }
    .modal-title { margin-top: 0; margin-bottom: 25px; color: var(--baton-title); }
    .form-group { margin-bottom: 20px; }
    .form-group label { display: block; font-weight: 600; margin-bottom: 8px; color: var(--baton-desc); font-size: 14px; }
    .form-group input, .form-group select, .form-group textarea {
        width: 100%; padding: 12px; border: 1px solid #E5E8EB; border-radius: 12px; 
        font-family: 'Pretendard'; font-size: 15px; outline: none; box-sizing: border-box;
    }
    .form-group input:focus, .form-group select:focus, .form-group textarea:focus { border-color: var(--baton-blue); }
    .modal-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 30px; }
    .btn-cancel { background: var(--baton-surface); border: none; padding: 12px 24px; border-radius: 16px; font-weight: 600; color: var(--baton-muted); cursor: pointer; }
    .btn-submit { background: var(--baton-blue); border: none; padding: 12px 24px; border-radius: 16px; font-weight: 600; color: var(--baton-white); cursor: pointer; }
    .header-controls { display: flex; align-items: center; gap: 15px;
}
</style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <div class="review-container reveal">
        <div class="review-header">
            <h2 class="section-display-title">따뜻한 거래 후기</h2>
            
            <div class="header-controls">
                <div class="review-tabs">
                    <div class="review-tab ${currentType == 'BUYER' ? 'active' : ''}" onclick="location.href='?type=BUYER'">구매자 후기</div>
                    <div class="review-tab ${currentType == 'SELLER' ? 'active' : ''}" onclick="location.href='?type=SELLER'">판매자 후기</div>
                </div>
                
                <sec:authorize access="isAuthenticated()">
                    <button class="review-write-btn" onclick="openModal()">후기 작성하기</button>
                </sec:authorize>
            </div>     
        </div>

        <c:if test="${empty reviewList}">
            <div class="review-card" style="text-align: center; color: var(--baton-muted);">
                아직 작성된 거래 후기가 없습니다.
            </div>
        </c:if>

        <c:forEach var="review" items="${reviewList}">
            <div class="review-card">
                <div class="review-card-header">
                    <div class="reviewer-info">
                        <span class="tag blue-text">${review.saleReviewType == 'BUYER' ? '구매자' : '판매자'}</span>
                        ${review.writerNickname} 님의 후기
                    </div>
                    <div class="review-score">
                        <c:forEach begin="1" end="${review.score}">★</c:forEach>
                    </div>
                </div>
                <div class="review-content">
                    ${review.content}
                </div>
                
                <div class="review-date">
                    ${review.createdDate} · 연관 상품: ${review.productTitle}
                </div>
            </div>
        </c:forEach>
    </div>

    <div id="reviewModal" class="modal-overlay">
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
                <label>상품 식별번호 (테스트용)</label>
                <input type="number" id="modalProductIdx" value="1" placeholder="상품번호 입력">
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
                <label>상세 후기</label>
                <textarea id="modalContent" rows="4" placeholder="거래는 어떠셨나요? 따뜻한 후기를 남겨주세요."></textarea>
            </div>
            
            <div class="modal-actions">
                <button class="btn-cancel" onclick="closeModal()">취소</button>
                <button class="btn-submit" onclick="submitReview()">등록하기</button>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/dist/js/main.js"></script>
    <script>
   
        const token = $("meta[name='_csrf']").attr("content");
        const header = $("meta[name='_csrf_header']").attr("content");

        if(token && header) {
            $(document).ajaxSend(function(e, xhr, options) {
                xhr.setRequestHeader(header, token);
            });
        }

        function openModal() {
            document.getElementById('reviewModal').style.display = 'flex';
        }
        function closeModal() {
            document.getElementById('reviewModal').style.display = 'none';
            document.getElementById('modalContent').value = '';
        }

        function submitReview() {
            const contentVal = document.getElementById('modalContent').value;
            if(contentVal.trim() === '') {
                alert("후기 내용을 입력해 주세요.");
                return;
            }

            const requestData = {
                saleReviewType: document.getElementById('modalType').value,
                productIdx: document.getElementById('modalProductIdx').value,
                score: document.getElementById('modalScore').value,
                content: contentVal
            };

            $.ajax({
                url: "${pageContext.request.contextPath}/review/write",
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify(requestData),
                success: function(response) {
                    if(response.status === 'success') {
                        alert("따뜻한 거래 후기가 등록되었습니다!");
                        closeModal();
                        location.reload(); 
                    } else {
                        alert("등록 실패: " + response.message);
                    }
                },
                error: function(xhr, status, error) {
                    console.error(xhr.responseText);
                    alert("로그인이 만료되었거나 서버 통신 중 에러가 발생했습니다.");
                }
            });
        }
    </script>
</body>
</html>