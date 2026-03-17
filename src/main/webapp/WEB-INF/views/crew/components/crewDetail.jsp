<%@ page contentType="text/html; charset=UTF-8"%>

<template id="crew-detail-template">
    <div class="content-wrapper" style="margin-top: 40px; padding-bottom: 80px;">
        <div style="background: #fff; border-radius: 20px; padding: 40px; border: 1px solid var(--border-color); box-shadow: 0 10px 30px rgba(0,0,0,0.02);">
            <div class="card-tags" style="margin-bottom: 12px;">
                <span>#운동</span><span>#러닝</span>
            </div>
            <h1 style="font-size: 28px; font-weight: 800; margin-bottom: 20px;">주말 아침 한강 러닝 크루 모집합니다! 초보 환영해요 🏃‍♂️</h1>
            
            <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border-color); padding-bottom: 20px; margin-bottom: 30px;">
                <div class="host-info" style="gap: 12px;">
                    <div class="host-avatar" style="width: 40px; height: 40px; font-size: 18px;">런</div>
                    <div>
                        <div class="host-name" style="font-size: 15px;">런닝맨</div>
                        <div style="font-size: 12px; color: var(--text-light); margin-top: 4px;">서울시 강남구 · 2시간 전 작성</div>
                    </div>
                </div>
                <div class="interaction-info">
                    <span><i class="ri-eye-line"></i> 124</span>
                </div>
            </div>

            <div style="font-size: 16px; line-height: 1.6; color: var(--text-sub); min-height: 200px;">
                안녕하세요! 주말마다 한강을 뛰는 런닝 크루입니다.<br>
                초보자도 무리 없이 뛸 수 있는 페이스로 진행할 예정이니 부담 없이 참여해 주세요.<br>
                뛰고 나서 간단하게 커피 한잔 하면서 친목도 다져요!
            </div>

            <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 40px; padding-top: 20px; border-top: 1px solid var(--border-color);">
                <div class="member-gauge" style="width: 250px;">
                    <div class="gauge-text"><span>현재 참여 인원</span><strong>3 / 10명</strong></div>
                    <div class="gauge-bar"><div class="gauge-fill" style="width: 30%;"></div></div>
                </div>
                <div style="display: flex; gap: 12px;">
                    <button style="padding: 12px 20px; border-radius: 12px; border: 1px solid var(--border-color); background: #fff; cursor: pointer; font-size: 20px; color: var(--text-light);"><i class="ri-heart-3-line"></i></button>
                    <button class="btn-create-crew" style="padding: 12px 40px; font-size: 16px;">참여하기</button>
                </div>
            </div>
        </div>
    </div>
</template>