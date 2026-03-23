<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>${dto.userName}님의 이력서 | BATON</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css"/>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<style>
/* BATON 시스템 컬러 정의 */
:root {
    --baton-navy: #002C5F;
    --baton-gray-dark: #1a202c;
    --baton-gray-sub: #4A5568;
    --baton-border: #E2E8F0;
    --baton-bg: #F7F9FC;
}

html, body { 
    margin: 0 !important; 
    padding: 0 !important; 
    background-color: var(--baton-bg) !important;
}

* { 
    font-family: 'Pretendard Variable', Pretendard, sans-serif !important; 
    box-sizing: border-box; 
    color: var(--baton-gray-dark);
}

#SubWrap { 
    padding: 60px 20px !important; 
    display: flex !important; 
    justify-content: center !important; 
    width: 100% !important;
}

/* 이력서 본체: BATON의 깔끔한 카드 스타일 반영 */
.resume-paper { 
    background: #fff !important; 
    padding: 80px !important; 
    box-shadow: 0 4px 20px rgba(0,0,0,0.05) !important; 
    max-width: 820px !important; 
    width: 100% !important;
    border-top: 10px solid var(--baton-navy) !important;
    position: relative;
}

/* 상단 워터마크 느낌의 로고 */
.baton-logo {
    position: absolute;
    top: 30px;
    right: 80px;
    font-size: 14px;
    font-weight: 900;
    color: var(--baton-navy);
    letter-spacing: 2px;
}

/* 헤더: 타이포그래피 강조 */
.resume-header {
    margin-bottom: 50px;
    padding-bottom: 20px;
    border-bottom: 2px solid var(--baton-gray-dark);
}

.resume-header h1 {
    font-size: 38px;
    font-weight: 800;
    margin: 0;
    letter-spacing: -1.5px;
}

/* 프로필 영역: 깔끔한 그리드 레이아웃 */
.user-info-grid {
    display: flex;
    gap: 40px;
    margin-bottom: 60px;
    align-items: flex-start;
}

.photo-box {
    width: 130px;
    height: 170px;
    background: #F1F5F9;
    border-radius: 4px;
    overflow: hidden;
    flex-shrink: 0;
    border: 1px solid var(--baton-border);
}

.photo-box img { width: 100%; height: 100%; object-fit: cover; }

.info-content { flex: 1; }
.info-content .name-row {
    display: flex;
    align-items: baseline;
    gap: 12px;
    margin-bottom: 25px;
}

.info-content .name { font-size: 32px; font-weight: 800; }
.info-content .meta { font-size: 16px; color: var(--baton-gray-sub); font-weight: 500; }

.details-table {
    display: grid;
    grid-template-columns: 80px 1fr;
    gap: 12px 20px;
    font-size: 15px;
}

.details-table .label { font-weight: 700; color: var(--baton-gray-sub); }
.details-table .value { font-weight: 500; }

/* 섹션 스타일: BATON의 모던한 느낌 */
.section-item { margin-bottom: 45px; }
.section-title {
    font-size: 18px;
    font-weight: 800;
    color: var(--baton-navy);
    margin-bottom: 15px;
    padding-bottom: 8px;
    border-bottom: 1px solid var(--baton-border);
}

.section-text {
    font-size: 16px;
    line-height: 1.8;
    white-space: pre-wrap;
    word-break: break-all;
    background: #FBFCFE;
    padding: 25px;
    border-radius: 8px;
    border: 1px solid #F1F5F9;
}

/* 제목(슬로건) 전용 스타일 */
.resume-slogan {
    font-size: 22px;
    font-weight: 700;
    color: var(--baton-gray-dark);
    margin-bottom: 40px;
    line-height: 1.4;
    padding-left: 15px;
    border-left: 5px solid var(--baton-navy);
}

/* 하단 확인 영역 */
.footer-area {
    margin-top: 80px;
    text-align: center;
    border-top: 1px solid var(--baton-border);
    padding-top: 50px;
}

.footer-area p { font-size: 18px; font-weight: 600; margin-bottom: 30px; }
.footer-area .date { color: var(--baton-gray-sub); font-size: 15px; margin-bottom: 10px; }
.footer-area .sign { font-size: 24px; font-weight: 800; }

/* 출력 버튼 (웹에서만 보임) */
.btn-floating {
    position: fixed;
    bottom: 30px;
    right: 30px;
    z-index: 1000;
}

.btn-baton-print {
    background: var(--baton-navy);
    color: #fff !important;
    padding: 16px 32px;
    border-radius: 8px;
    text-decoration: none;
    font-weight: 700;
    box-shadow: 0 4px 15px rgba(0,44,95,0.3);
    display: flex;
    align-items: center;
    gap: 8px;
    transition: 0.2s;
}

.btn-baton-print:hover { transform: translateY(-2px); background: #001a3a; }

/* 인쇄 설정 */
@media print {
    body { background: #fff !important; }
    #SubWrap { padding: 0 !important; }
    .resume-paper { 
        padding: 0 !important; 
        box-shadow: none !important; 
        border: none !important; 
        width: 100% !important; 
    }
    .btn-floating, .baton-logo { display: none !important; }
    .section-text { border: 1px solid var(--baton-border) !important; background: transparent !important; }
    -webkit-print-color-adjust: exact !important;
    print-color-adjust: exact !important;
}
</style>
</head>

<body>

<div id="SubWrap">
    <div class="resume-paper">
        <div class="baton-logo">BATON RESUME</div>
        
        <header class="resume-header">
            <h1>이 력 서</h1>
        </header>

        <div class="resume-slogan">
            ${not empty dto.title ? dto.title : '성실한 태도로 최선을 다해 업무에 임하겠습니다.'}
        </div>

        <section class="user-info-grid">
            <div class="photo-box">
                <c:choose>
                    <c:when test="${not empty dto.photoUrl}">
                        <img src="${pageContext.request.contextPath}/uploads/resume/${dto.photoUrl}" alt="Profile">
                    </c:when>
                    <c:otherwise>
                        <div style="display:flex; height:100%; align-items:center; justify-content:center; color:#CBD5E0; font-size:12px;">사진 없음</div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="info-content">
                <div class="name-row">
                    <span class="name">${dto.userName}</span>
                    <span class="meta">${dto.gender == 'M' ? '남성' : '여성'} · ${dto.birth}년생</span>
                </div>
                
                <div class="details-table">
                    <div class="label">연락처</div>
                    <div class="value">${dto.phone}</div>
                    <div class="label">이메일</div>
                    <div class="value">${dto.email}</div>
                    <div class="label">주소</div>
                    <div class="value">인천광역시 서구</div>
                </div>
            </div>
        </section>

        <div class="section-item">
            <h3 class="section-title">자기소개</h3>
            <div class="section-text">${not empty dto.introduce ? dto.introduce : '등록된 자기소개가 없습니다.'}</div>
        </div>

        <c:if test="${not empty dto.strengths}">
            <div class="section-item">
                <h3 class="section-title">나의 강점</h3>
                <div class="section-text">${dto.strengths}</div>
            </div>
        </c:if>

        <c:if test="${not empty dto.additionalInfo}">
            <div class="section-item">
                <h3 class="section-title">추가 정보</h3>
                <div class="section-text">${dto.additionalInfo}</div>
            </div>
        </c:if>

        <footer class="footer-area">
            <p>위 기재사항은 사실과 다름없음을 확인합니다.</p>
            <div class="date">${not empty dto.createdDate ? fn:substring(dto.createdDate, 0, 10) : '2026-03-23'}</div>
            <div class="sign">작성자 : ${dto.userName} (인)</div>
        </footer>
    </div>
</div>

<div class="btn-floating">
    <a href="#" class="btn-baton-print" onclick="window.print(); return false;">
        <span>🖨️</span> 이력서 인쇄하기
    </a>
</div>

</body>
</html>