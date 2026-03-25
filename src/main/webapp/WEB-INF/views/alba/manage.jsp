<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>지원자 관리</title>

<link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">

<style>
* { box-sizing:border-box; }

body {
  margin:0;
  font-family: -apple-system, BlinkMacSystemFont, "Pretendard", sans-serif;
  background: linear-gradient(135deg, #eef2ff, #fdf2f8);
}

/* 헤더 */
.header {
  position:sticky;
  top:0;
  backdrop-filter: blur(14px);
  background: rgba(255,255,255,0.7);
  padding:18px;
  font-weight:800;
  font-size:20px;
  border-bottom:1px solid rgba(255,255,255,0.4);
}

/* 리스트 */
.list {
  padding:16px;
}

/* 카드 */
.item {
  display:flex;
  gap:14px;
  padding:16px;
  margin-bottom:14px;
  border-radius:20px;
  background: rgba(255,255,255,0.6);
  backdrop-filter: blur(16px);
  box-shadow: 0 10px 30px rgba(0,0,0,0.08);
  transition: all 0.25s ease;
  position:relative;
  overflow:hidden;
}

.item::before {
  content:"";
  position:absolute;
  inset:0;
  background: linear-gradient(120deg, transparent, rgba(255,255,255,0.6), transparent);
  opacity:0;
  transition:0.4s;
}

.item:hover::before {
  opacity:1;
}

.item:hover {
  transform: translateY(-6px) scale(1.01);
}

/* 프로필 */
.profile img, .no-img {
  width:52px;
  height:52px;
  border-radius:50%;
}

.no-img {
  display:flex;
  align-items:center;
  justify-content:center;
  background: linear-gradient(135deg, #c7d2fe, #a5b4fc);
  color:#fff;
  font-size:22px;
}

/* 정보 */
.info {
  flex:1;
}

.top {
  display:flex;
  justify-content:space-between;
  align-items:center;
}

.name {
  font-weight:800;
  font-size:16px;
  letter-spacing:-0.3px;
}

.time {
  font-size:12px;
  color:#9ca3af;
}

/* 서브 */
.sub {
  font-size:13px;
  color:#6b7280;
  margin-top:6px;
  display:flex;
  align-items:center;
  gap:6px;
}

/* 메시지 */
.message {
  margin-top:8px;
  font-size:13px;
  color:#374151;
  background: rgba(255,255,255,0.7);
  padding:8px 10px;
  border-radius:10px;
}

/* 버튼 영역 */
.actions {
  display:flex;
  flex-direction:column;
  gap:8px;
}

/* 버튼 */
.actions button {
  width:40px;
  height:40px;
  border:none;
  border-radius:14px;
  cursor:pointer;
  display:flex;
  align-items:center;
  justify-content:center;
  transition: all 0.2s ease;
  backdrop-filter: blur(8px);
}

.actions button:hover {
  transform: scale(1.15) rotate(3deg);
}

/* 버튼 색 */
.call {
  background: linear-gradient(135deg, #60a5fa, #2563eb);
  color:#fff;
}

.pass {
  background: linear-gradient(135deg, #34d399, #059669);
  color:#fff;
}

.fail {
  background: linear-gradient(135deg, #f87171, #dc2626);
  color:#fff;
}
</style>
</head>

<body>

<div class="header">
  지원자 ${fn:length(applicants)}명
</div>

<div class="list">

<c:forEach var="a" items="${applicants}">
  <div class="item">

    <div class="profile">
      <c:choose>
        <c:when test="${not empty a.photoUrl}">
          <img src="${pageContext.request.contextPath}${a.photoUrl}">
        </c:when>
        <c:otherwise>
          <div class="no-img"><i class="ri-user-line"></i></div>
        </c:otherwise>
      </c:choose>
    </div>

    <div class="info">

      <div class="top">
        <span class="name">${a.applicantName}</span>
        <span class="time">
          ${a.applyDate.toString().replace('T',' ').substring(5,16)}
        </span>
      </div>

      <div class="sub">
        <i class="ri-phone-line"></i>
        ${empty a.applicantPhone ? "전화번호 없음" : a.applicantPhone}
      </div>

      <div class="sub">
        <i class="ri-mail-line"></i>
        ${empty a.applicantEmail ? "이메일 없음" : a.applicantEmail}
      </div>

      <div class="message">
        ${empty a.message ? "메시지 없음" : a.message}
      </div>

    </div>

    <div class="actions">
      <button class="call"
        onclick="location.href='tel:${a.applicantPhone}'">
        <i class="ri-phone-line"></i>
      </button>

      <button class="pass"
        onclick="updateStatus(${a.applyIdx}, ${posting.postingIdx}, '합격')">
        ✔
      </button>

      <button class="fail"
        onclick="updateStatus(${a.applyIdx}, ${posting.postingIdx}, '불합격')">
        ✖
      </button>
    </div>

  </div>
</c:forEach>

</div>

<script>
const CONTEXT_PATH = "${pageContext.request.contextPath}";

function updateStatus(applyIdx, postingIdx, status) {
  const params = new URLSearchParams();
  params.append("applyIdx", applyIdx);
  params.append("postingIdx", postingIdx);
  params.append("status", status);

  fetch(CONTEXT_PATH + "/alba/manage/updateStatus", {
    method: "POST",
    body: params
  })
  .then(res => res.json())
  .then(data => {
    if(data.status === "success") {
      location.reload();
    } else {
      alert("실패");
    }
  });
}
</script>

</body>
</html>