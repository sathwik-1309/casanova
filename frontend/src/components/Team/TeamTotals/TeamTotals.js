import React from "react"
import './TeamTotals.css'

function TotalBox(props) {
  return (
    <div className='flex-col total-box'>
      <div className={`h-20 ${props.meta.color}2 flex-centered font-0_7 font-600`}>{props.label}</div>
      {
        !props.avg ? 
        <div className={`h-50 ${props.meta.color}1 flex-centered font-600 w-180`}>{props.score} <span className='font-400 font-0_7 lp-10 pr-10'>vs</span> <span className="font-500 font-0_9">{props.vs_team}</span></div> 
        :
        <div className={`h-50 ${props.meta.color}1 flex-centered font-600 w-100`}>{props.score}</div>
      }
      
    </div>
  )
}

function TeamTotals(props) {
  const data = props.data
  console.log(data)
  return (
    <>
    {
      data.highest_total &&
      <div className="flex-col">
      <div className="bg-dark c-white flex-centered h-30 font-0_9 font-600">TEAM TOTALS</div>
      <div className='flex-row team-totals bg-shadow bg-white font-1 font-500'>
        {data.lowest_total && <TotalBox label='LOWEST' score={data.lowest_total.score} meta={props.meta} vs_team={data.lowest_total.vs_team}/>}
        {data.avg_total && <TotalBox label='AVERAGE' score={data.avg_total} meta={props.meta} avg={true}/>}
        {data.highest_total && <TotalBox label='HIGHEST' score={data.highest_total.score} meta={props.meta} vs_team={data.highest_total.vs_team}/>}
      </div>
      
    </div>
    }
    </>
  )
}

export default TeamTotals