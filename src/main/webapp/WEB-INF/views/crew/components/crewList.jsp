<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<template id="crew-list-template">
	<div>
		<div class="container content-wrapper">
			<div class="crew-toolbar">
				<div class="toolbar-top">
					<div class="filter-group">
						<button class="filter-btn active">전체</button>
						<button class="filter-btn">스터디</button>
						<button class="filter-btn">독서</button>
						<button class="filter-btn">운동</button>
						<button class="filter-btn">여행</button>
						<button class="filter-btn">취미/게임</button>
						<button class="filter-btn">문화/예술</button>
						<button class="filter-btn">맛집/카페</button>
						<button class="filter-btn">가족/육아</button>
						<button class="filter-btn">반려동물</button>
						<button class="filter-btn">기타</button>
					</div>
					<button class="btn-create-crew" @click="$router.push('/write')">
						<i class="ri-add-line"></i>모임 개설
					</button>
				</div>

				<div class="toolbar-bottom">
					<div class="region-select-group">
						<select class="detail-select"><option>서울시 강남구</option></select> <select
							class="detail-select"><option>역삼동</option></select>
					</div>

					<div class="action-group">
						<label class="toggle-switch-wrap"> <input type="checkbox"
							class="pink-switch" checked> <span class="toggle-label">모집
								중만 보기</span>
						</label> <span class="divider">|</span> <select
							class="detail-select sort-select">
							<option>최신순</option>
							<option>인기순</option>
							<option>마감임박순</option>
						</select>
					</div>
				</div>
			</div>

			<div class="crew-grid">
				<c:forEach var="i" begin="1" end="6">
					<div class="crew-card" @click="$router.push('/article/${i}')">
						<div class="card-image-box no-image">
							<i class="ri-camera-off-line placeholder-icon"></i>
							<div class="badge-group">
								<span class="badge recruiting">모집중</span> <span
									class="badge d-day">D-3</span>
							</div>
							<button class="wish-btn" @click.stop="toggleWish(${i})">
								<i class="ri-heart-3-line"></i>
							</button>
						</div>

						<div class="card-info">
							<div class="card-meta">운동/스포츠 · 강남구 역삼동</div>
							<h3 class="card-title">매주 화요일 저녁, 한강 야간 러닝 크루 모집합니다! 🏃‍♂️</h3>

							<div class="card-tags">
								<span>#초보환영</span><span>#2030</span><span>#오운완</span>
							</div>

							<div class="card-details">
								<div class="detail-item">
									<i class="ri-calendar-event-line"></i> 이번주 목요일 20:00
								</div>
								<div class="detail-item">
									<i class="ri-money-dollar-circle-line"></i> 참가비 없음
								</div>
							</div>

							<div class="member-gauge">
								<div class="gauge-text">
									참여 인원 <strong>12</strong><span>/20명</span>
								</div>
								<div class="gauge-bar">
									<div class="gauge-fill" style="width: 60%;"></div>
								</div>
							</div>

							<div class="card-footer">
								<div class="host-info">
									<div class="host-avatar">
										<i class="ri-user-smile-line"></i>
									</div>
									<span class="host-name">런닝조아</span>
								</div>
								<div class="interaction-info">
									<span><i class="ri-eye-line"></i> 245</span> <span><i
										class="ri-heart-3-fill wish-icon"></i> 12</span>
								</div>
							</div>
						</div>
					</div>
				</c:forEach>
			</div>

			<div class="pagination-container">${paging}</div>
		</div>
	</div>
</template>