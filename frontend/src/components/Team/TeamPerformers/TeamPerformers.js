import React from "react"
import './TeamPerformers.css'
import Photocard from "../../Player/Photocard/Photocard"

function CaptainBox(props) {
  const data = props.data
  return (
      <div className={`flex-col ${props.meta.color}1 captain-box rounded-4`}>
        <div className={`font-600 font-0_7 flex-centered pt-3 ${props.meta.color}2`}>CAPTAIN</div>
        <div className='flex-row'>
          <Photocard p_id={data.id} color={props.meta.color} height='60px'/>
          <div className='flex-centered font-1 font-600 flex-grow w-180 pr-30'> {data.fullname} </div>
        </div>
      </div>
  )
}

function PerformerBox({header, player, info, meta, label, size}) {
  let height = '60px'
  if (size){
    height = '70px'
  }
  return (
    <div className={`flex-col performer-box ${meta.color}1 rounded-4`}>
      <div className={`font-600 font-0_7 flex-centered pt-3 ${meta.color}2`}>{header}</div>
      <div className={`flex-row  font-600 font-1 flex-centered`}>
        <Photocard p_id={player.id} color={meta.color} height={height} />
        <div className='w-180 lp-10'>{player.fullname}</div>
        <div className='w-100 flex-centered'>{info} <span className='font-500 font-0_7 pt-3 pl-5'> {label}</span></div>
      </div>
    </div>
  )
}

function TeamPerformers(props) {
  const data = props.data
  console.log(data)
  return (
    <div className='flex-col bg-white bg-shadow squad-performers flex-centered'>
      <CaptainBox data={data.captain} meta={props.meta}/>
      <div className='flex-row squad-performers-rows'>
        {data.most_runs && <PerformerBox header='MOST RUNS' meta={props.meta} player={data.most_runs.player} info={data.most_runs.runs} label='RUNS' size={true}/>}
        {data.most_wickets && <PerformerBox header='MOST WICKETS' meta={props.meta} player={data.most_wickets.player} info={data.most_wickets.wickets} label='WICKETS' size={true}/>}
      </div>
      <div className='flex-row squad-performers-rows'>
        {data.best_sr && <PerformerBox header='BEST STRIKE-RATE' meta={props.meta} player={data.best_sr.player} info={data.best_sr.sr} label='SR'/>}
        {data.best_economy && <PerformerBox header='BEST ECONOMY' meta={props.meta} player={data.best_economy.player} info={data.best_economy.economy} label='RPO'/>}
      </div>
      <div className='flex-row squad-performers-rows'>
        {data.best_score && <PerformerBox header='BEST SCORE' meta={props.meta} player={data.best_score.player} info={data.best_score.best.score} label={data.best_score.best.balls}/>}
        {data.best_spell && <PerformerBox header='BEST SPELL' meta={props.meta} player={data.best_spell.player} info={data.best_spell.best.fig} label={data.best_spell.best.overs}/>}
      </div>
    </div>
  )
}

export default TeamPerformers