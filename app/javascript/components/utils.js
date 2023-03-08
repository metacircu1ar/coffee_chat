export function readUserIdAndCookie() {
  const pairs = document.cookie.split('; ');
  const user_id = pairs.find((line) => line.startsWith('user_id='))?.split('=')[1];
  const cookie = pairs.find((line) => line.startsWith('cookie='))?.split('=')[1];
  
  if(!user_id) {
    console.log("User id is not set");
  }

  if(!cookie) {
    console.log("Cookie id is not set");
  }

  return { user_id: user_id, cookie: cookie};
}

export function setUserIdAndCookie(user_id, cookie)
{
  document.cookie = `user_id=${user_id};`; 
  document.cookie = `cookie=${cookie}`; 
}

export function clearUserIdAndCookie()
{
  document.cookie = "user_id=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
  document.cookie = "cookie=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
}

export function mergeWithoutDuplicates(arr1, arr2)
{
  if(arr1 == null) return arr2;
  if(arr2 == null) return arr1;

  const combined = [...arr1, ...arr2].reduce((acc, curr) => {
    if (!acc.some(obj => obj.id === curr.id)) {
      acc.push(curr);
    }
    return acc;
  }, []);

  // Sort the resulting array by created_at_unixtime
  const sorted = combined.sort((a, b) => a.created_at_unixtime - b.created_at_unixtime);

  return sorted;
}