import { React, useState } from 'react'
import './Create.css'
import { BACKEND_API_URL, FRONTEND_API_URL } from '../../my_constants';
import axios from 'axios';

function Create() {
  const [selectedFile, setSelectedFile] = useState(null);
  const [selectedFile2, setSelectedFile2] = useState(null);
  const [error1, setError1] = useState('');
  const [error2, setError2] = useState('');

  const handleFileChange = (e) => {
    setSelectedFile(e.target.files[0]);
  };

  const handleFileChange2 = (e) => {
    setSelectedFile2(e.target.files[0]);
  };

  async function submitTourJson() {
    const formData = new FormData();

    if (selectedFile!=null) {
        formData.append('tournament_json', selectedFile);
    }
    
    const response = await axios.post(`${BACKEND_API_URL}/tournament/create_file`,formData,{ withCredentials: true })
    if (response.status === 202) {
        console.log(response.data.message);
        setError1(response.data.message);
    }else if (response.status === 200) {
        setError1('');
        window.location.replace(`${FRONTEND_API_URL}/`);
    }
  }
  
  async function submitScheduleJson() {
    const formData = new FormData();

    if (selectedFile2!=null) {
        formData.append('schedule_json', selectedFile2);
    }
    
    const response = await axios.post(`${BACKEND_API_URL}/schedule/upload_file`,formData,{ withCredentials: true })
    if (response.status === 202) {
        console.log(response.data.message);
        setError2(response.data.message);
    }else if (response.status === 200) {
        setError2('');
        window.location.replace(`${FRONTEND_API_URL}/`);
    }
  }
  

  return (
    <div className='flex-wrap default-font font-1 font-500'>
      <div className='create_box flex-col bg-shadow'>
        <div className='red-error'>{error1}</div>
        <div className='create_box_title flex-centered c-white bg-shadow'>TOURNAMENT</div>
        <div className='flex-centered m-10' >Upload Tour</div>
        <input type="file" className='font-1 w-200 flex-centered input_file' onChange={handleFileChange}/>
        <div className='flex-centered'>
          <div className='create_button' onClick={submitTourJson}>CREATE</div>
        </div>
      </div>
      <div className='create_box flex-col bg-shadow'>
      <div className='red-error'>{error2}</div>
        <div className='create_box_title flex-centered c-white bg-shadow'>SCHEDULE</div>
        <div className='flex-centered m-10' >Upload Schedule</div>
        <input type="file" className='font-1 w-200 flex-centered input_file' onChange={handleFileChange2}/>
        <div className='flex-centered'>
          <div className='create_button' onClick={submitScheduleJson}>CREATE</div>
        </div>
      </div>
    </div>
  )
}

export default Create