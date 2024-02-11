import React, {useEffect, useState} from 'react';
import { BACKEND_API_URL } from './../../../my_constants'
import { H2HRecordBox } from './H2HRecordBox/H2HRecordBox';
import PlayerCard from '../../Player/PlayerCard/PlayerCard';
import { PlayerCard1 } from './PlayerCard1/PlayerCard1';
import { MatchBoxDeatailed } from '../../Team/HeadtoHeadDetailed/MatchBoxDetailed';

function RankingList({data, label}) {
  return (
    <div className='flex-col font-600 font-1 mr-10 ml-10 w-310'>
      <div className='h-40 flex-centered'>{label}</div>
      {
        data.map((hash, index)=>{
          const pic = index == 0 ? true : false
          return (<PlayerCard1 data={hash} label='ranking' pic={pic}/>)
        })
      }
    </div>
  )
}

function PreMatchStats(props) {
  let url = `${BACKEND_API_URL}/schedule/pre_match`
  if (props.match_id) {
    url = url + `?match_id=${props.match_id}`
  }else if (props.schedule_id) {
    url = url + `?schedule_id=${props.schedule_id}`
  }else {
    url = url + `?team1=${props.team1}&team2=${props.team2}`
  }
    
    const [data, setData] = useState(null);

    useEffect(() => {
        const fetchData = async () => {
            const response = await fetch(url);
            const jsonData = await response.json();
            setData(jsonData);
        };

        fetchData();
    }, [props.team2]);


    if (!data) {
        return <div>Loading...pre match stats</div>;
    }

    return (
      <div className='flex-col flex-centered default-font'>
        <H2HRecordBox data={data.h2h_record_box}/>
        <div className='flex-col mt-30 bg-white flex-centered bg-shadow pb-15 w-700'>
          <div className='h-40 flex-centered font-600 font-1'>MOST RUNS</div>
          <div className='flex-row'>
            <div className='flex-col mr-10'>
              {
                data.most_runs[0].map((hash, index)=>{
                  const pic = index == 0 ? true : false 
                  return (<PlayerCard1 data={hash} label='runs' pic={pic}/>)
                })
              }
            </div>
            <div className='flex-col ml-10'>
              {
                data.most_runs[1].map((hash, index)=>{
                  const pic = index == 0 ? true : false 
                  return (<PlayerCard1 data={hash} label='runs' pic={pic}/>)
                })
              }
          </div>
        </div>
        </div>

        <div className='flex-col mt-30 bg-white flex-centered bg-shadow pb-15 w-700'>
          <div className='h-40 flex-centered font-600 font-1'>MOST WICKETS</div>
          <div className='flex-row'>
            <div className='flex-col mr-10'>
              {
                data.most_wickets[0].map((hash, index)=>{
                  const pic = index == 0 ? true : false 
                  return (<PlayerCard1 data={hash} label='wickets' pic={pic}/>)
                })
              }
            </div>
            <div className='flex-col ml-10'>
              {
                data.most_wickets[1].map((hash, index)=>{
                  const pic = index == 0 ? true : false 
                  return (<PlayerCard1 data={hash} label='wickets' pic={pic}/>)
                })
              }
          </div>
        </div>
        </div>

        <div className='flex-row mt-30 bg-white flex-centered bg-shadow pb-15 w-1000'>
          <RankingList label='Batting Rank' data={data.bat_rankings}/>
          <RankingList label='Bowling Rank' data={data.bow_rankings}/>
          <RankingList label='All-rounders Rank' data={data.all_rankings}/>
        </div>

        <div className='flex-row bg-white wrap gap-50 bg-shadow h2hdetailed mt-30'>
          {
            data.boxes.map((data, index)=>{
              return (<MatchBoxDeatailed data={data}/>)
            })
          } 
        </div>
        
      </div>
    );
}

export default PreMatchStats;
