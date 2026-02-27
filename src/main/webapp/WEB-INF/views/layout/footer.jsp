<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/footer.css">

<footer id="baton-footer">
    <div class="footer-container">
        <div class="footer-top">
            <div class="footer-brand">
                <h2 class="footer-logo">BATON</h2>
                <p class="brand-desc">
                    바톤은 이웃과 이웃을 잇는 따뜻한 바톤 터치를 꿈꿉니다.<br>
                    믿을 수 있는 동네 중고거래부터 새로운 즐거움이 가득한 동네 모임까지,<br>
                    우리의 일상을 더 가깝고 행복하게 연결합니다.
                </p>
                <div class="footer-sns">
                    <a href="#"><i class="ri-instagram-line"></i></a>
                    <a href="#"><i class="ri-facebook-circle-line"></i></a>
                    <a href="#"><i class="ri-youtube-line"></i></a>
                    <a href="#"><i class="ri-kakao-talk-line"></i></a>
                </div>
            </div>

            <div class="footer-links">
                <div class="link-group">
                    <h3>서비스</h3>
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/trade/list">중고거래</a></li>
                        <li><a href="${pageContext.request.contextPath}/crew/list">동네모임</a></li>
                        <li><a href="${pageContext.request.contextPath}/alba/list">알바구인</a></li>
                        <li><a href="${pageContext.request.contextPath}/community/list">커뮤니티</a></li>
                    </ul>
                </div>
                <div class="link-group">
                    <h3>고객지원</h3>
                    <ul>
                        <li><a href="#">공지사항</a></li>
                        <li><a href="#">자주 묻는 질문</a></li>
                        <li><a href="#">1:1 문의하기</a></li>
                        <li><a href="#">운영정책</a></li>
                    </ul>
                </div>
                <div class="link-group">
                    <h3>약관 및 정책</h3>
                    <ul>
                        <li><a href="#" class="emphasis">개인정보처리방침</a></li>
                        <li><a href="#">이용약관</a></li>
                        <li><a href="#">위치기반서비스 이용약관</a></li>
                        <li><a href="#">청소년보호정책</a></li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="footer-bottom">
            <div class="company-info">
                <div class="info-row">
                    <span>(주)바톤컴퍼니</span>
                    <span class="divider">|</span>
                    <span>대표이사 : 홍길동</span>
                    <span class="divider">|</span>
                    <span>사업자등록번호 : 123-45-67890</span>
                </div>
                <div class="info-row">
                    <span>주소 : 서울특별시 강남구 테헤란로 123, 바톤타워 15층</span>
                    <span class="divider">|</span>
                    <span>통신판매업신고 : 제 2026-서울강남-1234호</span>
                </div>
                <div class="info-row">
                    <span>고객센터 : 1588-1234 (평일 09:00 ~ 18:00)</span>
                    <span class="divider">|</span>
                    <span>이메일 : support@baton.co.kr</span>
                </div>
            </div>
            <p class="copyright">&copy; 2026 BATON Corp. All rights reserved.</p>
        </div>
    </div>
    <button id="btn-top" title="위로 가기"><i class="ri-arrow-up-line"></i></button>
</footer>

<script src="${pageContext.request.contextPath}/dist/js/footer.js"></script>