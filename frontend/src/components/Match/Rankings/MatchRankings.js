import React, { useState, useEffect } from 'react'
import { useParams } from 'react-router-dom'
import { PlayerMatchRankings } from './PlayerMatchRankings'
import { BACKEND_API_URL } from '../../../my_constants';


export function MatchRankings({match_id}) {
  const [rankType, setRankType] = useState('player')
  return (
    <div className='flex-col default-font flex-centered'>
      <div className='flex-row w-300 wrap gap-50 flex-centered h-70 bg-white bg-shadow rounded-4'>
        <div className={`h-30 w-80 flex-centered font-600 font-0_8 rounded-4 ${rankType == 'player' ? 'display_select' : 'display_unselect'}`} onClick={()=>{setRankType('player')}}>PLAYER</div>
        <div className={`h-30 w-80 flex-centered p-5 font-600 font-0_8 rounded-4 ${rankType == 'team' ? 'display_select' : 'display_unselect'}`} onClick={()=>{setRankType('team')}}>TEAM</div>
      </div>
      <div className='mt-30'>
        {
          rankType == 'player' ?
          <PlayerMatchRankings match_id={match_id}/> :
          <></>
        }
      </div>
    </div>
  )
}
