import './Wrapper1.css'
import BatsmenBox from './BatsmenBox';
import BowlersBox from './BowlersBox';

function Wrapper1(props) {
    let bat = props.batsmen
    let ball = props.bowlers


    return (
        <div id="wrapper1">
            <BatsmenBox team={props.bat_team} batsmen={bat} tour={props.tour} func={props.func}/>
            <BowlersBox team={props.bow_team} bowlers={ball} tour={props.tour} func={props.func}/>
        </div>
    )

    }
export default Wrapper1;