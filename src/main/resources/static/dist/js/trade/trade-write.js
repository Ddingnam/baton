const toggleImage = (function() {
    let uploadedFiles = [];
    const previewList = document.getElementById('previewList');
    const imgCount = document.getElementById('imgCount');

    function init() {
        const fileInput = document.getElementById('selectFile');
        if(!fileInput) return;

        fileInput.addEventListener('change', function() {
            const newFiles = Array.from(this.files);
            const remaining = 5 - uploadedFiles.length;
            newFiles.slice(0, remaining).forEach(file => {
                if (!file.type.startsWith('image/')) return;
                const reader = new FileReader();
                reader.onload = e => {
                    uploadedFiles.push({ file: file, url: e.target.result, isExisting: false });
                    render();
                };
                reader.readAsDataURL(file);
            });
            this.value = '';
        });
    }

    function addExisting(url, imgOrder) {
        uploadedFiles.push({ url: url, imgOrder: imgOrder, isExisting: true });
        render();
    }

    function remove(idx) {
        const target = uploadedFiles[idx];
        if(target.isExisting) {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'deleteImgOrders';
            input.value = target.imgOrder;
            document.getElementById('tradeForm').appendChild(input);
        }
        uploadedFiles.splice(idx, 1);
        render();
    }

    function render() {
        if(!previewList) return;
        previewList.innerHTML = '';
		
		const dataTransfer = new DataTransfer();
		
        uploadedFiles.forEach((item, i) => {
            const div = document.createElement('div');
            div.className = 'preview-item';
            let html = `<img src="${item.url}">`;
            if (i === 0) html += '<div class="thumb-badge">대표</div>';
            html += `<button type="button" class="remove-img-btn" onclick="toggleImage.remove(${i})">✕</button>`;
            div.innerHTML = html;
            previewList.appendChild(div);
			
			if(!item.isExisting && item.file) {
				dataTransfer.items.add(item.file);
			}
        });
		
		document.getElementById('selectFile').files = dataTransfer.files;
		
        imgCount.textContent = uploadedFiles.length + '/5';
    }

    return { init, remove, addExisting };
})();

document.addEventListener('DOMContentLoaded', function() {
    const dropdown = document.getElementById('categoryDropdown');
	if(!dropdown) return;
	
    const selected = dropdown.querySelector('.dropdown-selected');
    const menu = dropdown.querySelector('.dropdown-menu');
    const hiddenInput = document.getElementById('selectedCategory');
    const selectedText = dropdown.querySelector('.selected-text');

    selected.addEventListener('click', () => {
        dropdown.classList.toggle('active');
    });

    menu.querySelectorAll('li').forEach(item => {
        item.addEventListener('click', function() {
            const value = this.dataset.value;
            const text = this.innerText;

            hiddenInput.value = value;
            selectedText.innerText = text;

            menu.querySelectorAll('li').forEach(li => li.classList.remove('active'));
            this.classList.add('active');

            dropdown.classList.remove('active');
        });
    });

    document.addEventListener('click', (e) => {
        if (!dropdown.contains(e.target)) dropdown.classList.remove('active');
    });
});

const toggleTag = (function() {
    let tags = [];
    const tagInput = document.getElementById('tagInput');
    const tagWrap = document.getElementById('tagWrap');

    function init() {
        if(!tagInput) return;
        tagInput.addEventListener('keydown', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                add(this.value);
                this.value = '';
            }
            if (e.key === 'Backspace' && !this.value && tags.length) {
                tags.pop();
                render();
            }
        });
    }

    function add(val) {
        val = val.trim().replace(/^#/, '');
        if (val && tags.length < 5 && !tags.includes(val)) {
            tags.push(val);
            render();
        }
    }

    function remove(idx) {
        tags.splice(idx, 1);
        render();
    }

    function render() {
        if(!tagWrap) return;
        tagWrap.querySelectorAll('.tag-chip').forEach(el => el.remove());
        tags.forEach((tag, i) => {
            const span = document.createElement('span');
            span.className = 'tag-chip';
            span.innerHTML = `#${tag}<button type="button" onclick="toggleTag.remove(${i})" style="border:none;background:none;color:inherit;cursor:pointer">×</button>`;
            tagWrap.insertBefore(span, tagInput);
        });
        document.getElementById('finalTags').value = tags.join(',');
    }

    return { init, remove, add };
})();

const TradeLogic = (function() {
    function toggleOptions(type) {
        const locationField = document.getElementById('locationField');
		const shippingFeeField = document.getElementById('shippingFeeField');
        const locationInput = document.getElementById('locationInput');
		const shippingFeeInput = document.getElementById('shippingFeeInput');
		
		if (type === '직거래' || type === '둘다가능') {
			locationField.style.display = 'block';
			MapManager.relayout();
		} else {
			locationField.style.display = 'none';
			if(locationInput) locationInput.value = '';
		}

		if (type === '택배' || type === '둘다가능') {
			shippingFeeField.style.display = 'block';
		} else {
			shippingFeeField.style.display = 'none';
			if(shippingFeeInput) shippingFeeInput.value = '0';
		}
	}
	return { toggleOptions };
})();

const PriceFormatter = (function() {
    function format(value) {
		value = String(value).replace(/[^0-9]/g, '');
		return value.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }

    function unformat(value) {
        return value.replace(/[^\d]+/g, '');
    }

    function init() {
        const priceInput = document.getElementById('priceInput');
        const shippingFeeInput = document.getElementById('shippingFeeInput');
        const freeCheck = document.getElementById('freeCheck');

        [priceInput, shippingFeeInput].forEach(input => {
            if(!input) return;
            input.addEventListener('input', function() {
                if(this.readOnly) return;
                this.value = format(this.value);
            });
            if(input.value) input.value = format(input.value);
        });

		if (freeCheck && priceInput) {
			freeCheck.addEventListener('change', function() {
				if (this.checked) {
					priceInput.value = "0";
					priceInput.readOnly = true;
				} else {
					priceInput.value = "";
					priceInput.readOnly = false;
					priceInput.focus();
				}
			});

			const currentVal = unformat(priceInput.value);
			if (currentVal === "0" && priceInput.value !== "") {
				freeCheck.checked = true;
				priceInput.readOnly = true;
			}
        }
    }

    return { init, unformat };
})();

const MapManager = (function() {
    let map, marker, geocoder;

    function init() {
        const container = document.getElementById('map');
        if (!container) return;

        const lat = document.getElementById('latitude').value || 37.566826;
        const lng = document.getElementById('longitude').value || 126.9786567;
        const loc = new kakao.maps.LatLng(lat, lng);

        map = new kakao.maps.Map(container, { center: loc, level: 3 });
        marker = new kakao.maps.Marker({ position: loc, map: map });
        geocoder = new kakao.maps.services.Geocoder();

        kakao.maps.event.addListener(map, 'click', function(e) {
            marker.setPosition(e.latLng);
            document.getElementById('latitude').value = e.latLng.getLat();
            document.getElementById('longitude').value = e.latLng.getLng();
        });
    }

    function search() {
        const addr = document.getElementById('locationInput').value;
        if (!addr) return alert("검색할 주소를 입력하세요.");
        geocoder.addressSearch(addr, function(result, status) {
            if (status === kakao.maps.services.Status.OK) {
                const coords = new kakao.maps.LatLng(result[0].y, result[0].x);
                map.setCenter(coords);
                marker.setPosition(coords);
                document.getElementById('latitude').value = result[0].y;
                document.getElementById('longitude').value = result[0].x;
            }
        });
    }

    function relayout() {
        if (map) setTimeout(() => { map.relayout(); }, 100);
    }

    return { init, search, relayout };
})();

const initDropdown = () => {
    const dropdown = document.getElementById('categoryDropdown');
    if (!dropdown) return;

    const selected = dropdown.querySelector('.dropdown-selected');
    const menu = dropdown.querySelector('.dropdown-menu');
    const hiddenInput = document.getElementById('selectedCategory');
    const selectedText = dropdown.querySelector('.selected-text');

    // 클릭 이벤트 (전파 방지 포함)
    selected.addEventListener('click', (e) => {
        e.stopPropagation();
        dropdown.classList.toggle('active');
    });

    // 항목 선택 이벤트
    menu.querySelectorAll('li').forEach(item => {
        item.addEventListener('click', function(e) {
            e.stopPropagation();
            const val = this.dataset.value;
            const txt = this.innerText;

            hiddenInput.value = val;
            selectedText.innerText = txt;

            // active 클래스 이동
            menu.querySelectorAll('li').forEach(li => li.classList.remove('active'));
            this.classList.add('active');

            // 메뉴 닫기
            dropdown.classList.remove('active');
        });
    });

    // 외부 클릭 시 닫기
    document.addEventListener('click', (e) => {
        if (!dropdown.contains(e.target)) {
            dropdown.classList.remove('active');
        }
    });
};

window.onload = function() {
    toggleImage.init();
    toggleTag.init();
    PriceFormatter.init();
    MapManager.init();

    const urlParams = new URLSearchParams(window.location.search);
    const productIdx = urlParams.get('productIdx');
    const isUpdate = window.location.pathname.includes('update');
    const tempIdx = document.getElementById('tempProductIdx')?.value;

    const renderData = (data) => {
        if (!data || !data.trade) return;
        const t = data.trade;

        if (document.getElementById('titleInput')) document.getElementById('titleInput').value = t.title || '';
        if (document.getElementById('contentInput')) document.getElementById('contentInput').value = t.content || '';
        if (document.getElementById('locationInput')) document.getElementById('locationInput').value = t.tradePlace || '';
        if (document.getElementById('latitude')) document.getElementById('latitude').value = t.latitude || '';
        if (document.getElementById('longitude')) document.getElementById('longitude').value = t.longitude || '';

        const formatNumber = (num) => (num || 0).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        if (document.getElementById('priceInput')) document.getElementById('priceInput').value = formatNumber(t.price);
        if (document.getElementById('shippingFeeInput')) document.getElementById('shippingFeeInput').value = formatNumber(t.shippingFee);

        if (data.imageList) data.imageList.forEach(img => toggleImage.addExisting(img.imgUrl, img.imgOrder));
        if (data.tagList) data.tagList.forEach(tagName => toggleTag.add(tagName));

        if (t.tradeType) {
            const tr = document.querySelector(`input[name="tradeType"][value="${t.tradeType}"]`);
            if (tr) {
                tr.checked = true;
                TradeLogic.toggleOptions(t.tradeType);
            }
        }

        if (t.categoryIdx) {
            const hiddenCat = document.getElementById('selectedCategory');
            const catText = document.querySelector('.custom-dropdown .selected-text');
            if (hiddenCat && catText) {
                hiddenCat.value = t.categoryIdx;
                const activeLi = document.querySelector(`.dropdown-menu li[data-value="${t.categoryIdx}"]`);
                if (activeLi) {
                    catText.innerText = activeLi.innerText.trim();
                    document.querySelectorAll('.dropdown-menu li').forEach(li => li.classList.remove('active'));
                    activeLi.classList.add('active');
                }
            }
        }
        
        MapManager.init();
    };

    if (isUpdate && productIdx) {
        fetch(`${contextPath}/trade/updateData?productIdx=${productIdx}`).then(res => res.json()).then(renderData);
    } else if (tempIdx && tempIdx !== '0') {
        if (confirm("작성 중인 임시저장 글이 있습니다. 불러오시겠습니까?")) {
            fetch(`${contextPath}/trade/updateData?productIdx=${tempIdx}`).then(res => res.json()).then(renderData);
        } else {
            TradeLogic.toggleOptions('직거래');
        }
    } else {
        TradeLogic.toggleOptions('직거래');
    }
};

function submitForm(status) {
    const f = document.tradeForm;
	const priceInput = document.getElementById('priceInput');
	const shippingFeeInput = document.getElementById('shippingFeeInput');
	const freeCheck = document.getElementById('freeCheck');
	const tradeType = f.tradeType.value;
	
	const statusInput = document.getElementById('tradeStatus');
	if (statusInput) {
		statusInput.value = status;
	}
	
	if (!f.title.value.trim()) {
		alert('제목을 입력하세요.');
		f.title.focus();
		return;
	}

	if (!f.categoryIdx.value) {
		alert('카테고리를 선택해주세요.');
		f.categoryIdx.focus();
		return;
	}
	
	const rawPrice = PriceFormatter.unformat(priceInput.value);
	if (!freeCheck.checked && (!rawPrice || rawPrice === '0')) {
		alert('판매 가격을 입력하거나 무료나눔을 선택해주세요.');
		priceInput.focus();
		return;
	}

	priceInput.value = freeCheck.checked ? '0' : rawPrice;

	if (shippingFeeInput) {
		let rawShipping = PriceFormatter.unformat(shippingFeeInput.value);
	        
		if ((tradeType === '택배' || tradeType === '둘다가능') && !rawShipping) {
			rawShipping = '0'; 
		}
	        
		shippingFeeInput.value = rawShipping || '0';
	}
    
    const mode = f.mode ? f.mode.value : 'write';
    f.action = (mode === 'update') ? '/trade/update' : '/trade/write';
    f.submit();
}