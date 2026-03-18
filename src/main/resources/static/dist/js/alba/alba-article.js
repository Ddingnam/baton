const Gallery = (function () {

    let current = 0;

    function init(){
        const dots = document.querySelectorAll(".indicator-dot");
        if(dots.length <= 1) return;
        setInterval(next,4000);
    }

    function go(index){

        const main = document.getElementById("mainImage");
        const dots = document.querySelectorAll(".indicator-dot");

        if(!main || !dots[index]) return;

        const src = dots[index].dataset.src;
        if(src) main.src = CONTEXT_PATH + src;

        dots.forEach((d,i)=>d.classList.toggle("active", i===index));

        current = index;
    }

    function next(){
        const dots = document.querySelectorAll(".indicator-dot");
        let nextIndex = current + 1;
        if(nextIndex >= dots.length) nextIndex = 0;
        go(nextIndex);
    }

    return { init, go };

})();

document.addEventListener("DOMContentLoaded", Gallery.init);

const WishModule = (function () {
    let wished = false;
    let albaIdx = 0;

    function init(initialWished, idx) {
        wished = initialWished;
        albaIdx = idx;
        updateUI();
    }

    function toggle() {
        fetch('/alba/wish', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ albaIdx: albaIdx })
        })
        .then(res => {
            if (res.status === 401) { Toast.show('로그인이 필요합니다.'); return null; }
            return res.json();
        })
        .then(data => {
            if (!data) return;
            wished = data.wished;
            updateUI();
            Toast.show(wished ? '관심 알바에 담았습니다.' : '관심 알바에서 제외했습니다.');
        })
        .catch(() => Toast.show('오류가 발생했습니다.'));
    }

    function updateUI() {
        const btn = document.getElementById('wishBtnLarge');
        if (!btn) return;
        btn.classList.toggle('active', wished);
        btn.innerHTML = wished
            ? '<i class="ri-heart-3-fill"></i>'
            : '<i class="ri-heart-3-line"></i>';
    }

    return { init, toggle };
})();

const StatusModule = (function () {
    const getModal = () => document.getElementById('statusModal');

    function open() {
        const modal = getModal();
        if (modal) { modal.classList.add('open'); document.body.style.overflow = 'hidden'; }
    }

    function close() {
        const modal = getModal();
        if (modal) { modal.classList.remove('open'); document.body.style.overflow = ''; }
    }

    function update(albaIdx, status) {
        const params = new URLSearchParams();
        params.append('albaIdx', albaIdx);
        params.append('status', status);

        fetch(`${window.location.origin}/alba/updateStatus`, {
            method: 'POST',
            body: params
        })
        .then(res => res.json())
        .then(data => {
            if (data.status === 'success') {
                location.reload();
            } else {
                Toast.show('상태 변경에 실패했습니다.');
            }
        })
        .catch(() => Toast.show('네트워크 오류입니다.'));
    }

    return { open, close, update };
})();

const PullUpModule = (function () {
    function execute(albaIdx) {
        if (!confirm('이 공고를 목록 최상단으로 끌어올리시겠습니까?')) return;

        const params = new URLSearchParams();
        params.append('albaIdx', albaIdx);

        fetch(`${window.location.origin}/alba/pullUp`, {
            method: 'POST',
            body: params
        })
        .then(res => res.json())
        .then(data => {
            if (data.status === 'success') {
                Toast.show('성공적으로 끌어올렸습니다.');
                setTimeout(() => location.reload(), 1200);
            } else {
                Toast.show(data.message || '요청 처리에 실패했습니다.');
            }
        })
        .catch(() => Toast.show('네트워크 오류가 발생했습니다.'));
    }

    return { execute };
})();

const Toast = (function () {
    let timer = null;
    function show(msg) {
        const el = document.getElementById('toast');
        if (!el) return;
        el.textContent = msg;
        el.classList.add('show');
        clearTimeout(timer);
        timer = setTimeout(() => el.classList.remove('show'), 2500);
    }
    return { show };
})();

function copyAddress(address) {
    if (navigator.clipboard) {
        navigator.clipboard.writeText(address).then(() => {
            Toast.show('근무지 주소가 복사되었습니다.');
        });
    } else {
        const ta = document.createElement('textarea');
        ta.value = address;
        document.body.appendChild(ta);
        ta.select();
        document.execCommand('copy');
        document.body.removeChild(ta);
        Toast.show('근무지 주소가 복사되었습니다.');
    }
}

function confirmDelete(albaIdx) {
    if (confirm('이 공고를 정말 삭제하시겠습니까?\n삭제된 공고는 복구할 수 없습니다.')) {
        location.href = CONTEXT_PATH + '/alba/delete?postingIdx=' + albaIdx;
    }
}

function relayoutMap() {
    if (window.kakaoMap && window.markerCoords) {
        window.kakaoMap.setCenter(window.markerCoords);
        window.kakaoMap.setLevel(3);
    }
}

function initMap() {
    const address = document.getElementById('mapAddress')?.value;
    const placeName = document.getElementById('mapPlaceName')?.value || '근무 위치';
    const mapContainer = document.getElementById('map');
    
    if (!address || !mapContainer) return;

    const geocoder = new kakao.maps.services.Geocoder();
    geocoder.addressSearch(address, function(result, status) {
        if (status === kakao.maps.services.Status.OK) {
            const coords = new kakao.maps.LatLng(result[0].y, result[0].x);
            const map = new kakao.maps.Map(mapContainer, { center: coords, level: 3 });
            const marker = new kakao.maps.Marker({ map, position: coords });
            
            window.kakaoMap = map;
            window.markerCoords = coords;

            const infowindow = new kakao.maps.InfoWindow({
                content: `<div style="padding:5px;font-size:12px;text-align:center;white-space:nowrap;">${placeName}</div>`
            });
            infowindow.open(map, marker);

            searchNearbySubway(coords); 
        } else {
            document.getElementById('subway-list').innerHTML = '<div class="nearby-item">위치 정보를 찾을 수 없습니다.</div>';
        }
    });
}

window.addEventListener('DOMContentLoaded', function () {
    const articleEl = document.getElementById('articleData');
    if (articleEl) {
        const wished = articleEl.dataset.wished === 'true';
        const albaIdx = parseInt(articleEl.dataset.albaIdx) || 0;
        WishModule.init(wished, albaIdx);
    }

    function tryInitMap(retry) {
        if (typeof kakao !== 'undefined' && kakao.maps && kakao.maps.services) {
            initMap();
        } else if (retry > 0) {
            setTimeout(() => tryInitMap(retry - 1), 300);
        }
    }
    tryInitMap(10);
});

document.addEventListener("DOMContentLoaded", function() {
      const deadlineElements = document.querySelectorAll('.dday-calc');
      
      deadlineElements.forEach(el => {
          const deadlineStr = el.getAttribute('data-deadline');
          
          if(deadlineStr) {
              const today = new Date();
              today.setHours(0, 0, 0, 0);
              
              const dDate = new Date(deadlineStr);
              dDate.setHours(0, 0, 0, 0);
              
              const diffTime = dDate - today;
              const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
              
              if(diffDays < 0) {
                  el.textContent = "마감";
              } else if(diffDays === 0) {
                  el.textContent = "D-Day";
              } else {
                  el.textContent = "D-" + diffDays;
              }
          } else {
			el.textContent = "상시모집"; 
			el.style.display = 'inline-flex';
          }
      });
  });
  
  function searchNearbySubway(coords) {
      const container = document.getElementById('subway-list');
      if (!container) return;

      const ps = new kakao.maps.services.Places();

      const options = {
          location: coords,
          radius: 2000, 
          sort: kakao.maps.services.SortBy.DISTANCE
      };

      ps.categorySearch('SW8', function(data, status) {
          console.log("API 응답 상태:", status);
          console.log("받아온 데이터 개수:", data ? data.length : 0);

          if (status === kakao.maps.services.Status.OK && data.length > 0) {
              let html = '';
              
              data.forEach(place => {
                  const distance = parseInt(place.distance);
                  const walkTime = Math.ceil(distance / 80);
                  
                  html += `
                      <div class="nearby-item">
                          <strong>${place.place_name}</strong> 
                          도보 ${walkTime}분 (${distance}m)
                      </div>`;
              });
              container.innerHTML = html;
          } else {
              container.innerHTML = '<div class="nearby-item">인근 지하철역 정보를 찾을 수 없습니다. (2km 내)</div>';
          }
      }, options);
  }
  
  const SalaryCalc = (function() {
      const getModal = () => document.getElementById('salaryModal');
      
      function open() {
          getModal().classList.add('open');
          document.body.style.overflow = 'hidden';
          calculate(); 
      }

      function close() {
          getModal().classList.remove('open');
          document.body.style.overflow = '';
      }

      function calculate() {
          const hourly = parseInt(document.getElementById('calc-hourly-pay').value) || 0;
          const hours = parseFloat(document.getElementById('calc-daily-hours').value) || 0;
          const days = parseInt(document.getElementById('calc-monthly-days').value) || 0;

          const totalHours = hours * days;
          
          let weekHours = hours * (days / 4); 
          let result = hourly * totalHours;

          if (weekHours >= 15) {
              const weeklyBonus = (Math.min(weekHours, 40) / 40) * 8 * hourly;
              result += (weeklyBonus * 4.345); 
          }

          document.getElementById('result-month-pay').textContent = Math.round(result).toLocaleString() + '원';
      }

      return { open, close, calculate };
  })();

  document.addEventListener("DOMContentLoaded", function() {
      const calcBtn = document.querySelector('.btn-calc-mini');
      if(calcBtn) {
          calcBtn.onclick = SalaryCalc.open;
      }

      ['calc-hourly-pay', 'calc-daily-hours', 'calc-monthly-days'].forEach(id => {
          const el = document.getElementById(id);
          if(el) el.oninput = SalaryCalc.calculate;
      });
  });
  
  function openResumeModal() {
      const modal = document.getElementById('resumeModal');
      if(modal) {
          modal.style.display = 'flex';
          document.body.style.overflow = 'hidden'
      }
  }

  function closeResumeModal() {
      const modal = document.getElementById('resumeModal');
      if(modal) {
          modal.style.display = 'none';
          document.body.style.overflow = ''; 
          
          document.getElementById('resumeSelect').value = '';
          document.getElementById('applyMessage').value = '';
          document.getElementById('applyMessageCount').innerText = '0';
      }
  }

  document.getElementById('applyMessage')?.addEventListener('input', function() {
      const currentLength = this.value.length;
      const countSpan = document.getElementById('applyMessageCount');
      if(countSpan) countSpan.innerText = currentLength;
  });

  function submitResume() {
      const resumeIdx = document.getElementById('resumeSelect').value;
      const message = document.getElementById('applyMessage').value;
      const postingIdx = document.getElementById('articleData').getAttribute('data-alba-idx');

      if (!resumeIdx) {
          alert('지원할 이력서를 선택해주세요.');
          document.getElementById('resumeSelect').focus();
          return;
      }

      fetch(`${window.contextPath}/alba/apply`, {
          method: 'POST',
          headers: {
              'Content-Type': 'application/json',
          },
          body: JSON.stringify({
              postingIdx: postingIdx,
              resumeIdx: resumeIdx,
              message: message
          })
      })
      .then(response => response.json())
      .then(data => {
          if(data.success) {
              alert('지원이 완료되었습니다. 좋은 결과가 있기를 바랍니다!');
              closeResumeModal();
              location.reload();
          } else {
              alert(data.message || '지원 처리 중 문제가 발생했습니다.');
          }
      })
      .catch(error => {
          console.error('Error:', error);
          alert('네트워크 오류가 발생했습니다. 다시 시도해주세요.');
      });
  }