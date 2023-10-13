
import { React, useState, useEffect} from 'react'
import { useParams } from 'react-router-dom';
import { BACKEND_API_URL } from '../../../my_constants';
import './TeamPage.css'
import ScheduleMatchBox2 from '../../../components/Tournament/Schedule/ScheduleMatchBox2/ScheduleMatchBox2';
import Photocard from '../../../components/Player/Photocard/Photocard';
import BatsmanList from '../../../components/Squad/BatsmanList/BatsmanList';
import BowlerList from '../../../components/Squad/BowlerList/BowlerList';
import TeamHeader from '../../../components/Team/TeamHeader/TeamHeader';
import TeamPerformers from '../../../components/Team/TeamPerformers/TeamPerformers';
import TeamTotals from '../../../components/Team/TeamTotals/TeamTotals';
import TeamWinPercentage from '../../../components/Team/TeamWinPercentage/TeamWinPercentage';
import TeamDC from '../../../components/Team/TeamDC/TeamDC';

function TeamPage(props) {

  let {team_id} = useParams()

  const [data, setData] = useState(null);

    useEffect(() => {
        const fetchData = async () => {
            const response = await fetch(`${BACKEND_API_URL}/teams/${team_id}/team_page`);
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
    <div className='squad-page flex-col default-font'>
      <div className='flex-row squad-page-row2'>
        <div className='flex-col flex-centered'>
          <TeamHeader data={data.meta} label={`Tournaments - ${data.tournaments}`}/>
          {/* <SquadSchedules data={data.schedule} /> */}
        </div>
        <TeamPerformers data={data.top_players} meta={data.meta}/>
      </div>
      <div className='flex-row squad-page-row4'>
        <TeamTotals data={data.team_stats.total_stats} meta={data.meta}/>
        <TeamWinPercentage meta={data.meta} data={data.team_stats.result_stats}/>
        <TeamDC meta={data.meta} defended={data.team_stats.defended} chased={data.team_stats.chased}/>
      </div>
      <div className='flex-row squad-page-row3'>
        <BatsmanList meta={data.meta} bat_stats={data.bat_stats}/>
        <BowlerList meta={data.meta} ball_stats={data.ball_stats}/>
      </div>
      
    </div>
  )
}

export default TeamPage
