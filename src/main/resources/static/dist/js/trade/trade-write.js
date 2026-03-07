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

window.onload = function() {
    toggleImage.init();
    toggleTag.init();
    PriceFormatter.init();
    
    const urlParams = new URLSearchParams(window.location.search);
    const productIdx = urlParams.get('productIdx');
    const isUpdate = window.location.pathname.includes('update');
    const tempIdx = document.getElementById('tempProductIdx')?.value;

    if (isUpdate && productIdx) {
        loadData(productIdx);
    } 
    else if (tempIdx && tempIdx !== '0') {
        if (confirm("작성 중인 임시저장 글이 있습니다. 불러오시겠습니까?")) {
            loadData(tempIdx);
            if(!document.querySelector('input[name="productIdx"]')) {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'productIdx';
                input.value = tempIdx;
                document.getElementById('tradeForm').appendChild(input);
            }
        }
    } else {
        TradeLogic.toggleOptions('직거래');
    }
};


window.onload = function() {
    toggleImage.init();
    toggleTag.init();
    if (typeof PriceFormatter !== 'undefined' && PriceFormatter.init) {
        PriceFormatter.init();
    }
    
    const urlParams = new URLSearchParams(window.location.search);
    const productIdx = urlParams.get('productIdx');
    const isUpdate = window.location.pathname.includes('update');
    const tempIdx = document.getElementById('tempProductIdx')?.value;

    const renderData = (data) => {
        if (!data || !data.trade) return;
        const t = data.trade;

        // 1. 기본 텍스트 필드
        if (document.getElementById('titleInput')) document.getElementById('titleInput').value = t.title || '';
        if (document.getElementById('contentInput')) document.getElementById('contentInput').value = t.content || '';
        if (document.getElementById('locationInput')) document.getElementById('locationInput').value = t.tradePlace || '';

        // 2. 가격 및 배송비 (에러 방지를 위해 직접 포맷팅)
        const formatNumber = (num) => (num || 0).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        
        if (document.getElementById('priceInput')) {
            document.getElementById('priceInput').value = formatNumber(t.price);
        }
        if (document.getElementById('shippingFeeInput')) {
            document.getElementById('shippingFeeInput').value = formatNumber(t.shippingFee);
        }

        // 3. 이미지 로드
        if (data.imageList) {
            data.imageList.forEach(img => {
                if (toggleImage && toggleImage.addExisting) {
                    toggleImage.addExisting(img.imgUrl, img.imgOrder);
                }
            });
        }

        // 4. 태그 로드
        if (data.tagList) {
            data.tagList.forEach(tagName => {
                if (toggleTag && toggleTag.add) {
                    toggleTag.add(tagName);
                }
            });
        }

        // 5. 거래 방식 설정 및 UI 토글
        if (t.tradeType) {
            const tr = document.querySelector(`input[name="tradeType"][value="${t.tradeType}"]`);
            if (tr) {
                tr.checked = true;
                if (TradeLogic && TradeLogic.toggleOptions) {
                    TradeLogic.toggleOptions(t.tradeType);
                }
            }
        }

        // 6. 카테고리 설정
        if (t.categoryIdx) {
            const hiddenInput = document.getElementById('selectedCategory');
            const selectedText = document.querySelector('.custom-dropdown .selected-text');
            if (hiddenInput && selectedText) {
                hiddenInput.value = t.categoryIdx;
                const activeLi = document.querySelector(`.dropdown-menu li[data-value="${t.categoryIdx}"]`);
                if (activeLi) {
                    selectedText.innerText = activeLi.innerText.trim();
                    document.querySelectorAll('.dropdown-menu li').forEach(li => li.classList.remove('active'));
                    activeLi.classList.add('active');
                    selectedText.style.display = 'inline-block';
                }
            }
        }

        // 7. productIdx 히든 필드 생성
        if (!document.querySelector('input[name="productIdx"]')) {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'productIdx';
            input.value = t.productIdx;
            document.getElementById('tradeForm').appendChild(input);
        }
    };

    if (isUpdate && productIdx) {
        fetch(`${contextPath}/trade/updateData?productIdx=${productIdx}`)
            .then(res => res.json())
            .then(renderData)
            .catch(err => console.error(err));
    } else if (tempIdx && tempIdx !== '0') {
        if (confirm("작성 중인 임시저장 글이 있습니다. 불러오시겠습니까?")) {
            fetch(`${contextPath}/trade/updateData?productIdx=${tempIdx}`)
                .then(res => res.json())
                .then(renderData)
                .catch(err => console.error(err));
        } else {
            if (TradeLogic && TradeLogic.toggleOptions) TradeLogic.toggleOptions('직거래');
        }
    } else {
        if (TradeLogic && TradeLogic.toggleOptions) TradeLogic.toggleOptions('직거래');
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