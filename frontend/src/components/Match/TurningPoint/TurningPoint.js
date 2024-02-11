import { React, useEffect, useState } from 'react'
import { BACKEND_API_URL } from '../../../my_constants';
import './TurningPoint.css'

function TurningPoint(props) {
  const data = props.data
  const color = data.color
  // let url = `${BACKEND_API_URL}/match/${props.m_id}/turning_point`
  // const [data, setData] = useState(null);

  // useEffect(() => {
  //     const fetchScorecard = async () => {
  //     const response1 = await fetch(url);
  //     const jsonscorecard = await response1.json();
  //     setData(jsonscorecard);
  //     };

  //     fetchScorecard();
  // }, []);
  // if (!data) {
  //   return <></>
  // }
  return (
    <div className={`flex-col font-0_9 w-600 bg-shadow turning-point bg-white font-500 ${data.font}`}>
      <div className='h-35 font-600 c-black flex-centered'>Turning Point</div>
      <div className={`h-35 font-0_9 font-600 flex-centered ${color}1 turning-point-statement`}>{data.statement}</div>
      <div className='flex-row justify-evenly'>
        <div className='flex-col w-100 turning-point-boxes'>
          <div className={`${color}1 flex-centered h-30 opacity`}>{data.bat_team}</div>
          <div className={`${color}1 flex-centered h-40 font-1`}>{data.score} - {data.for}</div>
        </div>
        <div className='flex-col w-100 turning-point-boxes'>
          <div className={`${color}1 flex-centered h-30 opacity`}>OVERS</div>
          <div className={`${color}1 flex-centered h-40 font-1`}>{data.delivery}</div>
        </div>
        <div className='flex-col w-100 turning-point-boxes'>
          <div className={`${color}1 flex-centered h-30 opacity`}>CRR</div>
          <div className={`${color}1 flex-centered h-40 font-1`}>{data.crr}</div>
        </div>
        <div className='flex-col w-100 turning-point-boxes'>
          <div className={`${color}1 flex-centered h-30 opacity`}>RRR</div>
          <div className={`${color}1 flex-centered h-40 font-600 font-1`}>{data.rrr}</div>
        </div>
        <div className='flex-col w-180 turning-point-boxes'>
          <div className={`${color}1 flex-centered h-30 opacity`}>EQUATION</div>
          <div className={`${color}1 h-40 flex-centered font-600 font-1`}>{data.runs_left}<span className='font-0_8 font-400 pr-10 lp-10'>off</span>{data.balls_left}</div>
        </div>
      </div>
    </div>
  )
}

export default TurningPoint