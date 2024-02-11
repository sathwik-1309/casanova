import React from 'react'
import Photocard from '../../../Player/Photocard/Photocard'

export function PlayerCard1 ({data, label, pic}) {
  const height = pic ? '50px' : '40px'
  return (
    <div className={`flex-row font-600 font-1 default-font bg-shadow mt-2 rounded-2 ${pic ? 'h-50' : 'h-40'} w-310`}>
      {
        pic &&
        <Photocard p_id={data.id} color={data.color} height='50px'/>
      }
      
      <div className={`${data.color}1 ${pic ? 'w-200' : 'w-250'} flex vert-align pl-10`}>{data.name}</div>
      <div className={`w-60 flex-centered ${data.color}1 opacity-9`}>{data[label] || ''}</div>
    </div>
  )
}
