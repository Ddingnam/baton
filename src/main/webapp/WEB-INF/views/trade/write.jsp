<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>상품 등록 | 마켓</title>
<link rel="icon" href="data:;base64,iVBORw0KGgo=">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/trade-write.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<header class="app-header">
    <div class="header-content">
        <button class="back-btn" onclick="history.back()">
            <svg width="24" height="24" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path d="M15 18l-6-6 6-6"/></svg>
        </button>
        <h1>내 물건 팔기</h1>
    </div>
</header>

<div class="page-wrap">
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
                            <div id="previewList" style="display: flex; gap: 12px; flex-wrap: wrap;"></div>
                        </div>
                        <input type="file" name="selectFile" id="selectFile" accept="image/*" multiple style="display:none">
                    </div>
                    
                    <p class="card-title">상품 정보</p>
                    <div class="field">
                        <label>제목</label>
                        <input type="text" name="title" id="titleInput" maxlength="50" placeholder="어떤 물건을 파시나요?">
                    </div>

                    <div class="field" style="margin-bottom: 0;">
                        <label>상품 설명</label>
                        <textarea name="content" id="contentInput" placeholder="브랜드, 모델명, 구매 시기, 사용 기간, 하자 여부 등 자세히 작성할수록 빨리 팔려요 😊"></textarea>
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
                                <input type="number" name="price" id="priceInput" placeholder="0">
                            </div>
                        </div>

                        <div class="field">
                            <label>카테고리</label>
                            <select name="categoryIdx">
                                <option value="">카테고리를 선택하세요</option>
                                <option value="1">📱 전자기기</option>
                                <option value="2">👗 의류</option>
                                <option value="3">💄 뷰티</option>
                                <option value="4">⭐ 스타굿즈</option>
                                <option value="5">🏠 가구/인테리어</option>
                                <option value="6">📚 도서</option>
                                <option value="7">🎮 게임</option>
                                <option value="8">기타</option>
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
                                <input type="radio" name="productStatus" id="s1" value="새상품" checked><label for="s1">새상품</label>
                                <input type="radio" name="productStatus" id="s2" value="사용감없음"><label for="s2">사용감 없음</label>
                                <input type="radio" name="productStatus" id="s3" value="사용감적음"><label for="s3">사용감 적음</label>
                                <input type="radio" name="productStatus" id="s4" value="사용감많음"><label for="s4">사용감 많음</label>
                                <input type="radio" name="productStatus" id="s5" value="고장/파손"><label for="s5">고장/파손</label>
                            </div>
                        </div>
                        <div class="field" style="margin-bottom: 0;">
						    <label>거래 방식</label>
						    <div class="trade-type-group">
						        <input type="radio" name="tradeType" id="t1" value="직거래" checked onchange="TradeLogic.toggleLocation(true)">
						        <label for="t1">직거래</label>
						        
						        <input type="radio" name="tradeType" id="t2" value="택배" onchange="TradeLogic.toggleLocation(false)">
						        <label for="t2">택배</label>
						        
						        <input type="radio" name="tradeType" id="t3" value="둘다가능" onchange="TradeLogic.toggleLocation(true)">
						        <label for="t3">둘 다 가능</label>
						    </div>
						</div>
						
						<div class="field" id="locationField" style="margin-top: 20px;">
						    <label>거래 희망 장소</label>
						    <input type="text" name="tradePlace" id="locationInput" placeholder="예) 강남역 1번 출구 앞">
						</div>
                    </div>

                    <button type="button" class="submit-btn" onclick="submitForm()">게시글 등록하기</button>
                    <button type="button" class="cancel-btn" onclick="history.back()">취소</button>
                </div>
            </div>
            
        </div>
    </form>
</div>
<script src="${pageContext.request.contextPath}/dist/js/trade-write.js"></script>
</body>
</html>