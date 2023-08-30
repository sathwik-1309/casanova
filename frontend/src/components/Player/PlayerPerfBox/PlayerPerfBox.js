import './PlayerPerfBox.css'
import Scorebox from "../../Scorebox/Scorebox";
import SpellBox from "../../SpellBox/SpellBox";

function Perfbox1(props) {
    let data = props.data
    let data1, data2, width1, width2;
    if (props.type === 'scores') {
        data1 = data.batted? data.score : 'DNB'
        data2 = data.balls
        width1 = 'w-60'
        width2 = 'w-40'
    }
    else {
        data1 = data.fig
        data2 = data.overs
        width1 = 'w-75'
        width2 = 'w-25'
    }
    return (
        <div className='player_perf_box flex-col h-80 fit-content bg-shadow font-500'>
            <div className='player_perf_box_row1 flex-row h-40'>
                <div className={`ppb_row1_label w-150 font-0_9 ${data.color}1 flex vert-align lp-10`}>{data.name}</div>
                <div className={`ppb_row1_data1 ${width1} font-1 font-600 ${data.color}2 flex vert-align`}>{data1}</div>
                <div className={`ppb_row1_data2 ${width2} font-0_8 font-400 ${data.color}2 flex vert-align`}>{data2}</div>
            </div>
            <div className={`player_perf_box_row2 flex-row h-40 ${data.color}1 font-0_8`}>
                <div className={`player_perf_box_vs_team w-100 flex vert-align lp-10`}>vs {data.vs_team}</div>
                <div className={`player_perf_box_venue w-150 flex vert-align`}>at {data.venue}</div>
            </div>
        </div>
    );
}

function PlayerPerfBox(props) {
    let perfbox = <Perfbox1 data={props.data} type={props.type}/>
    switch (props.sub_type) {
        case "1":
            perfbox = <Perfbox1 data={props.data} type={props.type}/>
            break;
        case "2":
            perfbox = props.type === 'scores'? <Scorebox data={props.data} detailed={true}/> : <SpellBox data={props.data} detailed={true}/>
            break;
        default:
            break;
    }
    return (
        <>
        {perfbox}
        </>
    );

}

export default PlayerPerfBox
