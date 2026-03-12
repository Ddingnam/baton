<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>동네 인증 | BATON</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/member/regionAuth.css">
<link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=YOUR_KAKAO_APP_KEY&libraries=services"></script>
</head>
<body>

<header class="fixed-top shadow-sm bg-white">
	<jsp:include page="/WEB-INF/views/layout/header.jsp" />
</header>

<main class="baton-harmony-canvas">
    <div class="login-auth-frame auth-frame-lg">
        <header class="auth-header text-center">
            <div class="main-feature-icon-wrap">
                <i class="ri-map-pin-user-fill"></i>
            </div>
            <h1 class="auth-title">
			    ${regionType == 1 ? '주 동네' : '부 동네'} 인증
			</h1>
            <p class="auth-subtitle" id="authSubtitle">바톤 터치할 동네 인증 방식을 선택해주세요.</p>
        </header>

        <div id="step1" class="auth-form-body">
            <div class="split-square-wrap item-1">
                <button type="button" class="btn-square" onclick="startWithCurrentLocation()">
                    <div class="icon-circle">
                        <i class="ri-crosshair-2-line"></i>
                    </div>
                    <span class="btn-title">현재 위치로 찾기</span>
                    <span class="btn-desc">원클릭 자동 인증</span>
                </button>
                
                <button type="button" class="btn-square" onclick="openRegionModal()">
                    <div class="icon-circle">
                        <i class="ri-map-pin-add-line"></i>
                    </div>
                    <span class="btn-title">동네 직접 선택</span>
                    <span class="btn-desc">목록에서 지정</span>
                </button>
            </div>
            
            <div class="auth-back-helper item-2">
                <a href="${pageContext.request.contextPath}/" class="btn-link-back">
                    메인으로 돌아가기
                </a>
            </div>
        </div>

        <div id="loadingContainer" class="auth-form-body" style="display: none; flex-direction: column; align-items: center; justify-content: center; min-height: 280px;">
            <div class="baton-loader"></div>
            <p id="loadingMessage" style="margin-top: 24px; font-weight: 700; color: var(--text-dark); font-size: 16px;">위치 정보를 확인하고 있습니다...</p>
            <p style="font-size: 13px; color: var(--text-gray); margin-top: 8px;">잠시만 기다려주세요.</p>
        </div>

        <div id="stepVerify" class="auth-form-body" style="display: none;">
            <div class="map-container-wrap item-1">
                <div id="map" class="baton-map"></div>
            </div>

            <div id="verifyResultToast" class="auth-error-toast item-2" style="display: none;"></div>

            <div class="auth-action item-3" style="margin-top: 32px;">
                <button type="button" id="btnComplete" class="btn-baton-login" onclick="completeVerification()" disabled>
			        <span>인증 완료</span>
			    </button>
            </div>
            
            <div class="auth-back-helper item-4">
                <a href="javascript:void(0);" onclick="resetToStep1()" class="btn-link-back">
                    처음으로 돌아가기
                </a>
            </div>
        </div>
    </div>
</main>

<div id="regionModal" class="baton-modal-overlay">
    <div class="baton-modal-content modal-lg">
        <div class="modal-header">
            <h3>동네 직접 선택</h3>
            <button type="button" class="btn-close-modal" onclick="closeRegionModal()">
                <i class="ri-close-line"></i>
            </button>
        </div>
        <div class="modal-body">
            <div class="region-selector-wrap">
                <div class="region-col"><ul class="region-list" id="listSido"></ul></div>
                <div class="region-col"><ul class="region-list" id="listSigungu"><li class="region-empty">시/도를<br>선택해주세요</li></ul></div>
                <div class="region-col"><ul class="region-list" id="listDong"><li class="region-empty">시/군/구를<br>선택해주세요</li></ul></div>
            </div>
            <div class="modal-selected-text" id="modalSelectedText">지역을 선택해주세요.</div>
        </div>
        <div class="modal-footer" style="display: flex; gap: 12px;">
            <button type="button" class="btn-baton-secondary" style="flex: 1; height: 54px; font-size: 15px;" onclick="resetModalSelection()">초기화</button>
            <button type="button" class="btn-baton-login" style="flex: 2; height: 54px; font-size: 16px;" onclick="confirmRegionSelection()">선택 완료</button>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>

<script type="text/javascript">
let map = null;
let geocoder = new kakao.maps.services.Geocoder();

let targetAddress = "";
let targetDong = ""; 

let finalLat = 0;
let finalLng = 0;
let finalFullAddress = "";
let finalCoreAddress = "";
let finalRegionCode = "";

let tempSido = "";
let tempSigungu = "";
let tempDong = "";

const API_BASE_URL = "https://grpc-proxy-server-mkvo6j4wsq-du.a.run.app/v1/regcodes";

window.onload = function() { loadSido(); };

function showLoading(msg) {
    document.getElementById("step1").style.display = "none";
    document.getElementById("stepVerify").style.display = "none";
    document.getElementById("loadingContainer").style.display = "flex";
    document.getElementById("loadingMessage").innerText = msg;
    document.getElementById("authSubtitle").innerHTML = "위치 데이터를 동기화 중입니다.";
}

function hideLoading() {
    document.getElementById("loadingContainer").style.display = "none";
}

function startWithCurrentLocation() {
    if (!navigator.geolocation) {
        alert("위치 기반 서비스를 지원하지 않는 브라우저입니다.");
        return;
    }
    
    showLoading("현재 계신 위치를 정밀하게 탐색하고 있습니다...");
    
    navigator.geolocation.getCurrentPosition(function(position) {
        const lat = position.coords.latitude;
        const lng = position.coords.longitude;
        
        geocoder.coord2Address(lng, lat, function(result, status) {
            if (status === kakao.maps.services.Status.OK) {
                const addr = result[0].address;
                
                targetAddress = addr.region_1depth_name + " " + addr.region_2depth_name + " " + addr.region_3depth_name;
                targetDong = addr.region_3depth_name;
                
                setTimeout(() => {
                    executeVerification(lat, lng, addr);
                }, 1200);
            }
        });
    }, function() {
        hideLoading();
        document.getElementById("step1").style.display = "block";
        document.getElementById("authSubtitle").innerText = "바톤 터치할 동네 인증 방식을 선택해주세요.";
        alert("위치 정보를 가져올 수 없습니다. 브라우저 권한을 확인해주세요.");
    });
}

function openRegionModal() {
    document.getElementById('regionModal').classList.add('show');
    document.body.style.overflow = 'hidden';
}

function closeRegionModal() {
    document.getElementById('regionModal').classList.remove('show');
    document.body.style.overflow = 'auto';
}

function resetModalSelection() {
    tempSido = ""; tempSigungu = ""; tempDong = "";
    document.getElementById('listSigungu').innerHTML = '<li class="region-empty">시/도를<br>선택해주세요</li>';
    document.getElementById('listDong').innerHTML = '<li class="region-empty">시/군/구를<br>선택해주세요</li>';
    
    const sidoItems = document.getElementById('listSido').getElementsByClassName('region-item');
    for (let i = 0; i < sidoItems.length; i++) {
        sidoItems[i].classList.remove('active');
    }
    updateModalText();
}

function confirmRegionSelection() {
    if (!tempSido || !tempSigungu || !tempDong) {
        alert("읍/면/동까지 모두 선택해주세요.");
        return;
    }
    
    targetAddress = tempSido + " " + tempSigungu + " " + tempDong;
    targetDong = tempDong;
    closeRegionModal();
    
    showLoading("선택하신 동네와 현재 위치를 대조하고 있습니다...");
    
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function(position) {
            const lat = position.coords.latitude;
            const lng = position.coords.longitude;
            
            geocoder.coord2Address(lng, lat, function(result, status) {
                if (status === kakao.maps.services.Status.OK) {
                    const addr = result[0].address;
                    setTimeout(() => { 
                        executeVerification(lat, lng, addr); 
                    }, 1500);
                }
            });
        }, function() {
            setTimeout(() => { handleLocationError(); }, 1500);
        });
    } else {
        alert("위치 기반 서비스를 지원하지 않는 브라우저입니다.");
        resetToStep1();
    }
}

function executeVerification(lat, lng, addr) {
    hideLoading();
    document.getElementById("stepVerify").style.display = "block";
    
    const currentAddressFull = (typeof addr === 'object') ? addr.address_name : addr;

    document.getElementById("authSubtitle").innerHTML = 
        "<span class='target-address-highlight'><i class='ri-map-pin-2-fill'></i> " + targetAddress + "</span><br>이 동네에서 인증을 진행합니다.";
    
    initMap(lat, lng);
    
    const toast = document.getElementById("verifyResultToast");
    toast.style.display = "flex";

    if (currentAddressFull.includes(targetDong)) {
        
        geocoder.coord2RegionCode(lng, lat, function(result, status) {
            if (status === kakao.maps.services.Status.OK) {
                for(let i = 0; i < result.length; i++) {
                    if(result[i].region_type === 'B') {
                        finalRegionCode = result[i].code; 
                        finalCoreAddress = result[i].region_3depth_name;
                        break;
                    }
                }

                finalLat = lat;
                finalLng = lng;
                finalFullAddress = currentAddressFull;

                toast.className = "auth-error-toast item-2 auth-success";
                toast.innerHTML = '<i class="ri-checkbox-circle-fill"></i> 현재 위치가 [' + targetDong + '] 주변으로 일치합니다.';
                document.getElementById("btnComplete").disabled = false;
            }
        });
        
    } else {
        toast.className = "auth-error-toast item-2 shake";
        toast.innerHTML = '<i class="ri-error-warning-fill"></i> 현재 위치가 목표 지역과 다릅니다.<br>실제 위치: ' + currentAddressFull;
        document.getElementById("btnComplete").disabled = true;
    }
}

function handleLocationError() {
    hideLoading();
    document.getElementById("stepVerify").style.display = "block";
    document.getElementById("authSubtitle").innerHTML = 
        "<span class='target-address-highlight'><i class='ri-map-pin-2-fill'></i> " + targetAddress + "</span><br>이 동네에서 인증을 진행합니다.";
    
    geocoder.addressSearch(targetAddress, function(result, status) {
         if (status === kakao.maps.services.Status.OK) {
             initMap(result[0].y, result[0].x);
         }
    });
    
    const toast = document.getElementById("verifyResultToast");
    toast.style.display = "flex";
    toast.className = "auth-error-toast item-2 shake";
    toast.innerHTML = "위치 정보 권한이 거부되어 비교할 수 없습니다.";
}

function resetToStep1() {
    hideLoading();
    document.getElementById("stepVerify").style.display = "none";
    document.getElementById("step1").style.display = "block";
    document.getElementById("authSubtitle").innerText = "바톤 터치할 동네 인증 방식을 선택해주세요.";
    
    document.getElementById("btnComplete").disabled = true;
    document.getElementById("verifyResultToast").style.display = "none";
    
    targetAddress = ""; targetDong = "";
    resetModalSelection();
}

async function completeVerification() {
    const btn = document.getElementById("btnComplete");
    
    btn.disabled = true;
    btn.innerHTML = "<span>처리 중...</span>";

    const requestData = {
        regionType: `${regionType}`,
        regionCode: finalRegionCode,
        fullAddress: finalFullAddress,
        coreAddress: finalCoreAddress, 
        lat: finalLat,
        lng: finalLng
    };

    try {
        const response = await fetch('${pageContext.request.contextPath}/member/verifyLocation', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(requestData)
        });

        if (response.status === 401) {
        	showBatonToast("로그인이 필요한 서비스입니다.");
        	await new Promise(resolve => setTimeout(resolve, 1200));
            window.location.href = "${pageContext.request.contextPath}/member/login";
            return;
        }

        if (!response.ok) {
            throw new Error('서버 응답 오류');
        }

        const data = await response.json();

        switch(data.state) {
            case "success":
            	btn.classList.add('success');
                btn.innerHTML = '<i class="ri-checkbox-circle-line"></i> <span>인증 완료!</span>';
                
                await new Promise(resolve => setTimeout(resolve, 1200));

                window.location.href = "${pageContext.request.contextPath}/";
                break;
                
            case "fail":
            	showBatonToast("인증 처리에 실패했습니다. 정보를 다시 확인해주세요.");
                resetBtn(btn);
                break;
                
            case "serverError":
            	showBatonToast("서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
                resetBtn(btn);
                break;
                
            default:
            	showBatonToast("알 수 없는 오류가 발생했습니다.");
                resetBtn(btn);
        }

    } catch (error) {
        console.error('Fetch Error:', error);
        showBatonToast("통신 중 오류가 발생했습니다. 네트워크 상태를 확인해주세요.");
        resetBtn(btn);
    }
}

function resetBtn(btn) {
    btn.disabled = false;
    btn.innerHTML = "<span>인증 완료</span>";
}

function loadSido() {
    fetch(API_BASE_URL + "?regcode_pattern=*00000000")
        .then(response => response.json())
        .then(data => {
            const validData = data.regcodes.filter(code => code.name.split(" ").length === 1);
            renderList('listSido', validData, handleSidoClick, 1);
        });
}

function loadSigungu(sidoCode) {
    const pattern = sidoCode.substring(0, 2) + "*00000";
    fetch(API_BASE_URL + "?regcode_pattern=" + pattern + "&is_ignore_zero=true")
        .then(response => response.json())
        .then(data => {
            const filteredData = data.regcodes.filter(item => item.code !== sidoCode);
            renderList('listSigungu', filteredData, handleSigunguClick, 2);
        });
}

function loadDong(sigunguCode) {
    const pattern = sigunguCode.substring(0, 4) + "*&is_ignore_zero=true";
    fetch(API_BASE_URL + "?regcode_pattern=" + pattern)
        .then(response => response.json())
        .then(data => {
            const filteredData = data.regcodes.filter(item => item.code !== sigunguCode);
            renderList('listDong', filteredData, handleDongClick, 3);
        });
}

function renderList(elementId, items, clickHandler, depth) {
    const ul = document.getElementById(elementId);
    ul.innerHTML = "";
    
    if (!items || items.length === 0) {
        ul.innerHTML = '<li class="region-empty">데이터가 없습니다</li>'; 
        return;
    }

    let mappedItems = items.map(item => {
        const nameParts = item.name.split(" ");
        let displayName = "";
        if (depth === 1) displayName = nameParts[0];
        else if (depth === 2) displayName = nameParts.slice(1).join(" ");
        else if (depth === 3) displayName = nameParts[nameParts.length - 1];
        return { original: item, display: displayName };
    });

    mappedItems.sort((a, b) => a.display.localeCompare(b.display));

    mappedItems.forEach(mappedItem => {
        const li = document.createElement('li');
        li.className = 'region-item';
        li.innerText = mappedItem.display;
        li.onclick = () => clickHandler(mappedItem.original, mappedItem.display, li, ul);
        ul.appendChild(li);
    });
}

function setActiveClass(ulElement, clickedLi) {
    const items = ulElement.getElementsByClassName('region-item');
    for (let i = 0; i < items.length; i++) items[i].classList.remove('active');
    clickedLi.classList.add('active');
}

function handleSidoClick(item, displayName, liElement, ulElement) {
    tempSido = displayName; tempSigungu = ""; tempDong = "";
    setActiveClass(ulElement, liElement); updateModalText();
    loadSigungu(item.code);
    document.getElementById('listDong').innerHTML = '<li class="region-empty">시/군/구를<br>선택해주세요</li>';
}

function handleSigunguClick(item, displayName, liElement, ulElement) {
    tempSigungu = displayName; tempDong = "";
    setActiveClass(ulElement, liElement); updateModalText();
    loadDong(item.code);
}

function handleDongClick(item, displayName, liElement, ulElement) {
    tempDong = displayName;
    setActiveClass(ulElement, liElement); updateModalText();
}

function updateModalText() {
    const textEl = document.getElementById("modalSelectedText");
    if(tempSido || tempSigungu || tempDong) {
        textEl.innerHTML = `<b>\${tempSido} \${tempSigungu} \${tempDong}</b>`;
        textEl.style.color = "var(--baton-primary)";
    } else {
        textEl.innerHTML = "지역을 선택해주세요.";
        textEl.style.color = "var(--text-gray)";
    }
}

function initMap(lat, lng) {
    const mapContainer = document.getElementById('map');
    const mapOption = { center: new kakao.maps.LatLng(lat, lng), level: 4 };

    if(!map) map = new kakao.maps.Map(mapContainer, mapOption);
    else map.setCenter(new kakao.maps.LatLng(lat, lng));

    const markerPosition = new kakao.maps.LatLng(lat, lng);
    const marker = new kakao.maps.Marker({ position: markerPosition });
    marker.setMap(map);
    
    setTimeout(() => { map.relayout(); map.setCenter(markerPosition); }, 100);
}
</script>
</body>
</html>