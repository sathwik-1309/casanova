import React from 'react'
import Photocard from '../../Player/Photocard/Photocard'
import './BatsmanList.css'
import { TitleCase } from '../../../my_constants'

function BatsmanListItem (props) {
  const data = props.data
  const player = data.player
  let color;
  let shadow;
  let opacity_index;
  let content;
  if (props.meta){
    color = props.meta.color
    shadow = ''
    opacity_index = 2
    content = <Photocard p_id={player.id} height='60px'/>
  }else {
    color = data.color
    shadow = 'bg-shadow'
    opacity_index = 1
    content = <div className='flex-row'>
      <Photocard p_id={player.id} height='60px'/>
      <div className='w-60 font-0_8 font-400 flex-centered justify-center'>{data.teamname}</div>
      </div>
    // content = <div className='w-60 font-0_8 font-400 flex-centered justify-start'>{data.teamname}</div>
  }
  const opacity = props.index%opacity_index == 0 ? '' : 'batsman-list-opacity'
  return (
    <div className={`batsman-list-item flex-row ${color}1 font-1 h-60 font-500 ${opacity} ${shadow}`}>
      <div className='w-40 flex-centered'>{props.index+1}</div>
      {content}
      <div className='w-180 pl-5 font-600'>{TitleCase(player.fullname)}</div>
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
  const color = props.meta ? props.meta.color : 'bg-white c-black '
  return (
    <div className='flex-col batsman-list bg-white bg-shadow default-font'>
      <div className='bg-dark c-white font-600 font-1 flex-centered h-40 mb-2'>BATSMEN</div>
      <div className={`flex-row font-0_9 font-600 ${color}2 h-50`}>
        <div className='w-40 flex-centered'> #</div>
        <div className='w-60'></div>
        {
          !props.meta &&
          <div className='w-60 flex-centered'>TEAM</div>
        }
        <div className='w-180 flex-centered'>NAME</div>
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