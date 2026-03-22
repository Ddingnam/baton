<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div v-show="viewMode === 'ARTICLE'">
    <div v-if="!article" style="text-align:center;padding:80px;">
        <i class="ri-loader-4-line" style="font-size:32px;"></i>
    </div>
    <div v-else class="ta-wrap">
        <div class="ta-layout">
            <div class="ta-left">
                <div class="ta-main-card">
                    <div class="ta-img-main" style="cursor:zoom-in;" @click="openLightbox(currentImg)">
                        <img id="mainImage" :src="mainImgSrc" :alt="article.title">
                        <div v-if="['판매완료','예약중','숨기기'].includes(article.tradeStatus)" class="status-overlay">
                            <span class="status-overlay-badge">
                                {{ article.tradeStatus === '예약중' ? '예약 중' : article.tradeStatus === '숨기기' ? '숨겨진 상품' : article.tradeStatus }}
                            </span>
                        </div>
                    </div>
                    <div v-if="articleImages.length > 1" class="ta-thumbs">
                        <div v-for="(img, i) in articleImages" :key="i"
                             class="ta-thumb" :class="{ active: i === currentImg }" @click="currentImg = i">
                            <img :src="img" :alt="'이미지 '+(i+1)">
                        </div>
                    </div>

                    <div class="ta-product-info">
                        <div class="ta-badges">
                            <span v-if="article.categoryName" class="ta-badge ta-badge-cat">{{ article.categoryName }}</span>
                            <span v-if="article.productStatus === '새상품'" class="ta-badge ta-badge-new">새상품</span>
                            <span v-else-if="article.productStatus === '고장/파손'" class="ta-badge ta-badge-broken">고장/파손</span>
                            <span v-else class="ta-badge ta-badge-used">{{ article.productStatus }}</span>
                            <span v-if="article.tradeType === '직거래'"  class="ta-badge ta-badge-direct">직거래</span>
                            <span v-else-if="article.tradeType === '택배'" class="ta-badge ta-badge-parcel">택배</span>
                            <span v-else-if="article.tradeType === '둘다가능'" class="ta-badge ta-badge-both">직거래·택배</span>
                        </div>
                        <h1 class="ta-title">{{ article.title }}</h1>
                        <p class="ta-price" :class="{ free: article.price === 0 }">
                            <template v-if="article.price === 0">나눔</template>
                            <template v-else>{{ Number(article.price).toLocaleString('ko-KR') }}<span class="ta-price-won">원</span></template>
                        </p>
                        <div v-if="articleTags.length" class="ta-tags">
                            <span v-for="tag in articleTags" :key="tag" class="ta-tag">{{ '#' + tag }}</span>
                        </div>
                    </div>

                    <div class="ta-inner-section">
                        <h2 class="ta-section-title">상품 설명</h2>
                        <p class="ta-desc">{{ article.content }}</p>
                    </div>

                    <div class="ta-inner-section">
                        <h2 class="ta-section-title">거래 정보</h2>
                        <div class="ta-info-grid">
                            <div class="ta-info-item">
                                <span class="ta-info-label">거래 방식</span>
                                <span class="ta-info-value">{{ article.tradeType === '둘다가능' ? '직거래·택배' : article.tradeType }}</span>
                            </div>
                            <div class="ta-info-item">
                                <span class="ta-info-label">판매 상태</span>
                                <span class="ta-info-value">{{ articleStatusLabel }}</span>
                            </div>
                            <div class="ta-info-item">
                                <span class="ta-info-label">등록일</span>
                                <span class="ta-info-value">{{ formatTimeAgo(article.lastUpDate) }}</span>
                            </div>
                            <div class="ta-info-item">
                                <span class="ta-info-label">끌어올리기</span>
                                <span class="ta-info-value">{{ article.pullCount }}회</span>
                            </div>
                            <div v-if="article.tradeType !== '택배' && article.tradePlace" class="ta-info-item ta-full">
                                <span class="ta-info-label">거래 희망 장소</span>
                                <span class="ta-info-value">{{ article.tradePlace }}</span>
                                <div id="articleMap"></div>
                            </div>
                            <div v-if="article.tradeType === '택배' || article.tradeType === '둘다가능'" class="ta-info-item ta-full">
                                <span class="ta-info-label">배송비</span>
                                <span class="ta-info-value">{{ article.shippingFee > 0 ? Number(article.shippingFee).toLocaleString('ko-KR') + '원' : '추후 협의' }}</span>
                            </div>
                            <div v-if="article.tradeType === '택배' || article.tradeType === '둘다가능'" class="ta-info-item ta-full ta-notice">
                                <i class="ri-information-line"></i>
                                <span>결제 시 <strong>착불</strong> 또는 <strong>선불</strong>을 선택할 수 있습니다.</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="ta-right">
                <div class="ta-seller-card">
                    <div class="ta-seller-avatar"><i class="ri-user-3-fill"></i></div>
                    <div class="ta-seller-body">
                        <p class="ta-seller-name">{{ article.nickName }}</p>
                        <p class="ta-seller-region"><i class="ri-map-pin-2-fill"></i> {{ article.dong || '동네 정보 없음' }}</p>
                    </div>
                    <div class="ta-seller-actions">
                        <template v-if="articleIsOwner">
                            <button class="ta-seller-btn" @click="goToMyPage()">내정보 보기</button>
                        </template>
                        <template v-else>
                            <button class="ta-seller-btn" @click="goToTradePage(article.userIdx)">프로필 보기</button>
                            <button type="button" class="ta-report-btn" @click="reportOpen = true">
                                <i class="ri-alarm-warning-line"></i><span>신고</span>
                            </button>
                        </template>
                    </div>
                </div>

                <div class="ta-action-panel">
                    <div class="ta-stats">
                        <div class="ta-stat"><i class="ri-eye-line"></i><span class="ta-stat-val">{{ article.hitCount }}</span><span class="ta-stat-lbl">조회</span></div>
                        <div class="ta-stat"><i class="ri-heart-3-line"></i><span class="ta-stat-val">{{ articleLikeCount }}</span><span class="ta-stat-lbl">찜</span></div>
                        <div class="ta-stat"><i class="ri-chat-3-line"></i><span class="ta-stat-val">{{ article.chatCount }}</span><span class="ta-stat-lbl">채팅</span></div>
                    </div>

                    <template v-if="!articleIsLoggedIn">
                        <button v-if="article.tradeStatus === '판매완료'" class="chat-btn" disabled>판매 완료된 상품입니다</button>
                        <button v-else class="chat-btn" @click="location.href = ContextPath + '/member/login'"><i class="ri-chat-3-line"></i> 로그인하고 채팅하기</button>
                        <div class="secondary-actions">
                            <button class="wish-btn-large" @click="location.href = ContextPath + '/member/login'"><i class="ri-heart-3-line"></i> 찜하기</button>
                            <button class="share-btn" @click="shareArticle"><i class="ri-share-line"></i> 공유</button>
                        </div>
                    </template>

                    <template v-else-if="articleIsOwner">
                        <button class="chat-btn" @click="openChatList"><i class="ri-chat-3-line"></i> 채팅 내역 확인하기</button>
                        <template v-if="escrowInfo">
                            <template v-if="escrowInfo.TRADESTATUS === 'PAY_COMPLETED'">
                                <button class="pay-btn" @click="shippingOpen = true"><i class="ri-truck-line"></i> 운송장 입력하기</button>
                                <button class="pay-btn danger" @click="cancelTrade">주문 취소 (구매자에게 환불)</button>
                            </template>
                            <button v-else-if="escrowInfo.TRADESTATUS === 'SHIPPING'"  class="pay-btn" disabled>배송 중 (구매자 확정 대기)</button>
                            <button v-else-if="escrowInfo.TRADESTATUS === 'CONFIRMED'" class="chat-btn" disabled>판매 완료된 상품입니다</button>
                        </template>
                    </template>

                    <template v-else>
                        <button v-if="article.tradeStatus === '판매완료'" class="chat-btn" disabled>판매 완료된 상품입니다</button>
                        <button v-else class="chat-btn" @click="openChatRoom"><i class="ri-chat-3-line"></i> 채팅으로 거래하기</button>
                        <template v-if="article.price > 0">
                            <template v-if="!escrowInfo || escrowInfo.TRADESTATUS === 'CANCELED'">
                                <button type="button" class="pay-btn" @click="goToCheckout(article.productIdx)">
                                    <i class="ri-shield-check-line"></i> 안전 결제하기
                                </button>
                            </template>
                            <template v-else-if="escrowInfo && escrowInfo.BUYERIDX == articleCurrentUserIdx">
                                <template v-if="escrowInfo.TRADESTATUS === 'PAY_COMPLETED'">
                                    <button class="pay-btn" disabled>판매자의 발송을 대기 중입니다</button>
                                    <button class="pay-btn danger" @click="cancelTrade">결제 취소 (포인트 환불)</button>
                                </template>
                                <template v-else-if="escrowInfo.TRADESTATUS === 'SHIPPING'">
                                    <button class="chat-btn" @click="confirmPurchase">구매 확정하기</button>
                                    <button class="pay-btn danger" @click="requestRefund">반품 / 환불 요청하기</button>
                                </template>
                                <button v-else-if="escrowInfo.TRADESTATUS === 'CONFIRMED'" class="pay-btn success" disabled>구매 확정 완료</button>
                            </template>
                            <template v-else>
                                <button class="pay-btn" style="background:#999;" disabled>다른 사용자가 안전결제를 진행 중입니다</button>
                            </template>
                        </template>
                    </template>

                    <div v-if="articleIsLoggedIn" class="secondary-actions">
                        <button class="wish-btn-large" :class="{ active: articleIsLiked }" @click="toggleWishArticle">
                            <i :class="articleIsLiked ? 'ri-heart-3-fill' : 'ri-heart-3-line'"></i> 찜 {{ articleLikeCount }}
                        </button>
                        <button class="share-btn" @click="shareArticle"><i class="ri-share-line"></i> 공유</button>
                    </div>

                    <div v-if="articleIsOwner" class="ta-owner-section">
                        <p class="ta-owner-label">게시글 관리</p>
                        <div class="ta-owner-grid">
                            <button type="button" class="btn-manage status-style" :class="{ 'disabled-style': article.tradeStatus === '판매완료' }" @click="statusOpen = true"><i class="ri-loop-left-line"></i> 상태 변경</button>
                            <button type="button" class="btn-manage pull-style" :class="{ 'disabled-style': article.tradeStatus === '판매완료' }" @click="pullUp"><i class="ri-rocket-2-line"></i> 끌어올리기</button>
                            <button v-if="article.tradeStatus === '판매완료'" type="button" class="btn-manage edit-style disabled-style"><i class="ri-edit-line"></i> 수정</button>
                            <button v-else type="button" class="btn-manage edit-style" @click="goUpdate(article.productIdx)"><i class="ri-edit-line"></i> 수정</button>
                            <button type="button" class="btn-manage delete-style" @click="doDelete"><i class="ri-delete-bin-line"></i> 삭제</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="lightbox" :class="{ open: lightboxOpen }" @click.self="lightboxOpen = false">
            <button class="lightbox-close" @click="lightboxOpen = false"><i class="ri-close-line"></i></button>
            <button class="lightbox-nav lightbox-prev" @click="lightboxPrev"><i class="ri-arrow-left-s-line"></i></button>
            <img id="lightboxImg" :src="lightboxSrc" alt="확대 이미지">
            <button class="lightbox-nav lightbox-next" @click="lightboxNext"><i class="ri-arrow-right-s-line"></i></button>
            <p class="lightbox-count">{{ lightboxIdx + 1 }} / {{ articleImages.length }}</p>
        </div>

        <div class="modal-overlay" :class="{ open: statusOpen }" @click.self="statusOpen = false">
            <div class="modal-content" @click.stop>
                <div class="modal-header">
                    <h3>상태 변경</h3>
                    <button type="button" class="close-modal" @click="statusOpen = false"><i class="ri-close-line"></i></button>
                </div>
                <div class="status-options">
                    <button type="button" class="status-opt" :class="{ active: article.tradeStatus === '판매중' }" @click="updateStatus('판매중')">판매중</button>
                    <button type="button" class="status-opt" :class="{ active: article.tradeStatus === '예약중' }" @click="updateStatus('예약중')">예약중</button>
                    <button type="button" class="status-opt sold-out-opt" :class="{ active: article.tradeStatus === '판매완료' }" @click="updateStatus('판매완료')">판매완료</button>
                    <hr>
                    <button type="button" class="status-opt hide-opt" :class="{ active: article.tradeStatus === '숨기기' }" @click="updateStatus('숨기기')">숨기기</button>
                </div>
            </div>
        </div>

        <div class="modal-overlay" :class="{ open: shippingOpen }" @click.self="shippingOpen = false">
            <div class="modal-content" @click.stop>
                <div class="modal-header">
                    <h3>운송장 정보 입력</h3>
                    <button type="button" class="close-modal" @click="shippingOpen = false"><i class="ri-close-line"></i></button>
                </div>
                <div class="shipping-form">
                    <div class="shipping-field">
                        <label>택배사</label>
                        <select id="deliveryCompany" v-model="shipping.company">
                            <option>CJ대한통운</option><option>우체국택배</option><option>한진택배</option>
                            <option>롯데택배</option><option>로젠택배</option>
                            <option>GS25편의점택배</option><option>CU편의점택배</option>
                        </select>
                    </div>
                    <div class="shipping-field">
                        <label>운송장 번호</label>
                        <input type="text" id="trackingNumber" v-model="shipping.trackingNumber" placeholder="- 없이 숫자만 입력">
                    </div>
                </div>
                <button type="button" class="pay-btn" @click="submitShipping">발송 처리 완료하기</button>
            </div>
        </div>

        <div id="reportModal" class="report-modal-overlay" v-show="reportOpen" @click.self="reportOpen = false">
            <div class="report-modal-sheet">
                <div class="report-modal-head">
                    <span class="report-modal-title"><i class="ri-alarm-warning-line"></i> 신고하기</span>
                    <button type="button" class="report-modal-close" @click="reportOpen = false"><i class="ri-close-line"></i></button>
                </div>
                <div class="report-modal-body">
                    <p class="report-modal-desc">신고 사유를 선택해주세요. 허위 신고는 제재를 받을 수 있습니다.</p>
                    <div class="report-type-list">
                        <label class="report-type-item"><input type="radio" name="reportType" value="스팸" v-model="report.type"><span class="report-type-label"><i class="ri-spam-line"></i> 스팸 / 광고</span></label>
                        <label class="report-type-item"><input type="radio" name="reportType" value="욕설/비방" v-model="report.type"><span class="report-type-label"><i class="ri-emotion-unhappy-line"></i> 욕설 / 비방</span></label>
                        <label class="report-type-item"><input type="radio" name="reportType" value="음란물" v-model="report.type"><span class="report-type-label"><i class="ri-eye-off-line"></i> 음란물 / 불건전</span></label>
                        <label class="report-type-item"><input type="radio" name="reportType" value="사기" v-model="report.type"><span class="report-type-label"><i class="ri-error-warning-line"></i> 사기 / 허위 정보</span></label>
                        <label class="report-type-item"><input type="radio" name="reportType" value="개인정보침해" v-model="report.type"><span class="report-type-label"><i class="ri-user-forbid-line"></i> 개인정보 침해</span></label>
                        <label class="report-type-item"><input type="radio" name="reportType" value="기타" v-model="report.type"><span class="report-type-label"><i class="ri-more-line"></i> 기타</span></label>
                    </div>
                    <div class="report-content-wrap">
                        <textarea class="report-content-input" v-model="report.content"
                                  placeholder="추가로 전달할 내용이 있으면 입력해주세요. (선택)" maxlength="300"></textarea>
                        <span class="report-content-count">{{ report.content.length }}/300</span>
                    </div>
                </div>
                <div class="report-modal-foot">
                    <button type="button" class="report-btn-cancel" @click="reportOpen = false">취소</button>
                    <button type="button" class="report-btn-submit" @click="submitReport">신고 접수</button>
                </div>
            </div>
        </div>
    </div>
</div>
