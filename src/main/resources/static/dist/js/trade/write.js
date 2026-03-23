function useTradeWrite(shared) {
    const { Vue, ContextPath } = window;
    const { ref, reactive, computed, watch, nextTick } = Vue;

    const { categories, viewMode } = shared;

    const writeMode = ref('write');
    const currentProductIdx = ref('');
    const tempProductIdx = ref('');
    const catOpen = ref(false);
    const aiLoading  = ref(false);
    const existingFiles = ref([]);
    const newFiles = ref([]);
    const newFilePreviews = ref([]);
    const deletedImgOrders = ref([]);
    const tags = ref([]);
    const tagInput = ref('');

    const wForm = reactive({
        title: '', content: '', price: 0, categoryIdx: '',
        productStatus: '미개봉', tradeType: '직거래',
        shippingFee: '', tradePlace: '', latitude: '', longitude: '',
        tradeStatus: '판매중'
    });

    const isFree = ref(false);
    const priceDisplay = computed({
        get: () => isFree.value ? '0' : (wForm.price ? Number(String(wForm.price).replace(/,/g,'')).toLocaleString('ko-KR') : ''),
        set: v  => { wForm.price = v.replace(/,/g, ''); }
    });
	
    watch(isFree, v => { if (v) wForm.price = 0; });

    const totalImgCount   = computed(() => existingFiles.value.length + newFiles.value.length);
    const selectedCatName = computed(() => {
        const c = categories.value.find(c => c.CATEGORYIDX == wForm.categoryIdx);
        return c ? c.CATEGORYNAME : '카테고리를 선택하세요';
    });

    function selectCat(cat) { 
		wForm.categoryIdx = cat.CATEGORYIDX; 
		catOpen.value = false; 
	}

    function onFileChange(e) {
        const files = Array.from(e.target.files);
        files.slice(0, 5 - totalImgCount.value).forEach(f => {
            newFiles.value.push(f);
            newFilePreviews.value.push(URL.createObjectURL(f));
        });
        e.target.value = '';
    }
	
    function removeExisting(i) { 
		deletedImgOrders.value.push(existingFiles.value[i].imgOrder); 
		existingFiles.value.splice(i, 1); 
	}
	
    function removeNew(i) { 
		URL.revokeObjectURL(newFilePreviews.value[i]); 
		newFiles.value.splice(i, 1); 
		newFilePreviews.value.splice(i, 1); 
	}

    function addTag() {
        const t = tagInput.value.trim().replace(/[\[\]#]/g, '');
        if (t && tags.value.length < 5 && !tags.value.includes(t)) tags.value.push(t);
        tagInput.value = '';
    }
	
    function removeTag(i){ 
		tags.value.splice(i, 1); 
	}
	
    function onTagBackspace() { 
		if (!tagInput.value && tags.value.length) tags.value.pop(); 
	}

    async function aiGenerate() {
        if (newFiles.value.length === 0 && existingFiles.value.length === 0) { 
			alert('먼저 상품 사진을 최소 1장 등록해주세요!'); 
			return; 
		}
        aiLoading.value = true;
		try {
			const fd = new FormData();
				
			if (newFiles.value[0]) {
				fd.append('imageFile', newFiles.value[0]);
			} else {
				fd.append('imageUrl', existingFiles.value[0].url);
			}

			const res = await fetch('/api/trade/aigenerate', { method: 'POST', body: fd });
			const data = await res.json();
		        
			if (data.status === 'success') { 
				wForm.title = data.title; 
		        wForm.content = data.content; 
			} else {
				alert('이미지 분석에 실패했습니다.');
			}
		} catch (e) { 
			console.error(e); 
		} finally { 
			aiLoading.value = false;
		}
    }

    let _map = null, _marker = null;

    function initMapWrite() {
        if (!window.kakao?.maps) return;
        const container = document.getElementById('map');
        if (!container) return;
        const lat = parseFloat(wForm.latitude) || 37.566826;
        const lng = parseFloat(wForm.longitude) || 126.9786567;
        const loc = new kakao.maps.LatLng(lat, lng);
        if (_map) {
            _map.relayout();
            _map.setCenter(loc);
            if (_marker) _marker.setPosition(loc);
            return;
        }
        _map = new kakao.maps.Map(container, { center: loc, level: 3 });
        _marker = new kakao.maps.Marker({ position: loc, map: _map });
        kakao.maps.event.addListener(_map, 'click', e => {
            _marker.setPosition(e.latLng);
            wForm.latitude  = e.latLng.getLat();
            wForm.longitude = e.latLng.getLng();
        });
    }

    watch(() => wForm.tradeType, v => {
        if (v === '직거래' || v === '둘다가능') nextTick(() => setTimeout(initMapWrite, 50));
    });

    watch(viewMode, v => {
        if (v === 'WRITE' && (wForm.tradeType === '직거래' || wForm.tradeType === '둘다가능'))
            nextTick(() => setTimeout(initMapWrite, 50));
    });

    function resetWForm() {
        Object.assign(wForm, { 
			title:'', 
			content:'', 
			price:0, 
			categoryIdx:'', 
			productStatus:'미개봉', 
			tradeType:'직거래', 
			shippingFee:'', 
			tradePlace:'', 
			latitude:'', 
			longitude:'', 
			tradeStatus:'판매중' 
		});
		
        isFree.value = false;
        existingFiles.value = [];
		newFiles.value = []; 
		newFilePreviews.value = []; 
		deletedImgOrders.value = [];
        tags.value = []; 
		tagInput.value = '';
        _map = null; 
		_marker = null;
    }

    function fillWForm(data) {
        if (!data?.trade) return;
        const t = data.trade;
        wForm.title = t.title || '';
        wForm.content = t.content || '';
        wForm.price = t.price || 0;
        wForm.categoryIdx = t.categoryIdx || '';
        wForm.productStatus = t.productStatus || '미개봉';
        wForm.tradeType = t.tradeType || '직거래';
        wForm.shippingFee = t.shippingFee || '';
        wForm.tradePlace = t.tradePlace || '';
        wForm.latitude = t.latitude || '';
        wForm.longitude = t.longitude || '';
        wForm.tradeStatus = t.tradeStatus || '판매중';
        isFree.value = t.price === 0;
		
        if (data.imageList) data.imageList.forEach(img => existingFiles.value.push({ url: img.imgUrl, imgOrder: img.imgOrder }));
        if (data.tagList) tags.value = [...data.tagList];
    }

	
	async function initWrite(productIdx = null) {
	    resetWForm();
	    writeMode.value = productIdx ? 'update' : 'write';
	    currentProductIdx.value = productIdx || '';

	    const res = await fetch('/api/trade/write-init');
	    const data = await res.json();

	    if (categories.value.length === 0) {
	        categories.value = data.categoryList || [];
	    }
	    tempProductIdx.value = data.tempProductIdx || '';

	    if (!productIdx && tempProductIdx.value) {
	        nextTick(() => {
	            if (confirm('작성 중인 임시저장 글이 있습니다. 불러오시겠습니까?')) {
	                writeMode.value = 'write';
	                currentProductIdx.value = tempProductIdx.value;

	                fetch('/api/trade/updateData?productIdx=' + tempProductIdx.value)
	                    .then(r => r.json())
	                    .then(data => fillWForm(data));
	            }
	        });
	    } else if (productIdx) {
	        const res = await fetch('/api/trade/updateData?productIdx=' + productIdx);
	        fillWForm(await res.json());
	    }

	    nextTick(() => setTimeout(initMapWrite, 50));
	}
	
	function onlyNumberKey(e) {
	    const allowedKeys = ['Backspace', 'Tab', 'Enter', 'Escape', 'ArrowLeft', 'ArrowRight', 'Delete'];
	    if (allowedKeys.includes(e.key)) return;
	    
	    if (!/^[0-9]$/.test(e.key)) {
	        e.preventDefault();
	    }
	}

	function validateNumber(e) {
		const rawValue = e.target.value.replace(/[^0-9]/g, '');
		const formattedValue = rawValue ? Number(rawValue).toLocaleString('ko-KR') : '';
		    
		wForm.shippingFee = rawValue;
		e.target.value = formattedValue;
	}
	
	function validatePrice(e) {
	    const rawValue = e.target.value.replace(/[^0-9]/g, '');
	    const formattedValue = rawValue ? Number(rawValue).toLocaleString('ko-KR') : '';
	    
	    wForm.price = rawValue;
	    e.target.value = formattedValue;
	}

	async function submitForm(status) {
	    const f = document.getElementById('tradeForm');
	    if (!f) return;

	    const rawPrice = String(wForm.price || '0').replace(/[^0-9]/g, '');
	    const rawShipping = String(wForm.shippingFee || '0').replace(/[^0-9]/g, '');

	    if (existingFiles.value.length === 0 && newFiles.value.length === 0) {
	        showBatonToast('상품 사진을 최소 1장 이상 등록해주세요.');
	        return;
	    }

	    if (!wForm.title.trim()) {
	        showBatonToast('제목을 입력하세요.');
	        document.getElementById('titleInput')?.focus();
	        return;
	    }

	    if (!wForm.categoryIdx) {
	        showBatonToast('카테고리를 선택해주세요.');
	        return;
	    }

	    if (!wForm.content.trim()) {
	        showBatonToast('상품 소개 내용을 입력해주세요.');
	        document.getElementById('contentInput')?.focus();
	        return;
	    }

	    if (!isFree.value && (rawPrice === '0' || rawPrice === '')) {
	        showBatonToast('판매 가격을 입력하거나 무료나눔을 선택해주세요.');
	        document.getElementById('priceInput')?.focus();
	        return;
	    }
	    
	    const type = wForm.tradeType;

	    if (type === '직거래' || type === '둘다가능') {
	        if (!wForm.tradePlace.trim()) {
	            showBatonToast('직거래 희망 장소를 입력해주세요.');
	            document.getElementById('locationInput')?.focus();
	            return;
	        }
	        if (!wForm.latitude || !wForm.longitude) {
	            showBatonToast('지도에서 정확한 거래 위치를 선택해주세요.');
	            return;
	        }
	    }

	    if (type === '택배' || type === '둘다가능') {
	        if (!rawShipping || rawShipping === '') {
	            showBatonToast('택배 거래 시 배송비를 입력해주세요.');
	            document.getElementById('shippingFeeInput')?.focus();
	            return;
	        }
	    }

	    f.querySelector('[name="price"]').value = isFree.value ? '0' : rawPrice;
	    f.querySelector('[name="shippingFee"]').value = (type === '직거래') ? '0' : rawShipping;
	    f.querySelector('[name="tradeStatus"]').value = status;

	    const latInput = f.querySelector('[name="latitude"]');
	    const lngInput = f.querySelector('[name="longitude"]');

	    if (type === '택배' || !wForm.latitude) {
	        latInput.disabled = true;
	        lngInput.disabled = true;
	    } else {
	        latInput.disabled = false;
	        latInput.value = wForm.latitude;
	        lngInput.value = wForm.longitude;
	    }

	    const dt = new DataTransfer();
	    newFiles.value.forEach(file => dt.items.add(file));
	    f.querySelector('input[name="newFiles"]').files = dt.files;

	    const finalTags = document.getElementById('finalTags');
	    if (finalTags) finalTags.value = tags.value.join(',');
		
		const url = currentProductIdx.value ? '/api/trade/update' : '/api/trade/write';
		const formData = new FormData(f);
		
		try {
			const response = await fetch(url, {
				method: 'POST',
				body: formData
			});
			const result = await response.json();

			if (result.status === 'success') {
				location.href = '/trade/main';
			} else {
				showBatonToast('저장에 실패했습니다: ' + (result.message || '알 수 없는 오류'));
			}
		} catch (error) {
			console.error('Submit Error:', error);
			showBatonToast('서버 전송 중 오류가 발생했습니다.');
		}
	}

    return {
        writeMode, currentProductIdx, tempProductIdx,
        catOpen, aiLoading, existingFiles, newFiles, newFilePreviews, deletedImgOrders,
        tags, tagInput, wForm, isFree, priceDisplay, totalImgCount, selectedCatName,
        initWrite, onlyNumberKey, validateNumber, validatePrice, selectCat, onFileChange, removeExisting, removeNew, 
        addTag, removeTag, onTagBackspace, aiGenerate, submitForm
    };
}
