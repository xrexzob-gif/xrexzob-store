* { margin: 0; padding: 0; box-sizing: border-box; }
body { 
    font-family: 'Segoe UI', sans-serif; 
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
}

.container {
    width: 90%; max-width: 800px; background: rgba(255,255,255,0.95);
    border-radius: 20px; box-shadow: 0 20px 40px rgba(0,0,0,0.3);
    overflow: hidden;
}

header { 
    background: linear-gradient(45deg, #ff6b6b, #4ecdc4); 
    color: white; padding: 2rem; text-align: center; 
}

#chat-container { height: 500px; display: flex; flex-direction: column; }
#chat-messages { 
    flex: 1; padding: 20px; overflow-y: auto; background: #f8f9fa;
}
.message { margin: 10px 0; padding: 12px 16px; border-radius: 18px; max-width: 80%; }
.user { background: #4ecdc4; color: white; margin-left: auto; text-align: right; }
.ai { background: white; border: 1px solid #e0e0e0; }

.input-area { 
    display: flex; padding: 20px; gap: 10px; border-top: 1px solid #eee; 
}
#message-input { flex: 1; padding: 12px; border: 2px solid #e0e0e0; border-radius: 25px; }
button { 
    padding: 12px 24px; background: #ff6b6b; color: white; border: none; 
    border-radius: 25px; cursor: pointer; font-weight: bold;
}
button:hover { background: #ff5252; transform: scale(1.05); }
