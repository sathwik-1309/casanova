import React from 'react'
import './TeamWinPercentage.css'

function TeamWinPercentage(props) {
  const color = props.meta.color
  const data = props.data
  return (
    <div className='flex-col bg-white team-win-p-box bg-shadow'>
      <div className="bg-dark c-white flex-centered h-30 font-0_9 font-600">WIN %</div>
      <div className='lp-10 pr-10'>
        <div className='flex-row w-300 h-30 win-p-bar'>
          <div className={`${color}1`} style={{
            width: `${data.win_p}%`
          }}></div>
          <div className={`${color}1`} style={{
            width: `${data.loss_p}%`,
            opacity: '0.5'
          }}></div>
        </div>
      </div>
      <div className='flex-row h-30 font-0_8 font-600 flex-centered'>
        <div className='h-30'>WON - {data.won} / {data.total_matches} <span className='font-1 font-600 lp-10'>{data.win_p}%</span></div>
      </div>
      

    </div>
  )
}

export default TeamWinPercentage