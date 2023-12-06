import MatchBox from "../../Match/MatchBox/MatchBox";
import Photocard from "../../Player/Photocard/Photocard";


export function MatchBoxDeatailed({data}){
  return (
    <div className='flex-col default-font flex-centered'>
      <MatchBox data={data.match_box}/>
      <div className='flex-col flex-centered h2hborder rounded-4 bg-dark c-white'>
        <div className={`${data.winner.color}1 opacity-9 font-0_7 font-600 w-180 flex-centered`}>WINNER</div>
        <div className={`${data.winner.color}1 h-50 flex-centered w-180 font-0_9 font-600`}>{data.winner.teamname}</div>
      </div>
      <div className='flex-col flex-centered h2hborder rounded-4 bg-dark c-white'>
        <div className={`font-0_7 font-600 ${data.motm.color}1 opacity-9 flex-centered w-180`}>MOTM ⭐️</div>
        <div className={`flex-row ${data.motm.color}1 h-50 w-180 font-0_9 font-600`}>
          <Photocard p_id={data.motm.id} height='50px'/>
          <div className={`flex-centered lp-10`}>{data.motm.name}</div>
        </div>
        
      </div>
    </div>
  )
}