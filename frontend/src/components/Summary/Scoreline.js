import './Scoreline.css'
import '../css/teams.css'

function Scoreline(props) {

    let class2 = "summary_score " + props.team +"2"
    let class1 = "summary_teamname " + props.team +"1"

    return (
        
        <div id="summary_scoreline">
            <div className={class1}>
                {props.teamname.toUpperCase()}
            </div>
            <div className={class2}>
                <div id="final_score">{props.score}</div>
                <div id="final_overs"> {props.overs}</div>
            </div>
        </div>
    )

    }
export default Scoreline;