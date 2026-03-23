<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ include file="/WEB-INF/views/layout/headerResources.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>나의 이력서 | BATON</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css"/>
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/main/main.css"/>
<style>
/* 기존 테마 변수 유지 */
:root {
  --primary: #002C5F; 
  --primary-light: #EEF3FA; 
  --bg: #F7F9FC; 
  --surface: #fff; 
  --text: #111827; 
  --sub: #4A5568; 
  --border: #E2E8F0; 
  --radius: 12px;
}
body { background: var(--bg); font-family: 'Pretendard', sans-serif; }

/* 레이아웃 (테이블이 들어가야 해서 가로를 살짝 넓힘) */
.wrap { max-width: 1000px; margin: 0 auto; padding: 100px 20px 60px; }
.top-bar { display: flex; align-items: center; justify-content: space-between; margin-bottom: 24px; }
.page-title { font-size: 24px; font-weight: 800; color: var(--text); margin: 0; }
.btn-new { display: inline-flex; align-items: center; gap: 6px; padding: 10px 18px; background: var(--primary); color: #fff; border: none; border-radius: 8px; font-size: 14px; font-weight: 700; cursor: pointer; text-decoration: none; transition: 0.2s; }
.btn-new:hover { background: #1a4a8a; }

.count-info { font-size: 14px; color: var(--sub); margin-bottom: 16px; font-weight: 500; }
.count-info strong { color: var(--primary); }

/* 모던 테이블 컨테이너 (기존 카드 느낌 적용) */
.table-container {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  box-shadow: 0 2px 8px rgba(0,0,0,0.03);
  overflow: hidden; /* 테두리 둥글게 깎기 위함 */
  margin-bottom: 20px;
}

/* 테이블 디자인 */
.resume-table { width: 100%; border-collapse: collapse; text-align: center; }
.resume-table th {
  background: #F8FAFC;
  padding: 16px 12px;
  font-size: 14px;
  font-weight: 700;
  color: var(--sub);
  border-bottom: 1px solid var(--border);
  white-space: nowrap; /* 헤더 글자 줄바꿈 방지 */
}
.resume-table td {
  padding: 18px 12px;
  font-size: 14px;
  color: var(--text);
  border-bottom: 1px solid var(--border);
  vertical-align: middle;
}
.resume-table tbody tr:last-child td { border-bottom: none; }
.resume-table tbody tr:hover { background: var(--bg); }

/* 제목 영역 좌측 정렬 및 강조 */
.resume-table .title--row { text-align: left; padding-left: 24px; }
.resume-table .title--row a { font-size: 16px; font-weight: 700; color: var(--text); text-decoration: none; display: block; margin-bottom: 4px; transition: 0.2s; }
.resume-table .title--row a:hover { color: var(--primary); text-decoration: underline; }
.resume-table .category { font-size: 13px; color: var(--sub); }

/* 버튼 디자인 (인쇄, 이메일) */
.btn-icon {
  display: inline-flex; align-items: center; justify-content: center; gap: 4px;
  padding: 6px 10px; border-radius: 6px; font-size: 13px; font-weight: 500;
  background: var(--bg); color: var(--sub); border: 1px solid var(--border);
  cursor: pointer; text-decoration: none; transition: 0.2s;
  white-space: nowrap; /* ★핵심: 아이콘과 글자가 무조건 가로로 유지되게 함★ */
}
.btn-icon:hover { background: #E2E8F0; color: var(--text); }

/* 수정 버튼 */
.btn-edit {
  display: inline-flex; align-items: center; justify-content: center;
  padding: 6px 14px; border-radius: 6px; font-size: 13px; font-weight: 600;
  background: var(--primary-light); color: var(--primary); border: none;
  text-decoration: none; transition: 0.2s;
  white-space: nowrap; /* 줄바꿈 방지 */
}
.btn-edit:hover { background: #d4e3f5; }

/* 설정변경(공개) 버튼 */
.btn-outline {
  display: inline-flex; align-items: center; justify-content: center;
  padding: 6px 14px; border-radius: 6px; font-size: 13px; font-weight: 600;
  background: var(--surface); color: var(--primary); border: 1px solid var(--primary);
  cursor: pointer; transition: 0.2s;
  white-space: nowrap; /* 줄바꿈 방지 */
}
.btn-outline:hover { background: var(--primary-light); }

/* 하단 액션 바 (선택삭제 등) */
.action-bar { display: flex; justify-content: space-between; align-items: center; }
.btn-del-multi {
  padding: 10px 18px; background: var(--surface); border: 1px solid var(--border);
  color: var(--sub); border-radius: 8px; font-size: 14px; font-weight: 600;
  cursor: pointer; transition: 0.2s;
}
.btn-del-multi:hover { background: #FEF2F2; color: #DC2626; border-color: #FECACA; }

/* 체크박스 색상 변경 */
.custom-chk { width: 16px; height: 16px; accent-color: var(--primary); cursor: pointer; }

/* 빈 상태 (기존 테마 유지) */
.empty { text-align: center; padding: 80px 20px; }
.empty-icon { font-size: 50px; color: #CBD5E0; margin-bottom: 16px; }
.empty-title { font-size: 18px; font-weight: 700; color: var(--text); margin: 0 0 8px; }
.empty-desc { font-size: 14px; color: var(--sub); margin: 0; }
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<main class="wrap">
  <div class="top-bar">
    <h1 class="page-title">나의 이력서</h1>
    <a href="${pageContext.request.contextPath}/resume/write" class="btn-new">
      <i class="ri-add-line"></i> 새 이력서 작성
    </a>
  </div>

  <c:choose>
    <c:when test="${not empty list}">
      <p class="count-info">총 <strong>${fn:length(list)}개</strong>의 이력서가 있습니다.</p>

      <form id="manageForm" name="manageForm" method="post" action="${pageContext.request.contextPath}/resume/deleteMulti">
        <div class="table-container">
          <table class="resume-table">
            <colgroup>
              <col style="width:50px">
              <col style="width:auto">
              <col style="width:100px"> <col style="width:90px">  <col style="width:110px"> <col style="width:90px">  <col style="width:100px"> </colgroup>
            <thead>
              <tr>
                <th scope="col"><input type="checkbox" id="chkAll" class="custom-chk" onclick="toggleAll(this)"></th>
                <th scope="col">이력서 제목</th>
                <th scope="col">최종 수정일</th>
                <th scope="col">인쇄</th>
                <th scope="col">이메일 전송</th>
                <th scope="col">이력서 관리</th>
                <th scope="col">설정변경</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="r" items="${list}">
                <tr>
                  <td>
                    <input type="checkbox" name="profileIdxs" value="${r.profileIdx}" class="custom-chk">
                  </td>
                  <td class="title--row">
                    <a href="${pageContext.request.contextPath}/resume/article/${r.profileIdx}">
                      ${r.title}
                    </a>
                    <c:if test="${not empty r.phone}">
                      <span class="category"><i class="ri-phone-line"></i> ${r.phone}</span>
                    </c:if>
                  </td>
                  <td>
                    ${fn:substring(r.createdDate, 0, 10)}
                  </td>
                  <td>
                    <a href="#" onclick="alert('인쇄 기능 준비중입니다.'); return false;" class="btn-icon"><i class="ri-printer-line"></i> 인쇄</a>
                  </td>
                  <td>
                    <a href="#" onclick="alert('이메일 전송 준비중입니다.'); return false;" class="btn-icon"><i class="ri-mail-send-line"></i> 이메일</a>
                  </td>
                  <td>
                    <a href="${pageContext.request.contextPath}/resume/update?profileIdx=${r.profileIdx}" class="btn-edit">
                      수정
                    </a>
                  </td>
                  <td>
                    <button type="button" class="btn-outline" onclick="alert('공개 설정 기능 준비중입니다.');">
                      공개하기
                    </button>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>

        <div class="action-bar">
          <button type="button" class="btn-del-multi" onclick="submitDelChk();">
            <i class="ri-delete-bin-line"></i> 선택 삭제
          </button>
        </div>
      </form>
    </c:when>
    
    <c:otherwise>
      <div class="table-container">
        <div class="empty">
          <div class="empty-icon"><i class="ri-file-text-line"></i></div>
          <p class="empty-title">등록된 이력서가 없어요</p>
          <p class="empty-desc">이력서를 등록하면 사장님들이 먼저 연락할 수 있어요!</p>
        </div>
      </div>
    </c:otherwise>
  </c:choose>
</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>

<script>
// 전체 선택/해제 스크립트
function toggleAll(source) {
    const checkboxes = document.querySelectorAll('input[name="profileIdxs"]');
    checkboxes.forEach(cb => cb.checked = source.checked);
}

// 선택 삭제 스크립트
function submitDelChk() {
    const checked = document.querySelectorAll('input[name="profileIdxs"]:checked');
    if (checked.length === 0) {
        alert("삭제할 이력서를 선택해주세요.");
        return;
    }
    
    if (confirm("선택한 이력서 " + checked.length + "개를 정말 삭제하시겠습니까?")) {
        // 실제 백엔드 연동 시 아래 주석 해제
        // document.getElementById('manageForm').submit();
        alert('백엔드 다중 삭제 로직 연결이 필요합니다 (form submit 발생)');
    }
}
</script>
</body>
</html>