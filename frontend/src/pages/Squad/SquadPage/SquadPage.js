
import { React, useState, useEffect} from 'react'
import { useParams } from 'react-router-dom';
import { BACKEND_API_URL } from '../../../my_constants';
import ScheduleMatchBox from '../../../components/Tournament/Schedule/ScheduleMatchBox/ScheduleMatchBox';
import './SquadPage.css'
import ScheduleMatchBox2 from '../../../components/Tournament/Schedule/ScheduleMatchBox2/ScheduleMatchBox2';

function SquadSchedules(props) {
  const data = props.data
  return (
    <div className='squad-page-schedules default-font'>
      <div className='squad-schedule-header flex-centered font-1 font-600'>TEAM SCHEDULE</div>
    {
      data.map((schedule, key)=> {
        return(<ScheduleMatchBox2 data={schedule}/>)
      })
    }
    </div>
  )
}

function SquadPage(props) {

  let {squad_id} = useParams()

  const [data, setData] = useState(null);

    useEffect(() => {
        const fetchData = async () => {
            const response = await fetch(`${BACKEND_API_URL}/squads/${squad_id}/squad_page`);
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
    <div className='squad-page'>
      <SquadSchedules data={data.schedule} />
    </div>
  )
}

export default SquadPage
