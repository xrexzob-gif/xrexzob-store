// Navbar mobile
const hamburger = document.querySelector('.hamburger');
const navMenu = document.querySelector('.nav-menu');
hamburger.addEventListener('click', () => {
    hamburger.classList.toggle('active');
    navMenu.classList.toggle('active');
});

// Smooth scroll
document.querySelectorAll('a[href^="#"]').forEach(a => {
    a.addEventListener('click', e => {
        e.preventDefault();
        document.querySelector(a.getAttribute('href')).scrollIntoView({
            behavior: 'smooth'
        });
    });
});

// Animate skill bars
const observer = new IntersectionObserver(entries => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            document.querySelectorAll('.fill').forEach((fill, i) => {
                setTimeout(() => {
                    fill.style.width = fill.style.width;
                }, i * 200);
            });
        }
    });
});

observer.observe(document.querySelector('.skills-matrix'));

// Terminal typing effect
function typeWriter(element, text, speed = 100) {
    let i = 0;
    element.innerHTML = '';
    function type() {
        if (i < text.length) {
            element.innerHTML += text.charAt(i);
            i++;
            setTimeout(type, speed);
        }
    }
    type();
}

// Navbar scroll
window.addEventListener('scroll', () => {
    const nav = document.querySelector('.terminal-nav');
    if (window.scrollY > 50) {
        nav.style.background = 'rgba(10,10,10,0.98)';
    } else {
        nav.style.background = 'rgba(10,10,10,0.95)';
    }
});
