import React, {  useEffect, useRef } from 'react';
import Message from './Message';
import MessageInput from './MessageInput';
import './css/MainWindow.css';
import { readUserIdAndCookie, mergeWithoutDuplicates } from './utils';

function ConversationPanel({ selectedChatId, messageCache, setMessageCache, messages }) {
  const { user_id, cookie } = readUserIdAndCookie();
  const newestMessageUnixTime = useRef(0);
  
  // The following 2 variables are 
  // used to scroll to the latest message.
  // We need to scroll to the latest
  // message only when messages state 
  // actually changes, because the user
  // should be able to scroll up the chat
  // without being force-scrolled down
  // on each messages load when there
  // are actually no new messages.
  // We can't apply useEffect for this problem
  // because it will be called of every setMessages
  // call, so we have to check if the
  // DOM was actually updated.
  const messagesRef = useRef(null);
  let prevMessagesLastElementChild = null;

  async function loadMessages() {
    if (selectedChatId) {
      const route = `/users/${user_id}/chats/${selectedChatId}/messages/time/${newestMessageUnixTime.current}`; 

      const data = {
        method: 'GET',
        headers: {
          'Cookie': `cookie=${cookie}`
        }
      };
      
      console.log("ConversationPanel loadMessages() sent request");
      console.log(`Route: ${route}`);
      console.log(`Request data:`);
      console.log(data);

      fetch(route, data)
        .then(response => response.json())
        .then(data => {
          console.log("ConversationPanel loadMessages() received response");
          console.log(`Response data:`);
          console.log(data);

          if(data.messages && data.messages.length > 0) 
          {
            setMessageCache((prevState) => {
              let copy = new Map(JSON.parse(JSON.stringify(Array.from(prevState))));
              if(copy.has(selectedChatId))
              {
                let noDuplicates = mergeWithoutDuplicates(copy.get(selectedChatId), data.messages);
                copy.set(selectedChatId, noDuplicates);
              }
              else
              {
                copy.set(selectedChatId, data.messages);
              }
              console.log("setMessageCache", copy)
              return copy;
            });
          }
        })
        .catch(error => console.error(error));
    }
  };

  async function handleNewMessage(text) {
    const route = `/users/${user_id}/chats/${selectedChatId}/messages`; 

    const data = {
      method: 'POST',
      headers: {
        'Cookie': `cookie=${cookie}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ 
        'message_text': text 
      })
    };
    
    console.log("ConversationPanel handleNewMessage() sent request");
    console.log(`Route: ${route}`);
    console.log(`Request data:`);
    console.log(data);

    fetch(route, data)
      .then(response => response.json())
      .then(data => {
        console.log("ConversationPanel handleNewMessage() received response");
        console.log(`Response data:`);
        console.log(data);
        
        if(data.status === 'Success')
        {
          newestMessageUnixTime.current = Math.min(newestMessageUnixTime.current, data.created_at_unixtime);
        }
      })
      .catch(error => console.error(error));
  };

  useEffect(() => {
    if(messages && messages.length > 0)
      newestMessageUnixTime.current = messages[messages.length - 1].created_at_unixtime + 1;

    loadMessages();
    
    const intervalId = setInterval(loadMessages, 1000);

    return () => { 
      clearInterval(intervalId);
      newestMessageUnixTime.current = 0;
    }
  });

  useEffect(() => {
    if(messages && messages.length > 0)
      newestMessageUnixTime.current = messages[messages.length - 1].created_at_unixtime + 1;

    if(prevMessagesLastElementChild != messagesRef.current?.lastElementChild)
    {
      messagesRef.current?.lastElementChild?.scrollIntoView();
      prevMessagesLastElementChild = messagesRef.current?.lastElementChild;
    }

    return () => { 
      newestMessageUnixTime.current = 0;
    }
  }, [selectedChatId, messageCache]);

  return (
    <div className="conversation-panel-container" >
      <div className="message-list" ref={messagesRef}>
        {messages && messages.map(message => (
          <Message key={message.id} message={message} />
        ))}
      </div>
      <MessageInput
        handleNewMessage={handleNewMessage} />
    </div>
  );
}

export default ConversationPanel;