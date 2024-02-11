import './Scoreline.css'

function Scoreline(props) {
    return (
        <div id="summary_scoreline" className='bg-shadow'>
            <div className={`summary_teamname ${props.team}1`}>
                {props.teamname.toUpperCase()}
            </div>
            <div className={`summary_score ${props.team}2`}>
                <div id="final_score">{props.score}</div>
                <div id="final_overs"> {props.overs}</div>
            </div>
        </div>
    )
    }
export default Scoreline;
