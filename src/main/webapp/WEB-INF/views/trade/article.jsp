<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${trade.title} | BATON</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link rel="icon" href="data:;base64,iVBORw0KGgo=">
<link href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/trade/trade-article.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/report/report-modal.css">
<link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<div class="ta-wrap">

    <div class="ta-layout">

        <div class="ta-left">

            <%-- 갤러리 + 상품정보 + 설명 + 거래정보 = 하나의 흰 카드 --%>
            <div class="ta-main-card">

                <%-- 갤러리 --%>
                <div class="ta-img-main">
                    <c:choose>
                        <c:when test="${not empty imageList}">
                            <img id="mainImage" src="${pageContext.request.contextPath}${imageList[0].imgUrl}" alt="${trade.title}">
                        </c:when>
                        <c:when test="${not empty trade.imgUrl}">
                            <img id="mainImage" src="${pageContext.request.contextPath}${trade.imgUrl}" alt="${trade.title}">
                        </c:when>
                        <c:otherwise>
                            <img id="mainImage" src="${pageContext.request.contextPath}/dist/images/noimage.png" alt="이미지 없음">
                        </c:otherwise>
                    </c:choose>
                    <c:if test="${trade.tradeStatus == '판매완료' || trade.tradeStatus == '예약중' || trade.tradeStatus == '숨기기'}">
                        <div class="status-overlay">
                            <span class="status-overlay-badge">
                                <c:choose>
                                    <c:when test="${trade.tradeStatus == '판매완료'}">판매완료</c:when>
                                    <c:when test="${trade.tradeStatus == '예약중'}">예약 중</c:when>
                                    <c:when test="${trade.tradeStatus == '숨기기'}">숨겨진 상품</c:when>
                                </c:choose>
                            </span>
                        </div>
                    </c:if>
                </div>
                <c:if test="${not empty imageList && imageList.size() > 1}">
                    <div class="ta-thumbs">
                        <c:forEach var="item" items="${imageList}" varStatus="st">
                            <div class="ta-thumb ${st.index == 0 ? 'active' : ''}">
                                <img src="${pageContext.request.contextPath}${item.imgUrl}" alt="이미지 ${st.index + 1}">
                            </div>
                        </c:forEach>
                    </div>
                </c:if>

                <%-- 상품 정보 --%>
                <div class="ta-product-info">
                    <div class="ta-badges">
                        <c:if test="${not empty trade.categoryName}">
                            <span class="ta-badge ta-badge-cat">${trade.categoryName}</span>
                        </c:if>
                        <c:choose>
                            <c:when test="${trade.productStatus == '새상품'}"><span class="ta-badge ta-badge-new">새상품</span></c:when>
                            <c:when test="${trade.productStatus == '고장/파손'}"><span class="ta-badge ta-badge-broken">고장/파손</span></c:when>
                            <c:otherwise><span class="ta-badge ta-badge-used">${trade.productStatus}</span></c:otherwise>
                        </c:choose>
                        <c:choose>
                            <c:when test="${trade.tradeType == '직거래'}"><span class="ta-badge ta-badge-direct">직거래</span></c:when>
                            <c:when test="${trade.tradeType == '택배'}"><span class="ta-badge ta-badge-parcel">택배</span></c:when>
                            <c:when test="${trade.tradeType == '둘다가능'}"><span class="ta-badge ta-badge-both">직거래·택배</span></c:when>
                        </c:choose>
                    </div>
                    <h1 class="ta-title">${trade.title}</h1>
                    <p class="ta-price ${trade.price == 0 ? 'free' : ''}">
                        <c:choose>
                            <c:when test="${trade.price == 0}">나눔</c:when>
                            <c:otherwise><fmt:formatNumber value="${trade.price}" pattern="#,###"/><span class="ta-price-won">원</span></c:otherwise>
                        </c:choose>
                    </p>
                    <c:if test="${not empty tagList}">
                        <div class="ta-tags">
                            <c:forEach var="tag" items="${tagList}">
                                <span class="ta-tag">#${tag}</span>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>

                <%-- 상품 설명 --%>
                <div class="ta-inner-section">
                    <h2 class="ta-section-title">상품 설명</h2>
                    <p class="ta-desc">${trade.content}</p>
                </div>

                <%-- 거래 정보 --%>
                <div class="ta-inner-section">
                    <h2 class="ta-section-title">거래 정보</h2>
                    <div class="ta-info-grid">
                        <div class="ta-info-item">
                            <span class="ta-info-label">거래 방식</span>
                            <span class="ta-info-value">
                                <c:choose>
                                    <c:when test="${trade.tradeType == '둘다가능'}">직거래·택배</c:when>
                                    <c:when test="${trade.tradeType == '택배'}">택배</c:when>
                                    <c:when test="${trade.tradeType == '직거래'}">직거래</c:when>
                                </c:choose>
                            </span>
                        </div>
                        <div class="ta-info-item">
                            <span class="ta-info-label">판매 상태</span>
                            <span class="ta-info-value">
                                <c:choose>
                                    <c:when test="${trade.tradeStatus == '판매중'}">판매 중</c:when>
                                    <c:when test="${trade.tradeStatus == '예약중'}">예약 중</c:when>
                                    <c:when test="${trade.tradeStatus == '판매완료'}">판매 완료</c:when>
                                    <c:otherwise>${trade.tradeStatus}</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="ta-info-item">
                            <span class="ta-info-label">등록일</span>
                            <span class="ta-info-value time-ago" data-time="${trade.lastUpDate}">${trade.lastUpDate}</span>
                        </div>
                        <div class="ta-info-item">
                            <span class="ta-info-label">끌어올리기</span>
                            <span class="ta-info-value">${trade.pullCount}회</span>
                        </div>
                        <c:if test="${trade.tradeType != '택배' && not empty trade.tradePlace}">
                            <div class="ta-info-item ta-full">
                                <span class="ta-info-label">거래 희망 장소</span>
                                <span class="ta-info-value">${trade.tradePlace}</span>
                                <div id="map"></div>
                            </div>
                        </c:if>
                        <c:if test="${trade.tradeType == '택배' || trade.tradeType == '둘다가능'}">
                            <div class="ta-info-item ta-full">
                                <span class="ta-info-label">배송비</span>
                                <span class="ta-info-value">
                                    <c:choose>
                                        <c:when test="${not empty trade.shippingFee && trade.shippingFee > 0}"><fmt:formatNumber value="${trade.shippingFee}" pattern="#,###"/>원</c:when>
                                        <c:otherwise>추후 협의</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="ta-info-item ta-full ta-notice">
                                <i class="ri-information-line"></i>
                                <span>결제 시 <strong>착불</strong> 또는 <strong>선불</strong>을 선택할 수 있습니다. 착불은 수령 시 택배비를 지불하며, 선불은 발송 전 판매자에게 송금하는 방식입니다.</span>
                            </div>
                        </c:if>
                    </div>
                </div>

            </div><%-- /ta-main-card --%>

        </div>

        <div class="ta-right">

            <div class="ta-seller-card">
                <div class="ta-seller-avatar"><i class="ri-user-3-fill"></i></div>
                <div class="ta-seller-body">
                    <p class="ta-seller-name">${trade.nickName}</p>
                    <p class="ta-seller-region">
                        <i class="ri-map-pin-2-fill"></i>
                        <c:choose>
                            <c:when test="${not empty trade.dong}">${trade.dong}</c:when>
                            <c:otherwise>동네 정보 없음</c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <sec:authentication property="principal.member.userIdx" var="loggedInUserId"/>
                <div class="ta-seller-actions">
                    <c:choose>
                        <c:when test="${loggedInUserId == trade.userIdx}">
                            <button class="ta-seller-btn" onclick="location.href='${pageContext.request.contextPath}/mypage'">내정보 보기</button>
                        </c:when>
                        <c:otherwise>
                            <button class="ta-seller-btn" onclick="location.href='${pageContext.request.contextPath}/mypage/tradeUserMain?userIdx=${trade.userIdx}'">프로필 보기</button>
                            <button type="button" class="ta-report-btn" onclick="openReportModal('TRADE', ${trade.productIdx}, ${trade.userIdx})">
                                <i class="ri-alarm-warning-line"></i><span>신고</span>
                            </button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="ta-action-panel">
                <div class="ta-stats">
                    <div class="ta-stat"><i class="ri-eye-line"></i><span class="ta-stat-val">${trade.hitCount}</span><span class="ta-stat-lbl">조회</span></div>
                    <div class="ta-stat"><i class="ri-heart-3-line"></i><span class="ta-stat-val" id="statWishSide">${trade.likeCount}</span><span class="ta-stat-lbl">찜</span></div>
                    <div class="ta-stat"><i class="ri-chat-3-line"></i><span class="ta-stat-val">${trade.chatCount}</span><span class="ta-stat-lbl">채팅</span></div>
                </div>

                <sec:authorize access="isAnonymous()">
                    <c:choose>
                        <c:when test="${trade.tradeStatus == '판매완료'}">
                            <button class="chat-btn" disabled>판매 완료된 상품입니다</button>
                        </c:when>
                        <c:otherwise>
                            <button class="chat-btn" onclick="location.href='${pageContext.request.contextPath}/member/login'">
                                <i class="ri-chat-3-line"></i> 로그인하고 채팅하기
                            </button>
                        </c:otherwise>
                    </c:choose>
                    <div class="secondary-actions">
                        <button class="wish-btn-large" onclick="location.href='${pageContext.request.contextPath}/member/login'"><i class="ri-heart-3-line"></i> 찜하기</button>
                        <button class="share-btn" onclick="ShareModule.share()"><i class="ri-share-line"></i> 공유</button>
                    </div>
                </sec:authorize>

                <sec:authorize access="isAuthenticated()">
                    <sec:authentication property="principal.member.userIdx" var="loggedInUserId" />
                    <c:choose>
                        <c:when test="${loggedInUserId == trade.userIdx}">
                            <button class="chat-btn" onclick="window.open('${pageContext.request.contextPath}/chat/tradeList?tradeIdx=${trade.productIdx}', 'chatList', 'width=450, height=850, left=200, top=100, scrollbars=no, resizable=yes')">
                                <i class="ri-chat-3-line"></i> 채팅 내역 확인하기
                            </button>
                            <c:choose>
                                <c:when test="${not empty escrowInfo and escrowInfo.TRADESTATUS == 'PAY_COMPLETED'}">
                                    <button class="pay-btn" onclick="openShippingModal()"><i class="ri-truck-line"></i> 운송장 입력하기</button>
                                    <button class="pay-btn danger" onclick="cancelTrade(${trade.productIdx})">주문 취소 (구매자에게 환불)</button>
                                </c:when>
                                <c:when test="${not empty escrowInfo and escrowInfo.TRADESTATUS == 'SHIPPING'}">
                                    <button class="pay-btn" disabled>배송 중 (구매자 확정 대기)</button>
                                </c:when>
                                <c:when test="${not empty escrowInfo and escrowInfo.TRADESTATUS == 'CONFIRMED'}">
                                    <button class="chat-btn" disabled>판매 완료된 상품입니다</button>
                                </c:when>
                            </c:choose>
                        </c:when>
                        <c:when test="${trade.tradeStatus == '판매완료'}">
                            <button class="chat-btn" disabled>판매 완료된 상품입니다</button>
                        </c:when>
                        <c:otherwise>
                            <button class="chat-btn" onclick="window.open('${pageContext.request.contextPath}/chat/room?tradeIdx=${trade.productIdx}&toUserIdx=${trade.userIdx}', 'chatRoom', 'width=450, height=850, left=200, top=100, scrollbars=yes, resizable=yes')">
                                <i class="ri-chat-3-line"></i> 채팅으로 거래하기
                            </button>
                            <c:if test="${trade.price > 0}">
                                <c:choose>
                                    <c:when test="${empty escrowInfo or escrowInfo.TRADESTATUS == 'CANCELED'}">
                                        <button type="button" class="pay-btn" onclick="location.href='${pageContext.request.contextPath}/escrow/checkout?productIdx=${trade.productIdx}'">
                                            <i class="ri-shield-check-line"></i> 안전 결제하기
                                        </button>
                                    </c:when>
                                    <c:when test="${not empty escrowInfo and escrowInfo.BUYERIDX == loggedInUserId}">
                                        <c:choose>
                                            <c:when test="${escrowInfo.TRADESTATUS == 'PAY_COMPLETED'}">
                                                <button class="pay-btn" disabled>판매자의 발송을 대기 중입니다</button>
                                                <button class="pay-btn danger" onclick="cancelTrade(${trade.productIdx})">결제 취소 (포인트 환불)</button>
                                            </c:when>
                                            <c:when test="${escrowInfo.TRADESTATUS == 'SHIPPING'}">
                                                <button class="chat-btn" onclick="confirmTradePurchase(${trade.productIdx})">구매 확정하기</button>
                                                <button class="pay-btn danger" onclick="requestRefundViaChat(${trade.productIdx}, ${trade.userIdx})">반품 / 환불 요청하기</button>
                                            </c:when>
                                            <c:when test="${escrowInfo.TRADESTATUS == 'CONFIRMED'}">
                                                <button class="pay-btn success" disabled>구매 확정 완료</button>
                                            </c:when>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="pay-btn" style="background:#999;" disabled>다른 사용자가 안전결제를 진행 중입니다</button>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                        </c:otherwise>
                    </c:choose>

                    <div class="secondary-actions">
                        <button class="wish-btn-large ${isLiked ? 'active' : ''}" id="wishBtnLarge" onclick="WishModule.toggle()">
                            <i class="${isLiked ? 'ri-heart-3-fill' : 'ri-heart-3-line'}"></i> 찜 ${trade.likeCount}
                        </button>
                        <button class="share-btn" onclick="ShareModule.share()"><i class="ri-share-line"></i> 공유</button>
                    </div>

                    <c:if test="${loggedInUserId == trade.userIdx}">
                        <div class="ta-owner-section">
                            <p class="ta-owner-label">게시글 관리</p>
                            <div class="ta-owner-grid">
                                <button type="button" class="btn-manage status-style" onclick="StatusModule.open()"><i class="ri-loop-left-line"></i> 상태 변경</button>
                                <button type="button" class="btn-manage pull-style" onclick="PullUpModule.execute(${trade.productIdx})"><i class="ri-rocket-2-line"></i> 끌어올리기</button>
                                <c:choose>
                                    <c:when test="${trade.tradeStatus == '판매완료'}">
                                        <button type="button" class="btn-manage edit-style disabled-style" onclick="showBatonToast('판매 완료된 게시글은 수정할 수 없습니다.')"><i class="ri-edit-line"></i> 수정</button>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="button" class="btn-manage edit-style" onclick="location.href='${pageContext.request.contextPath}/trade/update?productIdx=${trade.productIdx}&page=${page}'"><i class="ri-edit-line"></i> 수정</button>
                                    </c:otherwise>
                                </c:choose>
                                <button type="button" class="btn-manage delete-style" onclick="confirmDelete(${trade.productIdx})"><i class="ri-delete-bin-line"></i> 삭제</button>
                            </div>
                        </div>
                    </c:if>
                </sec:authorize>
            </div>

        </div>
    </div>
</div>

<div class="lightbox" id="lightbox">
    <button class="lightbox-close" onclick="Lightbox.close()"><i class="ri-close-line"></i></button>
    <button class="lightbox-nav lightbox-prev" onclick="Lightbox.prev()"><i class="ri-arrow-left-s-line"></i></button>
    <img id="lightboxImg" src="" alt="확대 이미지">
    <button class="lightbox-nav lightbox-next" onclick="Lightbox.next()"><i class="ri-arrow-right-s-line"></i></button>
    <p class="lightbox-count" id="lightboxCount">1 / 1</p>
</div>

<div id="articleData"
    data-trade-idx="${trade.productIdx}"
    data-wished="${isLiked}"
    data-wish-count="${trade.likeCount}"
    data-lat="${trade.latitude}"
    data-lng="${trade.longitude}"
    style="display:none">
</div>

<div id="statusModal" class="modal-overlay" onclick="StatusModule.close()">
    <div class="modal-content" onclick="event.stopPropagation()">
        <div class="modal-header">
            <h3>상태 변경</h3>
            <button type="button" class="close-modal" onclick="StatusModule.close()"><i class="ri-close-line"></i></button>
        </div>
        <div class="status-options">
            <button type="button" class="status-opt ${trade.tradeStatus == '판매중' ? 'active' : ''}" onclick="StatusModule.update('${trade.productIdx}', '판매중')">판매 중</button>
            <button type="button" class="status-opt ${trade.tradeStatus == '예약중' ? 'active' : ''}" onclick="StatusModule.update('${trade.productIdx}', '예약중')">예약 중</button>
            <button type="button" class="status-opt ${trade.tradeStatus == '숨기기' ? 'active' : 'hide-opt'}" onclick="StatusModule.update('${trade.productIdx}', '숨기기')">숨기기</button>
        </div>
    </div>
</div>

<div id="shippingModal" class="modal-overlay" onclick="closeShippingModal()">
    <div class="modal-content" onclick="event.stopPropagation()">
        <div class="modal-header">
            <h3>운송장 정보 입력</h3>
            <button type="button" class="close-modal" onclick="closeShippingModal()"><i class="ri-close-line"></i></button>
        </div>
        <div class="shipping-form">
            <div class="shipping-field">
                <label>택배사</label>
                <select id="deliveryCompany">
                    <option value="CJ대한통운">CJ대한통운</option>
                    <option value="우체국택배">우체국택배</option>
                    <option value="한진택배">한진택배</option>
                    <option value="롯데택배">롯데택배</option>
                    <option value="로젠택배">로젠택배</option>
                    <option value="GS25편의점택배">GS25편의점택배</option>
                    <option value="CU편의점택배">CU편의점택배</option>
                </select>
            </div>
            <div class="shipping-field">
                <label>운송장 번호</label>
                <input type="text" id="trackingNumber" placeholder="- 없이 숫자만 입력">
            </div>
        </div>
        <button type="button" class="pay-btn" onclick="submitShippingInfo()">발송 처리 완료하기</button>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script>
    window.contextPath = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/dist/js/trade/trade-article.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/report/report-modal.js"></script>

<div id="reportModal" class="report-modal-overlay" style="display:none;">
    <div class="report-modal-sheet">
        <div class="report-modal-head">
            <span class="report-modal-title"><i class="ri-alarm-warning-line"></i> 신고하기</span>
            <button type="button" class="report-modal-close" onclick="closeReportModal()"><i class="ri-close-line"></i></button>
        </div>
        <div class="report-modal-body">
            <p class="report-modal-desc">신고 사유를 선택해주세요. 허위 신고는 제재를 받을 수 있습니다.</p>
            <div class="report-type-list">
                <label class="report-type-item"><input type="radio" name="reportType" value="스팸"><span class="report-type-label"><i class="ri-spam-line"></i> 스팸 / 광고</span></label>
                <label class="report-type-item"><input type="radio" name="reportType" value="욕설/비방"><span class="report-type-label"><i class="ri-emotion-unhappy-line"></i> 욕설 / 비방</span></label>
                <label class="report-type-item"><input type="radio" name="reportType" value="음란물"><span class="report-type-label"><i class="ri-eye-off-line"></i> 음란물 / 불건전</span></label>
                <label class="report-type-item"><input type="radio" name="reportType" value="사기"><span class="report-type-label"><i class="ri-error-warning-line"></i> 사기 / 허위 정보</span></label>
                <label class="report-type-item"><input type="radio" name="reportType" value="개인정보침해"><span class="report-type-label"><i class="ri-user-forbid-line"></i> 개인정보 침해</span></label>
                <label class="report-type-item"><input type="radio" name="reportType" value="기타"><span class="report-type-label"><i class="ri-more-line"></i> 기타</span></label>
            </div>
            <div class="report-content-wrap">
                <textarea id="reportContent" class="report-content-input" placeholder="추가로 전달할 내용이 있으면 입력해주세요. (선택)" maxlength="300"></textarea>
                <span class="report-content-count"><span id="reportContentCount">0</span>/300</span>
            </div>
        </div>
        <div class="report-modal-foot">
            <button type="button" class="report-btn-cancel" onclick="closeReportModal()">취소</button>
            <button type="button" class="report-btn-submit" onclick="submitReport()">신고 접수</button>
        </div>
        <input type="hidden" id="reportDomainType" value="">
        <input type="hidden" id="reportTargetIdx" value="">
        <input type="hidden" id="reportedUserIdx" value="">
    </div>
</div>

</body>
</html>
