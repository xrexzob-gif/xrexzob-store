// Efek sederhana saat scroll supaya kelihatan canggih
document.addEventListener("DOMContentLoaded", function() {
    const cards = document.querySelectorAll('.service-card');
    cards.forEach((card, index) => {
        setTimeout(() => {
            card.style.opacity = "1";
            card.style.transform = "translateY(0)";
        }, 200 * index);
    });
    console.log("X-REXZOB System Ready.");
});
