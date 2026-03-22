<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div v-show="viewMode === 'WRITE'">
    <div class="page-wrap">
        <div class="header-content">
            <button class="back-btn" @click="goList()">
                <i class="ri-arrow-left-s-line" style="font-size:24px;"></i>
            </button>
            <div class="title-set">
                <h1>{{ writeMode === 'update' ? '상품 정보 수정' : '내 물건 팔기' }}</h1>
                <p>우리 동네 이웃들과 따뜻한 거래를 시작해보세요.</p>
            </div>
        </div>

        <form id="tradeForm" name="tradeForm" method="post" enctype="multipart/form-data">
            <div class="grid-layout">
                <div class="main-side">
                    <div class="card">
                        <div class="field">
                            <label>상품 이미지 (최대 5장)</label>
                            <div class="image-section">
                                <div class="img-add-btn" @click="$refs.fileInput.click()">
                                    <span style="font-size:24px;">📸</span>
                                    <span style="color:var(--primary);font-weight:700;" id="imgCount">{{ totalImgCount }}/5</span>
                                </div>
                                <div id="previewList" style="display:flex;gap:12px;flex-wrap:wrap;">
                                    <div v-for="(f, i) in existingFiles" :key="'ex'+i" class="preview-item">
                                        <img :src="f.url">
                                        <div v-if="i===0 && newFiles.length===0" class="thumb-badge">대표</div>
                                        <button type="button" class="remove-img-btn" @click="removeExisting(i)">✕</button>
                                    </div>
                                    <div v-for="(f, i) in newFilePreviews" :key="'nw'+i" class="preview-item">
                                        <img :src="f">
                                        <div v-if="existingFiles.length===0 && i===0" class="thumb-badge">대표</div>
                                        <button type="button" class="remove-img-btn" @click="removeNew(i)">✕</button>
                                    </div>
                                </div>
                            </div>
                            <input type="file" ref="fileInput" name="newFiles" accept="image/*" multiple style="display:none" @change="onFileChange">
                            <input v-for="order in deletedImgOrders" :key="order" type="hidden" name="deleteImgOrders" :value="order">
                        </div>

                        <p class="card-title">상품 정보</p>
                        <div class="field">
                            <label>제목</label>
                            <div class="ai-input-group">
                                <input type="text" name="title" id="titleInput" maxlength="50"
                                       placeholder="어떤 물건을 파시나요?" v-model="wForm.title">
                                <button type="button" id="btnAiAssistant" class="ai-magic-btn"
                                        @click="aiGenerate" :disabled="aiLoading">
                                    <i class="ri-magic-line"></i> AI 작성
                                </button>
                            </div>
                            <div id="aiStatus" class="ai-status-msg" v-show="aiLoading">
                                <span class="ai-spinner"></span> 이미지를 분석하여 AI가 내용을 구성하고 있습니다...
                            </div>
                        </div>
                        <div class="field" style="margin-bottom:0;">
                            <label>상품 설명</label>
                            <textarea name="content" id="contentInput" maxlength="2000"
                                      placeholder="브랜드, 모델명, 구매 시기, 사용 기간, 하자 여부 등 자세히 작성할수록 빨리 팔려요 😊"
                                      v-model="wForm.content"></textarea>
                            <div class="content-count-wrap">
                                <span id="contentCount">{{ wForm.content.length }}/2000</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="sticky-side">
                    <div class="submit-container">
                        <div class="card">
                            <p class="card-title">기본 정보</p>
                            <div class="field">
                                <label>판매 가격</label>
                                <div class="price-wrap">
                                    <span class="won-sign">₩</span>
                                    <input type="text" name="price" id="priceInput" placeholder="0"
                                           v-model="priceDisplay" :readonly="isFree">
                                </div>
                                <div class="free-check-wrapper">
                                    <input type="checkbox" id="freeCheck" v-model="isFree">
                                    <label for="freeCheck">무료나눔</label>
                                </div>
                            </div>
                            <div class="field">
                                <label>카테고리</label>
                                <div class="custom-dropdown" id="categoryDropdown"
                                     :class="{ active: catOpen }"
                                     @click.stop="catOpen = !catOpen">
                                    <input type="hidden" name="categoryIdx" id="selectedCategory" :value="wForm.categoryIdx">
                                    <div class="dropdown-selected">
                                        <span class="selected-text">{{ selectedCatName }}</span>
                                        <i class="ri-arrow-down-s-line"></i>
                                    </div>
                                    <ul class="dropdown-menu">
                                        <li v-for="cat in categories" :key="cat.CATEGORYIDX"
                                            :class="{ active: wForm.categoryIdx == cat.CATEGORYIDX }"
                                            @click.stop="selectCat(cat)">{{ cat.CATEGORYNAME }}</li>
                                    </ul>
                                </div>
                            </div>
                            <div class="field" style="margin-bottom:0;">
                                <label>태그</label>
                                <div class="tag-outer-container">
								    <div v-for="(tag, i) in tags" :key="i" class="tag-item">
								        <span class="tag-hash">#</span>
								        <span class="tag-text">{{ tag }}</span>
								        <span class="tag-remove" @click="removeTag(i)">&times;</span>
								    </div>
								    <input type="text" 
								           v-model="tagInput" 
								           @keydown.enter.prevent="addTag" 
								           @keydown.backspace="onTagBackspace"
								           placeholder="태그 입력 후 엔터"
								           class="tag-input-field">
								</div>
                                <input type="hidden" name="tags" id="finalTags" :value="tags.join(',')">
                            </div>
                        </div>

                        <div class="card">
                            <p class="card-title">거래 조건</p>
                            <div class="field">
                                <label>상품 상태</label>
                                <div class="pill-group">
                                    <input type="radio" name="productStatus" id="s1" value="미개봉"  v-model="wForm.productStatus"><label for="s1">미개봉</label>
                                    <input type="radio" name="productStatus" id="s2" value="사용감없음" v-model="wForm.productStatus"><label for="s2">사용감 없음</label>
                                    <input type="radio" name="productStatus" id="s3" value="사용감적음" v-model="wForm.productStatus"><label for="s3">사용감 적음</label>
                                    <input type="radio" name="productStatus" id="s4" value="사용감많음" v-model="wForm.productStatus"><label for="s4">사용감 많음</label>
                                    <input type="radio" name="productStatus" id="s5" value="고장/파손" v-model="wForm.productStatus"><label for="s5">고장/파손</label>
                                </div>
                            </div>
                            <div class="field" style="margin-bottom:0;">
                                <label>거래 방식</label>
                                <div class="trade-type-group">
                                    <input type="radio" name="tradeType" id="t1" value="직거래" v-model="wForm.tradeType"><label for="t1">직거래</label>
                                    <input type="radio" name="tradeType" id="t2" value="택배" v-model="wForm.tradeType"><label for="t2">택배</label>
                                    <input type="radio" name="tradeType" id="t3" value="둘다가능" v-model="wForm.tradeType"><label for="t3">둘 다 가능</label>
                                </div>
                            </div>
                            <div class="field" id="shippingFeeField" v-show="wForm.tradeType === '택배' || wForm.tradeType === '둘다가능'">
                                <label>배송비</label>
                                <div class="price-wrap">
                                    <span class="won-sign">₩</span>
                                    <input type="text" name="shippingFee" id="shippingFeeInput" placeholder="0" v-model="wForm.shippingFee">
                                </div>
                            </div>
                            <div class="field" id="locationField" v-show="wForm.tradeType === '직거래' || wForm.tradeType === '둘다가능'">
                                <label>거래 희망 장소</label>
                                <div class="location-search-wrap">
                                    <input type="text" name="tradePlace" id="locationInput"
                                           placeholder="예) 강남역 1번 출구 앞, OO빌딩 정문"
                                           v-model="wForm.tradePlace">
                                </div>
                                <div id="map"></div>
                                <p class="map-info-text"><i class="ri-information-line"></i> 지도를 클릭하여 위치를 표시해주세요.</p>
                                <input type="hidden" name="latitude"  id="latitude"  v-model="wForm.latitude">
                                <input type="hidden" name="longitude" id="longitude" v-model="wForm.longitude">
                            </div>
                        </div>

                        <input type="hidden" name="mode" :value="writeMode">
                        <input type="hidden" name="tradeStatus" id="tradeStatus" :value="wForm.tradeStatus || '판매중'">
                        <input type="hidden" name="productIdx" v-if="writeMode === 'update'" :value="currentProductIdx">
                        <input type="hidden" id="tempProductIdx" :value="tempProductIdx">

                        <button v-if="writeMode !== 'update'" type="button" class="temp-submit-btn" @click="submitForm('임시저장')">임시저장</button>
                        <button type="button" class="submit-btn" @click="submitForm(wForm.tradeStatus || '판매중')">
                            {{ writeMode === 'update' ? '수정 완료하기' : '게시글 등록하기' }}
                        </button>
                        <button type="button" class="cancel-btn" @click="goList()">취소</button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>
