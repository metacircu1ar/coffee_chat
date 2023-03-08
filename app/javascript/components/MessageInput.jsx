import React, { useState, useRef } from 'react';

function MessageInput({ handleNewMessage }) {
  const [text, setText] = useState('');
  const textareaRef = useRef(null);

  const handleChange = event => {
    console.log("Text " + event.target.value);
    const textarea = textareaRef.current;
    textarea.style.height = "auto";
    event.target.style.height = `${Math.min(
      Math.max(event.target.scrollHeight, 50),
      window.innerHeight / 2
    )}px`; // set the height based on the content
    setText(event.target.value);
  };

  function handleSend() {
    let trimmedText = text.trim();

    if(trimmedText !== '')
    {
      handleNewMessage(trimmedText);
      const textarea = textareaRef.current;
      textarea.style.height = "50px"; // reset the height to its original value
    }    

    setText('');
  }

  const handleKeyDown = event => {
    if (event.ctrlKey && event.key === 'Enter') {
      handleSend(text);
    }
  };
  return (
    <div className="message-input-container">
      <textarea className="message-input-text-area"
        type="text"
        placeholder="Type a message. Send on Ctrl+Enter or click Send button there -->"
        value={text}
        onChange={handleChange}
        onKeyDown={handleKeyDown}
        ref={textareaRef}
        rows={1}
      />
      <button 
        className="message-input-send-button" 
        onClick={handleSend}>
          Send
      </button>
    </div>
  );
}

export default MessageInput;


