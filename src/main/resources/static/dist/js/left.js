/**
 * 사이드바 토글 핸들러
 */
function handleSidebar() {
    const container = document.getElementById('baton-layout-container');
    const openBtn = document.getElementById('baton-sidebar-open');
    
    if (!container) {
        console.error("Layout container not found");
        return;
    }

    container.classList.toggle('sidebar-hidden');
    
    if (openBtn) {
        if (container.classList.contains('sidebar-hidden')) {
            openBtn.style.display = 'flex';
        } else {
            openBtn.style.display = 'none';
        }
    }
}

window.addEventListener('load', () => {
    const container = document.getElementById('baton-layout-container');
    const openBtn = document.getElementById('baton-sidebar-open');
    if(container && openBtn) {
        openBtn.style.display = container.classList.contains('sidebar-hidden') ? 'flex' : 'none';
    }
});