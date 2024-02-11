import React, {useEffect, useState} from 'react';
import { BACKEND_API_URL } from './../../../my_constants'
import PreMatchStats from './PreMatchStats';
import PreMatchSquads from './PreMatchSquads';
import './PreMatch.css'
import { useParams } from 'react-router-dom';

function PreMatch(props) {
  let {schedule_id} = useParams()
  const [display, setDisplay] = useState('stats')
  return (
    <div className='flex-col default-font flex-centered'>
      <div className='flex-row w-300 wrap gap-50 flex-centered h-70 bg-white bg-shadow rounded-4'>
        <div className={`h-30 w-80 flex-centered font-600 font-0_8 rounded-4 ${display == 'stats' ? 'display_select' : 'display_unselect'}`} onClick={()=>{setDisplay('stats')}}>STATS</div>
        <div className={`h-30 w-80 flex-centered p-5 font-600 font-0_8 rounded-4 ${display == 'squads' ? 'display_select' : 'display_unselect'}`} onClick={()=>{setDisplay('squads')}}>SQAUDS</div>
      </div>
      {
        display == 'stats' ? 
        <PreMatchStats match_id={props.match_id} schedule_id={schedule_id} team1={props.team1} team2={props.team2}/> :
        <PreMatchSquads match_id={props.match_id} schedule_id={schedule_id} team1={props.team1} team2={props.team2}/>
      }
    </div>
  );
}

export default PreMatch;
