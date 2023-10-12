
import { React, useState, useEffect} from 'react'
import { useParams } from 'react-router-dom';
import { BACKEND_API_URL } from '../../../my_constants';
import './SquadPage.css'
import ScheduleMatchBox2 from '../../../components/Tournament/Schedule/ScheduleMatchBox2/ScheduleMatchBox2';
import Photocard from '../../../components/Player/Photocard/Photocard';
import BatsmanList from '../../../components/Squad/BatsmanList/BatsmanList';
import BowlerList from '../../../components/Squad/BowlerList/BowlerList';

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

function SquadHeader(props) {
  return(
    <div className={`flex-col font-1_2 font-600 w-400 flex-centered bg-shadow squad-header ${props.data.color}1`}>
        <div className='squad-header-line1 flex-centered'>{props.data.teamname}</div>
        <div className='font-400 font-0_8 squad-header-line2'>{props.data.tour}</div>
      </div>
  )
}

function CaptainBox(props) {
  const data = props.data
  return (
      <div className={`flex-col ${props.meta.color}1 captain-box`}>
        <div className={`font-600 font-0_7 flex-centered pt-3 ${props.meta.color}2`}>CAPTAIN</div>
        <div className='flex-row'>
          <Photocard p_id={data.id} color={props.meta.color} height='60px'/>
          <div className='flex-centered font-1 font-600 flex-grow w-180 pr-30'> {data.fullname} </div>
        </div>
      </div>
  )
}

function PerformerBox({header, player, info, meta, label, size}) {
  let height = '60px'
  if (size){
    height = '70px'
  }
  return (
    <div className='flex-col performer-box'>
      <div className={`font-600 font-0_7 flex-centered pt-3 ${meta.color}2`}>{header}</div>
      <div className={`flex-row ${meta.color}1 font-600 font-1 flex-centered`}>
        <Photocard p_id={player.id} color={meta.color} height={height} />
        <div className='w-180 lp-10'>{player.fullname}</div>
        <div className='w-100 flex-centered'>{info} <span className='font-500 font-0_7 pt-3 pl-5'> {label}</span></div>
      </div>
    </div>
  )
}

function SquadPerformers(props) {
  const data = props.data
  console.log(data)
  return (
    <div className='flex-col bg-white bg-shadow squad-performers flex-centered'>
      <CaptainBox data={data.captain} meta={props.meta}/>
      <div className='flex-row squad-performers-rows'>
        <PerformerBox header='MOST RUNS' meta={props.meta} player={data.most_runs.player} info={data.most_runs.runs} label='RUNS' size={true}/>
        <PerformerBox header='MOST WICKETS' meta={props.meta} player={data.most_wickets.player} info={data.most_wickets.wickets} label='WICKETS' size={true}/>
      </div>
      <div className='flex-row squad-performers-rows'>
        <PerformerBox header='BEST STRIKE-RATE' meta={props.meta} player={data.best_sr.player} info={data.best_sr.sr} label='SR'/>
        <PerformerBox header='BEST ECONOMY' meta={props.meta} player={data.best_economy.player} info={data.best_economy.economy} label='RPO'/>
      </div>
      <div className='flex-row squad-performers-rows'>
        <PerformerBox header='BEST SCORE' meta={props.meta} player={data.best_score.player} info={data.best_score.best.score} label={data.best_score.best.balls}/>
        <PerformerBox header='BEST SPELL' meta={props.meta} player={data.best_spell.player} info={data.best_spell.best.fig} label={data.best_spell.best.overs}/>
      </div>
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
    <div className='squad-page flex-col default-font'>
      <SquadHeader data={data.meta}/>
      <div className='flex-row squad-page-row2'>
        <SquadSchedules data={data.schedule} />
        <SquadPerformers data={data.top_players} meta={data.meta}/>
      </div>
      <div className='flex-row squad-page-row3'>
        <BatsmanList meta={data.meta} bat_stats={data.bat_stats}/>
        <BowlerList meta={data.meta} ball_stats={data.ball_stats}/>
      </div>
      
    </div>
  )
}

export default SquadPage
