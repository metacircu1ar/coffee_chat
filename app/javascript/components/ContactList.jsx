import React, { useState, useEffect } from 'react';
import Contact from './Contact'

import { readUserIdAndCookie } from './utils';

function ContactList({ onClose }) {
  const [contacts, setContacts] = useState([]);
  const [newContactId, setNewContactId] = useState("");
  
  const { user_id, cookie } = readUserIdAndCookie();

  async function getContacts() {
    const route = `/users/${user_id}/contacts`; 

    const data = {
      method: 'GET',
      headers: {
        'Cookie': `cookie=${cookie}`
      }
    };
    
    console.log("ContactList getContacts() sent request");
    console.log(`Route: ${route}`);
    console.log(`Request data:`);
    console.log(data);

    fetch(route)
      .then(response => response.json())
      .then(data => {
        console.log("ContactList getContacts() received response");
        console.log(`Response data:`);
        console.log(data);

        setContacts(data)
      })
      .catch(error => console.error(error));
  }

  const handleAddContact = () => {
    const route = `/users/${user_id}/contacts/${newContactId}`; 

    const data = {
      method: 'POST',
      headers: {
        'Cookie': `cookie=${cookie}`
      }
    };
    
    console.log("ContactList handleAddContact() sent request");
    console.log(`Route: ${route}`);
    console.log(`Request data:`);
    console.log(data);
  
    fetch(route, data)
      .then(response => response.json())
      .then(data => {
        console.log("ContactList handleAddContact() received response");
        console.log(`Response data:`);
        console.log(data);

        getContacts();
        setNewContactId("");
      })
      .catch(error => console.error(error));
  };

  useEffect(() => {
     getContacts();
  }, []);

  return (
    <div className="popup-window">
      <div className="contact-list-header">
        <div className="default-text-big">Contacts</div>
        <div className="contact-list-close-btn" onClick={onClose}>X</div>
      </div>
      <div className="contact-list-add-contact">
        <input className="contact-list-add-contact-input-text"
          type="text"
          placeholder="Enter contact id"
          value={newContactId}
          onChange={(e) => setNewContactId(e.target.value)}
        />
        <button className="contact-list-add-button" onClick={handleAddContact}>Add</button>
      </div>

      <table className="contact-entries-table">
        <thead>
          <tr>
            <th>Name</th>
            <th>ID</th>
          </tr>
        </thead>
        <tbody>
          {contacts.map((contact) => (
              <Contact key={contact.id} contact={contact} />
          ))}
        </tbody>
      </table> 
    </div>
  );
}
export default ContactList;