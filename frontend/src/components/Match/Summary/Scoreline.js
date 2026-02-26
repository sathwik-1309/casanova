import './Scoreline.css'
import Logo from '../../Team/Logo/Logo';

function Scoreline(props) {
    return (
        <div className={`flex-row h-50 w-594 bg-shadow ${props.team}1 pl-20`}>
            <Logo team={props.logo} height={40}/>
            <div className={`pl-15 flex vert-align font-600 w-410`}>{props.teamname.toUpperCase()}</div>
            <div className={`${props.team}2 bg-shadow flex-centered w-134`}>
                <div className='font-600 w-90 flex-centered'>{props.score}</div>
                <div className='pt-3 font-400 font-0_8 w-30 flex-centered'>{props.overs}</div>
            </div>
        </div>




        // <div id="summary_scoreline" className='bg-shadow'>
        //     <div className={`summary_teamname ${props.team}1`}>{props.teamname.toUpperCase()}</div>
        //     <div className={`summary_score ${props.team}2 `}>
        //         <div id="final_score">{props.score}</div>
        //         <div id="final_overs"> {props.overs}</div>
        //     </div>
        // </div>
    )
}
export default Scoreline;
