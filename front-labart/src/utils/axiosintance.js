
import axios from 'axios';

const backendURL = 'http://localhost:5000';

const axiosInstance = axios.create({
  baseURL: backendURL,
});

export default axiosInstance;
