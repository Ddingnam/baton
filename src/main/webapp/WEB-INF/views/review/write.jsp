<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>거래 후기 보내기 | BATON</title>
    <jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
    <link href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
    <style>
        body { background-color: #F8F9FA; margin: 0; padding: 0; }

        .review-write-wrap { 
            max-width: 600px; 
            margin: 100px auto 60px; 
            padding: 40px; 
            background: #fff;
            border-radius: 24px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            font-family: 'Pretendard', sans-serif; 
        }

        .popup-mode .review-write-wrap {
            margin: 40px auto; 
        }
        
        .rw-header { text-align: center; margin-bottom: 40px; }
        .rw-header h2 { font-size: 1.5rem; font-weight: 800; color: #1A1A1A; line-height: 1.4; }
        .rw-header p { font-size: 1rem; color: #8C8C8C; margin-top: 10px; font-weight: 500;}
        
        .score-section { display: flex; justify-content: center; gap: 30px; margin-bottom: 50px; }
        .score-item { text-align: center; cursor: pointer; opacity: 0.5; transition: all 0.3s ease; }
        .score-item:hover { opacity: 0.8; }
        .score-item.active { opacity: 1; transform: scale(1.08); }
        .score-item i { font-size: 3.5rem; display: block; margin-bottom: 8px; }
        .score-item span { font-size: 1rem; font-weight: 700; color: #555; }
        
        .score-bad.active i { color: #8C8C8C; }
        .score-good.active i { color: #2DBC6D; }
        .score-best.active i { color: #FFB300; }

        .tags-section h3 { font-size: 1.2rem; font-weight: 800; color: #1A1A1A; margin-bottom: 20px; text-align: center; }
        .tags-grid { display: flex; flex-direction: column; gap: 12px; margin-bottom: 40px; }
        .tag-label { 
            display: flex; align-items: center; padding: 18px 20px; 
            border: 1px solid #E6E6E6; border-radius: 12px; cursor: pointer;
            font-size: 1rem; color: #333; font-weight: 600; transition: all 0.2s ease;
            background-color: #fff;
        }
        .tag-label:hover { border-color: #D6D6D6; background-color: #FBFBFB; }
        .tag-label input { display: none; }
        .tag-label i { font-size: 1.4rem; margin-right: 12px; color: #C6C6C6; transition: color 0.2s; }
        
        .tag-label input:checked + i { color: #00B98D; }
        .tag-label:has(input:checked) { 
            border-color: #00B98D; 
            background-color: #E6F8F3; 
            color: #00B98D; 
            box-shadow: 0 2px 10px rgba(0, 185, 141, 0.1);
        }

        .content-section h3 { font-size: 1.2rem; font-weight: 800; color: #1A1A1A; margin-bottom: 20px; text-align: center; }
        .content-textarea { 
            width: 100%; height: 160px; padding: 20px; border: 1px solid #E6E6E6; box-sizing: border-box;
            border-radius: 12px; font-family: inherit; font-size: 1rem; resize: none; outline: none;
            color: #333; line-height: 1.6; transition: border-color 0.2s;
        }
        .content-textarea:focus { border-color: #00B98D; }
        .content-textarea::placeholder { color: #ADB5BD; font-weight: 500; }
        
        .btn-submit { 
            width: 100%; padding: 18px; background-color: #00B98D; 
            color: #fff; border: none; border-radius: 12px; font-size: 1.2rem; font-weight: 800; 
            cursor: pointer; margin-top: 30px; transition: background-color 0.2s;
            box-shadow: 0 4px 15px rgba(0, 185, 141, 0.2);
        }
        .btn-submit:hover { background-color: #00A37C; }
    </style>
</head>
<body class="${param.mode == 'popup' ? 'popup-mode' : ''}">

<c:if test="${param.mode != 'popup'}">
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />
</c:if>

<div class="review-write-wrap">
    <div class="rw-header">
        <h2>${targetNickname}님과의 거래가 어떠셨나요?</h2>
        <p>거래 선호도는 나만 볼 수 있어요.</p>
    </div>

    <form id="reviewForm" action="${pageContext.request.contextPath}/review/submit" method="post">
        <input type="hidden" name="targetUserIdx" value="${targetUserIdx}">
        <input type="hidden" name="productIdx" value="${productIdx}">
        <input type="hidden" name="saleReviewType" value="${saleReviewType}">
        
        <input type="hidden" id="score" name="score" value="3">
        <input type="hidden" id="reviewTags" name="reviewTags" value="">

        <div class="score-section">
            <div class="score-item score-bad" data-score="1" onclick="selectScore(this, 1)">
                <i class="ri-emotion-sad-fill"></i>
                <span>별로예요</span>
            </div>
            <div class="score-item score-good active" data-score="3" onclick="selectScore(this, 3)">
                <i class="ri-emotion-happy-fill"></i>
                <span>좋아요!</span>
            </div>
            <div class="score-item score-best" data-score="5" onclick="selectScore(this, 5)">
                <i class="ri-emotion-laugh-fill"></i>
                <span>최고예요!</span>
            </div>
        </div>

        <div class="tags-section">
            <h3>어떤 점이 좋았나요? (다중 선택 가능)</h3>
            <div class="tags-grid">
                <label class="tag-label">
                    <input type="checkbox" value="시간 약속을 잘 지켜요.">
                    <i class="ri-check-line"></i> 시간 약속을 잘 지켜요.
                </label>
                <label class="tag-label">
                    <input type="checkbox" value="친절하고 매너가 좋아요.">
                    <i class="ri-check-line"></i> 친절하고 매너가 좋아요.
                </label>
                <label class="tag-label">
                    <input type="checkbox" value="응답이 빨라요.">
                    <i class="ri-check-line"></i> 응답이 빨라요.
                </label>
                <label class="tag-label">
                    <input type="checkbox" value="물품 상태가 설명과 같아요.">
                    <i class="ri-check-line"></i> 물품 상태가 설명과 같아요.
                </label>
            </div>
        </div>

        <div class="content-section">
            <h3>따뜻한 거래 후기를 남겨주세요.</h3>
            <textarea class="content-textarea" name="content" placeholder="남겨주신 거래 후기는 상대방의 프로필에 공개됩니다."></textarea>
        </div>

        <button type="button" class="btn-submit" onclick="submitReview()">후기 보내기</button>
    </form>
</div>

<c:if test="${param.mode != 'popup'}">
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
</c:if>

<script>
    function selectScore(element, score) {
        document.querySelectorAll('.score-item').forEach(item => item.classList.remove('active'));
        element.classList.add('active');
        document.getElementById('score').value = score;
    }

    function submitReview() {
        const checkedTags = Array.from(document.querySelectorAll('.tag-label input:checked'))
                                 .map(cb => cb.value)
                                 .join(',');
        
        document.getElementById('reviewTags').value = checkedTags;
        document.getElementById('reviewForm').submit();
    }
</script>
</body>
</html>