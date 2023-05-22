import './SummaryInnings.css'
import Scoreline from './Scoreline';
import Wrapper1 from './Wrapper1';

function SummaryInnings(props) {
    console.log(props)
    let inn = props.inn
    let tour = props.tour

    
    return (
        <div className="summary_innings">
            <Scoreline team={inn.bat_team} score={inn.score} overs={inn.overs} tour={tour} teamname={inn.teamname}/>
            <Wrapper1 batsmen={inn.bat} bowlers={inn.ball} bat_team={inn.bat_team} bow_team={inn.bow_team} tour={tour} func={props.func}/>
        </div>
    )

    }
export default SummaryInnings;