import React from 'react'
import Photocard from '../../Player/Photocard/Photocard'
import './BowlerList.css'
import { TitleCase } from '../../../my_constants'

function BowlerListItem (props) {
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
  const opacity = props.index%opacity_index == 0 ? '' : 'bowler-list-opacity'
  return (
    <div className={`bowler-list-item flex-row ${color}1 font-1 h-60 font-500 ${opacity}`}>
      <div className='w-40 flex-centered'>{props.index+1}</div>
      {content}
      <div className='w-180 pl-2 font-600'>{TitleCase(player.fullname)}</div>
      <div className='w-40 flex-centered'>{data.innings}</div>
      <div className='w-60 flex-centered font-600 font-1_1'>{data.wickets}</div>
      <div className='w-40 flex-centered'>{data.maidens}</div>
      <div className='w-60 flex-centered'>{data.economy}</div>
      <div className='w-40 flex-centered'>{data.three_wickets}</div>
      <div className='w-100 flex-centered font-600'>{data.best.fig}<span className='font-0_7 font-400 pt-3 pl-8'>{data.best.overs}</span></div>
    </div>
  )
}

function BowlerList (props) {
  const color = props.meta ? props.meta.color : 'bg-white c-black '
  return (
    <div className='flex-col bowler-list bg-white bg-shadow'>
      <div className='bg-dark c-white font-600 font-1 flex-centered h-40 mb-2'>BOWLERS</div>
      <div className={`flex-row font-0_9 font-600 ${color}2 h-50`}>
      <div className='w-40 flex-centered'> #</div>
        <div className='w-60'></div>
        <div className='w-150 flex-centered'>NAME</div>
        <div className='w-40 flex-centered'>INN</div>
        <div className='w-60 flex-centered'>W</div>
        <div className='w-40 flex-centered'>M</div>
        <div className='w-60 flex-centered'>ECO</div>
        <div className='w-40 flex-centered'>3+</div>
        <div className='w-100 flex-centered'>BEST</div>
      </div>
      {
        props.ball_stats.map((stat, index) => {
          return (<BowlerListItem data={stat} meta={props.meta} index={index}/>)
        })
      }
    </div>
  )
}

export default BowlerList