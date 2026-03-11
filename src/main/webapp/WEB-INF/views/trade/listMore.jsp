<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:forEach var="item" items="${tradeList}">
    <div class="trade-card tl-product-card" onclick="location.href='${pageContext.request.contextPath}/trade/article?productIdx=${item.productIdx}'">
        <div class="card-image-box tl-card-img ${empty item.imgUrl ? 'no-image' : ''}">
            <c:choose>
                <c:when test="${not empty item.imgUrl}">
                    <img src="${item.imgUrl}" alt="${item.title}" loading="lazy">
                </c:when>
                <c:otherwise>
                    <i class="ri-camera-off-line placeholder-icon"></i>
                </c:otherwise>
            </c:choose>
            
            <div class="badge-group">
                <c:choose>
                    <c:when test="${item.productStatus == '새상품'}">
                        <span class="badge badge-new">새상품</span>
                    </c:when>
                    <c:when test="${item.productStatus == '고장/파손'}">
                        <span class="badge badge-broken">파손</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge badge-used">${item.productStatus}</span>
                    </c:otherwise>
                </c:choose>
                <c:choose>
                    <c:when test="${item.tradeStatus == '판매완료'}">
                        <span class="badge badge-sold">판매완료</span>
                    </c:when>
                    <c:when test="${item.tradeStatus == '예약중'}">
                        <span class="badge badge-reserved">예약중</span>
                    </c:when>
                </c:choose>
            </div>

            <button type="button" class="wish-btn tl-wish-btn ${item.isLiked ? 'active' : ''}" 
                    onclick="tlToggleWish(event, ${item.productIdx})">
                <i class="${item.isLiked ? 'ri-heart-3-fill' : 'ri-heart-3-line'}"></i>
            </button>
        </div>

        <div class="card-info tl-card-body">
            <h3 class="card-title tl-card-title">${item.title}</h3>
            
            <div class="card-price tl-card-price ${item.price == 0 ? 'free' : ''}">
                <c:choose>
                    <c:when test="${item.price == 0}">나눔</c:when>
                    <c:otherwise><fmt:formatNumber value="${item.price}" pattern="#,###"/>원</c:otherwise>
                </c:choose>
            </div>

            <div class="card-details">
                <div class="detail-item"><i class="ri-map-pin-2-line"></i> 
                    ${not empty item.tradePlace ? item.tradePlace : '택배 거래'}
                </div>
                <div class="detail-item"><i class="ri-time-line"></i> 
                    <span class="time-ago">${item.lastUpDate}</span>
                </div>
            </div>

            <div class="card-footer">
                <div class="host-info">
                    <div class="host-avatar"><i class="ri-user-smile-line"></i></div>
                    <span class="host-name">동네이웃</span>
                </div>
                <div class="interaction-info tl-card-stats">
                    <span><i class="ri-eye-line"></i> ${item.hitCount}</span>
                    <span><i class="ri-chat-3-line"></i> ${item.chatCount}</span>
                    <span><i class="ri-heart-3-line wish-icon"></i> ${item.likeCount}</span>
                </div>
            </div>
        </div>
    </div>
</c:forEach>
