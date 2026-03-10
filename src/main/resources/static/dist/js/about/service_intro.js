document.addEventListener('DOMContentLoaded', () => {
    
    const cssLink = document.createElement('link');
    cssLink.rel = 'stylesheet';
    cssLink.href = 'https://unpkg.com/aos@2.3.1/dist/aos.css';
    document.head.appendChild(cssLink);

    const script = document.createElement('script');
    script.src = 'https://unpkg.com/aos@2.3.1/dist/aos.js';
    document.body.appendChild(script);
	
    script.onload = () => {
        AOS.init({
            duration: 800,
            easing: 'ease-out-cubic',
            once: true,
            offset: 100 
        });
    };

    document.addEventListener('mousemove', (e) => {
        const layers = document.querySelectorAll('.parallax-layer');
        if(!layers.length) return;

        const x = (window.innerWidth / 2 - e.pageX) / 50;
        const y = (window.innerHeight / 2 - e.pageY) / 50;

        layers.forEach(layer => {
            layer.style.transform = `translate(${x}px, ${y}px)`;
        });
    });
});