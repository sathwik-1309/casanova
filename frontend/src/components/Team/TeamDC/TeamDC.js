import React from 'react'

function WinPBar(props) {
  const data = props.data
  const color = props.color
  return (
    <div className='flex-row'>
      <div className='w-200 flex-row h-20 win-p-bar'>
        <div className={`${color}1`} style={{
          width: `${data.win_p}%`
        }}></div>
        <div className={`${color}1`} style={{
          width: `${data.loss_p}%`,
          opacity: '0.5'
        }}></div>
      </div>
      <div className='w-200 font-0_8 font-500 flex-centered'><span className='pr-10 font-600 w-80 flex-centered'>{props.label}</span> {data.won} / {data.total_matches} <span className='font-600 font-1 lp-20'>{data.win_p}%</span></div>
    </div>
  )
}

function TeamDC (props) {
  const color = props.meta.color
  const defended = props.defended
  return (
    <div className='flex-col bg-shadow bg-white'>
        <div className="bg-dark c-white flex-centered h-30 font-0_9 font-600">BATTING 1st/2nd</div>
        <div className='lp-10 pr-10'>
          <div className='flex-row'>
            <WinPBar data={defended} color={color} label='DEFENDED'/>
          </div>
          
          <WinPBar data={props.chased} color={color} label='CHASED'/>
        </div>
    </div>
  )
}

export default TeamDC