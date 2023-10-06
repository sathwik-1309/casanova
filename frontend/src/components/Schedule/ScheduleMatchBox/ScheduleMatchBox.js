import React from "react";
import './ScheduleMatchBox.css'
import { FRONTEND_API_URL } from "../../../my_constants";

function Teambox(props) {
  const data = props.data
  return (
    <div className={`${data.abbrevation}1 font-600 font-1_1 schedule-teambox flex-centered`}>
      {data.name}
    </div>
  )
}

function ScheduleMatchBox(props) {
  const data = props.data
  return(
    <a className={`schedule-matchbox flex-row font-1 font-400 bg-shadow ${data.font}`} href={`${FRONTEND_API_URL}/match/${data.match_id}/1/summary`}>
      <div className="flex-col schedule-header">
        <div className="font-0_7 font-600 schedule-title">MATCH {data.order}</div>
        <div className="schedule-stage font-0_7 font-600">{data.stage}</div>
      </div>
      <Teambox data={data.squad1}/>
      <Teambox data={data.squad2}/>
      <div className="flex-centered schedule-venue">{data.venue}</div>
      <div className={`schedule-result flex-centered ${data.result_color}1`}>{data.result}</div>
    </a>
  )
}

export default ScheduleMatchBox;
