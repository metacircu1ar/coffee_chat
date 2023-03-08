import React, { useState } from 'react';
import './css/AuthForm.css'; 

const RegisterForm = ({ switchForm }) => {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState(null);

  const handleNameChange = (event) => {
    setName(event.target.value);
  };

  const handleEmailChange = (event) => {
    setEmail(event.target.value);
  };

  const handlePasswordChange = (event) => {
    setPassword(event.target.value);
  };

  const handleSubmit = (event) => {
    event.preventDefault();

    setError(null);
    
    async function register() {
      try {
        const route = 'auth/register';

        const data = {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ 
            'name': name,
            'email': email, 
            'password': password 
          })
        };

        console.log("RegisterForm sent request");
        console.log(`Route: ${route}`);
        console.log(`Request data:`);
        console.log(data);


        fetch(route, data)
        .then(response => response.json())
        .then(data => {
          console.log("RegisterForm received response");
          console.log(`Response data:`);
          console.log(data);

          if(data.status === "Success")
          {
            switchForm();
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

    register();
  };

  const handleLogin = () => {
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
          <label className="form-label" htmlFor="name">Name</label>
          <input className="form-input-text" type="text" value={name} onChange={handleNameChange} />
        </div>

        <div className="form-bottom-margin">
          <label className="form-label" htmlFor="email">Email</label>
          <input className="form-input-text" type="text" value={email} onChange={handleEmailChange} />
        </div>

        <div className="form-bottom-margin">
          <label className="form-label" htmlFor="password">Password</label>
          <input className="form-input-password" type="password" value={password} onChange={handlePasswordChange} />
        </div>

        <div className="form-bottom-margin">
          <input className="form-button" type="submit" value="Register" onClick={handleSubmit} />
        </div>

        <div>
          <input className="form-button" type="submit" value="Log In" onClick={handleLogin} />
        </div>
      </form>
    </div>
  );
};

export default RegisterForm;

