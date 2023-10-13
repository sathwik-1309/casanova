import React from 'react'
import { FRONTEND_API_URL } from '../../../../my_constants'
import { Link } from 'react-router-dom'
import './ScheduleMatchBox2.css'

function ScheduleMatchBox2(props) {
  const data = props.data
  console.log(data)
  return (
    <Link to={`${FRONTEND_API_URL}/match/${data.match_id}/1/summary`} className='schedule-box-container flex-row bg-white bg-shadow default-font font-1 font-600'>
      <div className='w-100'><span className='w-10 font-0_8 font-400'>vs</span> {data.squad2.abbrevation}</div>
      <div className='w-120 font-500 font-0_8'>{data.venue.toUpperCase()}</div>
      <div className='w-60'>
      {
        data.squad1.result &&
        <div className={`schedule-result-box w-60 font-0_8 font-600 ${data.squad1.result == 'won' ? 'bg-green' : 'bg-red'}`}>{data.squad1.result.toUpperCase()}</div>
      }
      </div>
      
    </Link>
  )
}

export default ScheduleMatchBox2