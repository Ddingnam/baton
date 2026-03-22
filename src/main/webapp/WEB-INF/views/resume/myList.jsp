<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ include file="/WEB-INF/views/layout/headerResources.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>나의 이력서 | BATON</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css"/>
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/main/main.css"/>
<style>
:root{--primary:#002C5F;--primary-light:#EEF3FA;--bg:#F7F9FC;--surface:#fff;--text:#111827;--sub:#4A5568;--border:#E2E8F0;--radius:12px;}
body{background:var(--bg);}
.wrap{max-width:760px;margin:0 auto;padding:100px 20px 60px;}
.top-bar{display:flex;align-items:center;justify-content:space-between;margin-bottom:24px;}
.page-title{font-size:22px;font-weight:800;color:var(--text);margin:0;}
.btn-new{display:inline-flex;align-items:center;gap:6px;padding:10px 18px;background:var(--primary);color:#fff;border:none;border-radius:8px;font-size:14px;font-weight:700;cursor:pointer;text-decoration:none;}
.btn-new:hover{background:#1a4a8a;}
.count-info{font-size:14px;color:var(--sub);margin-bottom:16px;}
.count-info strong{color:var(--primary);}

/* 카드 */
.resume-card{background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);padding:22px 24px;margin-bottom:14px;display:flex;align-items:center;justify-content:space-between;box-shadow:0 2px 8px rgba(0,0,0,0.03);cursor:pointer;transition:box-shadow .2s,border-color .2s;}
.resume-card:hover{box-shadow:0 4px 18px rgba(0,44,95,0.09);border-color:#b0c4de;}
.card-left{flex:1;min-width:0;}
.card-title{font-size:16px;font-weight:700;color:var(--text);margin:0 0 8px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;}
.card-meta{display:flex;gap:12px;flex-wrap:wrap;align-items:center;}
.meta-item{display:inline-flex;align-items:center;gap:4px;font-size:13px;color:var(--sub);}
.card-actions{display:flex;gap:8px;margin-left:18px;flex-shrink:0;}
.btn-sm{padding:7px 13px;border-radius:6px;font-size:13px;font-weight:600;cursor:pointer;border:none;text-decoration:none;display:inline-flex;align-items:center;gap:3px;}
.btn-edit{background:var(--primary-light);color:var(--primary);}
.btn-edit:hover{background:#d4e3f5;}
.btn-del{background:#FEF2F2;color:#DC2626;}
.btn-del:hover{background:#fee2e2;}

/* 빈 상태 */
.empty{text-align:center;padding:80px 20px;background:var(--surface);border:1px dashed var(--border);border-radius:var(--radius);}
.empty-icon{font-size:50px;color:#CBD5E0;margin-bottom:16px;}
.empty-title{font-size:18px;font-weight:700;color:var(--text);margin:0 0 8px;}
.empty-desc{font-size:14px;color:var(--sub);margin:0 0 24px;}
.btn-empty{display:inline-flex;align-items:center;gap:6px;padding:12px 24px;background:var(--primary);color:#fff;border-radius:8px;font-size:15px;font-weight:700;text-decoration:none;}
.btn-empty:hover{background:#1a4a8a;}
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<main class="wrap">
  <div class="top-bar">
    <h1 class="page-title">나의 이력서</h1>
    <a href="${pageContext.request.contextPath}/resume/write" class="btn-new">
      <i class="ri-add-line"></i> 새 이력서 작성
    </a>
  </div>

  <c:choose>
    <c:when test="${not empty list}">
      <p class="count-info">총 <strong>${fn:length(list)}개</strong>의 이력서가 있습니다.</p>

      <c:forEach var="r" items="${list}">
        <div class="resume-card"
             onclick="location.href='${pageContext.request.contextPath}/resume/article/${r.profileIdx}'">
          <div class="card-left">
            <p class="card-title">${r.title}</p>
            <div class="card-meta">
              <c:if test="${not empty r.phone}">
                <span class="meta-item"><i class="ri-phone-line"></i>${r.phone}</span>
              </c:if>
              <c:if test="${not empty r.createdDate}">
                <span class="meta-item"><i class="ri-calendar-line"></i>${r.createdDate}</span>
              </c:if>
            </div>
          </div>
          <div class="card-actions" onclick="event.stopPropagation()">
            <a href="${pageContext.request.contextPath}/resume/update?profileIdx=${r.profileIdx}"
               class="btn-sm btn-edit">
              <i class="ri-edit-line"></i> 수정
            </a>
            <a href="${pageContext.request.contextPath}/resume/delete?profileIdx=${r.profileIdx}"
               class="btn-sm btn-del"
               onclick="return confirm('이력서를 삭제할까요?')">
              <i class="ri-delete-bin-line"></i> 삭제
            </a>
          </div>
        </div>
      </c:forEach>
    </c:when>
    <c:otherwise>
      <div class="empty">
        <div class="empty-icon"><i class="ri-file-text-line"></i></div>
        <p class="empty-title">등록된 이력서가 없어요</p>
        <p class="empty-desc">이력서를 등록하면 사장님들이 먼저 연락할 수 있어요!</p>
        <a href="${pageContext.request.contextPath}/resume/write" class="btn-empty">
          <i class="ri-add-line"></i> 첫 이력서 작성하기
        </a>
      </div>
    </c:otherwise>
  </c:choose>
</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</body>
</html>
