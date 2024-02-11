import React, {useState, useEffect} from 'react'
import { BACKEND_API_URL } from '../../../my_constants';
import MatchBox from '../../Match/MatchBox/MatchBox';
import './HeadtoHeadDetailed.css'
import Photocard from '../../Player/Photocard/Photocard';

function MatchBoxDeatailed({data}){
  return (
    <div className='flex-col default-font flex-centered'>
      <MatchBox data={data.match_box}/>
      <div className='flex-col flex-centered h2hborder rounded-4 bg-dark c-white'>
        <div className={`${data.winner.color}1 opacity-9 font-0_7 font-600`}>WINNER</div>
        <div className={`${data.winner.color}1 h-50 flex-centered w-180 font-0_9 font-600`}>{data.winner.teamname}</div>
      </div>
      <div className='flex-col flex-centered h2hborder rounded-4 bg-dark c-white'>
        <div className='font-0_7 font-600'>MOTM ⭐️</div>
        <div className={`flex-row ${data.motm.color}1 h-50 w-180 font-0_9 font-600`}>
          <Photocard p_id={data.motm.id} height='50px'/>
          <div className={`flex-centered lp-10`}>{data.motm.name}</div>
        </div>
        
      </div>
    </div>
  )
}

export function HeadtoHeadDetailed({team1, team2}) {
  const [data, setData] = useState(null)
  let url = `${BACKEND_API_URL}/teams/head_to_head_detailed?team1=${team1}&team2=${team2}`
  useEffect(() => {
      const fetchData = async () => {
          const response = await fetch(url);
          const jsonData = await response.json();
          setData(jsonData);
          console.log(jsonData)
      };

      fetchData();
  }, [url])

  if (!data) {
      return <div>Loading...</div>;
  }
  return (
    <div className='flex-row bg-white wrap gap-50 bg-shadow h2hdetailed'>
      {
        data.boxes.map((data, index)=>{
          return (<MatchBoxDeatailed data={data}/>)
        })
      }
      
    </div>
  )
}
