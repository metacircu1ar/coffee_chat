import React, { useState, useEffect, useRef } from 'react';
import ChatPreview from './ChatPreview';
import './css/MainWindow.css';
import { readUserIdAndCookie, mergeWithoutDuplicates } from './utils';

function ChatPreviewPanel({ selectedChatId, setSelectedChatId }) {
  const [chats, setChats] = useState([]);
  const loadChatsInterval = 1000;
  const { user_id, cookie } = readUserIdAndCookie();

  async function loadChats(time) {
    const route = `/users/${user_id}/chats/time/${time}`; 

    const data = {
      method: 'GET',
      headers: {
        'Cookie': `cookie=${cookie}`
      }
    };
    
    console.log("ChatPreviewPanel loadChats() sent request");
    console.log(`Route: ${route}`);
    console.log(`Request data:`);
    console.log(data);

    fetch(route, data)
      .then(response => response.json())
      .then(data => {
        console.log("ChatPreviewPanel received response");
        console.log(`Response data:`);
        console.log(data);

        if(data.length > 0) 
        {
          time = data[data.length - 1].created_at_unixtime + 1; 

          setChats((prevData) => {
            return [...prevData, ...data];
          });
        }

        setTimeout(() => {
          loadChats(time);
        }, loadChatsInterval);
      })
      .catch(error => {
        console.error(error);
        setTimeout(() => {
          loadChats(time);
        }, loadChatsInterval);
      });
  };

  useEffect(() => {
    loadChats(0);
    
    return () => {
    }
  }, []);

  return ( 
    <div className="chat-preview-panel">
     {chats && chats.map(chat => (
        <ChatPreview 
          key={chat.id}
          chat={chat}   
          selectedChatId={selectedChatId} 
          setSelectedChatId={setSelectedChatId}         
        />
     ))} 
    </div>
  );
}

export default ChatPreviewPanel;