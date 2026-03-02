<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${mode=='update'?'상품 수정':'상품 등록'} | 마켓</title>
<link rel="icon" href="data:;base64,iVBORw0KGgo=">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/trade-write.css">
<link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp" />
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />

<div class="page-wrap">
	<div class="header-content">
        <button class="back-btn" onclick="history.back()">
            <i class="ri-arrow-left-s-line" style="font-size: 24px;"></i>
        </button>
        <div class="title-set">
            <h1>${mode=='update' ? '상품 정보 수정' : '내 물건 팔기'}</h1>
            <p>우리 동네 이웃들과 따뜻한 거래를 시작해보세요.</p>
        </div>
    </div>
    <form id="tradeForm" name="tradeForm" method="post" enctype="multipart/form-data">
        <div class="grid-layout">
            
            <div class="main-side">
                <div class="card">
                    <div class="field">
                        <label>상품 이미지 (최대 5장)</label>
                        <div class="image-section">
                            <div class="img-add-btn" onclick="document.getElementById('selectFile').click()">
                                <span style="font-size: 24px;">📸</span>
                                <span style="color: var(--primary); font-weight: 700;" id="imgCount">0/5</span>
                            </div>
                            <div id="previewList" style="display: flex; gap: 12px; flex-wrap: wrap;">
                            	<c:if test="${mode=='update'}">
                                    <c:forEach var="item" items="${listFile}">
                                        <div class="img-preview" data-file-idx="${item.fileIdx}">
                                            <img src="${pageContext.request.contextPath}/uploads/trade/${item.saveFilename}">
                                            <span class="delete-old-img" onclick="deleteExistingFile('${item.fileIdx}', this)">×</span>
                                        </div>
                                    </c:forEach>
                                </c:if>
                            </div>
                        </div>
                        <input type="file" name="newFiles" id="selectFile" accept="image/*" multiple style="display:none">
                    </div>
                    
                    <p class="card-title">상품 정보</p>
                    <div class="field">
                        <label>제목</label>
                        <input type="text" name="title" id="titleInput" maxlength="50" placeholder="어떤 물건을 파시나요?" value="${trade.title}">
                    </div>

                    <div class="field" style="margin-bottom: 0;">
                        <label>상품 설명</label>
                        <textarea name="content" id="contentInput" placeholder="브랜드, 모델명, 구매 시기, 사용 기간, 하자 여부 등 자세히 작성할수록 빨리 팔려요 😊">${trade.content}</textarea>
                        <div style="text-align: right; margin-top: 8px; color: var(--text-muted); font-size: 13px;">
                            <span id="contentCount">0/2000</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="sticky-side">
                <div class="submit-container">
                    <div class="card">
                        <p class="card-title">기본 정보</p>
                        
                        <div class="field">
                            <label>판매 가격</label>
                            <div class="price-wrap">
                                <span class="won-sign">₩</span>
                                <input type="text" name="price" id="priceInput" placeholder="0" value="${trade.price}">
                            </div>
                            <div class="free-check-wrapper">
						        <input type="checkbox" id="freeCheck">
						        <label for="freeCheck">무료나눔</label>
						    </div>
                        </div>

                        <div class="field">
                            <label>카테고리</label>
                            <select name="categoryIdx">
                                <option value="">카테고리를 선택하세요</option>
                                <option value="1" ${trade.categoryIdx == 1 ? 'selected' : ''}>📱 전자기기</option>
                                <option value="2" ${trade.categoryIdx == 2 ? 'selected' : ''}>👗 의류</option>
                                <option value="3" ${trade.categoryIdx == 3 ? 'selected' : ''}>💄 뷰티</option>
                                <option value="4" ${trade.categoryIdx == 4 ? 'selected' : ''}>⭐ 스타굿즈</option>
                                <option value="5" ${trade.categoryIdx == 5 ? 'selected' : ''}>🏠 가구/인테리어</option>
                                <option value="6" ${trade.categoryIdx == 6 ? 'selected' : ''}>📚 도서</option>
                                <option value="7" ${trade.categoryIdx == 7 ? 'selected' : ''}>🎮 게임</option>
                                <option value="8" ${trade.categoryIdx == 8 ? 'selected' : ''}>기타</option>
                            </select>
                        </div>

                        <div class="field" style="margin-bottom: 0;">
                            <label>태그</label>
                            <div class="tag-wrap" id="tagWrap" onclick="document.getElementById('tagInput').focus()">
                                <input type="text" id="tagInput" placeholder="#태그 입력 후 Enter">
                            </div>
                            <input type="hidden" name="tags" id="finalTags">
                        </div>
                    </div>

                    <div class="card">
                        <p class="card-title">거래 조건</p>
                        <div class="field">
                            <label>상품 상태</label>
                            <div class="pill-group">
                                <c:set var="status" value="${empty trade.productStatus ? '새상품' : trade.productStatus}"/>
                                <input type="radio" name="productStatus" id="s1" value="새상품" ${status == '새상품' ? 'checked' : ''}><label for="s1">새상품</label>
                                <input type="radio" name="productStatus" id="s2" value="사용감없음" ${status == '사용감없음' ? 'checked' : ''}><label for="s2">사용감 없음</label>
                                <input type="radio" name="productStatus" id="s3" value="사용감적음" ${status == '사용감적음' ? 'checked' : ''}><label for="s3">사용감 적음</label>
                                <input type="radio" name="productStatus" id="s4" value="사용감많음" ${status == '사용감많음' ? 'checked' : ''}><label for="s4">사용감 많음</label>
                                <input type="radio" name="productStatus" id="s5" value="고장/파손" ${status == '고장/파손' ? 'checked' : ''}><label for="s5">고장/파손</label>
                            </div>
                        </div>
                        <div class="field" style="margin-bottom: 0;">
						    <label>거래 방식</label>
						    <div class="trade-type-group">
						    	<c:set var="tType" value="${empty trade.tradeType ? '직거래' : trade.tradeType}"/>
						    	
						        <input type="radio" name="tradeType" id="t1" value="직거래" ${tType == '직거래' ? 'checked' : ''} onchange="TradeLogic.toggleOptions('직거래')">
						        <label for="t1">직거래</label>
						        
						        <input type="radio" name="tradeType" id="t2" value="택배" ${tType == '택배' ? 'checked' : ''} onchange="TradeLogic.toggleOptions('택배')">
						        <label for="t2">택배</label>
						        
						        <input type="radio" name="tradeType" id="t3" value="둘다가능" ${tType == '둘다가능' ? 'checked' : ''} onchange="TradeLogic.toggleOptions('둘다가능')">
						        <label for="t3">둘 다 가능</label>
						    </div>
						</div>
						
						<div class="field" id="shippingFeeField" style="margin-top: 20px; display: none;">
						    <label>배송비</label>
						    <div class="price-wrap">
						        <span class="won-sign">₩</span>
						        <input type="text" name="shippingFee" id="shippingFeeInput" placeholder="0" value="${trade.shippingFee}">
						    </div>
						</div>
						
						<div class="field" id="locationField" style="margin-top: 20px;">
						    <label>거래 희망 장소</label>
						    <input type="text" name="tradePlace" id="locationInput" placeholder="예) 강남역 1번 출구 앞" value="${trade.tradePlace}">
						</div>
                    </div>

                    <button type="button" class="submit-btn" onclick="submitForm()">${mode=='update' ? '수정 완료하기' : '게시글 등록하기'}</button>
                    <button type="button" class="cancel-btn" onclick="history.back()">취소</button>
                </div>
            </div>
            
        </div>
        <c:if test="${mode == 'update'}">
		    <input type="hidden" name="productIdx" value="${trade.productIdx}">
		</c:if>
		<input type="hidden" name="mode" value="${mode}">
    </form>
</div>
<script src="${pageContext.request.contextPath}/dist/js/trade-write.js"></script>
<script> const contextPath = '${pageContext.request.contextPath}'; </script>
</body>
</html>