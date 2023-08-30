import './SummaryFooter.css'
import Photocard from "../Photocard/Photocard";

function Motm(props) {
    let motm = props.motm
    let class1 = "summary_motm "+props.color+"1"
    // let img = images[motm.pid]

    let motm_stats = "NA"
    if (motm.bat && motm.ball) {
        motm_stats =
        <div id="motm_both">
            <div id="motm_both_bat">
                <div id="motm_both_bat_runs">{motm.bat.runs}</div>
                <div id="motm_both_bat_balls">off {motm.bat.balls}</div>
            </div>
            <div id="motm_both_and">&</div>
            <div id="motm_both_ball">
                <div id="motm_both_ball_fig">{motm.ball.fig}</div>
                {/*<div id="motm_both_ball_overs">({motm.ball.overs})</div>*/}
            </div>
        </div>
    }
    else if (motm.bat) {
        motm_stats =
        <div id="motm_bat">
            <div id="motm_bat_runs">{motm.bat.runs}</div>
            <div id="motm_bat_balls">off {motm.bat.balls}</div>
        </div>

    }
    else {
        motm_stats =
        <div id="motm_ball">
            <div id="motm_ball_fig">{motm.ball.fig}</div>
            {/*<div id="motm_ball_overs">{motm.ball.overs}</div>*/}
        </div>
    }

    return (
        <div className={class1}>
            <Photocard p_id={motm.pid}/>
            <div className='mom_stats'>
                <div className='mom_stats1'>
                    {/* {props.motm_name} */}
                    Man of the match
                </div>
                <div className='mom_stats2'>
                    {motm.name}
                </div>
                {motm_stats}
            </div>
        </div>
    )
}

function SummaryFooter(props) {

    let footer = props.footer
    let class1 = "summary_footer "+footer.tour
    let class2 = "match_result "+footer.result_color+"1"

    return (
        <div className={class1}>
            <div className={class2}>
                {footer.result}
            </div>
            <Motm color={footer.result_color} motm={footer.motm}/>
        </div>
    )

    }
export default SummaryFooter;
