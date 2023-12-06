import React from 'react'
import './HeadtoHeadBox.css'

function H2HItem({data, onClick}){
  let color
  if (data.record_color == 'red'){
    color = 'h2h_red'
  }else if (data.record_color == 'green'){
    color = 'h2h_green'
  }else {
    color = 'h2h_gray'
  }
   
  return (
    <div className='flex-row h-40 bg-white bg-shadow flex-centered default-font' onClick={()=>onClick(data.team_id)}>
      <div className={`${color} h-30 w-50 font-0_8 font-600 c-white record_box flex-centered`}>{data.record}</div>
      <div className='w-180 flex justify-start lp-20 font-1 font-600'><span className='font-0_8 font-400 pr-6 pt-2'>vs</span>{data.vs_team}</div>
    </div>
  )
}

function HeadtoHeadBox({data, onClick}) {
  return (
    <div className='flex-col default-font h2hbox w-300' >
      <div className="bg-dark c-white flex-centered h-30 font-0_9 font-600">HEAD TO HEAD</div>
      {
        data.map((data, index)=>{
          return (<H2HItem data={data} onClick={onClick}/>)
        })
      }
    </div>
  )
}

export default HeadtoHeadBox