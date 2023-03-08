import React from 'react';
const showdown = require('showdown');
const showdownHighlight = require("showdown-highlight");
import "highlight.js/styles/github-dark.css";

let converter = new showdown.Converter({
  extensions: [showdownHighlight({
      pre: false
  ,   auto_detection: true
  })]
});

const Message = ({ message }) => {
  return (
    <div className="message">
      <div className='message-header'>
        <strong className='message-username'>{message.user_name}</strong>
        <div className='message-timestamp'>{message.created_at_timestamp}</div>
      </div>
      <div className="margins-between-children"
        dangerouslySetInnerHTML={{__html: converter.makeHtml(message.text)}}>
      </div>
    </div>
  );
};

export default Message;

