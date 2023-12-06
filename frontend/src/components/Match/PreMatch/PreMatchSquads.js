import React, {useEffect, useState} from 'react';
import { BACKEND_API_URL } from './../../../my_constants'
import { PlayerCard1 } from './PlayerCard1/PlayerCard1';
import Photocard from '../../Player/Photocard/Photocard';
import BatPic from '../../../assets/bat.png'
import BallPic from '../../../assets/ball.png'
import AllPic from '../../../assets/all.png'
import WkPic from '../../../assets/wicket.png'

function PlayerCard2({data, label}) {
  let img_src
  switch (data.skill) {
    case 'bat':
      img_src = BatPic
      break
    case 'bow':
      img_src = BallPic
      break
    case 'all':
      img_src = AllPic
      break
    case 'wk':
      img_src = WkPic
      break
  }
  return (
    <div className='w-350 h-50 flex-row bg-shadow mt-1 rounded-3'>
      <Photocard p_id={data.id} height='50px' color={data.color}/>
      <div className={`flex-col ${data.color}1 w-220`}>
        <div className='h-50 font-600 font-1 flex vert-align pl-10'>{data.name}</div>
        {/* <div className='h-20 flex-row vert-align'>
          <img src={img_src} style={{height: '12px', width: '12px'}}/>
          <div className='pl-5 font-400 font-0_7'>{data.skill_name}</div>
        </div> */}
      </div>
      {
        label == 'runs' || label == 'wickets' || label == 'tour_runs' || label == 'tour_wickets' ?
        <div className={`w-80 ${data.color}1 opacity-9 flex-centered font-600 font-1`}>
          {data[label] || ''}
        </div>
        :
        <div className={`w-80 ${data.color}1 opacity-9 flex-centered font-1`}>
          <div className='w-40 flex-centered vert-align pl-20 font-700'>{data[label] == 1000 ? '' : data[label]}</div>
          <div className='w-40 flex-centered font-400 font-0_7 pt-3'>{data[`${label.split('_')[0]}_rating`] || ''}</div>
        </div>
      }
      
    </div>
  )
}

function PreMatchSquads(props) {
  let url = `${BACKEND_API_URL}/schedule/pre_match_squads`
  if (props.match_id) {
    url = url + `?match_id=${props.match_id}`
  }else {
    url = url + `?schedule_id=${props.schedule_id}`
  }
    
    const [data, setData] = useState(null);
    const [data1, setData1] = useState(null);
    const [data2, setData2] = useState(null);
    const [display, setDisplay] = useState('runs')

    useEffect(() => {
        const fetchData = async () => {
            const response = await fetch(url);
            const jsonData = await response.json();
            setData(jsonData);
            setData1(jsonData[0])
            setData2(jsonData[1])
        };

        fetchData();
    }, []);

    const handleDisplay = (val) => {
      if (val == 'runs' || val == 'wickets' || val == 'tour_runs' || val == 'tour_wickets'){
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
      setDisplay(val)
    }


    if (!data) {
        return <div>Loading...pre match squads</div>;
    }

    return (
      <div className='flex-col default-font flex-centered'>
        <div className='flex-row bg-white bg-shadow w-1000 wrap gap-20 flex-centered h-50 mt-10'>
          <div className={`${display == 'bat_rank' ? 'display_select' : 'display_unselect'} h-30 w-100 flex-centered font-600 font-0_8 rounded-4`} onClick={()=>{handleDisplay('bat_rank')}}>Bat Rating</div>
          <div className={`${display == 'bow_rank' ? 'display_select' : 'display_unselect'} h-30 w-100 flex-centered font-600 font-0_8 rounded-4`} onClick={()=>{handleDisplay('bow_rank')}}>Ball Rating</div>
          <div className={`${display == 'all_rank' ? 'display_select' : 'display_unselect'} h-30 w-100 flex-centered font-600 font-0_8 rounded-4`} onClick={()=>{handleDisplay('all_rank')}}>All Rating</div>
          <div className={`${display == 'runs' ? 'display_select' : 'display_unselect'} h-30 w-100 flex-centered font-600 font-0_8 rounded-4`} onClick={()=>{handleDisplay('runs')}}>Runs</div>
          <div className={`${display == 'wickets' ? 'display_select' : 'display_unselect'} h-30 w-100 flex-centered font-600 font-0_8 rounded-4`} onClick={()=>{handleDisplay('wickets')}}>Wickets</div>
          <div className={`${display == 'tour_runs' ? 'display_select' : 'display_unselect'} h-30 w-100 flex-centered font-600 font-0_8 rounded-4`} onClick={()=>{handleDisplay('tour_runs')}}>Tour Runs</div>
          <div className={`${display == 'tour_wickets' ? 'display_select' : 'display_unselect'} h-30 w-100 flex-centered font-600 font-0_8 rounded-4`} onClick={()=>{handleDisplay('tour_wickets')}}>Tour Wickets</div>
        </div>

        <div className='flex-row bg-white bg-shadow mt-10 w-800 hor-align pt-15 pb-15'>
          <div className='flex-col mr-10'>
            {
              data1.map((hash)=>{
                return (<PlayerCard2 data={hash} label={display}/>)
              })
            }
          </div>
          <div className='flex-col ml-10'>
            {
              data2.map((hash)=>{
                return (<PlayerCard2 data={hash} label={display}/>)
              })
            }
          </div>
          
        </div>
      </div>
    );
}

export default PreMatchSquads;
