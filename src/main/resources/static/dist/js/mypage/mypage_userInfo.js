let isNicknameVerified = true;

async function checkNickname() {
    const nicknameInput = document.getElementById('ui-nickname');
	const submitBtn = document.querySelector('button[type="submit"]');
    const nickname = nicknameInput.value.trim();
    const originalNickname = nicknameInput.dataset.original;

    if (!nickname) {
        showBatonToast("닉네임을 입력해주세요.");
        nicknameInput.focus();
        return;
    }

    if (nickname === originalNickname) {
        showBatonToast("현재 사용 중인 본인의 닉네임입니다.");
		isNicknameVerified = true;
        submitBtn.disabled = false;
        return;
    }

    try {
        const url = `${CONTEXT_PATH}/member/checkDuplicated?type=nickname&input=${encodeURIComponent(nickname)}`;
        const response = await fetch(url);
        const data = await response.json();

        if (data.state === "available") {
			isNicknameVerified = true;
            submitBtn.disabled = false;
            showBatonToast("사용 가능한 닉네임입니다.");
        } else if (data.state === "duplicated") {
			isNicknameVerified = false;
            submitBtn.disabled = true;
            showBatonToast("이미 사용 중인 닉네임입니다.");
            nicknameInput.focus();
        } else {
            isNicknameVerified = false;
			submitBtn.disabled = true;
            showBatonToast("중복 검사 중 오류가 발생했습니다.");
        }
    } catch (error) {
        console.error("Check Error:", error);
        showBatonToast("서버 통신 오류가 발생했습니다.");
    }
}

document.addEventListener("DOMContentLoaded", () => {
    const userInfoForm = document.getElementById('ui-userInfoForm');
    const nicknameInput = document.getElementById('ui-nickname');
	const submitBtn = userInfoForm.querySelector('button[type="submit"]');
    const originalNickname = nicknameInput.value.trim();
    
    nicknameInput.dataset.original = originalNickname;

    nicknameInput.addEventListener('input', function() {
		const currentVal = this.value.trim();
        if (currentVal === originalNickname) {
            isNicknameVerified = true;
            submitBtn.disabled = false;
        } else {
            isNicknameVerified = false;
            submitBtn.disabled = true;
        }
    });

    userInfoForm.addEventListener('submit', (e) => {
        if (!isNicknameVerified) {
            e.preventDefault();
            showBatonToast("닉네임 중복 확인을 완료해주세요.");
            nicknameInput.focus();
        }
    });

    const photoPreview = document.getElementById('ui-photo-preview');
    const photoPlaceholder = document.getElementById('ui-photo-placeholder');
    const fileInput = document.getElementById('ui-profileUpload');
    const btnDelete = document.getElementById('ui-btn-delete');
    const deletedPhotoInput = document.getElementById('ui-deletedPhoto');
    const photoWrapper = document.getElementById('ui-photo-wrapper');
    const hasOriginalPhoto = photoWrapper.dataset.hasOriginal === 'true';
    let currentObjectURL = null;

    const updatePhotoDisplay = (showImage, src = '') => {
        if (showImage) {
            photoPreview.src = src;
            photoPreview.classList.remove('ui-hidden');
            photoPlaceholder.classList.add('ui-hidden');
            btnDelete.classList.remove('ui-hidden');
        } else {
            photoPreview.src = '';
            photoPreview.classList.add('ui-hidden');
            photoPlaceholder.classList.remove('ui-hidden');
            btnDelete.classList.add('ui-hidden');
        }
    };

    fileInput.addEventListener('change', (e) => {
        const file = e.target.files[0];
        if (!file || !file.type.match('image.*')) return;
        
        deletedPhotoInput.value = 'false';
        if (currentObjectURL) URL.revokeObjectURL(currentObjectURL);
        currentObjectURL = URL.createObjectURL(file);
        updatePhotoDisplay(true, currentObjectURL);
    });

    btnDelete.addEventListener('click', () => {
        fileInput.value = '';
        if (currentObjectURL) URL.revokeObjectURL(currentObjectURL);
        updatePhotoDisplay(false);
        deletedPhotoInput.value = hasOriginalPhoto ? 'true' : 'false';
    });
});