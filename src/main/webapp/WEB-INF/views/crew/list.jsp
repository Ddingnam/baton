<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/crew_list.css">

<header>
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />
</header>

<main class="crew-page-wrapper">
    <section class="crew-hero">
        <div class="container hero-inner">
            <div class="hero-text">
                <span class="hero-badge">BATON CREW</span>
                <h1 class="hero-title">우리 동네 이웃과 함께<br><span class="pink-text">새로운 일상</span>을 시작하세요.</h1>
                <p class="hero-desc">운동, 스터디, 맛집 탐방까지! 지금 바로 참여할 수 있는 모임이 기다리고 있어요.</p>
            </div>
            <div class="hero-stats">
                <div class="stat-box"><strong>1,204</strong><span>개설된 크루</span></div>
                <div class="stat-box"><strong>8,530</strong><span>참여중인 이웃</span></div>
            </div>
        </div>
    </section>

    <div class="container crew-main-content">
        <section class="crew-toolbar">
            <div class="category-scroll">
                <button class="cat-btn active">전체</button>
                <button class="cat-btn">⚽ 운동/스포츠</button>
                <button class="cat-btn">📚 스터디</button>
                <button class="cat-btn">🎨 문화/예술</button>
                <button class="cat-btn">☕ 맛집/카페</button>
                <button class="cat-btn">🐶 반려동물</button>
            </div>

            <div class="filter-actions">
                <label class="toggle-recruiting">
                    <input type="checkbox" checked>
                    <span class="toggle-text">모집 중만 보기</span>
                </label>
                <select class="sort-select">
                    <option value="recent">최신순</option>
                    <option value="popular">인기순</option>
                    <option value="deadline">마감임박순</option>
                </select>
                <button class="btn-write" onclick="location.href='${pageContext.request.contextPath}/crew/write'">
                    <i class="ri-edit-line"></i> 크루 개설
                </button>
            </div>
        </section>

        <section class="crew-grid">
            <c:forEach var="i" begin="1" end="6">
                <article class="crew-card" onclick="location.href='${pageContext.request.contextPath}/crew/article?num=${i}'">
                    
                    <div class="card-thumb">
                        <img src="${pageContext.request.contextPath}/dist/images/bg.png" alt="썸네일">
                        <div class="status-badge recruiting">모집중</div>
                        <button class="wish-btn" onclick="event.stopPropagation();"><i class="ri-heart-3-line"></i></button>
                    </div>
                    
                    <div class="card-content">
                        <div class="meta-info">
                            <span class="category">운동/스포츠</span>
                            <span class="dot">·</span>
                            <span class="location"><i class="ri-map-pin-line"></i> 강남구 역삼동</span>
                        </div>
                        
                        <h3 class="title">매주 화요일 저녁 8시, 한강 야간 러닝 크루 모집합니다! 🏃‍♂️</h3>
                        
                        <div class="schedule-box">
                            <div class="schedule-item"><i class="ri-calendar-todo-line"></i> 매주 화/목 20:00</div>
                            <div class="schedule-item"><i class="ri-user-star-line"></i> 초보자 환영, 2030 직장인</div>
                        </div>

                        <div class="member-progress">
                            <div class="progress-text">
                                <span>참여 인원</span>
                                <strong>12<span class="max">/20명</span></strong>
                            </div>
                            <div class="progress-bar"><div class="fill" style="width: 60%;"></div></div>
                        </div>
                        
                        <div class="card-footer">
                            <div class="host">
                                <div class="host-img"><img src="${pageContext.request.contextPath}/dist/images/avatar.png" alt="방장"></div>
                                <span class="host-name">러닝조아</span>
                            </div>
                            <div class="stats">
                                <span><i class="ri-eye-line"></i> 245</span>
                                <span><i class="ri-chat-3-line"></i> 12</span>
                            </div>
                        </div>
                    </div>
                </article>
            </c:forEach>
        </section>

        <div class="page-navigation">
            ${paging}
        </div>
    </div>
</main>

<footer>
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
</footer>