// Animate numbers
function animateNumbers() {
    const numbers = document.querySelectorAll('.number');
    
    numbers.forEach(number => {
        const target = parseFloat(number.getAttribute('data-target'));
        const updateNumber = () => {
            const current = parseFloat(number.innerText.replace(/[^0-9.-]+/g, ''));
            const increment = target / 100;
            
            if (current < target) {
                number.innerText = Math.floor(current + increment) + number.classList.contains('has
