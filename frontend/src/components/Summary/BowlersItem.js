import './BowlersItem.css'
import '../css/teams.css'
function BowlersItem(props) {

    let class1 = "bowler_name wt20 "+ props.team + "1"
    let class2 = "bowler_fig wt20 " + props.team + "2"

    return (
        <div id="bowlers_item" onClick={() => props.func(props.spellbox)}>
           <div className={class1}>{props.name}</div>
           <div className={class2}>
                <div className="fig">
                    {props.fig}
                </div>
                <div className="overs">
                    {props.overs}
                </div>
            </div> 
        </div>
    )

    }
export default BowlersItem;