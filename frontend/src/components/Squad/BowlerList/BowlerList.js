import React from 'react'
import Photocard from '../../Player/Photocard/Photocard'
import './BowlerList.css'
import { TitleCase } from '../../../my_constants'

function BowlerListItem (props) {
  const data = props.data
  const meta = props.meta
  const player = data.player
  const opacity = props.index%2 == 0 ? '' : 'bowler-list-opacity'
  return (
    <div className={`bowler-list-item flex-row ${meta.color}1 font-1 font-500 ${opacity}`}>
      <div className='w-40 flex-centered'>{props.index+1}</div>
      <Photocard p_id={player.id} height='60px'/>
      <div className='w-150 pl-2 font-600'>{TitleCase(player.fullname)}</div>
      <div className='w-40 flex-centered'>{data.innings}</div>
      <div className='w-60 flex-centered font-600 font-1_1'>{data.wickets}</div>
      <div className='w-40 flex-centered'>{data.maidens}</div>
      <div className='w-60 flex-centered'>{data.sr}</div>
      <div className='w-40 flex-centered'>{data.three_wickets}</div>
      <div className='w-100 flex-centered font-600'>{data.best.fig}<span className='font-0_7 font-400 pt-3 pl-8'>{data.best.overs}</span></div>
    </div>
  )
}

function BowlerList (props) {
  return (
    <div className='flex-col bowler-list bg-white'>
      <div className='bg-dark c-white font-600 font-1 flex-centered h-40 mb-2'>BOWLERS</div>
      <div className={`flex-row font-0_9 font-600 ${props.meta.color}2 h-50`}>
      <div className='w-40 flex-centered'> #</div>
        <div className='w-60'></div>
        <div className='w-150 flex-centered'>NAME</div>
        <div className='w-40 flex-centered'>INN</div>
        <div className='w-60 flex-centered'>W</div>
        <div className='w-40 flex-centered'>M</div>
        <div className='w-60 flex-centered'>SR</div>
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