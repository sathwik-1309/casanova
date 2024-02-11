import React from 'react'

function RankingBox({data, meta}) {
  const color = meta.color
  return (
    <div className='flex-col bg-white bg-shadow default-font pt-10 pb-10 pl-15 pr-15 rounded-4 flex-centered'>
      <div className='flex-row'>
        <div className='flex-col mr-1 font-600 font-1_1'>
          <div className='flex-row h-50 rounded-3 mt-2'>
            <div className={`${color}1 flex-centered w-200`}>Rank</div>
            <div className={`flex-centered ${color}1 opacity-9 w-80`}>{data.rank}</div>
          </div>
          <div className='flex-row h-50 rounded-3 mt-2'>
            <div className={`${color}1 flex-centered w-200`}>Rating</div>
            <div className={`flex-centered ${color}1 opacity-9 w-80`}>{data.rating}</div>
          </div>
        </div>

        <div className='flex-col ml-1 font-500 font-1'>
          <div className='flex-row h-50 rounded-3 mt-2'>
            <div className={`${color}1 flex-centered w-150`}>Best Rank</div>
            <div className={`flex-centered ${color}1 opacity-9 w-50`}>{data.best_rank}</div>
          </div>
          
          <div className='flex-row h-50 rounded-3 mt-2'>
            <div className={`${color}1 flex-centered w-150`}>Best Rating</div>
            <div className={`flex-centered ${color}1 opacity-9 w-50`}>{data.best_rating}</div>
          </div>
        </div>
        
      </div>

      <div className='flex-row h-50 rounded-4 mt-2 font-500 font-1'>
        <div className={`${color}1 flex-centered w-200`}>Best Rank Match</div>
        <div className={`flex-centered ${color}1 opacity-9 w-60`}>{data.best_rank_match}</div>
      </div>
    </div>
    
  )
}

export default RankingBox