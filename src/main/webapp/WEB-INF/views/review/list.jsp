<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>거래 후기 보기 | BATON</title>
    <jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
    <link href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/main/main.css?v=final">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/mypage/mypage_left.css?v=final">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/mypage/mypage_main.css?v=final">
    
    <style>
        body, #baton-layout-container, .mp-main-wrapper {
            background-color: var(--baton-bg) !important;
        }

        .review-list-wrap { 
            background: #fff; 
            border-radius: 16px; 
            padding: 40px; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.03); 
            font-family: 'Pretendard', sans-serif; 
            max-width: 850px;       
            margin: 40px auto 80px; 
        }
        
        .rl-title { 
            font-size: 1.4rem; 
            font-weight: 800; 
            color: #1A1A1A; 
            margin-bottom: 25px; 
            border-bottom: 2px solid #1A1A1A; 
            padding-bottom: 15px; 
        }

        .inner-tabs { 
            display: flex; 
            gap: 10px; 
            margin-bottom: 40px; 
            border-bottom: none !important; 
        }
        .inner-tab { 
            padding: 12px 24px !important; 
            font-size: 1rem; 
            font-weight: 600; 
            color: #8C8C8C; 
            background: #F4F6F8 !important; 
            border: none !important; 
            border-radius: 8px; 
            cursor: pointer; 
            transition: all 0.2s ease; 
        }
        .inner-tab::after {
            display: none !important; 
        }
        .inner-tab:hover { 
            background: #EAECEF !important; 
            color: #555; 
        }

        .inner-tab.active { 
            background: #00B98D !important; 
            color: #fff !important; 
            font-weight: 700;
        }
        
        .tab-content { display: none; }
        .tab-content.active { display: block; animation: fadeIn 0.3s; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

        .review-item { border-bottom: 1px solid #F0F0F0; padding: 25px 0; }
        .review-item:first-child { padding-top: 0; }
        .review-item:last-child { border-bottom: none; }
        .ri-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 15px; }
        
        .ri-user { display: flex; align-items: center; }
        .ri-avatar { width: 45px; height: 45px; border-radius: 50%; background: #F5F5F5; margin-right: 15px; object-fit: cover; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; color: #CCC; }
        
        .ri-name { font-weight: 800; font-size: 1.05rem; color: #333; margin-bottom: 4px; }
        .ri-meta { font-size: 0.85rem; color: #8C8C8C; }
        
        .ri-product { font-size: 0.85rem; color: #00B98D; font-weight: 700; margin-top: 4px; }
        
        .ri-tags { display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 15px; }
        .tag-badge { background: #E6F8F3; color: #00B98D; font-size: 0.85rem; padding: 6px 12px; border-radius: 6px; font-weight: 600; border: 1px solid rgba(0, 185, 141, 0.15); }
        
        .ri-content { font-size: 1rem; color: #444; line-height: 1.6; white-space: pre-wrap; background: #FBFBFB; padding: 15px; border-radius: 8px; }
        .empty-review { text-align: center; padding: 80px 0; color: #ADB5BD; font-size: 1.1rem; font-weight: 600; }
        
        .role-badge { display: inline-block; padding: 2px 6px; border-radius: 4px; font-size: 0.75rem; font-weight: 700; margin-left: 8px; vertical-align: middle; }
        .rb-buyer { background: #E3F2FD; color: #1976D2; }
        .rb-seller { background: #FCE4EC; color: #C2185B; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<div id="baton-layout-container" class="mypage-mode">
    <jsp:include page="/WEB-INF/views/mypage/left.jsp" />

    <main class="mp-main-wrapper" id="mp-theme-root">
        <div class="mp-content-area">
            
            <div class="review-list-wrap">
                <h2 class="rl-title">거래 후기 보기</h2>

                <div class="inner-tabs">
                    <button class="inner-tab ${currentType != 'SENT' ? 'active' : ''}" onclick="switchTab('RECEIVED')">받은 거래 후기</button>
                    <button class="inner-tab ${currentType == 'SENT' ? 'active' : ''}" onclick="switchTab('SENT')">보낸 거래 후기</button>
                </div>

                <div id="tab-RECEIVED" class="tab-content ${currentType != 'SENT' ? 'active' : ''}">
                    <c:set var="hasReceived" value="false" />
                    <c:forEach var="review" items="${reviewList}">
                        <c:if test="${review.userIdx != sessionUserIdx}">
                            <c:set var="hasReceived" value="true" />
                            <div class="review-item">
                                <div class="ri-header">
                                    <div class="ri-user">
                                        <div class="ri-avatar">
                                            <c:choose>
                                                <c:when test="${not empty review.profilePhoto && review.profilePhoto != 'null'}">
                                                    <img src="${pageContext.request.contextPath}/uploads/member/${review.profilePhoto}" style="width:100%; height:100%; border-radius:50%;" onerror="this.style.display='none'; this.nextElementSibling.style.display='block';">
                                                    <i class="ri-user-smile-fill" style="display:none; color:#CCC;"></i>
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="ri-user-smile-fill"></i>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="ri-info">
                                            <div class="ri-name">
                                                ${review.writerNickname} 
                                                <span class="role-badge ${review.saleReviewType == 'BUYER' ? 'rb-buyer' : 'rb-seller'}">
                                                    ${review.saleReviewType == 'BUYER' ? '구매자' : '판매자'}
                                                </span>
                                            </div>
                                            <div class="ri-meta">${review.writerAddr} · ${review.timeAgo}</div>
                                            <div class="ri-product"><i class="ri-shopping-bag-3-fill"></i> ${review.productTitle}</div>
                                        </div>
                                    </div>
                                </div>

                                <c:if test="${not empty review.reviewTags}">
                                    <div class="ri-tags">
                                        <c:forEach var="tag" items="${fn:split(review.reviewTags, ',')}">
                                            <span class="tag-badge">${tag}</span>
                                        </c:forEach>
                                    </div>
                                </c:if>

                                <c:if test="${not empty review.content}">
                                    <div class="ri-content">${review.content}</div>
                                </c:if>
                            </div>
                        </c:if>
                    </c:forEach>
                    
                    <c:if test="${not hasReceived}">
                        <div class="empty-review">
                            <i class="ri-chat-1-line" style="font-size: 3.5rem; display: block; margin-bottom: 15px; color: #DEE2E6;"></i>
                            아직 다른 분이 남겨주신 후기가 없습니다.
                        </div>
                    </c:if>
                </div>

                <div id="tab-SENT" class="tab-content ${currentType == 'SENT' ? 'active' : ''}">
                    <c:set var="hasSent" value="false" />
                    <c:forEach var="review" items="${reviewList}">
                        <c:if test="${review.userIdx == sessionUserIdx}">
                            <c:set var="hasSent" value="true" />
                            <div class="review-item">
                                <div class="ri-header">
                                    <div class="ri-user">
                                        <div class="ri-info" style="margin-left: 0;">
                                            <div class="ri-meta">${review.timeAgo} 작성</div>
                                            <div class="ri-product" style="color: #333;"><i class="ri-shopping-bag-3-line"></i> ${review.productTitle}</div>
                                        </div>
                                    </div>
                                    <div>
                                        <button type="button" onclick="deleteReview(${review.reviewIdx})" style="background: none; border: 1px solid #CCC; padding: 4px 10px; border-radius: 4px; font-size: 0.8rem; color: #888; cursor: pointer;">삭제</button>
                                    </div>
                                </div>

                                <c:if test="${not empty review.reviewTags}">
                                    <div class="ri-tags">
                                        <c:forEach var="tag" items="${fn:split(review.reviewTags, ',')}">
                                            <span class="tag-badge" style="background:#F1F3F5; color:#495057; border-color:#E9ECEF;">${tag}</span>
                                        </c:forEach>
                                    </div>
                                </c:if>

                                <c:if test="${not empty review.content}">
                                    <div class="ri-content">${review.content}</div>
                                </c:if>
                            </div>
                        </c:if>
                    </c:forEach>
                    
                    <c:if test="${not hasSent}">
                        <div class="empty-review">
                            <i class="ri-edit-2-line" style="font-size: 3.5rem; display: block; margin-bottom: 15px; color: #DEE2E6;"></i>
                            작성하신 거래 후기가 없습니다.
                        </div>
                    </c:if>
                </div>

            </div>
            
        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script>
    const CONTEXT_PATH = '${pageContext.request.contextPath}';
</script>
<script src="${pageContext.request.contextPath}/dist/js/review/review_list.js"></script>

</body>
</html>