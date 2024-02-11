import React, { useState, useEffect } from 'react'
import { BACKEND_API_URL } from '../../../my_constants';
import { PlayerRankingsList } from './PlayerRankingsList';
import Photocard from '../../Player/Photocard/Photocard';
import { PlayerCard1 } from '../PreMatch/PlayerCard1/PlayerCard1';

function PlayerCard3({data, label, color}) {
  return(
    <>
    {
      label == 'bat_points' || label == 'bow_points' ?
        <div className='flex-row h-40 bg-shadow mt-1'>
        <div className={`${color}1 pl-10 flex vert-align w-200`}>{data.name}</div>
        <div className={`${color}1 opacity-9 flex-centered w-100`}>{data[label] || ''}</div>
      </div> :
      <div className='flex-row h-40 bg-shadow mt-1'>
        <div className={`${color}1 pl-10 flex vert-align w-200`}>{data.name}</div>
        <div className={`${color}1 opacity-9 flex-centered w-60 font-1`}>{data[label] == 1000 ? '' : data[label]}</div>
        <div className={`flex-centered w-40 font-0_9 ${data[`${label}_diff`][0] == '-' ? 'c-red' : 'c-green'}`}>{data[`${label}_diff`]}</div>
      </div>
    }
    </>
    
    
  )
}

function SquadList({data, label, color,teamname}) {
  return(
    <div className='flex-col w-300 font-600 font-1 default-font ml-10 mr-10'>
      <div className={`${color}1 h-60 flex-centered rounded-4 font-1_2`}>{teamname}</div>
      {
        data.map((hash)=>{
          return (<PlayerCard3 data={hash} label={label} color={color}/>)
        })
      }
    </div>
  )
}

function MatchRankingsSquadItem({data}) {
  
  return (
    <div className='flex-row h-50 font-600 font-1 bg-shadow mt-1'>
      <Photocard p_id={data.player_id} color={data.color} height='50px'/>
      <div className={`${data.color}1 w-200 pl-10 vert-align flex`}>{data.name}</div>
      <div className={`${data.color}1 opacity-9 w-80 flex-centered`}>{data.points}</div>
    </div>
  )
}

function MatchRankingsSquad({data}) {
  const [display, setDisplay] = useState('bat_points')
  const [data1, setData1] = useState(data.squad1.squad.sort(function(a, b) {
    return b['bat_points'] - a['bat_points']
  }))
  const [data2, setData2] = useState(data.squad2.squad.sort(function(a, b) {
    return b['bat_points'] - a['bat_points']
  }))
  
  const handleDisplay = (val) => {
    setDisplay(val)
    console.log('yolo')
    console.log(data1)
    if (val == 'bat_points' || val == 'bow_points') {
      setData1(data1.sort(function(a, b) {
        return b[val] - a[val]
      }))
      setData2(data2.sort(function(a, b) {
        return b[val] - a[val]
      }))
    }else {
      setData1(data1.sort(function(a, b) {
        return a[val] - b[val]
      }))
      setData2(data2.sort(function(a, b) {
        return a[val] - b[val]
      }))
    }
  }
  return (
    <div className='flex-col default-font flex-centered'>
      <div className='flex-row bg-white mt-30 pb-15 pt-15 bg-shadow'>
        <div className='flex-col ml-10 mr-10'>
          <div className='flex-centered font-600 font-1'>BATTING POINTS</div>
          {
            data.most_points_batting.map((hash)=>{
              return(<MatchRankingsSquadItem data={hash}/>)
            })
          }
        </div>
        <div className='flex-col ml-10 mr-10'>
        <div className='flex-centered font-600 font-1'>BOWLING POINTS</div>
          {
            data.most_points_bowling.map((hash)=>{
              return(<MatchRankingsSquadItem data={hash}/>)
            })
          }
        </div>
      </div>

      <div className='flex-col bg-white mt-30 pb-15 pt-15 bg-shadow fit-content'>
        <div className='flex-row flex-centered wrap gap-20 pb-15'>
          <div className={`${display == 'bat_points' ? 'display_select' : 'display_unselect'} h-30 w-100 flex-centered font-600 font-0_8 rounded-4`} onClick={()=>handleDisplay('bat_points')}>BAT POINTS</div>
          <div className={`${display == 'bow_points' ? 'display_select' : 'display_unselect'} h-30 w-100 flex-centered font-600 font-0_8 rounded-4`} onClick={()=>handleDisplay('bow_points')}>BOW POINTS</div>
          <div className={`${display == 'bat_rank' ? 'display_select' : 'display_unselect'} h-30 w-100 flex-centered font-600 font-0_8 rounded-4`} onClick={()=>handleDisplay('bat_rank')}>BAT RANK</div>
          <div className={`${display == 'bow_rank' ? 'display_select' : 'display_unselect'} h-30 w-100 flex-centered font-600 font-0_8 rounded-4`} onClick={()=>handleDisplay('bow_rank')}>BOW RANK</div>
          <div className={`${display == 'all_rank' ? 'display_select' : 'display_unselect'} h-30 w-100 flex-centered font-600 font-0_8 rounded-4`} onClick={()=>handleDisplay('all_rank')}>ALL RANK</div>
        </div>
        <div className='flex-row'>
          <SquadList data={data1} label={display} color={data.squad1.color} teamname={data.squad1.teamname}/>
          <SquadList data={data2} label={display} color={data.squad2.color} teamname={data.squad2.teamname}/>
        </div>  
      </div>
    </div>
  )
}

export function PlayerMatchRankings ({match_id}) {
  const [data, setData] = useState(null);
  const [display, setdisplay] = useState('match_details');
  const url = `${BACKEND_API_URL}/match/${match_id}/player_rankings`
  useEffect(() => {
      const fetchData = async () => {
          const response = await fetch(url);
          const jsonData = await response.json();
          setData(jsonData);
      };

      fetchData();
  }, []);


  if (!data) {
      return <div>Loading...player match rankings</div>;
  }
  return (
    <div className='flex-col flex-centered'>
      <div className='flex-row w-300 wrap gap-50 flex-centered h-70 bg-white bg-shadow rounded-4'>
        <div className={`h-30 w-80 flex-centered font-600 font-0_8 rounded-4 ${display == 'rankings' ? 'display_select' : 'display_unselect'}`} onClick={()=>{setdisplay('rankings')}}>RANKINGS</div>
        <div className={`h-30 w-80 flex-centered p-5 font-600 font-0_8 rounded-4 ${display == 'match_details' ? 'display_select' : 'display_unselect'}`} onClick={()=>{setdisplay('match_details')}}>DETAILS</div>
      </div>
      {
        display == 'rankings' ?
        <PlayerRankingsList match_id={match_id}/> :
        <MatchRankingsSquad data={data}/>
      }
    </div>
  )
}
