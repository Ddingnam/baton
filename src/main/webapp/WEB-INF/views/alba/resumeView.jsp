<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>지원자 이력서 | BATON ALBA</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">

<style>
:root{
  --primary:#002C5F;
  --primary-strong:#001F45;
  --primary-soft:#EEF4FB;
  --accent:#1565C0;
  --bg:#F4F7FB;
  --surface:#FFFFFF;
  --text:#111827;
  --sub:#4B5563;
  --muted:#94A3B8;
  --border:#E2E8F0;
  --radius:20px;
}

*{box-sizing:border-box;margin:0;padding:0;}

body{
  font-family:"Pretendard",-apple-system,BlinkMacSystemFont,sans-serif;
  background:
    radial-gradient(circle at top right, rgba(21,101,192,0.10), transparent 24%),
    linear-gradient(180deg, #F8FBFF 0%, #F4F7FB 100%);
  color:var(--text);
  min-height:100vh;
}

.page-shell{
  max-width:960px;
  margin:0 auto;
  padding:36px 20px 120px;
}

.hero{
  position:relative;
  overflow:hidden;
  background:linear-gradient(135deg, var(--primary-strong) 0%, var(--primary) 55%, #0A4A8A 100%);
  border-radius:28px;
  padding:30px 30px 28px;
  color:#fff;
  box-shadow:0 24px 50px rgba(0,44,95,0.20);
  margin-bottom:22px;
}

.hero::after{
  content:"";
  position:absolute;
  right:-60px;
  top:-60px;
  width:220px;
  height:220px;
  border-radius:50%;
  background:rgba(255,255,255,0.08);
}

.hero-top{
  display:flex;
  align-items:flex-start;
  justify-content:space-between;
  gap:18px;
  position:relative;
  z-index:1;
}

.hero-badge{
  display:inline-flex;
  align-items:center;
  gap:8px;
  padding:8px 14px;
  border-radius:999px;
  background:rgba(255,255,255,0.14);
  font-size:13px;
  font-weight:700;
  margin-bottom:14px;
}

.hero-title{
  font-size:30px;
  font-weight:800;
  letter-spacing:-0.03em;
  margin-bottom:8px;
}

.hero-sub{
  font-size:15px;
  color:rgba(255,255,255,0.82);
  line-height:1.6;
}

.close-btn{
  display:inline-flex;
  align-items:center;
  justify-content:center;
  width:46px;
  height:46px;
  border:none;
  border-radius:14px;
  background:rgba(255,255,255,0.14);
  color:#fff;
  font-size:22px;
  cursor:pointer;
  transition:0.2s ease;
  flex-shrink:0;
}

.close-btn:hover{
  background:rgba(255,255,255,0.22);
}

.profile-panel{
  margin-top:22px;
  position:relative;
  z-index:1;
  display:flex;
  align-items:center;
  gap:18px;
}

.avatar{
  width:82px;
  height:82px;
  border-radius:24px;
  background:rgba(255,255,255,0.16);
  border:1px solid rgba(255,255,255,0.16);
  display:flex;
  align-items:center;
  justify-content:center;
  overflow:hidden;
  flex-shrink:0;
}

.avatar img{
  width:100%;
  height:100%;
  object-fit:cover;
}

.avatar i{
  font-size:34px;
  color:#fff;
}

.profile-main{
  flex:1;
  min-width:0;
}

.resume-title{
  font-size:24px;
  font-weight:800;
  margin-bottom:8px;
}

.profile-name{
  font-size:16px;
  font-weight:600;
  color:rgba(255,255,255,0.88);
  margin-bottom:12px;
}

.profile-meta{
  display:flex;
  flex-wrap:wrap;
  gap:10px;
}

.meta-chip{
  display:inline-flex;
  align-items:center;
  gap:6px;
  padding:8px 12px;
  border-radius:999px;
  background:rgba(255,255,255,0.12);
  color:#fff;
  font-size:13px;
  font-weight:500;
}

.content-grid{
  display:grid;
  grid-template-columns:1fr;
  gap:16px;
}

.card{
  background:var(--surface);
  border:1px solid var(--border);
  border-radius:22px;
  padding:24px 24px 22px;
  box-shadow:0 10px 30px rgba(15,23,42,0.05);
}

.card-head{
  display:flex;
  align-items:center;
  gap:10px;
  margin-bottom:14px;
}

.card-icon{
  width:38px;
  height:38px;
  border-radius:12px;
  background:var(--primary-soft);
  color:var(--primary);
  display:flex;
  align-items:center;
  justify-content:center;
  font-size:18px;
}

.card-title{
  font-size:17px;
  font-weight:800;
  color:var(--text);
}

.card-body{
  font-size:15px;
  line-height:1.85;
  color:var(--sub);
  white-space:pre-wrap;
  word-break:break-word;
}

.empty-text{
  color:var(--muted);
}

.info-grid{
  display:grid;
  grid-template-columns:repeat(2, minmax(0, 1fr));
  gap:14px;
}

.info-box{
  background:#F8FAFC;
  border:1px solid var(--border);
  border-radius:16px;
  padding:16px 18px;
}

.info-label{
  font-size:12px;
  font-weight:800;
  color:var(--primary);
  margin-bottom:8px;
}

.info-value{
  font-size:15px;
  color:var(--text);
  line-height:1.6;
  word-break:break-word;
}

.bottom-bar{
  position:fixed;
  left:0;
  bottom:0;
  width:100%;
  padding:14px 20px;
  background:rgba(255,255,255,0.88);
  backdrop-filter:blur(12px);
  border-top:1px solid rgba(226,232,240,0.9);
}

.bottom-inner{
  max-width:960px;
  margin:0 auto;
  display:flex;
  justify-content:flex-end;
}

.btn-primary{
  display:inline-flex;
  align-items:center;
  justify-content:center;
  gap:8px;
  min-width:140px;
  padding:14px 20px;
  border:none;
  border-radius:14px;
  background:linear-gradient(135deg, var(--primary) 0%, #0A4A8A 100%);
  color:#fff;
  font-size:15px;
  font-weight:800;
  cursor:pointer;
  box-shadow:0 12px 24px rgba(0,44,95,0.18);
}

@media (max-width:768px){
  .hero{
    padding:24px 20px;
    border-radius:24px;
  }

  .hero-top{
    flex-direction:column;
    align-items:flex-start;
  }

  .close-btn{
    position:absolute;
    right:20px;
    top:20px;
  }

  .profile-panel{
    flex-direction:column;
    align-items:flex-start;
  }

  .resume-title{
    font-size:22px;
  }

  .info-grid{
    grid-template-columns:1fr;
  }

  .bottom-inner{
    justify-content:stretch;
  }

  .btn-primary{
    width:100%;
  }
}
</style>
</head>
<body>

<div class="page-shell">
  <section class="hero">
    <div class="hero-top">
      <div>
        <div class="hero-badge">
          <i class="ri-file-user-line"></i>
          지원자 이력서
        </div>
        <div class="hero-title">지원자 프로필 상세</div>
        <div class="hero-sub">공고에 지원한 인재의 이력서를 확인하는 읽기 전용 화면입니다.</div>
      </div>
      <button type="button" class="close-btn" onclick="window.close()" title="닫기">
        <i class="ri-close-line"></i>
      </button>
    </div>

    <div class="profile-panel">
      <div class="avatar">
        <c:choose>
          <c:when test="${not empty dto.photoUrl}">
            <img src="${pageContext.request.contextPath}${dto.photoUrl}" alt="${dto.userName}">
          </c:when>
          <c:otherwise>
            <i class="ri-user-3-line"></i>
          </c:otherwise>
        </c:choose>
      </div>

      <div class="profile-main">
        <div class="resume-title">${dto.title}</div>
        <div class="profile-name">${dto.userName}</div>

        <div class="profile-meta">
          <c:if test="${not empty dto.phone}">
            <div class="meta-chip"><i class="ri-phone-line"></i>${dto.phone}</div>
          </c:if>
          <c:if test="${not empty dto.email}">
            <div class="meta-chip"><i class="ri-mail-line"></i>${dto.email}</div>
          </c:if>
          <c:if test="${not empty dto.birth}">
            <div class="meta-chip"><i class="ri-cake-2-line"></i>${dto.birth}</div>
          </c:if>
          <c:if test="${not empty dto.gender}">
            <div class="meta-chip">
              <i class="ri-user-line"></i>
              <c:choose>
                <c:when test="${dto.gender eq 'M'}">남성</c:when>
                <c:when test="${dto.gender eq 'F'}">여성</c:when>
                <c:otherwise>${dto.gender}</c:otherwise>
              </c:choose>
            </div>
          </c:if>
        </div>
      </div>
    </div>
  </section>

  <section class="content-grid">
    <div class="card">
      <div class="card-head">
        <div class="card-icon"><i class="ri-contacts-book-2-line"></i></div>
        <div class="card-title">기본 정보</div>
      </div>
      <div class="info-grid">
        <div class="info-box">
          <div class="info-label">이름</div>
          <div class="info-value">${empty dto.userName ? '-' : dto.userName}</div>
        </div>
        <div class="info-box">
          <div class="info-label">연락처</div>
          <div class="info-value">${empty dto.phone ? '등록되지 않음' : dto.phone}</div>
        </div>
        <div class="info-box">
          <div class="info-label">이메일</div>
          <div class="info-value">${empty dto.email ? '등록되지 않음' : dto.email}</div>
        </div>
        <div class="info-box">
          <div class="info-label">생년월일</div>
          <div class="info-value">${empty dto.birth ? '등록되지 않음' : dto.birth}</div>
        </div>
      </div>
    </div>

    <div class="card">
      <div class="card-head">
        <div class="card-icon"><i class="ri-chat-quote-line"></i></div>
        <div class="card-title">자기소개</div>
      </div>
      <div class="card-body ${empty dto.introduce ? 'empty-text' : ''}">
        ${empty dto.introduce ? '작성된 자기소개가 없습니다.' : dto.introduce}
      </div>
    </div>

    <c:if test="${not empty dto.strengths}">
      <div class="card">
        <div class="card-head">
          <div class="card-icon"><i class="ri-star-smile-line"></i></div>
          <div class="card-title">강점</div>
        </div>
        <div class="card-body">${dto.strengths}</div>
      </div>
    </c:if>

    <c:if test="${not empty dto.additionalInfo}">
      <div class="card">
        <div class="card-head">
          <div class="card-icon"><i class="ri-information-line"></i></div>
          <div class="card-title">추가 정보</div>
        </div>
        <div class="card-body">${dto.additionalInfo}</div>
      </div>
    </c:if>

    <c:if test="${not empty apply.message}">
      <div class="card">
        <div class="card-head">
          <div class="card-icon"><i class="ri-mail-open-line"></i></div>
          <div class="card-title">지원 메시지</div>
        </div>
        <div class="card-body">${apply.message}</div>
      </div>
    </c:if>
  </section>
</div>

<div class="bottom-bar">
  <div class="bottom-inner">
    <button type="button" class="btn-primary" onclick="window.close()">
      <i class="ri-close-line"></i>
      닫기
    </button>
  </div>
</div>

</body>
</html>
