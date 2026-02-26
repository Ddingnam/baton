<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/views/layout/headerResources.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>동네 인증 | Baton</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

<style type="text/css">
:root {
    --baton-bg: #F9FAFB;
    --baton-white: #FFFFFF;
    --baton-title: #191F28;
    --baton-desc: #4E5968;
    --baton-blue: #3182F6;
}

body { 
    background-color: var(--baton-bg); 
    font-family: 'Pretendard', -apple-system, sans-serif;
    margin: 0;
}

.auth-container {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 20px;
}

.auth-box {
    max-width: 460px;
    width: 100%;
    background: var(--baton-white);
    padding: 40px 30px;
    border-radius: 32px;
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.06);
    text-align: center;
}

.icon-circle {
    width: 64px;
    height: 64px;
    background-color: #E8F3FF;
    color: var(--baton-blue);
    font-size: 26px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    margin: 0 auto 20px;
}

.auth-title {
    font-size: 24px;
    font-weight: 800;
    margin-bottom: 10px;
    color: var(--baton-title);
}

.auth-desc {
    color: var(--baton-desc);
    font-size: 15px;
    margin-bottom: 30px;
    line-height: 1.5;
}

.location-display {
    background-color: #F9FAFB;
    border: 1px solid #E5E8EB;
    border-radius: 24px;
    padding: 24px;
    margin-bottom: 24px;
    display: none; 
    
    text-align: center;
    display: flex; 
    flex-direction: column;
    align-items: center;
    justify-content: center;
}

.location-name {
    font-size: 18px;
    font-weight: 800;
    color: var(--baton-title);
    margin: 10px 0 20px 0;
    word-break: keep-all;
}

.badge-verified {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    color: var(--baton-blue);
    font-size: 14px;
    font-weight: 700;
    background: rgba(49, 130, 246, 0.1);
    padding: 6px 12px;
    border-radius: 20px;
}

#map {
    width: 100%;
    height: 200px;
    border-radius: 16px;
    border: 1px solid #E5E8EB;
    margin-top: 10px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.05);
}

.btn-auth {
    background: var(--baton-blue);
    color: #fff;
    border: none;
    padding: 16px;
    border-radius: 16px;
    font-weight: 700;
    font-size: 16px;
    width: 100%;
    transition: 0.2s;
    cursor: pointer;
}

.btn-auth:hover {
    background: #1B64DA;
}

.btn-auth:disabled {
    background: #ADCFFF;
    cursor: not-allowed;
}

.btn-retry {
    background: transparent;
    color: var(--baton-desc);
    border: none;
    font-size: 14px;
    text-decoration: underline;
    cursor: pointer;
    margin-top: 12px;
    display: none;
}
</style>
</head>
<body>

<header>
    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<main class="auth-container">
    <div class="auth-box">
        <div class="icon-circle">
            <i class="bi bi-geo-alt-fill"></i>
        </div>
        
        <h3 class="auth-title">내 동네 인증하기</h3>
        <p class="auth-desc">
            안전한 거래를 위해<br>
            현재 위치를 확인해주세요.
        </p>

        <div id="locationResult" class="location-display" style="display: none;">
            <div class="badge-verified">
                <i class="bi bi-check-circle-fill"></i>
                <span>인증 완료</span>
            </div>
            
            <div class="location-name" id="townName">
                위치 확인 중...
            </div>
            
            <div id="map"></div>
        </div>

        <div class="mt-3">
            <button type="button" class="btn-auth" id="btnMain" onclick="startAuth()">
                <span class="spinner-border spinner-border-sm me-2" id="loader" style="display:none;"></span>
                <span id="btnText">현재 위치로 인증하기</span>
            </button>

            <button type="button" class="btn-retry w-100" id="btnRetry" onclick="startAuth()">
                위치 다시 찾기
            </button>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/api/api.jsp"/>

<script>
function startAuth() {
    const btnText = document.getElementById('btnText');
    const loader = document.getElementById('loader');
    const townNameDisplay = document.getElementById('townName');
    const locationResult = document.getElementById('locationResult');
    const btnRetry = document.getElementById('btnRetry');
    const btnMain = document.getElementById('btnMain');
    const mapContainer = document.getElementById('map');

    btnText.innerText = "위치 확인 중...";
    loader.style.display = "inline-block";
    btnMain.disabled = true;

    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function(position) {
            const lat = position.coords.latitude;
            const lng = position.coords.longitude;

            const geocoder = new kakao.maps.services.Geocoder();
            geocoder.coord2RegionCode(lng, lat, function(result, status) {
                if (status === kakao.maps.services.Status.OK) {
                    const region = result.find(r => r.region_type === 'B');
                    const fullAddress = region.address_name;
                    const townName = region.region_3depth_name;

                    loader.style.display = "none";
                    locationResult.style.display = "flex"; 
                    townNameDisplay.innerText = fullAddress;
                    btnText.innerText = "가입 계속하기"; 
                    btnMain.disabled = false;
                    btnRetry.style.display = "block"; 

                    setTimeout(() => {
                        const mapOption = {
                            center: new kakao.maps.LatLng(lat, lng),
                            level: 3
                        };
                        const map = new kakao.maps.Map(mapContainer, mapOption);
                        
                        const marker = new kakao.maps.Marker({
                            position: new kakao.maps.LatLng(lat, lng)
                        });
                        marker.setMap(map);
                        
                        map.relayout();
                        map.setCenter(new kakao.maps.LatLng(lat, lng));
                    }, 100);

                    btnMain.onclick = function() {
                        location.href = "${pageContext.request.contextPath}/member/join?town=" + encodeURIComponent(fullAddress);
                    };
                }
            });
        }, function(error) {
            loader.style.display = "none";
            btnMain.disabled = false;
            btnText.innerText = "인증 실패";
            btnRetry.style.display = "block";
            alert("위치 정보를 가져오지 못했습니다. 기기의 위치 설정을 확인해주세요.");
        }, {
            enableHighAccuracy: true,
            maximumAge: 0,
            timeout: 10000
        });
    } else {
        alert("브라우저가 위치 정보를 지원하지 않습니다.");
    }
}
</script>

</body>
</html>