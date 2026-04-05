<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<aside class="crew-sidebar">
    <div class="crew-list">
        <div class="crew-icon home-icon" 
             title="BATON 메인"
             @click="$router.push('/')">
			 <i class="ri-home-4-line"></i>
        </div>

        <hr class="sidebar-divider" v-if="myCrewList && myCrewList.length > 0">

        <div v-for="item in myCrewList" 
             :key="item.crewIdx" 
             class="crew-icon" 
             :title="item.name"
             @click="$router.push('/article/' + item.crewIdx)">
            
            <template v-if="item.logoImage">
                <img :src="'/uploads/crew/' + item.logoImage" 
                     class="crew-logo-img" 
                     alt="모임 로고">
            </template>
            
            <template v-else>
                <span v-text="item.name.substring(0, 1)"></span>
            </template>
        </div>

        <div class="crew-icon add-crew-btn" 
             title="모임 추가" 
             @click="$router.push('/write')">
            <i class="ri-add-line"></i>
        </div>
    </div>
</aside>