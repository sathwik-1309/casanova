import Photocard from "../../../Photocard/Photocard";
import './IPPerformers.css'

function PlayerBox(props) {
    let data = props.data
    let player_perf;
    if (props.type === 'batsman') {
        player_perf = <div className='ip_player_box_perf flex-row'>
            <div className='ip_player_box_bat_runs flex font-1 font-600'>{data.runs}</div>
            <div className='ip_player_box_bat_balls font-0_8 font-400'>{data.balls}</div>
        </div>
    }
    else {
        player_perf = <div className='ip_player_box_perf flex-row'>
            <div className='ip_player_box_bow_fig flex font-1 font-600'>{data.fig}</div>
            <div className='ip_player_box_bow_overs font-0_8 font-400'>{data.overs}</div>
        </div>
    }
    return (
        <div className={`flex-row ip_player_box flex vert-align font-0_9 b-radius-3 ${data.color}1`}>
            < Photocard p_id = {data.p_id} color={data.color} height={'48px'}/>
            <div className='ip_player_box_name'>{data.name}</div>
            {player_perf}
        </div>
    );
}

function PerformersBox(props) {
    let data = props.data
    return (
        <div className='flex-col ip_performers_box font-500'>
            <PlayerBox type='batsman' data={data.performers[0]}/>
            <PlayerBox type='bowler' data={data.performers[1]}/>
            <div className='flex-centered ip_pb_phase_score'>{data.score}</div>
            <div className='flex-centered ip_pb_phase_label'>{props.phase}</div>
        </div>
    );
}


function PerformersInningsBox(props) {
    let data = props.data
    return (
        <div className='flex-col ip_performers_innings font-600 font-1'>
            <div className={`flex-row vert-align pib_scoreline b-radius-2 ${data.color}1`}>
                <div className='pibs_teamname'>{data.teamname}</div>
                <div className='pibs_score'>{data.score}</div>
                <div className='pibs_overs font-400 font-0_8'>{data.overs}</div>
            </div>
            <div className='flex-row pib_performers_boxes'>
                <PerformersBox data={data.powerplay} phase='powerplay'/>
                <PerformersBox data={data.middle} phase='middle'/>
                <PerformersBox data={data.death} phase='death'/>
            </div>
        </div>
    );
}

function IPPerformers(props) {
    return (
        <div className='flex-col bg-white bg-shadow ip_performers'>
            <PerformersInningsBox data={props.data.inn1}/>
            <PerformersInningsBox data={props.data.inn2}/>
        </div>
    );
}

export default IPPerformers;