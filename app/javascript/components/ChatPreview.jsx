import React, { useState, useEffect } from 'react';
import { readUserIdAndCookie } from './utils';

const ChatPreview = ({ chat, setSelectedChatId, selectedChatId }) => {
  const [unreadCount, setUnreadCount] = useState(0);
  const { user_id, cookie } = readUserIdAndCookie();

  async function loadUnreadCount() {
    const route = `/users/${user_id}/chats/${chat.id}/unread_count`; 

    const data = {
      method: 'GET',
      headers: {
        'Cookie': `cookie=${cookie}`
      }
    };
    
    console.log("ChatPreview sent request");
    console.log(`Route: ${route}`);
    console.log(`Request data:`);
    console.log(data);


    fetch(route, data)
      .then(response => response.json())
      .then(data => {
        console.log("ChatPreview received response");
        console.log(`Response data:`);
        console.log(data);

        setUnreadCount(data.unread_count);
      })
      .catch(error => console.error(error));
  };

  const isSelected = chat.id === selectedChatId;
  let backgroundColor = isSelected ? "#35363c" :  "#2B2C31"; 
  let hasUnreadCount =  unreadCount > 0;

  useEffect(() => {
    loadUnreadCount();

    const intervalId = setInterval(loadUnreadCount, 1000);

    return () => {
      clearInterval(intervalId);
    }
  }, []);

  return (
    <div className="chat-preview"
      style={{ backgroundColor }} 
      onClick={() => setSelectedChatId(chat.id)}>
        <div className="chat-preview-topic">{chat.topic}</div>
        {hasUnreadCount && (
          <div className="chat-preview-unread-count">{unreadCount}</div>
        )}
    </div>
   );
};

export default ChatPreview;
