const btnTop = document.getElementById('btn-top');
if(btnTop) {
    window.addEventListener('scroll', () => {
        if (window.scrollY > 300) btnTop.style.display = 'block';
        else btnTop.style.display = 'none';
    });
    btnTop.addEventListener('click', () => {
        window.scrollTo({ top: 0, behavior: 'smooth' });
    });
}