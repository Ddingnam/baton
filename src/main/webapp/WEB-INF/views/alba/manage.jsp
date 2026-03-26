<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>지원자 관리</title>
<link href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">

<style>
:root {
  --primary:        #002C5F;
  --accent:         #1565C0;
  --bg-color:       #FFFFFF; /* 완전 흰색 배경 */
  --text-main:      #111827;
  --text-sub:       #4B5563;
  --text-light:     #9CA3AF;
  --border-color:   #E5E7EB;
  --radius:         16px;
}

* { box-sizing: border-box; margin: 0; padding: 0; }

body {
  font-family: "Pretendard", -apple-system, sans-serif;
  background-color: var(--bg-color);
  color: var(--text-main);
  min-height: 100vh;
}

/* ── 헤더 ── */
.page-header {
  position: sticky; top: 0; z-index: 100;
  background: var(--primary);
  padding: 0 24px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}
.header-inner {
  display: flex; align-items: center;
  justify-content: space-between;
  padding: 16px 0;
  max-width: 1200px;
  margin: 0 auto;
}
.header-left { display: flex; align-items: center; gap: 12px; }

/* 뒤로가기 버튼 스타일 추가 */
.btn-back {
  display: flex; align-items: center; justify-content: center;
  width: 40px; height: 40px;
  background: transparent;
  border: none;
  color: #ffffff;
  font-size: 24px;
  cursor: pointer;
  border-radius: 12px;
  transition: background 0.2s ease;
  margin-right: 4px;
}
.btn-back:hover {
  background: rgba(255, 255, 255, 0.15);
}

.header-icon {
  width: 40px; height: 40px;
  background: rgba(255,255,255,0.15);
  border-radius: 12px;
  display: flex; align-items: center; justify-content: center;
  font-size: 20px; color: #ffffff;
}
.header-title h1 { 
  font-size: 20px; 
  font-weight: 800; 
  color: #ffffff !important; /* 무조건 흰색 적용 */
  letter-spacing: -0.5px; 
}
.header-subtitle { font-size: 13px; color: rgba(255,255,255,0.7); margin-top: 2px; }

.header-right .total-badge {
  background: rgba(255,255,255,0.2);
  color: #ffffff;
  padding: 8px 16px;
  border-radius: 99px;
  font-size: 14px; font-weight: 600;
}
.header-right .total-badge span { color: #90CAF9; font-weight: 800; margin-left: 6px; }

/* ── 메인 (가로로 넓게) ── */
.main-wrapper {
  max-width: 1200px;
  margin: 0 auto;
  padding: 40px 20px 80px;
}

/* ── 카드 목록 ── */
.list-section { display: flex; flex-direction: column; gap: 20px; }

/* ── 지원자 카드 (가로형) ── */
.applicant-card {
  display: flex;
  align-items: center;
  gap: 30px;
  background: #ffffff;
  border: 1px solid var(--border-color);
  border-radius: var(--radius);
  padding: 24px 30px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.04);
  transition: all 0.2s ease;
}
.applicant-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 8px 20px rgba(0,0,0,0.08);
  border-color: #D1D5DB;
}

/* 1. 왼쪽: 아바타 및 기본 정보 */
.card-left {
  display: flex;
  align-items: center;
  gap: 16px;
  flex: 0 0 280px; 
}
.avatar {
  width: 56px; height: 56px;
  border-radius: 16px; flex-shrink: 0;
  display: flex; align-items: center; justify-content: center;
  font-size: 24px;
  background: #F3F4F6; color: #6B7280;
  overflow: hidden;
}
.avatar img { width:100%; height:100%; object-fit:cover; }
.card-info { flex:1; min-width:0; }
.applicant-name {
  display: block;
  font-size: 18px; font-weight: 800;
  color: var(--text-main); margin-bottom: 6px;
}
.info-row {
  display: flex; align-items: center; gap: 6px;
  font-size: 14px; color: var(--text-sub); margin-bottom: 4px;
}
.info-row i { color: var(--text-light); }

/* 2. 중앙: 남긴 메시지 */
.card-middle {
  flex: 1; 
  background: #F9FAFB;
  border-radius: 12px;
  padding: 16px 20px;
  font-size: 14px;
  color: var(--text-sub);
  line-height: 1.6;
  min-height: 70px;
}
.card-middle.empty { color: var(--text-light); font-style: italic; }

/* 3. 오른쪽: 시간 및 액션 버튼 (무조건 가로 배치) */
.card-right {
  flex: 0 0 auto; 
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 12px;
}
.apply-time {
  display: flex; align-items: center; gap: 5px;
  font-size: 13px; color: var(--text-light);
}
.action-buttons {
  display: flex; 
  flex-direction: row !important; 
  flex-wrap: nowrap; 
  gap: 8px;
}
.btn-action {
  display: flex; 
  align-items: center; 
  justify-content: center;
  gap: 6px;
  padding: 10px 20px; 
  border-radius: 8px;
  font-size: 14px; 
  font-weight: 700; 
  border: none; 
  cursor: pointer;
  white-space: nowrap; 
  transition: all 0.2s ease;
}
.btn-action:active { transform: scale(0.96); }

.btn-call {
  background: #F3F4F6; color: var(--text-main);
  border: 1px solid #E5E7EB;
}
.btn-call:hover { background: #E5E7EB; }

.btn-resume {
  background: var(--accent); color: #fff;
}
.btn-resume:hover { background: #1E88E5; }

/* ── 빈 상태 ── */
.empty-state {
  text-align: center; padding: 100px 20px;
  background: #ffffff;
  border: 1px dashed #D1D5DB;
  border-radius: var(--radius);
}
.empty-icon { font-size: 48px; margin-bottom: 16px; color: #D1D5DB; }
.empty-state h3 { font-size: 18px; font-weight: 700; color: var(--text-sub); margin-bottom: 8px; }
.empty-state p  { font-size: 15px; color: var(--text-light); }
</style>
</head>
<body>

<div class="page-header">
  <div class="header-inner">
    <div class="header-left">
      <button class="btn-back" onclick="history.back()" title="뒤로가기">
        <i class="ri-arrow-left-s-line"></i>
      </button>
      <div class="header-icon"><i class="ri-group-line"></i></div>
      <div class="header-title">
        <h1 style="color: #ffffff !important;">지원자 관리</h1>
        <div class="header-subtitle">${posting.title}</div>
      </div>
    </div>
    <div class="header-right">
      <div class="total-badge">총 지원자<span>${totalCount}</span>명</div>
    </div>
  </div>
</div>

<div class="main-wrapper">
  <div class="list-section" id="applicant-list">
    <c:choose>
      <c:when test="${empty applicants}">
        <div class="empty-state">
          <div class="empty-icon"><i class="ri-inbox-line"></i></div>
          <h3>아직 지원자가 없어요</h3>
          <p>공고를 공유해서 더 많은 지원자를 받아보세요.</p>
        </div>
      </c:when>
      <c:otherwise>
        <c:forEach var="a" items="${applicants}" varStatus="st">
          <div class="applicant-card">
            
            <div class="card-left">
              <div class="avatar">
                <c:choose>
                  <c:when test="${not empty a.photoUrl}">
                    <img src="${pageContext.request.contextPath}${a.photoUrl}" alt="${a.applicantName}">
                  </c:when>
                  <c:otherwise><i class="ri-user-line"></i></c:otherwise>
                </c:choose>
              </div>
              <div class="card-info">
                <span class="applicant-name">${a.applicantName}</span>
                <div class="info-row"><i class="ri-phone-line"></i><span>${empty a.applicantPhone ? "전화번호 없음" : a.applicantPhone}</span></div>
                <div class="info-row"><i class="ri-mail-line"></i><span>${empty a.applicantEmail ? "이메일 없음" : a.applicantEmail}</span></div>
              </div>
            </div>

            <div class="card-middle ${empty a.message ? 'empty' : ''}">
              ${empty a.message ? "남긴 메시지가 없습니다." : a.message}
            </div>

            <div class="card-right">
              <div class="apply-time">
                <i class="ri-time-line"></i>
                <span>${a.applyDate.toString().replace('T',' ').substring(5,16)}</span>
              </div>
              <div class="action-buttons">
                <button class="btn-action btn-call" onclick="location.href='tel:${a.applicantPhone}'">
                  <i class="ri-phone-fill"></i> 전화
                </button>
                <button class="btn-action btn-resume" onclick="window.open('${pageContext.request.contextPath}/alba/resume/view?applyIdx=${a.applyIdx}', '_blank')">
                  <i class="ri-file-text-line"></i> 이력서
                </button>
              </div>
            </div>

          </div>
        </c:forEach>
      </c:otherwise>
    </c:choose>
  </div>
</div>

</body>
</html>