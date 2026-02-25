<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<aside class="mypage-sidebar">
    
    <div class="sidebar-profile">
        <div class="profile-avatar"><i class="ri-user-smile-fill"></i></div>
        <div class="profile-info">
            <span class="name">${sessionScope.member.userName != null ? sessionScope.member.userName : '박바통'}</span>
            <span class="manner">매너온도 36.5℃</span>
        </div>
    </div>

    <nav class="sidebar-nav">
        <div class="nav-group">
            <h4>나의 거래</h4>
            <a href="${pageContext.request.contextPath}/mypage/trade/buy" class="nav-item active">
                <i class="ri-shopping-bag-3-line"></i> 구매 내역
            </a>
            <a href="${pageContext.request.contextPath}/mypage/trade/sell" class="nav-item">
                <i class="ri-hand-coin-line"></i> 판매 내역
            </a>
            <a href="${pageContext.request.contextPath}/mypage/trade/wish" class="nav-item">
                <i class="ri-heart-3-line"></i> 관심 목록
            </a>
        </div>

        <div class="nav-group">
            <h4>나의 모임</h4>
            <a href="${pageContext.request.contextPath}/mypage/club/my" class="nav-item">
                <i class="ri-team-line"></i> 참여 중인 모임
            </a>
            <a href="${pageContext.request.contextPath}/mypage/club/host" class="nav-item">
                <i class="ri-mickey-line"></i> 주최한 모임
            </a>
        </div>

        <div class="nav-group">
            <h4>나의 알바</h4>
            <a href="${pageContext.request.contextPath}/mypage/alba/apply" class="nav-item">
                <i class="ri-file-list-3-line"></i> 지원 현황
            </a>
            <a href="${pageContext.request.contextPath}/mypage/alba/post" class="nav-item">
                <i class="ri-building-4-line"></i> 공고 관리
            </a>
        </div>

        <div class="nav-group">
            <h4>커뮤니티</h4>
            <a href="${pageContext.request.contextPath}/mypage/community/posts" class="nav-item">
                <i class="ri-edit-line"></i> 작성한 글
            </a>
        </div>

        <div class="nav-group">
            <h4>설정</h4>
            <a href="${pageContext.request.contextPath}/member/pwd" class="nav-item">
                <i class="ri-settings-3-line"></i> 내 정보 수정
            </a>
        </div>
    </nav>
</aside>