import React from 'react'

function H2HRecordBoxItem({data, left}) {
  return (
    <div className=''>
      {
        !left ?
        <div className='flex-row h-50 rounded-3 mr-10'>
          <div className={`${data.color}1 w-200 flex-centered font-600 font-1`}>{data.teamname}</div>
          <div className={`${data.color}1 opacity-9 w-40 flex-centered font-600 font-1`}>{data.won}</div>
        </div>
        
        :
        <div className='flex-row h-50 rounded-3 ml-10'>
          <div className={`${data.color}1 opacity-9 w-40 flex-centered font-600 font-1`}>{data.won}</div>
          <div className={`${data.color}1 w-200 flex-centered font-600 font-1`}>{data.teamname}</div>
        </div>
      }
      
    </div>
  )
}

export function H2HRecordBox ({data}) {
  return (
    <div className='flex-row mt-30 bg-white h-80 flex-centered w-600 bg-shadow rounded-2'>
      <H2HRecordBoxItem data={data[0]} left={false}/>
      <H2HRecordBoxItem data={data[1]} left={true}/>
    </div>
  )
}
