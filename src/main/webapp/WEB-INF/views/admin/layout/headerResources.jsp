<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<meta name="ctx" content="${pageContext.request.contextPath}">
<script>
window.CTX = '${pageContext.request.contextPath}';
<sec:authorize access="isAuthenticated()">
window.ADMIN_USER_IDX = Number('<sec:authentication property="principal.userIdx"/>');
</sec:authorize>
</script>
<link rel="icon" href="data:;base64,iVBORw0KGgo=">
<!-- Favicons -->
<link href="${pageContext.request.contextPath}/dist/images/h.png" rel="icon">
 
<!-- Fonts -->
<link href="https://fonts.googleapis.com" rel="preconnect">
<link href="https://fonts.gstatic.com" rel="preconnect">
<link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100;0,300;0,400;0,500;0,700;0,900;1,100;1,300;1,400;1,500;1,700;1,900&family=Raleway:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&family=Nunito:ital,wght@0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet">
  
<!-- Vendor CSS Files -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css" rel="stylesheet">
<link href="https://unpkg.com/aos@2.3.4/dist/aos.css" rel="stylesheet">

<!-- Main CSS Files -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/main/main.css" type="text/css">

<!-- Vendor JS Files -->
<script type="text/javascript" src="${pageContext.request.contextPath}/dist/vendor/jquery/js/jquery.min.js"></script>

<script type="text/javascript" src="${pageContext.request.contextPath}/dist/js/util/util-jquery.js"></script>