<%@ page contentType="text/html; charset=UTF-8"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/report/report-modal.css">
<div id="reportModal" class="report-modal-overlay" style="display:none;">
    <div class="report-modal-sheet">
        <div class="report-modal-head">
            <span class="report-modal-title">
                <i class="ri-alarm-warning-line"></i> 신고하기
            </span>
            <button type="button" class="report-modal-close" onclick="closeReportModal()">
                <i class="ri-close-line"></i>
            </button>
        </div>

        <div class="report-modal-body">
            <p class="report-modal-desc">신고 사유를 선택해주세요. 허위 신고는 제재를 받을 수 있습니다.</p>

            <div class="report-type-list">
                <label class="report-type-item">
                    <input type="radio" name="reportType" value="스팸">
                    <span class="report-type-label">
                        <i class="ri-spam-line"></i> 스팸 / 광고
                    </span>
                </label>
                <label class="report-type-item">
                    <input type="radio" name="reportType" value="욕설/비방">
                    <span class="report-type-label">
                        <i class="ri-emotion-unhappy-line"></i> 욕설 / 비방
                    </span>
                </label>
                <label class="report-type-item">
                    <input type="radio" name="reportType" value="음란물">
                    <span class="report-type-label">
                        <i class="ri-eye-off-line"></i> 음란물 / 불건전
                    </span>
                </label>
                <label class="report-type-item">
                    <input type="radio" name="reportType" value="사기">
                    <span class="report-type-label">
                        <i class="ri-error-warning-line"></i> 사기 / 허위 정보
                    </span>
                </label>
                <label class="report-type-item">
                    <input type="radio" name="reportType" value="개인정보침해">
                    <span class="report-type-label">
                        <i class="ri-user-forbid-line"></i> 개인정보 침해
                    </span>
                </label>
                <label class="report-type-item">
                    <input type="radio" name="reportType" value="기타">
                    <span class="report-type-label">
                        <i class="ri-more-line"></i> 기타
                    </span>
                </label>
            </div>

            <div class="report-content-wrap">
                <textarea id="reportContent" class="report-content-input"
                          placeholder="추가로 전달할 내용이 있으면 입력해주세요. (선택)"
                          maxlength="300"></textarea>
                <span class="report-content-count"><span id="reportContentCount">0</span>/300</span>
            </div>
        </div>

        <div class="report-modal-foot">
            <button type="button" class="report-btn-cancel" onclick="closeReportModal()">취소</button>
            <button type="button" class="report-btn-submit" onclick="submitReport()">신고 접수</button>
        </div>

        <input type="hidden" id="reportDomainType"      value="">
        <input type="hidden" id="reportTargetIdx"       value="">
        <input type="hidden" id="reportedUserIdx"       value="">
    </div>
</div>