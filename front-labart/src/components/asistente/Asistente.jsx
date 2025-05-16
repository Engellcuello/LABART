import { useState, useRef, useEffect } from 'react';
import { GoogleGenerativeAI } from '@google/generative-ai';


const Asistente = () => {
  const [input, setInput] = useState('');
  const [messages, setMessages] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [darkMode, setDarkMode] = useState(false);
  const messagesEndRef = useRef(null);
  const messagesContainerRef = useRef(null);

  const genAI = new GoogleGenerativeAI('AIzaSyACIqyFr4GUnU70u0uuBAST89m5muA_RCM');
  const model = genAI.getGenerativeModel({ model: "gemini-1.5-pro-latest" });

 
  useEffect(() => {
    const checkDarkMode = () => {
      const isDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
      setDarkMode(isDark);
    };

    checkDarkMode();
    
    const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
    const handleChange = (e) => setDarkMode(e.matches);
    
    mediaQuery.addEventListener('change', handleChange);
    return () => mediaQuery.removeEventListener('change', handleChange);
  }, []);

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  const scrollToBottom = () => {
    if (messagesContainerRef.current) {
      messagesContainerRef.current.scrollTo({
        top: messagesContainerRef.current.scrollHeight,
        behavior: 'smooth'
      });
    }
  };

  const toggleDarkMode = () => {
    setDarkMode(prev => !prev);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!input.trim()) return;

    const userMessage = { text: input, sender: 'user' };
    setMessages(prev => [...prev, userMessage]);
    setInput('');
    setIsLoading(true);

    try {
      const prompt = `
        Eres un asistente especializado en arte. Responde solo sobre:
        - Historia del arte
        - Pintura, escultura, arquitectura
        - Movimientos artísticos
        - Artistas famosos
        - Técnicas artísticas

        Si la pregunta no es de arte, responde:
        "Soy un asistente de arte. ¿Puedo ayudarte con algo relacionado a pintura, escultura u otros temas artísticos?"

        Las respuestas las puedes adaptar al idioma de la pregunta.

        Las respuestas tienen que venir sin negritas

        Las respuestas deben tener 300 caracteres de limite 
        
        Pregunta: ${input}
      `;

      const result = await model.generateContent(prompt);
      const response = await result.response;
      const text = response.text();

      setMessages(prev => [...prev, { text, sender: 'ai' }]);
    } catch (err) {
      console.error("Error con Gemini:", err);
      setMessages(prev => [...prev, { 
        text: "Error al generar la respuesta. Intenta de nuevo.", 
        sender: 'ai' 
      }]);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className={`asistente-wrapper ${darkMode ? 'asistente-dark-mode' : ''}`}>
      <div className="asistente-container">
        <div className="asistente-header">
          <h2>Asistente de Arte</h2>
          <button 
            className="asistente-dark-mode-toggle"
            onClick={toggleDarkMode}
            aria-label={darkMode ? 'Desactivar modo oscuro' : 'Activar modo oscuro'}
          >
            {darkMode ? '☀️' : '🌙'}
          </button>
          <button className="asistente-close-button" onClick={() => window.location.href="/home"}>Regresar</button>
        </div>
        
        <div className="chat-container">
          <div className="messages-container" ref={messagesContainerRef}>
            {messages.length === 0 ? (
              <div className="welcome-message">
                <p>¡Hola! Soy tu asistente de arte. Puedes preguntarme sobre:</p>
                <ul>
                  <li>Historia del arte</li>
                  <li>Movimientos artísticos</li>
                  <li>Artistas famosos</li>
                  <li>Técnicas de pintura</li>
                  <li>Análisis de obras</li>
                </ul>
              </div>
            ) : (
              messages.map((message, index) => (
                <div 
                  key={index} 
                  className={`message ${message.sender}`}
                >
                  <div className="message-content">
                    {message.text.split('\n').map((paragraph, i) => (
                      <p key={i}>{paragraph}</p>
                    ))}
                  </div>
                </div>
              ))
            )}
            {isLoading && (
              <div className="message ai">
                <div className="message-content">
                  <div className="typing-indicator">
                    <span></span>
                    <span></span>
                    <span></span>
                  </div>
                </div>
              </div>
            )}
            <div ref={messagesEndRef} />
          </div>
          
          <form onSubmit={handleSubmit} className="input-form">
            <input
              type="text"
              value={input}
              onChange={(e) => setInput(e.target.value)}
              placeholder="Escribe tu pregunta sobre arte..."
              disabled={isLoading}
            />
            <button type="submit" disabled={isLoading}>
              {isLoading ? 'Enviando...' : 'Enviar'}
            </button>
          </form>
        </div>
      </div>
    </div>
  );
};

export default Asistente;