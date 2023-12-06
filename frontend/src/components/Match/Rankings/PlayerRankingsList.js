import {React, useState, useEffect} from 'react'
import { BACKEND_API_URL, FRONTEND_API_URL } from '../../../my_constants';
import { PlayerCard1 } from '../PreMatch/PlayerCard1/PlayerCard1';
import PlayerCard from '../../Player/PlayerCard/PlayerCard';
import Photocard from '../../Player/Photocard/Photocard';

function RankingListItem ({data, pic}) {
  return (
    <a className={`${pic ? 'h-60' : 'h-40'} flex-row mt-1 bg-shadow font-600 font-1 decoration-none`} href={`${FRONTEND_API_URL}/player/${data.id}`}>
      {
        pic ? 
        <Photocard p_id={data.id} color={data.color} height='60px'/>
        :
        <div className={`w-50 flex-centered ${data.color}1`}>{data.rank}</div>
      }
      
      <div className={`${data.color}1 ${pic ? 'w-240' : 'w-250'} pl-10 vert-align flex`}>{data.name}</div>
      <div className={`${data.color}1 opacity-9 w-80 flex-centered`}>{data.rating}</div>
    </a>
  )
}

function RankingList({data, label}) {
  return(
    <div className='flex-col font-600 font-1 mr-20 ml-20'>
      <div className='flex-centered h-40'>{label}</div>
      {
        data.map((hash, index)=>{
          const pic = index ==0 ? true : false
          return(<RankingListItem data={hash} pic={pic}/>)
        })
      }
    </div>
  )
}

export function PlayerRankingsList ({match_id}) {
  const [data, setData] = useState(null);
  const [display, setdisplay] = useState(false);
  const url = `${BACKEND_API_URL}/match/${match_id}/player_rankings_list`
  useEffect(() => {
      const fetchData = async () => {
          const response = await fetch(url);
          const jsonData = await response.json();
          setData(jsonData);
      };

      fetchData();
  }, []);


  if (!data) {
      return <div>Loading...player match rankings list</div>;
  }

  const handleDisplay = (val) => {
    setdisplay(val)
  }

  return (
    <div className='flex-col'>
      <div className='flex-row w-400 wrap gap-50 flex-centered h-70 bg-white bg-shadow rounded-4 mt-10'>
        <div className={`h-30 w-80 flex-centered font-600 font-0_8 rounded-4 display_select`} onClick={()=>{setdisplay(!display)}}>{display ? 'TOP 10' : 'TOP 50'}</div>
      </div>

      {
        display ? 
        <div className='flex-row bg-shadow bg-white pb-15 pl-20 pr-20 rounded-4 mt-10'>
          <RankingList data={data.batting_rankings} label='Batting Ranking' />
          <RankingList data={data.bowling_rankings} label='Bowling Ranking' />
          <RankingList data={data.all_rankings} label='Allrounder Ranking'/>
        </div>
        :
        <div className='flex-row bg-shadow bg-white pb-15 pl-20 pr-20 rounded-4 mt-10'>
          <RankingList data={data.batting_rankings.slice(0,10)} label='Batting Ranking' />
          <RankingList data={data.bowling_rankings.slice(0,10)} label='Bowling Ranking' />
          <RankingList data={data.all_rankings.slice(0,10)} label='Allrounder Ranking'/>
        </div>
      }

    </div>
  )
}
