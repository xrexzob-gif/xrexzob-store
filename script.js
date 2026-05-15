// ── XREXZOB AI ──
const API_BASE = 'https://api.x.ai/v1';

const state = {
  apiKey: localStorage.getItem('xrexzob_api_key') || '',
  model: localStorage.getItem('xrexzob_model') || 'grok-3-latest',
  messages: [],
  isListening: false,
  isSpeaking: false,
  screenStream: null,
  recognition: null,
  synth: window.speechSynthesis,
};

// ── DOM refs ──
const chatMessages = document.getElementById('chatMessages');
const chatInput = document.getElementById('chatInput');
const sendBtn = document.getElementById('sendBtn');
const micBtn = document.getElementById('micBtn');
const screenBtn = document.getElementById('screenBtn');
const stopScreenBtn = document.getElementById('stopScreenBtn');
const screenPreview = document.getElementById('screenPreview');
const voiceVisualizer = document.getElementById('voiceVisualizer');
const apiKeyInput = document.getElementById('apiKeyInput');
const modelSelect = document.getElementById('modelSelect');
const clearBtn = document.getElementById('clearBtn');
const eyeBtn = document.getElementById('eyeBtn');
const speakToggle = document.getElementById('speakToggle');

// ── Init ──
function init() {
  if (state.apiKey) {
    apiKeyInput.value = state.apiKey;
    apiKeyInput.type = 'password';
  }
  modelSelect.value = state.model;
  setupRecognition();
  setupEventListeners();
}

// ── Event Listeners ──
function setupEventListeners() {
  sendBtn.addEventListener('click', sendMessage);

  chatInput.addEventListener('keydown', (e) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      sendMessage();
    }
  });

  chatInput.addEventListener('input', () => {
    chatInput.style.height = 'auto';
    chatInput.style.height = Math.min(chatInput.scrollHeight, 120) + 'px';
  });

  apiKeyInput.addEventListener('change', () => {
    state.apiKey = apiKeyInput.value.trim();
    localStorage.setItem('xrexzob_api_key', state.apiKey);
    showToast('API key saved!', 'success');
  });

  modelSelect.addEventListener('change', () => {
    state.model = modelSelect.value;
    localStorage.setItem('xrexzob_model', state.model);
    showToast(`Model: ${state.model}`, 'info');
  });

  eyeBtn.addEventListener('click', () => {
    apiKeyInput.type = apiKeyInput.type === 'password' ? 'text' : 'password';
    eyeBtn.textContent = apiKeyInput.type === 'password' ? '👁' : '🙈';
  });

  micBtn.addEventListener('click', toggleMic);
  screenBtn.addEventListener('click', startScreenShare);
  stopScreenBtn.addEventListener('click', stopScreenShare);
  clearBtn.addEventListener('click', clearChat);

  document.querySelectorAll('.chip').forEach(chip => {
    chip.addEventListener('click', () => {
      chatInput.value = chip.textContent;
      chatInput.style.height = 'auto';
      sendMessage();
    });
  });

  speakToggle.addEventListener('click', () => {
    if (state.isSpeaking) {
      state.synth.cancel();
      state.isSpeaking = false;
      speakToggle.textContent = '🔇';
      speakToggle.title = 'Suara AI: Mati';
      showToast('Suara AI dimatikan', 'info');
    }
  });
}

// ── Send Message ──
async function sendMessage() {
  const text = chatInput.value.trim();
  if (!text) return;

  if (!state.apiKey) {
    showToast('Masukkan API Key Grok dulu di sidebar!', 'error');
    apiKeyInput.focus();
    return;
  }

  // Hide welcome screen
  const welcome = document.getElementById('welcome');
  if (welcome) welcome.style.display = 'none';

  // Add user message
  addMessage('user', text);
  state.messages.push({ role: 'user', content: text });

  chatInput.value = '';
  chatInput.style.height = 'auto';

  // Show typing
  const typingEl = addTypingIndicator();

  try {
    const reply = await callGrok(state.messages);
    typingEl.remove();
    addMessage('ai', reply);
    state.messages.push({ role: 'assistant', content: reply });

    // Auto speak if enabled
    if (document.getElementById('autoSpeak').checked) {
      speak(reply);
    }
  } catch (err) {
    typingEl.remove();
    const errMsg = err.message || 'Gagal konek ke Grok API';
    addMessage('ai', `⚠️ Error: ${errMsg}`);
    showToast(errMsg, 'error');
  }
}

// ── Grok API ──
async function callGrok(messages) {
  const systemPrompt = `Kamu adalah XREXZOB, AI yang dibuat oleh Xrexzob. Kamu cerdas, santai, blak-blakan, dan seru. Kamu ngomong natural, bisa bahasa Indonesia atau Inggris sesuai user. Kamu jujur dan berani tapi tetap helpful. Nama kamu XREXZOB, bukan yang lain.`;

  const res = await fetch(`${API_BASE}/chat/completions`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${state.apiKey}`,
    },
    body: JSON.stringify({
      model: state.model,
      messages: [
        { role: 'system', content: systemPrompt },
        ...messages,
      ],
      max_tokens: 1024,
    }),
  });

  if (!res.ok) {
    const data = await res.json().catch(() => ({}));
    throw new Error(data.error?.message || `HTTP ${res.status}`);
  }

  const data = await res.json();
  return data.choices[0].message.content;
}

// ── Add Message ──
function addMessage(role, text) {
  const div = document.createElement('div');
  div.className = `message ${role}`;

  const time = new Date().toLocaleTimeString('id-ID', { hour: '2-digit', minute: '2-digit' });
  const name = role === 'ai' ? 'XREXZOB' : 'YOU';
  const avatar = role === 'ai' ? 'XZ' : 'U';

  div.innerHTML = `
    <div class="msg-avatar">${avatar}</div>
    <div class="msg-content">
      <div class="msg-name">${name}</div>
      <div class="msg-bubble">${formatText(text)}</div>
      <div class="msg-time">${time}</div>
    </div>
  `;

  chatMessages.appendChild(div);
  chatMessages.scrollTop = chatMessages.scrollHeight;
  return div;
}

function addTypingIndicator() {
  const div = document.createElement('div');
  div.className = 'message ai typing-indicator';
  div.innerHTML = `
    <div class="msg-avatar">XZ</div>
    <div class="msg-content">
      <div class="msg-name">XREXZOB</div>
      <div class="msg-bubble">
        <div class="typing-dot"></div>
        <div class="typing-dot"></div>
        <div class="typing-dot"></div>
      </div>
    </div>
  `;
  chatMessages.appendChild(div);
  chatMessages.scrollTop = chatMessages.scrollHeight;
  return div;
}

function formatText(text) {
  return text
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
    .replace(/\*(.*?)\*/g, '<em>$1</em>')
    .replace(/`(.*?)`/g, '<code style="background:#ffffff11;padding:1px 5px;border-radius:4px;font-family:monospace">$1</code>')
    .replace(/\n/g, '<br>');
}

// ── Voice Input ──
function setupRecognition() {
  const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
  if (!SpeechRecognition) return;

  state.recognition = new SpeechRecognition();
  state.recognition.continuous = false;
  state.recognition.interimResults = true;
  state.recognition.lang = 'id-ID';

  state.recognition.onresult = (e) => {
    const transcript = Array.from(e.results)
      .map(r => r[0].transcript)
      .join('');
    chatInput.value = transcript;
    chatInput.style.height = 'auto';
    chatInput.style.height = Math.min(chatInput.scrollHeight, 120) + 'px';
  };

  state.recognition.onend = () => {
    state.isListening = false;
    micBtn.classList.remove('mic-active');
    micBtn.title = 'Mulai voice input';
    voiceVisualizer.classList.remove('show');
    const text = chatInput.value.trim();
    if (text) sendMessage();
  };

  state.recognition.onerror = (e) => {
    state.isListening = false;
    micBtn.classList.remove('mic-active');
    voiceVisualizer.classList.remove('show');
    if (e.error !== 'no-speech') {
      showToast(`Mic error: ${e.error}`, 'error');
    }
  };
}

function toggleMic() {
  if (!state.recognition) {
    showToast('Browser lu ga support speech recognition', 'error');
    return;
  }

  if (state.isListening) {
    state.recognition.stop();
  } else {
    state.recognition.start();
    state.isListening = true;
    micBtn.classList.add('mic-active');
    micBtn.title = 'Stop mic';
    voiceVisualizer.classList.add('show');
    showToast('Lagi dengerin...', 'info');
  }
}

// ── Text to Speech ──
function speak(text) {
  if (!state.synth) return;
  state.synth.cancel();

  const clean = text.replace(/<[^>]+>/g, '').replace(/[*_`]/g, '');
  const utter = new SpeechSynthesisUtterance(clean);
  utter.lang = 'id-ID';
  utter.rate = 1.05;
  utter.pitch = 1;

  utter.onstart = () => {
    state.isSpeaking = true;
    speakToggle.textContent = '🔊';
    speakToggle.title = 'Stop suara AI';
  };
  utter.onend = () => {
    state.isSpeaking = false;
    speakToggle.textContent = '🔇';
  };

  state.synth.speak(utter);
}

// ── Screen Share ──
async function startScreenShare() {
  try {
    state.screenStream = await navigator.mediaDevices.getDisplayMedia({
      video: { cursor: 'always' },
      audio: false,
    });

    screenPreview.srcObject = state.screenStream;
    screenPreview.classList.add('show');
    screenBtn.style.display = 'none';
    stopScreenBtn.style.display = 'flex';

    state.screenStream.getVideoTracks()[0].onended = stopScreenShare;
    showToast('Screen share aktif!', 'success');

    addMessage('ai', '🖥️ Oke gw liat layar lu. Mau ngomongin apa soal screen ini?');
    state.messages.push({ role: 'assistant', content: '🖥️ Oke gw liat layar lu. Mau ngomongin apa soal screen ini?' });
  } catch (err) {
    if (err.name !== 'NotAllowedError') {
      showToast('Gagal share screen: ' + err.message, 'error');
    }
  }
}

function stopScreenShare() {
  if (state.screenStream) {
    state.screenStream.getTracks().forEach(t => t.stop());
    state.screenStream = null;
  }
  screenPreview.srcObject = null;
  screenPreview.classList.remove('show');
  screenBtn.style.display = 'flex';
  stopScreenBtn.style.display = 'none';
  showToast('Screen share dihentikan', 'info');
}

// ── Clear Chat ──
function clearChat() {
  state.messages = [];
  chatMessages.innerHTML = `
    <div class="welcome" id="welcome">
      <div class="welcome-logo">XZ</div>
      <h2>XREXZOB AI</h2>
      <p>AI canggih yang siap nemenin lu. Tanya apapun, kapanpun.</p>
      <div class="welcome-chips">
        <div class="chip">Siapa lo?</div>
        <div class="chip">Bantu gw nulis code</div>
        <div class="chip">Jelasin sesuatu</div>
        <div class="chip">Main roleplay</div>
      </div>
    </div>
  `;
  document.querySelectorAll('.chip').forEach(chip => {
    chip.addEventListener('click', () => {
      chatInput.value = chip.textContent;
      sendMessage();
    });
  });
  showToast('Chat dihapus', 'info');
}

// ── Toast ──
function showToast(msg, type = 'info') {
  const container = document.getElementById('toastContainer');
  const toast = document.createElement('div');
  toast.className = `toast ${type}`;

  const icons = { success: '✅', error: '❌', info: 'ℹ️' };
  toast.innerHTML = `<span>${icons[type] || ''}</span><span>${msg}</span>`;

  container.appendChild(toast);
  setTimeout(() => {
    toast.style.opacity = '0';
    toast.style.transition = 'opacity 0.3s';
    setTimeout(() => toast.remove(), 300);
  }, 3000);
}

// ── Start ──
document.addEventListener('DOMContentLoaded', init);
