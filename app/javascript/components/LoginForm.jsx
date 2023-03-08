import React, { useState } from 'react';
import { setUserIdAndCookie } from './utils';
import './css/AuthForm.css'; 

const LoginForm = ({ switchForm, setIsAuthorized }) => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState(null);

  const handleEmailChange = (event) => {
    setEmail(event.target.value);
  };

  const handlePasswordChange = (event) => {
    setPassword(event.target.value);
  };

  const handleSubmit = (event) => {
    event.preventDefault();

    setError(null);

    async function login() {
      try {
        const route = 'auth/login';

        const data = {
          method: 'POST',
          headers: { 'Content-Type': 'application/json'},
          body: JSON.stringify({ 
            'email': email, 
            'password': password 
          })
        };

        console.log("LoginForm sent request");
        console.log(`Route: ${route}`);
        console.log(`Request data:`);
        console.log(data);

        fetch(route, data)
        .then(response => response.json())
        .then(data => {
            console.log("LoginForm received response");
            console.log(`Response data:`);
            console.log(data);

            if(data.status === "Success")
            {
              if(data.user_id && data.cookie)
              {
                setUserIdAndCookie(data.user_id, data.cookie);
                setIsAuthorized(true);
              }
              else
              {
                console.log("User id and/or cookie is missing");
              }
            }
            else if(data.status === "Error")
            {
              setError(`Error: ${data.message}`)
            }
            else 
            {
              console.log("Unexpected data");
            }
        });
      } catch (error) {
        console.error(`Fetch error: ${error}`);
      }
    }

    login();

  };

  const handleRegister = () => {
    switchForm();
  };

  return (
    <div className="form-container">
      {error && <div className="form-error">{error}</div>}
      <form onSubmit={handleSubmit}>
        <header className="form-header">
          <h1>Welcome! ☕</h1>
        </header>

        <div className="form-bottom-margin">
          <label className="form-label" htmlFor="email">Email</label>
          <input className="form-input-text" type="text" id="email" value={email} onChange={handleEmailChange} />
        </div>

        <div className="form-bottom-margin">
          <label className="form-label" htmlFor="password">Password</label>
          <input className="form-input-password" type="password" id="password" value={password} onChange={handlePasswordChange} />
        </div>

        <div className="form-bottom-margin">
          <input className="form-button" type="submit" value="Log In" onClick={handleSubmit} />
        </div>

        <div>
          <input className="form-button" type="submit" value="Register" onClick={handleRegister} />
        </div>
      </form>
    </div>
  );
};

export default LoginForm;
