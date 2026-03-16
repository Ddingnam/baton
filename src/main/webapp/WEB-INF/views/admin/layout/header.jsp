<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<header class="agency-header">
    <div class="head-left">
        <button id="sidebarToggle" class="toggle-icon"><i class="ri-menu-4-fill"></i></button>
    </div>

    <div class="head-center" id="systemUtilityTrigger">
        <span id="systemClock"></span>
    </div>

    <div class="head-right">
        <div class="noti-btn" id="notiTrigger">
            <i class="ri-notification-3-fill"></i>
            <div class="noti-ring"></div>
        </div>

        <div class="user-avt-btn" id="profileTrigger">A</div>

        <div class="pop-modal" id="profileModal">
            <div class="sq-user">
                <div class="sq-avt">AD</div>
                <div class="sq-info">
                    <span class="sq-name">Admin User</span>
                    <span class="sq-role">Super Admin</span>
                </div>
            </div>
            <div class="sq-grid">
                <div class="sq-box" onclick="window.open('${pageContext.request.contextPath}/')">
                    <i class="ri-window-fill"></i>사이트
                </div>
                <div class="sq-box" id="setupTrigger">
                    <i class="ri-equalizer-fill"></i>설정
                </div>
                <div class="sq-box" id="myProfileTrigger">
                    <i class="ri-user-settings-fill"></i>프로필
                </div>
                <div class="sq-box red" onclick="location.href='${pageContext.request.contextPath}/member/logout'">
                    <i class="ri-shut-down-line"></i>로그아웃
                </div>
            </div>
        </div>

        <div class="pop-modal noti-modal" id="notiModal">
            <div class="noti-modal-head">
                <span class="noti-modal-title">알림</span>
                <button class="noti-read-all">모두 읽음</button>
            </div>
            <div class="noti-list">
                <div class="noti-item unread">
                    <div class="noti-icon-wrap bg-orange"><i class="ri-error-warning-fill"></i></div>
                    <div class="noti-content">
                        <p class="noti-text"><strong>신규 신고</strong>가 접수되었습니다</p>
                        <span class="noti-meta">커뮤니티 · 5분 전</span>
                    </div>
                    <div class="noti-dot"></div>
                </div>
                <div class="noti-item unread">
                    <div class="noti-icon-wrap bg-purple"><i class="ri-refund-2-fill"></i></div>
                    <div class="noti-content">
                        <p class="noti-text">환불 요청이 <strong>2건</strong> 대기 중입니다</p>
                        <span class="noti-meta">결제 · 22분 전</span>
                    </div>
                    <div class="noti-dot"></div>
                </div>
                <div class="noti-item unread">
                    <div class="noti-icon-wrap bg-blue"><i class="ri-customer-service-2-fill"></i></div>
                    <div class="noti-content">
                        <p class="noti-text">미답변 <strong>1:1 문의</strong>가 있습니다</p>
                        <span class="noti-meta">고객센터 · 1시간 전</span>
                    </div>
                    <div class="noti-dot"></div>
                </div>
                <div class="noti-item">
                    <div class="noti-icon-wrap bg-green"><i class="ri-user-add-fill"></i></div>
                    <div class="noti-content">
                        <p class="noti-text">신규 회원 <strong>127명</strong>이 가입했습니다</p>
                        <span class="noti-meta">회원 · 어제</span>
                    </div>
                </div>
                <div class="noti-item">
                    <div class="noti-icon-wrap bg-pink"><i class="ri-shield-check-fill"></i></div>
                    <div class="noti-content">
                        <p class="noti-text">시스템 <strong>보안 점검</strong>이 완료되었습니다</p>
                        <span class="noti-meta">시스템 · 2일 전</span>
                    </div>
                </div>
            </div>
            <div class="noti-footer">
                <a href="${pageContext.request.contextPath}/admin/notifications" class="noti-all-link">전체 알림 보기 <i class="ri-arrow-right-line"></i></a>
            </div>
        </div>
    </div>
</header>

<div class="huge-modal" id="systemUtilityModal">
    <div class="wg-box">
        <div class="wg-tl">
            <span id="modalMonth"></span>
            <div class="cal-nav">
                <button class="cal-nav-btn" id="calPrev"><i class="ri-arrow-left-s-line"></i></button>
                <button class="cal-nav-btn" id="calToday"><i class="ri-calendar-event-fill" style="color:var(--color-purple);"></i></button>
                <button class="cal-nav-btn" id="calNext"><i class="ri-arrow-right-s-line"></i></button>
            </div>
        </div>
        <div class="cal-wrap" id="miniCalGrid"></div>
    </div>

    <div class="wg-box">
        <div class="wg-tl">팀 현황<span class="team-count-badge">5명</span></div>
        <div class="team-rows">
            <div class="t-row">
                <div class="t-avt">OD</div>
                <div class="t-info">오다은</div>
                <div class="t-status-pill online"><span class="t-status-dot"></span>온라인</div>
            </div>
            <div class="t-row">
                <div class="t-avt">JY</div>
                <div class="t-info">이지영</div>
                <div class="t-status-pill online"><span class="t-status-dot"></span>온라인</div>
            </div>
            <div class="t-row">
                <div class="t-avt">HN</div>
                <div class="t-info">최하늘</div>
                <div class="t-status-pill online"><span class="t-status-dot"></span>온라인</div>
            </div>
            <div class="t-row">
                <div class="t-avt">MN</div>
                <div class="t-info" style="color:var(--text-light);">정명남</div>
                <div class="t-status-pill away"><span class="t-status-dot"></span>자리비움</div>
            </div>
            <div class="t-row">
                <div class="t-avt">HS</div>
                <div class="t-info" style="color:var(--text-light);">함형서</div>
                <div class="t-status-pill away"><span class="t-status-dot"></span>자리비움</div>
            </div>
        </div>
    </div>

    <div class="wg-box">
        <div class="wg-tl">세계 시각</div>
        <div class="wt-row"><span class="wt-lbl">서울</span><span class="wt-val" id="timeSeoul"></span></div>
        <div class="wt-row"><span class="wt-lbl">뉴욕</span><span class="wt-val" id="timeNY"></span></div>
        <div class="wt-row"><span class="wt-lbl">런던</span><span class="wt-val" id="timeLDN"></span></div>
    </div>

    <div class="wg-box">
        <div class="wg-tl">메모장</div>
        <textarea class="memo-pad" placeholder="간단히 메모하세요..."></textarea>
    </div>
</div>

<div class="fullscreen-overlay" id="setupOverlay">
    <div class="fullscreen-modal" id="setupModal">
        <div class="fm-sidebar">
            <div class="fm-brand">설정</div>
            <nav class="fm-nav">
                <button class="fm-nav-item active" data-tab="system">
                    <i class="ri-settings-4-fill"></i>시스템
                </button>
                <button class="fm-nav-item" data-tab="appearance">
                    <i class="ri-palette-fill"></i>테마 / 언어
                </button>
                <button class="fm-nav-item" data-tab="permissions">
                    <i class="ri-shield-user-fill"></i>권한 관리
                </button>
                <button class="fm-nav-item" data-tab="notifications">
                    <i class="ri-notification-4-fill"></i>알림 설정
                </button>
            </nav>
        </div>
        <div class="fm-content">
            <button class="fm-close" id="setupClose"><i class="ri-close-line"></i></button>

            <div class="fm-tab active" id="tab-system">
                <h2 class="fm-tab-title">시스템 설정</h2>
                <p class="fm-tab-desc">BATON Studio 운영 환경을 구성합니다.</p>
                <div class="fm-section">
                    <div class="fm-field">
                        <label class="fm-label">사이트명</label>
                        <input type="text" class="fm-input" value="BATON" placeholder="사이트명 입력">
                    </div>
                    <div class="fm-field">
                        <label class="fm-label">관리자 이메일</label>
                        <input type="email" class="fm-input" value="admin@baton.kr" placeholder="이메일 주소">
                    </div>
                    <div class="fm-field">
                        <label class="fm-label">세션 만료 시간</label>
                        <select class="fm-input">
                            <option>30분</option>
                            <option selected>1시간</option>
                            <option>2시간</option>
                            <option>무제한</option>
                        </select>
                    </div>
                    <div class="fm-field">
                        <label class="fm-label">유지보수 모드</label>
                        <div class="fm-toggle-row">
                            <span class="fm-toggle-desc">활성화 시 일반 사용자 접근이 차단됩니다.</span>
                            <label class="fm-toggle">
                                <input type="checkbox">
                                <span class="fm-toggle-track"></span>
                            </label>
                        </div>
                    </div>
                </div>
                <div class="fm-actions">
                    <button class="btn-pill btn-gradient">변경사항 저장</button>
                </div>
            </div>

            <div class="fm-tab" id="tab-appearance">
                <h2 class="fm-tab-title">테마 / 언어</h2>
                <p class="fm-tab-desc">관리자 페이지의 표시 설정을 변경합니다.</p>
                <div class="fm-section">
                    <div class="fm-field">
                        <label class="fm-label">인터페이스 언어</label>
                        <select class="fm-input">
                            <option selected>한국어</option>
                            <option>English</option>
                        </select>
                    </div>
                    <div class="fm-field">
                        <label class="fm-label">컬러 테마</label>
                        <div class="fm-theme-row">
                            <button class="fm-theme-chip active" style="background:linear-gradient(135deg,#7C3AED,#EC4899)">기본</button>
                            <button class="fm-theme-chip" style="background:linear-gradient(135deg,#3B82F6,#06B6D4)">블루</button>
                            <button class="fm-theme-chip" style="background:linear-gradient(135deg,#10B981,#3B82F6)">그린</button>
                            <button class="fm-theme-chip" style="background:linear-gradient(135deg,#F59E0B,#EF4444)">선셋</button>
                        </div>
                    </div>
                    <div class="fm-field">
                        <label class="fm-label">다크 모드</label>
                        <div class="fm-toggle-row">
                            <span class="fm-toggle-desc">준비 중인 기능입니다.</span>
                            <label class="fm-toggle">
                                <input type="checkbox" disabled>
                                <span class="fm-toggle-track disabled"></span>
                            </label>
                        </div>
                    </div>
                </div>
                <div class="fm-actions">
                    <button class="btn-pill btn-gradient">변경사항 저장</button>
                </div>
            </div>

            <div class="fm-tab" id="tab-permissions">
                <h2 class="fm-tab-title">권한 관리</h2>
                <p class="fm-tab-desc">관리자 등급별 접근 권한을 확인합니다.</p>
                <div class="fm-section">
                    <div class="perm-table-wrap">
                        <table class="perm-table">
                            <thead>
                                <tr>
                                    <th>등급</th>
                                    <th>설명</th>
                                    <th>현재 인원</th>
                                    <th>상태</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><span class="perm-badge super">Super Admin</span></td>
                                    <td>모든 권한 보유</td>
                                    <td>1명</td>
                                    <td><span class="tag tag-green">활성</span></td>
                                </tr>
                                <tr>
                                    <td><span class="perm-badge manager">Manager</span></td>
                                    <td>회원/거래 관리</td>
                                    <td>3명</td>
                                    <td><span class="tag tag-green">활성</span></td>
                                </tr>
                                <tr>
                                    <td><span class="perm-badge cs">CS Staff</span></td>
                                    <td>고객센터 담당</td>
                                    <td>2명</td>
                                    <td><span class="tag tag-blue">대기</span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div class="fm-tab" id="tab-notifications">
                <h2 class="fm-tab-title">알림 설정</h2>
                <p class="fm-tab-desc">수신할 알림 유형을 선택합니다.</p>
                <div class="fm-section">
                    <div class="fm-field">
                        <label class="fm-label">신규 신고 접수</label>
                        <div class="fm-toggle-row">
                            <span class="fm-toggle-desc">커뮤니티/거래 신고 발생 시 알림</span>
                            <label class="fm-toggle"><input type="checkbox" checked><span class="fm-toggle-track"></span></label>
                        </div>
                    </div>
                    <div class="fm-field">
                        <label class="fm-label">환불 요청</label>
                        <div class="fm-toggle-row">
                            <span class="fm-toggle-desc">미처리 환불 요청 알림</span>
                            <label class="fm-toggle"><input type="checkbox" checked><span class="fm-toggle-track"></span></label>
                        </div>
                    </div>
                    <div class="fm-field">
                        <label class="fm-label">1:1 문의</label>
                        <div class="fm-toggle-row">
                            <span class="fm-toggle-desc">미답변 문의 발생 시 알림</span>
                            <label class="fm-toggle"><input type="checkbox" checked><span class="fm-toggle-track"></span></label>
                        </div>
                    </div>
                    <div class="fm-field">
                        <label class="fm-label">신규 회원 가입</label>
                        <div class="fm-toggle-row">
                            <span class="fm-toggle-desc">일별 가입자 요약 알림</span>
                            <label class="fm-toggle"><input type="checkbox"><span class="fm-toggle-track"></span></label>
                        </div>
                    </div>
                </div>
                <div class="fm-actions">
                    <button class="btn-pill btn-gradient">변경사항 저장</button>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="fullscreen-overlay" id="profileOverlay">
    <div class="fullscreen-modal profile-modal-wrap" id="profileFullModal">
        <div class="fm-sidebar">
            <div class="fm-brand">프로필</div>
            <nav class="fm-nav">
                <button class="fm-nav-item active" data-ptab="info">
                    <i class="ri-user-fill"></i>내 정보
                </button>
                <button class="fm-nav-item" data-ptab="password">
                    <i class="ri-lock-password-fill"></i>비밀번호
                </button>
                <button class="fm-nav-item" data-ptab="grade">
                    <i class="ri-shield-star-fill"></i>권한 등급
                </button>
            </nav>
        </div>
        <div class="fm-content">
            <button class="fm-close" id="profileFullClose"><i class="ri-close-line"></i></button>

            <div class="fm-tab active" id="ptab-info">
                <h2 class="fm-tab-title">내 정보 수정</h2>
                <p class="fm-tab-desc">프로필 사진과 이름, 닉네임을 변경합니다.</p>
                <div class="fm-section">
                    <div class="profile-avatar-edit">
                        <div class="profile-av-circle">AD</div>
                        <div class="profile-av-actions">
                            <button class="btn-pill btn-light" style="font-size:13px;padding:8px 16px;">사진 변경</button>
                            <button class="btn-text" style="font-size:13px;">삭제</button>
                        </div>
                    </div>
                    <div class="fm-field">
                        <label class="fm-label">이름</label>
                        <input type="text" class="fm-input" value="관리자" placeholder="이름 입력">
                    </div>
                    <div class="fm-field">
                        <label class="fm-label">닉네임</label>
                        <input type="text" class="fm-input" value="Admin" placeholder="닉네임 입력">
                    </div>
                    <div class="fm-field">
                        <label class="fm-label">이메일</label>
                        <input type="email" class="fm-input" value="admin@baton.kr" placeholder="이메일">
                    </div>
                </div>
                <div class="fm-actions">
                    <button class="btn-pill btn-gradient">저장하기</button>
                </div>
            </div>

            <div class="fm-tab" id="ptab-password">
                <h2 class="fm-tab-title">비밀번호 변경</h2>
                <p class="fm-tab-desc">보안을 위해 주기적으로 비밀번호를 변경하세요.</p>
                <div class="fm-section">
                    <div class="fm-field">
                        <label class="fm-label">현재 비밀번호</label>
                        <input type="password" class="fm-input" placeholder="현재 비밀번호 입력">
                    </div>
                    <div class="fm-field">
                        <label class="fm-label">새 비밀번호</label>
                        <input type="password" class="fm-input" placeholder="8자 이상, 영문+숫자+특수문자">
                    </div>
                    <div class="fm-field">
                        <label class="fm-label">비밀번호 확인</label>
                        <input type="password" class="fm-input" placeholder="새 비밀번호 재입력">
                    </div>
                </div>
                <div class="fm-actions">
                    <button class="btn-pill btn-gradient">변경하기</button>
                </div>
            </div>

            <div class="fm-tab" id="ptab-grade">
                <h2 class="fm-tab-title">내 권한 등급</h2>
                <p class="fm-tab-desc">현재 계정에 부여된 권한 정보입니다.</p>
                <div class="fm-section">
                    <div class="grade-card">
                        <div class="grade-icon"><i class="ri-shield-star-fill"></i></div>
                        <div class="grade-info">
                            <span class="grade-title">Super Admin</span>
                            <span class="grade-desc">모든 메뉴 접근 및 설정 변경 가능</span>
                        </div>
                    </div>
                    <div class="perm-list">
                        <div class="perm-row"><i class="ri-check-line"></i><span>회원 관리 (조회/제재/탈퇴 처리)</span></div>
                        <div class="perm-row"><i class="ri-check-line"></i><span>거래 및 커뮤니티 관리</span></div>
                        <div class="perm-row"><i class="ri-check-line"></i><span>고객센터 문의 답변</span></div>
                        <div class="perm-row"><i class="ri-check-line"></i><span>시스템 설정 변경</span></div>
                        <div class="perm-row"><i class="ri-check-line"></i><span>관리자 권한 부여/회수</span></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
