import React from 'react';

const Contact = ({ contact }) => {
  return ( 
    <tr className='contact-entry-row'>
      <td>{contact.name}</td> 
      <td>{contact.id}</td>
    </tr>
  );
};

export default Contact;