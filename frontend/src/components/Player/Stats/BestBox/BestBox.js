import './BestBox.css'

function BestBox(props) {
    if (!props.data) {
        console.log("no spell")
        return <></>
    }
    let data = props.data
    let data1, data2, label, width1, width2;
    if (props.type === 'score') {
        data1 = data.score
        data2 = data.balls
        label = 'Best Score'
        width1 = 'w-60'
        width2 = 'w-40'
    }
    else {
        data1 = data.fig
        data2 = data.overs
        label = 'Best Spell'
        width1 = 'w-75'
        width2 = 'w-25'
    }
    return (
        <div className='best_box flex-col h-80'>
            <div className='best_box_row1 flex-row h-40'>
                <div className={`bb_row1_label w-150 font-0_9 ${data.color}1 flex vert-align lp-10`}>{label}</div>
                <div className={`bb_row1_data1 ${width1} font-1 font-600 ${data.color}2 flex vert-align`}>{data1}</div>
                <div className={`bb_row1_data2 ${width2} font-0_8 font-400 ${data.color}2 flex vert-align`}>{data2}</div>
            </div>
            <div className={`best_box_row2 flex-row ${data.color}1 h-40 font-0_8`}>
                <div className='best_box_vs_team w-100 flex vert-align lp-10'>vs {data.vs_team}</div>
                <div className='best_box_venue w-150 flex vert-align'>at {data.venue}</div>
            </div>
        </div>
    );
}

export default BestBox
