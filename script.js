function openService(url) {
    // Efek delay sedikit biar terasa "systematic"
    setTimeout(() => {
        window.location.href = url;
    }, 200);
}

// Efek Muncul Bertahap (Reveal Animation)
document.addEventListener('DOMContentLoaded', () => {
    const cards = document.querySelectorAll('.f-card');
    cards.forEach((card, index) => {
        card.style.opacity = "0";
        card.style.transform = "translateY(20px)";
        setTimeout(() => {
            card.style.transition = "all 0.6s ease-out";
            card.style.opacity = "1";
            card.style.transform = "translateY(0)";
        }, 150 * index);
    });
});
