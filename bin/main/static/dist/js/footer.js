document.addEventListener('DOMContentLoaded', () => {
    const btnTop = document.getElementById('btn-top');
    if (btnTop) {
        window.addEventListener('scroll', () => {
            if (window.scrollY > 400) {
                btnTop.style.display = 'flex';
                btnTop.style.alignItems = 'center';
                btnTop.style.justifyContent = 'center';
            } else {
                btnTop.style.display = 'none';
            }
        });

        btnTop.addEventListener('click', () => {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });
    }
});