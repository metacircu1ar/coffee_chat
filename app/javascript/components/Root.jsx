import React, { useState, useEffect } from 'react';
import MainWindow from './MainWindow';
import AuthForm from './AuthForm';
import { readUserIdAndCookie } from './utils';

const Root = () => {
  const [isAuthorized, setIsAuthorized] = useState(false);
  const [isLoading, setIsLoading] = useState(true);
  
  const { user_id, cookie } = readUserIdAndCookie();

  useEffect(() => {
    async function checkAuthorization() {

      if(!user_id || !cookie) 
      {
        setIsLoading(false);
        return;
      }

      try {
        const route = `/auth/authorized/${user_id}`; 

        const data = {
          method: 'POST',
          headers: { 
            'Set-Cookie': `cookie=${cookie}`
          }
        };

        console.log("Root sent request");
        console.log(`Route: ${route}`);
        console.log(`Request data:`);
        console.log(data);

        fetch(route, data)
        .then(response => response.json())
        .then(data => {
            console.log("Root received response");
            console.log(`Response data:`);
            console.log(data);

            if(data.status === 'Success')
            {
              setIsAuthorized(true);
            }

            setIsLoading(false);
        });
      } catch (error) {
          console.error(error);
          setIsLoading(false);
      }
    }

    checkAuthorization();
  }, []);

  // A hack to wait until useEffect completes,
  // to avoid rendering either AuthForm or MainWindow
  if (isLoading) {
    return <div></div>;
  }

  return isAuthorized ? 
    <MainWindow setIsAuthorized={setIsAuthorized}/> 
      : 
    <AuthForm setIsAuthorized={setIsAuthorized}/>;
};

export default Root;

