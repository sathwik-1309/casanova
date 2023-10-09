import { React, useState, useEffect } from 'react'
import { BACKEND_API_URL, FRONTEND_API_URL } from '../../../my_constants';
import { useParams } from 'react-router-dom';
import ScheduleMatchBox from '../../Tournament/Schedule/ScheduleMatchBox/ScheduleMatchBox';
import './Schedules.css'

function Schedules() {
  let { t_id } = useParams();

    let url = `${BACKEND_API_URL}/tournament/${t_id}/schedule`
    const [data, setData] = useState(null);

    useEffect(() => {
        const fetchData = async () => {
            const response = await fetch(url);
            const jsonData = await response.json();
            setData(jsonData);
        };

        fetchData();
    }, []);

    if (!data) {
        return <div>Loading...</div>;
    }
  return (
    <div className='flex-col default-font schedules-page'>
      {
        data.map((schedule, index)=>{
          return (<ScheduleMatchBox data={schedule}/>)
        })
      }
    </div>
  )
}

export default Schedules