import './BestBox.css'
import {FRONTEND_API_URL} from "../../../../my_constants";

function BestBox(props) {
    if (!props.data) {
        return <></>
    }
    let data = props.data
    let data1, data2, label, width1, width2;
    if (props.type === 'score') {
        data1 = data.score
        data2 = data.balls
        label = 'Best Score'
        width1 = 'w-55'
        width2 = 'w-35'
    }
    else {
        data1 = data.fig
        data2 = data.overs
        label = 'Best Spell'
        width1 = 'w-70'
        width2 = 'w-20'
    }
    return (
        <div className='best_box flex-col h-70'>
            <div className='best_box_row1 flex-row h-35'>
                <div className={`bb_row1_label w-140 font-0_9 ${data.color}1 flex vert-align lp-10`}>{label}</div>
                <div className={`bb_row1_data1 ${width1} font-1 font-600 ${data.color}2 flex vert-align`}>{data1}</div>
                <div className={`bb_row1_data2 ${width2} font-0_8 font-400 ${data.color}2 flex vert-align`}>{data2}</div>
            </div>
            <a className={`best_box_row2 flex-row ${data.color}1 h-35 font-0_8`} href={`${FRONTEND_API_URL}/match/${data.match_id}/1/summary`}>
                <div className='best_box_vs_team w-90 flex vert-align lp-10'>vs {data.vs_team}</div>
                <div className='best_box_venue w-140 flex vert-align'>at {data.venue}</div>
            </a>
        </div>
    );
}

export default BestBox
