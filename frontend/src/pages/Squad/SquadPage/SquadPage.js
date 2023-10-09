
import { React, useState, useEffect} from 'react'
import { useParams } from 'react-router-dom';
import { BACKEND_API_URL } from '../../../my_constants';
import ScheduleMatchBox from '../../../components/Tournament/Schedule/ScheduleMatchBox/ScheduleMatchBox';
import './SquadPage.css'

function SquadPage(props) {

  let {squad_id} = useParams()

  const [data, setData] = useState(null);

    useEffect(() => {
        const fetchData = async () => {
            const response = await fetch(`${BACKEND_API_URL}/squads/${squad_id}/schedule`);
            const jsonData = await response.json();
            setData(jsonData);
        };

        fetchData();
    }, []);
    if (!data) {
        return <div>Loading...</div>;
    }
    console.log(data)
  return (
    <div className='squad-page-schedules'>
    {
      data.map((schedule, key)=> {
        return(<ScheduleMatchBox data={schedule}/>)
      })
    }
    </div>
  )
}

export default SquadPage