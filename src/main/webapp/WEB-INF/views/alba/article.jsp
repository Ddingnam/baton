<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ include file="/WEB-INF/views/layout/headerResources.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>${dto.title} | BATON 알바</title>
<link href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/alba/alba-article.css">

<jsp:include page="/WEB-INF/views/api/api.jsp"/>

<style>
  html { scroll-behavior: smooth; }
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<main class="main-layout">

    <header class="detail-recruit-header">
        <h1 class="recruit-title">
            ${dto.title}
            <span class="status-text ${dto.recruitStatus == '모집완료' ? 'closed' : 'open'}">${dto.recruitStatus}</span>
        </h1>
        <div class="recruit-company">
            <span>${dto.employer}</span>
        </div>
        
        <div class="recruit-chips">
            <span class="chip">근로계약서작성</span>
            <span class="chip">초보가능</span>
            <span class="chip">빠른연락가능</span>
            <c:if test="${not empty tagList}">
                <c:forEach var="tag" items="${tagList}">
                    <span class="chip">${tag}</span>
                </c:forEach>
            </c:if>
        </div>
    </header>

    <div class="tabs-header-wrap" id="tabMenu">
        <ul class="tabs-header-container">
            <li class="tab-item active" onclick="scrollToSection('section-conditions', this)">근무조건</li>
            <li class="tab-item" onclick="scrollToSection('section-description', this)">상세요강</li>
            <li class="tab-item" onclick="scrollToSection('section-company', this)">기업정보</li>
        </ul>
    </div>

    <section id="section-conditions" class="scroll-section summary-section">
	   <div class="summary-section">
	       <div class="pay-highlight-container">
	            <div class="pay-top">
	                <span class="pay-badge">${dto.payType}</span>
	                <strong class="pay-amount"><fmt:formatNumber value="${dto.pay}" pattern="#,###"/>원</strong>
	            </div>
	            <div class="pay-info-tags">
	                <span class="info-tag light">협의가능</span>
	                <span class="info-tag blue">주휴포함</span>
	            </div>
	            <div class="min-wage-info">
	                2026년 최저시급 10,320원 
	                <button type="button" class="btn-calc-mini"><i class="ri-calculator-line"></i> 급여계산기</button>
	            </div>
	        </div>
	    </div>			
	    <ul class="summary-list">
	        <li>
	            <i class="ri-calendar-check-line"></i>
	            <div class="summary-text">
	                <span class="label">근무기간</span>
	                <span class="value">
	                    <c:choose>
	                        <c:when test="${dto.workPeriod == 'MORE_THAN_A_YEAR'}">1년 이상</c:when>
	                        <c:when test="${dto.workPeriod == 'MORE_THAN_A_MONTH'}">1개월~6개월</c:when>
	                        <c:when test="${dto.workPeriod == 'LESS_THAN_A_MONTH'}">1개월 미만(단기)</c:when>
	                        <c:otherwise>${dto.workPeriod}</c:otherwise>
	                    </c:choose>
	                </span>
	            </div>
	        </li>
	
	        <li>
	            <i class="ri-calendar-event-line"></i>
	            <div class="summary-text">
	                <span class="label">근무요일</span>
	                <span class="value">${koreanDays}</span>
	            </div>
	        </li>
	
	        <li>
	            <i class="ri-time-line"></i>
	            <div class="summary-text">
	                <span class="label">근무시간</span>
	                <span class="value">${dto.workTime}</span>
	            </div>
	        </li>
	    </ul>
	
	    <div class="map-container-wrapper" style="margin-top: 30px;">
	        <h3 style="font-size: 16px; font-weight: 700; margin-bottom: 12px; color: var(--text-main);">근무지 위치</h3>
	        
	        <div style="display: flex; justify-content: space-between; align-items: center; background: var(--bg-color); padding: 12px 16px; border-radius: 10px; margin-bottom: 12px;">
	            <span style="font-size: 14px; color: var(--text-sub); word-break: keep-all;">
	                <i class="ri-map-pin-line" style="vertical-align: middle; margin-right: 4px; font-size: 16px;"></i> 
	                ${dto.location}
	            </span>
	            <button type="button" onclick="copyAddress('${dto.location}')" style="white-space:nowrap; background: #fff; border: 1px solid var(--border-color); padding: 6px 12px; border-radius: 6px; font-size: 12px; font-weight: 500; color: var(--text-main); cursor: pointer; transition: background 0.2s;">
	                주소 복사
	            </button>
	        </div>
	        
	        <div id="map" style="width: 100%; height: 220px; border-radius: 10px; border: 1px solid var(--border-color); z-index: 1;"></div>
	        
	        <input type="hidden" id="mapAddress" value="${dto.location}">
	        <input type="hidden" id="mapPlaceName" value="${dto.employer}">
	    </div>
	</section>

    <div class="divider"></div>

    <section id="section-description" class="scroll-section">
        <h2 class="section-title">상세 모집요강</h2>
        
        <c:if test="${not empty imageList}">
            <div class="gallery-section-inner">
            
                    <div class="main-image-wrap">
                        <img id="mainImage"
                             src="${pageContext.request.contextPath}${imageList[0].imgUrl}">
                    </div>
            
                    <c:if test="${imageList.size() > 1}">
                        <div class="image-indicators">
                            <c:forEach var="item" items="${imageList}" varStatus="st">
                                <button class="indicator-dot ${st.index==0?'active':''}"
                                        data-src="${item.imgUrl}"
                                        onclick="Gallery.go(${st.index})"></button>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>
            </c:if>

        <div class="article-text">${dto.description}</div>

        <div class="article-stats">
            <span><i class="ri-eye-line"></i> 조회 ${dto.hitCount}</span>
            <span><i class="ri-heart-3-line"></i> 관심 ${dto.likeCount}</span>
            <span><i class="ri-message-3-line"></i> 지원 ${dto.chatCount}</span>
        </div>
    </section>

    <div class="divider"></div>

    <section id="section-company" class="scroll-section">
        <h2 class="section-title">기업 정보</h2>
        <section class="safety-warning default-warning">
            <div class="warning-icon"><i class="ri-shield-star-fill"></i></div>
            <div class="warning-text">
                <strong>안심하고 지원하세요!</strong>
                <p>채권추심 고액알바 및 통장, 비밀번호 요구는 보이스피싱 사기 범죄일 수 있습니다. 가담 시 사기방조죄로 처벌받을 수 있으니 절대 응하지 마세요.</p>
            </div>
        </section>
    </section>

    <sec:authorize access="isAuthenticated()">
        <sec:authentication property="principal.member.userIdx" var="loggedInUserId" />
        <c:if test="${loggedInUserId == dto.userIdx}">
            <section class="owner-manage-section">
                <h2 class="section-title" style="border:none; margin-bottom:10px;">내 공고 관리</h2>
                <div class="manage-grid">
                    <button type="button" class="btn-manage" onclick="StatusModule.open()">
                        <i class="ri-loop-left-line"></i> 상태 변경
                    </button>
                    <button type="button" class="btn-manage" onclick="PullUpModule.execute(${dto.postingIdx})">
                        <i class="ri-arrow-up-circle-line"></i> 끌어올리기
                    </button>
                    <button type="button" class="btn-manage"
                            onclick="location.href='${pageContext.request.contextPath}/alba/update?postingIdx=${dto.postingIdx}&page=${page}'">
                        <i class="ri-edit-line"></i> 수정
                    </button>
                    <button type="button" class="btn-manage danger" onclick="confirmDelete(${dto.postingIdx})">
                        <i class="ri-delete-bin-line"></i> 삭제
                    </button>
                </div>
            </section>
        </c:if>
    </sec:authorize>
</main>

<div class="bottom-fixed-bar">
    <div class="bottom-inner">
        <div class="bottom-left">
            <button class="btn-wish ${isWished ? 'active' : ''}" id="wishBtnLarge" onclick="WishModule.toggle()">
                <i class="${isWished ? 'ri-heart-3-fill' : 'ri-heart-3-line'}"></i>
            </button>
        </div>
       <div class="bottom-right">
            <sec:authorize access="isAnonymous()">
                <button class="btn-action btn-call" onclick="location.href='${pageContext.request.contextPath}/member/login'">
                    <i class="ri-wechat-line"></i> 1:1 문의
                </button>
                <button class="btn-action btn-apply" onclick="location.href='${pageContext.request.contextPath}/member/login'">
                    <span class="chip-dday dday-calc" data-deadline="${dto.deadline}">D-?</span>
                    <span>온라인 지원</span>
                </button>
            </sec:authorize>

            <sec:authorize access="isAuthenticated()">
                <c:choose>
                    <c:when test="${loggedInUserId == dto.userIdx}">
					    <button class="btn-action btn-call" onclick="window.open('${pageContext.request.contextPath}/chat/albaList?albaIdx=${dto.postingIdx}', 'chatList', 'width=450,height=850')">
					        <i class="ri-message-3-line"></i> 채팅 관리
					    </button>
					    <button class="btn-action btn-apply" onclick="window.open('${pageContext.request.contextPath}/chat/albaList?albaIdx=${dto.postingIdx}', 'chatList', 'width=450,height=850')">
					        <span class="chip-dday dday-calc" data-deadline="${dto.deadline}">D-?</span>
					        <span>지원 내역 (${dto.chatCount})</span>
					    </button>
					</c:when>
                    <c:when test="${dto.recruitStatus == '모집완료'}">
                        <button class="btn-action btn-apply disabled full-width" disabled>
                            <span class="chip-dday">마감</span>
                            <span>모집이 완료되었습니다</span>
                        </button>
                    </c:when>
                    <c:otherwise>
                        <button class="btn-action btn-call" onclick="window.open('${pageContext.request.contextPath}/chat/albaRoom?albaIdx=${dto.postingIdx}&toUserIdx=${dto.userIdx}', 'chatRoom', 'width=450,height=850')">
                            <i class="ri-wechat-line"></i> 1:1 채팅하기
                        </button>
                        <button class="btn-action btn-apply" onclick="window.open('${pageContext.request.contextPath}/chat/albaRoom?albaIdx=${dto.postingIdx}&toUserIdx=${dto.userIdx}', 'chatRoom', 'width=450,height=850')">
                            <span class="chip-dday dday-calc" data-deadline="${dto.deadline}">D-?</span>
                            <span>채팅으로 지원하기</span>
                        </button>
                    </c:otherwise>
                </c:choose>
            </sec:authorize>
        </div>
    </div>
</div>

<div id="statusModal" class="modal-overlay" onclick="StatusModule.close()">
    <div class="modal-content" onclick="event.stopPropagation()">
        <div class="modal-header"><h3>모집 상태 변경</h3><button type="button" class="close-modal" onclick="StatusModule.close()"><i class="ri-close-line"></i></button></div>
        <div class="status-options">
            <button type="button" class="status-opt ${dto.recruitStatus == '모집중' ? 'active' : ''}" onclick="StatusModule.update('${dto.postingIdx}', '모집중')">모집중</button>
            <button type="button" class="status-opt ${dto.recruitStatus == '모집완료' ? 'active' : ''}" onclick="StatusModule.update('${dto.postingIdx}', '모집완료')">모집완료</button>
        </div>
    </div>
</div>

<div class="toast" id="toast"></div>
<div id="articleData" data-alba-idx="${dto.postingIdx}" data-wished="${isWished}" style="display:none"></div>

<script>
  const CONTEXT_PATH = "${pageContext.request.contextPath}";
  
  function scrollToSection(id, element) {
      const el = document.getElementById(id);
      if(el) {
          const headerOffset = 110;
          const elementPosition = el.getBoundingClientRect().top;
          const offsetPosition = elementPosition + window.pageYOffset - headerOffset;
          window.scrollTo({ top: offsetPosition, behavior: "smooth" });
          
          document.querySelectorAll('.tab-item').forEach(tab => tab.classList.remove('active'));
          element.classList.add('active');
      }
  }
</script>

<script src="${pageContext.request.contextPath}/dist/js/alba/alba-article.js"></script>
</body>
</html>