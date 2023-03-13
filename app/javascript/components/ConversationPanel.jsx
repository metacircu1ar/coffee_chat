import React, {  useEffect, useRef } from 'react';
import Message from './Message';
import MessageInput from './MessageInput';
import './css/MainWindow.css';
import { readUserIdAndCookie, mergeWithoutDuplicates } from './utils';

function ConversationPanel({ selectedChatId, messageCache, setMessageCache, messages }) {
  const { user_id, cookie } = readUserIdAndCookie();
  const lastSelectedChatId = useRef(null);
  
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

  const scrollDown = () => {
    if(prevMessagesLastElementChild != messagesRef.current?.lastElementChild)
    {
      messagesRef.current?.lastElementChild?.scrollIntoView();
      prevMessagesLastElementChild = messagesRef.current?.lastElementChild;
    }
  }

  async function loadMessages(time) {
    if (!(selectedChatId && lastSelectedChatId.current == selectedChatId)) return;
    
    const route = `/users/${user_id}/chats/${selectedChatId}/messages/time/${time}`; 

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

        if(data.messages) 
        {
          if(data.messages.length > 0)
          {
            time = data.messages[data.messages.length - 1].created_at_unixtime + 1;
          
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

          setTimeout(() => {
            loadMessages(time);
          }, 1000);
        }
      })
      .catch(error => {
          console.error(error)

          setTimeout(() => {
            loadMessages(time);
          }, 1000);
        }
      );
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
      })
      .catch(error => console.error(error));
  };

  useEffect(() => {
    console.log(`useEffect no args ${selectedChatId} ${messages.length}`)

    lastSelectedChatId.current = selectedChatId;

    if(messages && messages.length > 0)
    {
      let unixTimeAfterNewestMessage = messages[messages.length - 1].created_at_unixtime + 1;
      
      setTimeout(() => {
        loadMessages(unixTimeAfterNewestMessage);
      }, 0);
    }
    else
    {
      setTimeout(() => {
        loadMessages(0);
      }, 0);
    }

    scrollDown();

    return () => { 
    }
  }, [selectedChatId]);

  useEffect(() => {
    console.log(`useEffect [messageCache] ${selectedChatId} ${messages.length}`)
    scrollDown();
  }, [messageCache]);

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