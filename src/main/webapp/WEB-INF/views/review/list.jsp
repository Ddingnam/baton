<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>BATON | 거래 후기</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/main.css">
<style>
    .review-container { max-width: 800px; margin: 50px auto; padding: 0 20px; }
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
</style>
</head>
<body>

    <div class="review-container reveal">
        <div class="review-header">
            <h2 class="section-display-title">따뜻한 거래 후기</h2>
            
            <div class="review-tabs">
                <div class="review-tab active" onclick="location.href='?type=BUYER'">구매자 후기</div>
                <div class="review-tab" onclick="location.href='?type=SELLER'">판매자 후기</div>
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

</body>
</html>