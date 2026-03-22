<%@ page contentType="text/html; charset=UTF-8"%>

<template id="crew-hero-template">
    <section class="crew-hero-section" style="width: 100vw; margin-left: calc(-50vw + 50%); border-radius: 0; margin-bottom: 0;">
        <div class="hero-inner">
            <div class="hero-text-box">
                <span class="sub-title">BATON CREW</span>
                <h1 class="main-title">우리 동네 <span class="highlight">크루</span>와 함께</h1>
                <p class="desc">가까운 이웃들과 관심사를 공유하고 새로운 즐거움을 찾아보세요.</p>
            </div>
			<div class="hero-search-box">
	            <i class="ri-search-line"></i>
	            <input type="text" 
	                   v-model="searchKeyword" 
	                   @keydown.enter.prevent="dispatchSearch"
	                   placeholder="관심있는 모임이나 키워드를 검색해보세요">
	            <button class="search-btn" @click="dispatchSearch">검색</button>
	        </div>
        </div>
    </section>
</template>