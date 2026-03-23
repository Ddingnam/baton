<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<div id="chatbot-overlay" class="chatbot-overlay"></div>

<div id="chatbot-slide-panel" class="chatbot-slide-panel">

    <div class="csp-header">
        <div class="csp-header-left">
            <div class="csp-ai-avatar">
                <i class="ri-robot-2-line"></i>
                <span class="csp-online-dot"></span>
            </div>
            <div>
                <div class="csp-header-name">바톤 AI 가이드</div>
                <div class="csp-header-status">온라인 · 즉시 응답</div>
            </div>
        </div>
        <div class="csp-header-actions">
            <button class="csp-header-btn" id="csp-close-btn" title="닫기">
                <i class="ri-close-line"></i>
            </button>
        </div>
    </div>

    <div class="csp-messages" id="csp-messages">
        <div class="csp-msg-row csp-msg-bot">
            <div class="csp-bot-avatar"><i class="ri-robot-line"></i></div>
            <div class="csp-msg-content">
                <div class="csp-bubble">
                    안녕하세요! 😊<br>
                    바톤 이용에 대해 궁금하신 점이 있다면 편하게 물어보세요.<br>
                    <strong>결제, 배송, 거래 분쟁, 금지품목</strong> 모두 안내해드릴게요.
                </div>
                <div class="csp-msg-time">방금</div>
            </div>
        </div>
        <div class="csp-chips-wrap" id="csp-chips">
            <button class="csp-chip" data-chip="바톤 포인트가 뭔가요?">💰 바톤 포인트란?</button>
            <button class="csp-chip" data-chip="판매 금지 품목이 뭔가요?">🚫 금지 품목</button>
            <button class="csp-chip" data-chip="배송 중 물건이 파손됐어요">📦 파손 신고</button>
            <button class="csp-chip" data-chip="사기 피해를 당했어요">🆘 사기 신고</button>
            <button class="csp-chip" data-chip="회원 탈퇴 방법을 알려주세요">👤 회원 탈퇴</button>
        </div>
    </div>

    <div class="csp-input-area">
        <div class="csp-input-box">
            <textarea
                id="csp-input"
                class="csp-textarea"
                placeholder="메시지를 입력하세요..."
                rows="1"
            ></textarea>
            <button class="csp-send-btn" id="csp-send-btn" disabled>
                <i class="ri-send-plane-fill"></i>
            </button>
        </div>
        <div class="csp-input-footer">
            AI 답변은 참고용입니다. 복잡한 문제는
            <a href="${pageContext.request.contextPath}/about/support">고객센터</a>를 이용해주세요.
        </div>
    </div>

</div>
