<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Spring</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/board.css" type="text/css">

<!-- Quill Rich Text Editor -->
<link href="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.snow.css" rel="stylesheet">
<!-- Quill Editor Image Resize CSS -->
<link href="https://cdn.jsdelivr.net/npm/quill-resize-module@2.0.4/dist/resize.css" rel="stylesheet">
</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<main>
	<!-- Page Title -->
	<div class="page-title">
		<div class="container align-items-center" data-aos="fade-up">
			<h1>게시판</h1>
			<div class="page-title-underline-accent"></div>
		</div>
	</div>
    
	<!-- Page Content -->    
	<div class="section">
		<div class="container" data-aos="fade-up" data-aos-delay="100">
			<div class="row justify-content-center">
				<div class="col-md-10 board-section my-4 p-5">

					<div class="pb-2">
						<span class="small-title">게시글 등록</span>
					</div>

					<form name="postForm" action="" method="post">
						<table class="table write-form">
							<tr>
								<td class="col-md-2 bg-light">제 목</td>
								<td>
									<input type="text" name="subject" class="form-control" maxlength="100" placeholder="Subject">
								</td>
							</tr>

							<tr>
								<td class="col-md-2 bg-light">이 름</td>
								<td>
									<div class="row">
										<div class="col-md-6">
											<input type="text" name="name" class="form-control" readonly tabindex="-1" value="스프링">
										</div>
									</div>
								</td>
							</tr>
						
							<tr>
								<td class="col-md-2 bg-light">내 용</td>
								<td>
									<div id="editor">${dto.content}</div>
									<input type="hidden" name="content">
								</td>
							</tr>
						</table>
						
						<div class="text-center">
							<button type="button" class="btn-accent btn-md" onclick="sendOk();">등록완료</button>
							<button type="reset" class="btn-default btn-md">다시입력</button>
							<button type="button" class="btn-default btn-md" onclick="location.href='${pageContext.request.contextPath}/';">취 소</button>
						</div>						
					</form>

				</div>
			</div>
		</div>
	</div>
</main>

<!-- Quill Rich Text Editor -->
<script src="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.js"></script>
<!-- Quill Editor Image Resize JS -->
<script src="https://cdn.jsdelivr.net/npm/quill-resize-module@2.0.4/dist/resize.js"></script>
<!-- Quill Editor 적용 JS -->
<script src="${pageContext.request.contextPath}/dist/posts/qeditor.js"></script>

<script type="text/javascript">
function hasContent(htmlContent) {
	htmlContent = htmlContent.replace(/<p[^>]*>/gi, ''); // p 태그 제거
	htmlContent = htmlContent.replace(/<\/p>/gi, '');
	htmlContent = htmlContent.replace(/<br\s*\/?>/gi, ''); // br 태그 제거
	htmlContent = htmlContent.replace(/&nbsp;/g, ' ');
	htmlContent = htmlContent.replace(/\s/g, ''); // 공백 제거
	
	return htmlContent.length > 0;
}

function sendOk() {
	const f = document.postForm;
	let str;
	
	str = f.subject.value.trim();
	if( ! str ) {
		alert('제목을 입력하세요. ');
		f.subject.focus();
		return;
	}

	const htmlViewEL = document.querySelector('textarea#html-view');
	let htmlContent = htmlViewEL ? htmlViewEL.value : quill.root.innerHTML;
	if(! hasContent(htmlContent)) {
		alert('내용을 입력하세요. ');
		if(htmlViewEL) {
			htmlViewEL.focus();
		} else {
			quill.focus();
		}
		return;
	}
	f.content.value = htmlContent;

	f.action = '${pageContext.request.contextPath}/';
	f.submit();
}
</script>

<footer>
	<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>

</body>
</html>