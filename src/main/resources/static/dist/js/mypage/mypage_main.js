(function () {
    'use strict';

    function initMypage() {
        var root = document.getElementById('mp-theme-root');
        var tabs = document.querySelectorAll('.tab-item');
        var sections = document.querySelectorAll('.mp-section');

        if (!root || tabs.length === 0 || sections.length === 0) return;

        var urlParams = new URLSearchParams(window.location.search);
        var activeTabParam = urlParams.get('tab');
        var activeInnerParam = urlParams.get('inner');

        var targetTab = document.querySelector('.tab-item[data-target="sec-overview"]');

        if (activeTabParam) {
            var foundTab = document.querySelector('.tab-item[data-target="sec-' + activeTabParam + '"]');
            if (foundTab) {
                targetTab = foundTab;
            }
        }

        function applyTheme(tab) {
            tabs.forEach(function (t) { t.classList.remove('active'); });
            tab.classList.add('active');

            var color = tab.getAttribute('data-color');
            var bg    = tab.getAttribute('data-bg');

            root.style.setProperty('--mp-theme', color);
            root.style.setProperty('--mp-theme-bg', bg);

            document.documentElement.style.setProperty('--header-domain-color', color);
            document.documentElement.style.setProperty('--header-domain-bg', bg);

            var targetId = tab.getAttribute('data-target');
            sections.forEach(function (sec) {
                sec.classList.remove('active');
                if (sec.id === targetId) {
                    sec.classList.add('active');
                }
            });
        }

        tabs.forEach(function (tab) {
            tab.addEventListener('click', function () {
                applyTheme(tab);

                var newParam = tab.getAttribute('data-target').replace('sec-', '');
                var newUrl   = window.location.pathname + '?tab=' + newParam;
                window.history.replaceState({}, '', newUrl);
            });
        });

		if (targetTab) {
		    applyTheme(targetTab);

		    if (activeInnerParam) {
		        var prefix = activeTabParam === 'community' ? 'comm' : activeTabParam;
		        var selector = '.inner-tab[data-inner="' + prefix + '-' + activeInnerParam + '"]';
		        var targetInnerBtn = document.querySelector(selector);

		        if (targetInnerBtn) {
		            setTimeout(function () {
		                targetInnerBtn.click();
		            }, 100);
		        }
		    }
		}
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initMypage);
    } else {
        initMypage();
    }

    window.addEventListener('DOMContentLoaded', function() {
        document.querySelectorAll('.inner-tab').forEach(function(tab) {
            tab.addEventListener('click', function() {
                var card = this.closest('.list-card');
                card.querySelectorAll('.inner-tab').forEach(function(t) { t.classList.remove('active'); });
                card.querySelectorAll('.inner-section').forEach(function(s) { s.classList.remove('active'); });
                this.classList.add('active');
                var target = this.getAttribute('data-inner');
                var sec = document.getElementById(target);
                if (sec) sec.classList.add('active');
            });
        });
    });
	
	let isApplying = false;
    function submitResume(postingIdx, resumeIdx) {
		if (isApplying) {
		        return; 
		    }
		isApplying = true
		
		fetch(`${CONTEXT_PATH}/alba/apply-posting`, { 
		        method: 'POST',
		        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
		        body: new URLSearchParams({ postingIdx, profileIdx: resumeIdx, message: '' })
		    })
        .then(res => res.text())
        .then(result => {
            if(result === 'success') alert('지원 완료!');
            else if(result === 'duplicate') alert('이미 지원한 공고입니다.');
            else if(result === 'login_required') alert('로그인 후 지원 가능합니다.');
            location.reload();
        })
		.catch(err => {
		        console.error(err);
		        isApplying = false; // 에러 났을 때만 다시 누를 수 있게 풀어줌
		});
    }
	
	function formatDate(dateString) {
	    if (!dateString) return '';
	    const date = new Date(dateString);
	    return `${date.getMonth() + 1}월 ${date.getDate()}일`;
	}

	function loadAlbaApply() {
	    const container = document.querySelector("#alba-apply .lc-list");
	    if(!container) return;

	    fetch(`${CONTEXT_PATH}/alba/mypage/alba-apply`)
	        .then(res => res.json())
	        .then(data => {
	            container.innerHTML = '';
	            if (!data || data.length === 0) {
	                container.innerHTML = `
	                    <div class="lc-empty">
	                        <i class="ri-briefcase-line"></i>
	                        <p>지원한 공고가 없습니다.</p>
	                    </div>
	                `;
	                return;
	            }

	            data.forEach(apply => {
	                const statusBadge = apply.status === '열람대기' ? 
	                    `<span class="theme-badge-outline">열람대기</span>` :
	                    apply.status === '서류통과' ? 
	                    `<span class="theme-badge">서류통과</span>` :
	                    `<span style="background:#F2F4F6;color:#8B95A1;padding:6px 12px;border-radius:8px;font-size:13px;font-weight:700;">불합격</span>`;

	                const html = `
	                    <div class="lc-item">
	                        <div class="item-info">
	                            <span class="corp-name theme-text">${apply.employer || ''}</span>
	                            <h4>${apply.title || ''}</h4>
	                            <p class="info-metrics">
	                                ${apply.payType || ''} ${apply.pay ? apply.pay.toLocaleString() : '0'}원 · 
	                                ${formatDate(apply.applyDate)} 지원
	                            </p>
	                        </div>
	                        <div class="item-right">
	                            ${statusBadge}
	                        </div>
	                    </div>
	                `;
	                container.innerHTML += html;
	            });
	        })
	        .catch(err => {
	            console.error(err);
	            container.innerHTML = `<div class="lc-empty"><p>불러오는 중 오류가 발생했습니다.</p></div>`;
	        });
	}
	
	function loadCrewData() {
		const joinedContainer = document.getElementById("joined-list-container");
		const hostedContainer = document.getElementById("hosted-list-container");
	    
	    if(!joinedContainer || !hostedContainer) return;

	    fetch(`${CONTEXT_PATH}/api/crew/myCrew`)
	        .then(res => res.json())
	        .then(data => {
	            const crew_j = data.myCrewListJoined || [];
	            const crew_h = data.myCrewListCreated || [];
	            
	            joinedContainer.innerHTML = '';
	            hostedContainer.innerHTML = '';

                const emptyHtml = `<div class="lc-item"><p style="padding:20px; color:#999; text-align:center; width:100%;">참여 중인 모임이 없습니다.</p></div>`;
				
	            if (crew_j.length === 0) {
	                joinedContainer.innerHTML = emptyHtml;
	            } else {
					crew_j.forEach(crew => {
		                const dateStr = crew.joinedDate.substring(0, 10);
						
						let badgeStyle = '';
					    let statusText = crew.status;

						if (crew.status === 'ACTIVE') {
					        badgeStyle = 'background: #E8F5E9; color: #2E7D32;';
					        statusText = '활동중';
					    } else if (crew.status === 'WAIT') {
					        badgeStyle = 'background: #FFF4E5; color: #FF9800;';
					        statusText = '승인대기';
					    } else if (crew.status === 'BANNED') {
					        badgeStyle = 'background: #FFE9E9; color: #F86D7D;';
					        statusText = '강퇴';
					    } else {
					        badgeStyle = 'background: #F2F4F6; color: #8B95A1;';
					        statusText = crew.status;
					    }
		                
		                const html = `
		                    <div class="lc-item">
		                        <div class="item-icon theme-icon-bg"><i class="ri-run-line"></i></div>
		                        <div class="item-info">
		                            <h4>${crew.name}</h4>
		                            <p class="info-metrics">참여멤버 ${crew.currentMember}명 · ${dateStr} 가입</p>
		                        </div>
								<div class="item-right">
					                <span class="theme-badge" style="${badgeStyle}">${statusText}</span>
					            </div>
		                    </div>
		                `;
		                
		                joinedContainer.innerHTML += html;
		            });
				}
				
	            if (crew_h.length === 0) {
	                hostedContainer.innerHTML = emptyHtml;
	            } else {
					crew_h.forEach(crew => {
		                const dateStr = crew.createdDate.substring(0, 10);
		                
		                const html = `
		                    <div class="lc-item">
		                        <div class="item-icon theme-icon-bg"><i class="ri-run-line"></i></div>
		                        <div class="item-info">
		                            <h4>${crew.name}</h4>
		                            <p class="info-metrics">참여멤버 ${crew.currentMember}명 · ${dateStr} 생성</p>
		                        </div>
		                    </div>
		                `;
		                
		                hostedContainer.innerHTML += html;
		            });
				}
	        })
	        .catch(err => console.error("모임 데이터 로딩 실패:", err));
	}

	document.addEventListener('DOMContentLoaded', function() {
	    loadAlbaApply();
	    loadCrewData();
	});

})();

