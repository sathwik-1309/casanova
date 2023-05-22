import BatStats from "../BatStats/BatStats";
import BallStats from "../BallStats/BallStats";
import './Stats.css'

function Stats(props) {
    return (
        <div className='tournament_stats'>
            <div className='tournament_bat_stats_window'><BatStats t_id={props.t_id}/></div>
            <div className='tournament_ball_stats_window'><BallStats t_id={props.t_id}/></div>
        </div>
    )
}

export default Stats;