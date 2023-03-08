import React, { useState } from 'react';
import LoginForm from './LoginForm';
import RegisterForm from './RegisterForm';
import './css/AuthForm.css'; 

const AuthForm = ({ setIsAuthorized }) => {
  const [isLoginForm, setIsLoginForm] = useState(true);

  const handleFormSwitch = () => {
    setIsLoginForm(!isLoginForm);
  };

  return (
    <div>
      {isLoginForm ? (
        <LoginForm 
          switchForm={handleFormSwitch} 
          setIsAuthorized={setIsAuthorized}/>
      ) : (
        <RegisterForm 
          switchForm={handleFormSwitch} 
        />
      )}
    </div>
  );
};

export default AuthForm;
