function openFeature(type) {
    const popup = document.getElementById('popup');
    const body = document.getElementById('popup-body');
    
    if(type === 'smm') {
        body.innerHTML = `
            <h2 style="margin-bottom:15px">SMM Booster</h2>
            <p style="color:#666; line-height:1.6">Layanan optimasi sosial media tercepat dengan server API terenkripsi. 
            <br><br><b>Fitur:</b>
            <ul>
                <li>Followers Indonesia / Global</li>
                <li>Likes Postingan Instan</li>
                <li>Views Video No Drop</li>
            </ul>
            <br>Silakan Hubungi IG untuk pricelist terbaru.</p>
        `;
    } else if(type === 'web') {
        body.innerHTML = `
            <h2 style="margin-bottom:15px">Web Development</h2>
            <p style="color:#666; line-height:1.6">Pembuatan website profesional untuk personal branding atau bisnis.
            <br><br><b>Teknologi:</b> HTML5, CSS3, JS, React, PHP. 
            <br>Proses pengerjaan 3-7 hari kerja tergantung tingkat kesulitan.</p>
        `;
    }
    
    popup.style.display = 'block';
}

function closePopup() {
    document.getElementById('popup').style.display = 'none';
}

// Tutup popup kalau klik di luar area box
window.onclick = function(event) {
    const popup = document.getElementById('popup');
    if (event.target == popup) {
        popup.style.display = "none";
    }
}
