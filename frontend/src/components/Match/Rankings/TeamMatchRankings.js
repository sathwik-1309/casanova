import React, { useEffect, useState } from 'react'
import { BACKEND_API_URL } from '../../../my_constants';

function TeamRankingItem({data}) {
  const color = data.color
  const diff_color = data.rank_diff_color == 'red' ? 'c-red' : 'c-green'
  return (
    <div className='flex-row pl-10'>
    <div className='flex-row h-50 default-font font-600 font-1 rounded-3 mt-2'>
      <div className={`${color}1 flex-centered w-60 opacity-9`}>{data.rank}</div>
      <div className={`${color}1 flex-centered w-250`}>{data.teamname}</div>
      <div className={`${color}1 flex-centered w-80 opacity-9`}>{data.rating}</div>
    </div>
    <div className={`w-30 flex-centered ${diff_color}`}>{data.rank_diff}</div>
    </div>
  ) 
}

function TeamBox({data}) {
  const color = data.color
  return (
    <div className='flex-row h-50 default-font font-600 font-1 rounded-3 mt-2'>
      <div className={`${color}1 flex-centered w-60 opacity-9`}>{data.rank}</div>
      <div className={`${color}1 flex-centered w-250`}>{data.teamname}</div>
      <div className={`${color}1 flex-centered w-80 opacity-9`}>{data.points}</div>
    </div>
  )
}


function TeamMatchRankings({match_id}) {
  const [data, setData] = useState(null);
  const url = `${BACKEND_API_URL}/match/${match_id}/team_rankings`
  useEffect(() => {
      const fetchData = async () => {
          const response = await fetch(url);
          const jsonData = await response.json();
          setData(jsonData);
      };

      fetchData();
  }, []);


  if (!data) {
      return <div>Loading...team match rankings</div>;
  }
  return (
    <div className='flex-col'>
      <div className='flex-col bg-white pt-15 pb-15 pl-10 pr-10 flex-centered bg-shadow rounded-3'>
        {
          data.team_rankings.map((hash)=>{
            return (<TeamBox data={hash}/>)
          })
        }
      </div>
      <div className='mt-30 bg-white bg-shadow rounded-3 pt-10 pb-15 pl-10 pr-10 font-1 default-font font-600'>
        <div className='flex-centered pb-10'>TEAM RANKINGS</div>
        <div className='flex-col'>
        {
          data.list.map((hash)=>{
            return (<TeamRankingItem data={hash}/>)
          })
        }
        </div>
      </div>
    </div>
  )
}

export default TeamMatchRankings