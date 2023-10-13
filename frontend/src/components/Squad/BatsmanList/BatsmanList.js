import React from 'react'
import Photocard from '../../Player/Photocard/Photocard'
import './BatsmanList.css'
import { TitleCase } from '../../../my_constants'

function BatsmanListItem (props) {
  const data = props.data
  const meta = props.meta
  const player = data.player
  const opacity = props.index%2 == 0 ? '' : 'batsman-list-opacity'
  return (
    <div className={`batsman-list-item flex-row ${meta.color}1 font-1 font-500 ${opacity}`}>
      <div className='w-40 flex-centered'>{props.index+1}</div>
      <Photocard p_id={player.id} height='60px'/>
      <div className='w-150 pl-2 font-600'>{TitleCase(player.fullname)}</div>
      <div className='w-40 flex-centered'>{data.innings}</div>
      <div className='w-60 flex-centered font-600 font-1_1'>{data.runs}</div>
      <div className='w-80 flex-centered'>{data.sr}</div>
      <div className='w-60 flex-centered'>{data.avg}</div>
      <div className='w-40 flex-centered'>{data.fifties}</div>
      <div className='w-80 flex-centered font-600'>{data.best.score}<span className='font-0_7 font-400 pt-3 pl-8'>{data.best.balls}</span></div>
    </div>
  )
}

function BatsmanList (props) {
  return (
    <div className='flex-col batsman-list bg-white bg-shadow'>
      <div className='bg-dark c-white font-600 font-1 flex-centered h-40 mb-2'>BATSMEN</div>
      <div className={`flex-row font-0_9 font-600 ${props.meta.color}2 h-50`}>
        <div className='w-40 flex-centered'> #</div>
        <div className='w-60'></div>
        <div className='w-150 flex-centered'>NAME</div>
        <div className='w-40 flex-centered'>INN</div>
        <div className='w-60 flex-centered'>RUNS</div>
        <div className='w-80 flex-centered'>SR</div>
        <div className='w-60 flex-centered'>AVG</div>
        <div className='w-40 flex-centered'>50+</div>
        <div className='w-80 flex-centered'>BEST</div>
      </div>
      {
        props.bat_stats.map((stat, index) => {
          return (<BatsmanListItem data={stat} meta={props.meta} index={index}/>)
        })
      }
    </div>
  )
}

export default BatsmanList