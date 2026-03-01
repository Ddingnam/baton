$(function() {
    /* 1. Sidebar Accordion (Maknaez Logic) */
    $(document).on('click', '.nav-item.has-sub > .nav-link', function(e) {
        e.preventDefault();
        
        // 접혀있으면 펼치기
        if ($('body').hasClass('sb-fold')) {
            $('body').removeClass('sb-fold');
        }

        const $item = $(this).parent('.nav-item');
        const $sub = $item.find('.sub-nav');

        // 다른 메뉴 닫기
        $('.nav-item.has-sub').not($item).removeClass('open').find('.sub-nav').slideUp(200);

        // 토글
        $item.toggleClass('open');
        $sub.stop(true, true).slideToggle(200);
    });

    /* 2. Sidebar Toggle */
    $('#toggleSidebar').on('click', function() {
        $('body').toggleClass('sb-fold');
    });

    /* 3. Profile Modal */
    $('#btnProfile').on('click', function(e) {
        e.stopPropagation();
        $('#modalProfile').toggleClass('show');
    });

    $(document).on('click', function(e) {
        if (!$(e.target).closest('.header-right').length) {
            $('#modalProfile').removeClass('show');
        }
    });

    /* 4. Active State */
    const path = window.location.pathname;
    
    // Submenu Active
    $('.sub-link').each(function() {
        const href = $(this).attr('href');
        if (href && path.indexOf(href) !== -1) {
            $(this).addClass('current');
            $(this).closest('.sub-nav').show();
            $(this).closest('.nav-item').addClass('open');
            $(this).closest('.nav-item').find('.nav-link').addClass('active');
        }
    });

    // Main Menu Active
    $('.nav-item:not(.has-sub) .nav-link').each(function() {
        const href = $(this).attr('href');
        if (href && path === href) {
            $(this).addClass('active');
        }
    });
});