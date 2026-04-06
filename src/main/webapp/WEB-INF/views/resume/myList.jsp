<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
.wrap { max-width: 1000px; margin: 0 auto; padding: 100px 20px 60px; }
.top-bar { display: flex; align-items: center; justify-content: space-between; margin-bottom: 24px; }
.page-title { font-size: 24px; font-weight: 800; color: var(--text); margin: 0; }

.btn-new { 
  display: inline-flex; align-items: center; gap: 6px; 
  padding: 10px 18px; background: var(--primary); 
  color: #ffffff !important; 
  border: none; border-radius: 8px; font-size: 14px; font-weight: 700; 
  cursor: pointer; text-decoration: none; transition: 0.2s; 
}
.btn-new i { color: #ffffff !important; } 
.btn-new:hover { background: #1a4a8a; color: #ffffff !important; }

.profile-dashboard {
  display: flex; align-items: center; background: var(--surface); border: 1px solid var(--border);
  border-radius: var(--radius); padding: 24px 32px; margin-bottom: 32px; box-shadow: 0 2px 8px rgba(0,0,0,0.03);
}
.profile-info { display: flex; align-items: center; gap: 16px; flex: 1.2; border-right: 1px solid var(--border); }
.profile-avatar { width: 60px; height: 60px; background: var(--primary-light); color: var(--primary); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 28px; }
.profile-text .name { font-size: 18px; font-weight: 800; color: var(--text); margin-bottom: 4px; }
.profile-text .desc { font-size: 14px; color: var(--sub); }
.profile-stats { display: flex; flex: 2; justify-content: space-around; }
.stat-item { text-align: center; cursor: pointer; transition: transform 0.2s; }
.stat-item:hover { transform: translateY(-2px); }
.stat-title { font-size: 13px; color: var(--sub); margin-bottom: 8px; font-weight: 600; }
.stat-num { font-size: 24px; font-weight: 800; color: var(--text); }
.stat-num span { font-size: 14px; font-weight: 500; margin-left: 2px; color: var(--sub); }
.stat-num.highlight { color: var(--primary); }

.count-info { font-size: 14px; color: var(--sub); margin-bottom: 16px; font-weight: 500; }
.count-info strong { color: var(--primary); }

.table-container { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); box-shadow: 0 2px 8px rgba(0,0,0,0.03); overflow: hidden; margin-bottom: 20px; }
.resume-table { width: 100%; border-collapse: collapse; text-align: center; }
.resume-table th { background: #F8FAFC; padding: 16px 12px; font-size: 14px; font-weight: 700; color: var(--sub); border-bottom: 1px solid var(--border); white-space: nowrap; }
.resume-table td { padding: 16px 12px; font-size: 14px; color: var(--text); border-bottom: 1px solid var(--border); vertical-align: middle; }
.resume-table tbody tr:last-child td { border-bottom: none; }
.resume-table tbody tr:hover { background: var(--bg); }

.resume-table .title--row { text-align: left; padding-left: 24px; }
.resume-table .title--row a { font-size: 16px; font-weight: 700; color: var(--text); text-decoration: none; display: block; margin-bottom: 4px; transition: 0.2s; }
.resume-table .title--row a:hover { color: var(--primary); text-decoration: underline; }
.resume-table .category { font-size: 13px; color: var(--sub); }
.resume-table .date-col { white-space: nowrap; color: var(--sub); font-weight: 500; } 

.btn-icon-only { display: inline-flex; align-items: center; justify-content: center; width: 34px; height: 34px; border-radius: 8px; font-size: 18px; background: var(--surface); color: var(--sub); border: 1px solid var(--border); cursor: pointer; text-decoration: none; transition: all 0.2s; }
.btn-icon-only:hover { background: var(--bg); color: var(--primary); border-color: #CBD5E0; }

.btn-edit { display: inline-flex; align-items: center; justify-content: center; padding: 6px 14px; border-radius: 6px; font-size: 13px; font-weight: 600; background: var(--primary-light); color: var(--primary); border: none; text-decoration: none; transition: 0.2s; white-space: nowrap; }
.btn-edit:hover { background: #d4e3f5; }

.btn-outline { display: inline-flex; align-items: center; justify-content: center; padding: 6px 14px; border-radius: 6px; font-size: 13px; font-weight: 600; background: var(--surface); color: var(--primary); border: 1px solid var(--primary); cursor: pointer; transition: 0.2s; white-space: nowrap; }
.btn-outline:hover { background: var(--primary-light); }

.action-bar { display: flex; justify-content: space-between; align-items: center; }
.btn-del-multi { padding: 10px 18px; background: var(--surface); border: 1px solid var(--border); color: var(--sub); border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; transition: 0.2s; }
.btn-del-multi:hover { background: #FEF2F2; color: #DC2626; border-color: #FECACA; }

.custom-chk { width: 16px; height: 16px; accent-color: var(--primary); cursor: pointer; }

.empty { text-align: center; padding: 80px 20px; }
.empty-icon { font-size: 50px; color: #CBD5E0; margin-bottom: 16px; }
.empty-title { font-size: 18px; font-weight: 700; color: var(--text); margin: 0 0 8px; }
.empty-desc { font-size: 14px; color: var(--sub); margin: 0 0 20px; }
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

  <div class="profile-dashboard">
    <div class="profile-info">
      <div class="profile-avatar"><i class="ri-user-smile-line"></i></div>
      <div class="profile-text">
        <div class="name">나의 이력서 현황</div>
        <div class="desc">오늘도 딱 맞는 일자리를 찾아보세요!</div>
      </div>
    </div>
    <div class="profile-stats">

	  <div class="stat-item"
	     onclick="location.href='${pageContext.request.contextPath}/mypage/main?tab=alba&inner=apply'">
	  <div class="stat-title">지원 완료</div>
	  <div class="stat-num highlight">${applyCount}<span>건</span></div>
	</div>
	
	<div class="stat-item"
	     onclick="location.href='${pageContext.request.contextPath}/mypage/main?tab=alba&inner=apply'">
	  <div class="stat-title">지원 결과</div>
	  <div class="stat-num">${resultCount}<span>건</span></div>
	</div>
	
	<div class="stat-item"
	     onclick="location.href='${pageContext.request.contextPath}/mypage/main?tab=alba&inner=wish'">
	  <div class="stat-title">스크랩한 알바</div>
	  <div class="stat-num">${scrapCount}<span>건</span></div>
	</div>

	</div>
  </div>

  <c:choose>
    <c:when test="${not empty list}">
      <p class="count-info">총 <strong>${fn:length(list)}개</strong>의 이력서가 있습니다.</p>

      <form id="manageForm" name="manageForm" method="post" action="${pageContext.request.contextPath}/resume/deleteMulti">
        <div class="table-container">
          <table class="resume-table">
            <colgroup>
              <col style="width:40px">
              <col style="width:auto">
              <col style="width:110px">
              <col style="width:60px">
              <col style="width:60px">
              <col style="width:80px">
              <col style="width:90px">
            </colgroup>
            <thead>
              <tr>
                <th scope="col"><input type="checkbox" id="chkAll" class="custom-chk" onclick="toggleAll(this)"></th>
                <th scope="col">이력서 제목</th>
                <th scope="col">최종 수정일</th>
                <th scope="col" title="인쇄">인쇄</th>
                <th scope="col" title="이메일 전송">이메일</th>
                <th scope="col">관리</th>
                <th scope="col">설정변경</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="r" items="${list}">
                <tr>
                  <td><input type="checkbox" name="profileIdxs" value="${r.profileIdx}" class="custom-chk"></td>
                  <td class="title--row">
                    <a href="${pageContext.request.contextPath}/resume/article/${r.profileIdx}">${r.title}</a>
                    <c:if test="${not empty r.phone}">
                      <span class="category"><i class="ri-phone-line"></i> ${r.phone}</span>
                    </c:if>
                  </td>
                  <td class="date-col">${fn:substring(r.createdDate, 0, 10)}</td>
                  
                  <td>
                    <a href="#" onclick="printResume(${r.profileIdx}); return false;" class="btn-icon-only" title="인쇄">
                      <i class="ri-printer-line"></i>
                    </a>
                  </td>
                  
                  <td>
                    <a href="#" onclick="emailResume(${r.profileIdx}); return false;" class="btn-icon-only" title="이메일 전송">
                      <i class="ri-mail-send-line"></i>
                    </a>
                  </td>
                  <td><a href="${pageContext.request.contextPath}/resume/update?profileIdx=${r.profileIdx}" class="btn-edit">수정</a></td>
                  <td>
					  <form method="post" action="${pageContext.request.contextPath}/resume/togglePublic" style="display:inline;">
					    <input type="hidden" name="profileIdx" value="${r.profileIdx}">
					    <button type="submit" class="btn-outline">
					      ${r.isPublic eq 'Y' ? '비공개하기' : '공개하기'}
					    </button>
					  </form>
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
          <a href="${pageContext.request.contextPath}/resume/write" class="btn-new">
            <i class="ri-add-line"></i> 첫 이력서 작성하기
          </a>
        </div>
      </div>
    </c:otherwise>
  </c:choose>
</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>

<script>
function toggleAll(source) {
    const checkboxes = document.querySelectorAll('input[name="profileIdxs"]');
    checkboxes.forEach(cb => cb.checked = source.checked);
}

function submitDelChk() {
    const form = document.getElementById('manageForm');
    const checked = document.querySelectorAll('input[name="profileIdxs"]:checked');

    if (checked.length === 0) {
        alert("삭제할 이력서를 선택해주세요.");
        return;
    }

    if (confirm("선택한 이력서 " + checked.length + "개를 정말 삭제하시겠습니까?")) {
        form.submit();
    }
}


function printResume(profileIdx) {
    const url = '${pageContext.request.contextPath}/resume/print?profileIdx=' + profileIdx;
    window.open(url, 'resumePrint', 'width=850,height=900,scrollbars=yes');
}

function emailResume(profileIdx) {
    const url = '${pageContext.request.contextPath}/resume/email?profileIdx=' + profileIdx;
    window.open(url, 'resumeEmail', 'width=550,height=650,scrollbars=no');
}
</script>
</body>
</html>