<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="icon" href="data:;base64,iVBORw0KGgo=">
<style>
    .write-container { width: 800px; margin: 20px auto; font-family: sans-serif; }
    .form-group { margin-bottom: 20px; }
    .form-group label { display: block; font-weight: bold; margin-bottom: 5px; }
    .form-control { width: 100%; padding: 10px; box-sizing: border-box; }
    
    /* 물품 상태 버튼 스타일 */
    .status-group { display: flex; gap: 10px; }
    .status-group input[type="radio"] { display: none; }
    .status-group label {
        padding: 8px 15px; border: 1px solid #ccc; border-radius: 20px;
        cursor: pointer; font-size: 14px; background: #fff;
    }
    .status-group input[type="radio"]:checked + label {
        background: #28a745; color: white; border-color: #28a745;
    }

    /* 태그 스타일 */
    .tag-container { border: 1px solid #ccc; padding: 5px; display: flex; flex-wrap: wrap; gap: 5px; }
    .tag-item { background: #e9ecef; padding: 3px 10px; border-radius: 15px; font-size: 13px; }
    .tag-item .del-btn { margin-left: 5px; color: red; cursor: pointer; }
    
    .btn-submit { padding: 15px; width: 100%; background: #28a745; color: white; border: none; font-size: 16px; cursor: pointer; }
</style>
</head>
<body>

<div class="write-container">
    <h2>중고거래 상품 등록</h2>
    <hr>
    <form id="tradeForm" name="tradeForm" method="post" enctype="multipart/form-data">
        
        <div class="form-group">
            <label>상품 이미지 (최대 5장)</label>
            <input type="file" name="selectFile" id="selectFile" accept="image/*" multiple>
            <small id="fileHelp" style="color: #666;">첫 번째 사진은 썸네일로 사용됩니다.</small>
        </div>

        <div class="form-group">
            <label>제목</label>
            <input type="text" name="title" class="form-control" placeholder="제목을 입력하세요" required>
        </div>

        <div class="form-group">
            <label>카테고리</label>
            <select name="categoryIdx" class="form-control" required>
                <option value="">카테고리 선택</option>
                <option value="1">전자기기</option>
                <option value="2">의류</option>
                <option value="3">뷰티</option>
                <option value="4">스타굿즈</option>
                </select>
        </div>

        <div class="form-group">
            <label>물품 상태</label>
            <div class="status-group">
                <input type="radio" name="productStatus" id="s1" value="새상품" checked>
                <label for="s1">새상품</label>
                
                <input type="radio" name="productStatus" id="s2" value="사용감없음">
                <label for="s2">사용감없음</label>
                
                <input type="radio" name="productStatus" id="s3" value="사용감적음">
                <label for="s3">사용감적음</label>
                
                <input type="radio" name="productStatus" id="s4" value="사용감많음">
                <label for="s4">사용감많음</label>
                
                <input type="radio" name="productStatus" id="s5" value="고장/파손">
                <label for="s5">고장/파손</label>
            </div>
        </div>

        <div class="form-group">
            <label>판매 가격</label>
            <input type="number" name="price" class="form-control" placeholder="숫자만 입력 (₩)" required>
        </div>

        <div class="form-group">
            <label>상품 설명</label>
            <textarea name="content" class="form-control" rows="8" placeholder="상품에 대한 설명을 자세히 적어주세요."></textarea>
        </div>

        <div class="form-group">
            <label>거래 방식</label>
            <input type="radio" name="tradeType" value="직거래" checked> 직거래
            <input type="radio" name="tradeType" value="택배"> 택배
            <input type="radio" name="tradeType" value="둘다가능"> 둘 다 가능
        </div>

        <div class="form-group">
            <label>거래 희망 장소</label>
            <input type="text" name="tradePlace" class="form-control" placeholder="장소를 입력하세요 (예: 강남역 1번 출구)">
        </div>

        <div class="form-group">
            <label>태그 (최대 5개)</label>
            <div class="tag-container" id="tagList">
                <input type="text" id="tagInput" class="form-control" style="border:none; width: auto; flex-grow: 1;" placeholder="태그 입력 후 Enter">
            </div>
            <input type="hidden" name="tags" id="finalTags">
        </div>

        <button type="button" class="btn-submit" onclick="submitForm()">게시글 등록하기</button>
    </form>
</div>

<script type="text/javascript">

const tags = [];
const tagInput = document.getElementById('tagInput');
const tagList = document.getElementById('tagList');
const finalTags = document.getElementById('finalTags');

tagInput.addEventListener('keydown', function(e) {
    if (e.key === 'Enter') {
        e.preventDefault();
        const val = this.value.trim().replace('#', '');
        if (val && tags.length < 5 && !tags.includes(val)) {
            tags.push(val);
            renderTags();
        }
        this.value = '';
    }
});

function renderTags() {
    // 입력창 제외하고 초기화
    const inputHtml = tagInput.outerHTML;
    tagList.innerHTML = '';
    tags.forEach((tag, index) => {
        const span = document.createElement('span');
        span.className = 'tag-item';
        span.innerHTML = `#${tag} <span class="del-btn" onclick="removeTag(${index})">&times;</span>`;
        tagList.appendChild(span);
    });
    tagList.appendChild(tagInput);
    tagInput.focus();
    // hidden 필드에 콤마로 구분해서 저장 (서버에서 split 가능)
    finalTags.value = tags.join(',');
}

function removeTag(index) {
    tags.splice(index, 1);
    renderTags();
}

// 폼 제출 로직
function submitForm() {
    const f = document.tradeForm;
    
    // 이미지 유효성 체크
    const files = document.getElementById('selectFile').files;
    if(files.length > 5) {
        alert("이미지는 최대 5장까지 가능합니다.");
        return;
    }
    if(files.length === 0) {
        alert("이미지를 최소 1장 등록해주세요.");
        return;
    }

    // 나중에 Vue나 Axios로 바꾸기 편하게 action 설정
    f.action = "/trade/write"; 
    f.submit();
}
</script>

</body>
</html>