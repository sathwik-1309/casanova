import './BatsmenItem.css'
import {useState} from "react";

function BatsmenItem(props) {

    let class1 = "summary_batsman_playername "+ props.team + "1"
    let class2 = "summary_batsman_score " + props.team + "2"
    // let character = props.runs.charAt(props.runs.length)
    const [selected, setSelected] = useState("career");

    return (
        <div onClick={() => props.func(props.scorebox)} id="summary_batsmen_item" className='bg-shadow mt-1'>
           <div className={class1}>{props.name}</div>
           <div className={class2}>
                <div id="summary_batsman_score_runs">
                    {props.runs}
                </div>
               <div id="summary_batsman_score_notout">{props.notout}</div>
                <div id="summary_batsman_score_balls">
                    {props.balls}
                </div>
            </div>
        </div>
    )

    }
export default BatsmenItem;
