* { margin: 0; padding: 0; box-sizing: border-box; }
body { 
    font-family: system-ui, -apple-system, sans-serif;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    height: 100vh; padding: 10px;
}

.chatbot { 
    height: 100vh; 
    background: white; 
    border-radius: 20px; 
    box-shadow: 0 10px 30px rgba(0,0,0,0.3);
    display: flex; flex-direction: column; 
    max-width: 100%; margin: 0 auto;
}

.header { 
    background: linear-gradient(45deg, #ff6b6b, #4ecdc4); 
    color: white; padding: 20px; text-align: center;
    border-radius: 20px 20px 0 0;
}
.header h2 { font-size: 1.3rem; margin-bottom: 5px; }
.status { font-size: 0.8rem; opacity: 0.9; }

#messages { 
    flex: 1; padding: 20px; overflow-y: auto; 
    background: #f8f9fa;
}
.msg { 
    margin: 10px 0; padding: 12px 16px; 
    border-radius: 20px; max-width: 85%; 
    word-wrap: break-word;
}
.you { background: #4ecdc4; color: white; margin-left: auto; }
.ai { background: white; border: 1px solid #e0e0e0; }

.input-box { 
    padding: 20px; display: flex; gap: 10px; 
    border-top: 1px solid #eee; background: white;
    border-radius: 0 0 20px 20px;
}
#input { 
    flex: 1; padding: 15px; border: 2px solid #e0e0e0; 
    border-radius: 25px; font-size: 16px; /* Mobile keyboard */
}
button { 
    width: 50px; height: 50px; border: none; 
    background: #ff6b6b; color: white; border-radius: 50%; 
    font-size: 1.2rem;
}
button:active { transform: scale(0.95); }
