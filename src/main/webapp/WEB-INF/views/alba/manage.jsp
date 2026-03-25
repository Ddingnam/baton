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
body {
  margin:0;
  font-family: -apple-system, BlinkMacSystemFont;
  background:#f9fafb;
}

.header {
  position:sticky;
  top:0;
  background:#fff;
  padding:14px;
  border-bottom:1px solid #eee;
  font-weight:700;
}

.list {
  padding:6px 0;
}

.item {
  display:flex;
  align-items:center;
  gap:12px;
  padding:14px;
  border-bottom:1px solid #eee;
  background:#fff;
}

.profile img, .no-img {
  width:44px;
  height:44px;
  border-radius:50%;
}

.no-img {
  display:flex;
  align-items:center;
  justify-content:center;
  background:#eee;
}

.info {
  flex:1;
}

.top {
  display:flex;
  justify-content:space-between;
  font-size:14px;
}

.name {
  font-weight:700;
}

.time {
  font-size:12px;
  color:#999;
}

.message {
  font-size:13px;
  color:#555;
  margin-top:4px;
}

.actions {
  display:flex;
  gap:6px;
}

.actions button {
  width:32px;
  height:32px;
  border:none;
  border-radius:50%;
  cursor:pointer;
}

.pass {
  background:#10B981;
  color:#fff;
}

.fail {
  background:#EF4444;
  color:#fff;
}

.call {
  background:#3B82F6;
  color:#fff;
}

.item.pass-bg {
  background:#ECFDF5;
}

.item.fail-bg {
  opacity:0.5;
}
</style>
</head>

<body>

<div class="header">
  지원자 ${fn:length(applicants)}명
</div>

<div class="list">

<c:forEach var="a" items="${applicants}">
  <div class="item ${a.status == '합격' ? 'pass-bg' : ''} ${a.status == '불합격' ? 'fail-bg' : ''}">

    <!-- 프로필 -->
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

    <!-- 정보 -->
    <div class="info">
      <div class="top">
        <span class="name">${a.applicantName}</span>

        <!-- ✅ 날짜 수정 (에러 안남) -->
        <span class="time">
          ${a.applyDate.toString().replace('T',' ').substring(5,16)}
        </span>
      </div>

      <div class="message">
        ${empty a.message ? "메시지 없음" : a.message}
      </div>
    </div>

    <!-- 액션 -->
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