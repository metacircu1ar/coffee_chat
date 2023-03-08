import React, { useState } from 'react';
import ContactList from './ContactList';
import CreateChat from './CreateChat';
import { clearUserIdAndCookie, readUserIdAndCookie } from './utils';
import './css/MainWindow.css';

function LeftMenuPanel({setIsAuthorized}) {
  const { user_id, cookie } = readUserIdAndCookie();
  const [showContactList, setShowContactList] = useState(false);
  const [showCreateChat, setShowCreateChat] = useState(false);

  const handleOpenContactList = () => {
    setShowContactList(true);
    setShowCreateChat(false);
  };

  const handleCloseContactList = () => {
    setShowContactList(false);
  };

  const handleOpenCreateChat = () => {
    setShowCreateChat(true);
    setShowContactList(false);
  };

  const handleCloseCreateChat = () => {
    setShowCreateChat(false);
  };

  const handleLogout = () => {
    try {
      const route = `/auth/logout/${user_id}`; 

      const data = {
        method: 'POST',
        headers: { 
          'Set-Cookie': `cookie=${cookie}`
        }
      };

      console.log("LeftMenuPanel sent request");
      console.log(`Route: ${route}`);
      console.log(`Request data:`);
      console.log(data);

      fetch(route, data)
      .then(response => response.json())
      .then(data => {
          console.log("LeftMenuPanel received response");
          console.log(`Response data:`);
          console.log(data);

          if(data.status === 'Success')
          {
            clearUserIdAndCookie();
            setIsAuthorized(false);
          }
      });
    } catch (error) {
        console.error(error);
    }
   
  }

  return (
    <div className="left-menu-panel">
      <span className="open-contacts" onClick={handleOpenContactList} title="Contacts"></span>
      <span className="create-chat" onClick={handleOpenCreateChat} title="Create chat"></span>
      {showContactList && (
          <ContactList onClose={handleCloseContactList} />
      )}
      {showCreateChat &&(
          <CreateChat onClose={handleCloseCreateChat} />
      )}
      <span className="log-out" onClick={handleLogout} title="Log out"></span>
    </div>
  );
}

export default LeftMenuPanel;