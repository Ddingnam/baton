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
						<span class="small-title">상세정보</span>
					</div>
									
					<table class="table board-article">
						<thead>
							<tr>
								<td colspan="2" class="text-center">
									제목입니다.
								</td>
							</tr>
						</thead>

						<tbody>
							<tr>
								<td width="50%">
									작성자 : 홍길동
								</td>
								<td width="50%" class="text-end">
									작성일 : 2025-05-01 | 조회 10
								</td>
							</tr>
							
							<tr>
								<td colspan="2" valign="top" class="article-content" height="200">
									내용 입니다.
								</td>
							</tr>
							<tr>
								<td colspan="2">
									이전글 : 
								</td>
							</tr>
							<tr>
								<td colspan="2">
									다음글 : 
								</td>
							</tr>
						</tbody>
					</table>

					<div class="row mb-2">
						<div class="col-md-6 align-self-center">
							<button type="button" class="btn-default" onclick="location.href='${pageContext.request.contextPath}/';">수정</button>
							<button type="button" class="btn-default">삭제</button>
						</div>
						<div class="col-md-6 align-self-center text-end">
							<button type="button" class="btn-default" onclick="location.href='${pageContext.request.contextPath}/';">리스트</button>
						</div>
					</div>

				</div>
			</div>
		</div>
	</div>
</main>

<footer>
	<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>

</body>
</html>