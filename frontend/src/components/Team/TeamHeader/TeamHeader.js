import React from "react"
import './TeamHeader.css'

function TeamHeader(props) {
  return(
    <div className={`flex-col font-1_2 font-600 w-400 flex-centered bg-shadow squad-header ${props.data.color}1`}>
        <div className='squad-header-line1 flex-centered'>{props.data.teamname}</div>
        <div className='font-400 font-0_8 squad-header-line2'>{props.label ? props.label : props.data.tour}</div>
      </div>
  )
}

export default TeamHeader