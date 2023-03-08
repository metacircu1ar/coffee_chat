import React, { useState } from 'react';
import ChatPreviewPanel from './ChatPreviewPanel';
import ConversationPanel from './ConversationPanel';
import LeftMenuPanel from './LeftMenuPanel';
import './css/MainWindow.css';
import Background from './images/bg.jpg'

const backgroundStyle = {
  backgroundImage: `url(${Background})`,
  backgroundSize: 'scale-down',
  backgroundPosition: 'top',
  width:'77%',
  height: '100%' 
}
/*
.conversation-panel-background {
  display: flex;
  flex-direction: column;

  width: 77%;
  height: 100%;

  background: url("./bg.jpg");
  background-size:contain;
  background-position:top;
  background: cover;

  overflow-y: hidden;
  overflow-x: hidden;
}

*/

//  <div className="conversation-panel-background" />
function MainWindow({setIsAuthorized}) {
  const [selectedChatId, setSelectedChatId] = useState(null);
  const [messageCache, setMessageCache] = useState(new Map());

  return (
    <div className="main-window">
      <LeftMenuPanel setIsAuthorized={setIsAuthorized}/>
      
      <ChatPreviewPanel 
        selectedChatId={selectedChatId}
        setSelectedChatId={setSelectedChatId} />
      
      {selectedChatId ? (
        <ConversationPanel  
          selectedChatId={selectedChatId}
          messageCache={messageCache}
          setMessageCache={setMessageCache} 
          messages={messageCache.get(selectedChatId) || []}
        />
      ) : (
        <div style={backgroundStyle} />
      )}
    </div>
  );
}

export default MainWindow;
