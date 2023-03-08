import React, { useState, useEffect } from 'react';
import { readUserIdAndCookie } from './utils';
import { MultiSelect } from "react-multi-select-component";

function CreateChat({ onClose }) {
  const [contacts, setContacts] = useState([]);
  const [selectedContacts, setSelectedContacts] = useState([]);
  const [chatTopic, setChatTopic] = useState("");

  const { user_id, cookie } = readUserIdAndCookie();

  async function getContacts() {
    const route = `/users/${user_id}/contacts`; 

    const data = {
      method: 'GET',
      headers: {
        'Cookie': `cookie=${cookie}`
      }
    };
    
    console.log("CreateChat getContacts() request");
    console.log(`Route: ${route}`);
    console.log(`Request data:`);
    console.log(data);
  
    fetch(route)
      .then(response => response.json())
      .then(data => {
        console.log("CreateChat getContacts() received response");
        console.log(`Response data:`);
        console.log(data);

        setContacts(data)
      })
      .catch(error => console.error(error));
  }

  const handleCreateChat = () => {

    const member_ids = selectedContacts.map((contact) => ( contact.value.id ));

    const route = `/users/${user_id}/chats`; 

    const data = {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Cookie': `cookie=${cookie}`
      },
      body: JSON.stringify({
        'chat_topic': chatTopic,
        'member_ids': member_ids
      })
    };
    
    console.log("CreateChat handleCreateChat() request");
    console.log(`Route: ${route}`);
    console.log(`Request data:`);
    console.log(data);
    console.log(`Member ids:`);
    console.log(member_ids)

    fetch(route, data)
      .then(response => response.json())
      .then(data => {
        console.log("CreateChat handleCreateChat() received response");
        console.log(`Response data:`);
        console.log(data);

        setSelectedContacts([]);
        onClose();
      })
      .catch(error => console.error(error));
  };

  useEffect(() => {
     getContacts();
  }, []);
  //  <pre>{JSON.stringify(selectedContacts)}</pre>
  return (
    <div className="popup-window">
      <div className="contact-list-header">
        <div className="default-text-big">Create chat</div>
        <div className="contact-list-close-btn" onClick={onClose}>X</div>
      </div>

      <p className="default-text-normal">Select members</p>
      <MultiSelect
        className="dark"
        options={contacts.map((contact) => ( {label: contact.name, value: contact } ))}
        value={selectedContacts}
        onChange={setSelectedContacts}
        labelledBy="Select"
      />
      <p className="default-text-normal">Chat topic</p>
      <div className="contact-list-add-contact">
        <input className="contact-list-add-contact-input-text"
          type="text"
          value={chatTopic}
          onChange={(e) => setChatTopic(e.target.value)}
        />
        <button className="contact-list-add-button" onClick={handleCreateChat}>Create chat</button>
      </div>
    </div>
  );
}
export default CreateChat;