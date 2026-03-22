<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/WEB-INF/views/layout/headerResources.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>이력서 작성 | BATON</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css"/>
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/main/main.css"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/resume/resume-write.css"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<main class="resume-write-container">
  <div class="page-header">
    <h1 class="page-title">새 이력서 작성</h1>
    <p class="page-desc">사장님께 나를 알릴 수 있는 이력서를 완성해보세요!</p>
  </div>

  <c:if test="${param.error eq 'true'}">
    <div class="alert-error">이력서 등록 중 오류가 발생했습니다. 다시 시도해주세요.</div>
  </c:if>

  <form action="${pageContext.request.contextPath}/resume/write" method="post" id="resumeForm">

    <!-- 이력서 제목 -->
    <section class="form-section">
      <h2 class="section-title">이력서 제목 <span class="required">*</span></h2>
      <input type="text" name="title" class="form-input text-lg"
             placeholder="예) 성실하고 시간 약속 잘 지키는 알바생입니다!" maxlength="200" required/>
    </section>

    <!-- 기본 정보 -->
    <section class="form-section">
      <h2 class="section-title">기본 정보</h2>
      <div class="info-grid">
        <div class="input-group">
          <label>이름</label>
          <input type="text" name="userName" class="form-input readonly"
                 value="${info.name}" readonly/>
        </div>
        <div class="input-group">
          <label>연락처 <span class="required">*</span></label>
          <input type="tel" name="phone" class="form-input"
                 placeholder="010-0000-0000" maxlength="20" required/>
        </div>
        <div class="input-group">
          <label>이메일</label>
          <input type="email" name="email" class="form-input"
                 value="${info.email}" placeholder="example@email.com" maxlength="100"/>
        </div>
        <div class="input-group">
          <label>생년월일</label>
          <input type="date" name="birth" class="form-input"/>
        </div>
      </div>
      <div class="input-group mt-8">
        <label>성별</label>
        <div class="radio-chip-group">
          <label class="radio-chip"><input type="radio" name="gender" value="M"/> <span>남성</span></label>
          <label class="radio-chip"><input type="radio" name="gender" value="F"/> <span>여성</span></label>
          <label class="radio-chip"><input type="radio" name="gender" value="" checked/> <span>선택 안함</span></label>
        </div>
      </div>
    </section>

    <!-- 자기소개 (AI 버튼 포함) -->
    <section class="form-section">
      <div class="section-title-row">
        <h2 class="section-title">자기소개</h2>
        <button type="button" class="btn-ai-open" id="btnAiOpen">
          <i class="ri-sparkling-2-line"></i> AI로 자동 작성
        </button>
      </div>
      <textarea name="introduce" id="introduceTextarea" class="form-textarea" rows="7"
                placeholder="간단한 자기소개, 지원 동기, 각오 등을 자유롭게 적어주세요.&#10;또는 위의 'AI로 자동 작성' 버튼을 눌러보세요!"></textarea>
    </section>

    <!-- 나의 장점 -->
    <section class="form-section">
      <h2 class="section-title">나의 장점</h2>
      <input type="text" name="strengths" class="form-input"
             placeholder="예) 빠른 적응력, 손님 응대 경험 있음, 체력 좋음" maxlength="1000"/>
    </section>

    <!-- 추가 정보 -->
    <section class="form-section">
      <h2 class="section-title">추가 정보 <span class="label-optional">(선택)</span></h2>
      <textarea name="additionalInfo" class="form-textarea" rows="4"
                placeholder="자격증, 보유 스킬, 특이사항 등 추가로 알리고 싶은 내용을 적어주세요."></textarea>
    </section>

    <div class="bottom-action-bar">
      <div class="action-inner">
        <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
        <button type="submit" class="btn-submit">이력서 등록 완료</button>
      </div>
    </div>
  </form>
</main>

<!-- ====== AI 자기소개서 모달 ====== -->
<div class="ai-modal-backdrop" id="aiModalBackdrop">
  <div class="ai-modal" id="aiModal">

    <!-- STEP 1: 키워드 선택 -->
    <div class="ai-step" id="aiStep1">
      <div class="ai-modal-header">
        <div class="ai-modal-title"><i class="ri-sparkling-2-line"></i> AI 자기소개서 작성</div>
        <p class="ai-modal-desc">나를 대표하는 키워드를 선택하면 AI가 자기소개서를 작성해드려요.</p>
        <button class="ai-modal-close" id="btnAiClose"><i class="ri-close-line"></i></button>
      </div>
      <div class="ai-modal-body">

        <!-- 업무 스킬 -->
        <div class="kw-section">
          <div class="kw-section-title kw-skill">업무 스킬</div>
          <div class="kw-chips" data-type="skill">
            <span class="kw-chip" data-value="고객 응대">고객 응대</span>
            <span class="kw-chip" data-value="재고 관리">재고 관리</span>
            <span class="kw-chip" data-value="상품 진열">상품 진열</span>
            <span class="kw-chip" data-value="매장 정리">매장 정리</span>
            <span class="kw-chip" data-value="포스기 사용">포스기 사용</span>
            <span class="kw-chip" data-value="음료 제조">음료 제조</span>
            <span class="kw-chip" data-value="음식 서빙">음식 서빙</span>
            <span class="kw-chip" data-value="주방 보조">주방 보조</span>
            <span class="kw-chip" data-value="문서 작업">문서 작업</span>
            <span class="kw-chip" data-value="엑셀 사용">엑셀 사용</span>
            <span class="kw-chip" data-value="전화 상담">전화 상담</span>
            <span class="kw-chip" data-value="상하차">상하차</span>
            <span class="kw-chip" data-value="배달">배달</span>
            <span class="kw-chip" data-value="포장">포장</span>
            <span class="kw-chip" data-value="택배 분류">택배 분류</span>
            <span class="kw-chip" data-value="그래픽 디자인">그래픽 디자인</span>
            <span class="kw-chip" data-value="영상 편집">영상 편집</span>
            <span class="kw-chip" data-value="개발">개발</span>
          </div>
        </div>

        <!-- 장점 -->
        <div class="kw-section">
          <div class="kw-section-title kw-strength">장점</div>
          <div class="kw-chips" data-type="strength">
            <span class="kw-chip" data-value="성실함">성실함</span>
            <span class="kw-chip" data-value="책임감">책임감</span>
            <span class="kw-chip" data-value="꼼꼼함">꼼꼼함</span>
            <span class="kw-chip" data-value="약속을 잘 지킴">약속을 잘 지킴</span>
            <span class="kw-chip" data-value="적극적">적극적</span>
            <span class="kw-chip" data-value="친절함">친절함</span>
            <span class="kw-chip" data-value="협업 능력">협업 능력</span>
            <span class="kw-chip" data-value="원활한 커뮤니케이션">원활한 커뮤니케이션</span>
            <span class="kw-chip" data-value="순발력">순발력</span>
            <span class="kw-chip" data-value="긍정적인 태도">긍정적인 태도</span>
            <span class="kw-chip" data-value="배려심">배려심</span>
            <span class="kw-chip" data-value="문제 해결 능력">문제 해결 능력</span>
            <span class="kw-chip" data-value="예의 바름">예의 바름</span>
            <span class="kw-chip" data-value="외국어 가능">외국어 가능</span>
            <span class="kw-chip" data-value="운전 능숙">운전 능숙</span>
            <span class="kw-chip" data-value="컴퓨터 능숙">컴퓨터 능숙</span>
          </div>
        </div>

        <!-- 입사 후 포부 -->
        <div class="kw-section">
          <div class="kw-section-title kw-goal">입사 후 포부</div>
          <div class="kw-chips" data-type="goal">
            <span class="kw-chip" data-value="신뢰성">신뢰성</span>
            <span class="kw-chip" data-value="고객 중심적">고객 중심적</span>
            <span class="kw-chip" data-value="목표 달성">목표 달성</span>
            <span class="kw-chip" data-value="긍정적">긍정적</span>
            <span class="kw-chip" data-value="도전 정신">도전 정신</span>
            <span class="kw-chip" data-value="장기 근속">장기 근속</span>
            <span class="kw-chip" data-value="지속적인 자기계발">지속적인 자기계발</span>
            <span class="kw-chip" data-value="자기주도적">자기주도적</span>
            <span class="kw-chip" data-value="빠른 적응력">빠른 적응력</span>
            <span class="kw-chip" data-value="조직 기여">조직 기여</span>
            <span class="kw-chip" data-value="창의적 사고">창의적 사고</span>
            <span class="kw-chip" data-value="전문성 강화">전문성 강화</span>
            <span class="kw-chip" data-value="성장 지향">성장 지향</span>
          </div>
        </div>

      </div>
      <div class="ai-modal-footer">
        <span class="kw-selected-count">선택된 키워드: <strong id="kwCount">0</strong>개</span>
        <button type="button" class="btn-ai-generate" id="btnGenerate" disabled>
          <i class="ri-sparkling-2-line"></i> 자기소개서 생성하기
        </button>
      </div>
    </div>

    <!-- STEP 2: 생성 중 / 결과 -->
    <div class="ai-step" id="aiStep2" style="display:none;">
      <div class="ai-modal-header">
        <div class="ai-modal-title"><i class="ri-sparkling-2-line"></i> AI 자기소개서 작성 중...</div>
        <button class="ai-modal-close" id="btnAiClose2"><i class="ri-close-line"></i></button>
      </div>
      <div class="ai-modal-body ai-result-body">
        <div class="ai-loading" id="aiLoading">
          <div class="ai-loading-dots">
            <span></span><span></span><span></span>
          </div>
          <p>AI가 자기소개서를 작성하고 있어요...</p>
        </div>
        <div class="ai-result-box" id="aiResultBox" style="display:none;">
          <div class="ai-result-label"><i class="ri-sparkling-2-line"></i> AI가 작성한 자기소개서</div>
          <textarea class="ai-result-textarea" id="aiResultText" rows="10"></textarea>
        </div>
      </div>
      <div class="ai-modal-footer" id="aiResultFooter" style="display:none;">
        <button type="button" class="btn-ai-back" id="btnAiBack">
          <i class="ri-arrow-left-line"></i> 다시 선택
        </button>
        <button type="button" class="btn-ai-apply" id="btnApply">
          <i class="ri-check-line"></i> 이 내용으로 적용하기
        </button>
      </div>
    </div>

  </div>
</div>
<!-- ====== /AI 모달 끝 ====== -->

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>

<style>
.alert-error{background:#FEF2F2;color:#DC2626;border:1px solid #FECACA;border-radius:8px;padding:14px 18px;margin-bottom:20px;font-size:14px;}
.label-optional{font-size:13px;font-weight:400;color:#9CA3AF;}
.mt-8{margin-top:8px;}

.section-title-row{display:flex;align-items:center;justify-content:space-between;margin-bottom:12px;}
.section-title-row .section-title{margin-bottom:0;}
.btn-ai-open{display:inline-flex;align-items:center;gap:6px;padding:8px 14px;background:linear-gradient(135deg,#667eea,#764ba2);color:#fff;border:none;border-radius:20px;font-size:13px;font-weight:700;cursor:pointer;transition:opacity .2s;}
.btn-ai-open:hover{opacity:.85;}
.btn-ai-open i{font-size:15px;}

.ai-modal-backdrop {
  display: none;
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.6);
  z-index: 9999;
  align-items: center;
  justify-content: center;
  padding: 20px;
  box-sizing: border-box;
}
.ai-modal-backdrop.open {
  display: flex;
}

.ai-modal {
  background: #fff;
  border-radius: 16px;
  width: 100%;
  max-width: 640px;
  max-height: 90vh; 
  display: flex;
  flex-direction: column;
  overflow: hidden;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.25);
}

.ai-step {
  display: flex;
  flex-direction: column;
  flex: 1;
  min-height: 0;
  height: 100%;
}

.ai-modal-header {
  padding: 22px 28px 0;
  position: relative;
  flex-shrink: 0;
}
.ai-modal-title { font-size: 18px; font-weight: 800; color: #111827; display: flex; align-items: center; gap: 8px; margin-bottom: 6px; }
.ai-modal-title i { background: linear-gradient(135deg, #667eea, #764ba2); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
.ai-modal-desc { font-size: 13px; color: #6B7280; margin-bottom: 14px; }
.ai-modal-close { position: absolute; top: 20px; right: 20px; background: none; border: none; font-size: 22px; color: #9CA3AF; cursor: pointer; padding: 4px; }
.ai-modal-close:hover { color: #374151; }

.ai-modal-body {
  flex: 1;
  overflow-y: auto;
  padding: 0 28px 16px;
  min-height: 0;
}
.ai-result-body { padding: 20px 28px; }

.kw-section { margin-bottom: 20px; }
.kw-section-title { font-size: 13px; font-weight: 700; padding: 4px 10px; border-radius: 4px; display: inline-block; margin-bottom: 10px; }
.kw-skill { background: #EFF6FF; color: #1D4ED8; }
.kw-strength { background: #F0FDF4; color: #166534; }
.kw-goal { background: #FDF4FF; color: #7E22CE; }
.kw-chips { display: flex; flex-wrap: wrap; gap: 8px; }
.kw-chip { display: inline-block; padding: 7px 14px; border: 1.5px solid #E5E7EB; border-radius: 20px; font-size: 13px; color: #374151; cursor: pointer; transition: all .15s; user-select: none; }
.kw-chip:hover { border-color: #667eea; color: #667eea; }
.kw-chip.selected { background: linear-gradient(135deg, #667eea, #764ba2); border-color: transparent; color: #fff; font-weight: 700; }

.ai-modal-footer {
  padding: 16px 28px;
  border-top: 1px solid #F3F4F6;
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-shrink: 0;
  background: #fff;
}
.kw-selected-count { font-size: 13px; color: #6B7280; }
.kw-selected-count strong { color: #667eea; font-weight: 700; }
.btn-ai-generate { display: inline-flex; align-items: center; gap: 6px; padding: 12px 22px; background: linear-gradient(135deg, #667eea, #764ba2); color: #fff; border: none; border-radius: 10px; font-size: 14px; font-weight: 700; cursor: pointer; }
.btn-ai-generate:disabled { background: #D1D5DB; cursor: not-allowed; }
.btn-ai-generate:not(:disabled):hover { opacity: .88; }

.ai-loading { text-align: center; padding: 40px 20px; }
.ai-loading p { font-size: 14px; color: #6B7280; margin-top: 16px; }
.ai-loading-dots { display: flex; justify-content: center; gap: 8px; }
.ai-loading-dots span { width: 10px; height: 10px; border-radius: 50%; background: linear-gradient(135deg, #667eea, #764ba2); animation: dotBounce 1.2s infinite ease-in-out; }
.ai-loading-dots span:nth-child(2) { animation-delay: .2s; }
.ai-loading-dots span:nth-child(3) { animation-delay: .4s; }
@keyframes dotBounce { 0%, 80%, 100% { transform: scale(0); } 40% { transform: scale(1); } }
.ai-result-label { font-size: 13px; font-weight: 700; color: #667eea; margin-bottom: 10px; display: flex; align-items: center; gap: 5px; }
.ai-result-textarea { width: 100%; border: 1.5px solid #E5E7EB; border-radius: 10px; padding: 14px; font-size: 14px; line-height: 1.75; resize: vertical; font-family: inherit; color: #111827; outline: none; }
.ai-result-textarea:focus { border-color: #667eea; }
.btn-ai-back { display: inline-flex; align-items: center; gap: 6px; padding: 11px 18px; background: #F3F4F6; border: none; border-radius: 8px; font-size: 14px; font-weight: 600; color: #374151; cursor: pointer; }
.btn-ai-back:hover { background: #E5E7EB; }
.btn-ai-apply { display: inline-flex; align-items: center; gap: 6px; padding: 12px 22px; background: linear-gradient(135deg, #667eea, #764ba2); color: #fff; border: none; border-radius: 10px; font-size: 14px; font-weight: 700; cursor: pointer; }
.btn-ai-apply:hover { opacity: .88; }
</style>

<script>
const backdrop   = document.getElementById('aiModalBackdrop');
const step1      = document.getElementById('aiStep1');
const step2      = document.getElementById('aiStep2');
const kwCount    = document.getElementById('kwCount');
const btnGenerate= document.getElementById('btnGenerate');
const aiLoading  = document.getElementById('aiLoading');
const aiResultBox= document.getElementById('aiResultBox');
const aiResultFooter = document.getElementById('aiResultFooter');
const aiResultText   = document.getElementById('aiResultText');
const introduceTA    = document.getElementById('introduceTextarea');

// 모달 열기/닫기
document.getElementById('btnAiOpen').addEventListener('click', () => {
  backdrop.classList.add('open');
});
function closeModal() { backdrop.classList.remove('open'); }
document.getElementById('btnAiClose').addEventListener('click', closeModal);
document.getElementById('btnAiClose2').addEventListener('click', closeModal);
backdrop.addEventListener('click', e => { if (e.target === backdrop) closeModal(); });

// 키워드 칩 토글
let selectedKeywords = [];
document.querySelectorAll('.kw-chip').forEach(chip => {
  chip.addEventListener('click', () => {
    const val = chip.dataset.value;
    chip.classList.toggle('selected');
    if (chip.classList.contains('selected')) {
      selectedKeywords.push(val);
    } else {
      selectedKeywords = selectedKeywords.filter(k => k !== val);
    }
    kwCount.textContent = selectedKeywords.length;
    btnGenerate.disabled = selectedKeywords.length === 0;
  });
});

// 뒤로가기
document.getElementById('btnAiBack').addEventListener('click', () => {
  step2.style.display = 'none';
  step1.style.display = 'flex';
  step1.style.flexDirection = 'column';
  aiLoading.style.display = 'block';
  aiResultBox.style.display = 'none';
  aiResultFooter.style.display = 'none';
  aiResultText.value = '';
});

//생성하기
btnGenerate.addEventListener('click', async () => {
  step1.style.display = 'none';
  step2.style.display = 'flex';
  step2.style.flexDirection = 'column';
  aiLoading.style.display = 'block';
  aiResultBox.style.display = 'none';
  aiResultFooter.style.display = 'none';

  // 키워드 분류
  const skillChips    = [...document.querySelectorAll('.kw-chips[data-type="skill"]    .kw-chip.selected')].map(c => c.dataset.value);
  const strengthChips = [...document.querySelectorAll('.kw-chips[data-type="strength"] .kw-chip.selected')].map(c => c.dataset.value);
  const goalChips     = [...document.querySelectorAll('.kw-chips[data-type="goal"]     .kw-chip.selected')].map(c => c.dataset.value);

  try {
    // 💡 백엔드(Spring Controller)로 요청을 보냅니다.
    const response = await fetch('${pageContext.request.contextPath}/api/alba/generate-resume', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        skills: skillChips,
        strengths: strengthChips,
        goals: goalChips
      })
    });

    if (!response.ok) {
        throw new Error('서버 응답 오류');
    }

    // 💡 백엔드에서 생성해준 텍스트 결과를 받아옵니다.
    const text = await response.text();

    aiResultText.value = text;
    aiLoading.style.display = 'none';
    aiResultBox.style.display = 'block';
    aiResultFooter.style.display = 'flex';

    // step2 헤더 타이틀 변경
    step2.querySelector('.ai-modal-title').innerHTML = '<i class="ri-sparkling-2-line"></i> AI 자기소개서 완성!';

  } catch (err) {
    console.error(err);
    aiResultText.value = '오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
    aiLoading.style.display = 'none';
    aiResultBox.style.display = 'block';
    aiResultFooter.style.display = 'flex';
  }
});

// 적용하기
document.getElementById('btnApply').addEventListener('click', () => {
  introduceTA.value = aiResultText.value;
  closeModal();
  introduceTA.scrollIntoView({ behavior: 'smooth', block: 'center' });
  // 살짝 하이라이트
  introduceTA.style.borderColor = '#667eea';
  setTimeout(() => { introduceTA.style.borderColor = ''; }, 2000);
});
</script>
</body>
</html>
