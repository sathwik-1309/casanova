// apiConfig.js
export const BACKEND_API_URL = `http://${process.env.REACT_APP_HOST}:3001`;
export const FRONTEND_API_URL = `http://${process.env.REACT_APP_HOST}:3000`;

export const TitleCase = (str) =>  {
  return str.replace(
    /\w\S*/g,
    function(txt) {
      return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
    }
  );
}
