<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ include file="/WEB-INF/views/layout/headerResources.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>${dto.title} | BATON</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css"/>
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/main/main.css"/>
<style>
:root{--primary:#002C5F;--primary-light:#EEF3FA;--bg:#F7F9FC;--surface:#fff;--text:#111827;--sub:#4A5568;--border:#E2E8F0;--radius:12px;}
body{background:var(--bg);}
.wrap{max-width:760px;margin:0 auto;padding:100px 20px 60px;}

.resume-header{background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);padding:30px 28px;margin-bottom:16px;display:flex;align-items:center;gap:20px;}
.avatar-circle{width:72px;height:72px;border-radius:50%;background:var(--primary-light);display:flex;align-items:center;justify-content:center;font-size:32px;color:var(--primary);flex-shrink:0;overflow:hidden;}
.avatar-circle img{width:100%;height:100%;object-fit:cover;}
.header-info{flex:1;}
.resume-title{font-size:20px;font-weight:800;color:var(--text);margin:0 0 6px;}
.resume-name{font-size:15px;font-weight:600;color:var(--sub);margin:0 0 8px;}
.resume-meta{display:flex;gap:14px;flex-wrap:wrap;}
.meta-item{display:inline-flex;align-items:center;gap:4px;font-size:13px;color:var(--sub);}

.info-card{background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);padding:26px 28px;margin-bottom:14px;}
.card-label{font-size:12px;font-weight:700;color:var(--primary);text-transform:uppercase;letter-spacing:.06em;margin:0 0 12px;}
.card-content{font-size:15px;color:var(--text);line-height:1.75;white-space:pre-wrap;word-break:break-word;}
.card-content.empty-text{color:#9CA3AF;font-style:italic;}

.bottom-bar{position:fixed;bottom:0;left:0;width:100%;background:var(--surface);border-top:1px solid var(--border);padding:14px 20px;z-index:100;box-shadow:0 -4px 16px rgba(0,0,0,0.05);}
.bar-inner{max-width:760px;margin:0 auto;display:flex;gap:10px;}
.btn-back{flex:1;padding:14px;background:var(--bg);border:1px solid var(--border);border-radius:10px;font-size:15px;font-weight:600;color:var(--sub);cursor:pointer;text-align:center;text-decoration:none;display:flex;align-items:center;justify-content:center;gap:6px;}
.btn-edit{flex:2;padding:14px;background:var(--primary);border:none;border-radius:10px;font-size:15px;font-weight:700;color:#fff !important;cursor:pointer;text-align:center;text-decoration:none;display:flex;align-items:center;justify-content:center;gap:6px;}
.btn-edit i{color:#fff !important;}
.btn-del{flex:1;padding:14px;background:#FEF2F2;border:none;border-radius:10px;font-size:15px;font-weight:700;color:#DC2626;cursor:pointer;text-align:center;text-decoration:none;display:flex;align-items:center;justify-content:center;gap:6px;}
.btn-back:hover{background:#E2E8F0;}
.btn-edit:hover{background:#1a4a8a;color:#fff !important;}
.btn-edit:hover i{color:#fff !important;}
.btn-del:hover{background:#fee2e2;}
</style>

</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<main class="wrap">

  <div class="resume-header">
    <div class="avatar-circle">
      <c:choose>
        <c:when test="${not empty dto.photoUrl}">
          <img src="${dto.photoUrl}" alt="프로필"/>
        </c:when>
        <c:otherwise>
          <i class="ri-user-3-line"></i>
        </c:otherwise>
      </c:choose>
    </div>
    <div class="header-info">
      <h1 class="resume-title">${dto.title}</h1>
      <p class="resume-name">${dto.userName}</p>
      <div class="resume-meta">
        <c:if test="${not empty dto.phone}">
          <span class="meta-item"><i class="ri-phone-line"></i>${dto.phone}</span>
        </c:if>
        <c:if test="${not empty dto.email}">
          <span class="meta-item"><i class="ri-mail-line"></i>${dto.email}</span>
        </c:if>
        <c:if test="${not empty dto.birth}">
          <span class="meta-item"><i class="ri-cake-line"></i>${dto.birth}</span>
        </c:if>
        <c:if test="${not empty dto.gender}">
          <span class="meta-item">
            <i class="ri-user-line"></i>
            <c:choose>
              <c:when test="${dto.gender eq 'M'}">남성</c:when>
              <c:when test="${dto.gender eq 'F'}">여성</c:when>
              <c:otherwise>${dto.gender}</c:otherwise>
            </c:choose>
          </span>
        </c:if>
        <c:if test="${not empty dto.createdDate}">
          <span class="meta-item"><i class="ri-calendar-line"></i>${dto.createdDate} 작성</span>
        </c:if>
      </div>
    </div>
  </div>

  <div class="info-card">
    <p class="card-label"><i class="ri-file-text-line"></i> 자기소개</p>
    <c:choose>
      <c:when test="${not empty dto.introduce}">
        <p class="card-content">${dto.introduce}</p>
      </c:when>
      <c:otherwise>
        <p class="card-content empty-text">작성된 자기소개가 없습니다.</p>
      </c:otherwise>
    </c:choose>
  </div>

  <c:if test="${not empty dto.strengths}">
    <div class="info-card">
      <p class="card-label"><i class="ri-star-line"></i> 나의 장점</p>
      <p class="card-content">${dto.strengths}</p>
    </div>
  </c:if>

  <c:if test="${not empty dto.additionalInfo}">
    <div class="info-card">
      <p class="card-label"><i class="ri-information-line"></i> 추가 정보</p>
      <p class="card-content">${dto.additionalInfo}</p>
    </div>
  </c:if>

  <div style="height:80px;"></div>
</main>

<div class="bottom-bar">
  <div class="bar-inner">
    <a href="${pageContext.request.contextPath}/resume/myList" class="btn-back">
      <i class="ri-arrow-left-line"></i> 목록
    </a>
    <a href="${pageContext.request.contextPath}/resume/update?profileIdx=${dto.profileIdx}" class="btn-edit">
      <i class="ri-edit-line"></i> 수정하기
    </a>
    <a href="${pageContext.request.contextPath}/resume/delete?profileIdx=${dto.profileIdx}"
       class="btn-del"
       onclick="return confirm('이력서를 삭제할까요?')">
      <i class="ri-delete-bin-line"></i> 삭제
    </a>
  </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</body>
</html>