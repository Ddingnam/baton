<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
</head>
<body>
    <script>
        alert("${not empty msg ? msg : '이력서 전송이 완료되었습니다.'}");
        window.close(); 
    </script>
</body>
</html>