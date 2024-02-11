import React, { useState, useEffect } from 'react'
import { BACKEND_API_URL } from '../../my_constants';
import Photocard from '../Player/Photocard/Photocard';

function LeaderboardItem({data, index}) {
  return (
    <div className='flex-row default-font font-500 font-1 h-50 bg-shadow mt-1 rounded-2'>
      <div className={`${data.color}1 opacity-9 flex-centered w-40 font-500 font-0_9`}>{index+1}</div>
      <div className={`${data.color}1 pl-15 w-250 flex vert-align`}>{data.name}</div>
      <div className={`${data.color}1 opacity-10 flex-centered w-60 font-600`}>{data.matches}</div>
      <div className={`${data.color}1 opacity-9 flex-centered w-100`}>{data.highest_rating}</div>
      <div className={`${data.color}1 opacity-10 flex-centered w-60 font-0_9 font-500`}>{data.times}</div>
    </div>
  )
}

function HistoryItem({data, index}) {
  return (
    <div className='flex-row default-font font-500 font-1 h-50 bg-shadow mt-1 rounded-2'>
      <div className={`${data.color}1 opacity-9 flex-centered w-40 font-500 font-0_9`}>{index+1}</div>
      <div className={`${data.color}1 pl-15 w-250 flex vert-align`}>{data.name}</div>
      <div className={`${data.color}1 opacity-10 flex-centered w-60 font-600`}>{data.matches}</div>
      <div className={`${data.color}1 opacity-9 flex-centered w-100`}>{data.highest_rating}</div>
      <div className={`${data.color}1 opacity-10 flex-centered w-60 font-0_9 font-400`}>{data.match_id}</div>
    </div>
  )
}

function History({data}) {
  return (
    <div className='flex-col mt-30 bg-white bg-shadow pb-15 pt-15 pl-20 pr-20  ml-10 mr-10'>
      <div className='h-30 flex-centered font-600 font-1 bg-theme1 c-white rounded-2'>History</div>
      <div className='flex-row font-600 font-0_8 h-35 vert-align'>
        <div className='flex-centered w-40'>No.</div>
        <div className='flex-centered w-250'>Name</div>
        <div className='flex-centered w-60'>Mat</div>
        <div className='flex-centered w-100'>Highest</div>
        <div className='flex-centered w-60'>m_id</div>
      </div>
      {
        data.history.map((hash, index)=>{
          return (<HistoryItem data={hash} index={index}/>)
        })
      }
    </div>
  )
}

function LeaderboardList({data}) {
  return (
    <div className='flex-col mt-30 bg-white bg-shadow pb-15 pt-15 pl-20 pr-20 ml-10 mr-10'>
      <div className='h-30 flex-centered font-600 font-1 bg-theme1 c-white rounded-2'>Leaderboard</div>
      <div className='flex-row font-600 font-0_8 h-35 vert-align'>
        <div className='flex-centered w-40'>No.</div>
        <div className='flex-centered w-250'>Name</div>
        <div className='flex-centered w-60'>Mat</div>
        <div className='flex-centered w-100'>Highest</div>
        <div className='flex-centered w-60'>Times</div>
      </div>
      {
        data.leaderboard.map((hash, index)=>{
          return (<LeaderboardItem data={hash} index={index}/>)
        })
      }
    </div>
  )
}

export function TeamLeaderboard () {
  let url = `${BACKEND_API_URL}/teams/leaderboard`
    const [data, setData] = useState(null);
    const [format, setFormat] = useState('wt20')

    useEffect(() => {
        const fetchData = async () => {
            const response = await fetch(url);
            const jsonData = await response.json();
            setData(jsonData);
        };

        fetchData();
    }, []);


    if (!data) {
      return <div>Loading..</div>
    }
       
  return (
    <div className='flex-col default-font flex-centered'>
      <div className='flex-row bg-white bg-shadow pb-15 pt-15 w-300 wrap gap-50 flex-centered mt-30'>
        <div className={`${format == 'wt20' ? 'display_select' : 'display_unselect'} w-80 h-30 font-600 font-1 flex-centered rounded-4`} onClick={()=>{setFormat('wt20')}}>WT20</div>
        <div className={`${format == 'csl' ? 'display_select' : 'display_unselect'} w-80 h-30 font-600 font-1 flex-centered rounded-4`} onClick={()=>{setFormat('csl')}}>CSL</div>
      </div>

      <div className='flex-row'>
        <History data={data[format]} />
        <LeaderboardList data={data[format]} />
      </div>

    </div>
  )
}
