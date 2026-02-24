document.addEventListener("DOMContentLoaded", function() {
    const currentPath = window.location.pathname;
    const menuItems = document.querySelectorAll('#left-menu-list li a');
    menuItems.forEach(item => {
        if(item.getAttribute('href') === currentPath) item.parentElement.classList.add('active');
    });
});